package com.keyware.base.controller.drawing;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.keyware.base.service.drawing.FlowCountService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/drawing")
public class DrawingController {
	
	@Resource
    private FlowCountService flowCountService;
	
	@Value("${mongodb.dbName}")
	String dbName;
	@Value("${mongodb.collTotalName}")
	String collTotalName;
	@Value("${mongodb.collTableName}")
	String collTableName;
	@Value("${filePath}")
	String filePath;
	
	@RequestMapping(value = "/packageNum")
    @ResponseBody
    public JSONArray packageNum(String date) {
        JSONArray lineDiagramEntity = flowCountService.selectPackageNum(date);
        System.out.println(dbName);
        //TODO 
//        ZJPFileMonitor m;
//        try {
//            m = new ZJPFileMonitor(5000);
//            m.monitor("", new ZJPFileListener(dbName,collTableName,collTotalName,filePath));
//            m.start();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
        return lineDiagramEntity;
    }
	
	
	@RequestMapping(value = "/appScale")
    @ResponseBody
    public JSONObject appScale(String date) {
		JSONObject jsonObject = flowCountService.selectAppScale(date);
        return jsonObject;
    }
	
	@RequestMapping(value = "/connectionInfor")
    @ResponseBody
    public JSONArray connectionInfor(String date) {
		JSONArray jsonArray = flowCountService.connectionInfor(date);
        return jsonArray;
    }
	
	
	@RequestMapping(value = "/boundFlowPackageNum")
    @ResponseBody
    public JSONArray boundFlowPackageNum(String date) {
		JSONArray jsonArray = flowCountService.boundFlowPackageNum(date);
		System.out.println(jsonArray);
        return jsonArray;
    }
	

}
