package com.keyware.base.exception;

import org.apache.shiro.authc.AuthenticationException;

/**
 * 
 * 此类描述的是：   同时在线人数已满
 * @author: 赵亚舟   
 * @version: 2016年6月8日 下午1:54:15
 */
public class MaxSessionException extends AuthenticationException {
	
	private static final long serialVersionUID = 1885149635555213696L;

	public MaxSessionException() {
	}

	public MaxSessionException(String message) {
		super(message);
	}

	public MaxSessionException(Throwable cause) {
		super(cause);
	}

	public MaxSessionException(String message, Throwable cause) {
		super(message, cause);
	}
}
