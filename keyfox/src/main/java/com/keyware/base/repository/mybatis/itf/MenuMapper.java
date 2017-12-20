package com.keyware.base.repository.mybatis.itf;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.keyware.base.repository.entity.Menu;
import com.keyware.base.vo.menu.menuVo;

public interface MenuMapper {
	
	List<Menu> selectAll(@Param("projectSource")String projectSource);
	
    int deleteByPrimaryKey(String menuId);

    int insert(Menu record);

    int insertSelective(Menu record);

    Menu selectByPrimaryKey(String menuId);

    int updateByPrimaryKeySelective(Menu record);

    int updateByPrimaryKey(Menu record);
    
    /**
     * 
     * @Title: getTheOneLevelMenuBasedOnTheAccountID
     * @Description: 获取用户账号下的一级菜单权限
     * @param userId		用户登陆名
     * @return
     * @return List<Menu>
     */
    List<Menu> getTheLevelMenuBasedOnTheAccountID(@Param("userId") String userId,@Param("projectSource")String projectSource);
    
    /**
     * 
     * @Title: getTheOneLevelMenuBasedOnTheAccountID
     * @Description: 获取用户账号下的二级菜单权限
     * @param userId		用户登陆名
     * @param menuId		一级菜单权限
     * @return
     * @return List<Menu>
     */
    List<menuVo> getTwoTheLevelMenuBasedOnTheAccountID(@Param("userId") String userId,@Param("projectSource")String projectSource,@Param("menuId") String menuId,@Param("isSys")String isSys);
    /**
     * 
     * @Title: getTheThreeLevelMenuBasedOnTheAccountID
     * @Description: 获取用户账号下的相应的所有三级菜单
     * @param userId		用户登陆名
     * @param menuId		二级菜单权限
     * @return
     * @return List<Menu>
     */
	List<menuVo> getThreeTheLevelMenuBasedOnTheAccountID(@Param("userId") String userId,@Param("projectSource")String projectSource,@Param("menuId") String menuId);
    
    /**
     * 
     * @Title: selectByMneu
     * @Description: 根据菜单查询
     * @param menu
     * @return
     * @return List<Menu>
     */
    List<Menu> selectByMneu(Menu menu);

    /**
     * 
     * @author: 赵亚舟
     * @Title: selectAllFirst
     * @Description: 查询所有一级菜单
     * @return
     * @return List<Menu>
     */
	List<Menu> selectAllFirst(@Param("projectSource")String projectSource);
	/**
     * 
     * @author: 代钢
     * @Title: selectAllFirst
     * @Description: 查询所有二级菜单
     * @return
     * @return List<Menu>
     */
	List<Menu> selectAllSecond(@Param("projectSource")String projectSource);
	
	
	/**
	 * 
	 *	@Title 根据菜单查询名称查询menuName
	 *  @author 李涛
	 *  @param 
	 *  @date   2016年10月20日
	 *  @return Menu
	 */
    Menu selectByName(@Param("menuName")String menuName,@Param("projectSource")String projectSource);
    
    /**
     * 
     * @Title: selectChildNodeByParentIdOrMenuId
     * @Description: 查询子节点和下一级子节点,当第一个参数为一级界面的ID第二个参数为空时,返回结果为内容是二级菜单和三级菜单。
     * 									当一个参数为空第二个参数有值时，返回结果为当前菜单信息和所有子菜单
     * @param parentId
     * @param menuId
     * @return
     * @author 赵亚舟
     * @return List<menuVo>
     */
	List<menuVo> selectChildNodeByParentIdOrMenuId(@Param("parentId")String parentId,@Param("menuId")String menuId);
    	
}