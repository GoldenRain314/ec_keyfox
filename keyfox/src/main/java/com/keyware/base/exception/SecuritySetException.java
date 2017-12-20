package com.keyware.base.exception;

import org.apache.shiro.authc.AuthenticationException;
/**
 * 
 * 此类描述的是：   	安全设置相关异常
 * @author: 赵亚舟   
 * @version: 2016年7月18日 下午1:59:07
 */
public class SecuritySetException extends AuthenticationException{
	    
	private static final long serialVersionUID = 822865846990758771L;

	public SecuritySetException(){
		
	}
	public SecuritySetException(String message) {
		super(message);
	}

	public SecuritySetException(Throwable cause) {
		super(cause);
	}

	public SecuritySetException(String message, Throwable cause) {
		super(message, cause);
	}

}
