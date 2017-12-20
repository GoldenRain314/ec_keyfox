package com.keyware.base.context;

import java.lang.reflect.Method;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.AlternativeJdkIdGenerator;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;


/**
 * 
 * 此类描述的是：   验证重复提交数据
 * @author: 赵亚舟   
 * @version: 2016年6月8日 下午1:32:44
 */
public class TokenInterceptor extends HandlerInterceptorAdapter{
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception{
		if (handler instanceof HandlerMethod) {
			HandlerMethod handlerMethod = (HandlerMethod) handler;
			Method method = handlerMethod.getMethod();
			Token annotation = method.getAnnotation(Token.class);
			if (annotation != null) {
				if (annotation.create() == true) {
					makeToken(request);
				}
				if (annotation.validate() == true) {
					if (isRepeatSubmit(request)) {
						clearToken(request);
						throw new RuntimeException("禁止重复提交数据");
					}
					clearToken(request);
				}
			}
		}
		return super.preHandle(request, response, handler);
	}
	
	private boolean isRepeatSubmit(HttpServletRequest request) {
		String sToken = (String)WebUtils.getSessionAttribute(request, "token");
		String cToken = request.getParameter("token");
		if(sToken != null && cToken != null && sToken.equals(cToken)){
			return false;
		}else{
			return true;
		}
	}
	
	public static void makeToken(HttpServletRequest request){
		String token = new AlternativeJdkIdGenerator().generateId().toString();
		WebUtils.setSessionAttribute(request, "token", token);
		request.setAttribute("token", token);
	}
	public static void clearToken(HttpServletRequest request){
		WebUtils.setSessionAttribute(request, "token", null);
		request.removeAttribute("token");
	}
	
}
