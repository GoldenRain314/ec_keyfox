package com.keyware.base.controller.tz;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.keyware.base.controller.BaseController;
import com.keyware.base.service.itf.rules.BasicRuleService;
import com.keyware.utils.bean.Config;
import com.keyware.utils.bean.Connect;
import com.keyware.utils.bean.Net;

import net.sf.json.JSONArray;


@Controller
@RequestMapping("/tzController")
public class TzController extends BaseController {
	
	public static Logger logger = Logger.getLogger(TzController.class);
	@Resource
	public BasicRuleService basicRuleService;
	
	@RequestMapping(value="/left_ztree")
	public String left_ztree(){
		return "iframeContent/left_ztree";
	}
	@RequestMapping(value="/middle_ztree_a")
	public String middle_ztree_a(){
		return "iframeContent/middle_ztree_a";
	}
	@RequestMapping(value="/middle_ztree_b")
	public String middle_ztree_b(){
		return "iframeContent/middle_ztree_b";
	}
	@RequestMapping(value="/middle_ztree_c")
	public String middle_ztree_c(){
		return "iframeContent/middle_ztree_c";
	}
	
	@RequestMapping(value="/right_container/111")
	public String x111(){
		return "iframeContent/right_container/111";
	}
	@RequestMapping(value="/right_container/DDOS")
	public String DDOS(){
		return "iframeContent/right_container/DDOS";
	}
	@RequestMapping(value="/right_container/guizeguanli")
	public ModelAndView guizeguanli(){
		ModelAndView modelAndView = new ModelAndView("iframeContent/right_container/guizeguanli");
		modelAndView.addObject("ruleList", JSONArray.fromObject(basicRuleService.selectAllRules()));
		return modelAndView;
	}
	@RequestMapping(value="/right_container/peizhijiemian")
	public String peizhijiemian(){
		return "iframeContent/right_container/peizhijiemian";
	}
	@RequestMapping(value="/right_container/tianjiaguize")
	public String tianjiaguize(){
		return "iframeContent/right_container/tianjiaguize";
	}
	@RequestMapping(value="/right_container/whole_flow")
	public String zhengtiliuliang(){
		return "iframeContent/right_container/whole_flow";
	}
	
	@RequestMapping(value = "/addConfig")
    @ResponseBody
	public Config addConfig(Config config,String VIP,String Network,String DMZ,String Extract_HTTP_Title){
		
		System.out.println(VIP);
		System.out.println(Network);
		System.out.println(DMZ);
		System.out.println(Extract_HTTP_Title);
		
		List<Net> VIPlist = new ArrayList<Net>();
		List<Net> Networklist = new ArrayList<Net>();
		List<Net> DMZlist = new ArrayList<Net>();
		List<String> Extract_HTTP_Titlelist = new ArrayList<String>();
		if(!"".equals(VIP)) {
			com.alibaba.fastjson.JSONArray parseArray = com.alibaba.fastjson.JSONArray.parseArray(VIP);
			for (Object object : parseArray) {
				Net net = JSONObject.parseObject(object.toString(), Net.class);
				VIPlist.add(net);
			}
			config.getIntraNet().setVIP(VIPlist);
		}
		if(!"".equals(Network)) {
			com.alibaba.fastjson.JSONArray parseArray = com.alibaba.fastjson.JSONArray.parseArray(Network);
			for (Object object : parseArray) {
				Net net = JSONObject.parseObject(object.toString(), Net.class);
				Networklist.add(net);
			}
			config.getIntraNet().setNetwork(Networklist);
		}
		if(!"".equals(DMZ)) {
			com.alibaba.fastjson.JSONArray parseArray = com.alibaba.fastjson.JSONArray.parseArray(DMZ);
			for (Object object : parseArray) {
				Net net = JSONObject.parseObject(object.toString(), Net.class);
				DMZlist.add(net);
			}
			config.getIntraNet().setDMZ(DMZlist);
		}
		if(!"".equals(Extract_HTTP_Title)) {
			com.alibaba.fastjson.JSONArray parseArray = com.alibaba.fastjson.JSONArray.parseArray(Extract_HTTP_Title);
			for (Object object : parseArray) {
				Extract_HTTP_Titlelist.add(object.toString());
			}
			config.setExtract_HTTP_Title(Extract_HTTP_Titlelist);
		}
		
		/*net.sf.json.JSONObject fromObject = net.sf.json.JSONObject.fromObject(config);
		System.out.println(fromObject.toString());*/
		System.out.println(config.toString());
		return config;
	}
	@RequestMapping(value = "/getConfig")
	@ResponseBody
	public Config getConfig(){
		try {
			String configTxt = FileUtils.readFileToString(new File("D:\\share\\Config.txt"),"UTF-8");
			System.out.println(configTxt);
			Config config = JSONObject.parseObject(configTxt, Config.class);
			Connect connect = config.getConnect();
			System.out.println(connect.getIsIP());
			return config;
		} catch (IOException e) {
			e.printStackTrace();
			return new Config();
		}
	}
}