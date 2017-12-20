package com.keyware.base.repository.mybatis.itf.help;

import java.util.List;

import com.keyware.base.repository.entity.help.QuestionList;

public interface QuestionListMapper {
    int deleteByPrimaryKey(String qId);

    int insert(QuestionList record);

    int insertSelective(QuestionList record);

    QuestionList selectByPrimaryKey(String qId);

    int updateByPrimaryKeySelective(QuestionList record);

    int updateByPrimaryKey(QuestionList record);
    
    /**
     * 
     * @author: 赵亚舟
     * @Title: selectByInfo
     * @Description: 根据属性信息查询
     * @param questionList
     * @return
     * @return List<QuestionList>
     */
    List<QuestionList> selectByInfo(QuestionList questionList);
}