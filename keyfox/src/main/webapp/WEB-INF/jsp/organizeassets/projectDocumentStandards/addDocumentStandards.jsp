<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加评审级别</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}datepicker/WdatePicker.js"></script>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript">
$(function (){
	$("#documentStandards").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomRight',//提示信息的位置
		inlineValidation: true,//是否即时验证，false为提交表单时验证,默认true  
		failure : function() {
		    layer.message("验证失败，请检查");
			return false;  
		},//验证失败时调用的函数
		ajaxFormValidation: true,//开始AJAX验证
		success : function() {
		//	$("#addForm").submit();
		}//验证通过时调用的函数 
		//onAjaxFormComplete: ajaxValidationCallback
	});
	
	
	$("#close").click(function (){
		parent.closeWin();
	});
	
	/* 提交 */
	$("#submit").click(function (){
		var formChecked = $('#documentStandards').validationEngine('validate');
		if(formChecked){
			var options = {
				dataType:"json",
				success:function(json){
					if(json.code == '1'){
						$("#documentStandards").attr("action","");
						layer.msg(json.message,{shift:5,time:1000},function(){
							parent.refreshTable();
							parent.closeWin();
						});
					}
					if(json.code == '0'){
						layer.msg(json.message);
					}
				},
				error:function(json){
					layer.msg("发生错误");
				}
			};
			$('#documentStandards').ajaxSubmit(options);
		}
	});
})
function isHaveName(){
	 var name = $("#standardName").val();
	 $.ajax({ 
			url:'${_baseUrl}/projectDocumentStandards/isHaveName', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"name":name},
			async: false,
			success: function(data){
				if(data == "false"){
					$("#standardName").val("");
					layer.msg( "该名称已经存在");
				}
      	    },
			error:function(){
				layer.msg( "系统错误");
			}
	  });
 }
</script>
</head>
<body>

<form action="${_baseUrl}/projectDocumentStandards/saveDocumentStandardsMessage" id="documentStandards" method="post">
	<div class="jbinformation roleshux">
		<table width="723" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="150" height="50" align="center" bgcolor="#f7f4f4">标准名称</td>
		    <td width="187" valign="middle"><div class="jbxinxi_s">
		    	<input type="text" name="standardName" id="standardName" value="${projectDocumentStandards.standardName }" onblur="isHaveName();" class="validate[required,maxSize[200]] jbxinxi_input"></div><div class="jbxinxi_span1">*</div></td>
		  </tr>
		  <tr>
		    <td width="150" height="50" align="center" bgcolor="#f7f4f4">说明</td>
		    <td width="187" valign="top"><div class="jbxinxi_s">
		    	<input type="text" name="description" id="description" value="${projectDocumentStandards.description }" class="validate[1000] jbxinxi_input"></div></td>
		  </tr>
	</table>
	</div>
	<input type="hidden" value="${projectDocumentStandards.id }" name="id" />
	<div class="permission_an mubanclass_an ma mt30">
	    <shiro:hasPermission name="projectDocumentStandards:saveDocumentStandardsMessage">
	       <a href="javascript:;" class="per_baocun" id="submit">确 定</a>
	    </shiro:hasPermission>
	    <a href="javascript:;" class="per_gbi" id="close">取 消</a>
	</div>
</form>
</body>
</html>