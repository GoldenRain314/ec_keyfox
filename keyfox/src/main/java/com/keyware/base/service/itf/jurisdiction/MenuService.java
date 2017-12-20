package com.keyware.base.service.itf.jurisdiction;

import java.util.List;

import com.keyware.base.repository.entity.Menu;
import com.keyware.base.repository.entity.MenuPermisson;
import com.keyware.base.vo.menu.MenuPermissionVo;
import com.keyware.base.vo.menu.menuVo;

public interface MenuService {

	List<Menu> selectAll();
	
	int deleteByPrimaryKey(String menuId);
	
    int insert(Menu record);

    int insertSelective(Menu record);

    Menu selectByPrimaryKey(String menuId);

    int updateByPrimaryKeySelective(Menu record);

    int updateByPrimaryKey(Menu record);
    
    /**
     * 
     * @Title: getTheOneLevelMenuBasedOnTheAccountID
     * @Description: 获取用户账号下的相应的所有一级菜单
     * @param userId
     * @return
     * @return List<Menu>
     */
	List<Menu> getTheOneLevelMenuBasedOnTheAccountID(String userId);
	
	/**
     * 
     * @Title: getTheTwoLevelMenuBasedOnTheAccountID
     * @Description: 获取用户账号下的相应的所有二级菜单
     * @param userId
     * @return
     * @return List<Menu>
     */
	List<menuVo> getTheTwoLevelMenuBasedOnTheAccountID(String userId,String menuId,String isSys);
	/**
     * 
     * @Title: getThreeTheLevelMenuBasedOnTheAccountID
     * @Description: 获取用户账号下的相应的所有三级菜单
     * @param userId
     * @return
     * @return List<Menu>
     */
	List<menuVo> getThreeTheLevelMenuBasedOnTheAccountID(String userId,String menuId);
	
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
	List<Menu> selectAllFirst();
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getMenuPermissonByMenuId
	 * @Description: 根据菜单ID获取菜单下所有权限
	 * @param menuId
	 * @return
	 * @return List<MenuPermisson>
	 */
	List<MenuPermissionVo> getMenuPermissonByMenuId(String menuId);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: insertMenuPermission
	 * @Description: 将菜单和权限的关联关系插入数据库
	 * @param menuPermisson
	 * @return void
	 */
	void insertMenuPermission(MenuPermisson menuPermisson);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: deleteMenuPermission
	 * @Description: 删除菜单和权限的关联关系
	 * @param menuPermisson
	 * @return void
	 */
	void deleteMenuPermission(MenuPermisson menuPermisson);

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: deleteByMenuId
	 * @Description: 删除菜单 MENU ROLE_MENU MENU_PERMISSON 
	 * @param menuId
	 * @return void
	 */
	void deleteByMenuId(String menuId);
	/**
     * 
     * @author: 代钢
     * @Title: selectAllFirst
     * @Description: 查询所有二级菜单
     * @return
     * @return List<Menu>
     */
	List<Menu> selectAllSecond();
	
	/**
	 * 
	 *	@Title 根据菜单查询名称查询menuName
	 *  @author 李涛
	 *  @param 
	 *  @date   2016年10月20日
	 *  @return Menu
	 */
    Menu selectByName(String menuName);
    
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
	List<menuVo> selectChildNodeByParentIdOrMenuId(String parentId,String menuId);

	
}
