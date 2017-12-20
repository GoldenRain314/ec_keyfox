<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档历史版本</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
function documentPreview(documentId,projectId){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'查看文档',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 950
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/documentController/documentPreview?documentId="+documentId+"&projectId="+projectId);
}
</script>
</head>
<body>
<div class="dotted_line dotted_line1 widthauto">
            <div class="xmugonj_cont ma" style="display:block; padding:0 15px;">
                <div class="xmugonj_ta_j widthauto">
             	  <div class="xmugonj_ta_j widthauto">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="changeInfluence">
	                    <thead>
	                      <tr>
	                        <td width="5%" height="50" align="center" bgcolor="#f5f6f6">序 号</td>
	                        <td width="16%" align="center" bgcolor="#f5f6f6">版本号</td>
	                        <td width="10%" align="center" bgcolor="#f5f6f6">发布时间</td>
	                        <td width="7%" align="center" bgcolor="#f5f6f6">发布人</td>
	                        <td width="7%" align="center" bgcolor="#f5f6f6">操作</td>
	                    
	                      </tr>
	                   </thead>
	                   <tbody>
	                  	<c:choose>
	                  		<c:when test="${size != '0'}">
		                    	<c:forEach var="list" items="${list }" varStatus="index">
				                  	<tr id="${list.id }" <c:if test="${(index.index+1) %2 == 0 }">bgcolor="#f1f3f6"</c:if> >
				                  		<td align="center">${index.index+1 }</td>
				                        <td align="center">${list.documentVersion }</td>
				                        <td align="center">${list.publishTime }</td>
				                        <td align="center">
				                        <c:forEach var="user" items="${userList}">
				                         <c:if test="${user.id ==list.releaserId}">${user.userName}</c:if>
				                        </c:forEach>
				                       
				                        </td>
				                        <td align="center">
				                        	<a href="javascript:void(0);" onclick="documentPreview('${list.id }','${list.projectId}')">查看</a>
				                        </td>
				                  	</tr>
		                  		</c:forEach>
		                    </c:when>
		                  	<c:otherwise>
		                  		<tr>
		                  			<td colspan="5" align="center">该文档还没有发布！！！</td>
		                  		</tr>
		                  	</c:otherwise>
	                  	</c:choose>
	                   </tbody>
	                </table>
			     </div>
               </div>
            </div>
	<div class="clear"></div>
</div>
<div id="popDiv" style="display: none;">
	<iframe id="popIframe" border="0" frameborder="no"></iframe>
</div>
</body>
</html>
