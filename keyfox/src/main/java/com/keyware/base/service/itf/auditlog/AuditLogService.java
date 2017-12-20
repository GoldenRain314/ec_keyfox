package com.keyware.base.service.itf.auditlog;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.keyware.base.repository.entity.auditlog.AuditLog;
import com.keyware.base.repository.entity.auditlog.AuditLogSnapshot;

public interface AuditLogService {
	int deleteByPrimaryKey(String id);
	int deleteAudit(List listId);
	List selectAudit(List listId);
    int insert(AuditLog record);
    
    AuditLog selectByPrimaryKey(String id);

    List<AuditLog> selectAll(String userId);
    /**
	 *@author 申鹏飞
	 *@title 归档日志
	 * @return
	 *@date 2016-07-01
	 */
	int insertAuditLogSnapshot(List auditLogSnapshot);
    /**
	 *@author 申鹏飞
	 *@title 查询安全审计员审计页面信息
	 * @return
	 *@date 2016-07-01
	 */
    List<AuditLog> safeAuditLog(String startDate,String endDate);
    /**
	 *@author 申鹏飞
	 *@title 查询安全保密员审计页面信息
	 * @return
	 *@date 2016-07-01
	 */
    List<AuditLog> safeSecretAuditLog(String startDate,String endDate);
    
    /**
	 *@author 申鹏飞
	 *@title 查询管理员审计页面信息
	 * @return
	 *@date 2016-07-01
	 */
    List<AuditLog> selectAdminLog(String startDate,String endDate);
    
    
    int updateByPrimaryKey(AuditLog record);
    /**
     * 
     *@author 申鹏飞
     *@title 插入日志
     *@param
     * @param logName 功能
     * @param logNameType 模块
     * @param comments 详情
     * @param request
     *
     *@date 20160623
     */
    public void insertLog(String logName,String logNameType,String comments,HttpServletRequest request);
	
	
	

}
