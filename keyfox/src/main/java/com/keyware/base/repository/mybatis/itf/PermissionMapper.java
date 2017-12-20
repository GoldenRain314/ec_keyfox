package com.keyware.base.repository.mybatis.itf;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.keyware.base.repository.entity.Permission;

public interface PermissionMapper {
    int deleteByPrimaryKey(String permissionId);

    int insert(Permission record);

    int insertSelective(Permission record);

    Permission selectByPrimaryKey(String permissionId);

    int updateByPrimaryKeySelective(Permission record);

    int updateByPrimaryKey(Permission record);
    
    /**
     * 
     * @Title: getPermissionByAccountId
     * @Description: 根据userId获取权限点集合
     * @param userId
     * @return
     * @return List<Permission>
     */
    List<Permission> getPermissionByAccountId(@Param("userId")String userId,@Param("projectSource")String projectSource);
    
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
    
    List<Permission> getNoMenuPermissionList(@Param("projectSource")String projectSource);
}