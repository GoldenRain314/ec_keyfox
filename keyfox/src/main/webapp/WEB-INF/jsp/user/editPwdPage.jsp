<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改用户信息</title>
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript">
var pwdOld='${pwdOld}';
var pwdMinLength='${pwdMinLength}';
var pwdMaxLength='${pwdMaxLength}';

$(function (){
	$("#user").validationEngine({
		autoHidePrompt:true,//自动隐藏
		autoHideDelay:1000,
		scroll: true, 
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomLeft', //提示信息的位置
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
})

function check(){
	if($("#user").validationEngine('validate')){
		var options = {
			dataType:"json",
			success:function(json){
				if(json.code == '1'){
					layer.msg(json.message,{shift:5},function(){
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
		$('#user').ajaxSubmit(options);
	}
}
function closePage(){
	parent.closeWin();
}
</script>
<style>
	.jbinformation .jbxinxi_input{ width:350px;}
</style>
</head>

<body>
	<form name="user" id="user" action="${_baseUrl}/userController/editPwd" method="post">  
		<input type="hidden" name="userId" id="userId" value='${userId}'/><br/>
	
<div class="jbinformation" style="width:auto;">
	<table width="582" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="30%" height="50" align="center" bgcolor="#f7f4f4">原密码:</td>
    <td width="70%" valign="middle">
    	<div class="jbxinxi_s">
    		<input type="password" name="passwordOld" id="passwordOld" class="validate[required,,custom[onlyLetterNumber]] jbxinxi_input">
    	</div>
    	<div class="jbxinxi_span1">*</div>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" bgcolor="#f7f4f4">新密码:</td>
    <td valign="middle">
    	<div class="jbxinxi_s">
    		<input type="password" name="password" id="password" data-prompt-position="bottomRight:-130px;" class="validate[required,minSize[${pwdMinLength }],maxSize[${pwdMaxLength }],custom[passwordRule],custom[onlyLetterNumber]] jbxinxi_input">
    	</div>
    	<div class="jbxinxi_span1">*</div>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" bgcolor="#f7f4f4">确认密码:</td>
    <td colspan="3" valign="top">
    	<div class="jbxinxi_s">
    		<input type="password" name="confirmPwd" id="confirmPwd" class="validate[required,equals[password],,custom[onlyLetterNumber]] jbxinxi_input">
    	</div>
    	<div class="jbxinxi_span1">*</div>
    </td>
   </tr>
</table>

</div>
<div class="permission_an mubanclass_an ma mt30 mb20">
    <a href="javascript:;" class="per_baocun" onClick="check();">保存</a>
    <a href="javascript:;" class="per_gbi" onClick="closePage();">关闭</a>
</div>
	</form> 
</body>
</html>