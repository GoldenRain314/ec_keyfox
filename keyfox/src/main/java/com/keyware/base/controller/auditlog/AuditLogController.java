package com.keyware.base.controller.auditlog;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.format.UnderlineStyle;
import jxl.write.Colour;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.keyware.base.controller.BaseController;
import com.keyware.base.repository.entity.auditlog.AuditLog;
import com.keyware.base.repository.entity.auditlog.AuditLogSnapshot;
import com.keyware.base.service.itf.auditlog.AuditLogService;
import com.keyware.base.task.util.AjaxMessage;
import com.keyware.base.utils.Constant;
import com.keyware.utils.DateUtils;
import com.keyware.utils.IdComposeListUtil;
import com.keyware.utils.IdGenerator;
import com.keyware.utils.JsonUtils;
import com.keyware.utils.PaginationUtil;


@Controller
@RequestMapping("/auditLogController")
public class AuditLogController extends BaseController{
	@Resource
	private AuditLogService auditLogService;
	/**
	 *@author 申鹏飞
	 *@title 跳转日志管理页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/auditLog" })
	public String auditLogPage(){
		return "auditlog/auditLog";	
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转管理员审计页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/adminAuditLog" })
	public String adminAuditLogPage(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String endDate = sdf.format(new Date());
		Calendar cl = Calendar.getInstance();
		cl.add(Calendar.MONTH, -1);	
		String startDate = sdf.format(cl.getTime());
		request.setAttribute("endDate", endDate);
		request.setAttribute("startDate", startDate);
		return "auditlog/adminAuditLog";	
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转安全审计员审计页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/safeAuditLog" })
	public String safeAuditLogPage(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String endDate = sdf.format(new Date());
		Calendar cl = Calendar.getInstance();
		cl.add(Calendar.MONTH, -1);	
		String startDate = sdf.format(cl.getTime());
		request.setAttribute("endDate", endDate);
		request.setAttribute("startDate", startDate);
		return "auditlog/safeAuditLog";	
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转安全保密员审计页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/safeSecretAuditLog" })
	public String safeSecretAuditLogPage(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String endDate = sdf.format(new Date());
		Calendar cl = Calendar.getInstance();
		cl.add(Calendar.MONTH, -1);	
		String startDate = sdf.format(cl.getTime());
		request.setAttribute("endDate", endDate);
		request.setAttribute("startDate", startDate);
		return "auditlog/safeSecretAuditLog";	
	}
	/**
	 *@author 申鹏飞
	 *@title 跳转日志管理添加页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/addPage" })
	public String addPage(){
		return "auditlog/addPage";	
	}
	/**
	 *@author 申鹏飞
	 *@title 添加日志管理信息
	 *@param auditLog
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/add",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage add(@ModelAttribute AuditLog auditLog){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			auditLog.setId(IdGenerator.uuid32());
			auditLogService.insert(auditLog);
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
	 *@title 跳转日志管理修改页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/editPage" })
	public String editPage(){
		String id=request.getParameter("id");
		request.setAttribute("id", id);
		return "auditlog/editPage";	
	}
	/**
	 *@author 申鹏飞
	 *@title 获取日志管理信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = {"/viewInfo" })
	@ResponseBody
	public String viewInfo(){
		String id=request.getParameter("id");
		AuditLog auditLog=auditLogService.selectByPrimaryKey(id);
		return JsonUtils.objectToJsonString(auditLog);	
	}
	/**
	 *@author 申鹏飞
	 *@title 修改日志管理信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/edit",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage edit(@ModelAttribute AuditLog auditLog){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			auditLogService.updateByPrimaryKey(auditLog);
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
	 *@title 查询日志管理页面
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/select",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil selectAll(@ModelAttribute AuditLog auditLog){
		PaginationUtil paginationUtil=new PaginationUtil();
		paginationUtil.before(request);
		auditLog.setProjectSource(Constant.projectName);
		List<?> auditLog1=auditLogService.selectAll(null);
		paginationUtil.after(auditLog1);
		return paginationUtil;
	}
	/**
	 *@author 申鹏飞
	 *@title 查询管理员审计页面信息
	 * @return
	 *@date 2016-07-01
	 */
	@RequestMapping(value = "/selectAdminLog",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil selectAdminLog(@ModelAttribute AuditLog auditLog){
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		PaginationUtil paginationUtil=new PaginationUtil();
		paginationUtil.before(request);
		auditLog.setProjectSource(Constant.projectName);
		List<AuditLog> selectAdminLog = auditLogService.selectAdminLog(startDate, endDate);
		paginationUtil.after(selectAdminLog);
		return paginationUtil;
	}
	/**
	 *@author 申鹏飞
	 *@title 查询安全审计员审计页面信息
	 * @return
	 *@date 2016-07-01
	 */
	@RequestMapping(value = "/safeAuditLog",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil safeAuditLog(@ModelAttribute AuditLog auditLog){
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		PaginationUtil paginationUtil=new PaginationUtil();
		paginationUtil.before(request);
		auditLog.setProjectSource(Constant.projectName);
		List<AuditLog> safeAuditLog = auditLogService.safeAuditLog(startDate,endDate);
		paginationUtil.after(safeAuditLog);
		return paginationUtil;
	}
	/**
	 *@author 申鹏飞
	 * @param projectSource 
	 *@title 查询安全保密员审计页面信息
	 * @return
	 *@date 2016-07-01
	 */
	@RequestMapping(value = "/safeSecretAuditLog",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil safeSecretAuditLog(@ModelAttribute AuditLog auditLog){
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String projectSource=request.getParameter("projectSource");
		PaginationUtil paginationUtil=new PaginationUtil();
		paginationUtil.before(request);
		auditLog.setProjectSource(Constant.projectName);
		List<AuditLog> safeSecretAuditLog = auditLogService.safeSecretAuditLog(startDate, endDate);
		paginationUtil.after(safeSecretAuditLog);
		return paginationUtil;
	}
	/**
	 *@author 申鹏飞
	 *@title 删除日志管理信息
	 * @return
	 *@date 2016-06-17
	 */
	@RequestMapping(value = "/delete",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String delete(){
		List<String> listId=IdComposeListUtil.listId(request);
		auditLogService.deleteAudit(listId);
		
		auditLogService.insertLog("删除日志", "审计管理", getUser_idFormSession("userName")+"删除了"+listId.size()+"条日志", request);
		
		return "删除成功";
	}
	/**
	 *@author 申鹏飞
	 *@title 归档日志信息
	 *@param auditLog
	 * @return
	 *@date 2016-07-01
	 */
	@RequestMapping(value = "/addSnapshot",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String addSnapshot(){
		//TODO  归档
		String fileTime=DateUtils.getDateTime();
		String rows=request.getParameter("rows");
		JSONArray jsonId = JSONArray.fromObject(rows); // 首先把字符串转成 JSONArray  对象
		
		if(jsonId.size()>0){
			for(int j=0;j<jsonId.size();j++){
				List<AuditLogSnapshot> auditLogSnapshotList= new ArrayList<AuditLogSnapshot>();
				JSONObject jobId = jsonId.getJSONObject(j);  // 遍历 jsonarray 数组，把每一个对象转成 json 对象
				AuditLogSnapshot auditLogSnapshot= new AuditLogSnapshot();
				auditLogSnapshot.setId(jobId.get("id").toString());
				auditLogSnapshot.setComments(jobId.get("comments").toString());
				auditLogSnapshot.setDeptName(jobId.get("deptName").toString());
				auditLogSnapshot.setFileTime(fileTime);
				auditLogSnapshot.setIpAddress(jobId.get("ipAddress").toString());
				auditLogSnapshot.setLogName(jobId.get("logName").toString());
				auditLogSnapshot.setLogNameType(jobId.get("logNameType").toString());
				auditLogSnapshot.setOperTime(jobId.get("operTime").toString());
				auditLogSnapshot.setUserId(jobId.get("userId").toString());
				auditLogSnapshot.setUserName(jobId.get("userName").toString());
		        auditLogSnapshotList.add(auditLogSnapshot);
		        auditLogService.insertAuditLogSnapshot(null);
			}
		}
		
		auditLogService.insertLog("日志归档", "审计管理", getUser_idFormSession("userName")+"归档了"+jsonId.size()+"条日志", request);
		
		
		return "成功";
		
	}
	/**
	 *@author 代钢
	 * @param projectSource 
	 *@title 导出日志
	 *@return
	 * @throws Exception 
	 */
	@RequestMapping(value = "/exportExcel",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public void exportExcel(HttpServletResponse response, String projectSource) throws Exception{
		String type = request.getParameter("type") == null ? "" : request.getParameter("type");
		String startDate = request.getParameter("startDate") == null ? "" : request.getParameter("startDate");
		String endDate = request.getParameter("endDate") == null ? "" : request.getParameter("endDate");
        String filename = "审计记录.xls";
        String filePath = request.getSession().getServletContext().getRealPath("upload") +"\\"+ filename;
        List<AuditLog> list = new ArrayList<AuditLog>();
		if("admin".equals(type)){
			list = auditLogService.selectAdminLog(startDate, endDate);	
		}else if("safeAudit".equals(type)){
			list = auditLogService.safeAuditLog(startDate, endDate);
		}else if("safeSecret".equals(type)){
			list = auditLogService.safeSecretAuditLog(startDate, endDate);
		}
         
        List<Map> logList = new ArrayList<Map>();
//        if(list.size() > 0){
        	for(AuditLog log : list){
        		Map<String,String> logMap = new HashMap<String,String>();
        		logMap.put("logName", log.getLogName());
        		logMap.put("logNameType", log.getLogNameType());
        		logMap.put("userId", log.getUserId());
        		logMap.put("userName", log.getUserName());
        		logMap.put("deptName", log.getDeptName());
        		logMap.put("IP", log.getIpAddress());
        		logMap.put("operTime", log.getOperTime());
        		logMap.put("comments", log.getComments());
        		logMap.put("projectSource",log.getProjectSource());
        		logList.add(logMap);
        	}
			exportExcel(response,logList,filePath);  
//	    }else{
//	        response.getWriter().write("请传入正确的项目UID");
//		}
	}
	public boolean exportExcel(HttpServletResponse response,List list,String filePath) {
		try {
			OutputStream os = response.getOutputStream();// 取得输出流   
			response.reset();// 清空输出流   
			response.setHeader("Content-disposition", "attachment; filename=abc.xls");// 设定输出文件头  
		
			response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("审计记录".getBytes("gb2312"), "ISO8859-1" )+".xls"+"\"");
			response.setContentType("application/msexcel");// 定义输出类型 
			WritableWorkbook wbook = Workbook.createWorkbook(os); // 建立excel文件   
			String tmptitle = "审计记录"; // 标题   
			WritableSheet wsheet = wbook.createSheet(tmptitle, 0); // sheet名称  
			// 设置excel标题   
			WritableFont wfont = new WritableFont(WritableFont.ARIAL, 16,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,Colour.BLACK);   
			WritableCellFormat wc = new WritableCellFormat(wfont); 
        	// 设置居中 
       	 	wc.setAlignment(jxl.format.Alignment.CENTRE); 
       		// 设置边框线 
        	wc.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN); 
        	WritableCellFormat wc1 = new WritableCellFormat(); 
        	// 设置居中 
       	 	wc1.setAlignment(jxl.format.Alignment.CENTRE); 
       		// 设置边框线 
        	wc1.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN); 
        	wc1.setWrap(true);   
       		wsheet.getSettings().setDefaultColumnWidth(20);  
       		//Label  label = new Label(1, 5, "字体", wc); 
			// 开始生成主体内容                   
			wsheet.addCell(new Label(0, 0, "日志名称",wc));  
			wsheet.addCell(new Label(1, 0, "日志名称类型",wc));  
			wsheet.addCell(new Label(2, 0, "用户帐号",wc)); 
			wsheet.addCell(new Label(3, 0, "用户名",wc));  
			wsheet.addCell(new Label(4, 0, "IP",wc));
			wsheet.addCell(new Label(5, 0, "操作时间",wc));
			wsheet.addCell(new Label(6, 0, "详情",wc));
			wsheet.addCell(new Label(7, 0, "项目数据来源",wc));
			for(int i=0;i<list.size();i++){
				HashMap projectMap = (HashMap)list.get(i);
				wsheet.addCell(new Label(0, i+1, projectMap.get("logName") == null ? "" : projectMap.get("logName").toString(),wc1));
				wsheet.addCell(new Label(1, i+1, projectMap.get("logNameType") == null ? "" : projectMap.get("logNameType").toString(),wc1));
				wsheet.addCell(new Label(2, i+1, projectMap.get("userId") == null ? "" : projectMap.get("userId").toString(),wc1));
				wsheet.addCell(new Label(3, i+1, projectMap.get("userName") == null ? "" : projectMap.get("userName").toString(),wc1));
				wsheet.addCell(new Label(4, i+1, projectMap.get("IP") == null ? "" : projectMap.get("IP").toString(),wc1));
			    wsheet.addCell(new Label(5, i+1, projectMap.get("operTime") == null ? "" : projectMap.get("operTime").toString(),wc1));
			    wsheet.addCell(new Label(6, i+1, projectMap.get("comments") == null ? "" : projectMap.get("comments").toString(),wc1));
			    wsheet.addCell(new Label(7, i+1, projectMap.get("projectSource") == null ? "" : projectMap.get("projectSource").toString(),wc1));
			}           
			// 主体内容生成结束           
			wbook.write(); // 写入文件   
			wbook.close();
			os.close(); // 关闭流
/*			String projectExcel = PluSoft.Utils.File.read(filePath);
			response.getWriter().write(projectExcel);	
			java.io.File file = new java.io.File(filePath);
			file.delete();*/
			return true; 
		} catch(Exception ex) { 
			ex.printStackTrace(); 
			return false; 
		} 
    }  
	
	
}
