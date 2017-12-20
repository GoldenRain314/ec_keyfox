package com.keyware.base.controller.user;


import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.HashSet;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.keyware.base.controller.BaseController;
import com.keyware.base.repository.entity.department.Department;
import com.keyware.base.repository.entity.safemanagement.SafeManagement;
import com.keyware.base.repository.entity.user.User;
import com.keyware.base.service.itf.auditlog.AuditLogService;
import com.keyware.base.service.itf.department.DepartmentService;
import com.keyware.base.service.itf.jurisdiction.MenuService;
import com.keyware.base.service.itf.number.NumberBuilderService;
import com.keyware.base.service.itf.safemanagement.SafeManagementService;
import com.keyware.base.service.itf.user.UserService;
import com.keyware.base.task.util.AjaxMessage;
import com.keyware.base.utils.Constant;
import com.keyware.utils.DateUtils;
import com.keyware.utils.EncryptUtil;
import com.keyware.utils.IdComposeListUtil;
import com.keyware.utils.IdGenerator;
import com.keyware.utils.JsonUtils;
import com.keyware.utils.PaginationUtil;

@Controller
@RequestMapping("/userController")
public class UserController extends BaseController{
	public static Logger logger = Logger.getLogger(UserController.class);
	@Autowired
	private UserService userService;
	@Resource
	private AuditLogService auditLogService;
	@Autowired
	private SafeManagementService safeManagementService;
	@Autowired
	private MenuService menuService;
	@Autowired
	private NumberBuilderService numberBuilderService;
	@Autowired
	private DepartmentService departmentService;
	
