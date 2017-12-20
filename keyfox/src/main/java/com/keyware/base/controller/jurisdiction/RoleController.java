package com.keyware.base.controller.jurisdiction;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.keyware.base.controller.BaseController;
import com.keyware.base.repository.entity.Menu;
import com.keyware.base.repository.entity.Role;
import com.keyware.base.repository.entity.RoleMenu;
import com.keyware.base.repository.entity.RolePermission;
import com.keyware.base.repository.entity.UserRole;
import com.keyware.base.repository.entity.user.User;
import com.keyware.base.service.itf.auditlog.AuditLogService;
import com.keyware.base.service.itf.jurisdiction.MenuService;
import com.keyware.base.service.itf.jurisdiction.PermissionService;
import com.keyware.base.service.itf.jurisdiction.RoleService;
import com.keyware.base.service.itf.user.UserService;
import com.keyware.base.task.util.AjaxMessage;
import com.keyware.base.utils.Constant;
import com.keyware.base.vo.menu.MenuPermissionVo;
import com.keyware.base.vo.user.UserVo;
import com.keyware.utils.DateUtils;
import com.keyware.utils.IdGenerator;
import com.keyware.utils.JsonUtils;
import com.keyware.utils.PaginationUtil;

/**
 * 
 * 此类描述的是：   	角色管理
 * @author: 赵亚舟   
 * @version: 2016年6月23日 上午9:10:36
 */
@Controller
@RequestMapping("/role/")
public class RoleController extends BaseController{
	
	public static Logger logger = Logger.getLogger(RoleController.class);
	
	@Autowired
	private RoleService roleService;
	
	@Autowired
	private MenuService menuService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private AuditLogService auditLogService;
	@Autowired
	private PermissionService permissionService;
	
