package com.keyware.base.context;


import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.ExceptionHandler;

import com.keyware.base.exception.LoginForbiddenException;
import com.keyware.base.exception.NoRelatedRolesException;
import com.keyware.base.exception.ShopExceptionHandler;


/**
 * 
 * 此类描述的是：   	SaaSExceptionHandler
 * @author: 赵亚舟   
 * @version: 2016年6月8日 下午1:55:55
 */

public class KDExceptionHandler extends ShopExceptionHandler {

	private static final long serialVersionUID = -4459419023875308466L;

	private Map<String, String> map = new HashMap<String, String>();

	@ExceptionHandler({ LoginForbiddenException.class })
	public Map<String, String> doLoginForbiddenException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) {
		try {
			this.map.put("code", "business");
			this.map.put("message", "用户被拉黑");
			Logger.getLogger(exception.getClass().getName()).log(Level.SEVERE, makeErrorMessage(exception, "IOException"));
			this.map.put("message", exception.getLocalizedMessage());
		} catch (Exception handlerException) {
			this.map.put("code", "other");
			this.map.put("message", handlerException.getLocalizedMessage());
			Logger.getLogger(handlerException.getClass().getName()).log(Level.SEVERE, makeErrorMessage(handlerException, "Exception"));
		}
		return this.map;
	}
	
	@ExceptionHandler({ NoRelatedRolesException.class })
	public Map<String, String> doNoRelatedRolesException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) {
		try {
			this.map.put("code", "business");
			this.map.put("message", "用户无权限");
			Logger.getLogger(exception.getClass().getName()).log(Level.SEVERE, makeErrorMessage(exception, "IOException"));
			this.map.put("message", exception.getLocalizedMessage());
		} catch (Exception handlerException) {
			this.map.put("code", "other");
			this.map.put("message", handlerException.getLocalizedMessage());
			Logger.getLogger(handlerException.getClass().getName()).log(Level.SEVERE, makeErrorMessage(handlerException, "Exception"));
		}
		return this.map;
	}

	private String makeErrorMessage(Exception ex, String type) {
		StringBuffer sb = new StringBuffer("file:[");
		StackTraceElement[] element = ex.getStackTrace();
		sb.append(element[0].getFileName());
		sb.append("],class:[");
		sb.append(element[0].getClassName());
		sb.append("],method:[");
		sb.append(element[0].getMethodName());
		sb.append("],line:[");
		sb.append(element[0].getLineNumber());
		sb.append("],type:[");
		sb.append(type);
		sb.append("],message:[");
		sb.append(ex.getLocalizedMessage());
		sb.append("]");
		return sb.toString();
	}

}
