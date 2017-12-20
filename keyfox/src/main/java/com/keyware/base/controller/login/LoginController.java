package com.keyware.base.controller.login;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.keyware.base.context.Token;
import com.keyware.base.controller.BaseController;
import com.keyware.base.listener.SessionCounter;
import com.keyware.base.repository.entity.Menu;
import com.keyware.base.repository.entity.department.Department;
import com.keyware.base.repository.entity.safemanagement.SafeManagement;
import com.keyware.base.repository.entity.user.User;
import com.keyware.base.service.itf.department.DepartmentService;
import com.keyware.base.service.itf.jurisdiction.MenuService;
import com.keyware.base.service.itf.safemanagement.SafeManagementService;
import com.keyware.base.service.itf.user.UserService;
import com.keyware.base.task.util.ClientUtil;
import com.keyware.base.utils.Constant;
import com.keyware.base.vo.user.UserVo;
import com.keyware.utils.DateUtils;
import com.keyware.utils.JsonUtils;


@Controller
public class LoginController extends BaseController {
	
	public static Logger logger = Logger.getLogger(LoginController.class);
	
	public static String NEED_VALIDATE_2 = "NEED_VALIDATE_2";//session中的值：二次验证
	public static String USERNAME = "USERNAME";//session中的值：登陆名
	public static String VALIDATE_2_TOKEN = "VALIDATE_2_TOKEN";//session中的值：二次验证token
	public static String ERROR_MESSAGE = "ERROR_MESSAGE";//session中的值：错误信息
	
	
	@Resource
	private UserService userService;
	@Resource
	private DepartmentService departmentService;
	@Autowired
	private MenuService menuService;
	@Resource
	private SafeManagementService safeManagementService;

	
	/**
	 * 
	 * @Title: indexPage
	 * @Description: 登录
	 * @return
	 * @return String
	 */
	@RequestMapping(value = {"/index" })
	@Token(create=true)
	public String indexPage(){
		if("KT".equals(Constant.projectName))
			return "kt/portal/indexPage";
		return "portal/indexPage";
	}
	
	
	/**
	 * 
	 * @Title: submit
	 * @Description: 登录验证
	 * @param uservo
	 * @return
	 * @return ModelAndView
	 */
	@Token(validate=true)
	@RequestMapping(value = "/login",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	public ModelAndView submit(@ModelAttribute UserVo uservo){
		ModelAndView modelAndView = new ModelAndView("redirect:/portal");
		
		//项目初期不验证验证码
		/*//从session中取出servlet生成的验证码text值  
		String kaptchaExpected = (String)request.getSession().getAttribute(com.google.code.kaptcha.Constants.KAPTCHA_SESSION_KEY);  
		//校验验证码是否正确  
		if (uservo.getKaptcha() == null || !uservo.getKaptcha().equalsIgnoreCase(kaptchaExpected)){  
			request.getSession().setAttribute(ERROR_MESSAGE, "验证码错误");
			return modelAndView;
		}*/
		
		User tempUser = null;
		
		//从cookie中取得用户
		User user = userService.getCurrentUser();
		if(user == null){
			String sessionId = request.getSession(true).getId();
			boolean isRemember = StringUtils.isNotBlank(uservo.getIsRemember()) ? true :false;
			try {
				userService.login(uservo.getUserId(),uservo.getPassword(),isRemember,ClientUtil.getIP(request),sessionId);
			} catch (Exception e) {
				//登陆错误信息
				request.getSession().setAttribute(ERROR_MESSAGE, e.getMessage());//登录信息有误
				return modelAndView;
			}
		}else{
			request.getSession().setAttribute(ERROR_MESSAGE, "已经登录");
		}
		tempUser = userService.selectUserByUserId(uservo.getUserId());
		request.getSession().setAttribute("user", tempUser);
		request.getSession().setAttribute("userId", tempUser.getUserId());
		request.getSession().setAttribute("user_id", tempUser.getId());	
		request.getSession().setAttribute("userName", tempUser.getUserName());
		String departName="";
		Department department= departmentService.selectByPrimaryKey(tempUser.getDepartId());
		if(department!=null){
			departName=department.getDeptName();
		}
		request.getSession().setAttribute("departName", departName);
		
		return modelAndView;
	}
	
	/**
	 * 
	 * @Title: portal
	 * @Description: 去登录页
	 * @return
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/portal",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	@Token(create=true)
	public ModelAndView portal(){
		String errorMessage = (String)request.getSession().getAttribute(ERROR_MESSAGE);
		//ModelAndView mav = new ModelAndView("portal/indexPage");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("portal/indexPage");
		if("KT".equals(Constant.projectName))
			mav.setViewName("kt/portal/indexPage");
		
		mav.addObject("errorMessage",errorMessage);
		request.getSession().removeAttribute(ERROR_MESSAGE);
		
		try {
			User user = (User)request.getSession(true).getAttribute("user");
			
			if(null != request.getAttribute("token"))
				mav.addObject("token",request.getAttribute("token"));
			
			if(user != null){
				return new ModelAndView("redirect:/loginSuccess");
			}
			
		} catch (Exception e) {
			return mav;
		}
		return mav;
	}
	
	
	/**
	 * 登陆成功
	 * @return
	 */
	@RequestMapping(value="/loginSuccess",method = RequestMethod.GET)
	@Token(create=true)
	public String loginSuccess(){
		String loginIp = request.getRemoteAddr();
    	boolean rs = true;
    	if(SessionCounter.list != null && SessionCounter.list.size()>0){
    		for(int i = 0;i < SessionCounter.list.size(); i ++){
    			if(loginIp.equals(SessionCounter.list.get(i))){
    				rs = false;
    			}
    		}
    	}
    	if(rs){//如果队列中存在相同的IP 则SESSION不增加
    		SessionCounter.list.add(loginIp);
    		SessionCounter.sessionIpMap.put(request.getSession().getId(), loginIp);
    		SessionCounter.activeSessions++;
    		logger.info("新增SESSION,sessionId = " + request.getSession().getId()
    				+ "; loginIp = " + loginIp +"; 当前总SESSION值为 "+SessionCounter.activeSessions);
    	}else{
    		if(SessionCounter.activeSessions == 0)
    			SessionCounter.activeSessions++;
    	}
		
		//return "portal/loginSuccess";
		return "index";
	}
	
	
	@RequestMapping(value="/home",method = RequestMethod.GET)
	@Token(create=true)
	public ModelAndView home(){
		//ModelAndView mav = new ModelAndView("portal/home");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("portal/home");
		if("KT".equals(Constant.projectName))
			mav.setViewName("kt/portal/home");
		
		User user = (User) request.getSession().getAttribute("user");
		if(!"admin".equals(user.getUserId()) && !"safesecret".equals(user.getUserId()) && !"safeaudit".equals(user.getUserId()) && !"sysadmin".equals(user.getUserId())){
			//安全验证,提示密码过期
			List<SafeManagement> safeManagements = safeManagementService.selectInfo();
			//密码密码时间(天)
			Long pwdChangeCycle = safeManagements.get(0).getPwdChangeCycle();
			String userPwdModifTime = user.getUserPwdModifTime();
			String flag = "false";
			try {
				long betweenDays = DateUtils.betweenDays(userPwdModifTime, DateUtils.getDate());
				if(betweenDays > pwdChangeCycle){
					flag = "true";
					request.setAttribute("updateMessage", flag);
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		
		//带权限相关
		String userId = (String)SecurityUtils.getSubject().getPrincipal();//获取用户账户		
		
		//所有一级权限
		List<Menu> menusParents = menuService.getTheOneLevelMenuBasedOnTheAccountID(userId);
		//List 去重复项
		List<Menu> removeDuplicate = this.removeDuplicate(menusParents);
		request.setAttribute("menuParents", JsonUtils.objectToJsonString(removeDuplicate));
		
		//用户名
		request.setAttribute("userName", user.getUserName());
		
		return mav;
	}
	
	/**
	 * 
	 * @Title: logout
	 * @Description: 注销 返回登陆页面
	 * @return
	 * @return String
	 */
	@RequestMapping(value="/logout",method = {RequestMethod.GET, RequestMethod.POST},produces = "application/json; charset=utf-8")
	public String logout(){
		try {
			
			User selectByPrimaryKey = userService.selectByPrimaryKey(getUser_idFormSession("user_id"));
			selectByPrimaryKey.setExitTime(DateUtils.getDate());
			userService.updateByPrimaryKey(selectByPrimaryKey);
			userService.logout();
			
			/*String loginIp = request.getRemoteAddr();
	        if(SessionCounter.activeSessions>0){
	            if(SessionCounter.list.size() > 0){
	                for(int i = 0;i < SessionCounter.list.size(); i ++){
	                    if(loginIp.equals(SessionCounter.list.get(i))){
	                    	SessionCounter.list.remove(i);  
	                    }
	                }
	            }
	            SessionCounter.activeSessions--;//在用户销毁的时候,从队列中踢出这个IP
				logger.info("销毁SESSION,sessionId = " + secctionId
	                             + "; loginIp = " + loginIp +"; 当前总SESSION值为 "+SessionCounter.activeSessions);
	        }*/
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/index";
	}
	
	
	@RequestMapping(value="/logout/closewindows",method = {RequestMethod.GET, RequestMethod.POST},produces = "application/json; charset=utf-8")
	public String logout1(){
		try {
			userService.logout();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	
	private List<Menu> removeDuplicate(List<Menu> list) {
        Set<Menu> set = new HashSet<Menu>();
        List<Menu> newList = new ArrayList<Menu>();
        for (Iterator<Menu> iter = list.iterator(); iter.hasNext();) {
        	Menu element = (Menu) iter.next();
            if (set.add(element))
                newList.add(element);
        }
        return newList;
    }
	
	
	
	
}



