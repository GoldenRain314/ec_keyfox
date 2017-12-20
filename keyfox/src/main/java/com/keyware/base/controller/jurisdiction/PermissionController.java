package com.keyware.base.controller.jurisdiction;

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
import com.keyware.base.repository.entity.Permission;
import com.keyware.base.service.itf.jurisdiction.PermissionService;
import com.keyware.base.utils.Constant;
import com.keyware.utils.IdGenerator;
import com.keyware.utils.PaginationUtil;

/**
 * 
 * 此类描述的是：   	权限 管理
 * @author: 赵亚舟   
 * @version: 2016年6月30日 上午11:01:30
 */
@Controller
@RequestMapping("/permission/")
public class PermissionController extends BaseController{

	public static Logger logger = Logger.getLogger(PermissionController.class);
	
	@Autowired
	private PermissionService permissionService;

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: permissionList
	 * @Description: 跳转到权限管理
	 * @return
	 * @return ModelAndView
	 */
	@RequestMapping(value = "permissionList",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public ModelAndView permissionList(){
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jurisdiction/permission/permissionList");
		return modelAndView;
	}
	
	/**
	 * 
	 * @Title: getRoleList
	 * @Description: 获取分页数据
	 * @return
	 * @return PaginationUtil
	 */
	@RequestMapping(value = "getPermissionList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getPermissionList(@ModelAttribute Permission permission){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		
		if("搜索您想寻找的...".equals(permission.getPermissionName()))
			permission.setPermissionName(null);
		
		if("sysadmin".equals(getUser_idFormSession("userId")))
			permission.setIsSys("sysadmin");
		
		List<Permission> selectByPermission = permissionService.selectByPermission(permission);
		paginationUtil.after(selectByPermission);
		return paginationUtil;
	}
	
	/**
	 * 
	 * @Title: getRoleList
	 * @Description: 获取分页数据
	 * @return
	 * @return PaginationUtil
	 */
	@RequestMapping(value = "getNoMenuPermissionList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getNoMenuPermissionList(@ModelAttribute Permission permission){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		List<Permission> selectByPermission = permissionService.getNoMenuPermissionList();
		paginationUtil.after(selectByPermission);
		return paginationUtil;
	}

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showAddPermission
	 * @Description: 跳转到添加权限界面
	 * @return
	 * @return ModelAndView
	 */
	@RequestMapping(value = "showAddPermission",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public ModelAndView showAddPermission(String permissionId){
		ModelAndView modelAndView = new ModelAndView();
		if(StringUtils.hasText(permissionId)){
			Permission selectByPrimaryKey = permissionService.selectByPrimaryKey(permissionId);
			request.setAttribute("permissionInfo", selectByPrimaryKey);
		}
		modelAndView.setViewName("jurisdiction/permission/addPermission");
		return modelAndView;
	}

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: insertPermission
	 * @Description: 插入数据
	 * @param permission
	 * @return
	 * @return HashMap<String,String>
	 */
	@RequestMapping(value = "insertPermission",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> insertPermission(@ModelAttribute Permission permission){
		HashMap<String, String> hashMap = new HashMap<String, String>();
		try {
			if(permission != null){
				if(StringUtils.hasText(permission.getPermissionId())){
					//修改
					permissionService.updateByPrimaryKeySelective(permission);
					hashMap.put("code", "1");
					hashMap.put("message", "操作成功");
				}else{
					//插入
					permission.setPermissionId(IdGenerator.uuid32());
					permissionService.insertSelective(permission);
					hashMap.put("code", "1");
					hashMap.put("message", "操作成功");
				}
			}else{
				hashMap.put("code", "0");
				hashMap.put("message", Constant.ERROE_MESSAGE);
			}
		} catch (Exception e) {
			hashMap.put("code", "0");
			hashMap.put("message", Constant.ERROE_MESSAGE);
		}
		return hashMap;
	}
	
	
	@RequestMapping(value = "delePermission",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> delePermission(){
		HashMap<String, String> hashMap = new HashMap<String, String>();
		String permissionIds = request.getParameter("permissionIds");
		if(StringUtils.hasText(permissionIds)){
			String[] split = permissionIds.split(",");
			for(String id : split){
				//删除权限点
				permissionService.deletePermissionCorrelationByPermissionId(id);
			}
			hashMap.put("message", "操作成功");
		}else{
			hashMap.put("message", Constant.ERROE_MESSAGE);
		}
		return hashMap;
	}
	
}
