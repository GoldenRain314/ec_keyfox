package com.keyware.base.repository.entity.index;

import java.io.Serializable;

public class MessageTable implements Serializable{
     
	private static final long serialVersionUID = 1L;

	private String messageId;

    private String messageContent;
    
    private String parentModelName;

    private String messageUrl;

    private String receiverId;

    private String createTime;

    private String messageStatus;

    private String handeTime;

    private String projectId;
    
    private String readHande;
    
    private String projectSource;
    

    public String getReadHande() {
		return readHande;
	}

	public void setReadHande(String readHande) {
		this.readHande = readHande;
	}

	public String getMessageId() {
        return messageId;
    }

    public void setMessageId(String messageId) {
        this.messageId = messageId == null ? null : messageId.trim();
    }

    public String getParentModelName() {
        return parentModelName;
    }

    public void setParentModelName(String parentModelName) {
        this.parentModelName = parentModelName == null ? null : parentModelName.trim();
    }

    public String getMessageUrl() {
        return messageUrl;
    }

    public void setMessageUrl(String messageUrl) {
        this.messageUrl = messageUrl == null ? null : messageUrl.trim();
    }

    public String getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(String receiverId) {
        this.receiverId = receiverId == null ? null : receiverId.trim();
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime == null ? null : createTime.trim();
    }

    public String getMessageStatus() {
        return messageStatus;
    }

    public void setMessageStatus(String messageStatus) {
        this.messageStatus = messageStatus == null ? null : messageStatus.trim();
    }

    public String getHandeTime() {
        return handeTime;
    }

    public void setHandeTime(String handeTime) {
        this.handeTime = handeTime == null ? null : handeTime.trim();
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId == null ? null : projectId.trim();
    }

	public String getMessageContent() {
		return messageContent;
	}

	public void setMessageContent(String messageContent) {
		this.messageContent = messageContent;
	}

	public String getProjectSource() {
		return projectSource;
	}

	public void setProjectSource(String projectSource) {
		this.projectSource = projectSource;
	}
    
    
}