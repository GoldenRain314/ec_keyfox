package com.keyware.base.service.itf.user;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.Sheet;

import com.keyware.base.repository.entity.Role;
import com.keyware.base.repository.entity.UserRole;
import com.keyware.base.repository.entity.user.User;
import com.keyware.base.task.util.AjaxMessage;

public interface UserService {
	int deleteByPrimaryKey(List<String> id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);
    
    List<User> selectAll(String userId);
    
    List<User> selectDepartUser(String departId);
    /**
     * 
     *@author 申鹏飞
     *@title 查询注销用户表
     *@param
     * @return
     *@date 2016-06-29
     */
    List<User> selectLogOutUser(String userName);
    /**
     * 
     * @Title: getUserCount
     * @Description: 判断是否是cookie登陆
     * @param user
     * @return
     * @return int
     */
    public User getCurrentUser();

    /**
     * 
     * @Title: login
     * @Description: 登陆 
     * @param userId		用户名
     * @param password		密码
     * @param isRemember
     * @param ip			IP
     * @param sessionId		分配的session ID
     * @return void
     */
	void login(String userId, String password, boolean isRemember, String ip,
			String sessionId);
	
	 /**
     * 
     * @Title: selectUserByUserId
     * @Description: 根据userid获取用户信息
     * @param userId
     * @return
     * @return User
     */
    public User selectUserByUserId(String userId);

    /**
     * 
     * @Title: logout
     * @Description: 退出
     * @return void
     */
	void logout();
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
	List<User> getUserIdName();
	/**
	 * @Title: updateLogout
     * @Description: 注销用户
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
     * @Description:userId更新数据
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
	List<User> pwdResetList(String initPwdTime);
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
	    
	 int count();
	 /**
	  *  *@author 申鹏飞
		 * @Title: updateSort
	     * @Description: 用户表上下移动
	     * @param record
	     * @return
	     */
	int updateSort(User record);
/*	*//**
     * 
     *@author 申鹏飞
     *@title 统计上移时前面用户的信息
     *@param
     * @return
     *@date 2016-06-29
     *//*
	User selectUpSort(String sort);
	*//**
     * 
     *@author 申鹏飞
     *@title 统计下移时前面用户的信息
     *@param
     * @return
     *@date 2016-06-29
     *//*
	User selectDownSort(String sort);*/

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getAddRoleUserList
	 * @Description: 获取角色用户关联
	 * @param role
	 * @return
	 * @return List<User>
	 */
	List<User> getAddRoleUserList(Role role);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: insert
	 * @Description: 建立 用户 角色关系表
	 * @param userRole
	 * @return void
	 */
	void insertUserRole(UserRole userRole);

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: deletetUserRole
	 * @Description: 删除角色用户关联关系
	 * @param userRole
	 * @return void
	 */
	void deletetUserRole(UserRole userRole);

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: deleteUserRoleByUserId
	 * @Description: 删除用户时级联删除角色用户关联关系表
	 * @param id
	 * @return void
	 */
	void deleteUserRoleByUserId(String id);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectUserCountByDeptId
	 * @Description: 统计部门下所有人员
	 * @param deptId
	 * @return
	 * @return Integer
	 */
	Integer selectUserCountByDeptId(String deptId);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectByUserNumber
	 * @Description: 根据用户编码查询用户信息
	 * @param userNumber
	 * @return
	 * @return List<User>
	 */
	List<User> selectByUserNumber(String userNumber);

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectBySearch
	 * @Description: 根据搜索的值查询用户
	 * @param value
	 * @return
	 * @return List<User>
	 */
	List<User> selectBySearch(String userName);
	
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
	List<User> selectAllUser();
	
	/**
	 * 
	 * @Title: checkFirstRowName
	 * @Description: 检查列是否和模板一致
	 * @param ajaxMessage
	 * @param sheetAt
	 * @author 赵亚舟
	 * @return void
	 */
	void checkFirstRowName(AjaxMessage ajaxMessage, Sheet sheet);
	
	/**
	 * 
	 * @Title: insertUser
	 * @Description: 验证数据格式并将数据插入数据库
	 * @param inserted		已插入行树
	 * @param skip			跳过行树
	 * @param sheet			excl sheet
	 * @author 赵亚舟
	 * @return void
	 */
	String insertUser(Sheet sheet,String sUserName,HttpServletRequest request);
	
}
