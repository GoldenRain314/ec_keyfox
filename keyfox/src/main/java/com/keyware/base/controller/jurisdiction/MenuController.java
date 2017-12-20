package com.keyware.base.controller.jurisdiction;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import com.keyware.base.repository.entity.MenuPermisson;
import com.keyware.base.repository.entity.Permission;
import com.keyware.base.service.itf.auditlog.AuditLogService;
import com.keyware.base.service.itf.jurisdiction.MenuService;
import com.keyware.base.service.itf.jurisdiction.PermissionService;
import com.keyware.base.utils.Constant;
import com.keyware.base.vo.menu.MenuPermissionVo;
import com.keyware.utils.IdGenerator;
import com.keyware.utils.PaginationUtil;

/**
 * 
 * 此类描述的是：   	菜单管理
 * @author: 赵亚舟   
 * @version: 2016年6月16日 下午1:49:11
 */
@Controller
@RequestMapping("/menu/")
public class MenuController extends BaseController{

	@Autowired
	private MenuService menuService;
	
	@Autowired
	private AuditLogService auditLogService;
	
	@Autowired
	private PermissionService permissionService;
	
	
	/**
	 * 
	 * @author:赵亚舟
	 * @Title: getMenuList
	 * @Description: 跳转到菜单管理
	 * @return
	 * @return ModelAndView
	 */
	@RequestMapping(value = "getMenuList",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public ModelAndView getMenuList(){
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jurisdiction/menu/menuList");
		return modelAndView;
	}
	
	/**
	 * 
	 * @Title: sendGoodsList
	 * @Description: 菜单管理分页
	 * @param menu
	 * @param request
	 * @return
	 * @return PaginationUtil
	 */
	@RequestMapping(value="getMenuListData",method=RequestMethod.POST,produces="application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil sendGoodsList(@ModelAttribute Menu menu, HttpServletRequest request){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		if("搜索您想寻找的...".equals(menu.getMenuName()))
			menu.setMenuName(null);
		
		if("sysadmin".equals(getUser_idFormSession("userId")))
			menu.setIsSys("sysadmin");
		
		List<Menu> selectAll = menuService.selectByMneu(menu);
		
		paginationUtil.after(selectAll);
		return paginationUtil;
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: addMenu
	 * @Description: 跳转到选项卡界面界面
	 * @return
	 * @return HashMap<String,String>
	 */
	@RequestMapping(value="showAddMenu",method=RequestMethod.GET,produces="application/json; charset=utf-8")
	public String showAddMenu(String menuId){
		
		request.setAttribute("menuId", menuId);
		
		return "jurisdiction/menu/showMenuDetail";
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: addMenu
	 * @Description: 跳转到详细信息界面
	 * @return
	 * @return HashMap<String,String>
	 */
	@RequestMapping(value="showMenuInfo",method=RequestMethod.GET,produces="application/json; charset=utf-8")
	public String showMenuInfo(String menuId){
		
		request.setAttribute("menuId", menuId);
		
		if(StringUtils.hasText(menuId)){
			Menu menuInfo = menuService.selectByPrimaryKey(menuId);
			request.setAttribute("menuInfo", menuInfo);
		}
		
		List<Menu> selectAllFirst = menuService.selectAllFirst();
		List<Menu> selectAllSecond = menuService.selectAllSecond();
		selectAllFirst.addAll(selectAllSecond);
		if(selectAllFirst != null)
			request.setAttribute("firstMenuList", selectAllFirst);
		
		return "jurisdiction/menu/addMenu";
	}
	
	
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: insertMenu
	 * @Description: 保存菜单
	 * @return
	 * @return HashMap<String,String>
	 */
	@RequestMapping(value="insertMenu",method=RequestMethod.POST,produces="application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> insertMenu(@ModelAttribute Menu menu){
		HashMap<String, String> map = new HashMap<String, String>();
		try {
			if(StringUtils.hasText(menu.getMenuId())){
				//设置等级
				Long level= 0L;
				if(StringUtils.hasText(menu.getParentId())){
					Long parentLevel = menuService.selectByPrimaryKey(menu.getParentId()).getMenuLevel();
					level = parentLevel + Long.valueOf(1);
				}else{
					level = Long.valueOf(1);
				}
				menu.setMenuLevel(level);
				//menu.setMenuLevel(StringUtils.hasText(menu.getParentId()) ? Long.valueOf(2) : Long.valueOf(1));
				menu.setParentId(StringUtils.hasText(menu.getParentId()) ? menu.getParentId() : "0");
				menuService.updateByPrimaryKeySelective(menu);
				
				auditLogService.insertLog("修改菜单信息", "菜单管理", getUser_idFormSession("userName")+"修改"+menu.getMenuName()+"菜单信息", request);
				
			}else{
				//添加
				menu.setMenuId(IdGenerator.uuid32());
				//设置等级
				Long level= 0L;
				if(StringUtils.hasText(menu.getParentId())){
					Long parentLevel = menuService.selectByPrimaryKey(menu.getParentId()).getMenuLevel();
					level = parentLevel + Long.valueOf(1);
				}else{
					level = Long.valueOf(1);
				}
				//menu.setMenuLevel(StringUtils.hasText(menu.getParentId()) ? Long.valueOf(2) : Long.valueOf(1));
				menu.setMenuLevel(level);
				menu.setStatus("0");
				menu.setParentId(StringUtils.hasText(menu.getParentId()) ? menu.getParentId() : "0");
				menuService.insertSelective(menu);
				
				auditLogService.insertLog("新增菜单", "菜单管理", getUser_idFormSession("userName")+"新增"+menu.getMenuName()+"菜单", request);
			}
			map.put("code", "1");
			map.put("message", "操作成功");
			map.put("menuId", menu.getMenuId());
		} catch (Exception e) {
			map.put("code", "0");
			map.put("message", Constant.ERROE_MESSAGE);
		}
		return map;
	}
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: delMenu
	 * @Description: 删除菜单
	 * @return
	 * @return HashMap<String,String>
	 */
	@RequestMapping(value="delMenu",method=RequestMethod.POST,produces="application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> delMenu(){
		HashMap<String, String> map = new HashMap<String, String>();
		String menuIds = request.getParameter("menuIds");
		if(StringUtils.hasText(menuIds)){
			String[] split = menuIds.split(",");
			String menuNames = "";
			for(String menuId : split){
				Menu menuInfo = menuService.selectByPrimaryKey(menuId);
				//删除 权限 菜单 关联关系表
				menuService.deleteByMenuId(menuId);
				
				menuNames+= menuInfo.getMenuName()+",";
			}
			
			if(menuNames.length() > 0){
				auditLogService.insertLog("删除菜单", "菜单管理", getUser_idFormSession("userName")+"删除"+menuNames.substring(0, menuNames.length()-1)+"菜单", request);
			}
			
			map.put("message", "操作成功");
		}
		return map;
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showMenuPermission
	 * @Description: 跳转到菜单权限
	 * @param menuId
	 * @return
	 * @return String
	 */
	@RequestMapping(value="showMenuPermission",method=RequestMethod.GET,produces="application/json; charset=utf-8")
	public String showMenuPermission(String menuId){
		request.setAttribute("menuId", menuId);
		return "jurisdiction/menu/showMenuPermission";
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getMenuPermissionList
	 * @Description: 菜单权限分页
	 * @param menu
	 * @return
	 * @return PaginationUtil
	 */
	@RequestMapping(value="getMenuPermissionList",method=RequestMethod.POST,produces="application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getMenuPermissionList(@ModelAttribute Menu menu){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		
		List<MenuPermissionVo> menuPermissonByMenuId = menuService.getMenuPermissonByMenuId(menu.getMenuId());
		
		paginationUtil.after(menuPermissonByMenuId);
		return paginationUtil;
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showMenuPermission
	 * @Description: 跳转到菜单权限
	 * @param menuId
	 * @return
	 * @return String
	 */
	@RequestMapping(value="showAddPermission",method=RequestMethod.GET,produces="application/json; charset=utf-8")
	public String showAddPermission(String menuId){
		request.setAttribute("menuId", menuId);
		return "jurisdiction/menu/showAddPermission";
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: insertMenuPermission
	 * @Description: 保存菜单和权限的关联关系
	 * @return
	 * @return HashMap<String,String>
	 */
	@RequestMapping(value="insertMenuPermission",method=RequestMethod.POST,produces="application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> insertMenuPermission(String permissionIds,String menuId){
		HashMap<String, String> hashMap = new HashMap<String, String>();
		if(StringUtils.hasText(menuId) && StringUtils.hasText(permissionIds)){
			String[] split = permissionIds.split(",");
			
			String permissionNames = "";
			for(String permissionId : split){
				Permission selectByPrimaryKey = permissionService.selectByPrimaryKey(permissionId);
				permissionNames += selectByPrimaryKey.getPermissionName()+",";
			}
			
			Menu menuInfo = menuService.selectByPrimaryKey(menuId);
			for(String permissionId : split){
				MenuPermisson menuPermisson = new MenuPermisson();
				menuPermisson.setMenuId(menuId);
				menuPermisson.setPermissionId(permissionId);
				menuService.insertMenuPermission(menuPermisson);
			}
			
			if(permissionNames.length() > 0){
				auditLogService.insertLog("关联菜单权限", "菜单管理", getUser_idFormSession("userName")+"将"+permissionNames.substring(0, permissionNames.length()-1)+"权限关联到"+menuInfo.getMenuName()+"菜单中", request);
			}
			
			hashMap.put("message", "操作成功");
		}else{
			hashMap.put("message", Constant.ERROE_MESSAGE);
		}
		return hashMap;
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: insertMenuPermission
	 * @Description: 删除菜单和权限的关联关系
	 * @return
	 * @return HashMap<String,String>
	 */
	@RequestMapping(value="delPermission",method=RequestMethod.POST,produces="application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> delPermission(String permissionIds,String menuId){
		HashMap<String, String> hashMap = new HashMap<String, String>();
		if(StringUtils.hasText(menuId) && StringUtils.hasText(permissionIds)){
			String[] split = permissionIds.split(",");
			
			String permissionNames = "";
			for(String permissionId : split){
				Permission selectByPrimaryKey = permissionService.selectByPrimaryKey(permissionId);
				permissionNames += selectByPrimaryKey.getPermissionName()+",";
			}
			
			Menu menuInfo = menuService.selectByPrimaryKey(menuId);
			
			for(String permissionId : split){
				MenuPermisson menuPermisson = new MenuPermisson();
				menuPermisson.setMenuId(menuId);
				menuPermisson.setPermissionId(permissionId);
				menuService.deleteMenuPermission(menuPermisson);
			}
			
			if(permissionNames.length() > 0){
				auditLogService.insertLog("删除菜单权限", "菜单管理", getUser_idFormSession("userName")+"删除"+menuInfo.getMenuName()+"菜单下"+permissionNames.substring(0, permissionNames.length()-1)+"按钮权限", request);
			}
			
			hashMap.put("message", "操作成功");
		}else{
			hashMap.put("message", Constant.ERROE_MESSAGE);
		}
		return hashMap;
	}
	/**
	 * 
	 * @author: 代钢
	 * @Title: selectMeunNameByMenuId
	 * @Description: 根据menuId获取menuName
	 * @return
	 */
	@RequestMapping(value="selectMeunNameByMenuId",method=RequestMethod.POST,produces="application/json; charset=utf-8")
	@ResponseBody
	public String selectMeunNameByMenuId(){
		String menuId = request.getParameter("menuId") == null ? "" : request.getParameter("menuId");
		Menu menu = menuService.selectByPrimaryKey(menuId);
		return menu.getMenuName();
	}
	
	
}
