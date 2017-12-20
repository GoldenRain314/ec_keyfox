package com.keyware.base.service.itf.help;

import java.util.List;

import com.keyware.base.repository.entity.help.QuestionList;

public interface QuestionListService {
	
	int deleteByPrimaryKey(String qId);

    int insertSelective(QuestionList record);

    QuestionList selectByPrimaryKey(String qId);

    int updateByPrimaryKeySelective(QuestionList record);

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

    /**
     * 
     * @author: 赵亚舟
     * @Title: insertQuestion
     * @Description: 将问题入库
     * @param name
     * @param value
     * @return void
     */
    String insertQuestion(String name, String value,String menuId);

    /**
     * 
     * @author: 赵亚舟
     * @Title: updateQuestion
     * @Description: 修改问题及答案
     * @param name
     * @param value
     * @param id
     * @return
     * @return String
     */
	String updateQuestion(String name, String value, String id,String menuId);

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: deleteQuestion
	 * @Description: 删除问题
	 * @param qIds
	 * @return
	 * @return String
	 */
	String deleteQuestion(String qIds);
}
