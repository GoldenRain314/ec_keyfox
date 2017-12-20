package com.keyware.base.repository.mybatis.itf;

import java.util.List;

import com.keyware.base.repository.entity.RoleMenu;

public interface RoleMenuMapper {
    int insert(RoleMenu record);

    List<RoleMenu> selectAll();
   
    /**
     * @Title: deleteByRoleId
     * @Description: 根据角色ID删除角色下所有菜单权限
     * @param roleId
     * @return
     * @return int
     */
    int deleteByRoleId(String roleId);
    
    /**
     * 
     * @author: 赵亚舟
     * @Title: selectByRoleId
     * @Description: 感觉角色ID查询有权限的菜单
     * @param roleId
     * @return
     * @return List<RoleMenu>
     */
    List<RoleMenu> selectByRoleId(String roleId);

    /**
     * 
     * @author: 赵亚舟
     * @Title: deleteByMenuId
     * @Description: 根据菜单ID删除
     * @param menuId
     * @return void
     */
	void deleteByMenuId(String menuId);
}