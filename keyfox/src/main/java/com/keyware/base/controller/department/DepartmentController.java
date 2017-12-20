package com.keyware.base.controller.department;


import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.keyware.base.controller.BaseController;
import com.keyware.base.repository.entity.department.Department;
import com.keyware.base.repository.entity.user.User;
import com.keyware.base.service.itf.auditlog.AuditLogService;
import com.keyware.base.service.itf.department.DepartmentService;
import com.keyware.base.service.itf.user.UserService;
import com.keyware.base.task.util.AjaxMessage;
import com.keyware.base.utils.Constant;
import com.keyware.utils.DateUtils;
import com.keyware.utils.IdComposeListUtil;
import com.keyware.utils.IdGenerator;
import com.keyware.utils.JsonUtils;
import com.keyware.utils.PaginationUtil;

@Controller
@RequestMapping("/departmentController")
public class DepartmentController extends BaseController{
	@Resource
	private DepartmentService departmentService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private AuditLogService auditLogService; 
	
	
	/**
	 *@author 申鹏飞
	 *@title 跳转部门管理页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/department" })
	public String departmentPage(){
		return "department/department";	
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转部门添加页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/addPage" })
	public String addPage(){
		return "department/addPage";	
	}
	
	/**
	 *@author 申鹏飞
	 *@title 添加部门信息
	 *@param department
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/add",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage add(@ModelAttribute Department department){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			
			Department departmentSelect = new Department();
			departmentSelect.setDeptName(department.getDeptName());
			List<Department> selectByDeparmentInfo = departmentService.selectByDeparmentInfoSelect(departmentSelect);
			if(selectByDeparmentInfo.size()>0){
				ajaxMessage.setCode("0");
				ajaxMessage.setMessage("部门名称已存在");
				return ajaxMessage;
			}
			Department departmentSelect1 = new Department();
			departmentSelect1.setDeptNumber(department.getDeptNumber());
			List<Department> selectByDeparmentInfo1 = departmentService.selectByDeparmentInfoSelect(departmentSelect1);
			if(selectByDeparmentInfo1.size()>0){
				ajaxMessage.setCode("0");
				ajaxMessage.setMessage("部门编号已存在");
				return ajaxMessage;
			}
			
			department.setId(IdGenerator.uuid32());
			department.setDeptCreateTime(DateUtils.getDateTime());
			department.setTotalWorkers((long) 0);
			departmentService.insert(department);
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage("保存成功");
			auditLogService.insertLog("添加部门","部门管理", getUser_idFormSession("userName")+"添加"+department.getDeptName()+"部门", request);
			
		} catch (Exception e) {
			e.printStackTrace();
			ajaxMessage.setCode("0");
			System.out.println("错误");
			ajaxMessage.setMessage("系统错误,请联系管理员");
		}
		return ajaxMessage;
		
	}
	/**
	 *@author 申鹏飞
	 * @param projectRsource 
	 *@title 跳转部门修改页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/editPage" })
	public String editPage(String id, String projectRsource){
		request.setAttribute("id", id);
		
		Department department = departmentService.selectByPrimaryKey(id);
		
		if(department != null){
			department = departmentService.setUserName(department);
		}
		String isSys = "";
		if("sysadmin".equals(getUser_idFormSession("userId")))
			isSys = "sysadmin";
		
		//上级部门
		List<Department> departments = departmentService.getParentId(id, isSys, projectRsource);
		request.setAttribute("departmentList", departments);
		
		request.setAttribute("department", department);
		return "department/editPage";	
	}

	
	/**
	 *@author 申鹏飞
	 *@title 获取部门信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/viewInfo" })
	@ResponseBody
	public String viewInfo(){
		String id=request.getParameter("id");
		Department department=departmentService.selectByPrimaryKey(id);
		return JsonUtils.objectToJsonString(department);	
	}
	
	/**
	 *@author 申鹏飞
	 *@title 修改部门信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/edit",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage edit(@ModelAttribute Department department){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			departmentService.updateByPrimaryKey(department);
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage("保存成功");
			
			auditLogService.insertLog("修改部门信息", "部门管理", getUser_idFormSession("userName")+"修改了"+department.getDeptName()+"部门详细信息", request);
		} catch (Exception e) {
			e.printStackTrace();
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage("系统错误,请联系管理员");
		}
		return ajaxMessage;	
	}
	
	
	/**
	 *@author 申鹏飞
	 *@title 查询部门所有信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/select",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil select(@ModelAttribute Department department){
		PaginationUtil paginationUtil=new PaginationUtil();
		paginationUtil.before(request);
		
		if("请输入部门名称...".equals(department.getDeptName())){
			department.setDeptName(null);
		}
		
		if("sysadmin".equals(getUser_idFormSession("userId"))){
			department.setIsSys("sysadmin");
		}
		
		List<Department> departmentList = departmentService.selectByDeparmentInfo(department);
		for(Department vo : departmentList){
			Integer selectUserCountByDeptId = userService.selectUserCountByDeptId(vo.getId());
			if(selectUserCountByDeptId != null)
				vo.setUserCount(selectUserCountByDeptId);
			
			Department selectByPrimaryKey = departmentService.selectByPrimaryKey(vo.getParentId());
			if(selectByPrimaryKey != null)
				vo.setParentName(selectByPrimaryKey.getDeptName());
			
			
		}
		department.setProjectSource(Constant.projectName);;
		paginationUtil.after(departmentList);
		return paginationUtil;
	}
	
	/**
	 *@author 申鹏飞
	 *@title 删除部门信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/delete",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String delete(){
		List<String> listId = IdComposeListUtil.listId(request);
		String deparNames = "";
		for(String id : listId){
			Department selectByPrimaryKey = departmentService.selectByPrimaryKey(id);
			deparNames += selectByPrimaryKey.getDeptName()+",";
		}
		departmentService.deleteByPrimaryKey(listId);
		if(deparNames.length() > 0){
			auditLogService.insertLog("删除部门", "部门管理", getUser_idFormSession("userName")+"删除了"+deparNames.substring(0, deparNames.length()-1)+"部门", request);
		}
		
		return "删除成功";
	}
	/**
	 *@author 申鹏飞
	 * @param projectResource 
	 *@title 获取部门名称和Id
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/getParentId",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String getParentId(String projectResource){
		String id=request.getParameter("id");
		
		String isSys = "";
		if("sysadmin".equals(getUser_idFormSession("userId")))
			isSys = "sysadmin";
		
		
		List<?> department=departmentService.getParentId(id,isSys,projectResource);
		return JsonUtils.arrayListToJsonString(department);
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转部门管理页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/selectUser" })
	public String selectUser(){
		return "department/selectUser";
	}
	/**
	 *@author 申鹏飞
	 * @param projectResource 
	 *@title 项目部门节点数
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value="/selectDepartTree",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public void selectDepartTree(HttpServletRequest request,  
            HttpServletResponse response, String projectResource) throws Exception{
        request.setCharacterEncoding("utf-8");
        response.setContentType("text/xml;charset=utf-8");
        PrintWriter out = response.getWriter();
        String id=request.getParameter("id");
        
        String isSys = "";
		if("sysadmin".equals(getUser_idFormSession("userId")))
			isSys = "sysadmin";
        
		List<Department> departmentList=departmentService.getParentId(id,isSys,projectResource);
 	    if(departmentList!=null&&departmentList.size()>0){
 	    	out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
 	        out.println("<nodes>");
 	    	for(int i=0;i<departmentList.size();i++){
 	    		Department department = departmentList.get(i);
 	    		String parentId="-1";
 	    		if(department.getParentId()!=null&&!"".equals(department.getParentId())){
 	    			parentId=department.getParentId();
 	    		}
 	    		out.println("<node nodeId='"+department.getId()+"' parentId='"+parentId+"' >"+department.getDeptName()+"</node>");
 	    	}
 	    	out.println("</nodes>");
 	    }
	}
	/**
	 *@author 申鹏飞
	 *@title 根据父节点的id来查询子节点
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value="/selectSonByNodeId",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	public void selectSonByNodeId(HttpServletRequest request, HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("utf-8");
		String nodeId = request.getParameter("nodeId") == null ? "" : request.getParameter("nodeId");
		List<Department> departmentList=departmentService.getChildId(nodeId);
	    response.setContentType("text/xml;charset=utf-8");
	    PrintWriter out = response.getWriter();
	    Object json = JSON.toJSON(departmentList);
	    out.println(json);
	}
	/**
	 * 生成树
	 *  @author 申鹏飞
	 * @param projectResource 
	 *  @param 
	 *  @date   2016年6月28日
	 *  @return ModelAndView
	 */
	@RequestMapping(value="/selectDepartUser")
	public ModelAndView selectDepartUser(String projectResource){
		ModelAndView modeAndView = new ModelAndView("department/selectDepartUser");
		String inputId = request.getParameter("inputId");
		String managerId = request.getParameter("managerId") == null ? "" :  request.getParameter("managerId");
		String departId = request.getParameter("departId") == null ? "" :  request.getParameter("departId");
		String choicedParentDepart = request.getParameter("choicedParentDepart") == null ? "" :  request.getParameter("choicedParentDepart");
		String docManager = request.getParameter("docManager") == null ? "" :  request.getParameter("docManager");
		String isSys = "";
		if("sysadmin".equals(getUser_idFormSession("userId")))
			isSys = "sysadmin";
		
		String strTree="";
    	String id=request.getParameter("id");
    	if(!"".equals(departId) && "".equals(choicedParentDepart)){
    		Department depart = departmentService.selectByPrimaryKey(departId);
    		Department parentDepart = departmentService.selectByPrimaryKey(depart.getParentId());
    		if(parentDepart != null){
    			strTree += "{id:'"+parentDepart.getParentId()+"',pId:'',name:'"+parentDepart.getDeptName()+"',nocheck:true, open:true},";
    			request.setAttribute("set_document_departId", depart.getId());
    		}
    	}else{
    		if(!"".equals(choicedParentDepart)){
        		Department depart = departmentService.selectByPrimaryKey(choicedParentDepart);
        		if(depart != null){
        			strTree += "{id:'"+depart.getId()+"',pId:'',name:'"+depart.getDeptName()+"',nocheck:true, open:true},";
        			request.setAttribute("source", "choiceParentDepart");
        		}
        		
        	}else{
        		List<Department> departmentList=departmentService.getParentId(id,isSys,projectResource);
        		strTree += "{id:'',pId:'root',name:'所有部门',nocheck:true, open:true},";
         	    if(departmentList!=null&&departmentList.size()>0){
         	    	for(int i=0;i<departmentList.size();i++){
         	    		Department department = departmentList.get(i);
         	    		String parentId="";
         	    		if(department.getParentId()!=null&&!"".equals(department.getParentId())){
         	    			parentId=department.getParentId();
         	    		}
         	    		strTree += "{id:'"+department.getId()+"',pId:'"+parentId+"',name:'"+department.getDeptName()+"'},";
         	    	}

         	    }
        	}
    		
    	}
    	
//		//根节点
//		String strTree = "{id:'"+department.getId()+"',pId:'"+parentId+"',name:'"+department.getDeptName()+"',nocheck:true, open:true},";
    	if(strTree.length()>0){
    		strTree =strTree.substring(0, strTree.length()-1);
    	}
		
		modeAndView.addObject("zNodes", "["+strTree+"]");
		request.setAttribute("inputId", inputId);
		request.setAttribute("managerId", managerId);
		request.setAttribute("docManager",docManager);
		return modeAndView;
	}
	
	
	
	
	
