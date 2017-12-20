package com.keyware.base.repository.mybatis.itf.auditlog;

import java.util.List;

import com.keyware.base.repository.entity.auditlog.AuditLogSnapshot;


public interface AuditLogSnapshotMapper {
    int insert(AuditLogSnapshot record);

    int insertSelective(AuditLogSnapshot record);
    int addAuditLogSnapshot(List auditLogSnapshot);
}