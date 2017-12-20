package com.keyware.base.repository.mybatis.itf.help;

import com.keyware.base.repository.entity.help.AnswerList;

public interface AnswerListMapper {
    int deleteByPrimaryKey(String aId);

    int insert(AnswerList record);

    int insertSelective(AnswerList record);

    AnswerList selectByPrimaryKey(String aId);

    int updateByPrimaryKeySelective(AnswerList record);

    int updateByPrimaryKeyWithBLOBs(AnswerList record);

    int updateByPrimaryKey(AnswerList record);
    
    AnswerList selectByQId(String qId);
    
    /**
     * 
     * @author: 赵亚舟
     * @Title: deleteByQid
     * @Description:
     * @param qId
     * @return
     * @return int
     */
    int deleteByQid(String qId);
    
}