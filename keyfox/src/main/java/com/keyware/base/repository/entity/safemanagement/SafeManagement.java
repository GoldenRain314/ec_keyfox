package com.keyware.base.repository.entity.safemanagement;

public class SafeManagement {
    private String id;

    private Long systemLevel;

    private Long pwdLocktimes;

    private Long minimumPwdLength;

    private Long maximumPwdLength;

    private Long pwdExpirationTime;

    private Long userInactiveTime;

    private Long pwdChangeCycle;
    
    private String projectSource;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public Long getSystemLevel() {
        return systemLevel;
    }

    public void setSystemLevel(Long systemLevel) {
        this.systemLevel = systemLevel;
    }

    public Long getPwdLocktimes() {
        return pwdLocktimes;
    }

    public void setPwdLocktimes(Long pwdLocktimes) {
        this.pwdLocktimes = pwdLocktimes;
    }

    public Long getMinimumPwdLength() {
        return minimumPwdLength;
    }

    public void setMinimumPwdLength(Long minimumPwdLength) {
        this.minimumPwdLength = minimumPwdLength;
    }

    public Long getMaximumPwdLength() {
        return maximumPwdLength;
    }

    public void setMaximumPwdLength(Long maximumPwdLength) {
        this.maximumPwdLength = maximumPwdLength;
    }

    public Long getPwdExpirationTime() {
        return pwdExpirationTime;
    }

    public void setPwdExpirationTime(Long pwdExpirationTime) {
        this.pwdExpirationTime = pwdExpirationTime;
    }

    public Long getUserInactiveTime() {
        return userInactiveTime;
    }

    public void setUserInactiveTime(Long userInactiveTime) {
        this.userInactiveTime = userInactiveTime;
    }

    public Long getPwdChangeCycle() {
        return pwdChangeCycle;
    }

    public void setPwdChangeCycle(Long pwdChangeCycle) {
        this.pwdChangeCycle = pwdChangeCycle;
    }

	public String getProjectSource() {
		return projectSource;
	}

	public void setProjectSource(String projectSource) {
		this.projectSource = projectSource;
	}
    
}