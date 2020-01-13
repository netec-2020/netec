package org.apache.hadoop.hdfs.protocol.datatransfer;

import java.nio.ByteBuffer;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;
import org.slf4j.Logger;

import org.apache.hadoop.hdfs.protocol.ExtendedBlock;
import org.apache.hadoop.hdfs.util.ByteUtils;
import org.slf4j.LoggerFactory;

/**
 * Simplified information about reading a block
 * via NetEC
 */
public class NetECReadBlockProtocol {
  /**
   * string_lens| dnIP |poolId|blkId|blkLen|genStamp|clientName|readOffset|readLen
   *  1+1+1 byte|15byte|10byte|8byte|8 byte| 8 byte | 40 byte  |  8 byte  | 8 byte
   */
  private static final Logger LOG =
  LoggerFactory.getLogger(NetECReadBlockProtocol.class);

  private final String datanodeIP;
  /* ExtendedBlock */
  private final String poolId;
  private final long blkId;
  private final long blkLen;
  private final long genStamp;

  private final String clientName;
  private final long readOffset;
  private final long readLen;
  /* byte size */
  private static final int PACKET_SIZE = 128;
  private static final int LONG_BYTE_SIZE = Long.BYTES;
  private static final int DNIP_BYTE_SIZE = 15;
  private static final int POOLID_BYTE_SIZE = 40;
  private static final int CLIENTNAME_BYTE_SIZE = 10;
  private static final int STRING_LEN = 1 * 3;
  private static final int PROTO_LEN =
    DNIP_BYTE_SIZE + POOLID_BYTE_SIZE + CLIENTNAME_BYTE_SIZE + 5 * LONG_BYTE_SIZE + STRING_LEN;
  private static final int PADDING_LEN = PACKET_SIZE - PROTO_LEN;




  public NetECReadBlockProtocol(final String datanodeIP,
    final String poolId,
    final long blkId, final long blkLen,
    final long genStamp, final String clientName,
    final long readOffset, final long readLen) {
    this.datanodeIP = datanodeIP;
    this.poolId = poolId;
    this.blkId = blkId;
    this.blkLen = blkLen;
    this.genStamp = genStamp;
    this.clientName = clientName;
    this.readOffset = readOffset;
    this.readLen = readLen;
    LOG.info("NetECReadBlockProtocol:" +
      "\ndatanodeIP: " + datanodeIP +
      "\npoolId: " + poolId +
      "\nblkId: " + blkId +
      "\nblkLen: " + blkLen +
      "\ngenStamp: " + genStamp +
      "\nclientName: " + clientName +
      "\nreadOffset: " + readOffset +
      "\nreadLen: " + readLen
    );
  }

  public static NetECReadBlockProtocol parseFrom(InputStream in, boolean firstProtoPacket) throws IOException {
    LOG.info("\nparsing... and it is " + firstProtoPacket + " that this is the first proto packet.\n");
    int packetSize = PACKET_SIZE;
    if (firstProtoPacket) {
      packetSize -= 3;
    }
    /* read all data into buffer */
    byte[] buf = new byte[packetSize];
    int byteRead = in.read(buf);
    if (byteRead != packetSize) {
      // error
      return null;
    }
    int bufPos = 0;
    /* string lengths */
    short dnIPLength, poolIdLength, clientNameLength;
    dnIPLength = ByteUtils.byte2Short(buf[bufPos++]);
    poolIdLength = ByteUtils.byte2Short(buf[bufPos++]);
    clientNameLength = ByteUtils.byte2Short(buf[bufPos++]);
    /* dnIP */
    final String pDatanodeIP = ByteUtils.bytes2String(
      Arrays.copyOfRange(buf, bufPos,
      bufPos + dnIPLength));
    bufPos += DNIP_BYTE_SIZE;
    /* poolId */
    final String pPoolId = ByteUtils.bytes2String(
      Arrays.copyOfRange(buf, bufPos,
      bufPos + poolIdLength));
    bufPos += POOLID_BYTE_SIZE;
    /* blkId */
    final long pBlkId = ByteUtils.bytes2Long(
      Arrays.copyOfRange(buf, bufPos,
      bufPos + LONG_BYTE_SIZE));
    bufPos += LONG_BYTE_SIZE;
    /* blkLen */
    final long pBlkLen = ByteUtils.bytes2Long(
      Arrays.copyOfRange(buf, bufPos,
      bufPos + LONG_BYTE_SIZE));
    bufPos += LONG_BYTE_SIZE;
    /* genStamp */
    final long pGenStamp = ByteUtils.bytes2Long(
      Arrays.copyOfRange(buf, bufPos,
      bufPos + LONG_BYTE_SIZE));
    bufPos += LONG_BYTE_SIZE;
    /* clientName */
    final String pClientName = ByteUtils.bytes2String(
      Arrays.copyOfRange(buf, bufPos,
      bufPos + clientNameLength));
    bufPos += CLIENTNAME_BYTE_SIZE;
    /* readOffset */
    final long pReadOffset = ByteUtils.bytes2Long(
      Arrays.copyOfRange(buf, bufPos,
      bufPos + LONG_BYTE_SIZE));
    bufPos += LONG_BYTE_SIZE;
    /* readLen */
    final long pReadLen = ByteUtils.bytes2Long(
      Arrays.copyOfRange(buf, bufPos,
      bufPos + LONG_BYTE_SIZE));
    bufPos += LONG_BYTE_SIZE;

    return new NetECReadBlockProtocol(pDatanodeIP, pPoolId,
      pBlkId, pBlkLen, pGenStamp, pClientName, pReadOffset, pReadLen);
  }

