package com.keyware.base.repository.entity;

import java.io.Serializable;

public class MenuPermisson implements Serializable{
	private static final long serialVersionUID = -531320509480828319L;

	private String menuId;

    private String permissionId;

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId == null ? null : menuId.trim();
    }

    public String getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(String permissionId) {
        this.permissionId = permissionId == null ? null : permissionId.trim();
    }
}