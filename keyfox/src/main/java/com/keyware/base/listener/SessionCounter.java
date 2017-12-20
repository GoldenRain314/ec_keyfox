package com.keyware.base.listener;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;
import org.springframework.util.StringUtils;

public class SessionCounter implements HttpSessionListener,ServletRequestListener{

	private static Logger log = Logger.getLogger(SessionCounter.class);
	
	private static final String CONTENT_TYPE = "text/html; charset=GBK";
	
	public static int activeSessions = 0;//当前活动的人数
	
    private HttpServletRequest request;
    
    public static ArrayList<String> list = new ArrayList<String>();//用来存放不同ip的地址 
    
    //key:sessionId-ip
    public static HashMap<String,String> sessionIpMap = new HashMap<String,String>();
	
	
	public void init() throws ServletException {

    }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
    } 
	
	public void destroy() {
    } 
	
	
	@Override
	public void requestDestroyed(ServletRequestEvent arg0) {
	}

	@Override
	public void requestInitialized(ServletRequestEvent arg0) {
		request=(HttpServletRequest)arg0.getServletRequest();
		
	}

	@Override
	public void sessionCreated(HttpSessionEvent httpSessionEvent) {
        HttpSession session = httpSessionEvent.getSession();
		String sessionId = session.getId();
        String userId = (String) session.getAttribute("userId");
        if(StringUtils.hasText(userId)){
        	String loginIp = request.getRemoteAddr();
        	boolean rs = true;
        	if(list.size() > 0){
        		for(int i = 0;i < list.size(); i ++){
        			if(loginIp.equals(list.get(i))){
        				rs = false;
        			}
        		}
        	}
        	if(rs){                      //如果队列中存在相同的IP 则SESSION不增加
        		list.add(loginIp);
        		activeSessions++;
        		sessionIpMap.put(sessionId, loginIp);
        		for(String ip:list)
        			log.info(ip);
        		log.info("新增SESSION,sessionId = " + sessionId
        				+ "; loginIp = " + loginIp +"; 当前总SESSION值为 "+activeSessions);
        	}
        }
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        String sessionId = httpSessionEvent.getSession().getId();
        String loginIp = null;
        try {
        	loginIp = request.getRemoteAddr();
		} catch (Exception e) {
			log.error("request异常");
		}
        if(activeSessions>0){
            if(list.size() > 0){
            	if(loginIp == null){
            		String ip = sessionIpMap.get(sessionId);
            		loginIp = ip;
                	Iterator<Entry<String, String>> iterator = sessionIpMap.entrySet().iterator();
                	while(iterator.hasNext()){
                		Entry<String, String> next = iterator.next();
                		if(next.getValue().equals(ip)){
                			iterator.remove();
                		}
                	}
            	}
            	
                for(int i = 0;i < list.size(); i ++){
                    if(list.get(i).equals(loginIp)){
                        list.remove(i);
                        i--;
                    }
                }
            }
            sessionIpMap.remove(sessionId);
            activeSessions--;                   //在用户销毁的时候,从队列中踢出这个IP
            log.info("销毁SESSION,sessionId = " + sessionId
                             + "; loginIp = " + loginIp +"; 当前总SESSION值为 "+activeSessions);
            if(activeSessions == 0){
            	list.removeAll(list);
            	sessionIpMap = new HashMap<String,String>();
            }
        }
	}

	public static int getActiveSessions() {
		return activeSessions;
	}


}
