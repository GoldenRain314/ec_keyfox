package com.keyware.utils;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class IdComposeListUtil {
	/**
	 * 
	 *@author 申鹏飞
	 *@title 解析bootstrap中选中行的id并形成list
	 *@param
	 * @return
	 *@date
	 */
	public static List<String> listId(HttpServletRequest request){
		String rows=request.getParameter("rows");
		JSONArray jsonId = JSONArray.fromObject(rows); // 首先把字符串转成 JSONArray  对象
		ArrayList<String> listId=new ArrayList<String>();
		if(jsonId.size()>0){
			for(int j=0;j<jsonId.size();j++){
				JSONObject jobId = jsonId.getJSONObject(j);  // 遍历 jsonarray 数组，把每一个对象转成 json 对象
				listId.add(jobId.get("id").toString());
			}
		}
		return listId;
	}
}
