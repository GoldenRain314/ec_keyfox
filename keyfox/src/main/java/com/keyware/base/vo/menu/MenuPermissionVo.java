package com.keyware.base.vo.menu;

import com.keyware.base.repository.entity.MenuPermisson;

public class MenuPermissionVo extends MenuPermisson{
	private static final long serialVersionUID = 1L;
	
	private String permissionName;
	
	private String permission;
	
	private String permissionUrl;

	public String getPermissionName() {
		return permissionName;
	}

	public void setPermissionName(String permissionName) {
		this.permissionName = permissionName;
	}

	public String getPermission() {
		return permission;
	}

	public void setPermission(String permission) {
		this.permission = permission;
	}

	public String getPermissionUrl() {
		return permissionUrl;
	}

	public void setPermissionUrl(String permissionUrl) {
		this.permissionUrl = permissionUrl;
	}
	
}
