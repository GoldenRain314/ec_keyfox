<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 验证权限问题 -->
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加权限</title>
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
	$("#addPermission").validationEngine({
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
		
		}//验证通过时调用的函数 
		//onAjaxFormComplete: ajaxValidationCallback
	});
	
	$("#close").click(function (){
		parent.closeWin();
	});
	
	/* 提交 */
	$("#submit").click(function (){
		var formChecked = $('#addPermission').validationEngine('validate');
		if(formChecked){
			var options = {
				dataType:"json",
				success:function(json){
					if(json.code == '1'){
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
			$('#addPermission').ajaxSubmit(options);
		}
		
	});
})
</script>
</head>
<body>
<br>
<form action="${_baseUrl}/permission/insertPermission" id="addPermission" method="post">
	<div class="jbinformation roleshux">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="15%" height="50" align="center" bgcolor="#f7f4f4">权限名称</td>
	    <td width="35%" valign="middle"><div class="jbxinxi_s">
    	<input type="text" name="permissionName" id="permissionName" value="${permissionInfo.permissionName }" class="validate[required] jbxinxi_input" style="width:230px;"></div><div class="jbxinxi_span1">*</div></td>
	    <td width="15%" align="center" valign="middle" bgcolor="#f7f4f4">权限</td>
	    <td width="35%"><div class="jbxinxi_s">
    	<input type="text" name="permission" id="permission" value="${permissionInfo.permission }"  class="validate[required] jbxinxi_input" style="width:230px;"></div><div class="jbxinxi_span1">*</div></td>
	  </tr>
	  <tr>
	    <td height="50" align="center" bgcolor="#f7f4f4">权限地址</td>
	    <td valign="middle"><div class="jbxinxi_s">
	    	<input type="text" name="permissionUrl" id="permissionUrl" value="${permissionInfo.permissionUrl }" class="validate[required] jbxinxi_input" style="width:230px;"></div><div class="jbxinxi_span1">*</div>
	    	<input type="hidden" name="permissionId" id="permissionId" value="${permissionInfo.permissionId }" />
	    </td>
	    <td valign="middle" bgcolor="#f7f4f4">&nbsp;</td>
	    <td valign="middle">&nbsp;</td>
	    </tr>
	</table>
	</div>
	<div class="permission_an mubanclass_an ma mt30">
	    <a href="javascript:;" class="per_baocun" id="submit">保 存</a>
	    <a href="javascript:;" class="per_gbi" id="close">关 闭</a>
	
	</div>
</form>
</body>
</html>