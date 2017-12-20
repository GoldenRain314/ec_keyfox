package com.keyware.base.service.impl.help;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.keyware.base.repository.entity.help.AnswerList;
import com.keyware.base.repository.entity.help.QuestionList;
import com.keyware.base.repository.mybatis.itf.help.AnswerListMapper;
import com.keyware.base.repository.mybatis.itf.help.QuestionListMapper;
import com.keyware.base.service.itf.help.QuestionListService;
import com.keyware.base.utils.Constant;
import com.keyware.utils.DateUtils;
import com.keyware.utils.IdGenerator;

@Service
public class QuestionListServiceImpl implements QuestionListService {

	@Autowired
	private QuestionListMapper questionMapper;
	
	@Autowired
	private AnswerListMapper answerListMapper;
	
	@Override
	public int deleteByPrimaryKey(String qId) {
		return questionMapper.deleteByPrimaryKey(qId);
	}

	@Override
	public int insertSelective(QuestionList record) {
		record.setProjectSource(Constant.projectName);
		return questionMapper.insertSelective(record);
	}

	@Override
	public QuestionList selectByPrimaryKey(String qId) {
		return questionMapper.selectByPrimaryKey(qId);
	}

	@Override
	public int updateByPrimaryKeySelective(QuestionList record) {
		record.setProjectSource(Constant.projectName);
		return questionMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public List<QuestionList> selectByInfo(QuestionList questionList) {
		questionList.setProjectSource(Constant.projectName);
		return questionMapper.selectByInfo(questionList);
	}

	@Transactional
	@Override
	public String insertQuestion(String name, String value,String menuId) {
		//将问题入库
		QuestionList questionList = new QuestionList();
		questionList.setqId(IdGenerator.uuid32());
		questionList.setCreateTime(DateUtils.formatDateTime(new Date()));
		questionList.setqName(name);
		questionList.setMenuId(menuId);
		this.insertSelective(questionList);
		
		//将答案入库
		AnswerList answerList = new AnswerList();
		answerList.setaId(IdGenerator.uuid32());
		answerList.setqId(questionList.getqId());
		answerList.setaContent(value);
		answerListMapper.insertSelective(answerList);
		return "";
	}

	@Transactional
	@Override
	public String updateQuestion(String name, String value, String id,String menuId) {
		//修改问题信息
		QuestionList questionList = new QuestionList();
		questionList.setqId(id);
		questionList.setqName(name);
		questionList.setMenuId(menuId);
		this.updateByPrimaryKeySelective(questionList);
		//修改答案信息
		AnswerList answerList = new AnswerList();
		answerList.setqId(id);
		answerList.setaContent(value);
		answerListMapper.updateByPrimaryKeyWithBLOBs(answerList);
		return "";
	}

	@Transactional
	@Override
	public String deleteQuestion(String qIds) {
		String[] split = qIds.split(",");
		for(String id : split){
			this.deleteByPrimaryKey(id);
			answerListMapper.deleteByQid(id);
		}
		return "";
	}

}
