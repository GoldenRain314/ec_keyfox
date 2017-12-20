package com.keyware.utils;

import javax.servlet.http.HttpServletRequest;

public class IpUtil {
	/**
	 * 
	 *@author 申鹏飞
	 *@title 获取访问Ip
	 *@param
	 * @param request
	 * @return
	 *@date
	 */
	public static String getIpAddr(HttpServletRequest request) {
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		//如果通过了多级反向代理，需截取ip
		if(ip != null && ip.indexOf(",") > -1){
					ip = ip.split(",")[0].trim();
		}
		return ip.equals("0:0:0:0:0:0:0:1")?"127.0.0.1":ip;
	}
}
