
package org.apache.hadoop.hdfs.util;

import java.nio.ByteBuffer;
import java.nio.charset.Charset;

public class ByteUtils {

  public static byte short2Byte(short x) {
    return (byte) (x & 0xFF);
  }

  public static short byte2Short(byte b) {
    if (b >= 128)
      return -1;
    return (short) b;
  }

  public static byte[] int2Bytes(int x) {
    return ByteBuffer.allocate(Integer.BYTES).putInt(x).array();
  }

  public static int bytes2Int(byte[] bytes) {
    return ByteBuffer.wrap(bytes).getInt();
  }

  public static byte[] long2Bytes(long x) {
    return ByteBuffer.allocate(Long.BYTES).putLong(x).array();
  }

  public static long bytes2Long(byte[] bytes) {
    return ByteBuffer.wrap(bytes).getLong();
  }

  public static byte[] string2Bytes(String s) {
    return s.getBytes(Charset.forName("UTF-8"));
  }

  public static String bytes2String(byte[] bytes) {
    return new String(bytes, Charset.forName("UTF-8"));
  }

  public static byte[] boolean2Bytes(boolean b) {
      return new byte[]{ (byte)(b ? 1 : 0) };
  }

  public static boolean byte2Boolean(byte bytes) {
    return bytes == 1;
  }

}