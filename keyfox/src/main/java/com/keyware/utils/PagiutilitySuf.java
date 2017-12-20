package com.keyware.utils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;


public class PagiutilitySuf {
	
	public static Map<String,Object> pSuf(List result)
	{
		Map<String,Object> m = new HashMap<String,Object>();
//		PageInfo p = new PageInfo(result);
		Page p = (Page)result;
    	m.put("total", p.getTotal());
    	m.put("pageNumber", p.getPageNum());
    	m.put("pageSize", p.getPageSize());
    	m.put("rows", p);
		return m;
	}

}
