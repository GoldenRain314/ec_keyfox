package com.keyware.base.service.itf.help;

import com.keyware.base.repository.entity.help.AnswerList;

public interface AnswerListService {
	int deleteByPrimaryKey(String aId);

    int insertSelective(AnswerList record);

    AnswerList selectByPrimaryKey(String aId);

    int updateByPrimaryKeySelective(AnswerList record);

    int updateByPrimaryKeyWithBLOBs(AnswerList record);
    
    AnswerList selectByQId(String qId);
}
