package com.keyware.base.service.drawing;


import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 获取流量
 * Created by Administrator on 2017/12/19.
 */
public interface  FlowCountService {
	
	/**
	 * 获取包数数据
	 * @param date
	 * @return
	 */
    JSONArray selectPackageNum(String date);

    /**
     * 获取应用比例
     * @param date
     * @return
     */
    JSONObject selectAppScale(String date);
    
    /**
     * 获取连接信息
     * @param date
     * @return
     */
    JSONArray connectionInfor(String date);
    
    /**
     * 边界流量-包数
     */
    JSONArray boundFlowPackageNum(String date);
    
    /**
     * 边界流量-包数
     */
    JSONArray boundFlowPackageNum(String date);
    
}
