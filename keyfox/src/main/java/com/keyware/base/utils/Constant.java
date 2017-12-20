package com.keyware.base.utils;

import java.util.HashMap;

public class Constant {
	
	//错误信息
	public static String ERROE_MESSAGE = "系统错误,请联系管理员";
	
	//编号前缀
	public static String RULE_NUMBER = "kw";
	
	public static HashMap<String, String> document = initDocument();
	
	public static HashMap<String, Integer> documentOrder = initDocumentOrder();
	
	
	public static HashMap<String, String> initDocument() {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("数据库设计说明", "shujukushejishuoming");
		hashMap.put("软件设计说明", "ruanjianshejishuoming");
		hashMap.put("软件产品规格说明", "ruanjianchanpinguigeshuoming");
		hashMap.put("软件研制任务书", "ruanjianyanzhirenwushu");
		hashMap.put("软件需求规格说明", "ruanjianxuqiuguogeshuoming");
		hashMap.put("软件单元测试计划", "ruanjiandanyuanceshijihua");
		hashMap.put("软件单元测试说明", "ruanjiandanyuanceshishuoming");
		hashMap.put("软件系统测试计划", "ruanjianxitongceshijihua");
		hashMap.put("软件配置项测试计划", "ruanjianpeizhixiangceshijihua");
		hashMap.put("软件部件测试计划", "ruanjianbujianceshijihua");
		hashMap.put("软件部件测试说明", "ruanjianbujianceshishuoming");
		hashMap.put("软件系统测试说明", "ruanjianxitongceshishuoming");
		hashMap.put("软件配置项测试说明", "ruanjianpeizhixiangceshishuoming");
		hashMap.put("接口需求规格说明", "jiekouxuqiuguigeshuoming");
		hashMap.put("接口设计说明", "jiekoushejishuoming");
		hashMap.put("系统（子系统）规格说明", "xitongzixitongxuqiuguigeshuoming");
		hashMap.put("系统（子系统）设计说明", "xitongzixitongshejishuoming");
		hashMap.put("软件测试计划", "ruanjianceshijihua");
		hashMap.put("软件测试说明", "ruanjianceshishuoming");
		return hashMap;
	}

	
	private static HashMap<String, Integer> initDocumentOrder() {
		HashMap<String, Integer> hashMap = new HashMap<String, Integer>();
		hashMap.put("软件研制任务书", 1);
		
		hashMap.put("软件需求规格说明", 2);
		hashMap.put("系统/子系统规格说明", 2);
		hashMap.put("接口需求规格说明", 2);
		
		hashMap.put("软件设计说明", 3);
		hashMap.put("数据库设计说明", 3);
		hashMap.put("系统/子系统设计说明", 3);
		hashMap.put("接口设计说明", 3);
		hashMap.put("软件产品规格说明", 3);
		
		hashMap.put("软件测试计划", 4);
		hashMap.put("软件单元测试计划", 4);
		hashMap.put("软件部件测试计划", 4);
		hashMap.put("软件配置项测试计划", 4);
		hashMap.put("软件系统测试计划", 4);
		hashMap.put("软件开发计划", 4);
		hashMap.put("软件配置管理计划", 4);
		hashMap.put("软件质量保证计划", 4);
		
		hashMap.put("软件测试说明", 5);
		hashMap.put("软件单元测试说明", 5);
		hashMap.put("软件部件测试说明", 5);
		hashMap.put("软件配置项测试说明", 5);
		hashMap.put("软件系统测试说明", 5);
		
		hashMap.put("软件测试报告", 6);
		hashMap.put("软件单元测试报告", 6);
		hashMap.put("软件部件测试报告", 6);
		hashMap.put("软件配置项测试报告", 6);
		hashMap.put("软件系统测试报告", 6);
		hashMap.put("软件配置管理报告", 6);
		hashMap.put("软件质量保证报告", 6);
		hashMap.put("软件产品规格说明", 6);
		hashMap.put("软件版本说明", 6);
		hashMap.put("软件用户手册", 6);
		hashMap.put("固件保障手册", 6);
		
		hashMap.put("软件单元回归测试计划", 7);
		hashMap.put("软件部件回归测试计划", 7);
		hashMap.put("软件配置项回归测试计划", 7);
		hashMap.put("软件系统回归测试计划", 7);
		
		hashMap.put("软件单元回归测试说明", 8);
		hashMap.put("软件部件回归测试说明", 8);
		hashMap.put("软件配置项回归测试说明", 8);
		hashMap.put("软件系统回归测试说明", 8);
		
		hashMap.put("软件单元回归测试报告", 9);
		hashMap.put("软件部件回归测试报告", 9);
		hashMap.put("软件配置项回归测试报告", 9);
		hashMap.put("软件系统回归测试报告", 9);
		
		return hashMap;
	}

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getdocument
	 * @Description: 根据文档名称获取前台ID
	 * @param documentName
	 * @return
	 * @return String
	 */
	public static String getdocument(String documentName){
		return document.get(documentName);
	}
	
	public static Integer getDocumentOrder(String documentName){
		return documentOrder.get(documentName);
	}
	
	
	/**
	 * 1、提醒允许创建的最大用户数 输入的时候要算上隐藏里面的  如：5 除了三员账号外 可在输入录入两个账户
	 * 2、0:为不限制用户数
	 */
	public static Integer userCount = 0;

	/**
	 * 1、同时在线人数
	 * 2、0:为不限制同时在线人数
	 */
	public static Integer sessionCount = 10;
	
	/**
	 * 控制基础模块数据
	 */
	public static String projectName = "KD";
	
	public static final String VIEW_PREFIX_FOLDER = "/eagle";
}
