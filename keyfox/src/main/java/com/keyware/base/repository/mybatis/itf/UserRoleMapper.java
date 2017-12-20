package com.keyware.base.repository.mybatis.itf;

import java.util.List;

import com.keyware.base.repository.entity.UserRole;

public interface UserRoleMapper {
    int insert(UserRole record);

    List<UserRole> selectAll();
    
    /**
     * 
     * @Title: deleteByUserId
     * @Description: 根据userId 删除关联关系  userID指的是user表中的ID列
     * @param userId
     * @return
     * @return int
     */
    int deleteByUserId(String userId);

    /**
     * 
     * @author: 赵亚舟
     * @Title: deletetUserRole
     * @Description: 删除关联关系表
     * @param userRole
     * @return void
     */
	void deletetUserRole(UserRole userRole);
	
	/**
	 * 
	 * @Title: selectByUserId
	 * @Description: 
	 * @param userId
	 * @return
	 * @author 李军荣
	 * @return String
	 */
	List<String> selectByUserId(String userId);
}