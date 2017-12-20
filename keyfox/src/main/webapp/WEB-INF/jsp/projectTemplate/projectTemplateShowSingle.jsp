<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  

<title>项目模板详细信息</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">

//关闭弹出的页面
function shut(){
	parent.closeWin();
}

//点击文档名称查看文档内容
function checkFun(id){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'查看文档模板信息',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 500,
		width: 600
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentTemplateController/checkDocumentTemplatePage?id="+id);
}


/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	menuList.bootstrapTable('refresh');
}

</script>
</head>

<style>
	.jbxinxi_s,.qr_input,.docModelName { width:187px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
	.qr_input { width:200px; }
	.docModelName { display:inline-block; width:130px;}
</style>
<body>

 <div class="popup_tit mtmb20">项目模板信息</div>
 <div class="jbinformation roleshux">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
  		<tr>
		    <td width="150" height="50" align="center" bgcolor="#f7f4f4">模板名称:</td>
		    <td width="187" valign="middle">
		    	<div class="jbxinxi_s" title="${projectTemplateType.projectTemplateName}" >${projectTemplateType.projectTemplateName}</div>
		    </td>
		    <td width="150" align="center" valign="middle" bgcolor="#f7f4f4">样式定义模板:</td>
		    <td width="230">
			    <c:forEach items="${styleTemplateList}" var="styleTemplate">
			     <div class="qr_input" title="${styleTemplate.styleDocumentName}">
					<c:if test="${styleTemplate.id==projectTemplateType.styleSetTemplate }">
						${styleTemplate.styleDocumentName}
					</c:if>
				 </div>
				</c:forEach>
			</td>
  		</tr>
  		<tr>
		    <td height="50" align="center" bgcolor="#f7f4f4">适用范围:</td>
		    <td valign="middle">
		    	<div class="qr_input" title="${projectTemplateType.applicationScope}">${projectTemplateType.applicationScope}</div>
		    </td>
		    <td align="center" valign="middle" bgcolor="#f7f4f4">样式输出模板:</td>
		    <td>
		      	<c:forEach items="${styleTemplateList}" var="styleTemplate">
		      	 <div class="qr_input" title="${styleTemplate.styleDocumentName}">
					<c:if test="${styleTemplate.id==projectTemplateType.styleOutTemplate }">${styleTemplate.styleDocumentName} </c:if>
				 </div>
				</c:forEach>
		    </td>
  		</tr>
	</table>
</div>
<div class="wdang_s newz_popup newz_popup23" style="text-align: center;">
    <table width="100%" border="1" cellspacing="0" cellpadding="0" class="tablebox">
        <thead>
          <tr style="height: 30px;">
           	<td width="14%">序号</td>	
            <td width="20%">文档模板名称</td>
            <td width="20%"><span >文档类型</span></td>
            <td width="20%"><span >适用范围</span></td>
            <td width="20%">文档模板来源</td>
          </tr>
         </thead>
          <c:forEach items="${projectTemplateList}" var="projectDocument"  varStatus="status">
			<tr <c:if test="${projectDocument.templateStatus =='0' }">style="color: #CACAC4;" </c:if>>	
				<td>${status.count}</td>
				<td>
					<a class="docModelName" href="javascript:;"  onclick="checkFun('${projectDocument.id}');"
						<c:if test="${projectDocument.templateStatus =='0' }">style="color: #CACAC4;" </c:if> title="${projectDocument.documentTemplateName }" >${projectDocument.documentTemplateName }</a>
				</td>
				<td>${projectDocument.documentType }</td>
				<td>${projectDocument.applicationScope }</td>
				<td>
					<c:if test="${projectDocument.source=='初始化'}">标准文档模板</c:if>
					<c:if test="${projectDocument.source=='自定义'}">自定义文档模板</c:if>
					<c:if test="${projectDocument.source=='文档范本库'}">文档范本库</c:if>
				</td>
			</tr>
		</c:forEach>
    </table>  
</div>
                           
	<div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="0"></iframe>
	</div>



</body>
</html>