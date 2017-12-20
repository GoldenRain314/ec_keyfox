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


function getChangeContent(changeId,oldDocumentId,projectId){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'内容变更单',
		autoOpen: true,
		modal: true,	
		height: 550,
		width: 900
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/cdc/showChangeContent?projectId="+projectId+"&documentId="+oldDocumentId+"&changeId="+changeId+"&readOnly=true");
}

function getChangeRequestForm(changeId,projectId){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'变更申请单',
		autoOpen: true,
		modal: true,	
		height: 550,
		width: 900
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/ci/showChangeRequestNoteDetails?projectId="+projectId+"&changeId="+changeId);
}

function influenceAnalyze(changeId,projectId){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'影响域分析',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 950
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/ci/showChangeInfluence?projectId="+projectId+"&changeId="+changeId+"&readOnly=true");
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
		                       
		                    	 <td width="5%" height="50" align="center" bgcolor="#f5f6f6">变更次数</td>
		                        <td width="10%" align="center" bgcolor="#f5f6f6">内容变更单</td>
		                        <td width="10%" align="center" bgcolor="#f5f6f6">变更申请时间</td>
		                        <td width="8%" align="center"  bgcolor="#f5f6f6">变更执行人员</td>
		                        <td width="10%" align="center" bgcolor="#f5f6f6">变更后的文档版本</td>
                   				<td width="8%" align="center" bgcolor="#f5f6f6">变更申请单</td>
                    	  		<td width="7%" align="center" bgcolor="#f5f6f6">变更影响域</td>
	                    	   	<td width="8%" align="center" bgcolor="#f5f6f6">文档变更章节</td>
		                      </tr>
		                  </thead>
		                  <tbody>
				                <c:choose>
			                  		<c:when test="${size != '0'}">
				                    	<c:forEach var="list" items="${listHistoryVo }" varStatus="index">
						                  	<tr id="${list.changeId }" <c:if test="${(index.index+1) %2 == 0 }">bgcolor="#f1f3f6"</c:if> >
						                  		<td align="center">${index.index+1 }</td>
						                        <td align="center"><a onClick="getChangeContent('${list.changeId }','${list.oldDocumentId }','${projectId}');">查看</a></td>
						                        <td align="center">${list.newPublishTime }</td>
						                        <td align="center">${list.changePersionName }</td>
						                        <td align="center">${list.newVersion }</td>
						                        <td align="center"><a onClick="getChangeRequestForm('${list.changeId }','${projectId}');">查看</a></td>
						                        <td align="center"><a onClick="influenceAnalyze('${list.changeId }','${projectId}');">查看</a></td>
						                        <td align="center">${list.changeSection }</td>
						                  	</tr>
				                  		</c:forEach>
				                    </c:when>
				                  	<c:otherwise>
				                  		<tr>
				                  			<td colspan="8" align="center">该文档还没有变更记录！！！</td>
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
