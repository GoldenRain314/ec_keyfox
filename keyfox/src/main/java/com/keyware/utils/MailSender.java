package com.keyware.utils;

import java.io.IOException;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

import org.springframework.core.task.TaskExecutor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.messaging.MessagingException;
import org.springframework.stereotype.Component;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import freemarker.template.Template;
import freemarker.template.TemplateException;

/*@Component("mailSender") */
public class MailSender {
	@Resource
	private JavaMailSender javaMailSender;
	
	public void setJavaMailSender(JavaMailSender javaMailSender) {
		this.javaMailSender = javaMailSender;
	}

	@Resource
	private SimpleMailMessage simpleMailMessage;
	
	public void setSimpleMailMessage(SimpleMailMessage simpleMailMessage) {
		this.simpleMailMessage = simpleMailMessage;
	}

	@Resource
	private FreeMarkerConfigurer freeMarkerConfigurer;
	
	public void setFreeMarkerConfigurer(FreeMarkerConfigurer freeMarkerConfigurer) {
		this.freeMarkerConfigurer = freeMarkerConfigurer;
	}

	@Resource
	private TaskExecutor taskExecutor;

	public void setTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;
	}

	/**
	 * 构建邮件内容，发送邮件。
	 * Map
	 * @param user
	 *            用户
	 * @param url
	 *            链接
	 */
//	public void send(User user, String url, String email) {
	public void send(Map<String, Object> map) {
//		String nickname = user.getUserAccount();
		String to = map.get("to").toString();
		String text = "";
		String subject = (null == map.get("subject") ? null : map.get("subject").toString());
		try {
			// 从FreeMarker模板生成邮件内容
//			map中如果放入存在有text,则不利用FreeMarker模板生成,直接去text
			if(null != map.get("text")){
				text = map.get("text").toString();
			}else{
				Template template = freeMarkerConfigurer.getConfiguration()
						.getTemplate(map.get("template").toString());
				// 模板中用${XXX}站位，map中key为XXX的value会替换占位符内容。
				text = FreeMarkerTemplateUtils.processTemplateIntoString(template,
						map);
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (TemplateException e) {
			e.printStackTrace();
		}
		this.taskExecutor.execute(new SendMailThread(to, subject, text));
	}

	// 内部线程类，利用线程池异步发邮件。
	private class SendMailThread implements Runnable {
		private String to;
		private String subject;
		private String content;

		private SendMailThread(String to, String subject, String content) {
			super();
			this.to = to;
			this.subject = subject;
			this.content = content;
		}

		@Override
		public void run() {
			sendMail(to, subject, content);
		}
	}

	/**
	 * 发送邮件
	 * 
	 * @param to
	 *            收件人邮箱
	 * @param subject
	 *            邮件主题
	 * @param content
	 *            邮件内容
	 */
	public void sendMail(String to, String subject, String content) {
		try {
			MimeMessage message = javaMailSender.createMimeMessage();
			MimeMessageHelper messageHelper;
			try {
				messageHelper = new MimeMessageHelper(message,
						true, "UTF-8");
				messageHelper.setFrom(simpleMailMessage.getFrom());
				if (subject != null) {
					messageHelper.setSubject(subject);
				} else {
					messageHelper.setSubject(simpleMailMessage.getSubject());
				}
				messageHelper.setTo(to);
				messageHelper.setText(content, true);
				javaMailSender.send(message);
			} catch (javax.mail.MessagingException e) {
				e.printStackTrace();
			}
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}
}
