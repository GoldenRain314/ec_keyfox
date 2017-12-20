<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加菜单</title>
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
	$("#addMenu").validationEngine({
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
	
	/* 提交 */
	$("#submit").click(function (){
		if($('#addMenu').validationEngine('validate')){
			$("#submit").unbind("click");
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
			$('#addMenu').ajaxSubmit(options);
		}
	});
	
	$("#close").click(function (){
		parent.closeWin();
	});
});



</script>
</head>
<body>
<form action="${_baseUrl}/menu/insertMenu" id="addMenu" method="post">
<div class="jbinformation roleshux">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="15%" height="50" align="center" bgcolor="#f7f4f4">菜单名称</td>
	    <td width="35%" valign="middle"><div class="jbxinxi_s">
	    	<input type="text" name="menuName" id="menuName" value="${menuInfo.menuName }" <c:if test="${menuInfo != null }">readonly="readonly"  disabled="disabled"</c:if> class="validate[required] jbxinxi_input" style="width:230px;"></div><div class="jbxinxi_span1">*</div>
	    	<input type="hidden" name="menuId" value="${menuInfo.menuId }"/>
	    </td>
	    <td width="15%" align="center" valign="middle" bgcolor="#f7f4f4">菜单请求地址</td>
	    <td width="35%"><div class="jbxinxi_s">
	    	<input type="text" name="menuUrl" id="menuUrl" value="${menuInfo.menuUrl }" <c:if test="${menuInfo != null }">readonly="readonly"  disabled="disabled"</c:if> class="validate[required] jbxinxi_input" style="width:230px;"></div><div class="jbxinxi_span1">*</div>
	    </td>
	  </tr>
	  <tr>
	    <td height="50" align="center" bgcolor="#f7f4f4">排序</td>
	    <td valign="middle"><div class="jbxinxi_s">
	    	<input type="text" name="menuSeq" id="menuSeq" value="${menuInfo.menuSeq }" class="validate[required,custom[integer]] jbxinxi_input" style="width:230px;"></div><div class="jbxinxi_span1">*</div>
	    </td>
	    <td align="center" valign="middle" bgcolor="#f7f4f4">样式</td>
	    <td valign="top"><div class="jbxinxi_s">
	    	<input type="text" name="classType" id="classType" value="${menuInfo.classType }" class="jbxinxi_input" style="width:230px;"></div>
	    </td>
	  </tr>
	  <tr>
	    <td height="50" align="center" bgcolor="#f7f4f4">父菜单</td>
	    <td valign="middle">
	    	<div class="qr_input">
	    	<select class="qr_select" name="parentId" style="width:230px;">
	    		<option value="">请选择父节点</option>
	    		<c:forEach items="${firstMenuList}" var="menu">
					<option value="${menu.menuId }" <c:if test="${menu.menuId == menuInfo.parentId}">selected="selected"</c:if> >${menu.menuName }</option>
				</c:forEach>
	      </select></div>
	    </td>
	    <td valign="middle" bgcolor="#f7f4f4">&nbsp;</td>
	    <td valign="middle">&nbsp;</td>
      </tr>
	</table>
</div>

<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="menu:insertMenu">
        <a href="javascript:;" class="per_baocun" id="submit">保 存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class="per_gbi" id="close">关 闭</a>
</div>
</form>

</body>
</html>