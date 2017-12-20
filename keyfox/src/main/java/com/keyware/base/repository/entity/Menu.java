package com.keyware.base.repository.entity;

import java.io.Serializable;
import java.util.List;

import com.keyware.base.vo.menu.MenuPermissionVo;

public class Menu implements Serializable{
	private static final long serialVersionUID = 5122834717831659944L;

	public String menuId;

    private Long menuLevel;

    private String parentId;

    private String menuName;

    private String menuUrl;

    private String status;

    private Long menuSeq;
    
    private String parentName;
    
    private String classType;
    
    private String isSys;
    
    private String projectSource;
    
    public String getProjectSource() {
		return projectSource;
	}

	public void setProjectSource(String projectSource) {
		this.projectSource = projectSource;
	}

	//所有二级菜单
    private List<Menu> childMenu;
    
    //二级权限下的权限点
    private List<MenuPermissionVo> permissions;
    

    public String getIsSys() {
		return isSys;
	}

	public void setIsSys(String isSys) {
		this.isSys = isSys;
	}

	public List<Menu> getChildMenu() {
		return childMenu;
	}

	public void setChildMenu(List<Menu> childMenu) {
		this.childMenu = childMenu;
	}

	public List<MenuPermissionVo> getPermissions() {
		return permissions;
	}

	public void setPermissions(List<MenuPermissionVo> permissions) {
		this.permissions = permissions;
	}

	public String getParentName() {
		return parentName;
	}

	public void setParentName(String parentName) {
		this.parentName = parentName;
	}

	public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId == null ? null : menuId.trim();
    }

    public Long getMenuLevel() {
        return menuLevel;
    }

    public void setMenuLevel(Long menuLevel) {
        this.menuLevel = menuLevel;
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId == null ? null : parentId.trim();
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName == null ? null : menuName.trim();
    }

    public String getMenuUrl() {
        return menuUrl;
    }

    public void setMenuUrl(String menuUrl) {
        this.menuUrl = menuUrl == null ? null : menuUrl.trim();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    public Long getMenuSeq() {
        return menuSeq;
    }

    public void setMenuSeq(Long menuSeq) {
        this.menuSeq = menuSeq;
    }

	public String getClassType() {
		return classType;
	}

	public void setClassType(String classType) {
		this.classType = classType;
	}
	
	@Override  
	public boolean equals(Object obj) {  
		Menu m = (Menu)obj;   
		return menuId.equals(m.getMenuId()) && menuName.equals(m.getMenuName());   
	}  
	
	@Override  
	public int hashCode() {  
		String in = menuId + menuName;  
		return in.hashCode();  
	}  
	
}