package com.keyware.base.repository.mybatis.itf;

import java.util.List;

import com.keyware.base.repository.entity.MenuPermisson;
import com.keyware.base.vo.menu.MenuPermissionVo;

public interface MenuPermissonMapper {
    int insert(MenuPermisson record);

    int insertSelective(MenuPermisson record);
    
    
    /**
     * 
     * @Title: deleteByMenuId
     * @Description: 根据菜单ID删除菜单下所有关联的所有权限点
     * @param menuId
     * @return
     * @return int
     */
    int deleteByMenuId(String menuId);

    
	List<MenuPermissionVo> getMenuPermissonByMenuId(String menuId);

	void deleteMenuPermission(MenuPermisson menuPermisson);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: deleteByPermissionId
	 * @Description: 根据权限点ID删除
	 * @param permissionId
	 * @return void
	 */
	void deleteByPermissionId(String permissionId);
    
}