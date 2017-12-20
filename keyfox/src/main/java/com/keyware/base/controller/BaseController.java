package com.keyware.base.controller;


import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.springframework.web.util.WebUtils;

import com.keyware.base.context.KDExceptionHandler;
import com.keyware.base.context.TokenInterceptor;
import com.keyware.base.exception.ExceptionMessage;
import com.keyware.base.exception.LoginForbiddenException;
import com.keyware.base.exception.NoRelatedRolesException;
import com.keyware.base.utils.Constant;
import com.keyware.base.utils.Json;
import com.keyware.utils.JsonUtils;

/**
 * 
 * 此类描述的是：   	BaseController
 * @author: 赵亚舟   
 * @version: 2016年6月8日 下午2:12:29
 */
@Controller
public class BaseController {
	
	protected  HttpServletRequest request;
	@ExceptionHandler
	public ModelAndView doResolveException(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception exception){
		ModelAndView mav = new ModelAndView();
		KDExceptionHandler shandler = new KDExceptionHandler();
		Map<String,String> map = new HashMap<String,String>();
		if(exception instanceof IOException){
			map = shandler.doIOException(request, response, shandler, exception);
		}else if(exception instanceof ClassNotFoundException){
			map = shandler.doClassNotFoundException(request, response, shandler, exception);
		}else if(exception instanceof CloneNotSupportedException){
			map = shandler.doCloneNotSupportedException(request, response, shandler, exception);
		}else if(exception instanceof LoginForbiddenException){
			map = shandler.doLoginForbiddenException(request, response, shandler, exception);
		}else if(exception instanceof NoRelatedRolesException){
			map = shandler.doNoRelatedRolesException(request, response, shandler, exception);
		}else{
			map = shandler.doRuntimeException(request, response, shandler, exception);
		}
		if("business".equalsIgnoreCase(map.get("code"))){
			map.put("message", map.get("message"));
		}else{			
			map.put("message", ExceptionMessage.getMessage(map.get("code")));
		}
		map.put("code", "0");
		TokenInterceptor.makeToken(request);
		map.put("token", getToken(request));
		if(BaseController.isAjax(request)){
			try {
				response.setContentType("text/json; charset=UTF-8");  
				response.getWriter().print(JsonUtils.objectToJsonString(map));
				response.getWriter().flush();
				response.getWriter().close();
			} catch (IOException e) {
				Logger.getLogger(this.getClass().getName()).log(Level.SEVERE,e.getLocalizedMessage());
			}
		}else{
			mav.setViewName("/common/error");		
			mav.addAllObjects(map);
		}
		return mav;
	}
	@ModelAttribute
	public void initServlt(HttpServletRequest request,HttpServletResponse response){
		request.setAttribute("_baseUrl", request.getContextPath());
		Locale locale = RequestContextUtils.getLocale(request);
		request.setAttribute("_local", locale.getLanguage());
		request.setAttribute("_url", request.getRequestURI());
//		request.setAttribute("_resources", RedisUtil.hget(RedisKeyEnums.SETTINGS.getValue(), "resourcesPath"));
		request.setAttribute("_resources", request.getContextPath()+"/resources/");
		request.setAttribute("_officecontrol", request.getContextPath()+"/resources/officecontrol/");
	}
	/**
	 * 
	 * @Title: getToken
	 * @Description: 获得验证令牌
	 * @param request
	 * @return String   
	 * @throws
	 * @date 2015-4-17 下午4:09:15
	 */
	protected String getToken(HttpServletRequest request){
		Object token = WebUtils.getSessionAttribute(request, "token");
		return token != null ?token.toString():null;
	}
	
