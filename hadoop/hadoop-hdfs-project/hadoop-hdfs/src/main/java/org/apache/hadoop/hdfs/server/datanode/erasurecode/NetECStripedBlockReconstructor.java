/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.hadoop.hdfs.server.datanode.erasurecode;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;

import org.apache.hadoop.classification.InterfaceAudience;
import org.apache.hadoop.hdfs.protocol.DatanodeInfo;
import org.apache.hadoop.hdfs.protocol.ExtendedBlock;
import org.apache.hadoop.hdfs.server.datanode.DataNodeFaultInjector;
import org.apache.hadoop.hdfs.server.datanode.metrics.DataNodeMetrics;
import org.apache.hadoop.util.Time;

/**
 * StripedBlockReconstructor reconstruct one or more missed striped block in
 * the striped block group, the minimum number of live striped blocks should
 * be no less than data block number.
 */
@InterfaceAudience.Private
class NetECStripedBlockReconstructor extends NetECStripedReconstructor
    implements Runnable {

  private NetECStripedBlockReader stripedBlockReader;
  // private NetECStripedBlockWriter stripedBlockWriter;
  private StripedReconstructionInfo stripedReconInfo;

  NetECStripedBlockReconstructor(ErasureCodingWorker worker,
      StripedReconstructionInfo stripedReconInfo) {
    super(worker, stripedReconInfo);

    this.stripedReconInfo = stripedReconInfo;

    // stripedWriter = new StripedWriter(this, getDatanode(),
    //     getConf(), stripedReconInfo);
    setMaxTargetLength(getBlockLen(0));
  }

  boolean hasValidTargets() {
    // TODO: fix when striped writer is ready
    return true;
  //   return stripedWriter.hasValidTargets();
  }

  @Override
  public void run() {
    try {

      initStripedBlockReader();

      // stripedWriter.init();

      reconstruct();

      // stripedWriter.endTargetBlocks();

      // Currently we don't check the acks for packets, this is similar as
      // block replication.
    } catch (Throwable e) {
      LOG.warn("Failed to reconstruct striped block: {}", getBlockGroup(), e);
      getDatanode().getMetrics().incrECFailedReconstructionTasks();
    } finally {
      getDatanode().decrementXmitsInProgress(getXmits());
      final DataNodeMetrics metrics = getDatanode().getMetrics();
      metrics.incrECReconstructionTasks();
      metrics.incrECReconstructionBytesRead(getBytesRead());
      metrics.incrECReconstructionRemoteBytesRead(getRemoteBytesRead());
      metrics.incrECReconstructionBytesWritten(getBytesWritten());
      closeStripedBlockReader();
      // stripedWriter.close();
    }
  }

  void initStripedBlockReader() {
    int dataBlkNum = stripedReconInfo.getEcPolicy().getNumDataUnits();
    int minRequiredSources = dataBlkNum;
    ExtendedBlock[] blocks = new ExtendedBlock[minRequiredSources];
    DatanodeInfo[] infos = new DatanodeInfo[minRequiredSources];

    for (int i = 0;i < minRequiredSources;i++) {
      blocks[i] = getBlock(stripedReconInfo.getLiveIndices()[i]);
      infos[i] = stripedReconInfo.getSources()[i];
    }

    InetSocketAddress switchAddress = new InetSocketAddress("10.0.0.10", 9866);

    stripedBlockReader = new NetECStripedBlockReader(this, getDatanode(), getConf(),
        blocks, infos, switchAddress);
    LOG.info("\nNetECStripedBlockReconstructor: exiting initStripedBlockReader()\n");
  }

  void closeStripedBlockReader() {
    freeBuffer(stripedBlockReader.getReadBuffer());
    stripedBlockReader.freeReadBuffer();
    stripedBlockReader.closeBlockReader();
  }

  @Override
  void reconstruct() throws IOException {
    LOG.info("\nNetECStripedBlockReconstructor: entering reconstruct()\n");
    LOG.info("\nNetECStripedBlockReconstructor: positionInBlock: " + getPositionInBlock() + ", maxTargetLength: " + getMaxTargetLength()+ "\n");
    while (getPositionInBlock() < getMaxTargetLength()) {
      DataNodeFaultInjector.get().stripedBlockReconstruction();
      long remaining = getMaxTargetLength() - getPositionInBlock();
      final int toReconstructLen =
          (int) Math.min(stripedBlockReader.getBufferSize(), remaining);

      long start = Time.monotonicNow();
      // step1: read from minimum source DNs required for reconstruction.
      // The returned success list is the source DNs we do real read from
      stripedBlockReader.read(toReconstructLen);
      long readEnd = Time.monotonicNow();

      // // step2: decode to reconstruct targets
      // reconstructTargets(toReconstructLen);
      // long decodeEnd = Time.monotonicNow();

      // step3: transfer data
      // if (stripedWriter.transferData2Targets() == 0) {
      //   String error = "Transfer failed for all targets.";
      //   throw new IOException(error);
      // }
      long writeEnd = Time.monotonicNow();

      // Only the succeed reconstructions are recorded.
      final DataNodeMetrics metrics = getDatanode().getMetrics();
      metrics.incrECReconstructionReadTime(readEnd - start);
      // metrics.incrECReconstructionWriteTime(writeEnd - readEnd);

      updatePositionInBlock(toReconstructLen);

      clearBuffers();
    }
  }

  // private void reconstructTargets(int toReconstructLen) throws IOException {
  //   ByteBuffer[] inputs = getStripedReader().getInputBuffers(toReconstructLen);

  //   int[] erasedIndices = stripedWriter.getRealTargetIndices();
  //   ByteBuffer[] outputs = stripedWriter.getRealTargetBuffers(toReconstructLen);

  //   long start = System.nanoTime();
  //   getDecoder().decode(inputs, erasedIndices, outputs);
  //   long end = System.nanoTime();
  //   this.getDatanode().getMetrics().incrECDecodingTime(end - start);

  //   stripedWriter.updateRealTargetBuffers(toReconstructLen);
  // }

  /**
   * Clear all associated buffers.
   */
  private void clearBuffers() {
    stripedBlockReader.getReadBuffer().clear();

    // stripedWriter.clearBuffers();
  }
}
