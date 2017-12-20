package com.keyware.utils;

import java.math.BigDecimal;
import java.util.ArrayList;

import org.springframework.util.StringUtils;
/**
 * 
 * 此类描述的是：   	数字工具类
 * @author: 赵亚舟   
 * @version: 2016年6月10日 下午6:06:15
 */
public class NumberUtils {
	
	/**
	 * double乘法
	 * 解决java Double 计算精度的问题
	 * @param v1
	 * @param v2
	 * @return
	 */
    public static double mul(double v1,double v2){
        BigDecimal b1 = new BigDecimal(Double.toString(v1));
        BigDecimal b2 = new BigDecimal(Double.toString(v2));
        return b1.multiply(b2).doubleValue();
    }
    /**
     * double加法
     * 解决java Double 计算精度的问题
     * @param v1
     * @param v2
     * @return
     */
    public static double add(double v1,double v2){
        BigDecimal b1 = new BigDecimal(Double.toString(v1));
        BigDecimal b2 = new BigDecimal(Double.toString(v2));
        return b1.add(b2).doubleValue();
    }
    
    
    /**
     * 
     * 保留两位小数(四舍五入)
     * @param number
     * @return
     */
    public static double round(Double number){
    	BigDecimal bigDecimal = new BigDecimal(number);
    	return bigDecimal.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
    }
    
    /**
     * 
     * 将字符串转成list  格式（"1,2,3"）
     * @param str	
     * @return
     */
    public static ArrayList<Integer> strToList(String str){
    	ArrayList<Integer> arrayList = new ArrayList<Integer>();
    	if(StringUtils.hasText(str)){
			String[] split = str.split(",");
			for(int i=0;i<split.length;i++){
				arrayList.add(Integer.parseInt(split[i]));
			}
		}
    	if(arrayList.size() == 0)
    		return null;
    	return arrayList;
    }
    
    
    /**
     * 随机生成4位数字字符数组
     * 
     * @return rands
     */
    public static String getFourValidationCode(){
        String chars = "0123456789";
        StringBuffer stringBuffer = new StringBuffer();
        for (int i = 0; i < 4; i++){
            int rand = (int) (Math.random() * 10);
            stringBuffer.append(chars.charAt(rand));
        }
        return stringBuffer.toString();
    }
    
    /**
     * 随机生成6位的验证码
     * 
     * @return
     */
    public static String getSixValidationCode(){
    	 String chars = "0123456789";
         StringBuffer stringBuffer = new StringBuffer();
         for (int i = 0; i < 6; i++){
             int rand = (int) (Math.random() * 10);
             stringBuffer.append(chars.charAt(rand));
         }
         return stringBuffer.toString();
    }

}
