package com.keyware.base.exception;

import org.apache.shiro.authc.AuthenticationException;

/**
 * 
 * 此类描述的是：   登陆异常处理
 * @author: 赵亚舟   
 * @version: 2016年6月8日 下午1:54:15
 */
public class LoginForbiddenException extends AuthenticationException {
	
	private static final long serialVersionUID = 1885149635555213696L;

	public LoginForbiddenException() {
	}

	public LoginForbiddenException(String message) {
		super(message);
	}

	public LoginForbiddenException(Throwable cause) {
		super(cause);
	}

	public LoginForbiddenException(String message, Throwable cause) {
		super(message, cause);
	}
}
