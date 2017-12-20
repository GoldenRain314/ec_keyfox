package com.keyware.base.service.impl.help;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.keyware.base.repository.entity.help.AnswerList;
import com.keyware.base.repository.mybatis.itf.help.AnswerListMapper;
import com.keyware.base.service.itf.help.AnswerListService;

@Service
public class AnswerListServiceImpl implements AnswerListService {

	@Autowired
	private AnswerListMapper answerListMapper;
	
	@Override
	public int deleteByPrimaryKey(String aId) {
		return answerListMapper.deleteByPrimaryKey(aId);
	}

	@Override
	public int insertSelective(AnswerList record) {
		return answerListMapper.insertSelective(record);
	}

	@Override
	public AnswerList selectByPrimaryKey(String aId) {
		return answerListMapper.selectByPrimaryKey(aId);
	}

	@Override
	public int updateByPrimaryKeySelective(AnswerList record) {
		return answerListMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKeyWithBLOBs(AnswerList record) {
		return answerListMapper.updateByPrimaryKeyWithBLOBs(record);
	}

	@Override
	public AnswerList selectByQId(String qId) {
		return answerListMapper.selectByQId(qId);
	}

}
