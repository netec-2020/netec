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
package org.apache.hadoop.hdfs.server.datanode;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.Arrays;

import org.apache.commons.logging.Log;
import org.apache.hadoop.fs.ChecksumException;
import org.apache.hadoop.hdfs.DFSUtilClient;
import org.apache.hadoop.hdfs.HdfsConfiguration;
import org.apache.hadoop.hdfs.protocol.Block;
import org.apache.hadoop.hdfs.protocol.ExtendedBlock;
import org.apache.hadoop.hdfs.protocol.datatransfer.NetECPacketHeader;
import org.apache.hadoop.hdfs.protocol.datatransfer.PacketHeader;
import org.apache.hadoop.hdfs.server.common.HdfsServerConstants.ReplicaState;
import org.apache.hadoop.hdfs.server.datanode.fsdataset.FsVolumeReference;
import org.apache.hadoop.hdfs.server.datanode.fsdataset.LengthInputStream;
import org.apache.hadoop.hdfs.server.datanode.fsdataset.ReplicaInputStreams;
import org.apache.hadoop.hdfs.util.DataTransferThrottler;
import org.apache.hadoop.io.IOUtils;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.ReadaheadPool.ReadaheadRequest;
import org.apache.hadoop.net.SocketOutputStream;
import org.apache.hadoop.util.AutoCloseableLock;
import org.apache.hadoop.util.DataChecksum;
import org.apache.htrace.core.TraceScope;
import org.jboss.netty.handler.codec.replay.VoidEnum;

import static org.apache.hadoop.io.nativeio.NativeIO.POSIX.POSIX_FADV_DONTNEED;
import static org.apache.hadoop.io.nativeio.NativeIO.POSIX.POSIX_FADV_SEQUENTIAL;

import com.google.common.annotations.VisibleForTesting;
import com.google.common.base.Preconditions;
import org.slf4j.Logger;

/**
 * Reads a block from the disk and sends it to a recipient.
 *
 * Data sent from the BlockeSender in the following format:
 * <br><b>Data format:</b> <pre>
 *
 */
class NetECBlockSender implements java.io.Closeable {
  static final Logger LOG = DataNode.LOG;
  static final Log ClientTraceLog = DataNode.ClientTraceLog;
  private static final boolean is32Bit =
      System.getProperty("sun.arch.data.model").equals("32");
  private static final int IO_FILE_BUFFER_SIZE;
  static {
    HdfsConfiguration conf = new HdfsConfiguration();
    IO_FILE_BUFFER_SIZE = DFSUtilClient.getIoFileBufferSize(conf);
  }

  /** the block to read from */
  private final ExtendedBlock block;

  private static final int PACKET_SIZE = NetECPacketHeader.PACKET_SIZE;
  private static final int PACKET_AT_A_TIME = 100;

  /** InputStreams and file descriptors to read block/checksum. */
  private ReplicaInputStreams ris;
  /** updated while using transferTo() */
  private long blockInPosition = -1;
  /** Initial position to read */
  private long initialOffset;
  /** Current position of read */
  private long offset;
  /** Position of last byte to read from block file */
  private final long endOffset;
  /** Bytes that we need to send out */
  private final long sendLength;
  /** Number of bytes in chunk used for computing checksum */
  private final int chunkSize = PACKET_SIZE - NetECPacketHeader.HEADER_LENGTH;
  /** Sequence number of packet being sent */
  private long seqno;
  /** Set to true once entire requested byte range has been sent to the client */
  private boolean sentEntireByteRange;
  /** Format used to print client trace log messages */
  private final String clientTraceFmt;
  private DataNode datanode;

  /** The replica of the block that is being read. */
  private final Replica replica;


  private long lastCacheDropOffset;
  private final FileIoProvider fileIoProvider;

  @VisibleForTesting
  static long CACHE_DROP_INTERVAL_BYTES = 1024 * 1024; // 1MB

