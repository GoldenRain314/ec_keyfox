package com.keyware.base.service.drawing;


import net.sf.json.JSONArray;

/**
 * 获取流量
 * Created by Administrator on 2017/12/19.
 */
public interface  FlowCountService {

    JSONArray selectFlowState(String date);

    JSONArray themeRiver(String date);
    
    JSONArray selectAppScale(String date);
}
