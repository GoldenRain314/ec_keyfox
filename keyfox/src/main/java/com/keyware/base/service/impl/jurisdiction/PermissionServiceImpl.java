package com.keyware.base.service.impl.jurisdiction;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.keyware.base.repository.entity.Permission;
import com.keyware.base.repository.mybatis.itf.MenuPermissonMapper;
import com.keyware.base.repository.mybatis.itf.PermissionMapper;
import com.keyware.base.repository.mybatis.itf.RolePermissionMapper;
import com.keyware.base.service.itf.jurisdiction.PermissionService;
import com.keyware.base.utils.Constant;

@Service
public class PermissionServiceImpl implements PermissionService {

	@Autowired
	private PermissionMapper permissionMapper;
	
	@Autowired
	private RolePermissionMapper rolePermissionMapper;
	
	@Autowired
	private MenuPermissonMapper menuPermissonMapper;
	
	@Override
	public int deleteByPrimaryKey(String permissionId) {
		return permissionMapper.deleteByPrimaryKey(permissionId);
	}

	@Override
	public int insertSelective(Permission record) {
		record.setProjectSource(Constant.projectName);
		return permissionMapper.insertSelective(record);
	}

	@Override
	public Permission selectByPrimaryKey(String permissionId) {
		return permissionMapper.selectByPrimaryKey(permissionId);
	}

	@Override
	public int updateByPrimaryKeySelective(Permission record) {
		return permissionMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public List<Permission> getPermissionByAccountId(String userId) {
		return permissionMapper.getPermissionByAccountId(userId,Constant.projectName);
	}

	@Override
	public List<Permission> selectByPermission(Permission record) {
		record.setProjectSource(Constant.projectName);
		return permissionMapper.selectByPermission(record);
	}

	@Override
	public List<Permission> getNoMenuPermissionList() {
		return permissionMapper.getNoMenuPermissionList(Constant.projectName);
	}

	@Transactional
	@Override
	public void deletePermissionCorrelationByPermissionId(String permissionId) {
		//删除权限点表
		this.deleteByPrimaryKey(permissionId);
		//删除角色 权限 关联关系表
		rolePermissionMapper.deleteByPermission(permissionId);
		
		//删除 菜单 权限 关联关系表
		menuPermissonMapper.deleteByPermissionId(permissionId);
		
	}

}