  /**
   * See {{@link BlockSender#isLongRead()}
   */
  private static final long LONG_READ_THRESHOLD_BYTES = 256 * 1024;

  // The number of bytes per checksum here determines the alignment
  // of reads: we always start reading at a checksum chunk boundary,
  // even if the checksum type is NULL. So, choosing too big of a value
  // would risk sending too much unnecessary data. 512 (1 disk sector)
  // is likely to result in minimal extra IO.
  private static final long CHUNK_SIZE = 174;
  /**
   * Constructor
   *
   * @param block Block that is being read
   * @param startOffset starting offset to read from
   * @param length length of data to read
   * @param datanode datanode from which the block is being read
   * @param clientTraceFmt format string used to print client trace logs
   * @throws IOException
   */
  NetECBlockSender(ExtendedBlock block, long startOffset, long length,
              DataNode datanode, String clientTraceFmt)
      throws IOException {
    InputStream blockIn = null;
    DataInputStream checksumIn = null;
    FsVolumeReference volumeRef = null;
    this.fileIoProvider = datanode.getFileIoProvider();
    try {
      this.block = block;
      this.clientTraceFmt = clientTraceFmt;
      this.datanode = datanode;

      final long replicaVisibleLength;
      try(AutoCloseableLock lock = datanode.data.acquireDatasetLock()) {
        replica = getReplica(block, datanode);
        replicaVisibleLength = replica.getVisibleLength();
      }

      if (replica.getGenerationStamp() < block.getGenerationStamp()) {
        throw new IOException("Replica gen stamp < block genstamp, block="
            + block + ", replica=" + replica);
      } else if (replica.getGenerationStamp() > block.getGenerationStamp()) {
        if (DataNode.LOG.isDebugEnabled()) {
          DataNode.LOG.debug("Bumping up the client provided"
              + " block's genstamp to latest " + replica.getGenerationStamp()
              + " for block " + block);
        }
        block.setGenerationStamp(replica.getGenerationStamp());
      }
      if (replicaVisibleLength < 0) {
        throw new IOException("Replica is not readable, block="
            + block + ", replica=" + replica);
      }
      if (DataNode.LOG.isDebugEnabled()) {
        DataNode.LOG.debug("block=" + block + ", replica=" + replica);
      }

      // Obtain a reference before reading data
      volumeRef = datanode.data.getVolume(block).obtainReference();

      length = length < 0 ? replicaVisibleLength : length;
      sendLength = length;

      // end is either last byte on disk or the length for which we have a
      // checksum
      long end = replica.getBytesOnDisk();
      // if (startOffset < 0 || startOffset > end
      //     || (length + startOffset) > end) {
      //   String msg = " Offset " + startOffset + " and length " + length
      //   + " don't match block " + block + " ( blockLen " + end + " )";
      //   LOG.warn(datanode.getDNRegistrationForBP(block.getBlockPoolId()) +
      //       ":sendBlock() : " + msg);
      //   throw new IOException(msg);
      // }

      // Ensure read offset is position at the beginning of chunk
      offset = startOffset - (startOffset % chunkSize);
      if (length >= 0) {
        // Ensure endOffset points to end of chunk.
        long tmpLen = startOffset + length;
        if (tmpLen % chunkSize != 0) {
          tmpLen += (chunkSize - tmpLen % chunkSize);
        }
        if (tmpLen < end) {
          // will use on-disk checksum here since the end is a stable chunk
          end = tmpLen;
        }
      }
      endOffset = end;

      seqno = 0;

      if (DataNode.LOG.isDebugEnabled()) {
        DataNode.LOG.debug("replica=" + replica);
      }
      blockIn = datanode.data.getBlockInputStream(block, offset); // seek to offset
      ris = new ReplicaInputStreams(
          blockIn, checksumIn, volumeRef, fileIoProvider);
    } catch (IOException ioe) {
      IOUtils.closeStream(this);
      org.apache.commons.io.IOUtils.closeQuietly(blockIn);
      org.apache.commons.io.IOUtils.closeQuietly(checksumIn);
      throw ioe;
    }
  }

