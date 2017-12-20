<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>变更分析-影响域分析展示界面-只读界面</title>
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript">
$(function (){
	//选中变更级别
	var changeLevel = "${changevo.changeLevel}";
	var split = changeLevel.split(",");
	for(var i=0;i<split.length;i++){
		$("#"+split[i]).attr("checked",true);
	}
	
	//变更文档当前行变红
	$("#${changeDocumentId}").children().each(function (i){
		$(this).attr("class","juh_color")
	});
	
	/* 是否有错误信息 */
	var message = "${message}";
	if(message != ""){
		layer.msg(message);
	}
	
	
	var main_1=$('.main_1').height();
	$('.mainIframe').height(main_1);
	
	
})

</script>
</head>
<body>
<div class="ma main">
    	<div class="wdang_main">
        	<div class="page_tit_warp mtmb20"><div class="page_tit"><span>影响域分析</span></div></div>
        	
            <div class="current_wz mtmb20" style=" height:auto;"><strong>项目目录：</strong><span>${documentLocalhost }</span></div>
            <div class="tablebox2 wdang_s bgenglist">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" id="changeInfluence">
                    <thead>
                      <tr>
                        <td width="3%" height="50" align="center" bgcolor="#f5f6f6">序 号</td>
                        <td width="10%" align="center" bgcolor="#f5f6f6">工作产品</td>
                        <td width="8%" align="center" bgcolor="#f5f6f6">开始时间</td>
                        <td width="8%" align="center" bgcolor="#f5f6f6">完成时间</td>
                        <td width="7%" align="center" bgcolor="#f5f6f6">文档负责人</td>
                        <td width="6%" align="center" bgcolor="#f5f6f6">当前版本</td>
                        <td width="6%" align="center" bgcolor="#f5f6f6">变更状态</td>
                        <td width="11%" align="center" bgcolor="#f5f6f6">追踪关系详情</td>
                        <td width="9%" align="center" bgcolor="#f5f6f6">影响章节</td>
                        <td width="11%" align="center" bgcolor="#f5f6f6">变更章节</td>
                      </tr>
                  </thead>
                  <tbody>
                  
                  	<c:forEach var="doc" items="${documentList }" varStatus="index">
	                  	<tr id="${doc.documentId }" <c:if test="${(index.index+1) %2 == 0 }">bgcolor="#f1f3f6"</c:if> >
	                  		<td align="center">${index.index+1 }</td>
	                        <td align="center">${doc.documentName }</td>
	                        <td align="center">${doc.startTime }</td>
	                        <td align="center">${doc.endTime }</td>
	                        <td align="center">${doc.documentManagerName }</td>
	                        <td align="center">${doc.documentVersion }</td>
	                        <td align="center">
	                        	<c:if test="${doc.documentChangeStatus == '1' }">未变更</c:if> 
	                        	<c:if test="${doc.documentChangeStatus == '2' }">已变更</c:if> 
	                        	<c:if test="${doc.documentChangeStatus == '3' }">预发布</c:if> 
	                        	<c:if test="${doc.documentChangeStatus == '4' }">不变更</c:if> 
	                        	<c:if test="${doc.documentChangeStatus == '5' }">等待变更</c:if> 
	                        </td>
	                        <td align="center">${doc.traceDocumentName }</td>
	                        <td align="left">${doc.traceSectionNames }</td>
	                        <td align="left">${doc.changeSectioNames}</td>
	                  	</tr>
                  	</c:forEach>
                  </tbody>
                </table>
              </div>
            <iframe id="indexIframe" frameborder="0" class="mainIframe" style="width:100%; height:100%;" src="${_baseUrl}/ci/showChangeRequestNoteDetails?projectId=${projectId}&changeId=${changeId}"></iframe>
    </div>
	<div class="clear"></div>
</body>

<script type="text/javascript">   /* iframe高度自适应  */
	$(function(){
		$("#indexIframe").load(function () {
		    var mainheight = $(this).contents().find("body").height() + 30;
		    $(this).height(mainheight);
		});
		if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.split(';')[1].replace(/[ ]/g,"") == "MSIE8.0"){
			setIframeHeight("indexIframe");
		}
	})
	function setIframeHeight(id){
		try{
			var iframe = document.getElementById(id);
			if(iframe.Document){
				newHeight = iframe.Document.body.scrollHeight + 20 +"px";
			}else{
				newHeight = iframe.contentDocument.body.scrollHeight + 20 + "px";
			}
			iframe.style.height = newHeight;
			
		}catch(e){
			throw new Error("error");
		}
	}
	
</script>
</html>