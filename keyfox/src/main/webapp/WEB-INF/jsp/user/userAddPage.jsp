<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加用户</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript" >
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
	$("#user").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomLeft',//提示信息的位置
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
	
	
	var path='${_baseUrl}/departmentController/getParentId';
	$.ajax({
		cache:false,
		async:false,
		type:"POST",
		url:path,
		dataType:"json",
		success: function(data){
			var obj=JSON.stringify(data);
			var innerHtml="<select id='departId' name='departId' class='qr_select'><option value=''>请选择</option>";
			if(obj=="[]"){
				innerHtml+=""; 
			}else{
				innerHtml+="";    
				for(var i=0;i<data.length;i++){	
						innerHtml+="<option value='"+data[i].id+"'>"+data[i].deptName+"</option>";    
				}  
			}
			innerHtml+="</select>";                  
			$("#depart").html(innerHtml);
		}
	});

	$("#submit").click(function (){
		if($("#user").validationEngine('validate')){
			var userId=$("#userId").val();
			var userName=$("#userName").val();
			var password=$("#password").val();
			var confirmPwd=$("#confirmPwd").val();
			for(var i=0; i<userIdNameMap.length; i++){
				if (userIdNameMap[i].userId == userId) {
					layer.msg("用户账号已存在！");    /* 更改提示语  */
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
	$("#close").click(function (){
		parent.refreshTable();
		parent.closeWin();
	});
	
	//将密码至为空
	$("#password").val("");

})
</script>
</head>
<body>
<form name="user" id="user" action="${_baseUrl}/userController/add" method="post">  
<div class="jbinformation">
	<table width="860px">
		<tr>
			<td width="122px">用户账号</td>
			<td width="167px"><div class="jbxinxi_s"><input type="text" name="userId" id="userId" class="validate[required,maxSize[25],custom[onlyGeneralCharacter]] jbxinxi_input"></div><div class="jbxinxi_span1">*</div></td>
			<td width="122px">员工编码</td>
			<td width="167px"><div class="jbxinxi_s"><input type="text" value="${userNumber }" name="userNumber" id="userNumber" class="validate[required,maxSize[20]] jbxinxi_input"></div><div class="jbxinxi_span1">*</div></td>
		</tr>
		<tr>
			<td>密&emsp;&emsp;码</td>
			<td>
				<div class="jbxinxi_s">
	        		<input type="password" name="password" id="password" class="validate[required,minSize[${pwdMinLength }],maxSize[${pwdMaxLength }],custom[passwordRule]] jbxinxi_input">
	        	</div>
	        	<div class="jbxinxi_span1">*</div>
	        	<div class="password-meter">
					<div class="password-meter-message"></div>
					<div class="password-meter-bg">
						<div class="password-meter-bar"></div>
					</div>
				</div>
			</td>
			<td>确认密码</td>
			<td><div class="jbxinxi_s"><input type="password" name="confirmPwd" id="confirmPwd" class="validate[required,equals[password]] jbxinxi_input"></div><div class="jbxinxi_span1">*</div></td>
		</tr>
		<tr>
			<td>姓&emsp;&emsp;名</td>
			<td><div class="jbxinxi_s"><input type="text" name="userName" id="userName" class="validate[required,maxSize[25]] jbxinxi_input"></div><div class="jbxinxi_span1">*</div></td>
			<td>身份证号码</td>
			<td><div class="jbxinxi_s"><input type="text" name="idCard" id="idCard" class="jbxinxi_input validate[custom[chinaIdLoose]]"></div></td>
		</tr>
		<tr>
			<td>所属部门</td>
			<td>
				<div class="qr_input">
	        		<span id="depart" ></span>
	        	</div>
	        </td>
			<td>电子邮件</td>
			<td><div class="jbxinxi_s"><input type="text" name="email" id="email"   class="validate[custom[email],maxSize[100]] jbxinxi_input"></div></td>
		</tr>
		<tr>
			<td>性&emsp;&emsp;别</td>
			<td>
				<div class="jbxinxi_xibie">
	        		<dl>
	                	<dt><input type="radio" name="sex" id="sex" value="0" ></dt>
	                    <dd>男</dd>
	                </dl>
	                <dl>
	                	<dt><input type="radio" name="sex" id="sex" value="1"></dt>    
	                    <dd>女</dd>
	                </dl>
		        	<div class="clear"></div>
		        </div>
		    </td>
			<td>手&emsp;&emsp;机</td>
			<td><div class="jbxinxi_s"><input type="text" name="mobilePhone" id="mobilePhone" class="validate[custom[mobile]] jbxinxi_input"></div></td>
		</tr>
		<tr>
			<td>办公电话</td>
			<td><div class="jbxinxi_s"><input type="text" name="officeTelephone" id="officeTelephone" class="validate[maxSize[50],minSize[2],custom[onlyGeneralCharacter]] jbxinxi_input"></div></td>
			<td>家庭电话</td>
			<td><div class="jbxinxi_s"><input type="text" name="homePhone" id="homePhone" class="validate[maxSize[50],minSize[2],custom[onlyGeneralCharacter]] jbxinxi_input"></div></td>
		</tr>
		<tr>
			<td>职&emsp;&emsp;务</td>
			<td><div class="jbxinxi_s"><input type="text" name="post" id="post" class="validate[maxSize[50]]  jbxinxi_input"></div></td>
			<td></td>
			<td></td>
		</tr>
	</table>
</div>
<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="userController:add">
       <a href="javascript:;" class="per_baocun" id="submit">保存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class="per_gbi" id="close">关闭</a>
</div>
</form>
</body>
<script type="text/javascript">
$(function(){
	clearBlank();
})
function clearBlank(){
	var obj = $("td");
	for(var i = 0; i<obj.length; i++){
		if(i%2 == 0){
			obj.eq(i).each(function(){
				var str = $(this).html();
				console.log(str);
				$(this).css({'text-align':'center','background':'#f7f4f4','height':'50px'});
			})
		}
	}
}
</script>
</html>
