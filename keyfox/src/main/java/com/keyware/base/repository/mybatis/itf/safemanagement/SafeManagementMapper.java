package com.keyware.base.repository.mybatis.itf.safemanagement;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.keyware.base.repository.entity.safemanagement.SafeManagement;



public interface SafeManagementMapper {
    int deleteByPrimaryKey(List listId);

    int insert(SafeManagement record);

    int insertSelective(SafeManagement record);

    SafeManagement selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(SafeManagement record);

    int updateByPrimaryKey(SafeManagement record);
    List<SafeManagement> selectAll(@Param("projectSource")String projectSource);
    
    List<SafeManagement> selectInfo(@Param("projectSource")String projectSource);
    
    List<SafeManagement> selectProjectInfo(Long systemLevel);
}