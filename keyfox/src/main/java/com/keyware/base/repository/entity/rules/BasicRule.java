package com.keyware.base.repository.entity.rules;

import java.util.ArrayList;

public class BasicRule {
	
	private String appId;
	private String name;
	private String msg;
	//备注
	private String reverse;
	private String level;
	private String reNewapp;
	private String type;
	private String myType;
	private String saveBytes;
	private String respond;
	private String trance;
	private String status;
	//子规则类型
	private String rulesType;
	private String regex_rule;
	private String iP_rule;
	private String key_rule;
	private String protocol_Rule;
	private String lib_rule;
	private String domain_rule;

	public String getAppId() {
		return appId;
	}
	public void setAppId(String appId) {
		this.appId = appId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public String getReverse() {
		return reverse;
	}
	public void setReverse(String reverse) {
		this.reverse = reverse;
	}
	public String getLevel() {
		return level;
	}
	public void setLevel(String level) {
		this.level = level;
	}
	public String getReNewapp() {
		return reNewapp;
	}
	public void setReNewapp(String reNewapp) {
		this.reNewapp = reNewapp;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getMyType() {
		return myType;
	}
	public void setMyType(String myType) {
		this.myType = myType;
	}
	public String getSaveBytes() {
		return saveBytes;
	}
	public void setSaveBytes(String saveBytes) {
		this.saveBytes = saveBytes;
	}
	public String getRespond() {
		return respond;
	}
	public void setRespond(String respond) {
		this.respond = respond;
	}
	public String getTrance() {
		return trance;
	}
	public void setTrance(String trance) {
		this.trance = trance;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getRulesType() {
		return rulesType;
	}
	public void setRulesType(String rulesType) {
		this.rulesType = rulesType;
	}
	public String getRegex_rule() {
		return regex_rule;
	}
	public void setRegex_rule(String regex_rule) {
		this.regex_rule = regex_rule;
	}
	public String getiP_rule() {
		return iP_rule;
	}
	public void setiP_rule(String iP_rule) {
		this.iP_rule = iP_rule;
	}
	public String getKey_rule() {
		return key_rule;
	}
	public void setKey_rule(String key_rule) {
		this.key_rule = key_rule;
	}
	public String getProtocol_Rule() {
		return protocol_Rule;
	}
	public void setProtocol_Rule(String protocol_Rule) {
		this.protocol_Rule = protocol_Rule;
	}
	public String getLib_rule() {
		return lib_rule;
	}
	public void setLib_rule(String lib_rule) {
		this.lib_rule = lib_rule;
	}
	public String getDomain_rule() {
		return domain_rule;
	}
	public void setDomain_rule(String domain_rule) {
		this.domain_rule = domain_rule;
	}
}
