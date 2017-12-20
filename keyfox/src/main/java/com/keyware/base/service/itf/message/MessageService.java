package com.keyware.base.service.itf.message;

import java.util.List;

import com.keyware.base.repository.entity.index.MessageTable;


public interface MessageService {
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: insertMessage
	 * @Description: 插入一条新的消息
	 * @param messageContent	消息主题内容
	 * @param modelName			要跳转的模块名称(中文模块名称即可)
	 * @param messageUrl		跳转的url
	 * @param receiverId		接受人ID
	 * @param projectId			项目ID
	 * @param status			待办还是待阅 （0：待阅 1：待办）
	 * @return void
	 */
	void insertMessage(String messageContent,String modelName,String messageUrl,String receiverId,String projectId,String status);
	
	 /**
     * 
     * @author: 赵亚舟
     * @Title: selectByInfo
     * @Description: 查询
     * @param record
     * @return
     * @return List<MessageTable>
     */
    List<MessageTable> selectByInfo(MessageTable record);
    
    
    int updateByPrimaryKeySelective(MessageTable record);
    
    
    /**
     * 
     * @author: 赵亚舟
     * @Title: updateMessageStatus
     * @Description: 根据Id将消息至为已读
     * @param id
     * @return void
     */
    void updateMessageStatus(String id);
    
    /**
     * @author 代钢
     * @title：根据项目id删除数据
     * @param projectId
     * @return
     */
    int deleteByProjectId(String projectId);
    
    MessageTable selectByPrimaryKey(String messageId);
	
}
