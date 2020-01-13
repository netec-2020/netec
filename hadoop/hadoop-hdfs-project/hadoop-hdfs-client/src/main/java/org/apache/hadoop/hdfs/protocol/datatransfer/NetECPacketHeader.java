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
package org.apache.hadoop.hdfs.protocol.datatransfer;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Arrays;

import org.apache.hadoop.classification.InterfaceAudience;
import org.apache.hadoop.classification.InterfaceStability;
import org.apache.hadoop.hdfs.util.ByteBufferOutputStream;
import org.apache.hadoop.hdfs.util.ByteUtils;

import com.google.common.base.Preconditions;
import com.google.common.primitives.Shorts;
import com.google.common.primitives.Ints;
import com.google.protobuf.InvalidProtocolBufferException;

/**
 * Header data for each packet that goes through the NetEC READ pipelines.
 * Includes all of the information about the packet, excluding checksums and
 * actual data.
 *
 * This data includes:
 *  - the offset in bytes into the HDFS block of the data in this packet
 *  - the sequence number of this packet in the pipeline
 *  - whether or not this is the last packet in the pipeline
 *  - the length of the data in this packet
 *
 */
@InterfaceAudience.Private
@InterfaceStability.Evolving
public class NetECPacketHeader {

  private int packetLen;
  /* header */
  // private long offsetInBlock;
  private long seqno;
  // private boolean lastPacketInBlock;
  // private int dataLen;

  public static final int HEADER_LENGTH =
    Long.BYTES/* + Long.BYTES + 1 + Integer.BYTES*/;

  public static final int PACKET_SIZE = 128;
  public static final int DATA_SIZE = PACKET_SIZE - HEADER_LENGTH;

  public NetECPacketHeader() {
  }

  public NetECPacketHeader(/*long offsetInBlock, */long seqno/*,
                       boolean lastPacketInBlock, int dataLen */) {
    // this.offsetInBlock = offsetInBlock;
    this.seqno = seqno;
    // this.lastPacketInBlock = lastPacketInBlock;
    // this.dataLen = dataLen;
  }

  public int getDataLen() {
    return DATA_SIZE;
  }

  // public boolean isLastPacketInBlock() {
  //   return this.isLastPacketInBlock();
  // }

  public long getSeqno() {
    return this.seqno;
  }

  public long getOffsetInBlock() {
    return DATA_SIZE * seqno;
  }


  @Override
  public String toString() {
    return "PacketHeader with packetLen=" + this.packetLen +
      " header data:" +
      // "\n\tOffsetInBlock: " + this.offsetInBlock +
      "\n\tSeqno: " + this.seqno
      // "\n\tLastPacketInBlock: " + this.lastPacketInBlock +
      // "\n\tDataLen: " + this.dataLen
      ;
  }

  public void setFieldsFromData(byte[] headerData) {
    int bufPos = 0;
    // /* offsetInBlock */
    // offsetInBlock = ByteUtils.bytes2Long(
    //   Arrays.copyOfRange(headerData, bufPos, bufPos + Long.BYTES));
    // bufPos += Long.BYTES;
    /* seqno */
    seqno = ByteUtils.bytes2Long(
      Arrays.copyOfRange(headerData, bufPos, bufPos + Long.BYTES));
    bufPos += Long.BYTES;
    // /* lastPacketInBlock */
    // lastPacketInBlock = ByteUtils.byte2Boolean(headerData[bufPos]);
    // bufPos += 1;
    // /* dataLen */
    // dataLen = ByteUtils.bytes2Int(
    //   Arrays.copyOfRange(headerData, bufPos, bufPos + Integer.BYTES));
  }

  public void readFields(DataInputStream in) throws IOException {
    byte[] data = new byte[HEADER_LENGTH];
    in.readFully(data);
    setFieldsFromData(data);
  }

  public byte[] getBytes() {
    /* Write all data into buffer */
    byte[] buf = new byte[HEADER_LENGTH];
    int bufPos = 0;
    // /* offsetInBlock */
    // /* arraycopy(src, srcPos, dest, destPos, length) */
    // System.arraycopy(ByteUtils.long2Bytes(offsetInBlock), 0,
    //   buf, bufPos, Long.BYTES);
    // bufPos += Long.BYTES;
    /* seqno */
    System.arraycopy(ByteUtils.long2Bytes(seqno), 0,
      buf, bufPos, Long.BYTES);
    bufPos += Long.BYTES;
    // /* lastPacketInBlock */
    // System.arraycopy(ByteUtils.boolean2Bytes(lastPacketInBlock), 0,
    //   buf, bufPos, 1);
    // bufPos += 1;
    // /* dataLen */
    // System.arraycopy(ByteUtils.int2Bytes(dataLen), 0,
    //   buf, bufPos, Integer.BYTES);
    return buf;
  }


  /**
   * Write the header into the buffer.
   * This requires that PKT_HEADER_LEN bytes are available.
   */
  public void putInBuffer(final ByteBuffer buf, final int index) {
    buf.put(getBytes());
  }

  public void write(DataOutputStream out) throws IOException {
    out.write(getBytes());
  }


  /**
   * Perform a sanity check on the packet, returning true if it is sane.
   * @param lastSeqNo the previous sequence number received - we expect the
   *                  current sequence number to be larger by 1.
   */
  public boolean sanityCheck(long lastSeqNo) {
    // We should only have a non-positive data length for the last packet
    // if (dataLen <= 0 && !lastPacketInBlock) return false;
    // The last packet should not contain data
    // if (lastPacketInBlock && dataLen != 0) return false;
    // Seqnos should always increase by 1 with each packet received
    return seqno == lastSeqNo + 1;
  }

  @Override
  public boolean equals(Object o) {
    if (!(o instanceof NetECPacketHeader)) return false;
    NetECPacketHeader other = (NetECPacketHeader)o;
    return (
      /* offsetInBlock == other.getOffsetInBlock() && */
      seqno == other.getSeqno()/* &&
      lastPacketInBlock == other.isLastPacketInBlock() &&
      dataLen == other.getDataLen() */
    );
  }

  @Override
  public int hashCode() {
    return (int)seqno;
  }
}
