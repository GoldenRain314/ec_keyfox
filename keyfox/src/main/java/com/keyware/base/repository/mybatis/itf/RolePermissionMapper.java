package com.keyware.base.repository.mybatis.itf;

import java.util.List;

import com.keyware.base.repository.entity.RolePermission;

public interface RolePermissionMapper {
    int insert(RolePermission record);

    List<RolePermission> selectAll();
    
    /**
     * @Title: deleteByRoleId
     * @Description: 根据角色ID删除关联权限信息
     * @param roleId
     * @return
     * @return int
     */
    int deleteByRoleId(String roleId);
    
    /**
     * 
     * @author: 赵亚舟
     * @Title: selectByRoleId
     * @Description: 根据角色ID查询相关权限点
     * @param roleId
     * @return
     * @return List<RolePermission>
     */
    List<RolePermission> selectByRoleId(String roleId);

    /**
     * 
     * @author: 赵亚舟
     * @Title: deleteByPermission
     * @Description: 根据权限点ID删除所有角色下次权限
     * @param permissionId
     * @return void
     */
	void deleteByPermission(String permissionId);
}