<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加438b文档的前项文档</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript">
$(function (){
	$("#addRole").validationEngine({
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
	
	//设置关联关系
	$("#documentRelation").val("${info.documentRelation}");
	
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
							parent.refreshTable();
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
<br>
<form action="${_baseUrl}/cfc/insertChangeFixed" id="addRole" method="post">
	<div class="jbinformation roleshux">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="15%" height="50" align="center" bgcolor="#f7f4f4">文档名称</td>
	    <td width="35%" valign="middle">
	    	<div class="qr_input">
		    	<select class="validate[required] qr_select" id="documentName" name="documentName">
		         <c:forEach items="${list }" var="list">
		         	<option value="${list.documentTemplateName }" <c:if test="${info.documentName == list.documentTemplateName}">selected="selected"</c:if>>${list.documentTemplateName }</option>
		         </c:forEach>
		      </select>
		     </div>
	    </td>
	  </tr>
	  <tr>
	  	<td width="15%" height="50" align="center" valign="middle" bgcolor="#f7f4f4">前项文档名称</td>
	    <td width="35%" valign="middle">
	    	<div class="qr_input">
		    	<select class="validate[required] qr_select" id="traceDocumentName" name="traceDocumentName">
		         <c:forEach items="${list }" var="list">
		         	<option value="${list.documentTemplateName }" <c:if test="${info.traceDocumentName == list.documentTemplateName}">selected="selected"</c:if>>${list.documentTemplateName }</option>
		         </c:forEach>
		      </select>
		      </div>
	    </td>
	   </tr>
	   <tr>
	  	<td width="15%" height="50" align="center" valign="middle" bgcolor="#f7f4f4">关联关系</td>
	    <td width="35%" valign="middle">
	    	<div class="qr_input">
		    	<select class="validate[required] qr_select" id="documentRelation" name="documentRelation">
		         	<option value="">请选择关联关系</option>
		         	<option value="0">直接关联</option>
		         	<option value="1">间接关联</option>
		      	</select>
		    </div>
	    </td>
	   </tr>
	   <tr>
    		<td width="15%" height="50" align="center" valign="middle" bgcolor="#f7f4f4">序号</td>
	    	<td width="35%" valign="middle">
		    	<div class="qr_input">
		    		<input type="text" name="seq" id="seq" value="${info.seq }" class="validate[required,custom[integer]] jbxinxi_input"></td>
			    </div>
	    	</td>
	   </tr>
	</table>
	</div>
	<div class="permission_an mubanclass_an ma mt30">
		<input type="hidden" name="id" value="${info.id }">
	    <a href="javascript:;" class="per_baocun" id="submit">保 存</a>
	    <a href="javascript:;" class="per_gbi" id="close">关 闭</a>
	</div>
</form>
</body>
</html>