package com.keyware.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.swing.JFileChooser;

/**
 * 
 * 此类描述的是：   	文件加密/解密
 * @author: 赵亚舟   
 * @version: 2016年6月22日 下午3:40:25
 */
public class fileencrypter {
	
	public static void main(String args[]) {  
        fileencrypter da = new fileencrypter();  
        String pass = "123456";  
        String pass1 = pass.substring(0, 2);  
        String pass2 = pass.substring(2, 4);  
        String pass3 = pass.substring(4);  
        System.out.println(pass1);  
        System.out.println(pass2);  
        System.out.println(pass3);  
        String name = "D:/jiaMiHouTestJiaMi.doc";  
       // if (scan.next().equals("en"))  
           // da.encrypt(new File(name), da.md5s(pass1) + da.md5s(pass2)  
            //        + da.md5s(pass3));  
       // else  
            da.decrypt(new File(name), da.md5s(pass1) + da.md5s(pass2)  
                    + da.md5s(pass3));  
    } 
	
	
	
	/** 
     * 加密函数 输入： 要加密的文件，密码（由0-F组成，共48个字符，表示3个8位的密码）如： 
     * AD67EA2F3BE6E5ADD368DFE03120B5DF92A8FD8FEC2F0746 其中： AD67EA2F3BE6E5AD 
     * DES密码一 D368DFE03120B5DF DES密码二 92A8FD8FEC2F0746 DES密码三 输出： 
     * 对输入的文件加密后，保存到同一文件夹下增加了".tdes"扩展名的文件中。 
     */  
    private void encrypt(File fileIn, String sKey) {  
        try {  
            if (sKey.length() == 48) {  
                byte[] bytK1 = getKeyByStr(sKey.substring(0, 16));  
                byte[] bytK2 = getKeyByStr(sKey.substring(16, 32));  
                byte[] bytK3 = getKeyByStr(sKey.substring(32, 48));  
  
                FileInputStream fis = new FileInputStream(fileIn);  
                byte[] bytIn = new byte[(int) fileIn.length()];  
                for (int i = 0; i < fileIn.length(); i++) {  
                    bytIn[i] = (byte) fis.read();  
                }  
                // 加密  
                byte[] bytOut = encryptByDES(encryptByDES(encryptByDES(bytIn,  
                        bytK1), bytK2), bytK3);  
                String fileOut = "D:/jiaMiHouTestJiaMi.doc";  
                FileOutputStream fos = new FileOutputStream(fileOut);  
                for (int i = 0; i < bytOut.length; i++) {  
                    fos.write((int) bytOut[i]);  
                }  
                fos.close();  
            } else  
                ;  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }  
  
    /** 
     * 解密函数 输入： 要解密的文件，密码（由0-F组成，共48个字符，表示3个8位的密码）如： 
     * AD67EA2F3BE6E5ADD368DFE03120B5DF92A8FD8FEC2F0746 其中： AD67EA2F3BE6E5AD 
     * DES密码一 D368DFE03120B5DF DES密码二 92A8FD8FEC2F0746 DES密码三 输出： 
     * 对输入的文件解密后，保存到用户指定的文件中。 
     */  
    private void decrypt(File fileIn, String sKey) {  
        try {  
            if (sKey.length() == 48) {  
                String strPath = fileIn.getPath();  
                strPath = strPath.substring(0, strPath.length() - 5);  
                JFileChooser chooser = new JFileChooser();  
                chooser.setCurrentDirectory(new File("."));  
                chooser.setSelectedFile(new File(strPath));  
                byte[] bytK1 = getKeyByStr(sKey.substring(0, 16));  
                byte[] bytK2 = getKeyByStr(sKey.substring(16, 32));  
                byte[] bytK3 = getKeyByStr(sKey.substring(32, 48));  
  
                FileInputStream fis = new FileInputStream(fileIn);  
                byte[] bytIn = new byte[(int) fileIn.length()];  
                for (int i = 0; i < fileIn.length(); i++) {  
                    bytIn[i] = (byte) fis.read();  
                }  
                // 解密  
                byte[] bytOut = decryptByDES(decryptByDES(decryptByDES(bytIn,  
                        bytK3), bytK2), bytK1);  
                File fileOut = chooser.getSelectedFile();  
                fileOut.createNewFile();  
                FileOutputStream fos = new FileOutputStream(fileOut);  
                for (int i = 0; i < bytOut.length; i++) {  
                    fos.write((int) bytOut[i]);  
                }  
                fos.close();  
            }  
        } catch (Exception e) {  
            System.out.println("解密错误！");  
        }  
    }  
  
    /** 
     * 用DES方法加密输入的字节 bytKey需为8字节长，是加密的密码 
     */  
    private byte[] encryptByDES(byte[] bytP, byte[] bytKey) throws Exception {  
        DESKeySpec desKS = new DESKeySpec(bytKey);  
        SecretKeyFactory skf = SecretKeyFactory.getInstance("DES");  
        SecretKey sk = skf.generateSecret(desKS);  
        Cipher cip = Cipher.getInstance("DES");  
        cip.init(Cipher.ENCRYPT_MODE, sk);  
        return cip.doFinal(bytP);  
    }  
  
    /** 
     * 用DES方法解密输入的字节 bytKey需为8字节长，是解密的密码 
     */  
    private byte[] decryptByDES(byte[] bytE, byte[] bytKey) throws Exception {  
        DESKeySpec desKS = new DESKeySpec(bytKey);  
        SecretKeyFactory skf = SecretKeyFactory.getInstance("DES");  
        SecretKey sk = skf.generateSecret(desKS);  
        Cipher cip = Cipher.getInstance("DES");  
        cip.init(Cipher.DECRYPT_MODE, sk);  
        return cip.doFinal(bytE);  
    }  
  
    /** 
     * 输入密码的字符形式，返回字节数组形式。 如输入字符串：AD67EA2F3BE6E5AD 
     * 返回字节数组：{173,103,234,47,59,230,229,173} 
     */  
    private byte[] getKeyByStr(String str) {  
        byte[] bRet = new byte[str.length() / 2];  
        for (int i = 0; i < str.length() / 2; i++) {  
            Integer itg = new Integer(16 * getChrInt(str.charAt(2 * i))  
                    + getChrInt(str.charAt(2 * i + 1)));  
            bRet[i] = itg.byteValue();  
        }  
        return bRet;  
    }  
  
    /** 
     * 计算一个16进制字符的10进制值 输入：0-F 
     */  
    private int getChrInt(char chr) {  
        int iRet = 0;  
        if (chr == "0".charAt(0))  
            iRet = 0;  
        if (chr == "1".charAt(0))  
            iRet = 1;  
        if (chr == "2".charAt(0))  
            iRet = 2;  
        if (chr == "3".charAt(0))  
            iRet = 3;  
        if (chr == "4".charAt(0))  
            iRet = 4;  
        if (chr == "5".charAt(0))  
            iRet = 5;  
        if (chr == "6".charAt(0))  
            iRet = 6;  
        if (chr == "7".charAt(0))  
            iRet = 7;  
        if (chr == "8".charAt(0))  
            iRet = 8;  
        if (chr == "9".charAt(0))  
            iRet = 9;  
        if (chr == "A".charAt(0))  
            iRet = 10;  
        if (chr == "B".charAt(0))  
            iRet = 11;  
        if (chr == "C".charAt(0))  
            iRet = 12;  
        if (chr == "D".charAt(0))  
            iRet = 13;  
        if (chr == "E".charAt(0))  
            iRet = 14;  
        if (chr == "F".charAt(0))  
            iRet = 15;  
        return iRet;  
    }  
  
    public String md5s(String plainText) {  
        String str = null;  
        try {  
            MessageDigest md = MessageDigest.getInstance("MD5");  
            md.update(plainText.getBytes());  
            byte b[] = md.digest();  
  
            int i;  
  
            StringBuffer buf = new StringBuffer("");  
            for (int offset = 0; offset < b.length; offset++) {  
                i = b[offset];  
                if (i < 0)  
                    i += 256;  
                if (i < 16)  
                    buf.append("0");  
                buf.append(Integer.toHexString(i));  
            }  
            // System.out.println("result: " + buf.toString());// 32位的加密  
            // System.out.println("result: " + buf.toString().substring(8,  
            // 24));// 16位的加密  
            str = buf.toString().substring(8, 24);  
        } catch (NoSuchAlgorithmException e) {  
            e.printStackTrace();  
        }  
        return str;  
    }  
	
	
	
	
	
	
	/**
     * 文件file进行加密
     * @param fileUrl 文件路径
     * @param key 密码
     * @throws Exception
     */
    public static void encrypt(String fileUrl, String key) throws Exception {
        File file = new File(fileUrl);
        String path = file.getPath();
        if(!file.exists()){
            return;
        }
        int index = path.lastIndexOf("\\");
        String destFile = path.substring(0, index)+"\\"+"abc";
        File dest = new File(destFile);
        InputStream in = new FileInputStream(fileUrl);
        OutputStream out = new FileOutputStream(destFile);
        byte[] buffer = new byte[1024];
        int r;
        byte[] buffer2=new byte[1024];
        while (( r= in.read(buffer)) > 0) {
                for(int i=0;i<r;i++)
                {
                    byte b=buffer[i];
                    buffer2[i]=b==255?0:++b;
                }
                out.write(buffer2, 0, r);
                out.flush();
        }
        in.close();
        out.close();
        file.delete();
        dest.renameTo(new File(fileUrl));
        appendMethodA(fileUrl, key);
        System.out.println("加密成功");
    }
	
    
    /**
     * 
     * @param fileName
     * @param content 密钥
     */
     public static void appendMethodA(String fileName, String content) {
            try {
                // 打开一个随机访问文件流，按读写方式
                RandomAccessFile randomFile = new RandomAccessFile(fileName, "rw");
                // 文件长度，字节数
                long fileLength = randomFile.length();
                //将写文件指针移到文件尾。
                randomFile.seek(fileLength);
                randomFile.writeBytes(content);
                randomFile.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
     }
    
     /**
      * 解密
      * @param fileUrl 源文件
      * @param tempUrl 临时文件
      * @param ketLength 密码长度
      * @return
      * @throws Exception
      */
     public static String decrypt(String fileUrl, String tempUrl, int keyLength) throws Exception{
            File file = new File(fileUrl);
            if (!file.exists()) {
                return null;
            }
            File dest = new File(tempUrl);
            if (!dest.getParentFile().exists()) {
                dest.getParentFile().mkdirs();
            }
             
            InputStream is = new FileInputStream(fileUrl);
            OutputStream out = new FileOutputStream(tempUrl);
             
            byte[] buffer = new byte[1024];
            byte[] buffer2=new byte[1024];
            byte bMax=(byte)255;
            long size = file.length() - keyLength;
            int mod = (int) (size%1024);
            int div = (int) (size>>10);
            int count = mod==0?div:(div+1);
            int k = 1, r;
            while ((k <= count && ( r = is.read(buffer)) > 0)) {
                if(mod != 0 && k==count) {
                    r =  mod;
                }
                 
                for(int i = 0;i < r;i++)
                {
                    byte b=buffer[i];
                    buffer2[i]=b==0?bMax:--b;
                }
                out.write(buffer2, 0, r);
                k++;
            }
            out.close();
            is.close();
            return tempUrl;
        }
     
     
    
}
