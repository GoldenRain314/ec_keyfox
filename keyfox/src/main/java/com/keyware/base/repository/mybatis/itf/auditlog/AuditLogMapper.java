package com.keyware.base.repository.mybatis.itf.auditlog;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.keyware.base.repository.entity.auditlog.AuditLog;

public interface AuditLogMapper {
    int deleteByPrimaryKey(String id);
    int deleteAudit(List<?> listId);
    List selectAudit(List listId);

    int insert(AuditLog record);

    int insertSelective(AuditLog record);

    AuditLog selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(AuditLog record);

    int updateByPrimaryKey(AuditLog record);
    List<AuditLog> selectAll(@Param("userId")String userId,@Param("projectSource")String projectSource);
    /**
   	 *@author 申鹏飞
   	 *@title 查询安全审计员审计页面信息
   	 * @return
   	 *@date 2016-07-01
   	 */
    List<AuditLog> safeAuditLog(@Param("startDate") String startDate,@Param("endDate") String endDate,@Param("projectSource")String projectSource);
    /**
   	 *@author 申鹏飞
   	 *@title 查询安全保密员审计页面信息
   	 *@return
   	 *@date 2016-07-01
   	 */
    List<AuditLog> safeSecretAuditLog(@Param("startDate") String startDate,@Param("endDate") String endDate,@Param("projectSource")String projectSource);
    /**
   	 *@author 申鹏飞
   	 *@title 查询管理员审计页面信息
   	 *@return
   	 *@date 2016-07-01
   	 */
    List<AuditLog> selectAdminLog(@Param("startDate") String startDate,@Param("endDate") String endDate,@Param("projectSource")String projectSource);
	
}