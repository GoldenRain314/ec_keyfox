package com.keyware.base.service.itf.safemanagement;

import java.util.List;

import com.keyware.base.repository.entity.safemanagement.SafeManagement;

public interface SafeManagementService {
	 	int deleteByPrimaryKey(List listId);

	    int insert(SafeManagement record);

	    SafeManagement selectByPrimaryKey(String id);

	    List<SafeManagement> selectAll();
	    
	    int updateByPrimaryKey(SafeManagement record);

		List<SafeManagement> selectInfo();
		
		List<SafeManagement> selectProjectInfo(Long systemLevel);

		

}
