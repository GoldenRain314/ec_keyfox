package com.keyware.base.service.impl.jurisdiction;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.keyware.base.repository.entity.Menu;
import com.keyware.base.repository.entity.MenuPermisson;
import com.keyware.base.repository.mybatis.itf.MenuMapper;
import com.keyware.base.repository.mybatis.itf.MenuPermissonMapper;
import com.keyware.base.repository.mybatis.itf.RoleMenuMapper;
import com.keyware.base.service.itf.jurisdiction.MenuService;
import com.keyware.base.utils.Constant;
import com.keyware.base.vo.menu.MenuPermissionVo;
import com.keyware.base.vo.menu.menuVo;

@Service("menuService")
public class MenuServiceImpl implements MenuService {

	@Autowired
	private MenuMapper menuMapper;
	
	@Autowired
	private MenuPermissonMapper menuPermissionMapper;
	
	@Autowired
	private RoleMenuMapper roleMenuMapper;
	
	@Transactional
	@Override
	public int deleteByPrimaryKey(String id) {
		return menuMapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(Menu record) {
		record.setProjectSource(Constant.projectName);
		record.setIsSys("0");
		return menuMapper.insert(record);
	}

	@Override
	public Menu selectByPrimaryKey(String id) {
		return menuMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKey(Menu record) {
		return menuMapper.updateByPrimaryKey(record);
	}

	@Override
	public List<Menu> getTheOneLevelMenuBasedOnTheAccountID(String userId) {
		return menuMapper.getTheLevelMenuBasedOnTheAccountID(userId,Constant.projectName);
	}

	@Override
	public int insertSelective(Menu record) {
		record.setProjectSource(Constant.projectName);
		record.setIsSys("0");
		return menuMapper.insertSelective(record);
	}

	@Override
	public int updateByPrimaryKeySelective(Menu record) {
		return menuMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public List<Menu> selectAll() {
		return menuMapper.selectAll(Constant.projectName);
	}


	@Override
	public List<Menu> selectByMneu(Menu menu) {
		menu.setProjectSource(Constant.projectName);
		return menuMapper.selectByMneu(menu);
	}

	@Override
	public List<menuVo> getTheTwoLevelMenuBasedOnTheAccountID(String userId,
			String menuId,String isSys) {
		return menuMapper.getTwoTheLevelMenuBasedOnTheAccountID(userId,Constant.projectName,menuId,isSys);
	}

	@Override
	public List<Menu> selectAllFirst() {
		return menuMapper.selectAllFirst(Constant.projectName);
	}

	@Override
	public List<MenuPermissionVo> getMenuPermissonByMenuId(String menuId) {
		
		return menuPermissionMapper.getMenuPermissonByMenuId(menuId);
	}

	@Override
	public void insertMenuPermission(MenuPermisson menuPermisson) {
		menuPermissionMapper.insertSelective(menuPermisson);
	}

	@Override
	public void deleteMenuPermission(MenuPermisson menuPermisson) {
		menuPermissionMapper.deleteMenuPermission(menuPermisson);
		
	}

	@Override
	public void deleteByMenuId(String menuId) {
		//删除 menu 表
		this.deleteByPrimaryKey(menuId);
		
		//删除 角色 菜单 关联关系 表
		roleMenuMapper.deleteByMenuId(menuId);
		
		//删除菜单关联关系表
		menuPermissionMapper.deleteByMenuId(menuId);
		
	}

	@Override
	public List<Menu> selectAllSecond() {
		return menuMapper.selectAllSecond(Constant.projectName);
	}

	@Override
	public List<menuVo> getThreeTheLevelMenuBasedOnTheAccountID(String userId,
			String menuId) {
		return menuMapper.getThreeTheLevelMenuBasedOnTheAccountID(userId,Constant.projectName,menuId);
	}

	public Menu selectByName(String menuName) {
		return menuMapper.selectByName(menuName,Constant.projectName);
	}

	@Override
	public List<menuVo> selectChildNodeByParentIdOrMenuId(String parentId,
			String menuId) {
		return menuMapper.selectChildNodeByParentIdOrMenuId(parentId, menuId);
	}

}
