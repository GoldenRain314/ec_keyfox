package com.keyware.base.vo.user;

import com.keyware.base.repository.entity.user.User;

public class UserVo extends User{
	private static final long serialVersionUID = -4140149691480826306L;


	//验证码
	private String kaptcha;
	
	//部门名称
	private String departName;
	
	
	private String isRemember;
	
	private String token;

	public String getKaptcha() {
		return kaptcha;
	}

	public void setKaptcha(String kaptcha) {
		this.kaptcha = kaptcha;
	}

	public String getIsRemember() {
		return isRemember;
	}

	public void setIsRemember(String isRemember) {
		this.isRemember = isRemember;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getDepartName() {
		return departName;
	}

	public void setDepartName(String departName) {
		this.departName = departName;
	}
	
}
