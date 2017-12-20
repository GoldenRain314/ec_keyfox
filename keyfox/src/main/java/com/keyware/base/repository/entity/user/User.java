package com.keyware.base.repository.entity.user;

import java.io.Serializable;
import java.util.List;

import org.springframework.data.mongodb.core.mapping.DBRef;

import com.keyware.base.repository.entity.Permission;
import com.keyware.base.repository.entity.Role;

public class User implements Serializable{
	
	private static final long serialVersionUID = -1292417487409772488L;

	private String id;

    private String userId;

    private String userName;

    private String password;

    private String departId;

    private String userCreationTime;

    private String userPwdModifTime;

    private Long userStatus;

    private Long userLock;

    private Long userPwdError;

    private String userPwdErrorDate;
    //退出时间
    private String exitTime;
    //原密码
    private String passwordOld;
    
    private String post;

    private String email;

    private String officeTelephone;

    private String userNumber;

    private String idCard;

    private String mobilePhone;

    private Long sex;

    private String homePhone;
    
    private Long logout;
    
    private String initPwdTime;
    
    private String sort;
    
    private String logoutTime;
    
    private String projectSource;
    
	//角色
    @DBRef
    private List<Role> roles;
    
    //权限
    private List<Permission> permissions;
    
    //部门名称
    private String deptName;
    
    //要操作的用户ID
    private String ids;
    
    private String isSys;
    
    private String userNameForSerch;
    
    private String flag;
    
    
    
    /**
	 * @return the logoutTime
	 */
	public String getLogoutTime() {
		return logoutTime;
	}

	/**
	 * @param logoutTime the logoutTime to set
	 */
	public void setLogoutTime(String logoutTime) {
		this.logoutTime = logoutTime;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getUserNameForSerch() {
		return userNameForSerch;
	}

	public void setUserNameForSerch(String userNameForSerch) {
		this.userNameForSerch = userNameForSerch;
	}

	public String getIsSys() {
		return isSys;
	}

	public void setIsSys(String isSys) {
		this.isSys = isSys;
	}

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public List<Role> getRoles() {
		return roles;
	}

	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}

	public List<Permission> getPermissions() {
		return permissions;
	}

	public void setPermissions(List<Permission> permissions) {
		this.permissions = permissions;
	}

	public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName == null ? null : userName.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

    public String getDepartId() {
        return departId;
    }

    public void setDepartId(String departId) {
        this.departId = departId == null ? null : departId.trim();
    }

    public String getUserCreationTime() {
        return userCreationTime;
    }

    public void setUserCreationTime(String userCreationTime) {
        this.userCreationTime = userCreationTime == null ? null : userCreationTime.trim();
    }

    public String getUserPwdModifTime() {
        return userPwdModifTime;
    }

    public void setUserPwdModifTime(String userPwdModifTime) {
        this.userPwdModifTime = userPwdModifTime == null ? null : userPwdModifTime.trim();
    }

    public Long getUserStatus() {
        return userStatus;
    }

    public void setUserStatus(Long userStatus) {
        this.userStatus = userStatus;
    }

    public Long getUserLock() {
        return userLock;
    }

    public void setUserLock(Long userLock) {
        this.userLock = userLock;
    }

    public Long getUserPwdError() {
        return userPwdError;
    }

    public void setUserPwdError(Long userPwdError) {
        this.userPwdError = userPwdError;
    }

    public String getUserPwdErrorDate() {
        return userPwdErrorDate;
    }

    public void setUserPwdErrorDate(String userPwdErrorDate) {
        this.userPwdErrorDate = userPwdErrorDate == null ? null : userPwdErrorDate.trim();
    }
    public String getExitTime() {
  		return exitTime;
  	}

  	public void setExitTime(String exitTime) {
  		this.exitTime = exitTime;
  	}

  	public String getPasswordOld() {
  		return passwordOld;
  	}

  	public void setPasswordOld(String passwordOld) {
  		this.passwordOld = passwordOld;
  	}

	public String getPost() {
		return post;
	}

	public void setPost(String post) {
		this.post = post;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getOfficeTelephone() {
		return officeTelephone;
	}

	public void setOfficeTelephone(String officeTelephone) {
		this.officeTelephone = officeTelephone;
	}

	public String getUserNumber() {
		return userNumber;
	}

	public void setUserNumber(String userNumber) {
		this.userNumber = userNumber;
	}

	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

	public Long getSex() {
		return sex;
	}

	public void setSex(Long sex) {
		this.sex = sex;
	}

	public String getHomePhone() {
		return homePhone;
	}

	public void setHomePhone(String homePhone) {
		this.homePhone = homePhone;
	}

	public Long getLogout() {
		return logout;
	}

	public void setLogout(Long logout) {
		this.logout = logout;
	}

	public String getInitPwdTime() {
		return initPwdTime;
	}

	public void setInitPwdTime(String initPwdTime) {
		this.initPwdTime = initPwdTime;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}


	@Override
	public boolean equals(Object obj) {
		User m = (User)obj;   
		return id.equals(m.getId()) && userName.equals(m.getUserName()); 
	}
	
	@Override
	public int hashCode() {
		String code = this.id+this.userName;
		return code.hashCode();
	}

	public String getProjectSource() {
		return projectSource;
	}

	public void setProjectSource(String projectSource) {
		this.projectSource = projectSource;
	}
}