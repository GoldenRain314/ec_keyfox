package com.keyware.base.exception;
import org.apache.shiro.authc.AuthenticationException;
/**
 * 
 * 此类描述的是：   密码失效异常
 * @author: 赵亚舟   
 * @version: 2016年9月12日 上午10:15:27
 */
public class PasscodeErrorException extends AuthenticationException{

	private static final long serialVersionUID = 1332956368117932976L;
	
	public PasscodeErrorException() {
		
	}
	
	public PasscodeErrorException(String message) {
		super(message);
	}

	public PasscodeErrorException(Throwable cause) {
		super(cause);
	}

	public PasscodeErrorException(String message, Throwable cause) {
		super(message, cause);
	}

}
