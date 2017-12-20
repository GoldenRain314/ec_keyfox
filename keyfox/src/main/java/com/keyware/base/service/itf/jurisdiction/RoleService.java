package com.keyware.base.service.itf.jurisdiction;

import java.util.List;

import com.keyware.base.repository.entity.Role;
import com.keyware.base.repository.entity.RoleMenu;
import com.keyware.base.repository.entity.RolePermission;
import com.keyware.base.vo.user.UserVo;

public interface RoleService {

	int deleteByPrimaryKey(String roleId);

    int insertSelective(Role record);

    Role selectByPrimaryKey(String roleId);

    int updateByPrimaryKeySelective(Role record);
    
    /**
     * 
     * @Title: selectByRole
     * @Description: 根据任意属性查询
     * @param role
     * @return
     * @return List<Role>
     */
    List<Role> selectByRole(Role role);

    /**
     * 
     * @author: 赵亚舟
     * @Title: selectRoleUserByRoleId
     * @Description: 查询当前角色下所有用户
     * @param roleId
     * @return
     * @return List<User>
     */
	List<UserVo> selectRoleUserByRoleId(String roleId);
	
	 /**
     * 
     * @author: 赵亚舟
     * @Title: selectByRoleId
     * @Description: 感觉角色ID查询有权限的菜单
     * @param roleId
     * @return
     * @return List<RoleMenu>
     */
    List<RoleMenu> selectRoleMenuByRoleId(String roleId);
    
    /**
     * 
     * @author: 赵亚舟
     * @Title: selectByRoleId
     * @Description: 根据角色ID查询相关权限点
     * @param roleId
     * @return
     * @return List<RolePermission>
     */
    List<RolePermission> selectRolePermissionByRoleId(String roleId);

    /**
     * 
     * @author: 赵亚舟
     * @Title: deleteRoleMenuAndPermission
     * @Description: 根据角色ID删除菜单和
     * @param roleId
     * @return void
     */
	void deleteRoleMenuAndPermission(String roleId);

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: insertRoleMenuAndPermission
	 * @Description: 修改权限关联关系表
	 * @param permissions
	 * @param roleId
	 * @return void
	 */
	void insertRoleMenuAndPermission(String permissions, String roleId);

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: deleteByRoleId
	 * @Description: 删除角色表
	 * @param roleId
	 * @return void
	 */
	void deleteByRoleId(String roleId);

	/**
	 *	@Title
	 *  @author 李涛
	 *  @param 
	 *  @date   2017年1月19日
	 *  @return List<Role>
	 */
	List<Role> selectByRoleSelect(Role roleSelect);
	
    
}
