package com.keyware.base.filter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.keyware.base.controller.login.LoginController;

public class KDInterceptor extends HandlerInterceptorAdapter{
	//public static Logger logger = Logger.getLogger(KDInterceptor.class);
	
    @Override  
    public boolean preHandle(HttpServletRequest request,  
            HttpServletResponse response, Object handler) throws Exception {  
  
        request.setCharacterEncoding("UTF-8");  
        response.setCharacterEncoding("UTF-8");  
        response.setContentType("text/html;charset=UTF-8");
        
        // 判断路径是登出还是登录验证，是这两者之一的话执行Controller中定义的方法 
        String uri = request.getRequestURI();
//		登录、注册、省市区查询、注册及注册成功、验证账号信息、获取企业列表、读取帮助图片文件
        if(uri.endsWith("/portal")
        		|| uri.endsWith("/index")
        		) {
            return true;
        }
        
       // String contextPath = request.getContextPath();
       // String fixUrl = uri.substring(contextPath.length());//去掉项目名的路径
      
    	// 进入登录页面，判断session中是否有key，有的话重定向到首页，否则进入登录界面
        if(uri.endsWith("/login") && request.getSession() != null && request.getSession().getAttribute("user") != null && (null == (Boolean)request.getSession().getAttribute("admin") || !(Boolean)request.getSession().getAttribute("admin"))) {
        	response.sendRedirect(request.getContextPath() + "/home"); 
        }else if(uri.endsWith("/login") || (request.getSession() != null && request.getSession().getAttribute("user") != null && (null == (Boolean)request.getSession().getAttribute("admin") || !(Boolean)request.getSession().getAttribute("admin")))){
        	// 其他情况判断session中是否有key，有的话继续用户的操作
        	return true;
        }else if(uri.endsWith("/home") && null != request.getSession(true).getAttribute(LoginController.NEED_VALIDATE_2) && (Boolean)request.getSession(true).getAttribute(LoginController.NEED_VALIDATE_2)){
        	return true;
        }
    	response.sendRedirect(request.getContextPath() + "/index");
        // 最后的情况就是进入登录页面
        return false;
    }
}
