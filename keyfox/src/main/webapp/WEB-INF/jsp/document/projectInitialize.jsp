<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>构建项目</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript">
var id = "${id}";
var projectId = "${projectId}";
var type = "${type}";
$(function(){
	if("true" == "${NoBuild}"){
		layer.msg("项目还未构建完毕",{shift:5,time:1000},function(){
			 parent.skipModule("文档编写","");
		 });
	}
	
	if("${taskAssign}" != ''){
		click("taskAssign");
	}
	$("#projectMessage").click(function(){
		var frame=	$("#projectForming");
		$(frame).attr("src","${_baseUrl}/document/documentBaseinfo?id="+id+"&projectId="+projectId+"&type="+type+"&update=${update}");
	});
	$("#documentList").click(function(){
		var frame=	$("#projectForming");
		$(frame).attr("src","${_baseUrl}/document/documentList?projectId="+projectId+"&type="+type);
	});
	$("#taskAssign").click(function(){
		var frame=	$("#projectForming");
		$(frame).attr("src","${_baseUrl}/document/taskAssign?projectId="+projectId+"&type="+type);
	});
})
function click(id){
	$("#"+id).click();
}

</script>
</head>
<body>
	<div class="ma main">
    	<div class="wdang_main">
    		<!-- <div class="page_tit_warp mtmb20"><div class="page_tit"><span>项目构建</span></div></div> -->
        	<div class="xmugouj_tab">
                	<a href="javascript:;" id="projectMessage" class="xmugouj_tab_on">项目信息</a>
                    <a href="javascript:;" id="documentList">文档列表</a>
                    <a href="javascript:;" id="taskAssign">任务分配</a>   <!-- 删除样式 class="xmugouj_tab3" 缺少小三角图标 -->
            </div>
            <div class="wdang_cont" style="display:block;">
            	<c:choose>
	            	<c:when test="${taskAssign == '' or empty taskAssign}">
		            	<div class="iframe_aa1">
		            		<iframe name="projectForming" id="projectForming" style="width:100%; height:100%;" src="${_baseUrl}/document/documentBaseinfo?id=${id}&projectId=${projectId}&type=${type}&update=${update}" frameborder=0 ;scrolling="auto">
		            	</div>
	            	</c:when>
	            	<c:otherwise>
	            		<div class="iframe_aa1">
	            			<iframe name="projectForming" id="projectForming" style="width:100%; height:100%;" src="${_baseUrl}/document/taskAssign?projectId=${projectId}" frameborder=0 ;scrolling="auto">
	            		</div>
	            	</c:otherwise>
				</c:choose> 
	        </div>
        </div>
    </div>
</body>