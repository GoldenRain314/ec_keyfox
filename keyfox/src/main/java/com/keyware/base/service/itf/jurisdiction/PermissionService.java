package com.keyware.base.service.itf.jurisdiction;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.keyware.base.repository.entity.Permission;

public interface PermissionService {

	int deleteByPrimaryKey(String permissionId);
	
    int insertSelective(Permission record);

    Permission selectByPrimaryKey(String permissionId);

    int updateByPrimaryKeySelective(Permission record);

    
    /**
     * 
     * @Title: getPermissionByAccountId
     * @Description: 根据userId获取权限点集合
     * @param userId
     * @return
     * @return List<Permission>
     */
    List<Permission> getPermissionByAccountId(@Param("userId")String userId);
    
    /**
     * 
     * @author: 赵亚舟
     * @Title: selectByPermission
     * @Description: 根据权限表查询
     * @param record
     * @return
     * @return List<Permission>
     */
    List<Permission> selectByPermission(Permission record);

    /**
     * 
     * @author: 赵亚舟
     * @Title: getNoMenuPermissionList
     * @Description: 获取未关联菜单的权限
     * @return
     * @return List<Permission>
     */
	List<Permission> getNoMenuPermissionList();

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: deletePermissionCorrelationByPermissionId
	 * @Description: 删除权限点 删除 PERMISSION、ROLE_PERMISSON、MENU_PERMISSON
	 * @param id
	 * @return void
	 */
	void deletePermissionCorrelationByPermissionId(String id);
}
