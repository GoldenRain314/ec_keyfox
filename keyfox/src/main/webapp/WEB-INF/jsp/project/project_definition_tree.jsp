<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html style="overflow:hidden;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>左侧菜单树</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<link type="text/css" rel="stylesheet" href="${_resources}css/zTreeStyle.css">
<link type="text/css" rel="stylesheet" href="${_resources}css/jquery.jscrollpane1.css">

<style>
	.btn { width:12px; height:980px; display:inline-block; background:#c8d3e2; position:absolute; z-index:999; }
	.btn div { position:absolute; top:39%; text-align:905px; width:10px; height:118px; left:1px; vertical-align:center; line-height:905px;}
	.btn .open { background:url(${_resources}images/right.png) no-repeat;}
	.btn .close { background:url(${_resources}images/left.png) no-repeat;}
</style>

<script type="text/javascript">
	window.onload = function(){
		initWidth();
		initHeight();
	}
	window.onresize = function(){
		initWidth();
		initHeight();
	}
	function initHeight(){
		/* var oMaBox = document.getElementById("menu"); */
		var topH = 0; // oMaBox.getBoundingClientRect().height;  
		
		if(navigator.userAgent.indexOf("MSIE")>0 || navigator.userAgent.indexOf("like Gecko")>0) {//IE浏览器
			//topH = oMaBox.clientHeight; 
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
		$("#list").css("height",initheight - 70);
		
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

</head>
<body>
<div class="ma main" >
	<div id="menu" class="fl menu" >
	    <div class="menu_tit">项目管理</div>
	    <div class="list">
	    	<div id="list" class="zTreeDemoBackground list_rolla2 left">
	            <ul id="treeDemo" class="ztree ztreexmgli ztreexmgli2"></ul>
	        </div>
	    </div>
	</div>
	
	<!-- 图标按钮开始  -->
	<div id="btn" class="btn fl">
		<div id="close" class="close" onclick="slipHidden();initWidth()"></div>
		<div id="open" class="open" onclick="slipShow();initWidth()" style="display:none;"></div>
		
	</div> 
	<!-- 图标按钮结束 -->
	
	<div id="iframeCont" class="iframe_yhgl" style=" width:100%;">
		<iframe id="indexIframe" frameborder="0" style="width:100%; height:100%;" src=""></iframe>   
	</div>     
</div>    
</body>
<script type="text/javascript">
		var nodeId = "${nodeId}";
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
					idKey:"nodeId",
					pIdKey:"parentId"
				}
			},
			callback: {
				onNodeCreated: this.onNodeCreated,				
				onClick:onClick
/* 				onClick:onClick_s */
			}
		
		};
		var zNodes;
		$.ajax({ 
				url:'${_baseUrl}/project/selectall', 
				type:'post', //数据发送方式 
				dataType:'json', //接受数据格式 
				error:function(json){
					layer.msg( "not lived!");
					  },
				async: false,
				cache: false,
				success: function(data){
				   zNodes =  eval('('+data.json+')');
				   if(nodeId == ""){
					   nodeId = data.nodeId;
				   }
                }
		  });
		
		$(document).ready(function(){
			loadTree(nodeId);
		});
		
		function loadTree(nodeId){
			ztree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
			//ztree.expandNode(ztree.getNodeByParam("nodeId",nodeId,null));//展开指定节点
			ztree.selectNode(ztree.getNodeByParam("nodeId",nodeId,null));//选中指定节点
			ztree.setting.callback.onClick(null, ztree.setting.treeId, ztree.getNodeByParam("nodeId",nodeId,null));//触发函数
		}
		
		/* function onClick_s(e,treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			zTree.expandNode(treeNode);
		} */

		function addDiyDom(treeId, treeNode) {
			var liObj = $("#" + treeNode.tId);
			var aObj = $("#" + treeNode.tId + "_span");
			liObj.addClass("level_"+treeNode.level)
			aObj.addClass("le_"+treeNode.level)
		};
		function onClick(e,treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			zTree.expandNode(treeNode);
			var div = document.getElementById("indexIframe");
			var isOrSetDocument = false;
			$.ajax({
				url:'${_baseUrl}/project/selectProjectByNodeId', 
				type:'post', //数据发送方式 
				dataType:'text', //接受数据格式 
				data:{"nodeId":treeNode.nodeId},
				async: false,
				success: function(data){
					if(data == "false"){
						isOrSetDocument = true;
					}
	            },
				error:function(){
					layer.msg( "系统错误");
				}
			});
			if(isOrSetDocument==true){
				div.src ="${_baseUrl}/project/project_definition?nodeId="+treeNode.nodeId+"&directoryLevel="+treeNode.directoryLevel;
			}else{
				div.src ="${_baseUrl}/project/showProjectMessage?nodeId="+treeNode.nodeId;
			}
			
		}
		function refreshTree(){
			window.location.reload(true);
		}	
		function getTree(){
			var tree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
			return tree;
		}
	</script>
</html>