  /**
   * close opened files.
   */
  @Override
  public void close() throws IOException {
    try {
      ris.closeStreams();
    } finally {
      IOUtils.closeStream(ris);
      ris = null;
    }
  }

  private static Replica getReplica(ExtendedBlock block, DataNode datanode)
      throws ReplicaNotFoundException {
    Replica replica = datanode.data.getReplica(block.getBlockPoolId(),
        block.getBlockId());
    if (replica == null) {
      throw new ReplicaNotFoundException(block);
    }
    return replica;
  }

  /**
   * Converts an IOExcpetion (not subclasses) to SocketException.
   * This is typically done to indicate to upper layers that the error
   * was a socket error rather than often more serious exceptions like
   * disk errors.
   */
  private static IOException ioeToSocketException(IOException ioe) {
    if (ioe.getClass().equals(IOException.class)) {
      // "se" could be a new class in stead of SocketException.
      IOException se = new SocketException("Original Exception : " + ioe);
      se.initCause(ioe);
      /* Change the stacktrace so that original trace is not truncated
       * when printed.*/
      se.setStackTrace(ioe.getStackTrace());
      return se;
    }
    // otherwise just return the same exception.
    return ioe;
  }

  /**
   * @param datalen Length of data
   * @return number of chunks for data of given size
   */
  private int numberOfChunks(long datalen) {
    return (int) ((datalen + chunkSize - 1)/chunkSize);
  }

  /**
   * Sends PACKET_AT_A_TIME packets with PACKET_SIZE - HEADER_LENGTH bytes of data each.
   *
   * @param pkt buffer used for writing packet data
   * @param out stream to send data to
   * @param throttler used for throttling data transfer bandwidth
   */
  private int sendPackets(ByteBuffer pkt, OutputStream out, int packetAtATime,
  DataTransferThrottler throttler) throws IOException {

    int packetLen = PACKET_SIZE;
    int headerLen = NetECPacketHeader.HEADER_LENGTH;
    int dataLen = packetLen - headerLen;

    int dataSent = 0;

    pkt.clear();
    byte[] buf = pkt.array();

    for (int i = 0;i < packetAtATime;i++) {
      boolean lastPacket;
      if (offset < sendLength)
        lastPacket = false;
      else
        lastPacket = true;
      /** write header into buffer */
      writePacketHeader(pkt, dataLen, packetLen * i, lastPacket);
      if (lastPacket) {
        /* stop writing data and send them all */
        pkt.limit(packetLen * (i + 1));
        break;
      } else {
        if (offset < endOffset){
          /** write data into buffer */
          LOG.info("NetECBlockSender: offset is " + offset + ", endOffset is " + endOffset + ", readLength is " + sendLength);
          try{
            ris.readDataFully(buf, i * packetLen + headerLen, dataLen);
            offset += dataLen;
            dataSent += dataLen;
          } catch (IOException e){
            dataSent += endOffset - offset;
            offset = endOffset;
            LOG.info("\nNetECBlockSender: all data sent\n");
            LOG.error(e.toString());
          }
        } else {
          /** send no data */
          offset += dataLen;
        }
        seqno++;
      }
    }



    try {
      // normal transfer
      out.write(buf);
    } catch (IOException e) {
      if (e instanceof SocketTimeoutException) {
        /*
         * writing to client timed out.  This happens if the client reads
         * part of a block and then decides not to read the rest (but leaves
         * the socket open).
         *
         * Reporting of this case is done in DataXceiver#run
         */
      } else {
        /* Exception while writing to the client. Connection closure from
         * the other end is mostly the case and we do not care much about
         * it. But other things can go wrong, especially in transferTo(),
         * which we do not want to ignore.
         *
         * The message parsing below should not be considered as a good
         * coding example. NEVER do it to drive a program logic. NEVER.
         * It was done here because the NIO throws an IOException for EPIPE.
         */
        String ioem = e.getMessage();
        if (!ioem.startsWith("Broken pipe") && !ioem.startsWith("Connection reset")) {
          LOG.error("BlockSender.sendChunks() exception: ", e);
          datanode.getBlockScanner().markSuspectBlock(
              ris.getVolumeRef().getVolume().getStorageID(),
              block);
        }
      }
      throw ioeToSocketException(e);
    }

    if (throttler != null) { // rebalancing so throttle
      throttler.throttle(packetLen);
    }

    return dataSent;
  }



