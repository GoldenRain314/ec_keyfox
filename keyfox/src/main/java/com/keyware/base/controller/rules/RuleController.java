package com.keyware.base.controller.rules;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.cxf.jaxrs.ext.multipart.Multipart;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.keyware.base.controller.BaseController;
import com.keyware.base.repository.entity.rules.BasicRule;
import com.keyware.base.task.util.AjaxMessage;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/ruleController")
public class RuleController extends BaseController {
	
	/***
	 * @author 李涛
	 * @describe  将规则数据转换成json文件
	 * @param BasicRule
	 */
	@RequestMapping(value="/ruleTitleTransfromJson",method=RequestMethod.POST)
	public AjaxMessage  ruleTitleTransformJsonFile(@ModelAttribute BasicRule basicRule ){
		AjaxMessage ajax = new AjaxMessage();
		Map<String,Object>  dataMap = new HashMap<String,Object>();
		
		dataMap.put("APPID", basicRule.getAppId());
		dataMap.put("Name", basicRule.getName());
		dataMap.put("MSG", basicRule.getMsg());
		//保留信息
		dataMap.put("Reverse","ReverseInfor");
		dataMap.put("Level", basicRule.getLevel());
		//是否更新连接的APP，暂时未启用 ,固定为1
		dataMap.put("ReNewAPP", "1");
		dataMap.put("Type", "100");
		//响应方式
		dataMap.put("respond", "2");
		//规则转换模式
		dataMap.put("Trance", basicRule.getTrance());

		//存储规则参数信息和id
		dataMap.put("rules", new ArrayList<Object>());
		JSONObject jsonObject = JSONObject.fromObject(dataMap);
		String str = request.getRealPath("rules"); 
		File file = new File(str+File.separator+basicRule.getAppId()+".json");
		FileWriter fileWriter = null;
		try {
			try {
				if(!file.exists()){
					file.createNewFile();
				}
				fileWriter = new FileWriter(file);
				fileWriter.write(jsonObject.toString());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			if(fileWriter !=null){
				try {
					fileWriter.flush();
					fileWriter.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		ajax.setData(jsonObject.toString());
		return ajax;
		
	}
	
	/***
	 * @author 李涛
	 * @describe 将规则参数转化到规则的json文件中
	 * @return AJAX
	 */
	@RequestMapping(value="/ruleContextTransformJsonFile",method=RequestMethod.POST)
	public  AjaxMessage   ruleContextTransformJsonFile(){
		AjaxMessage  ajax = new AjaxMessage();
		Map<String,Object>  dataMap = new HashMap<String,Object>();
		Map<String,Object> map = new HashMap<String,Object>();
		Map<String,Object> rulesMap = new HashMap<String,Object>();
		String  ruleType = request.getParameter("ruleType");
		String fileName ="";
		JSONObject obj = null;
		
		String rule_id = request.getParameter("rule_id");
		int index = rule_id.indexOf("_");
		fileName = rule_id.substring(0, index)+".json";
		String line = "";
		try {
			File file = new File(request.getServletContext().getRealPath("rules")+File.separator+fileName);
			if( !file.exists()){
				file.createNewFile();
			}
			BufferedReader  bufRead = new BufferedReader(new FileReader(file));
			try {
				while((line=bufRead.readLine())!= null){
					line=bufRead.readLine();
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		obj = JSONObject.fromObject(line);
		//判断规则类型，加入规则参数数据
		//key_rule
		if(ruleType.equals("key_rule")){
			String pro_id =request.getParameter("pro_id");
			String keyword =request.getParameter("keyware");
			String IsCaseSensive = request.getParameter("iscasesensive");
			map.put("ProID", pro_id);
			map.put("Keyword",keyword);
			map.put("IsCaseSensive", IsCaseSensive);
			dataMap.put("Key_Rule", new ArrayList<Object>().add(map));
		}
		
		//Ip_Rule
		if(ruleType.equals("IP_Rule")){
			//IPv4/IPv6
			String v4_v6 = request.getParameter("v4_v6");
			if(v4_v6.equals("0")){
				v4_v6="IPV4";
			}else{
				v4_v6="IPV6";
			}
			String ip_address = request.getParameter("ip_address");
			String port_high = request.getParameter("port_low");
			String port_low = request.getParameter("port_low");
			map.put(v4_v6,ip_address);
			Map<String,String> portMap = new HashMap<String,String>();
			portMap.put("LowPort", port_low);
			portMap.put("HightPort", port_high);
			//参考数据
			portMap.put("Property", "2");
			portMap.put("Sign", "1");
			map.put("Port_Rule",portMap);
			dataMap.put("IP_Rule", new ArrayList<Object>().add(map));
		}
		//Regex_Rule
		if(ruleType.equals("Regex_Rule")){
			String Regex = request.getParameter("regex");
			String pro_id = request.getParameter("proId");
			String globalMatch = request.getParameter("global_match");
			//是否全局
			map.put("Regex", Regex);
			map.put("ProID", pro_id);
			if(globalMatch.equals("1")){
				map.put("Property", true);
			}else{
				map.put("Property", false);
			}
			dataMap.put("Regex_Rule", new ArrayList<Object>().add(map));
		}
		
		//Domain_Rule
		if(ruleType.equals("Domain_Rule")){
			String type = request.getParameter("type");
			String Domain = request.getParameter("domain");
			map.put("Domain", Domain);
			map.put("Type", type);
			dataMap.put("Domain_Rule", new ArrayList<Object>().add(map));
		}
		
		//Protocol_Rule
		if(ruleType.equals("Protocol_Rule")){
			String port_high = request.getParameter("port_low");
			String port_low = request.getParameter("port_low");
			String pro_id = request.getParameter("pro_id");
			Map<String,String> portMap = new HashMap<String,String>();
			portMap.put("LowPort", port_low);
			portMap.put("HightPort", port_high);
			map.put("ProID", pro_id);
			//参考数据
			portMap.put("Property", "2");
			portMap.put("Sign", "1");
			map.put("Port_Rule",portMap);
			dataMap.put("Protocol_Rule", new ArrayList<Object>().add(map));
		}
		
		//Lib_Rule
		if(ruleType.endsWith("Lib_Rule")){
			//保存上传文件之后，再生成规则参数
			//上传路径
			String libName = "";
			String savePath = request.getServletContext().getRealPath("/WEB-INF/upload");
			File file = new File(savePath);
			DiskFileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setHeaderEncoding("UTF-8"); 
			try {
				List<FileItem> list = upload.parseRequest(request);
				for(FileItem item : list){
					if(item.isFormField()){
						String name = item.getFieldName();
						try {
							String value = item.getString("UTF-8");
						} catch (UnsupportedEncodingException e) {
							e.printStackTrace();
						}
					}else{
						String filename = item.getName();
						 if(filename==null || filename.trim().equals("")){
							 continue;
						 }
						 filename = filename.substring(filename.lastIndexOf("\\")+1);
						 try {
							InputStream in = item.getInputStream();
							FileOutputStream out = new FileOutputStream(savePath + "\\" + filename);
							byte buffer[] = new byte[1024];
							int len = 0;
							while((len=in.read(buffer))>0){
								out.write(buffer, 0, len);
							}
							in.close();
							out.close();
							item.delete();
						 } catch (IOException e) {
							e.printStackTrace();
						}
						 
					}
				}
			} catch (FileUploadException e) {
				e.printStackTrace();
			}
			
			String  pro_id = request.getParameter("pro_id");
			map.put("Lib", libName);
			map.put("ProID", pro_id);
			dataMap.put("Lib_Rule", new ArrayList<Object>().add(map));
		}
		
		//添加规则参数
		if(obj.get(ruleType)!=null){
			ArrayList<Object> ruleArrayList=(ArrayList<Object>) obj.get(ruleType);
			ruleArrayList.add(map);
			obj.put(ruleType, ruleArrayList);
		}else{
			obj.putAll(dataMap);
		}	
		
		
		//修改rules信息
		ArrayList<String> rules = (ArrayList<String>) obj.get("rules");
		rulesMap.put("type", ruleType);
		rulesMap.put("id",rule_id);
		rulesMap.put("data", map);
		obj.put(rules, rulesMap);
		ajax.setData(JSONObject.fromObject(rulesMap).toString());
		return ajax;
		
	}
	
	/***
	 * @author litao
	 * @describe 跳转到规则添加页面
	 * @return
	 */
	@RequestMapping(value="/addRule")
	public String  addRule(){
		return "basicRules/addRule";
		
	}
	
}
