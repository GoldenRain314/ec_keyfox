<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加角色</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript">
$(function (){
	$("#addRole").validationEngine({
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
	
	
	$("#close").click(function (){
		parent.closeWin();
	});
	
	/* 提交 */
	$("#submit").click(function (){
		var formChecked = $('#addRole').validationEngine('validate');
		if(formChecked){
			var options = {
				dataType:"json",
				success:function(json){
					if(json.code == '1'){
						layer.msg(json.message,{shift:5,time:1000},function(){
							$("#roleId").val(json.data);
							parent.setRoleId(json.data);
							parent.refreshTable();
							
							if("保存成功"==json.message)
								parent.click("roleUserList");
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
			$('#addRole').ajaxSubmit(options);
		}
	});
})
</script>
</head>
<body>

<form action="${_baseUrl}/role/insertRole" id="addRole" method="post">
	<div class="jbinformation roleshux">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="15%" height="50" align="center" bgcolor="#f7f4f4">角色名称</td>
	    <td width="35%" valign="middle"><div class="jbxinxi_s">
	    	<input type="text" name="roleName" id="roleName" <c:if test="${roleInfo.roleName == '系统管理员' || roleInfo.roleName == '管理员' || roleInfo.roleName == '安全保密员' || roleInfo.roleName == '安全审计员' }">readonly disabled="disabled"</c:if> value="${roleInfo.roleName }" class="validate[required,maxSize[25]] jbxinxi_input" style="width:282px;"></div><div class="jbxinxi_span1">*</div></td>
	    <td width="15%" align="center" valign="middle" bgcolor="#f7f4f4">角色编号</td>
	    <td width="35%"><div class="jbxinxi_s">
	    	<input type="text" name="roleCode" id="roleCode" <c:if test="${roleInfo.roleName == '系统管理员' || roleInfo.roleName == '管理员' || roleInfo.roleName == '安全保密员' || roleInfo.roleName == '安全审计员' }">readonly disabled="disabled"</c:if> value="${roleInfo.roleCode }" class="validate[required,maxSize[25]] jbxinxi_input" style="width:282px;"></div><div class="jbxinxi_span1">*</div>
	    	<input type="hidden" name="roleId" id="roleId" value="${roleInfo.roleId }"  />
	    </td>
	  </tr>

	  <!-- <tr>
	    <td height="50" align="center" bgcolor="#f7f4f4">继承角色</td>
	    <td colspan="3" valign="middle"><div class="qr_input">
	    	<select class="qr_select">
	          <option value="">aa</option>
	          <option value="">aaa</option>
	      </select></div></td>
	    </tr> -->
	</table>
	</div>
	<div class="permission_an mubanclass_an ma mt20">
		<shiro:hasPermission name="role:insertRole">
	        <a href="javascript:;" class="per_baocun" id="submit">保 存</a>
	    </shiro:hasPermission>
	    <a href="javascript:;" class="per_gbi" id="close">关 闭</a>
	</div>
</form>
</body>
</html>