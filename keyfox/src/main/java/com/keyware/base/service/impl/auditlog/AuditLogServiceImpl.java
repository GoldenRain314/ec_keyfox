package com.keyware.base.service.impl.auditlog;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import jxl.read.biff.Record;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.keyware.base.repository.entity.auditlog.AuditLog;
import com.keyware.base.repository.mybatis.itf.auditlog.AuditLogMapper;
import com.keyware.base.repository.mybatis.itf.auditlog.AuditLogSnapshotMapper;
import com.keyware.base.service.itf.auditlog.AuditLogService;
import com.keyware.base.utils.Constant;
import com.keyware.utils.DateUtils;
import com.keyware.utils.IdGenerator;
import com.keyware.utils.IpUtil;


@Service("auditLogService")
public class AuditLogServiceImpl implements AuditLogService {
	@Autowired
	private AuditLogMapper auditLogMapper;
	@Autowired
	private AuditLogSnapshotMapper auditLogSnapshotMapper;
	@Override
	public int deleteByPrimaryKey(String id) {
		// 
		return auditLogMapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(AuditLog record) {
		record.setProjectSource(Constant.projectName);
		return auditLogMapper.insert(record);
	}

	@Override
	public AuditLog selectByPrimaryKey(String id) {
		// 
		return auditLogMapper.selectByPrimaryKey(id);
	}

	@Override
	public List<AuditLog> selectAll(String userId) {
		// 
		return auditLogMapper.selectAll(userId, Constant.projectName);
	}

	@Override
	public int updateByPrimaryKey(AuditLog record) {
		// 
		return auditLogMapper.updateByPrimaryKey(record);
	}

	
//	public void insertLog(String logName,String logNameType,String comments,String ipAddress,String userName,String departName){
//		AuditLog auditLog=new AuditLog();
//		auditLog.setLogName(logName);
//		auditLog.setLogNameType(logNameType);
//		auditLog.setId(IdGenerator.uuid32());
//		auditLog.setOperTime(DateUtils.getDateTime());
//		auditLog.setIpAddress(ipAddress);
//		auditLog.setUserName(userName);
//		auditLog.setDeptName(departName);
//		auditLog.setComments(comments);
//		this.insert(auditLog);
//	}	
	public void insertLog(String logName,String logNameType,String comments,HttpServletRequest request){
		AuditLog auditLog=new AuditLog();
		auditLog.setLogName(logName);
		auditLog.setLogNameType(logNameType);
		auditLog.setId(IdGenerator.uuid32());
		auditLog.setOperTime(DateUtils.getDateTime());
		HttpSession session = request.getSession();
		String userName=(String) session.getAttribute("userName");
		String departName=(String) session.getAttribute("departName");
		String userId=(String) session.getAttribute("userId");
		auditLog.setIpAddress(IpUtil.getIpAddr(request));
		auditLog.setUserName(userName);
		auditLog.setDeptName(departName);
		auditLog.setComments(comments);
		auditLog.setUserId(userId);
		this.insert(auditLog);
	}

	@Override
	public int deleteAudit(List listId) {
		return auditLogMapper.deleteAudit(listId);
	}

	@Override
	public List<AuditLog> safeAuditLog(String startDate,String endDate) {
		return auditLogMapper.safeAuditLog(startDate, endDate,Constant.projectName);
	}

	@Override
	public List<AuditLog> safeSecretAuditLog(String startDate,String endDate) {
		// 
		return auditLogMapper.safeSecretAuditLog(startDate, endDate, Constant.projectName);
	}

	@Override
	public List<AuditLog> selectAdminLog(String startDate,String endDate) {
		return auditLogMapper.selectAdminLog(startDate, endDate,Constant.projectName);
	}

	@Override
	public List selectAudit(List listId) {
		// 
		return auditLogMapper.selectAudit(listId);
	}

	@Override
	public int insertAuditLogSnapshot(List auditLogSnapshot) {
		// 
		return auditLogSnapshotMapper.addAuditLogSnapshot(auditLogSnapshot);
	}	
}
