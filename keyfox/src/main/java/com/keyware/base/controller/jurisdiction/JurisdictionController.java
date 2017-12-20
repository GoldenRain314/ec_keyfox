package com.keyware.base.controller.jurisdiction;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.keyware.base.controller.BaseController;
import com.keyware.base.repository.entity.Menu;
import com.keyware.base.service.itf.jurisdiction.MenuService;
import com.keyware.base.task.util.AjaxMessage;
import com.keyware.base.utils.Constant;
import com.keyware.base.vo.menu.menuVo;
import com.keyware.utils.JsonUtils;
import com.keyware.utils.PaginationUtil;

/**
 * 
 * 此类描述的是：   	授权管理
 * @author: 赵亚舟   
 * @version: 2016年6月20日 上午11:14:50
 */
@Controller
@RequestMapping("/jurisdiction")
public class JurisdictionController extends BaseController{

	@Autowired
	private MenuService menuService;
	/*@Autowired
	private OrganizeassetsService organizeassetsService;*/
	
	public static Logger logger = Logger.getLogger(JurisdictionController.class);
	
	/**
	 * 
	 * @Title: menuList	
	 * @Description: 授权列表
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "/menuList",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String menuList(String menuId){
		try {
			String userId = (String) request.getSession().getAttribute("userId");
			String clickNodeId = request.getParameter("clickNodeId");
			
			Menu selectByPrimaryKey = menuService.selectByPrimaryKey(menuId);
			if(selectByPrimaryKey != null){
				request.setAttribute("menuInfo", selectByPrimaryKey);
			}
			
			String isSys = "";
			if("sysadmin".equals(getUser_idFormSession("userId")))
				isSys = "sysadmin";
			
			//查询二级权限
			List<menuVo> twolelve = menuService.getTheTwoLevelMenuBasedOnTheAccountID(userId, menuId,isSys);

			List<menuVo> removeDuplicate = this.removeDuplicate(twolelve);
			for(int i=0;i<removeDuplicate.size();i++){
				//查询三级权限
				menuVo vo = removeDuplicate.get(i);
				String id = vo.getMenuId();
				List<menuVo> threelevel = menuService.getThreeTheLevelMenuBasedOnTheAccountID(userId, id);
				if(threelevel.size() > 0){
					removeDuplicate.addAll(this.removeDuplicate(threelevel));
				}
				
			}
			
			if (StringUtils.hasText(clickNodeId)){
				request.setAttribute("needExpandNodeId", clickNodeId);
			}else if("组织资产".equals(selectByPrimaryKey.getMenuName())){
				request.setAttribute("needExpandNodeId", "zuzhizichan");
			}else  if(removeDuplicate.size() > 0){
				request.setAttribute("needExpandNodeId", removeDuplicate.get(0).getMenuId());
			}
			request.setAttribute("menuList", JsonUtils.toJson(removeDuplicate));
			
		} catch (Exception e) {
			logger.error(e);
		}
		if("KD".equals(Constant.projectName))
			return "portal/home_body";
		else if("KT".equals(Constant.projectName))
			return "kt/portal/home_body";
		
		return "portal/home_body";
	}
	
	/**
	 * 
	 * @Title: menuList	
	 * @Description: 组织资产引用
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "/organize",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String organize(){
		try {
			String userId = (String) request.getSession().getAttribute("userId");
			Menu  menu =menuService.selectByName("组织资产");			
			String menuId = menu.getMenuId();
			Menu selectByPrimaryKey = menuService.selectByPrimaryKey(menuId);
			String sectionId= request.getParameter("sectionId") == null ? "" : request.getParameter("sectionId");
			request.setAttribute("sectionId", sectionId);
			String source = request.getParameter("source") == null ? "" : request.getParameter("source");
			//source:documentEdit
			request.setAttribute("source", source);
			String setPageSize = request.getParameter("setPageSize") == null ? "" : request.getParameter("setPageSize");
			//setPageSize:50
			request.setAttribute("setPageSize", setPageSize);
			if(selectByPrimaryKey != null){
				request.setAttribute("menuInfo", selectByPrimaryKey);
			}
			
			String isSys = "";
			if("sysadmin".equals(getUser_idFormSession("userId")))
				isSys = "sysadmin";
			//查询二级权限
			List<menuVo> twolelve = menuService.getTheTwoLevelMenuBasedOnTheAccountID(userId, menuId,isSys);
			List<menuVo> removeDuplicate = this.removeDuplicate(twolelve);
			for(int i=0;i<removeDuplicate.size();i++){
				//查询三级权限
				menuVo vo = removeDuplicate.get(i);
				String id = vo.getMenuId();
				List<menuVo> threelevel = menuService.getThreeTheLevelMenuBasedOnTheAccountID(userId, id);
				if(threelevel.size() > 0){
					removeDuplicate.addAll(this.removeDuplicate(threelevel));
				}
				
			}
			if(removeDuplicate.size() > 0){
				request.setAttribute("needExpandNodeId", removeDuplicate.get(0).getMenuId());
			}
			request.setAttribute("menuList", JsonUtils.toJson(removeDuplicate));
			
		} catch (Exception e) {
			logger.error(e);
		}
		return "documentEdit/referOrganrize";
	}
	
	/**
	 * 
	 *	@Title 判断是否有组织资产菜单权限
	 *  @author 李涛
	 *  @param 
	 *  @date   2016年10月28日
	 *  @return AjaxMessage
	 */
	@RequestMapping(value="/judgeOrganize",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public  AjaxMessage judgeOrganize(){
		AjaxMessage ajaxMessage = new AjaxMessage();
		String userId = (String) request.getSession().getAttribute("userId");
		Menu  menu =menuService.selectByName("组织资产");			
		String menuId = menu.getMenuId();
		Menu selectByPrimaryKey = menuService.selectByPrimaryKey(menuId);
		String sectionId= request.getParameter("sectionId") == null ? "" : request.getParameter("sectionId");
		request.setAttribute("sectionId", sectionId);
		if(selectByPrimaryKey != null){
			request.setAttribute("menuInfo", selectByPrimaryKey);
		}
		
		String isSys = "";
		if("sysadmin".equals(getUser_idFormSession("userId")))
			isSys = "sysadmin";
		//查询二级权限
		List<menuVo> twolelve = menuService.getTheTwoLevelMenuBasedOnTheAccountID(userId, menuId,isSys);
		List<menuVo> removeDuplicate = this.removeDuplicate(twolelve);
		for(int i=0;i<removeDuplicate.size();i++){
			//查询三级权限
			menuVo vo = removeDuplicate.get(i);
			String id = vo.getMenuId();
			List<menuVo> threelevel = menuService.getThreeTheLevelMenuBasedOnTheAccountID(userId, id);
			if(threelevel.size() > 0){
				removeDuplicate.addAll(this.removeDuplicate(threelevel));
			}
			
		}
		if(removeDuplicate.size()>0){
			ajaxMessage.setCode("1");
		}else{
			ajaxMessage.setCode("0");
		}
		return ajaxMessage;
	}

	

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: removeDuplicate
	 * @Description: List  去重
	 * @param list
	 * @return
	 * @return List<Menu>
	 */
	private List<menuVo> removeDuplicate(List<menuVo> list) {
        Set<menuVo> set = new HashSet<menuVo>();
        List<menuVo> newList = new ArrayList<menuVo>();
        for (Iterator<menuVo> iter = list.iterator(); iter.hasNext();) {
        	menuVo element = (menuVo) iter.next();
            if (set.add(element))
                newList.add(element);
        }
        return newList;
    }
	/**
	 * 
	 * @Title: getThreeLevel	
	 * @Description: 获得三级权限列表
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "/getThreeLevel",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getThreeLevel(){
		String menuId = request.getParameter("menuId") == null ? "" : request.getParameter("menuId");
		String userId = (String) request.getSession().getAttribute("userId");
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		List<menuVo> threelevelList = menuService.getThreeTheLevelMenuBasedOnTheAccountID(userId, menuId);
		paginationUtil.after(threelevelList);
		return paginationUtil;
	}
	
	
	
	@RequestMapping(value = "/menuTreeList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage menuTreeList(String menuId){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			String userId = (String) request.getSession().getAttribute("userId");
			
			
			String isSys = "";
			if("sysadmin".equals(getUser_idFormSession("userId")))
				isSys = "sysadmin";
			
			//查询二级权限
			List<menuVo> twolelve = menuService.getTheTwoLevelMenuBasedOnTheAccountID(userId, menuId,isSys);

			List<menuVo> removeDuplicate = this.removeDuplicate(twolelve);
			for(int i=0;i<removeDuplicate.size();i++){
				//查询三级权限
				menuVo vo = removeDuplicate.get(i);
				String id = vo.getMenuId();
				List<menuVo> threelevel = menuService.getThreeTheLevelMenuBasedOnTheAccountID(userId, id);
				if(threelevel.size() > 0){
					removeDuplicate.addAll(this.removeDuplicate(threelevel));
				}
				
			}
			
			ajaxMessage.setToken(menuId);
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage("添加成功");
			ajaxMessage.setData(JsonUtils.toJson(removeDuplicate));
		} catch (Exception e) {
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage("系统错误");
		}
		
		return ajaxMessage;
	}
}
