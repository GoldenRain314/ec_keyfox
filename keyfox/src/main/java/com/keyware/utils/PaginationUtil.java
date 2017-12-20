package com.keyware.utils;

import java.io.Serializable;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.util.StringUtils;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;

/**
 * 作     者：zhangxinm
 * 
 * 说     明：分页信息及分页工具类
 * 
 * 创建时间：2015-5-13
 */
public class PaginationUtil implements Serializable{

	private int DEFAULT_PAGE_SIZE = 10;
	
	private static final long serialVersionUID = 1L;

	private String url = "";//请求地址
	
	private int pageNo = 1;//当前页码
	
	private int pageSize = 10;//每页显示条数
	
	@SuppressWarnings("rawtypes")
	private Page rows;//查询结果数据集
	
	private int prePage = 1;//上一页
	
	private Integer nextPage = 1;//下一页
	
	private int pageCount = 0;//分页数量，即总共有几页
	
	private Map<String, String> paramMap = new HashMap<String, String>();//查询条件，Key 是属性名， Value是属性值
	
	private int totalCount = 0;//记录总条数
	
	@SuppressWarnings("unused")
	private int startIndex;//记录开始的索引
	
	
	public PaginationUtil() {}
	
	public PaginationUtil(String url) {
		this.url = url;
	}
	
	public PaginationUtil(int totalCOunt, int pageNo, int pageSize, String url) {
		this.url = url;
		if (totalCOunt <= 0) {
			this.totalCount = 0;
		} else {
			this.totalCount = totalCOunt;
		}
		if(pageNo <= 0) {
			this.pageNo = 1;
		} else {
			this.pageNo = pageNo;
		}
		
		if (pageSize <= 0) {
			this.pageSize = DEFAULT_PAGE_SIZE;
		} else {
			this.pageSize = pageSize;
		}
		
		//计算其他值
		this.pageCount = this.totalCount/this.pageSize + (this.totalCount%this.pageSize == 0 ? 0 : 1);
	} 
	
	//计算总页数
	public void adjust() {
		
		if (this.totalCount <= 0) {
			this.totalCount = 0;
		}
		if (this.pageSize <= 0) {
			this.pageSize = DEFAULT_PAGE_SIZE;
		}
		//计算其他值
		this.pageCount = this.totalCount/this.pageSize + (this.totalCount%this.pageSize == 0 ? 0 : 1);
		
		if(this.pageNo <= 0) {
			this.pageNo = 1;
		} else if (this.pageNo >= this.pageCount){
			this.pageNo = this.pageCount;
		}
		
		if(this.pageNo - 1 < 1) {
			this.prePage = 1;
		} else {
			this.prePage = this.pageNo - 1;
		}

		if(this.pageNo + 1 > this.pageCount) {
			this.nextPage = this.pageCount;
		} else {
			this.nextPage =  this.pageNo + 1;
		}
	}
	/**
	 * 
	 * 作者：陈川华
	 *
	 * 参数说明：@param key
	 * 参数说明：@param value
	 *
	 * 作用说明： 将查询条件放入Map中
	 *
	 * 创建时间：2014-4-19
	 *
	 */
	public void put(String key, String value) {
		this.paramMap.put(key, value);
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public int getPrePage() {
		return this.prePage;
//		if(this.pageNo - 1 < 1) {
//			return 1;
//		} else {
//			return this.pageNo - 1;
//		}
	}

	public void setPrePage(int prePage) {
		this.prePage = prePage;
	}

	public Integer getNextPage() {
		return this.nextPage;
//		if(this.pageNo + 1 > this.pageCount) {
//			return this.pageCount;
//		} else {
//			return this.pageNo + 1;
//		}
	}

	public void setNextPage(Integer nextPage) {
		this.nextPage = nextPage;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public Map<String, String> getParamMap() {
		return paramMap;
	}

	public void setParamMap(Map<String, String> paramMap) {
		this.paramMap = paramMap;
	}

	public int getStartIndex() {
		return (this.pageNo - 1)* this.pageSize;
	}

	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}

	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getPageCount() {
		return pageCount;
	}

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	
	@SuppressWarnings("rawtypes")
	public Page getRows() {
		return rows;
	}

	@SuppressWarnings("rawtypes")
	public void setRows(Page rows) {
		this.rows = rows;
	}
	
	/**
	 * 获取分页请求信息
	 * @param request
	 * @param pagination
	 * @return
	 */
	public void before(HttpServletRequest request) {
		Enumeration<String>	en = request.getParameterNames();
		String pageNoStr = request.getParameter("pageNo");
		if (!StringUtils.hasText(pageNoStr)) {
			pageNoStr = "1";
		}
		String pageSizeStr = request.getParameter("pageSize"); 
		if (!StringUtils.hasText(pageSizeStr)) {
			pageSizeStr = "10";
		}
		int pageNo = Integer.parseInt(pageNoStr);
		int pageSize = Integer.parseInt(pageSizeStr);
		//读取参数
		while (en.hasMoreElements()) {
			String name = en.nextElement();
//			if (name.startsWith("page_")) {
//				pagination.put(name.substring(5), request.getParameter(name));
//			}
			if(!"pageNo".equals(name) && !"pageSize".equals(name)){
				this.put(name, request.getParameter(name));
			}
		}
		this.setPageNo(pageNo);
		this.setPageSize(pageSize);
		//PageHelper，负责mybatis的自动分页
		PageHelper.startPage(pageNo, pageSize);
	}
	
	/**
	 * 封装查询结果信息
	 * @param result
	 */
	@SuppressWarnings("rawtypes")
	public void after(List result){
		Page p = null;
		if (result == null) {
			p= new Page();
		} else {
			p = (Page)result;
			/*p= new Page();
			for(Object object :result){
				p.add(object);
			}*/
			
		}
		this.totalCount = (int) p.getTotal();
		this.pageCount = p.getPageNum();
		this.pageSize = p.getPageSize();
		this.rows = p;
		this.adjust();//计算总页数
	}
}
