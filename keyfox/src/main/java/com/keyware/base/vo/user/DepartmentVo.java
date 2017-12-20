package com.keyware.base.vo.user;

import com.keyware.base.repository.entity.department.Department;

public class DepartmentVo extends Department{

	private String parentDeptName;

	public String getParentDeptName() {
		return parentDeptName;
	}

	public void setParentDeptName(String parentDeptName) {
		this.parentDeptName = parentDeptName;
	}
	
}
