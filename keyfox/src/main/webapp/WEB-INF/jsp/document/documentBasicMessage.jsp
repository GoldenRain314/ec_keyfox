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
								parent.editDocument("${documentId}","${projectId}");
							});
						}
						if(json.code == '0'){
							layer.msg(json.message,{time:2000},function(){
								parent.closeWin();
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
	function skip(){
		/* var path="${_baseUrl}/documentSectionController/sectionTree?projectId=${projectId}&documentId=${documentId}";
		window.parent.location.href = path; */
		parent.editDocument("${documentId}","${projectId}");
	}
</script>
</head>
<body>
	<div class="popup_tit mtmb20">文档基本信息</div>
	<div class="jbinformation" style="width:761px;">
	   	<form id="documentBaseinfo"  method="post" action="${_baseUrl}/document/saveDocumentBaseinfo?projectId=${projectId}&documentId=${documentId}">
	   		<span style="font-size:15px;">文档名称：</span><span style="font-size:15px;" id="templateName">${templateName}</span>
	   		<div class="mt20"></div>
		   	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		   		<c:choose>
		   			<c:when test="${documentBaseinfo != '' && !empty documentBaseinfo}">
					 	<tr>
						<td width="15%" height="50" align="center" bgcolor="#f7f4f4">研制单位</td>
						<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text" name="enterprise" id="enterprise" readonly="readonly" value="${documentBaseinfo.enterprise}" class="jbxinxi_input" style="width:225px;"></div><div class="jbxinxi_span1">*</div></td>
						<td width="15%" height="50" align="center" bgcolor="#f7f4f4">项目密级</td>
						<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text" name="projectClassification" value="${documentBaseinfo.projectClassification}" id="projectClassification" readonly="readonly" class="jbxinxi_input" style="width:225px;"></div><div class="jbxinxi_span1">*</div></td>
					  </tr>	
		   			</c:when>
		   			<c:otherwise>
		   			  <tr>
						<td width="15%" height="50" align="center" bgcolor="#f7f4f4">研制单位</td>
						<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text" name="enterprise" id="enterprise" readonly="readonly" value="${enterprise}" class="jbxinxi_input" style="width:225px;"></div><div class="jbxinxi_span1">*</div></td>
						<td width="15%" height="50" align="center" bgcolor="#f7f4f4">项目密级</td>
						<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text" name="projectClassification" value="${projectClassification}" id="projectClassification" readonly="readonly" class="jbxinxi_input" style="width:225px;"></div><div class="jbxinxi_span1">*</div></td>
					  </tr>
		   			</c:otherwise>
		   		</c:choose>
			  <tr>
				<td width="15%" height="50" align="center" bgcolor="#f7f4f4">软件名称</td>
				<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text" name="testProjectName" id="testProjectName" class="jbxinxi_input validate[required,maxSize[50]]" value="${documentBaseinfo.testProjectName }" style="width:225px;"></div><div class="jbxinxi_span1">*</div></td>
				<td width="15%" height="50" align="center" bgcolor="#f7f4f4">产品名称</td>
				<td width="35%" valign="top"><div class="jbxinxi_s"><input type="text" name="productName" id="productName" value="${documentBaseinfo.productName }" class="jbxinxi_input validate[required,maxSize[50]]" style="width:225px;"></div><div class="jbxinxi_span1">*</div></td>
			  </tr>
			</table>
			<input type="hidden" id="projectId">
			<input type="hidden" id="documentId">
			<input type="hidden" id="id" name="id" value="${documentBaseinfo.id }">
	   	</form>
		
		<div class="permission_an mt30">
			<a href="javascript:;" id="submit" class="per_baocun" onclick="save();">保存</a>
			<a href="javascript:;" class="per_gbi" onclick="parent.closeWin();">关闭</a>
		</div>
	</div>
</body>
</html>
