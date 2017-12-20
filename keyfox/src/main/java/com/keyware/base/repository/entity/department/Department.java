package com.keyware.base.repository.entity.department;


public class Department {
    private String id;

    private String deptName;

    private String parentId;
    
    private String parentName;

    private Long orderNo;

    private String comments;

    private String deptCreateTime;
    
    private String deptNumber;

    private String manager;
    
    private String managerName;

    private Long totalWorkers;

    private String superLeader;
    
    private String superLeaderName;

    private String interfacePerson;
    
    private String interfacePersonName;

    private String departAbbrevia;

    private String charge;
    
    private String chargeName;
    
    private String isSys;
    
    private String projectSource;
    
	//统计用户数
	private Integer userCount;
	

    public String getParentName() {
		return parentName;
	}

	public void setParentName(String parentName) {
		this.parentName = parentName;
	}

	public String getIsSys() {
		return isSys;
	}

	public void setIsSys(String isSys) {
		this.isSys = isSys;
	}

	public Integer getUserCount() {
		return userCount;
	}

	public void setUserCount(Integer userCount) {
		this.userCount = userCount;
	}

	public String getChargeName() {
		return chargeName;
	}

	public void setChargeName(String chargeName) {
		this.chargeName = chargeName;
	}

	public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName == null ? null : deptName.trim();
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId == null ? null : parentId.trim();
    }

    public Long getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(Long orderNo) {
        this.orderNo = orderNo;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments == null ? null : comments.trim();
    }

    public String getDeptCreateTime() {
        return deptCreateTime;
    }

    public void setDeptCreateTime(String deptCreateTime) {
        this.deptCreateTime = deptCreateTime == null ? null : deptCreateTime.trim();
    }

	public String getDeptNumber() {
		return deptNumber;
	}

	public void setDeptNumber(String deptNumber) {
		this.deptNumber = deptNumber;
	}

	public String getManager() {
		return manager;
	}

	public void setManager(String manager) {
		this.manager = manager;
	}

	public Long getTotalWorkers() {
		return totalWorkers;
	}

	public void setTotalWorkers(Long totalWorkers) {
		this.totalWorkers = totalWorkers;
	}

	public String getSuperLeader() {
		return superLeader;
	}

	public void setSuperLeader(String superLeader) {
		this.superLeader = superLeader;
	}

	public String getInterfacePerson() {
		return interfacePerson;
	}

	public void setInterfacePerson(String interfacePerson) {
		this.interfacePerson = interfacePerson;
	}

	public String getDepartAbbrevia() {
		return departAbbrevia;
	}

	public void setDepartAbbrevia(String departAbbrevia) {
		this.departAbbrevia = departAbbrevia;
	}

	public String getCharge() {
		return charge;
	}

	public void setCharge(String charge) {
		this.charge = charge;
	}

	public String getInterfacePersonName() {
		return interfacePersonName;
	}

	public void setInterfacePersonName(String interfacePersonName) {
		this.interfacePersonName = interfacePersonName;
	}

	public String getSuperLeaderName() {
		return superLeaderName;
	}

	public void setSuperLeaderName(String superLeaderName) {
		this.superLeaderName = superLeaderName;
	}

	public String getManagerName() {
		return managerName;
	}

	public void setManagerName(String managerName) {
		this.managerName = managerName;
	}

	public String getProjectSource() {
		return projectSource;
	}

	public void setProjectSource(String projectSource) {
		this.projectSource = projectSource;
	}
    
	

    
	
}