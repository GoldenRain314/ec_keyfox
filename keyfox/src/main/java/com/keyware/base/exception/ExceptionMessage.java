package com.keyware.base.exception;
import java.util.HashMap;
import java.util.Map;

/**
 * 
 * 此类描述的是：   	ExceptionMessage
 * @author: 赵亚舟   
 * @version: 2016年6月8日 下午2:16:57
 */
public class ExceptionMessage {
	
	private static Map<String,String> map = new HashMap<String,String>();
	
	static {
		map.put("filenotfound", "文件未发现");
		map.put("eof", "文件传输异常");
		map.put("malformed", "URL解析出错");
		map.put("unknownhost", "指定主机未找到");
		map.put("io", "其他文件操作异常");
		map.put("other", "未知异常,请联系管理员");
		map.put("unauthenticated", "未登录");
		map.put("unauthorized", "对不起没有相关权限");
		map.put("unknownaccount", "对不起用户不存在");
		map.put("lockedaccount", "用户被锁定");
		map.put("incorrectcredentials", "密码不正确");
		map.put("excessiveattempts", "尝试次数太多,请联系管理员");
		map.put("disabledAccount", "用户未启用");
		map.put("authentication", "验证出错,请联系管理员");
		map.put("nullpointer", "业务逻辑异常");
		map.put("classcast", "类型转换异常");
		map.put("arithmetic", "算术运算异常");
		map.put("arraystore", "向数组中存放与声明类型不兼容对象异常");
		map.put("indexoutofbounds", "下标越界异常");
		map.put("negativearraysize", "创建一个大小为负数的数组错误异常");
		map.put("numberformat", "数字格式异常");
		map.put("security", "安全异常");
		map.put("unsupportedoperation", "不支持的操作异常");
		map.put("arrayindexoutofbounds", "访问数组元素的下标越界异常");
		map.put("stringindexoutofbounds", "字符串下标越界异常");
		map.put("illegalargument", "传递非法参数异常");
		map.put("illegalstate", "客户端的响应已经结束");
		map.put("illegalaccess", "非法访问异常");
		map.put("maxuploadsizeexceeded", "最大上传限制");
		map.put("enumconstantnotpresent", "枚举读取异常");
		map.put("instantiation", "实例了一个接口或者抽象类");
		map.put("interrupted", "线程中断异常");
		map.put("nosuchfield", "类不包含指定名称的字段");
		map.put("nosuchmethod", "无法找到特定方法");
		map.put("typenotpresent", "当应用程序试图使用表示类型名称的字符串对类型进行访问，但无法找到带有指定名称的类型定义时，抛出该异常");
		map.put("bind", "Bean绑定异常");
		map.put("conversionnotsupported", "转换不支持异常");
		map.put("httpmediatypenotacceptable", "HttpMedia类型接受");
		map.put("httpmediatypenotsupported", "HttpMedia类型不支持");
		map.put("httpmessagenotreadable", "Http消息不可读");
		map.put("httpmessagenotwritable", "Http消息不可写");
		map.put("httprequestmethodnotsupported", "Http请求方法不支持");
		map.put("methodargumentnotvalid", "方法参数不正确");
		map.put("missingservletrequestparameter", "丢失请求参数");
		map.put("missingservletrequestpart", "丢失请求部分");
		map.put("nohandlerfound", "没有找到处理方法");
		map.put("nosuchrequesthandlingmethod", "没有请求找到处理方法");
		map.put("typemismatch", "请求错误");
		map.put("business", "业务逻辑异常");
		map.put("classnotfound", "类未找到");
		map.put("clonenotsupported", "复制类不支持");
		map.put("expirationTimelimit", "账号已过期");
	}
	
	public static String getMessage(String key){
		return map.get(key);
	}
}
