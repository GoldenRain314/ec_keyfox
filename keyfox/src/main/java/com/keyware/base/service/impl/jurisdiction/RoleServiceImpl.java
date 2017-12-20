package com.keyware.base.service.impl.jurisdiction;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.keyware.base.repository.entity.Role;
import com.keyware.base.repository.entity.RoleMenu;
import com.keyware.base.repository.entity.RolePermission;
import com.keyware.base.repository.entity.UserRole;
import com.keyware.base.repository.mybatis.itf.RoleMapper;
import com.keyware.base.repository.mybatis.itf.RoleMenuMapper;
import com.keyware.base.repository.mybatis.itf.RolePermissionMapper;
import com.keyware.base.repository.mybatis.itf.UserRoleMapper;
import com.keyware.base.service.itf.jurisdiction.RoleService;
import com.keyware.base.utils.Constant;
import com.keyware.base.vo.user.UserVo;

@Service
public class RoleServiceImpl implements RoleService {

	@Autowired
	private RoleMapper roleMapper;
	
	@Autowired
	private RoleMenuMapper roleMenuMapper;
	
	@Autowired
	private RolePermissionMapper rolePermissionMapper;
	
	@Autowired
	private UserRoleMapper userRoleMapper;
	
	@Override
	public int deleteByPrimaryKey(String roleId) {
		return roleMapper.deleteByPrimaryKey(roleId);
	}

	@Override
	public int insertSelective(Role record) {
		record.setProjectSource(Constant.projectName);
		return roleMapper.insertSelective(record);
	}

	@Override
	public Role selectByPrimaryKey(String roleId) {
		return roleMapper.selectByPrimaryKey(roleId);
	}

	@Override
	public int updateByPrimaryKeySelective(Role record) {
		return roleMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public List<Role> selectByRole(Role role) {
		role.setProjectSource(Constant.projectName);
		return roleMapper.selectByRole(role);
	}

	@Override
	public List<UserVo> selectRoleUserByRoleId(String roleId) {
		return roleMapper.selectRoleUserByRoleId(roleId,Constant.projectName);
	}

	@Override
	public List<RoleMenu> selectRoleMenuByRoleId(String roleId) {
		return roleMenuMapper.selectByRoleId(roleId);
	}

	@Override
	public List<RolePermission> selectRolePermissionByRoleId(String roleId) {
		return rolePermissionMapper.selectByRoleId(roleId);
	}
	
	@Override
	public void deleteRoleMenuAndPermission(String roleId) {
		roleMenuMapper.deleteByRoleId(roleId);
		rolePermissionMapper.deleteByRoleId(roleId);
	}

	@Transactional
	@Override
	public void insertRoleMenuAndPermission(String permissions, String roleId) {
		if(StringUtils.hasText(roleId)){
			//首先删除所有关联关系
			deleteRoleMenuAndPermission(roleId);
			//插入新的关联关系
			JSONArray jsonArray = JSONArray.fromObject("["+permissions+"]");
			if(jsonArray.size() > 0){
				for (int i = 0; i < jsonArray.size(); i++) {
					JSONObject object = (JSONObject) jsonArray.get(i);
					String id = (String) object.get("id");
					String value = object.getString("value");
					if("1".equals(value)){
						RoleMenu roleMenu = new RoleMenu();
						roleMenu.setRoleId(roleId);
						roleMenu.setMenuId(id);
						//菜单
						roleMenuMapper.insert(roleMenu);
					}else if("2".equals(value)){
						RolePermission rolePermission = new RolePermission();
						rolePermission.setRoleId(roleId);
						rolePermission.setPermissionId(id);
						rolePermissionMapper.insert(rolePermission);
					}
				}
			}
		}
	}

	@Transactional
	@Override
	public void deleteByRoleId(String roleId) {
		//删除觉得表中关联关系
		this.deleteByPrimaryKey(roleId);
		
		//删除角色和菜单权限的关联关系
		roleMenuMapper.deleteByRoleId(roleId);
		
		//删除 角色和 权限的关联关系
		rolePermissionMapper.deleteByRoleId(roleId);
		
		UserRole userRole = new UserRole();
		userRole.setRoleId(roleId);
		userRoleMapper.deletetUserRole(userRole );
	}

	@Override
	public List<Role> selectByRoleSelect(Role roleSelect) {
		roleSelect.setProjectSource(Constant.projectName);
		return roleMapper.selectByRoleSelect(roleSelect);
	}
	
	

}
