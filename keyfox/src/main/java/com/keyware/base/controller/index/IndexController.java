package com.keyware.base.controller.index;

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
import com.keyware.base.repository.entity.index.MessageTable;
import com.keyware.base.service.itf.message.MessageService;
import com.keyware.base.task.util.AjaxMessage;
import com.keyware.base.utils.Constant;
import com.keyware.utils.PaginationUtil;

/**
 * 
 * 此类描述的是：   首页
 * @author: 赵亚舟   
 * @version: 2016年8月2日 上午10:56:39
 */
@Controller
@RequestMapping("/index/")
public class IndexController extends BaseController{
	
	public static Logger logger = Logger.getLogger(IndexController.class);
	
	@Autowired
	private MessageService messageService;
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showIndex
	 * @Description: 跳转到首页
	 * @return
	 * @return String
	 */
	@RequestMapping(value="/showIndex",method =RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showIndex(){
		//需要阅读的消息
		Integer readMessage = 0;
		MessageTable messageTable = new MessageTable();
		messageTable.setReceiverId(getUser_idFormSession("user_id"));
		messageTable.setMessageStatus("0");
		messageTable.setReadHande("0");
		List<MessageTable> selectByInfo = messageService.selectByInfo(messageTable);
		readMessage = selectByInfo.size();
		request.setAttribute("readMessage", readMessage);
		String user_id = (String)request.getSession().getAttribute("user_id");
		//需要处理的消息
		Integer handleMessage = 0;
		messageTable.setReadHande("1");
		List<MessageTable> selectByInfo1 = messageService.selectByInfo(messageTable);
		handleMessage = selectByInfo1.size();
		request.setAttribute("handleMessage", handleMessage);
		request.setAttribute("user_id", user_id);
		return "index/index";
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showHandMessage
	 * @Description: 跳转到显示待办事项界面
	 * @return
	 * @return String
	 */
	@RequestMapping(value="/showHandMessage",method =RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showHandMessage(){
		return "index/showHandList";
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showHandMessage
	 * @Description: 跳转到显示待阅事项界面
	 * @return
	 * @return String
	 */
	@RequestMapping(value="/showReadMessage",method =RequestMethod.GET,produces = "application/json; charset=utf-8")
	public String showReadMessage(){
		return "index/showReadList";
	}
	
	
//	
	
	/**
	 * 
	 * @Title: getRoleList
	 * @Description: 获取分页数据
	 * @return
	 * @return PaginationUtil
	 */
	@RequestMapping(value = "getHandMessageList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getHandMessageList(@ModelAttribute MessageTable messageTable){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		messageTable.setReceiverId(getUser_idFormSession("user_id"));
		messageTable.setMessageStatus("0");
		messageTable.setReadHande("1");
		List<MessageTable> selectByInfo = messageService.selectByInfo(messageTable);
		paginationUtil.after(selectByInfo);
		return paginationUtil;
	}
	
	/**
	 * 
	 * @Title: getRoleList
	 * @Description: 获取分页数据
	 * @return
	 * @return PaginationUtil
	 */
	@RequestMapping(value = "getReadMessageList",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public PaginationUtil getReadMessageList(@ModelAttribute MessageTable messageTable){
		PaginationUtil paginationUtil = new PaginationUtil();
		paginationUtil.before(request);
		messageTable.setReceiverId(getUser_idFormSession("user_id"));
		//messageTable.setMessageStatus("0");
		messageTable.setReadHande("0");
		List<MessageTable> selectByInfo = messageService.selectByInfo(messageTable);
		paginationUtil.after(selectByInfo);
		return paginationUtil;
	}
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: updateMessageStatus
	 * @Description: 修改消息状态
	 * @param messageTable
	 * @return
	 * @return AjaxMessage
	 */
	@RequestMapping(value = "updateMessageStatus",method = RequestMethod.POST,produces = "application/json; charset=utf-8")
	@ResponseBody
	public AjaxMessage updateMessageStatus(@ModelAttribute MessageTable messageTable){
		AjaxMessage ajaxMessage = new AjaxMessage();
		try {
			if(StringUtils.hasText(messageTable.getMessageId())){
				String[] split = messageTable.getMessageId().split(",");
				for(String id:split){
					messageService.updateMessageStatus(id);
				}
			}
			ajaxMessage.setCode("1");
			ajaxMessage.setMessage("操作成功");
		} catch (Exception e) {
			logger.error(e);
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage(Constant.ERROE_MESSAGE);
		}
		return ajaxMessage;
	}
	
}
