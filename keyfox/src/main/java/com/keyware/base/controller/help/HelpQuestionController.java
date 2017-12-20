package com.keyware.base.controller.help;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.keyware.base.controller.BaseController;
import com.keyware.base.repository.entity.Menu;
import com.keyware.base.repository.entity.help.AnswerList;
import com.keyware.base.repository.entity.help.QuestionList;
import com.keyware.base.service.itf.help.AnswerListService;
import com.keyware.base.service.itf.help.QuestionListService;
import com.keyware.base.service.itf.jurisdiction.MenuService;
import com.keyware.base.task.util.AjaxMessage;
import com.keyware.base.utils.Constant;
import com.keyware.utils.PaginationUtil;

@Controller
@RequestMapping("/hq/")
public class HelpQuestionController extends BaseController {
	public static Logger logger = Logger.getLogger(HelpQuestionController.class);
	
	@Autowired
	private QuestionListService questionListService;
	
	@Autowired
	private AnswerListService answerListService;
	
	@Autowired
	private MenuService menuService;
	

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getQuestionList
	 * @Description: 跳转到问题列表
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "showQuestionList",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showQuestionList(String menuId){
		QuestionList questionList = new QuestionList();
		questionList.setMenuId(menuId);
		List<QuestionList> selectByInfo = questionListService.selectByInfo(questionList );
		request.setAttribute("list", selectByInfo);
		Menu selectByPrimaryKey = menuService.selectByPrimaryKey(menuId);
		if(selectByPrimaryKey != null)
			request.setAttribute("menuName", selectByPrimaryKey.getMenuName());
		return "help/questionList";
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getQuestionList
	 * @Description: 获取问题列表
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "getQuestionList",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String getQuestionList(String menuId){
		request.setAttribute("menuId", menuId);
		return "organizeassets/help/questionList";
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getHistoryDetailsList
	 * @Description: 影响与分析 获取数据
	 * @param questionList
	 * @return
	 * @return PaginationUtil
	 */
	@RequestMapping(value = "getList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getHistoryDetailsList(@ModelAttribute QuestionList questionList){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		
		if("搜索您想寻找的...".equals(questionList.getqName()))
			questionList.setqName(null);
		
		List<QuestionList> selectByInfo = questionListService.selectByInfo(questionList);
		paginationUtil.after(selectByInfo);
		return paginationUtil;
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showAdd
	 * @Description: 跳转到添加
	 * @param menuId
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "showAdd",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showAdd(String menuId,String qId){
		request.setAttribute("menuId", menuId);
		
		Menu menu = new Menu();
		menu.setMenuName("帮助");
		List<Menu> selectByMneu = menuService.selectByMneu(menu );
		menu.setMenuName(null);
		menu.setParentId(selectByMneu.get(0).getMenuId());
		List<Menu> selectByMneuList = menuService.selectByMneu(menu);
		request.setAttribute("menuList", selectByMneuList);
		
		if(StringUtils.hasText(qId)){
			QuestionList selectByPrimaryKey = questionListService.selectByPrimaryKey(qId);
			request.setAttribute("id", selectByPrimaryKey.getqId());
			request.setAttribute("qName", selectByPrimaryKey.getqName());
			request.setAttribute("menuId", selectByPrimaryKey.getMenuId());
		}
		return "organizeassets/help/addQuestion";
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: insertQuestion
	 * @Description: 问题入库
	 * @return
	 * @return AjaxMessage
	 */
	@RequestMapping(value = "insertQuestion",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage insertQuestion(String name,String value,String menuId,String id){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			String a = "";
			if(StringUtils.hasText(id)){
				//修改
				a = questionListService.updateQuestion(name,value,id,menuId);
			}else{
				//添加
				a = questionListService.insertQuestion(name,value,menuId);
			}
			
			if(StringUtils.hasText(a)){
				ajaxMessage.setCode("1");
				ajaxMessage.setMessage(a);
			}else{
				ajaxMessage.setCode("0");
				ajaxMessage.setMessage("操作成功");
			}
		} catch (Exception e) {
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage(Constant.ERROE_MESSAGE);
		}
		return ajaxMessage;
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: getQuestionValue
	 * @Description: 获取问题的答案
	 * @param qId
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "getQuestionValue",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	@ResponseBody
	public String getQuestionValue(String qId){
		AnswerList selectByQId = answerListService.selectByQId(qId);
		return selectByQId.getaContent();
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showQuestionDetails
	 * @Description: 查看问题详情
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "showQuestionDetails",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showQuestionDetails(String qId){
		QuestionList selectByPrimaryKey = questionListService.selectByPrimaryKey(qId);
		request.setAttribute("info", selectByPrimaryKey);
		return "help/showQuestionDetails";
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: deleQuestion
	 * @Description: 删除问题
	 * @return
	 * @return AjaxMessage
	 */
	@RequestMapping(value = "deleQuestion",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage deleQuestion(String qIds){
		AjaxMessage ajaxMessage = new AjaxMessage();
		if(StringUtils.hasText(qIds)){
			try {
				questionListService.deleteQuestion(qIds);
				ajaxMessage.setMessage("操作成功");
			} catch (Exception e) {
				ajaxMessage.setMessage(Constant.ERROE_MESSAGE);
			}
		}
		return ajaxMessage;
	}
	
	/**
	 * 
	 * @author: 代钢
	 * @Title: getProductSale
	 * @Description: 跳转到产品购买页面
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "getProductSale",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String getProductSale(){
		return "help/productSale";
	}
	
	/**
	 * 
	 * @author: 代钢
	 * @Title: getProductSale
	 * @Description: 跳转到产品简介
	 * @return
	 * @return String
	 */
	@RequestMapping(value = "getProductIntroduction",method = RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String getProductIntroduction(){
		return "help/productIntroduction";
	}
}
