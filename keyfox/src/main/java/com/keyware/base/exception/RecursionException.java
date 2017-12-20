package com.keyware.base.exception;
import org.apache.shiro.authc.AuthenticationException;

/**
 * 
 * 此类描述的是：   递归异常
 * @author: 赵亚舟   
 * @version: 2016年8月23日 下午2:33:22
 */
public class RecursionException extends AuthenticationException{

	private static final long serialVersionUID = 7159609017548780986L;
	

	public RecursionException() {
		// TODO Auto-generated constructor stub
	}
	
	public RecursionException(String message) {
		super(message);
	}

	public RecursionException(Throwable cause) {
		super(cause);
	}

	public RecursionException(String message, Throwable cause) {
		super(message, cause);
	}
	
}