	/**
	 * @return the request
	 */
	public HttpServletRequest getRequest() {
		return request;
	}
	/**
	 * @param request the request to set
	 */
	@Autowired
	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}
	
	/**
	 * 获取客户端ip
	 * @return
	 */
	public String getRemoteHost(){
		String ip = request.getHeader("x-forwarded-for");
		if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)){
			ip = request.getHeader("Proxy-Client-IP");
		}
		if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)){
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)){
			ip = request.getRemoteAddr();
		}
		//如果通过了多级反向代理，需截取ip
		if(ip != null && ip.indexOf(",") > -1){
			ip = ip.split(",")[0].trim();
		}
		return ip.equals("0:0:0:0:0:0:0:1")?"127.0.0.1":ip;
	}
	
	
	public static boolean isAjax(HttpServletRequest request){
	    String requestType = request.getHeader("X-Requested-With");

	    return (requestType != null) && (requestType.equals("XMLHttpRequest"));
	  }
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getUser_idFormSession
	 * @Description: 获取session中数据
	 * @param user_id
	 * @return
	 * @return String
	 */
	public String getUser_idFormSession(String user_id){
		return (String)request.getSession().getAttribute(user_id);
	}
	/**
	 * 发送数据【避免使用此方法，后期版本可能会被删除，将会被sendJsonSuccess、sendJsonException、sendJsonException 等方法替换】
	 * @param response
	 * @param list	数据列表
	 * @param rowsCount 总条数
	 * @param pageCount 总页数
	 */
	public void sendJSONPageInfo(HttpServletResponse response, List<?> list,long rowsCount , long pageCount) {
		JSONArray jsonArray = JSONArray.fromObject(list);
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("rowsCount", rowsCount);
		jsonObject.put("pageCount", pageCount);
		jsonObject.put("list", jsonArray);
		String string = jsonObject.toString();
		response.setContentType("text/json; charset=UTF-8");
		try {
			response.getWriter().write(string);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 发送数据【避免使用此方法，后期版本可能会被删除，将会被sendJsonSuccess、sendJsonException、sendJsonException 等方法替换】
	 */
	public void sendJSONList(HttpServletResponse response, List<?> list) {
		JSONArray json = JSONArray.fromObject(list);
		String string = json.toString();
		response.setContentType("text/json; charset=UTF-8");
		try {
			response.getWriter().write(string);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 发送数据【避免使用此方法，后期版本可能会被删除，将会被sendJsonSuccess、sendJsonException、sendJsonException 等方法替换】
	 */
	public void sendJSONObject(HttpServletResponse response, Object o) {
		JSONObject json = JSONObject.fromObject(o);
		String string = json.toString();
		response.setContentType("text/json; charset=UTF-8");
		try {
			response.getWriter().write(string);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 发送数据【已删除，可采用sendJsonSuccess、sendJsonException、sendJsonException 等方法替换】
	 */
/*	public void sendJSONMessage(HttpServletResponse response, String s) {
		response.setContentType("text/json; charset=UTF-8");
		try {
			response.getWriter().write(s);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}*/

	/**
	 * 发送数据
	 */
	public Json sendJsonException(Exception e) {
		e.printStackTrace();
		Json j = new Json();
		j.setMsg(e.getMessage());
		j.setSuccess(false);
		return j;
	}
	
	/**
	 * 发送数据
	 */
	public Json sendJsonException(String msg) {
		Json j = new Json();
		j.setMsg(msg);
		j.setSuccess(false);
		return j;
	}
	
	/**
	 * 发送数据
	 */
	public Json sendJsonSuccess(String mes,Object obj) {
		Json j = new Json();
		j.setMsg(mes);
		j.setSuccess(true);
		j.setObj(obj);
		return j;
	}

	/** 
	 * @Description: jsp文件夹前缀，因为在xml只能设置jsp的一个前缀，我们需要的是jsp下级目录，如果此目录改名，直接在此修改即可
	 * @author yanwj
	 * @date 2017年10月17日 下午3:48:54
	 * @param path
	 * @return String
	 */ 
	public static String jspPrefix(String path) {
		return Constant.VIEW_PREFIX_FOLDER + path;
	}
}