  /**
   * sendBlock() is used to read block and its metadata and stream the data to
   * either a client or to another datanode.
   *
   * @param out  stream to which the block is written to
   * @param throttler for sending data.
   * @return total bytes read, including checksum data.
   */
  long sendBlock(DataOutputStream out, DataTransferThrottler throttler)
    throws IOException {
    final TraceScope scope = datanode.getTracer().
        newScope("sendBlock_" + block.getBlockId());
    try {
      return doSendBlock(out, throttler);
    } finally {
      scope.close();
    }
  }

  private long doSendBlock(DataOutputStream out,
        DataTransferThrottler throttler) throws IOException {
    if (out == null) {
      throw new IOException( "out stream is null" );
    }
    initialOffset = offset;
    long totalRead = 0;

    if (isLongRead() && ris.getDataInFd() != null) {
      // Advise that this file descriptor will be accessed sequentially.
      ris.dropCacheBehindReads(block.getBlockName(), 0, 0,
          POSIX_FADV_SEQUENTIAL);
    }

    final long startTime = ClientTraceLog.isDebugEnabled() ? System.nanoTime() : 0;
    try {
      int pktBufSize = PACKET_SIZE * PACKET_AT_A_TIME;

      ByteBuffer pktBuf = ByteBuffer.allocate(pktBufSize);

      while (offset < sendLength && !Thread.currentThread().isInterrupted()) {
        long dataLen = sendPackets(pktBuf, out, PACKET_AT_A_TIME, throttler);
        totalRead += dataLen;
      }
      // If this thread was interrupted, then it did not send the full block.
      if (!Thread.currentThread().isInterrupted()) {
        try {
          // send an empty packet to mark the end of the block
          sendPackets(pktBuf, out, PACKET_AT_A_TIME, throttler);
          out.flush();
        } catch (IOException e) { //socket error
          throw ioeToSocketException(e);
        }

        sentEntireByteRange = true;
      }
    } finally {
      if ((clientTraceFmt != null) && ClientTraceLog.isDebugEnabled()) {
        final long endTime = System.nanoTime();
        ClientTraceLog.debug(String.format(clientTraceFmt, totalRead,
            initialOffset, endTime - startTime));
      }
      close();
    }
    return totalRead;
  }

  /**
   * Returns true if we have done a long enough read for this block to qualify
   * for the DataNode-wide cache management defaults.  We avoid applying the
   * cache management defaults to smaller reads because the overhead would be
   * too high.
   *
   * Note that if the client explicitly asked for dropBehind, we will do it
   * even on short reads.
   *
   * This is also used to determine when to invoke
   * posix_fadvise(POSIX_FADV_SEQUENTIAL).
   */
  private boolean isLongRead() {
    return (endOffset - initialOffset) > LONG_READ_THRESHOLD_BYTES;
  }

  /**
   * WriteVoidEnum{@code pkt},
   * return the length of the header written.
   */
  private void writePacketHeader(ByteBuffer pkt, int dataLen, int pos, boolean lastPacket) {
    // both syncBlock and syncPacket are false
    NetECPacketHeader header = new NetECPacketHeader(/*offset, */seqno/*,
    lastPacket, dataLen*/);

    pkt.position(pos);
    pkt.put(header.getBytes());
  }

  boolean didSendEntireByteRange() {
    return sentEntireByteRange;
  }
  /**
   * @return the offset into the block file where the sender is currently
   * reading.
   */
  long getOffset() {
    return offset;
  }
}
