package com.keyware.utils;

import javax.servlet.http.HttpServletRequest;

import org.springframework.util.StringUtils;

import com.github.pagehelper.PageHelper;


public class PagiutilityPre {
	public static void pPre(HttpServletRequest r)
	{
		String limit = r.getParameter("limit");
		String pn = r.getParameter("pn");
		int fps;
		int fpn;
		try {
			fps = StringUtils.hasText(limit)? Integer.valueOf(limit) : 10;
		} catch (Exception e) {
			fps = 10;
		}
		try {
			fpn = StringUtils.hasText(pn)? Integer.valueOf(pn) : 1;
		} catch (Exception e) {
			fpn = 1;
		}
		PageHelper.startPage(fpn, fps);
	}
}
