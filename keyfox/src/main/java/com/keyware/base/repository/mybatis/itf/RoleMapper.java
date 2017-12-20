package com.keyware.base.repository.mybatis.itf;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.keyware.base.repository.entity.Permission;
import com.keyware.base.repository.entity.Role;
import com.keyware.base.vo.user.UserVo;

public interface RoleMapper {
    int deleteByPrimaryKey(String roleId);

    int insert(Role record);

    int insertSelective(Role record);

    Role selectByPrimaryKey(String roleId);

    int updateByPrimaryKeySelective(Role record);

    int updateByPrimaryKey(Role record);
    
    //无调用   无主动调用,userMapper.xml自定义查询中调用
    List<Permission> selectRolePermission(String roleId);
    
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
     * @Description: 查询当前用户下所有角色
     * @param roleId
     * @return
     * @return List<User>
     */
	List<UserVo> selectRoleUserByRoleId(@Param("roleId")String roleId,@Param("projectSource")String projectSource);

	/**
	 *	@Title
	 *  @author 李涛
	 *  @param 
	 *  @date   2017年1月19日
	 *  @return List<Role>
	 */
	List<Role> selectByRoleSelect(Role roleSelect);
}