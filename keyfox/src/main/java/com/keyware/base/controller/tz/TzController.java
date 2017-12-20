package com.keyware.base.controller.tz;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.keyware.base.controller.BaseController;


@Controller
@RequestMapping("/tzController")
public class TzController extends BaseController {
	
	public static Logger logger = Logger.getLogger(TzController.class);
	
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
	public String guizeguanli(){
		return "iframeContent/right_container/guizeguanli";
	}
	@RequestMapping(value="/right_container/peizhijiemian")
	public String peizhijiemian(){
		return "iframeContent/right_container/peizhijiemian";
	}
	@RequestMapping(value="/right_container/tianjiaguize")
	public String tianjiaguize(){
		return "iframeContent/right_container/tianjiaguize";
	}
	@RequestMapping(value="/right_container/zhengtiliuliang")
	public String zhengtiliuliang(){
		return "iframeContent/right_container/zhengtiliuliang";
	}
	
}



