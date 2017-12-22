package com.keyware.base.controller.rules;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.codehaus.groovy.transform.stc.StaticTypeCheckingSupport;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.keyware.base.controller.BaseController;
import com.keyware.base.repository.entity.rules.BasicRule;
import com.keyware.base.service.itf.rules.BasicRuleService;
import com.keyware.base.task.util.AjaxMessage;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/ruleController")
public class RuleController extends BaseController {
	
	@Resource
	public BasicRuleService basicRuleService;
	
	
	/**
	 * @author litao
	 * @describe 保存和修改规则文件
	 * @param basicRule
	 * @return
	 */
	@RequestMapping(value="/saveRuleAndCreateJsonFile",method=RequestMethod.POST)
	public ModelAndView saveRuleAndCreateJsonFile(@ModelAttribute BasicRule basicRule){
		ModelAndView  modelAndView  = new ModelAndView("iframeContent/right_container/guizeguanli");
		JSONObject jsonFile = new JSONObject();
		jsonFile.put("APPID", basicRule.getAppId());
		jsonFile.put("Name", basicRule.getName());
		jsonFile.put("SaveBytes", basicRule.getSaveBytes());
		jsonFile.put("Trance", basicRule.getTrance());
		jsonFile.put("Respond", 2);
		jsonFile.put("ReNewAPP", 1);
		jsonFile.put("Type", 100);
		jsonFile.put("Reverse", basicRule.getReverse());
		jsonFile.put("Level", basicRule.getLevel());
		jsonFile.put("MSG","");
		String rulesType ="";
		ArrayList<Object> rulesList = new ArrayList<Object>();
		//获取规则数据
		Map<String,Object> rulesMap = new HashMap<String,Object>();
		if(!basicRule.getiP_rule().equals("")){
			rulesType+="IP_Rule,";
			JSONObject ipObject= JSONObject.fromObject(basicRule.getiP_rule());
			JSONArray jsonArray = JSONArray.fromObject(ipObject.get("IP_Rule"));
			jsonFile.put("IP_Rule", jsonArray);
			for (Object object : jsonArray) {
				rulesMap.put("id", basicRule.getAppId()+"_"+rulesList);
				rulesMap.put("data", object);
				rulesMap.put("type", "IP_Rule");
				rulesList.add(rulesMap);
			}
			
		}
		if(!basicRule.getKey_rule().equals("")){
			rulesType+="Key_Rule,";
			JSONObject keyObject= JSONObject.fromObject(basicRule.getKey_rule());
			JSONArray jsonArray = JSONArray.fromObject(keyObject.get("Key_Rule"));
			jsonFile.put("Key_Rule", jsonArray);
			for (Object object : jsonArray) {
				rulesMap.put("id", basicRule.getAppId()+"_"+rulesList);
				rulesMap.put("data", object);
				rulesMap.put("type", "Key_Rule");
				rulesList.add(rulesMap);
			}
		}
		if(!basicRule.getRegex_rule().equals("")){
			rulesType+="Regex_Rule,";
			JSONObject regexObject= JSONObject.fromObject(basicRule.getRegex_rule());
			JSONArray jsonArray = JSONArray.fromObject(regexObject.get("Regex_Rule"));
			jsonFile.put("Regex_Rule", jsonArray);
			for (Object object : jsonArray) {
				rulesMap.put("id", basicRule.getAppId()+"_"+rulesList);
				rulesMap.put("data", object);
				rulesMap.put("type", "Regex_Rule");
				rulesList.add(rulesMap);
			}
		}
		if(!basicRule.getLib_rule().equals("")){
			rulesType+="Lib_Rule,";
			JSONObject libObject= JSONObject.fromObject(basicRule.getLib_rule());
			JSONArray jsonArray = JSONArray.fromObject(libObject.get("Lib_Rule"));
			jsonFile.put("Lib_Rule", jsonArray);
			for (Object object : jsonArray) {
				rulesMap.put("id", basicRule.getAppId()+"_"+rulesList);
				rulesMap.put("data", object);
				rulesMap.put("type", "Lib_Rule");
				rulesList.add(rulesMap);
			}
		}
		if(!basicRule.getDomain_rule().equals("")){
			rulesType+="Domain_Rule,";
			JSONObject domainObject= JSONObject.fromObject(basicRule.getDomain_rule());
			JSONArray jsonArray = JSONArray.fromObject(domainObject.get("Domain_Rule"));
			jsonFile.put("Domain_Rule", jsonArray);
			for (Object object : jsonArray) {
				rulesMap.put("id", basicRule.getAppId()+"_"+rulesList);
				rulesMap.put("data", object);
				rulesMap.put("type", "Domain_Rule");
				rulesList.add(rulesMap);
			}
		}
		if(!basicRule.getProtocol_Rule().equals("")){
			rulesType+="Protocol_Rule,";
			JSONObject proObject= JSONObject.fromObject(basicRule.getProtocol_Rule());
			JSONArray jsonArray = JSONArray.fromObject(proObject.get("Protocol_Rule"));
			jsonFile.put("Protocol_Rule", jsonArray);
			for (Object object : jsonArray) {
				rulesMap.put("id", basicRule.getAppId()+"_"+rulesList);
				rulesMap.put("data", object);
				rulesMap.put("type", "Protocol_Rule");
				rulesList.add(rulesMap);
			}
		}
		
		jsonFile.put("rules", JSONArray.fromObject(rulesList));
		//保存修改规则数据和规则文件
		basicRule.setStatus("running");
		basicRule.setRulesType(rulesType);
		if(basicRuleService.selectById(basicRule.getAppId()) !=null){
			basicRuleService.updateByPrimaryKey(basicRule);
		}else{
			basicRuleService.insert(basicRule);
		}
		String ruleFileName = basicRule.getAppId()+".json"; 
		File newRuleFile= new File(request.getServletContext().getRealPath("resources/files/rules")+File.separator+ruleFileName);
		FileWriter writer = null;
		try {
			writer = new FileWriter(newRuleFile);
			writer.write(jsonFile.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			try {
				writer.flush();
				writer.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		modelAndView.addObject("ruleList", JSONArray.fromObject(basicRuleService.selectAllRules()));
		return modelAndView;
	}
	
	
	
	
	
	/***
	 * @author litao
	 * @describe 新增规则
	 * 跳转到规则添加页面
	 * @return  modelAndView
	 */
	@RequestMapping(value="/addRule")
	public ModelAndView  addRule(){
		ModelAndView modelAndView = new ModelAndView("iframeContent/right_container/tianjiaguize");
		List<BasicRule> rules=basicRuleService.selectAllRules();
		if(rules.size() ==0){
			modelAndView.addObject("app_id",1);
		}else{
			modelAndView.addObject("app_id",Integer.valueOf(rules.get(rules.size()-1).getAppId())+1);
		}
		return modelAndView;
		
	}
	
	/***
	 * @author litao 
	 * @describe  查看规则信息
	 * @param app_id 规则ID
	 * @return ModelAndView
	 */
	@RequestMapping(value="/checkRule" ) 
	public ModelAndView checkRule(){
		ModelAndView modelAndView  = new ModelAndView("iframeContent/right_container/tianjiaguize");
		String app_id = request.getParameter("app_id");
		String ruleFileName = app_id+".json"; 
		File newRuleFile= new File(request.getServletContext().getRealPath("resources/files/rules")+File.separator+ruleFileName);
		try {
			String jsonFileStr = FileUtils.readFileToString(newRuleFile, "UTF-8");
			modelAndView.addObject("app_id",app_id) ;
			modelAndView.addObject("ruleObject",JSONObject.fromObject(jsonFileStr)) ;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return modelAndView;
	}
	
	
	/***
	 * @author 李涛
	 * @describe  删除数据和对应的规则文件
	 * @return
	 */
	@RequestMapping(value="/delRuleData",method=RequestMethod.POST,produces = "application/json; charset=utf-8")
	public AjaxMessage delRuleData(){
		AjaxMessage ajax = new  AjaxMessage();
		String  app_id = request.getParameter("appId");
		String ruleFileName = app_id+".json"; 
		File ruleFile= new File(request.getServletContext().getRealPath("resources/files/rules")+File.separator+ruleFileName);
		try {
			basicRuleService.deleteRule(app_id);
			ruleFile.delete();
			ajax.setMessage("1");
		} catch (Exception e) {
			ajax.setMessage("0");
		}	
		return ajax;
	}
	
	
	/***
	 * @author litao
	 * @describe  删除规则参数信息
	 * @param seq 同类规则参数的序号
	 * @return ajax
	 */
	@RequestMapping(value="/delRuleParaInfo",method=RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage delRuleParaInfo(){
		AjaxMessage ajax = new AjaxMessage();
		String app_id = request.getParameter("appId");
		String ruleType = request.getParameter("ruleType");
		String seq = request.getParameter("seq");
		JSONArray jsonArray = null;
		JSONObject fileObj = null;
		String ruleFileName = app_id+".json"; 
		File newRuleFile= new File(request.getServletContext().getRealPath("resources/files/rules")+File.separator+ruleFileName);
		try {
			String jsonFileStr = FileUtils.readFileToString(newRuleFile, "UTF-8");
			fileObj = JSONObject.fromObject(jsonFileStr);
			//从对应的规则文件中读取规则参数数据
			jsonArray = JSONArray.fromObject(fileObj.get(ruleType));
			//当删除的规则类型为Lib时，需要删除之前上传的动态库文件
			if(ruleType.equals("Lib_Rule")){
				String fileName =JSONObject.fromObject(jsonArray.get(Integer.valueOf(seq))).get("Lib")+".json" ;
				File libFile = new  File(request.getServletContext().getRealPath("resources/files/uploads")+File.separator+fileName);
				libFile.delete();
			}
			fileObj.put(ruleType, jsonArray);
			basicRuleService.alterFile(newRuleFile, fileObj);
			jsonArray.remove(seq);
			ajax.setMessage("1");
			ajax.setData(jsonArray.toString());
		} catch (IOException e) {
			ajax.setMessage("0");
			e.printStackTrace();
		}
		return ajax;
	}
	
	
	
	
	/***
	 * @author litao
	 * @describe 跳转到规则展示页面
	 * @return modelAndView
	 */
	@RequestMapping(value="/showRulePage")
	public ModelAndView showRulePage(){
		ModelAndView modelAndView = new ModelAndView("basicRules/addRule");
		modelAndView.addObject("ruleList", JSONArray.fromObject(basicRuleService.selectAllRules()));
		return modelAndView;
	}
	
	/***
	 * @author litao	
	 * @decribe 根据id查询规则数据
	 * @return
	 */
	@RequestMapping(value="/searchRuleById" ,method=RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage searchRuleById(){
		AjaxMessage ajax = new AjaxMessage();
		//限定只有id存在或者为""的时候可以查询
		String param = request.getParameter("param");
		if(param.equals("")){
			ajax.setMessage("1");
			ajax.setData(JSONArray.fromObject(basicRuleService.selectAllRules()).toString());
		}else{
			if(basicRuleService.selectBySelective(param).size()>0){
				ajax.setMessage("1");
				ajax.setData(JSONArray.fromObject(basicRuleService.selectBySelective(param)).toString());
			}else{
				ajax.setMessage("0");
			}	
		}
		return ajax;
		
	}
	
}