	/**
	 *@author 代钢
	 *@title 跳转项目定义中设置文档的页面
	 *@return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/selectDepartUserName"})
	public String addSetDocument(){
		return "department/selectDepartUser";	
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: checkDepartMentName
	 * @Description: 校验部门名称是否存在
	 * @return
	 * @return AjaxMessage
	 */
	@RequestMapping(value="/checkDepartMentName",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage checkDepartMentName(){
		AjaxMessage ajaxMessage = new AjaxMessage();
		String dept_name = request.getParameter("name");
		if(StringUtils.hasText(dept_name)){
			List<Department> selectByDeparmentName = departmentService.selectByDeparmentName(dept_name);
			if(selectByDeparmentName.size() > 0){
				ajaxMessage.setCode("1");
				ajaxMessage.setMessage("部门名称已存在");
			}
		}
		return ajaxMessage;
	}
	/**
	 *@author 代钢
	 *@title 查询所有部门
	 *@return
	 *@date 2016-10-13
	 */
	@RequestMapping(value="/selectAllDepartment",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, String> selectAllDepartment() throws Exception{
	   HashMap<String, String> map = new HashMap<String, String>();
	   String userId = request.getParameter("userId") == null ? "" : request.getParameter("userId");
	   if(!"".equals(userId) && !"undefined".equals(userId)){
		   User user = userService.selectByPrimaryKey(userId);
		   if(user.getDepartId() != null){
			   map.put("departId",user.getDepartId());
		   }
	   }
 	   List<Department> departmentList = departmentService.selectAll();
 	   map.put("json", JsonUtils.toJson(departmentList));
 	   return map;
	}
	
	
	/**
	 * 
	 *	@Title 选择负责人
	 *  @author 李涛
	 * @param projectResource 
	 *  @param 
	 *  @date   2016年11月21日
	 *  @return ModelAndView
	 */
	@RequestMapping(value="/selectManagerUser")
	public ModelAndView selectManagerUser(String projectResource){
		ModelAndView modeAndView = new ModelAndView("department/selectManagerUser");
		String inputId = request.getParameter("inputId");
		String managerId = request.getParameter("managerId") == null ? "" :  request.getParameter("managerId");
		String departId = request.getParameter("departId") == null ? "" :  request.getParameter("departId");
		String choicedParentDepart = request.getParameter("choicedParentDepart") == null ? "" :  request.getParameter("choicedParentDepart");
		String team_id = request.getParameter("team_id") == null ? "" :  request.getParameter("team_id");
		String isSys = "";
		if("sysadmin".equals(getUser_idFormSession("userId")))
			isSys = "sysadmin";
		
		String strTree="";
    	String id=request.getParameter("id");
    	if(!"".equals(departId) && "".equals(choicedParentDepart)){
    		Department depart = departmentService.selectByPrimaryKey(departId);
    		Department parentDepart = departmentService.selectByPrimaryKey(depart.getParentId());
    		if(parentDepart != null){
    			strTree += "{id:'"+parentDepart.getParentId()+"',pId:'',name:'"+parentDepart.getDeptName()+"',nocheck:true, open:true},";
    			request.setAttribute("set_document_departId", depart.getId());
    		}
    	}else{
    		if(!"".equals(choicedParentDepart)){
        		Department depart = departmentService.selectByPrimaryKey(choicedParentDepart);
        		if(depart != null){
        			strTree += "{id:'"+depart.getId()+"',pId:'',name:'"+depart.getDeptName()+"',nocheck:true, open:true},";
        			request.setAttribute("source", "choiceParentDepart");
        		}
        		
        	}else{
        		List<Department> departmentList=departmentService.getParentId(id,isSys,projectResource);
        		strTree += "{id:'',pId:'root',name:'所有部门',nocheck:true, open:true},";
         	    if(departmentList!=null&&departmentList.size()>0){
         	    	for(int i=0;i<departmentList.size();i++){
         	    		Department department = departmentList.get(i);
         	    		String parentId="";
         	    		if(department.getParentId()!=null&&!"".equals(department.getParentId())){
         	    			parentId=department.getParentId();
         	    		}
         	    		strTree += "{id:'"+department.getId()+"',pId:'"+parentId+"',name:'"+department.getDeptName()+"'},";
         	    	}

         	    }
        	}
    		
    	}
    	
//		//根节点
//		String strTree = "{id:'"+department.getId()+"',pId:'"+parentId+"',name:'"+department.getDeptName()+"',nocheck:true, open:true},";
    	if(strTree.length()>0){
    		strTree =strTree.substring(0, strTree.length()-1);
    	}
		
		modeAndView.addObject("zNodes", "["+strTree+"]");
		request.setAttribute("inputId", inputId);
		request.setAttribute("managerId", managerId);
		request.setAttribute("team_id", team_id);
		return modeAndView;
	}
	
	/**
	 * 
	 * @Title: showselectDepartUserTop
	 * @Description: 测试管理选人界面由两个界面组成,加一个中转界面
	 * @param inputId
	 * @param managerId
	 * @param choicedParentDepart
	 * @return
	 * @author 赵亚舟
	 * @return String
	 */
	@RequestMapping(value = "showSelectDepartUserTop",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showselectDepartUserTop(String inputId,String managerId,String choicedParentDepart){
		request.setAttribute("inputId", inputId);
		request.setAttribute("managerId", managerId);
		request.setAttribute("choicedParentDepart", choicedParentDepart);
		return "department/selectDepartUserTop";
	}
	
}