  private byte[] getBytes(final int size) {
    /* Write all data into buffer */
    byte[] buf = new byte[size];
    int bufPos = 0;
    /* String length * 3 */
    buf[bufPos++] = ByteUtils.short2Byte((short)datanodeIP.length());
    buf[bufPos++] = ByteUtils.short2Byte((short)poolId.length());
    buf[bufPos++] = ByteUtils.short2Byte((short)clientName.length());
    /* datanodeIP */
    /* arraycopy(src, srcPos, dest, destPos, length) */
    System.arraycopy(ByteUtils.string2Bytes(datanodeIP), 0,
      buf, bufPos, datanodeIP.length());
    bufPos += DNIP_BYTE_SIZE;
    /* poolId */
    System.arraycopy(ByteUtils.string2Bytes(poolId), 0,
      buf, bufPos, poolId.length());
    bufPos += POOLID_BYTE_SIZE;
    /* blkId */
    System.arraycopy(ByteUtils.long2Bytes(blkId), 0,
      buf, bufPos, LONG_BYTE_SIZE);
    bufPos += LONG_BYTE_SIZE;
    /* blkLen */
    System.arraycopy(ByteUtils.long2Bytes(blkLen), 0,
      buf, bufPos, LONG_BYTE_SIZE);
    bufPos += LONG_BYTE_SIZE;
    /* genStamp */
    System.arraycopy(ByteUtils.long2Bytes(genStamp), 0,
      buf, bufPos, LONG_BYTE_SIZE);
    bufPos += LONG_BYTE_SIZE;
    /* clientName */
    System.arraycopy(ByteUtils.string2Bytes(clientName), 0,
      buf, bufPos, clientName.length());
    bufPos += CLIENTNAME_BYTE_SIZE;
    /* readOffset */
    System.arraycopy(ByteUtils.long2Bytes(readOffset), 0,
      buf, bufPos, LONG_BYTE_SIZE);
    bufPos += LONG_BYTE_SIZE;
    /* readLen */
    System.arraycopy(ByteUtils.long2Bytes(readLen), 0,
      buf, bufPos, LONG_BYTE_SIZE);
    bufPos += LONG_BYTE_SIZE;

    return buf;
  }

  public void write(OutputStream out, final short protoVersion, final Op opCode) throws IOException {
    LOG.info("write:" +
      "\nprotoVersion: " + protoVersion +
      "\nopCode: " + opCode
    );
    byte[] packet = getBytes(PACKET_SIZE - 3);
    ByteBuffer buffer = ByteBuffer.allocate(PACKET_SIZE);
    buffer.putShort(protoVersion);
    buffer.put(opCode.code);
    buffer.put(packet);
    out.write(buffer.array());
  }

  public void write(OutputStream out) throws IOException {
    LOG.info("\nWriting NetECReadBlockProtocol to outputstream");
    byte[] buf = getBytes(PACKET_SIZE);
    /* write out */
    out.write(buf);
  }

  public String getDatanodeIP() {
    return this.datanodeIP;
  }

  public ExtendedBlock getBlock() {
    return new ExtendedBlock(poolId, blkId, blkLen, genStamp);
  }

  public String getClientName() {
    return this.clientName;
  }
  public long getReadOffset() {
    return this.readOffset;
  }
  public long getReadLen() {
    return this.readLen;
  }
}