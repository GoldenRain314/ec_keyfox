package com.keyware.base.service.impl.message;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.keyware.base.repository.entity.index.MessageTable;
import com.keyware.base.repository.mybatis.itf.index.MessageTableMapper;
import com.keyware.base.service.itf.message.MessageService;
import com.keyware.base.utils.Constant;
import com.keyware.utils.DateUtils;
import com.keyware.utils.IdGenerator;

@Service
public class MessageServiceImpl implements MessageService{

	@Autowired
	private MessageTableMapper messageTableMapper;
	
	@Override
	public void insertMessage(String messageContent, String modelName,
			String messageUrl, String receiverId, String projectId,
			String status) {
		MessageTable messageTable = new MessageTable();
		messageTable.setMessageId(IdGenerator.uuid32());
		messageTable.setParentModelName(modelName);
		messageTable.setMessageUrl(messageUrl);
		messageTable.setReceiverId(receiverId);
		messageTable.setCreateTime(DateUtils.formatDateTime(new Date()));
		messageTable.setMessageStatus("0");
		messageTable.setProjectId(projectId);
		messageTable.setMessageContent(messageContent);
		messageTable.setReadHande(status);
		messageTable.setProjectSource(Constant.projectName);
		messageTableMapper.insertSelective(messageTable);
	}
	
	@Override
	public List<MessageTable> selectByInfo(MessageTable record) {
		record.setProjectSource(Constant.projectName);
		return messageTableMapper.selectByInfo(record);
	}

	@Override
	public int updateByPrimaryKeySelective(MessageTable record) {
		return messageTableMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public void updateMessageStatus(String id) {
		MessageTable messageTable = new MessageTable();
		messageTable.setMessageId(id);
		messageTable.setHandeTime(DateUtils.formatDateTime(new Date()));
		messageTable.setMessageStatus("1");
		this.updateByPrimaryKeySelective(messageTable);
	}

	@Override
	public int deleteByProjectId(String projectId) {
		return messageTableMapper.deleteByProjectId(projectId,Constant.projectName);
	}

	@Override
	public MessageTable selectByPrimaryKey(String messageId) {
		
		return messageTableMapper.selectByPrimaryKey(messageId);
	}

}
