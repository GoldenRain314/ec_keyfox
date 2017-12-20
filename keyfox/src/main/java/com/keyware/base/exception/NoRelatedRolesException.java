package com.keyware.base.exception;

import org.apache.shiro.authc.AuthenticationException;

/**
 * 此类描述的是：   	异常-没有相关的角色
 * @author: 赵亚舟   
 * @version: 2016年6月8日 下午1:54:52
 */

public class NoRelatedRolesException extends AuthenticationException {

	private static final long serialVersionUID = -6352858019126573934L;

	public NoRelatedRolesException() {
	}

	public NoRelatedRolesException(String message) {
		super(message);
	}

	public NoRelatedRolesException(Throwable cause) {
		super(cause);
	}

	public NoRelatedRolesException(String message, Throwable cause) {
		super(message, cause);
	}
}
