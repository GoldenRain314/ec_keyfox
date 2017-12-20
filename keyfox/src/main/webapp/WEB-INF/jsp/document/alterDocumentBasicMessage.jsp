<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档基本信息</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0 minimal-ui"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<script type="text/javascript" src="${_resources}datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
	var opeator ="${opeator}";
	$(function(){
		$("#projectId").val("${projectId}");
		$("#documentId").val("${documentId}");
		
	});
	function save(){
		if($("#documentBaseinfo").validationEngine('validate')){
			var options = {
					dataType:"json",
					success:function(json){
						if(json.code == '1'){
							$("#submit").removeAttr('onclick');
							layer.msg(json.message,{shift:2},function(){
							});
						}
						if(json.code == '0'){
							layer.msg(json.message,{shift:2},function(){
								cancelAndClose();
							});
						}
					},
					error:function(json){
						layer.msg("发生错误");
					}
				};
			$('#documentBaseinfo').ajaxSubmit(options);
		}
	}
	/* 关闭弹出框 */
	
//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}
function judge_enter(){
    if(window.event.keyCode==13){
    	event.returnValue = false;//阻止刷新页面
    }
}

document.onkeydown=function(event) 
{ 
	e = event ? event :(window.event ? window.event : null); 
	if(e.keyCode==13){ 
		return false; 
	} 
} 	
	
</script>
</head>
<body>
	<div class="popup_tit mtmb20">文档基本信息</div>
	<div class="jbinformation" style="width:773px;">
	   	<form id="documentBaseinfo"  method="post" action="${_baseUrl}/document/saveDocumentBaseinfo?projectId=${projectId}&documentId=${documentId}">
	   		<span style="font-size:15px;">文档名称：</span><span style="font-size:15px;" id="templateName">${templateName}</span>
	   		<div class="mt20"></div>
		   	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="15%" height="50" align="center" bgcolor="#f7f4f4">研制单位</td>
				<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text" name="enterprise" id="enterprise" disabled="disabled" onkeypress="judge_enter();"  onkeydown="judge_enter();"  readonly="readonly" value="${enterprise}" class="jbxinxi_input" style="width:225px;"
				></div><div class="jbxinxi_span1"   <c:if test="${opeator=='check'}">  style="display: none;"</c:if>>*</div></td>
				<td width="15%" height="50" align="center" bgcolor="#f7f4f4">项目密级</td>
				<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text" name="projectClassification" disabled="disabled"  onkeypress="judge_enter();" onkeydown="judge_enter();"   value="${projectClassification}" id="projectClassification" readonly="readonly" class="jbxinxi_input" style="width:225px;"
				></div><div class="jbxinxi_span1"   <c:if test="${opeator=='check'}">  style="display: none;"</c:if> >*</div></td>
			  </tr>
			  <tr>
				<td width="15%" height="50" align="center" bgcolor="#f7f4f4">软件名称</td>
				<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text" name="testProjectName" onkeypress="judge_enter();"  onkeydown="judge_enter();"  id="testProjectName" class="jbxinxi_input  validate[required,maxSize[50]]" value="${documentBaseinfo.testProjectName }" style="width:225px;" 
				<c:if test="${opeator=='check'}"> disabled="disabled"</c:if>
				></div><div class="jbxinxi_span1"   <c:if test="${opeator=='check'}">  style="display: none;"</c:if>>*</div></td>
				<td width="15%" height="50" align="center" bgcolor="#f7f4f4">产品名称</td>
				<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text"  name="productName"   onkeypress="judge_enter();" onkeydown="judge_enter();" id="productName" value="${documentBaseinfo.productName }" class="jbxinxi_input validate[required,maxSize[50]]" style="width:225px;" 
				<c:if test="${opeator=='check'}"> disabled="disabled"</c:if>
		></div><div class="jbxinxi_span1"  <c:if test="${opeator=='check'}">  style="display: none;"</c:if>>*</div></td>
			  </tr>
			</table>
			<input type="hidden" id="projectId">
			<input type="hidden" id="documentId">
			<input type="hidden" id="id" name="id" value="${documentBaseinfo.id }">
	   	</form>
		
		<div class="permission_an mt30"  id ="buttonDiv" <c:if test="${opeator=='check'}"> style="display:none"</c:if>
		>
			<a href="javascript:;" id="submit" class="per_baocun" onclick="save();">保存</a>
			<a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">关闭</a>
	
		</div>
	</div>
</body>
</html>