	/**
	 * 
	 * @Title: roleList
	 * @Description: 角色管理
	 * @return
	 * @return ModelAndView
	 */
	@RequestMapping(value = "roleList",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public ModelAndView roleList(){
		ModelAndView modelAndView = new ModelAndView();
		String userId = (String)request.getSession().getAttribute("userId");
		modelAndView.setViewName("jurisdiction/role/roleList");
		modelAndView.addObject("userId", userId);
		return modelAndView;
	}
	
	/**
	 * 
	 * @Title: getRoleList
	 * @Description: 获取分页数据
	 * @return
	 * @return PaginationUtil
	 */
	@RequestMapping(value = "getRoleList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getRoleList(@ModelAttribute Role role){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		if("请输入角色名称...".equals(role.getRoleName()))     // 内容与信息保持一致：搜索您想寻找的... ==  请输入角色名称...
			role.setRoleName(null);
		
		if("sysadmin".equals(getUser_idFormSession("userId")))
			role.setIsSys("sysadmin");
		
		List<Role> selectByRole = roleService.selectByRole(role);
		paginationUtil.after(selectByRole);
		return paginationUtil;
	}
	
	/**
	 * 
	 * @Title: addRole
	 * @Description: 添加角色弹出层
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "addRole",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String addRole(){
		
		return "jurisdiction/role/addRole";
	}
	
	/**
	 * 
	 * @Title: insertRole
	 * @Description: 保存角色
	 * @param role
	 * @return
	 * @return AjaxMessage
	 */
	@RequestMapping(value = "insertRole",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage insertRole(@ModelAttribute Role role){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			if(StringUtils.hasText(role.getRoleId())){
				//修改
				
				Role roleSelect = new Role();
				roleSelect.setRoleCode(role.getRoleCode());
				List<Role> selectByRole = roleService.selectByRoleSelect(roleSelect );
				if(selectByRole.size() > 0){
					if(!role.getRoleId().equals(selectByRole.get(0).getRoleId())){
						ajaxMessage.setCode("0");
						ajaxMessage.setMessage("角色编号已存在");
						return ajaxMessage;
					}
				}
				Role roleSelect1 = new Role();
				roleSelect1.setRoleName(role.getRoleName());
				List<Role> selectByRole1 = roleService.selectByRoleSelect(roleSelect1 );
				if(selectByRole1.size() > 0){
					if(!role.getRoleId().equals(selectByRole1.get(0).getRoleId())){
						ajaxMessage.setCode("0");
						ajaxMessage.setMessage("角色名称已存在");
						return ajaxMessage;
					}
					
				}
				roleService.updateByPrimaryKeySelective(role);
				ajaxMessage.setCode("1");
				ajaxMessage.setMessage("修改成功");
				ajaxMessage.setData(role.getRoleId());
				//插入日志
				auditLogService.insertLog("修改角色", "角色管理", getUser_idFormSession("userName")+"修改"+role.getRoleName()+"角色信息", request);
				
			}else{
				Role roleSelect = new Role();
				roleSelect.setRoleCode(role.getRoleCode());
				List<Role> selectByRole = roleService.selectByRoleSelect(roleSelect );
				if(selectByRole.size() > 0){
					ajaxMessage.setCode("0");
					ajaxMessage.setMessage("角色编号已存在");
					return ajaxMessage;
				}
				Role roleSelect1 = new Role();
				roleSelect1.setRoleName(role.getRoleName());
				List<Role> selectByRole1 = roleService.selectByRoleSelect(roleSelect1 );
				if(selectByRole1.size() > 0){
					ajaxMessage.setCode("0");
					ajaxMessage.setMessage("角色名称已存在");
					return ajaxMessage;
				}
				//添加
				role.setRoleId(IdGenerator.uuid32());
				role.setCreateTime(DateUtils.formatDateTime(new Date()));
				role.setIsSys("0");
				roleService.insertSelective(role);
				ajaxMessage.setCode("1");
				ajaxMessage.setMessage("保存成功");
				ajaxMessage.setData(role.getRoleId());
				//插入日志
				auditLogService.insertLog("添加角色", "角色管理", getUser_idFormSession("userName")+"新增"+role.getRoleName()+"角色权限", request);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e);
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage(Constant.ERROE_MESSAGE);
		}
		return ajaxMessage;
	}
	
	/**
	 * 
	 * @Title: deleRole
	 * @Description: 批量删除角色
	 * @param roleIds
	 * @return
	 * @return HashMap<String,String>
	 */
	@RequestMapping(value = "deleRole",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> deleRole(String roleIds){
		HashMap<String, String> map = new HashMap<String, String>();
		try {
			if(StringUtils.hasText(roleIds)){
				String[] split = roleIds.split(",");
				String roleNames = "";
				for(String roleId : split){
					Role selectByPrimaryKey = roleService.selectByPrimaryKey(roleId);
					roleNames+= selectByPrimaryKey.getRoleName()+",";
				}
				
				for(String roleId : split){
					roleService.deleteByRoleId(roleId);
				}
				
				if(roleNames.length() > 0){
					//插入日志
					auditLogService.insertLog("删除角色", "角色管理", getUser_idFormSession("userName")+"删除"+roleNames.substring(0, roleNames.length()-1)+"角色", request);
				}
				
				map.put("message", "删除成功");
			}
		} catch (Exception e) {
			map.put("message", Constant.ERROE_MESSAGE);
			logger.error(e);
		}
		return map;
	}
	
	/**
	 * 
	 * @Title: showDetail
	 * @Description: 角色详情弹出框
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "showDetail",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showDetail(String roleId,String status){
		request.setAttribute("roleId", roleId);
		request.setAttribute("status", status);
		return "jurisdiction/role/showDetail";
	}
	
	
	
	/**
	 * 
	 * @Title: showDetail
	 * @Description: 角色详情弹出框
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "showRoleInfo",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showRoleInfo(String roleId){
		request.setAttribute("roleId", roleId);
		if(StringUtils.hasText(roleId)){
			Role selectByPrimaryKey = roleService.selectByPrimaryKey(roleId);
			request.setAttribute("roleInfo", selectByPrimaryKey);
		}
		return "jurisdiction/role/addRole";
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showUserByRoleId
	 * @Description: 查看角色下所有成员
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "showUserByRoleId",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showUserByRoleId(String roleId){
		request.setAttribute("roleId", roleId);
		return "jurisdiction/role/showRoleUser";
	}
	
	
	@RequestMapping(value = "getRoleUserList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getRoleUserList(@ModelAttribute Role role){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		List<UserVo> selectByRole = roleService.selectRoleUserByRoleId(role.getRoleId());
		paginationUtil.after(selectByRole);
		return paginationUtil;
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showAccredit
	 * @Description: 展示所有的菜单和权限点
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "showAccredit",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showAccredit(){
		String roleId = request.getParameter("roleId");
		String status = request.getParameter("status");
		request.setAttribute("status", status);
		Role role = roleService.selectByPrimaryKey(roleId);
		String userId = (String)request.getSession().getAttribute("userId");
		//获取所有一级菜单
		List<Menu> selectAllFirst = menuService.selectAllFirst();
		List<Menu> listFirst = new ArrayList<Menu>();
		listFirst.addAll(selectAllFirst);
		/*if("safesecret_".equals(role.getRoleCode())){
			for(Menu m : selectAllFirst){
				if("安全管理".equals(m.getMenuName()) || "审计管理".equals(m.getMenuName())){
					listFirst.add(m);
				}
			}
		}else if("safeaudit_".equals(role.getRoleCode())){
			for(Menu m : selectAllFirst){
				if("审计管理".equals(m.getMenuName())){
					listFirst.add(m);
				}
			}
		}else if("admin_".equals(role.getRoleCode()) || "keyware_sys_admin".equals(role.getRoleCode())){
			for(Menu m : selectAllFirst){
				if(!"安全管理".equals(m.getMenuName())){
					listFirst.add(m);
				}
			}
		}else{
			for(Menu m : selectAllFirst){
				if(!"安全管理".equals(m.getMenuName()) && !"审计管理".equals(m.getMenuName()) && !"授权管理".equals(m.getMenuName()) && !"组织管理".equals(m.getMenuName()) && !"用户管理".equals(m.getMenuName())){
					listFirst.add(m);
				}
			}
		}*/
		
		if(listFirst.size() > 0){
			Menu selectMenu = new Menu();
			if("sysadmin".equals(getUser_idFormSession("userId")))
				selectMenu.setIsSys("sysadmin");
			
			for(Menu menu : listFirst){
				selectMenu.setParentId(menu.getMenuId());
				List<Menu> childMenuList = menuService.selectByMneu(selectMenu);
				if(childMenuList.size() > 0){
					
					for (int i = 0; i <childMenuList.size(); i++) {
						Menu childMenu = childMenuList.get(i);
						if("用户系统设置".equals(childMenu.getMenuName())){
							childMenuList.remove(i);
							i=i-1;
						}else{
							List<MenuPermissionVo> menuPermissonByMenuId = menuService.getMenuPermissonByMenuId(childMenu.getMenuId());
							childMenu.setPermissions(menuPermissonByMenuId);
							selectMenu.setParentId(childMenu.getMenuId());
							List<Menu> threeMenuList = menuService.selectByMneu(selectMenu);
							for(Menu threeMenu : threeMenuList){
								List<MenuPermissionVo> menuPermissionVos = menuService.getMenuPermissonByMenuId(threeMenu.getMenuId());
								threeMenu.setPermissions(menuPermissionVos);
							}
							childMenu.setChildMenu(threeMenuList);
						}
					}
					
					
				}
				List<MenuPermissionVo> menuPermissonByMenuId = menuService.getMenuPermissonByMenuId(menu.getMenuId());
				if(menuPermissonByMenuId.size() > 0){
					menu.setPermissions(menuPermissonByMenuId);
				}
				menu.setChildMenu(childMenuList);
			}
		}
		logger.info(JsonUtils.toJson(listFirst));
		request.setAttribute("permissionString", JsonUtils.toJson(listFirst));
		request.setAttribute("roleId", roleId);
		request.setAttribute("userId", userId);
		request.setAttribute("role", role);
		return "jurisdiction/role/accredit";
	}
	
	/**
	 * @author: 赵亚舟
	 * @Title: getMenuAndPermission
	 * @Description: 查询当前用户下所有菜单和权限点
	 * @param roleId
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "getMenuAndPermission",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String getMenuAndPermission(String roleId){
		ArrayList<String> arrayList = new ArrayList<String>();
		if(StringUtils.hasText(roleId)){
			
			//先查询所有菜单
			List<RoleMenu> roleMenus = roleService.selectRoleMenuByRoleId(roleId);
			for(RoleMenu roleMenu : roleMenus){
				arrayList.add(roleMenu.getMenuId());
			}
			
			//查询角色下所有的权限点
			List<RolePermission> rolePermissions = roleService.selectRolePermissionByRoleId(roleId);
			for(RolePermission permission : rolePermissions){
				arrayList.add(permission.getPermissionId());
			}
		}
		return JsonUtils.toJson(arrayList);
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: updateMenuAndPermission
	 * @Description: 重新生成角色和权限的关联关系
	 * @param permissions
	 * @param roleId
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "updateMenuAndPermission",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String updateMenuAndPermission(String permissions,String roleId,String status){
		try {
			roleService.insertRoleMenuAndPermission(permissions,roleId);
			
			Role selectByPrimaryKey = roleService.selectByPrimaryKey(roleId);
			if("update".equals(status)){
				auditLogService.insertLog("修改角色权限", "角色管理", getUser_idFormSession("userName")+"修改"+selectByPrimaryKey.getRoleName()+"角色权限", request);
			}else{
				auditLogService.insertLog("新增角色权限", "角色管理", getUser_idFormSession("userName")+"新增"+selectByPrimaryKey.getRoleName()+"角色权限", request);
			}
			return "操作成功";
		} catch (Exception e) {
			return Constant.ERROE_MESSAGE;
		}
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showAddRoleUser
	 * @Description: 跳转到添加关联关系界面
	 * @param roleId
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "showAddRoleUser",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showAddRoleUser(String roleId){
		request.setAttribute("roleId", roleId);
		return "jurisdiction/role/showAddRoleUser";
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getAddRoleUserList
	 * @Description: 关联用户
	 * @param role
	 * @return
	 * @return PaginationUtil
	 */
	@RequestMapping(value = "getAddRoleUserList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getAddRoleUserList(@ModelAttribute Role role){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		List<User> addRoleUserList = userService.getAddRoleUserList(role);
		/*if(addRoleUserList.size()>0){
			Iterator<User> iterators=addRoleUserList.iterator();
			while(iterators.hasNext()){
				User user=iterators.next();
				if(user.getLogout()==1){
					iterators.remove();
				}
			}
		}*/
		paginationUtil.after(addRoleUserList);
		return paginationUtil;
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: saveRoleUser
	 * @Description:  保存角色用户关联关系
	 * @param userIds
	 * @param roleId
	 * @return
	 * @return AjaxMessage
	 */
	@RequestMapping(value = "saveRoleUser",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage saveRoleUser(String userIds,String roleId){
		AjaxMessage am = new AjaxMessage();
		try {
			if(StringUtils.hasText(userIds)){
				String[] split = userIds.split(",");
				String userNames = "";
				
				Role roleInfo = roleService.selectByPrimaryKey(roleId);
				
				for(String userId : split){
					User selectByPrimaryKey = userService.selectByPrimaryKey(userId);
					userNames += selectByPrimaryKey.getUserName()+",";
				}
				
				
				for(String userId : split){
					UserRole userRole = new UserRole();
					userRole.setRoleId(roleId);
					userRole.setUserId(userId);
					userService.insertUserRole(userRole);
				}
				
				if(userNames.length() > 0){
					auditLogService.insertLog("用户关联角色", "角色管理", getUser_idFormSession("userName")+"将"+userNames.substring(0, userNames.length()-1)+"添加到"+roleInfo.getRoleName()+"的角色成员", request);
				}
				
				am.setMessage("操作成功");
			}
		} catch (Exception e) {
			logger.error(e);
			am.setMessage(Constant.ERROE_MESSAGE);
		}
		return am;
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: delUserRole
	 * @Description: 删除用户和角色的关联关系
	 * @param userIds
	 * @param roleId
	 * @return
	 * @return AjaxMessage
	 */
	@RequestMapping(value = "delUserRole",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage delUserRole(String userIds,String roleId){
		AjaxMessage am = new AjaxMessage();
		try {
			if(StringUtils.hasText(userIds)){
				String[] split = userIds.split(",");
				String userNames = "";
				for(String userId : split){
					User userInfo = userService.selectByPrimaryKey(userId);
					userNames += userInfo.getUserName()+",";
				}
				
				for(String userId : split){
					UserRole userRole = new UserRole();
					userRole.setRoleId(roleId);
					userRole.setUserId(userId);
					userService.deletetUserRole(userRole);
				}
				Role selectByPrimaryKey = roleService.selectByPrimaryKey(roleId);
				if(userNames.length() > 0){
					auditLogService.insertLog("删除角色成员", "角色管理", getUser_idFormSession("userName")+"删除"+selectByPrimaryKey.getRoleName()+"角色中"+userNames.substring(0, userNames.length()-1)+"用户", request);
				}
				
				
				am.setMessage("删除成功");
			}
		} catch (Exception e) {
			logger.error(e);
			am.setMessage(Constant.ERROE_MESSAGE);
		}
		return am;
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: checkRoleCode
	 * @Description: ajax 验证编码是否存在
	 * @return
	 * @return HashMap<String,Object>
	 */
	@RequestMapping(value = "checkRoleCode",produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> checkRoleCode(){
		String fieldId = request.getParameter("fieldId");
		String roleCode = request.getParameter("fieldValue");
		
		HashMap<String, Object> hashMap = new HashMap<String, Object>();
		hashMap.put("fieldId", fieldId);
		Role role = new Role();
		role.setRoleCode(roleCode);
		List<Role> selectByRole = roleService.selectByRole(role );
		if(selectByRole.size() > 0){
			hashMap.put("success", false);
			hashMap.put("message", "角色编码已存在");
		}else{
			hashMap.put("success", true);
//			hashMap.put("message", "验证通过");	
			hashMap.put("message", "");
		}
		return hashMap;
	}
	
}
