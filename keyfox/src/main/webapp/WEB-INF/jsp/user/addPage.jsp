<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加用户</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript">
var userIdNameMap;
$.ajax({
	type: "POST",
	url: '${_baseUrl}/userController/getUserIdName',
	dataType: "json",
	async : false,
	success: function(result){
		userIdNameMap = result;
	},
	error : function (XMLHttpRequest, textStatus, errorThrown) {
	}
});

$(function (){
	var path='${_baseUrl}/departmentController/getParentId';
	$.ajax({
		cache:false,
		async:false,
		type:"POST",
		url:path,
		dataType:"json",
		success: function(data){
			var obj=JSON.stringify(data);
			var innerHtml="<select id='departId' name='departId' style='height:26px; width:150px; margin-left:20px;'>";
			if(obj=="[]"){
				innerHtml+="<option value=''></option>"; 
			}else{
				innerHtml+="<option value=''></option>";    
				for(var i=0;i<data.length;i++){	
						innerHtml+="<option value='"+data[i].id+"'>"+data[i].deptName+"</option>";    
				}  
			}
			innerHtml+="</select>";                  
			$("#depart").html(innerHtml);
		}
	})

	$("#submit").click(function (){
		if($("#user").validationEngine('validate')){
			var userId=$("#userId").val();
			var userName=$("#userName").val();
			var password=$("#password").val();
			var confirmPwd=$("#confirmPwd").val();
			for(var i=0; i<userIdNameMap.length; i++){
				if (userIdNameMap[i].userId == userId) {
					layer.msg("用户账号已存在！");   /* 更改提示语  */
					return false;
				}
			}
			if(password!=confirmPwd){
				layer.msg("两次密码不相同！");
				return false;
			}
			var options = {
					dataType:"json",
					success:function(json){
						if(json.code == '1'){
							layer.msg(json.message,{shift:5},function(){
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
				$('#user').ajaxSubmit(options);
			
		}
		
	});

})
</script>
</head>
<body>
	<form name="user" id="user" action="${_baseUrl}/userController/add" method="post">  
		用户登陆名:<input type="text" name="userId" id="userId" class="validate[required] jbxinxi_input"/><br/>
		用户名称:<input type="text" name="userName" id="userName" class="validate[required] jbxinxi_input"/><br/>
		密码:<input type="password" name="password" id="password" class="validate[required] jbxinxi_input"/><br/>
		确认密码：<input type="password" name="confirmPwd" id="confirmPwd" class="validate[required] jbxinxi_input"/><br/>
		所属部门:<span id="depart" ></span><br/>
		职务:<input type="text" name="post" id="post" /><br/>
		电子邮箱:<input type="text" name="email" id="email" /><br/>
		办公电话:<input type="text" name="officeTelephone" id="officeTelephone" /><br/>
		员工编号:<input type="text" name="userNumber" id="userNumber" class="validate[required]"/><br/>
		身份证号码:<input type="text" name="idCard" id="idCard" /><br/>
		手机:<input type="text" name="mobilePhone" id="mobilePhone" /><br/>
		性别:<input type="radio" name="sex" id="sex" value="0"  checked="checked"/>男
          <input type="radio" name="sex" id="sex" value="1"/>女
          <br/>
		家庭电话:<input type="text" name="homePhone" id="homePhone" /><br/>
    	<input type="button" value="保存" id="submit"/> 
	</form> 
</body>
</html>