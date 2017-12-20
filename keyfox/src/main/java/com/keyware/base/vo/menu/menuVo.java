package com.keyware.base.vo.menu;

import java.util.List;

import com.keyware.base.repository.entity.Menu;

public class menuVo extends Menu{
	    
	private static final long serialVersionUID = -4804232272476824112L;

	private String name;
	
	private String url;
	
	private List<Menu> childMenuList;
	
	public List<Menu> getChildMenuList() {
		return childMenuList;
	}

	public void setChildMenuList(List<Menu> childMenuList) {
		this.childMenuList = childMenuList;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	
	@Override  
	public boolean equals(Object obj) {  
		menuVo m = (menuVo)obj;   
		return super.menuId.equals(m.getMenuId()) && name.equals(m.getName());   
	}  
	
	@Override  
	public int hashCode() {  
		String in = menuId + name;  
		return in.hashCode();  
	}
	
}
