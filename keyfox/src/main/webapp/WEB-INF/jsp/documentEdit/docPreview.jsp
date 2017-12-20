<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>文档预览</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<link type="text/css" rel="stylesheet" href="${_resources}css/zTreeStyle.css">
<link rel="stylesheet" href="${_resources}css/jquery.jscrollpane1.css" />

<script type="text/javascript">

	var documentId = "${documentId}";
	var projectId = "${projectId}";
	var templateId = "${templateId}";

	var ztree;
	var setting = {	
		view: {
			showLine: true,
			selectedMulti: false,
			addDiyDom: addDiyDom,
			dblClickExpand: false	
		},
		data: {
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "pId"
			}
		},
		callback: {
			onNodeCreated: this.onNodeCreated,				
			onClick:onClick			
		}
	};
	
	var zNodes = eval('(${zNodes})');
	
	$(document).ready(function(){
		ztree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
		
		ztree.expandNode(ztree.getNodeByParam("id","${nodeId}",null));//展开指定节点
		ztree.selectNode(ztree.getNodeByParam("id","${nodeId}",null));//选中指定节点
		ztree.setting.callback.onClick(null, ztree.setting.treeId, ztree.getNodeByParam("id","${nodeId}",null));//触发函数
	});
	
	function addDiyDom(treeId, treeNode) {
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_"+treeNode.level)
		aObj.addClass("le_"+treeNode.level)
	};
	
	function onClick(e,treeId, treeNode) {
		if(treeNode.name=="${documentName}"){
			var uri= treeNode.uri;
			if(uri!=null&&uri!=""){
				var path="${_baseUrl}"+treeNode.uri;
				var frame=	$("#rightIframe");
				$(frame).attr("src",path);
			}
		}else{//getSectionNoEditPage
			var path="${_baseUrl}/documentSectionController/getSectionNoEditPage?sectionId="+treeNode.id;
			var frame=	$("#rightIframe");
			$(frame).attr("src",path);
		}
	}
	
	function returnHistory(){
		window.location.href="${_baseUrl}/document/loadDocumentHistoryVersions?templateId="+templateId+"&projectId="+projectId+"&documentId="+documentId;
	}
	
</script>
</head>
<body>
	<div >
		<!-------左侧菜单------>
	    <div class="fl menu " style="top:0px;">
	        <div class="menu_tit">${documentName}</div>
	            <div class="list">
	                <div class="zTreeDemoBackground list_rolla1 left">
	                    <ul id="treeDemo" class="ztree ztreea"></ul>
	                </div>        
	            </div>
	    </div>
        <!-------中间内容------>
        	<div class=" fl" style=" margin-left:255px;width: 100%;height:100%;">
				       <a href="javascript:;" class="glqxian_btn1 " onclick="returnHistory();">返回上一级</a>
        	<iframe id="rightIframe" frameborder="0" style="width:100%; height:500px;" src=""></iframe>     
        </div>     
    	<div class="clear"></div>
    </div>
</body>
</html>