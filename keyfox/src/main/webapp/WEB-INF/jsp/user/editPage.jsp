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
$(function (){
	$("#submit").click(function (){
		if($("#user").validationEngine('validate')){
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
	$.ajax({
		cache:false,
		async:false,
		type:"POST",
		url:'${_baseUrl}/departmentController/getParentId',
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
	});
	var id='${id}';
	var path="${_baseUrl}/userController/viewInfo";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"id":id      
		},    
		dataType:"json",    
		success: function (data) { 
			$("#userId").val(data.userId);
			$("#userName").val(data.userName);
			$("#departId").val(data.departId);
			$("#id").val(data.id);
			$("#post").val(data.post);
			$("#email").val(data.email);
			$("#officeTelephone").val(data.officeTelephone);
			$("#userNumber").val(data.userNumber);
			$("#idCard").val(data.idCard);
			$("#mobilePhone").val(data.mobilePhone);
			var sex = $("input[name='sex']");
			for(var i=0;i<sex.length;i++){
				if($(sex[i]).val()==data.sex){
					$(sex[i]).attr("checked","checked");
				}
			}
			$("#homePhone").val(data.homePhone);
		}   
	}); 
})

</script>
</head>
<body>
	<form name="user" id="user" action="${_baseUrl}/userController/edit" method="post">  
		<input type="hidden" name="id" id="id"/><br/>
		用户登陆名:<input type="text" name="userId" id="userId"  readonly class="validate[required]"/><br/>
		用户名称:<input type="text" name="userName" id="userName" class="validate[required]"/><br/>
		所属部门:<span id="depart" ></span><br/>
		职务:<input type="text" name="post" id="post" /><br/>
		电子邮箱:<input type="text" name="email" id="email" /><br/>
		办公电话:<input type="text" name="officeTelephone" id="officeTelephone" /><br/>
		员工编号:<input type="text" name="userNumber" id="userNumber" class="validate[required]"/><br/>
		身份证号码:<input type="text" name="idCard" id="idCard" /><br/>
		手机:<input type="text" name="mobilePhone" id="mobilePhone" /><br/>
		性别:<input type="radio" name="sex" id="sex" value="0" />男
          <input type="radio" name="sex" id="sex" value="1" />女<br/>
		家庭电话:<input type="text" name="homePhone" id="homePhone" /><br/>
    	<input type="button" value="保存"id="submit"/> 
	</form> 
</body>
</html>