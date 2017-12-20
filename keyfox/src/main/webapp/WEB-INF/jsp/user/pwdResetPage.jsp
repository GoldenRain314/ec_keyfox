<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改用户信息</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript">
var userId='${userId}';
var pwdMinLength='${pwdMinLength}';
var pwdMaxLength='${pwdMaxLength}';
function checkPassWord(){
	 var password=document.getElementById("password").value;
	var reg =  /^[a-zA-Z\d]*(([\d]+[a-z]+[A-Z]+)+|([\d]+[A-Z]+[a-z]+)+|([a-z]+[A-Z]+[\d]+)+|([a-z]+[\d]+[A-Z]+)+|([A-Z]+[\d]+[a-z]+)+|([A-Z]+[a-z]+[\d]+)+|\W+)[a-zA-Z\d]*$/;
	if(!reg.test(password)&&""!=password){
		alert("密码中必须包含数字、大写字母和小写字母！可以包含特殊字符！");
		document.getElementById("password").value="";
		document.getElementById("password").focus();
		return false;
	}
	if(pwdMinLength!=0&&pwdMaxLength!=0){
		var passwordlength = password.length;
		if (passwordlength > pwdMaxLength&&""!=password) {
			alert("长度大于密码最大长度" + pwdMaxLength + "，请重新输入");
			return false;
		}
		if (passwordlength < pwdMinLength&&""!=password) {
			alert("长度小于密码最小长度" + pwdMinLength + "，请重新输入");
			return false;
		}
	} 
}
$(function (){
	$("#userId").val(userId);
})
function check(){
	if($("#user").validationEngine('validate')){
		checkPassWord();
		var password=$("#password").val();
		var confirmPwd=$("#confirmPwd").val();
		if(password!=confirmPwd){
			alert("两次密码不相同！");
			return false;
		}	
		alert("修改成功");
		$("#user").submit();
	}
}
</script>
</head>
<body>
	<form name="user" id="user" action="${_baseUrl}/userController/editPwd" method="post">  
		<input type="hidden" name="userId" id="userId"/><br/>
		新密码:<input type="password" name="password" id="password" class="validate[required]" onblur="checkPassWord();"/><br/>
		确认密码:<input type="password" name="confirmPwd" id="confirmPwd" class="validate[required]"/><br/>
    	<input type="button" value="保存" onClick="check();"/> 
	</form> 
</body>
</html>