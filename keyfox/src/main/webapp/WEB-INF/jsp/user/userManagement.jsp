<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登陆</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<link type="text/css" rel="stylesheet" href="${_resources}css/zTreeStyle.css">
<script type="text/javascript">
	var tree;
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
				idKey: "menuId",
				pIdKey: "parentId"
			}
		},
		callback: {
			onNodeCreated: this.onNodeCreated,				
			onClick:onClick			
		}
	};
	
	var zNodes = eval('(${menuList})');
	
	$(document).ready(function(){
		tree = 
			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
	});
	
	function addDiyDom(treeId, treeNode) {
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_"+treeNode.level)
		aObj.addClass("le_"+treeNode.level)
	};
	
	function onClick(e,treeId, treeNode) {
		var div = document.getElementById("rightIframe");
		div.src ="${_baseUrl}"+treeNode.menuUrl;
	}
	
</script>
</head>
<body>
	<div class="ma main">
		<!-------左侧菜单------>
	    <div class="fl menu">
	        <div class="menu_tit">${menuInfo.menuName }</div>
	            <div class="list">
	                <div class="zTreeDemoBackground left">
	                    <ul id="treeDemo" class="ztree"></ul>
	                </div>        
	            </div>
	    </div>
		
        <!-------中间内容------>
        <iframe id="rightIframe" frameborder="0" style="width:100%; height:100%;" class="iframe_yhgl" src=""></iframe>          
    	<div class="clear"></div>
    </div>
</body>
</html>