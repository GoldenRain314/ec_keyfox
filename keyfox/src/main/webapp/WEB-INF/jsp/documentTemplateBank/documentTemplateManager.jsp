<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>左侧菜单树</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<link type="text/css" rel="stylesheet" href="${_resources}css/zTreeStyle.css">
<link type="text/css" rel="stylesheet" href="${_resources}css/jquery.jscrollpane1.css">
<script type="text/javascript">
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
	
	var zNodes =[
	 			{ id:1, pId:0, name:"自定义文档模板",uri:"${_baseUrl}/documentTemplateController/showDefineDocumentTemplate"},
				{ id:2, pId:0, name:"标准文档模板",uri:"${_baseUrl}/documentTemplateController/showStandradDocumentTemplate"},
				{ id:3, pId:0, name:"样式文档模板",uri:"${_baseUrl}/styleTemplateController/styleTemplateAll"},
				{ id:4, pId:0, name:"项目模板类型定义",uri:"${_baseUrl}/projectTemplateTypeController/showAllProjectTemplate"}
			];
	
	$(document).ready(function(){
		ztree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
		
		ztree.expandNode(ztree.getNodeByParam("id","1",null));//展开指定节点
		ztree.selectNode(ztree.getNodeByParam("id","1",null));//选中指定节点
		ztree.setting.callback.onClick(null, ztree.setting.treeId, ztree.getNodeByParam("id","1",null));//触发函数
	});
	
	function addDiyDom(treeId, treeNode) {
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_"+treeNode.level)
		aObj.addClass("le_"+treeNode.level)
	};
	
	function onClick(e,treeId, treeNode) {
		var div = document.getElementById("rightIframe");
		div.src =treeNode.uri;
	}
	
</script>
</head>
<body>
	<div class="ma main">
		<!-------左侧菜单------>
	    <div class="menu fl">
	        <div class="menu_tit">文档模板管理</div>
	            <div class="list">
	                <div class="zTreeDemoBackground list_rolla2 left">
	                    <ul id="treeDemo" class="ztree ztreexmgli"></ul>
	                </div>        
	            </div>
	    </div>
		<div class="clear"></div>
        <!-------中间内容------>
        <div class="iframe_yhgl ">
        	<iframe id="rightIframe" frameborder="0" style="width:100%; height:100%;" src=""></iframe>     
        </div>     
    	<div class="clear"></div>
    </div>
</body>
</html>