	@RequestMapping(value="/showIndexPageBody",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showIndexPageBody(){
		
		return "portal/home_body";
	}
	
	@RequestMapping(value="/showUserList",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showUserList(){
		
		return "portal/showUserList";
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转用户列表页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value={"/user"})
	public String userPage(){
		return "user/userList";
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转用户列表页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value={"/logoutUser"})
	public String logoutUserPage(){
		return "user/logoutUserList";
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转用户列表页面
	 * @return
	 *@date 2016-06-30
	 */
	@RequestMapping(value={"/userPwdResetPage"})
	public String userPwdResetListPage(){
		return "user/userPwdResetList";
	}
	
	/**
	 *@author 申鹏飞
	 *@title 跳转用户管理添加页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/addPage" })
	public String addPage(){
		List<SafeManagement> list=safeManagementService.selectInfo();
		SafeManagement safeManagement = list.get(0);
		request.setAttribute("userNumber", numberBuilderService.getUserNumber());
		Long pwdMinLength=(long) 0;
		Long pwdMaxLength=(long) 0;
		if(safeManagement!=null){
			pwdMinLength=safeManagement.getMinimumPwdLength();
			pwdMaxLength=safeManagement.getMaximumPwdLength();
			request.setAttribute("pwdMinLength",pwdMinLength );
			request.setAttribute("pwdMaxLength", pwdMaxLength);
		}
		return "user/userAddPage";	
	}
	/**
	 *@author 申鹏飞
	 *@title 添加用户管理信息
	 *@param user
	 * @return
	 *@date 2016-06-29
	 */
	@RequestMapping(value="/add",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage add(@ModelAttribute User user){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			List<User> selectByUserNumber = userService.selectByUserNumber(user.getUserNumber());
			if(selectByUserNumber.size() > 0){
				ajaxMessage.setCode("0");
				ajaxMessage.setMessage("员工编号已存在");     // 修改提示信息与内容保持一致，‘用户编号已存在’--‘员工编号已存在’
				return ajaxMessage;
			}
			
			Integer userCount = Constant.userCount;
			//如果是0的话则不做验证
			if(0 != userCount){
				List<User> selectAll = userService.selectAll(null);
				if(userCount <= selectAll.size()){
					ajaxMessage.setCode("0");
					ajaxMessage.setMessage("当前版本只允许新建"+Constant.userCount+"个用户");
					return ajaxMessage;
				}
			}
			
			user.setPasswordOld(user.getPassword());
			user.setPassword(EncryptUtil.md5(user.getPassword()));
			user.setUserCreationTime(DateUtils.getDate());
			user.setUserPwdModifTime(DateUtils.getDate());
			user.setUserStatus((long) 0);
			user.setUserLock((long) 0);
			user.setLogout((long) 0);
			user.setId(IdGenerator.uuid32());
//			int sort=userService.count()+1;
			String sort=DateUtils.getDateTimeInt();
			user.setSort(sort);
			userService.insert(user);
			//数据库中编号+1
			numberBuilderService.updateNumber("user_code");
			
			//保存用户的日志
			HttpSession session = request.getSession();
			String userName = (String) session.getAttribute("userName");
			String comments = userName + "添加了用户" + user.getUserName();
			auditLogService.insertLog("添加人员", "用户列表", comments, request);
			
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage("保存成功");
		} catch (Exception e) {
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage(Constant.ERROE_MESSAGE);
		}
		return ajaxMessage;
		
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转用户管理修改页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/editPage" })
	public String editPage(){
		String id=request.getParameter("id");
		request.setAttribute("id", id);
		User selectByPrimaryKey = userService.selectByPrimaryKey(id);
		if(selectByPrimaryKey != null)
			request.setAttribute("userInfo", selectByPrimaryKey);
		return "user/userEditPage";	
	}
	/**
	 *@author 申鹏飞
	 *@title 获取用户管理信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/viewInfo" })
	@ResponseBody
	public String viewInfo(){
		String id=request.getParameter("id");
		User user=userService.selectByPrimaryKey(id);
		return JsonUtils.objectToJsonString(user);	
	}
	/**
	 *@author 申鹏飞
	 *@title 修改用户管理信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/edit",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage edit(@ModelAttribute User user){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			List<User> selectByUserNumber = userService.selectByUserNumber(user.getUserNumber());
			if(selectByUserNumber.size() > 0){
				if(selectByUserNumber.size() == 1 ){
					User user2 = selectByUserNumber.get(0);
					if(!user2.getId().equals(user.getId())){
						ajaxMessage.setCode("0");
						ajaxMessage.setMessage("员工编号已存在");     // 修改提示信息与内容保持一致，‘用户编号已存在’--‘员工编号已存在’
						return ajaxMessage;
					}
				}else{
					ajaxMessage.setCode("0");
					ajaxMessage.setMessage("员工编号已存在");
					return ajaxMessage;
				}
			}
			userService.updateByPrimaryKey(user);
			//修改用户的日志
			HttpSession session = request.getSession();
			String userName = (String) session.getAttribute("userName");
			String comments = userName + "修改了用户" + user.getUserName() + "的信息";
			auditLogService.insertLog("修改人员", "用户列表", comments, request);
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage("保存成功");
		} catch (Exception e) {
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage(Constant.ERROE_MESSAGE);
		}
		return ajaxMessage;
	}
	/**
	 *@author 申鹏飞
	 *@title 查询用户管理页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/select",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil selectAll(@ModelAttribute User user){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		String user_idFormSession = getUser_idFormSession("userId");
		if("sysadmin".equals(user_idFormSession))
			user.setIsSys("sysadmin");
		
		if("请输入姓名...".equals(user.getUserNameForSerch())){
			user.setUserNameForSerch(null);
		}
		user.setUserStatus(1L);
		user.setProjectSource(Constant.projectName);
		List<User> userList = userService.selectByUserInfo(user);
		paginationUtil.after(userList);
		return paginationUtil;
	}
	/**
	 *@author 申鹏飞
	 *@title 查询注销用户页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/selectLogOutUser",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil selectLogOutUser(String name){
		PaginationUtil paginationUtil=new PaginationUtil();
		paginationUtil.before(request);
		if("请输入姓名...".equals(name))     // 信息显示与内容一致 
			name = null;
		List<?> user=userService.selectLogOutUser(name);
		paginationUtil.after(user);
		return paginationUtil;
	}
	
	/**
	 *@ author 			申鹏飞
	 *@ title 			删除用户管理信息
	 *@ return
	 *@ date 2016-06-17
	 */
	@RequestMapping(value = "/delete",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String delete(){
		HttpSession session = request.getSession();
		String userName = (String) session.getAttribute("userName");
		try {
			List<String> listId=IdComposeListUtil.listId(request);
			
			String userNames = "";
			for(String id : listId){
				User u = userService.selectByPrimaryKey(id);
				if("".equals(userNames)){
					userNames = u.getUserName();
				}else{
					userNames += "," + u.getUserName();
				}
				
			}
			userService.deleteByPrimaryKey(listId);
			//删除人员日志
			String comments = userName + "删除了用户" + userNames;
			auditLogService.insertLog("删除人员", "用户列表", comments, request);
			//删除  角色 用户 关联关系表
			for(String id : listId){
				userService.deleteUserRoleByUserId(id);
			}
			return "删除成功";
			
		} catch (Exception e) {
			logger.error(e);
			return Constant.ERROE_MESSAGE;
		}
	}
	
	/**
	 *@author 申鹏飞
	 *@title 删除重置密码页面信息
	 * @return
	 *@date 2016-06-30
	 */
	@RequestMapping(value = "/delPwdResetList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String delPwdResetList(){
		HttpSession session = request.getSession();
		String userName=(String) session.getAttribute("userName");
		try {
			List<String> listId=IdComposeListUtil.listId(request);
			String userNames = "";
			for(String id : listId){
				User u = userService.selectByPrimaryKey(id);
				if("".equals(userNames)){
					userNames = u.getUserName();
				}else{
					userNames += "," + u.getUserName();
				}
			}
			userService.delPwdResetList(listId);
			//删除重置密码的日志
			String comments = userName + "删除了用户" + userNames +"初始密码信息";
			auditLogService.insertLog("删除", "初始密码", comments, request);
			return "删除成功";
		} catch (Exception e) {
			logger.error(e);
			return Constant.ERROE_MESSAGE;
		}
	}
	/**
	 *@author 申鹏飞
	 *@title 修改用户状态
	 *@return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/updateStatus",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage updateStatus(@ModelAttribute User user){
		HttpSession session = request.getSession();
		String userName=(String) session.getAttribute("userName");
		AjaxMessage ajaxMessage = new AjaxMessage();
		String ids = user.getIds();
		String userNames = "";
		String logName = "";
		if(StringUtils.hasText(ids)){
			String[] split = ids.split(",");
			for(String id : split){
				user.setId(id);
				userService.updateStatus(user);
				//记录日志
				User u = userService.selectByPrimaryKey(id);
				if("".equals(userNames)){
					userNames = u.getUserName();
				}else{
					userNames += "," + u.getUserName();
				}
				logName="open";
				if(user.getUserStatus()==1){
					logName="close";
				}
			}
			if("open".equals(logName)){
				String comments = userName + "启用了用户" + userNames;
				auditLogService.insertLog("启用", "用户列表", comments, request);
				ajaxMessage.setMessage("启用成功");
			}else if("close".equals(logName)){
				String comments = userName + "禁用了用户" + userNames;
				auditLogService.insertLog("禁用", "用户列表", comments, request);
				ajaxMessage.setMessage("禁用成功");
			}
		}
		
		return ajaxMessage;	
	}
	/**
	 *@author 申鹏飞
	 *@title 修改用户锁定状态
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/updateLock",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String updateLock(@ModelAttribute User user){
		HttpSession session = request.getSession();
		String userName = (String) session.getAttribute("userName");
		List<String> listId=IdComposeListUtil.listId(request);
		userService.unlock(listId);
		String userNames = "";
		for(int i=0;i<listId.size();i++){
			User u = userService.selectByPrimaryKey(listId.get(i));
			if("".equals(userNames)){
				userNames = u.getUserName();
			}else{
				userNames += "," + u.getUserName();
			}
		}
		String comments = userName + "将用户" + userNames + "解锁";
		auditLogService.insertLog("解锁", "用户列表", comments, request);
		return "解锁成功";	
	}
	/**
	 *@author 申鹏飞
	 *@title 获取用户登陆名和用户名
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/getUserIdName")
	@ResponseBody
	public String getUserIdName(){
		List<User> userIdNameMap=userService.getUserIdName();
		return JsonUtils.arrayListToJsonString(userIdNameMap);
	}
	/**
	 *@author 申鹏飞
	 *@title 用户注销
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/updateLogout",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String updateLogout(@ModelAttribute User user){
		List<String> listId=IdComposeListUtil.listId(request);
		HttpSession session = request.getSession();
		String userName = (String) session.getAttribute("userName");
		if("1".equals(request.getParameter("logOut"))||request.getParameter("logOut")=="1"){
			userService.updateLogout(listId);
			User userupdate = new User();
			//注销用户的日志
			String userNames = "";
			for(int i=0;i<listId.size();i++){
				User u = userService.selectByPrimaryKey(listId.get(i));
				userupdate.setId(listId.get(i));
				userupdate.setLogoutTime(DateUtils.getDateTime());
				userService.updateByPrimaryKey(userupdate);
				if("".equals(userNames)){
					userNames = u.getUserName();
				}else{
					userNames += "," + u.getUserName();
				}
			}
			String comments = userName + "注销了用户" + userNames;
			auditLogService.insertLog("注销人员", "用户列表", comments, request);
			
		}
		if(!"1".equals(request.getParameter("logOut"))&&request.getParameter("logOut")!="1"){
			Integer userCount = Constant.userCount;
			if(0 != userCount){
				List<User> selectAll = userService.selectAll(null);
				if(userCount < (selectAll.size()+listId.size()))
					return "当前版本只允许新建"+Constant.userCount+"个用户";
			}
			userService.recovery(listId);
			//还原用户的日志
			for(int i=0;i<listId.size();i++){
				User u = userService.selectByPrimaryKey(listId.get(i));
				String comments = userName + "还原了用户" + u.getUserName();
				auditLogService.insertLog("还原人员", "注销用户列表", comments, request);
			}
		}
//		user.setLogout((long) logout);
//		user=userService.selectByPrimaryKey(user.getId());
//		HttpSession session = request.getSession();
//		String userName=(String) session.getAttribute("userName");
//		String logName="还原用户";
//		String comments=userName+"将"+user.getUserName()+"还原用户 ";
//		if(logout==1){
//			logName="注销用户";
//			comments=userName+"将"+user.getUserName()+"用户注销";
//		}
//		auditLogService.insertLog(logName, "用户管理", comments,request);
		return "0";	
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转修改密码页面
	 * @return
	 *@date 2016-06-24
	 */
	@RequestMapping(value = {"/editPwdPage" })
	public String editPwdPage(){
		HttpSession session = request.getSession();
		String userId=session.getAttribute("userId").toString();
		
		List<SafeManagement> list=safeManagementService.selectInfo();
		SafeManagement safeManagement = list.get(0);
		
		request.setAttribute("userId", userId);
		Long pwdMinLength=(long) 0;
		Long pwdMaxLength=(long) 0;
		if(safeManagement!=null){
			pwdMinLength=safeManagement.getMinimumPwdLength();
			pwdMaxLength=safeManagement.getMaximumPwdLength();
		}
		request.setAttribute("pwdMinLength",pwdMinLength );
		request.setAttribute("pwdMaxLength", pwdMaxLength);

		return "user/editPwdPage";	
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转密码重置页面
	 * @return
	 *@date 2016-06-24
	 */
	@RequestMapping(value ="/userPwdResetList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil userPwdResetList(String name){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		if("请输入姓名...".equals(name))      // 内容信息与显示一致 
			name = null;
		
		List<?> user = userService.pwdResetList(name);
		paginationUtil.after(user);
		return paginationUtil;
	}
	/**
	 *@author 申鹏飞
	 *@title 修改密码
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value="/editPwd",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage editPwd(@ModelAttribute User user){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			User selectByPrimaryKey = userService.selectByPrimaryKey(getUser_idFormSession("user_id"));
			
			if(!EncryptUtil.md5(user.getPasswordOld()).equals(selectByPrimaryKey.getPassword())){
				ajaxMessage.setCode("0");
				ajaxMessage.setMessage("原密码输入不正确！");
				return ajaxMessage;
			}
			user.setId(selectByPrimaryKey.getId());
			user.setPasswordOld(user.getPasswordOld());
			user.setPassword(EncryptUtil.md5(user.getPassword()));
			user.setUserPwdModifTime(DateUtils.getDate());
			userService.updateByPrimaryKey(user);
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage("修改成功");
		} catch (Exception e) {
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage("系统错误,请联系管理员");
		}
		return ajaxMessage;
	}
	/**
	 *@author 申鹏飞
	 *@title 重置密码
	 * @return
	 *@date 2016-06-30
	 */
	@RequestMapping(value="/PwdReset",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String PwdReset(@ModelAttribute User user){
		HttpSession session = request.getSession();
		String userName = (String) session.getAttribute("userName");
		List<String> listId=IdComposeListUtil.listId(request);
		String userNames = "";
		for(int i=0;i<listId.size();i++){
			String passsword=IdGenerator.random10Str();
			user.setPassword(EncryptUtil.md5(passsword));
			user.setPasswordOld(passsword);
			user.setUserPwdModifTime(DateUtils.formatDateTime(new Date()));
			user.setInitPwdTime(DateUtils.formatDateTime(new Date()));
			user.setExitTime(DateUtils.formatDateTime(new Date()));
			user.setId(listId.get(i));
			userService.updateByPrimaryKey(user);
			
			User u = userService.selectByPrimaryKey(listId.get(i));
			if("".equals(userNames)){
				userNames = u.getUserName();
			}else{
				userNames += "," + u.getUserName();
			}
		}
		//重置密码的日志
		String comments = userName + "将" + userNames + "用户的密码重置";
		auditLogService.insertLog("重置密码", "用户列表", comments, request);
		return "重置成功";
	}
	/**
	 *@author 申鹏飞
	 *@title 排序上下位置
	 * @returnz
	 *@date 2016-06-30
	 */
	@RequestMapping(value = "/updateSort",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String updateSort(@ModelAttribute User user){
		//排序方式
		String type = request.getParameter("type");
		
		if(user != null){
			//List<User> selectAll = userService.selectAll(null);
			User selectUser = new User();
			String user_idFormSession = getUser_idFormSession("userId");
			if("sysadmin".equals(user_idFormSession))
				selectUser.setIsSys("sysadmin");
			
			if("请输入姓名...".equals(user.getUserNameForSerch())){
				selectUser.setUserNameForSerch(null);
			}
			selectUser.setUserStatus(1L);
			selectUser.setProjectSource(Constant.projectName);
			List<User> selectAll = userService.selectByUserInfo(selectUser);			
			
			int flag = 0;
			for(int i=0;i<selectAll.size();i++){
				User user2 = selectAll.get(i);
				if(user.getId().equals(user2.getId())){
					flag = i;
					break;
				}
			}
				
			if("0".equals(type)){
				if(flag == 0)
					return "无法上移";
				flag --;
			}else{
				if(flag == (selectAll.size()-1))
					return "无法下移";
				flag ++ ;
			}
			
			String sort = user.getSort();
			
			User user2 = selectAll.get(flag);
			
			User user3 = new User();
			user3.setId(user.getId());
			user3.setSort(user2.getSort());
			userService.updateSort(user3);
			user3.setId(user2.getId());
			user3.setSort(sort);
			userService.updateSort(user3);
			return "操作成功";    // 修改提示信息为 操作成功
		}

		return Constant.ERROE_MESSAGE;	
	}
	
	/**
	 *@ author 申鹏飞
	 *@ title 获取部门人员
	 *@ return
	 *@ date 2016-06-30
	 */
	@RequestMapping(value = "/selectDepartUser",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String selectDepartUser(@ModelAttribute User user){
		HashSet<User> hashSet = new HashSet<User>();
		String departId = request.getParameter("departId");
		String set_document_departId = request.getParameter("set_document_departId") == null ? "" : request.getParameter("set_document_departId");
		String source = request.getParameter("source") == null ? "" : request.getParameter("source");
		String userName = request.getParameter("value");
		logger.info("查询条件="+userName);
		
		if("sysadmin".equals(getUser_idFormSession("userId"))){
			user.setIsSys("sysadmin");
		}
		
		user.setFlag("1");
		if(!"".equals(set_document_departId)){
			Department department = departmentService.selectByPrimaryKey(set_document_departId);
			if(department != null){
				if(userName == null || "搜索您想寻找的...".equals(userName)){
					List<User> users = userService.selectDepartUser(department.getParentId());
					return JsonUtils.arrayListToJsonString(users);	
				}else{
					user.setUserNameForSerch(userName);
					//修改[#3329]BUG,搜索本部门的人只出本部门下的人员
					user.setDepartId(department.getParentId());
					user.setProjectSource(Constant.projectName);
					List<User> selectByUserInfo = userService.selectByUserInfo(user);
					return JsonUtils.arrayListToJsonString(selectByUserInfo);	
				}
			}
		}else{
			if(StringUtils.hasText(userName)){
				if(!"搜索您想寻找的...".equals(userName))
					user.setUserNameForSerch(userName);
				List<User> selectByUserInfo = userService.selectByUserInfo(user);
				hashSet.addAll(selectByUserInfo);
			}else{
				if(!"".equals(source)){
					user.setDepartId(departId);
					List<User> users = userService.selectByUserInfo(user);
					hashSet.addAll(users);
				}else{
					HashSet<String> selectByparentId = departmentService.selectByparentId(departId);
					user.setDepartId(departId);
					List<User> us = userService.selectByUserInfo(user);
					hashSet.addAll(us);
					for(String deptId : selectByparentId){
						user.setDepartId(deptId);
						List<User> users = userService.selectByUserInfo(user);
						hashSet.addAll(users);
					}
				}
				
			}
		}
		return JsonUtils.toJson(hashSet);	
	}
	
	/**
	 *@author 申鹏飞
	 *@title 获取部门人员
	 * @return
	 *@date 2016-06-30
	 */
	@RequestMapping(value = "/addUserList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String addUserList(){
		String departId=request.getParameter("departId");
		List<User> user = userService.selectDepartUser(departId);
		return JsonUtils.arrayListToJsonString(user);	
	}
	
	
	/**
	 * 
	 * @Title: showBatchImport
	 * @Description: 上传用户列表
	 * @return
	 * @author 赵亚舟
	 * @return String
	 */
	@RequestMapping(value = "/showBatchImport",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showBatchImport(String rand){
		request.setAttribute("rand", rand);
		return "/user/uploadUserExcl";
	}
	
	/**
	 * 
	 * @Title: analysisExcl
	 * @Description: 解析excl,上传用户
	 * @param multipartfile
	 * @return
	 * @author 赵亚舟
	 * @return AjaxMessage
	 */
	@ResponseBody
	@RequestMapping(value="/analysisExcl",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	public AjaxMessage analysisExcl(MultipartFile multipartfile){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			Workbook workbook = WorkbookFactory.create(multipartfile.getInputStream());
			//获取第一个sheet
			Sheet sheet = workbook.getSheetAt(0);
			//检查标题
			userService.checkFirstRowName(ajaxMessage, sheet);
			if("0".equals(ajaxMessage.getCode()))
				return ajaxMessage;
			//验证数据，并插入数据库
			HttpSession session = request.getSession();
			String userName = (String) session.getAttribute("userName");	
			String message = userService.insertUser(sheet,userName,request);
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage(message);
		} catch (Exception e) {
			e.printStackTrace();
			ajaxMessage.setCode("0");
		}
		
		return ajaxMessage;
	}

	/**
	 * 
	 * @Title: downloadExcl
	 * @Description: 下载文件
	 * @author 赵亚舟
	 * @return void
	 */
	@RequestMapping(value="/downloadExcl",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public void downloadExcl(HttpServletResponse response){
		
		try {
			String fileName = "批量导入用户模板";
			String path = request.getSession().getServletContext().getRealPath("")+File.separator+"resources"+File.separator+"model"+File.separator+fileName+".xlsx";
			File file = new File(path);
			
			InputStream fis = new BufferedInputStream(new FileInputStream(path));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);
            fis.close();
            // 清空response
            response.reset();
            
            response.setCharacterEncoding("UTF-8");
            //response.setContentType("application/vnd.ms-excel");
            response.setContentType("application/octet-stream");
            // IE  
			if (request.getHeader("user-agent").toLowerCase().contains("msie")||request.getHeader("user-agent").toLowerCase().contains("like gecko") ) {
				response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes("GB2312"), "ISO8859-1" ) +".xlsx"+ "\"");
			}else{
				response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes("utf-8"), "ISO8859-1" ) +".xlsx"+ "\"");
			}
		       
            response.addHeader("Content-Length", "" + file.length());
            OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
            toClient.write(buffer);
            toClient.flush();
            toClient.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
}
