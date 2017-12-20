package com.keyware.base.controller.safemanagement;


import java.text.ParseException;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.keyware.base.controller.BaseController;
import com.keyware.base.controller.login.LoginController;
import com.keyware.base.repository.entity.safemanagement.SafeManagement;
import com.keyware.base.repository.entity.user.User;
import com.keyware.base.service.itf.auditlog.AuditLogService;
import com.keyware.base.service.itf.safemanagement.SafeManagementService;
import com.keyware.base.service.itf.user.UserService;
import com.keyware.base.task.util.AjaxMessage;
import com.keyware.utils.DateUtils;
import com.keyware.utils.EncryptUtil;
import com.keyware.utils.IdComposeListUtil;
import com.keyware.utils.IdGenerator;
import com.keyware.utils.JsonUtils;
import com.keyware.utils.PaginationUtil;

@Controller
@RequestMapping("/safeManagementController")
public class SafeManagementController extends BaseController{
	public static Logger logger = Logger.getLogger(LoginController.class);
	
	@Resource
	private SafeManagementService safeManagementService; 
	@Resource
	private UserService userService;
	
	@Autowired
	private AuditLogService auditLogService;
	
	/**
	 *@author 申鹏飞
	 *@title 跳转安全设置管理页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/safeManagement" })
	public String safeManagentPage(){
		return "safemanagement/safeManagement";	
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转安全设置添加页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/addPage" })
	public String addPage(){
		return "safemanagement/addPage";	
	}
	
	/**
	 *@author 申鹏飞
	 *@title 添加安全设置信息
	 *@param department
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/add",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage add(@ModelAttribute SafeManagement safeManagement){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			
			List<SafeManagement> selectProjectInfo = safeManagementService.selectProjectInfo(Long.valueOf(safeManagement.getSystemLevel()));
			if(selectProjectInfo.size() > 0){
				ajaxMessage.setCode("0");
				ajaxMessage.setMessage("系统密级已存在");
				return ajaxMessage;
			}
			
			safeManagement.setId(IdGenerator.uuid32());
			safeManagementService.insert(safeManagement);
			String name = "";
			if(0 == safeManagement.getSystemLevel())
				name = "普通";
			if(1 == safeManagement.getSystemLevel())
				name = "秘密";
			if(2 == safeManagement.getSystemLevel())
				name = "机密";
			if(3 == safeManagement.getSystemLevel())
				name = "绝密";
			
			auditLogService.insertLog("添加安全设置", "安全设置", getUser_idFormSession("userName")+"添加"+name+"安全设置", request);
			
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage("保存成功");
		} catch (Exception e) {
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage("系统错误,请联系管理员");
		}
		return ajaxMessage;
	}
	
	/**
	 *@author 申鹏飞
	 *@title 跳转安全设置修改页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/editPage" })
	public String editPage(){
		String id=request.getParameter("id");
		request.setAttribute("id", id);
		return "safemanagement/editPage";	
	}
	/**
	 *@author 申鹏飞
	 *@title 获取安全设置信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/viewInfo" })
	@ResponseBody
	public String viewInfo(){
		String id=request.getParameter("id");
		SafeManagement safeManagement=safeManagementService.selectByPrimaryKey(id);
		return JsonUtils.objectToJsonString(safeManagement);	
	}
	
	/**
	 *@author 申鹏飞
	 *@title 修改安全管理信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/edit",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage edit(@ModelAttribute SafeManagement safeManagement){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			
			List<SafeManagement> selectProjectInfo = safeManagementService.selectProjectInfo(Long.valueOf(safeManagement.getSystemLevel()));
			if(selectProjectInfo.size() > 1){
				ajaxMessage.setCode("0");
				ajaxMessage.setMessage("系统密级已存在");
				return ajaxMessage;
			}else if(selectProjectInfo.size() == 1){
				if(!safeManagement.getId().equals(selectProjectInfo.get(0).getId())){
					ajaxMessage.setCode("0");
					ajaxMessage.setMessage("系统密级已存在");
					return ajaxMessage;
				}
			}
			safeManagementService.updateByPrimaryKey(safeManagement);
			String names = "";
			if(0 == safeManagement.getSystemLevel())
				names += "普通";
			if(1 == safeManagement.getSystemLevel())
				names += "秘密";
			if(2 == safeManagement.getSystemLevel())
				names += "机密";
			if(3 == safeManagement.getSystemLevel())
				names += "绝密";
			
			//插入日志 TODO
			auditLogService.insertLog("修改安全设置", "安全设置", getUser_idFormSession("userName")+"修改了"+names+"详细信息", request);
			
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage("保存成功");
		} catch (Exception e) {
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage("系统错误,请联系管理员");
		}
		return ajaxMessage;	
	}
	
	/**
	 *@author 申鹏飞
	 *@title 查询安全设置页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/select",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil select(){
		PaginationUtil paginationUtil=new PaginationUtil();
		paginationUtil.before(request);
		List<SafeManagement> safeManagement=safeManagementService.selectAll();
		paginationUtil.after(safeManagement);
		return paginationUtil;
	}
	/**
	 *@author 申鹏飞
	 *@title 删除安全设置信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/delete",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String delete(){
		List<String> listId=IdComposeListUtil.listId(request);
		
		String names = "";
		for(String id : listId){
			SafeManagement safeManagement = safeManagementService.selectByPrimaryKey(id);
			if(0 == safeManagement.getSystemLevel())
				names += "普通,";
			if(1 == safeManagement.getSystemLevel())
				names += "秘密,";
			if(2 == safeManagement.getSystemLevel())
				names += "机密,";
			if(3 == safeManagement.getSystemLevel())
				names += "绝密,";
		}
		safeManagementService.deleteByPrimaryKey(listId);
		
		if(names.length() > 0){
			auditLogService.insertLog("删除安全设置", "安全设置", getUser_idFormSession("userName")+"删除"+names.substring(0, names.length()-1)+"安全设置", request);
		}
		
		return "删除成功";
	}
	/**
	 *@author 申鹏飞
	 *@title 获取安全设置信息
	 * @return
	 *@date 2016-06-24
	 */
	@RequestMapping("/getSafeInfo")
	@ResponseBody
	public String  getSafeInfo(){
		List<SafeManagement> safeManagement=safeManagementService.selectAll();
		return JsonUtils.arrayListToJsonString(safeManagement);	
	}
	/**
	 * 
	 *@author 申鹏飞
	 *@title 安全验证信息
	 *@param
	 * @return
	 * @throws ParseException 
	 *@date 2016-06-17
	 */
	@RequestMapping(value="/logCheck",method = RequestMethod.POST,produces="application/json;charset=utf-8")
	@ResponseBody
	public String logCheck() throws ParseException{
		String userId=request.getParameter("userId");
		String password=request.getParameter("password");

		User user=userService.selectUserByUserId(userId);
		//1、判断用户名是否正确
		if(user==null){
			return "用户名输入错误！";
		}
		//2、判断是否为admin
		if(user.getUserId().equals("admin")||"admin"==user.getUserId()){
			String passwordED5=user.getPassword();
			//验证密码是否正确
			if(EncryptUtil.md5(password).equals(passwordED5)||passwordED5==EncryptUtil.md5(password)){
				return "0";
			}else{
				return "密码输出错误";
			}
		}else{
			//3、判断用户是否被禁用或者锁定
			if(user.getUserStatus().equals("1")||1==user.getUserStatus()){
				return "用户被禁用！";
			}
			if(1==user.getUserLock()||user.getUserLock().equals("1")){
				return "该用户已锁定,请联系安全管理员解锁!";
			}
			//4、验证密码是否正确
			String passwordED5=user.getPassword();

			List<SafeManagement> list=safeManagementService.selectInfo();
			SafeManagement safeManagement = list.get(0);
			
			if(EncryptUtil.md5(password).equals(passwordED5)||passwordED5==EncryptUtil.md5(password)){
				//5、密码正确，至空错误次数和错误日期
				user.setUserPwdError((long) 0);
				user.setUserPwdErrorDate(null);
				userService.updateByPrimaryKey(user);
				//5.1、验证是否超过非活跃时间
				
				//5.2、获取非活跃时间限定值
				long userInactiveTime=0;
				if(!safeManagement.equals(null)&&safeManagement.getUserInactiveTime()!=null&&!"".equals(safeManagement.getUserInactiveTime())){
					userInactiveTime=safeManagement.getUserInactiveTime();
				}
				//5.3获取上一次退出的时间
//				String exitTime=DateUtils.getDate();
				String exitTime=user.getExitTime();
				//5.4本次登录的时间-上一次退出时间=非活动时间范围是否大于限定值
				//5.5判断是否锁定该用户
				if(userInactiveTime!=0&&!"".equals(exitTime)&&null!=exitTime){
					long between_days=DateUtils.betweenDays(exitTime, DateUtils.getDate());
					//5.6判断非活动时间范围是否大于限定值
					if(between_days>userInactiveTime){
						//5.7更新退出时间为当前时间，并锁定用户
						user.setUserLock((long) 1);
						userService.updateByPrimaryKey(user);
						return "用户超出非活跃规定时间,锁定用户";
					}
				}
				//5.8更新退出时间
				user.setExitTime(DateUtils.getDate());
				userService.updateByPrimaryKey(user);
				return "0";
			}else{
				//6.密码不正确
				Long errorTime=user.getUserPwdError();
				String errorDate=user.getUserPwdErrorDate();
				if(errorDate!=null){
					if(errorDate.equals(DateUtils.getDate())){
						errorTime+=1;
						long pwd_lockTimes=0;
						if(!safeManagement.equals(null)&&safeManagement.getPwdLocktimes()!=null&&!"".equals(safeManagement.getPwdLocktimes())){
							pwd_lockTimes=safeManagement.getPwdLocktimes();
						}
						if(pwd_lockTimes!=0){
							if(errorTime>=pwd_lockTimes){
								user.setUserLock((long) 1);
								userService.updateByPrimaryKey(user);
								return "密码错误次数达到限定值"+pwd_lockTimes+"次,用户被锁定";
							}else{
								return "密码错误";
							}
						}
					}else{
						errorTime=(long) 1;
						errorDate=DateUtils.getDate();
						user.setUserPwdError(errorTime);
						user.setUserPwdErrorDate(errorDate);
						userService.updateByPrimaryKey(user);
					}
				}
				else{
					errorTime=(long) 1;
					errorDate=DateUtils.getDate();
					user.setUserPwdError(errorTime);
					user.setUserPwdErrorDate(errorDate);
					userService.updateByPrimaryKey(user);
				}
				return "密码输出错误";
			}
			
		}
		
	}


}
