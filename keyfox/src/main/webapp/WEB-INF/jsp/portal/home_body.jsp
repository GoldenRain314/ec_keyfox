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
		ztree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
		
		//ztree.expandNode(ztree.getNodeByParam("menuId","${needExpandNodeId}",null));//展开指定节点
		ztree.selectNode(ztree.getNodeByParam("menuId","${needExpandNodeId}",null));//选中指定节点
		ztree.setting.callback.onClick(null, ztree.setting.treeId, ztree.getNodeByParam("menuId","${needExpandNodeId}",null));//触发函数
		//var div = document.getElementById("rightIframe");
		//div.src ="${_baseUrl}/organizeassets/showOrganizeassetsIndex";
		
	});
	
	function addDiyDom(treeId, treeNode) {
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_"+treeNode.level)
		aObj.addClass("le_"+treeNode.level)
	};
	
	function onClick(e,treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		zTree.expandNode(treeNode);
		var div = document.getElementById("rightIframe");
		div.src ="${_baseUrl}"+treeNode.menuUrl+"?menuId="+treeNode.menuId;
	}
	
</script>
</head>
<body>
	<div class="ma main">
		<!-------左侧菜单------>
	    <div id="menu" class="fl menu">
	        <div class="menu_tit">${menuInfo.menuName }</div>
	            <div class="list">
	                <div id="list" class="zTreeDemoBackground list_rolla2 left">
	                    <ul id="treeDemo" class="ztree ztreexmgli"></ul>
	                </div>        
	            </div>
	    </div>
		
		<!-- 图标按钮开始  -->
		<div id="btn" class="btn fl">
			<div id="close" class="close" onclick="slipHidden();initWidth()"></div>
			<div id="open" class="open" onclick="slipShow();initWidth()" style="display:none;"></div>
			
		</div> 
		<!-- 图标按钮结束 -->
		
        <!-------中间内容------>
        <div id="iframeCont" class="iframe_yhgl">
        	<iframe id="rightIframe" frameborder="0" style="width:100%; height:100%;" src=""></iframe>     
        </div>     
    	<div class="clear"></div>
    </div>
</body>

<style>
	.btn { width:12px; height:980px; display:inline-block; background:#c8d3e2; position:absolute; left:251px; z-index:999; }
	.btn div { position:absolute; top:39%; text-align:905px; width:10px; height:118px; left:1px; vertical-align:center; line-height:905px;}
	.btn .open { background:url(${_resources}images/right.png) no-repeat;}
	.btn .close { background:url(${_resources}images/left.png) no-repeat;}
</style>

<script type="text/javascript">
	var  resizeTimer = null;
	window.onload = function(){
		initWidth();
		initHeight();
	}
	window.onresize = function(){
	    if(resizeTimer) clearTimeout(resizeTimer);
	    resizeTimer = setTimeout("initHeight();initWidth();",100);
	 }
	function initHeight(){
		var topH = 0; 
		if(navigator.userAgent.indexOf("MSIE")>0 || navigator.userAgent.indexOf("like Gecko")>0) {//IE浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Firefox")>0){//Firefox浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Opera")>0){//Opera浏览器
			initheight = document.body.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Chrome")>0){//Chrome谷歌浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Safari")>0){//Safari浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		$("#btn").css( "height",initheight );
		$("#list").css( "height",initheight -70 );
		
	}
	function initWidth(){
		var oMaBox = document.getElementById("menu");
		var topW = oMaBox.getBoundingClientRect().width; 
		
		if(navigator.userAgent.indexOf("MSIE")>0 || navigator.userAgent.indexOf("like Gecko")>0) {//IE浏览器
			topW = oMaBox.clientWidth;
			initwidth = document.documentElement.clientWidth-topW;
		}
		if(navigator.userAgent.indexOf("Firefox")>0){//Firefox浏览器
			initwidth = document.documentElement.clientWidth-topW;
		}
		if(navigator.userAgent.indexOf("Opera")>0){//Opera浏览器
			initwidth = document.body.clientWidth-topW;
		}
		if(navigator.userAgent.indexOf("Chrome")>0){//Chrome谷歌浏览器
			initwidth = document.documentElement.clientWidth-topW;
		}
		if(navigator.userAgent.indexOf("Safari")>0){//Safari浏览器
			initwidth = document.documentElement.clientWidth-topW;
		}
		$("#btn").css( {"position":"relative","left":topW});
		$("#iframeCont").css( {"width":initwidth-10,"position":"absolute","left":topW+10});
	}
	function slipHidden(){
		var oTop = document.getElementById("close");
		var oDown = document.getElementById("open");
		var oBox = document.getElementById("menu");
		var oBtn = document.getElementById("btn");
		oTop.style.display = "none";
		oDown.style.display = "block";
		oBox.style.display = "none";
		
	}
	function slipShow(){
		var oTop = document.getElementById("close");
		var oDown = document.getElementById("open");
		var oBox = document.getElementById("menu");
		var oBtn = document.getElementById("btn");
		oTop.style.display = "block";
		oDown.style.display = "none";
		oBox.style.display = "block";
		
	}
</script>

</html>