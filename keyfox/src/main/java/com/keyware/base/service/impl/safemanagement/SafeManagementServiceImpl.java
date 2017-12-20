package com.keyware.base.service.impl.safemanagement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.keyware.base.repository.entity.safemanagement.SafeManagement;
import com.keyware.base.repository.mybatis.itf.safemanagement.SafeManagementMapper;
import com.keyware.base.service.itf.safemanagement.SafeManagementService;
import com.keyware.base.utils.Constant;


@Service("safeManagementService")
public class SafeManagementServiceImpl implements SafeManagementService {

	@Autowired
	private SafeManagementMapper safeManagementMapper;
	@Override
	public int deleteByPrimaryKey(List listId) {
		// 
		return safeManagementMapper.deleteByPrimaryKey(listId);
	}

	@Override
	public int insert(SafeManagement record) {

		// 
		record.setProjectSource(Constant.projectName);
		return safeManagementMapper.insert(record);
	}

	@Override
	public SafeManagement selectByPrimaryKey(String id) {
		// 
		return safeManagementMapper.selectByPrimaryKey(id);
	}

	@Override
	public List<SafeManagement> selectAll() {
		// 
		return safeManagementMapper.selectAll(Constant.projectName);
	}

	@Override
	public int updateByPrimaryKey(SafeManagement record) {
		// 
		record.setProjectSource(Constant.projectName);
		return safeManagementMapper.updateByPrimaryKey(record);
	}

	@Override
	public List<SafeManagement> selectInfo() {
		// 
		return safeManagementMapper.selectInfo(Constant.projectName);
	}

	@Override
	public List<SafeManagement> selectProjectInfo(Long systemLevel) {
		return safeManagementMapper.selectProjectInfo(systemLevel);
	}
	

}
