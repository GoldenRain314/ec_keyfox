<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改用户信息</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript">
$(function (){
	$("#close").click(function (){
		parent.refreshTable();
		parent.closeWin();
	});

		
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
	
	$.ajax({
		cache:false,
		async:false,
		type:"POST",
		url:'${_baseUrl}/departmentController/getParentId',
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
});
</script>
</head>
<body>

<form name="user" id="user" action="${_baseUrl}/userController/edit" method="post">  
<input type="hidden" name="id" id="id"/><br/>
<div class="jbinformation">
    <table width="860" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="122" height="50" align="center" valign="middle" bgcolor="#f7f4f4">用户账号</td>
        <td width="167" valign="middle"><div class="jbxinxi_s"><input type="text" name="userId" id="userId" readonly disabled="disabled" class="validate[required,maxSize[25],custom[onlyGeneralCharacter]] jbxinxi_input"></div><div class="jbxinxi_span1">*</div></td>
        <td width="122" align="center" bgcolor="#f7f4f4">员工编号</td>
        <td width="167"><div class="jbxinxi_s"><input type="text" name="userNumber" id="userNumber" class="validate[required,maxSize[50]] jbxinxi_input"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名</td>
        <td><div class="jbxinxi_s"><input type="text" name="userName" <c:if test="${userInfo.userName == '系统管理员' || userInfo.userName == '安全保密员' || userInfo.userName == '安全审计员' }">readonly disabled="disabled"</c:if> id="userName" class="validate[required,maxSize[25]] jbxinxi_input"></div><div class="jbxinxi_span1">*</div></td>
        <td align="center" bgcolor="#f7f4f4">身份证号码 </td>
        <td valign="top"><div class="jbxinxi_s"><input type="text" name="idCard" id="idCard" class="jbxinxi_input validate[custom[chinaIdLoose]"></div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">所属部门</td>
        <td valign="middle"><div class="qr_input"><span id="depart" ></span></div></td>
        <td align="center" bgcolor="#f7f4f4">电子邮件</td>
        <td valign="top"><div class="jbxinxi_s"><input type="text" name="email" id="email"   class="validate[custom[email],maxSize[100]] jbxinxi_input"/></div></td>     
      </tr>
      
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别</td>
        <td><div class="jbxinxi_xibie">
        		<dl>
                	<dt><input type="radio" name="sex" id="sex" value="0"></dt>
                    <dd>男</dd>
                </dl>
                <dl>
                	<dt><input type="radio" name="sex" id="sex" value="1"></dt>
                    <dd>女</dd>
                </dl>
        	<div class="clear"></div>
        </div></td>
        <td align="center" bgcolor="#f7f4f4">手      机</td>
        <td valign="top"><div class="jbxinxi_s"><input type="text" name="mobilePhone" id="mobilePhone" class="validate[custom[mobile]] jbxinxi_input"></div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">办公电话</td>
        <td valign="top"><div class="jbxinxi_s"><input type="text" name="officeTelephone" id="officeTelephone" class="jbxinxi_input validate[maxSize[50],minSize[2],custom[onlyGeneralCharacter]]"></div></td>
        <td align="center" bgcolor="#f7f4f4">家庭电话</td>
        <td valign="top"><div class="jbxinxi_s"><input type="text" name="homePhone" id="homePhone" class="validate[maxSize[50],minSize[2],custom[onlyGeneralCharacter]] jbxinxi_input"></div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">职&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;务</td>
        <td valign="top"><div class="jbxinxi_s"><input type="text" name="post" id="post" class="validate[maxSize[50]] jbxinxi_input"></div></td>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">&nbsp;</td>
        <td valign="top">&nbsp;</td>
      </tr>
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="userController:edit">
       <a href="javascript:;" class="per_baocun" id="submit">保存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class="per_gbi" id="close">关闭</a>

</div>
</form>
</body>
</html>
