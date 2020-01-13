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

import org.apache.hadoop.classification.InterfaceAudience;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.ChecksumException;
import org.apache.hadoop.fs.StorageType;
import org.apache.hadoop.hdfs.BlockReader;
import org.apache.hadoop.hdfs.DFSConfigKeys;
import org.apache.hadoop.hdfs.DFSUtilClient;
import org.apache.hadoop.hdfs.DFSUtilClient.CorruptedBlocks;
import org.apache.hadoop.hdfs.client.impl.NetECBlockReaderRemote;
import org.apache.hadoop.hdfs.net.Peer;
import org.apache.hadoop.hdfs.protocol.DatanodeID;
import org.apache.hadoop.hdfs.protocol.DatanodeInfo;
import org.apache.hadoop.hdfs.protocol.ExtendedBlock;
import org.apache.hadoop.hdfs.security.token.block.BlockTokenIdentifier;
import org.apache.hadoop.hdfs.server.datanode.DataNode;
import org.apache.hadoop.io.IOUtils;
import org.apache.hadoop.net.NetUtils;
import org.apache.hadoop.security.token.Token;
import org.slf4j.Logger;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.util.EnumSet;
import java.util.concurrent.Callable;

/**
 * StripedBlockReader is used to read block data from one source DN, it contains
 * a block reader, read buffer and striped block index.
 * Only allocate StripedBlockReader once for one source, and the StripedReader
 * has the same array order with sources. Typically we only need to allocate
 * minimum number (minRequiredSources) of StripedReader, and allocate
 * new for new source DN if some existing DN invalid or slow.
 * If some source DN is corrupt, set the corresponding blockReader to
 * null and will never read from it again.
 */
@InterfaceAudience.Private
class NetECStripedBlockReader {
  private static final Logger LOG = DataNode.LOG;

  private final DataNode datanode;
  private final Configuration conf;

  private NetECStripedReconstructor reconstructor;

  // private final short index; // internal block index
  // private final DatanodeInfo source;
  private final ExtendedBlock[] blocks;
  private final DatanodeInfo[] infos;
  private final long readNumBytes;
  private final InetSocketAddress switchAddress;
  private BlockReader blockReader;
  private ByteBuffer buffer;
  // private boolean isLocal;
  // Striped read buffer size
  private int bufferSize;

  NetECStripedBlockReader(NetECStripedReconstructor reconstructor,
                     DataNode datanode, Configuration conf,
                     ExtendedBlock[] blocks,
                     DatanodeInfo[] infos,
                     InetSocketAddress switchAddress) {
    this.reconstructor = reconstructor;
    this.datanode = datanode;
    this.conf = conf;
    this.blocks = blocks;
    this.infos = infos;
    this.switchAddress = switchAddress;
    long largestNumBytes = 0;
    for (ExtendedBlock block : blocks) {
      if (block.getNumBytes() > largestNumBytes)
        largestNumBytes = block.getNumBytes();
    }
    this.readNumBytes = largestNumBytes;
    // this.isLocal = false
    /* bufferSize: default 64KB */
    bufferSize = conf.getInt(
      DFSConfigKeys.DFS_DN_EC_RECONSTRUCTION_STRIPED_READ_BUFFER_SIZE_KEY,
      DFSConfigKeys.DFS_DN_EC_RECONSTRUCTION_STRIPED_READ_BUFFER_SIZE_DEFAULT);

    BlockReader tmpBlockReader = createBlockReader();
    if (tmpBlockReader != null) {
      this.blockReader = tmpBlockReader;
    }
    LOG.info("\nNetECStripedBlockReader: initialize ok\n");
  }

  ByteBuffer getReadBuffer() {
    if (buffer == null) {
      this.buffer = reconstructor.allocateBuffer(bufferSize);
    }
    return buffer;
  }

  public int getBufferSize() {
    return bufferSize;
  }

  void freeReadBuffer() {
    buffer = null;
  }

  private BlockReader createBlockReader() {
    int offsetInBlock = 0;
    Peer peer = null;
    try {
      InetSocketAddress dnAddr = switchAddress;
      peer = newConnectedPeer(dnAddr);
      return NetECBlockReaderRemote.newBlockReader(
          "dummy", blocks, infos, offsetInBlock,
          readNumBytes - offsetInBlock, "", peer, -1);
    } catch (IOException e) {
      LOG.info("Exception while creating remote block reader, datanode", e);
      IOUtils.closeStream(peer);
      return null;
    }
  }

  private Peer newConnectedPeer(InetSocketAddress addr)
      throws IOException {
    Peer peer = null;
    boolean success = false;
    Socket sock = null;
    final int socketTimeout = datanode.getDnConf().getSocketTimeout();
    try {
      sock = NetUtils.getDefaultSocketFactory(conf).createSocket();
      NetUtils.connect(sock, addr, socketTimeout);
      peer = DFSUtilClient.peerFromSocket(sock);
      success = true;
      return peer;
    } finally {
      if (!success) {
        IOUtils.cleanup(null, peer);
        IOUtils.closeSocket(sock);
      }
    }
  }

  public void read(final int length) throws IOException {
    try {
      getReadBuffer().limit(length);
      actualReadFromBlock();
      return;
    } catch (IOException e) {
      LOG.info(e.getMessage());
      throw e;
    }
  }
  // Callable<Void> readFromBlock(final int length) {
  //   return new Callable<Void>() {

  //     @Override
  //     public Void call() throws Exception {
  //       try {
  //         getReadBuffer().limit(length);
  //         actualReadFromBlock();
  //         return null;
  //       } catch (ChecksumException e) {
  //         LOG.warn("Found Checksum error ", e.getPos());
  //         throw e;
  //       } catch (IOException e) {
  //         LOG.info(e.getMessage());
  //         throw e;
  //       }
  //     }
  //   };
  // }

  /**
   * Perform actual reading of bytes from block.
   */
  private void actualReadFromBlock() throws IOException {
    int len = buffer.remaining();
    int n = 0;
    while (n < len) {
      int nread = blockReader.read(buffer);
      if (nread <= 0) {
        break;
      }
      n += nread;
      reconstructor.incrBytesRead(false, nread);
    }
  }

  // close block reader
  void closeBlockReader() {
    IOUtils.closeStream(blockReader);
    blockReader = null;
  }


  BlockReader getBlockReader() {
    return blockReader;
  }
}
