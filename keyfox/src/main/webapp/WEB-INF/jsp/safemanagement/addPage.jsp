<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加安全设置信息</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}/JSON-js-master/json2.js" charset="utf-8"></script>
<script type="text/javascript">
$(function (){
	$("#safeManagement").validationEngine({
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
	$("#submit").click(function (){
		var formChecked = $('#safeManagement').validationEngine('validate');
		var minLength = $("#minimumPwdLength").val();
		var maxLength = $("#maximumPwdLength").val();
		if(parseInt(maxLength) < parseInt(minLength)){
			layer.msg("最长密码长度不能小于最短密码长度");
			return false;	
		}
		
		if(formChecked){
			$("#submit").unbind("click");
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
			$("#safeManagement").ajaxSubmit(options);
		}
	});
	
	$("#close").click(function (){
		parent.refreshTable();
		parent.closeWin();
	});

})
</script>
</head>
<body>
<br>
	<form name="safeManagement" id="safeManagement" action="${_baseUrl}/safeManagementController/add" method="post">  
<div class="jbinformation" style="width:723px;">
    <table width="723" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="120" height="50" align="center" valign="middle" bgcolor="#f7f4f4"> 系统密级</td>
        <td width="237" valign="middle">
        	<div class="qr_input">
        		<select name="systemLevel" id="systemLevel" class="validate[required] qr_select fl" style="width:202px; height:auto;padding:5px 0;margin-top: 11px;" >
					<option value="">请选择系统密级</option> 
					<option value='0'>普通</option> 
					<option value='1'>秘密</option> 
					<option value='2'>机密</option>
					<option value='3'>绝密</option>
				</select>
			</div>
			<div class="jbxinxi_span1">*</div>
		</td>
        <td width="129" align="center" bgcolor="#f7f4f4">密码锁定次数</td>
        <td width="237">
        	<div class="jbxinxi_s" style="width:auto;">
        		<input type="text" name="pwdLocktimes" id="pwdLocktimes" class="validate[required,custom[positiveInteger],maxSize[11]] jbxinxi_input" style="width:195px;"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">最短密码长度</td>
        <td><div class="jbxinxi_s" style="width:auto;"><input type="text" name="minimumPwdLength" id="minimumPwdLength" class="validate[required,custom[positiveInteger],maxSize[11]] jbxinxi_input" style="width:195px;"></div><div class="jbxinxi_span1">*</div></td>
        <td align="center" bgcolor="#f7f4f4">最长密码长度</td>
        <td valign="top"><div class="jbxinxi_s" style="width:auto;"><input type="text" name="maximumPwdLength" id="maximumPwdLength" class="validate[required,custom[positiveInteger],maxSize[11]] jbxinxi_input" style="width:195px;"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">密码失效时间(天)</td>
        <td valign="middle">
        	<div class="jbxinxi_s" style="width:auto;">
        		<input type="text" name="pwdExpirationTime" id="pwdExpirationTime" class="validate[required,custom[positiveInteger],maxSize[11]] jbxinxi_input" style="width:195px;" />
        	</div>
        	<div class="jbxinxi_span1">*</div>
        </td>
        <td align="center" bgcolor="#f7f4f4">用户非活跃时间(天)</td>
        <td valign="top"><div class="jbxinxi_s" style="width:auto;"><input type="text" name="userInactiveTime" id="userInactiveTime" class="validate[required,custom[positiveInteger],maxSize[11]] jbxinxi_input" style="width:195px;"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">口令更换周期(天)</td>
        <td><div class="jbxinxi_s" style="width:auto;"><input type="text" name="pwdChangeCycle" id="pwdChangeCycle" class="validate[required,custom[positiveInteger],maxSize[11]] jbxinxi_input" style="width:195px;" ></div><div class="jbxinxi_span1">*</div></td>
        <td width="129" bgcolor="#f7f4f4">&nbsp;</td>
	    <td width="237">&nbsp;</td>
      </tr>
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="safeManagementController:add">
       <a href="javascript:;" class="per_baocun" id="submit">保存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class="per_gbi" id="close">关闭</a>

</div>
	</form> 
</body>
</html>