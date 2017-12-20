package com.keyware.base.repository.mybatis.itf.user;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.keyware.base.repository.entity.Role;
import com.keyware.base.repository.entity.user.User;

public interface UserMapper {
	
    int deleteByPrimaryKey(List<String> id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String id);

    List<User> selectByUserId(@Param("userId")String userId,@Param("projectSource")String projectSource);
    
    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);
    
    List<User> selectAll(@Param("userId")String userId,@Param("projectSource")String projectSource);
    
    List<User> selectDepartUser(@Param("departId")String departId,@Param("projectSource")String projectSource);
    /**
     * 
     *@author 申鹏飞
     *@title 查询注销用户表
     *@param
     * @return
     *@date 2016-06-29
     */
    List<User> selectLogOutUser(@Param("userName")String userName,@Param("projectSource")String projectSource);
    /**
     * 
     * @Title: selectUserExtByUserAccount
     * @Description: 根据userId查询用户包括权限信息
     * @param userAccount
     * @return
     * @return User
     */
    User selectUserExtByUserAccount(@Param("userId")String userId,@Param("projectSource")String projectSource);
    
    
    User selectUserExtByUserIdForUser(@Param("userId")String userId,@Param("projectSource")String projectSource);
    
    /**
     * 
     * @Title: selectUserByUserId
     * @Description: 根据userid获取用户信息
     * @param userId
     * @return
     * @return User
     */
    public User selectUserByUserId(@Param("userId")String userId,@Param("projectSource")String projectSource);
    /**
	 * @Title: updateStatus
     * @Description: 更换用户状态
     * @param id,status
     * @return
     * 
	 */
	int updateStatus(User record);
	/**
	 * @Title: updateLock
     * @Description: 更换用户锁定状态
     * @param id,status
     * @return
     * 
	 */
	int updateLock(User record);
	/**
	 * @Title: Unlock
     * @Description: 解锁
     * @param 
     * @return
     */
	int unlock(List<?> record);
	/**
	 * @Title: 获取userId,userName
     * @Description: 
     * @param userId,userName
     * @return
     * 
	 */
	List<User> getUserIdName(@Param("projectSource")String projectSource);
	/**
	 * @Title: updateLogout
     * @Description: 注销还原用户
     * @param record
     * @return
     */
	int updateLogout(List record);
	/**
	 * @Title: recovery
     * @Description: 还原用户
     * @param record
     * @return
     */
	int recovery(List record);
	
	/**
	 * @Title: 
     * @Description:更加userId更新数据
     * @param record
     * @return
     */
	int updateByPrimaryUserId(User record);
	
	/**
	 * @Title: 
     * @Description:初始密码列表
     * @param initPwdTime
     * @return
     */
	List<User> pwdResetList(@Param("userName")String userName,@Param("projectSource")String projectSource);
	/**
	 * @Title: 
     * @Description:删除密码重置表
     * @param initPwdTime
     * @return
     */
	int delPwdResetList(List listId);
	/**
     * 
     *@author 申鹏飞
     *@title 统计用户总数
     *@param
     * @return
     *@date 2016-06-29
     */
	    
	 int count(@Param("projectSource")String projectSource);
	 /**
	  *  *@author 申鹏飞
		 * @Title: updateSort
	     * @Description: 用户表上下移动
	     * @param record
	     * @return
	     */
	int updateSort(User record);
	/**
     * 
     *@author 申鹏飞
     *@title 统计上移时前面用户的信息
     *@param
     * @return
     *@date 2016-06-29
     */
	User selectUpSort(@Param("sort")String sort,@Param("projectSource")String projectSource);
	/**
     * 
     *@author 申鹏飞
     *@title 统计下移时前面用户的信息
     *@param
     * @return
     *@date 2016-06-29
     */
	User selectDownSort(String sort);

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getAddRoleUserList
	 * @Description: 根据角色ID获取 除了当前觉得外所有用户
	 * @param role
	 * @return
	 * @return List<User>
	 */
	List<User> getAddRoleUserList(Role role);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectUserCountByDeptId
	 * @Description: 统计部门下所有人员
	 * @param deptId
	 * @return
	 * @return Integer
	 */
	Integer selectUserCountByDeptId(@Param("deptId")String deptId,@Param("projectSource")String projectSource);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectByUserNumber
	 * @Description: 根据用户编码查询用户信息
	 * @param userNumber
	 * @return
	 * @return List<User>
	 */
	List<User> selectByUserNumber(@Param("userNumber")String userNumber,@Param("projectSource")String projectSource);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectBySearch
	 * @Description: 模糊查询
	 * @param userName
	 * @return
	 * @return List<User>
	 */
	List<User> selectBySearch(@Param("userName")String userName,@Param("projectSource")String projectSource);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectByUserInfo
	 * @Description: 根据属性查询
	 * @param user
	 * @return
	 * @return List<User>
	 */
	List<User> selectByUserInfo(User user);
	
	/**
	 * 
	 *	@Title 查询所有用户
	 *  @author 李涛 
	 *  @param 
	 *  @date   2016年11月9日
	 *  @return List<User>
	 */
	List<User> selectAllUser(@Param("projectSource")String projectSource);
}