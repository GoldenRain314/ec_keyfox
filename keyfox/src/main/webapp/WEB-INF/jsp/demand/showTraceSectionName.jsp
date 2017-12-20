<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>选择展示追踪关系的章节</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${_resources}js/jquery.ztree.excheck.js"></script>
<link rel="stylesheet" href="${_resources}css/zTreeStyle_class.css" />
													
<script type="text/javascript">

/* 左侧菜单的章节ID */
var sectionId ;

var setting_r = {	
	view: {
		showLine: true,
		selectedMulti: false,
		addDiyDom: addDiyDom
	},
	check: {
		enable: true,
		chkStyle: "radio",
		radioType: "all"
		//chkboxType :{ "Y" : "", "N" : "" }
	},
	data: {
		simpleData: {
			enable: true
		}
	},
	callback: {
		onNodeCreated: this.onNodeCreated,				
		onClick: this.onClick
	}
};

//左侧菜单树
var zNodesLeft ;
//右侧菜单树
var zNodesRight;

$(function (){
	$("#close").click(function (){
		parent.closeWin();
	});
	
	$("#save").click(function (){
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
		var nodes = treeObj.getCheckedNodes(true); 
		var traceSectionIds = [];
		for(var i=0;i<nodes.length;i++){
			traceSectionIds.push(nodes[i].id);
		}
		if(traceSectionIds.length != 1){
			layer.msg("请选择一个章节");
		}else{
			parent.setTraceNameAndId(nodes[0].name,nodes[0].id);
			parent.closeWin();
			
		}
	});
})

$(document).ready(function(){
	$.ajax({
		url : "${_baseUrl}/documentSectionController/trackSectionTree",
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {
  			documentId : "${documentId}",
  			projectId:"${projectId}",
  			"left" : "saveTrack"	
  		},
		success : function(json) {
			zNodesLeft = eval('('+json.zNodes+')');
			$("#leftTree").html(json.documentName);
			$("#documentName").html(json.documentName);
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
	
	var zTree = $.fn.zTree.init($("#treeDemo"), setting_r, zNodesLeft);
	var nodes = zTree.transformToArray(zTree.getNodes());
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].isParent){
			if(i==0){
				nodes[i].nocheck=true;
			}
			zTree.updateNode(nodes[i]);
			zTree.expandNode(nodes[i]);
		}
		
		//if(nodes[i].name=="前言" ||  nodes[i].name.indexOf("附录-附图") > 0  || nodes[i].name.indexOf("附录-附表") > 0 || nodes[i].name.indexOf("附录-附件") > 0){
			//nodes[i].nocheck=true;
			//zTree.updateNode(nodes[i]);
		//}
		
	}
	replaceRefer();
	
});

function addDiyDom(treeId, treeNode) {
	var liObj = $("#" + treeNode.tId);
	var aObj = $("#" + treeNode.tId + "_span");
	liObj.addClass("level_"+treeNode.level)
	aObj.addClass("le_"+treeNode.level)
};

function  replaceRefer(){
	var ztree = $.fn.zTree.getZTreeObj("treeDemo");
	var	nodes =ztree.transformToArray(ztree.getNodes());
	for(var i=0;i<nodes.length;i++){
		var childNodes = nodes[i];//㊤㊥㊦㊧㊨㊐㊊
		var name = childNodes.name;
		var result = true;
		while(result){
			if(name.indexOf("▼▽㊤▲△")>0||name.indexOf("▼▽㊦▲△")>0||name.indexOf("▼▽㊧▲△")>0||name.indexOf("▼▽㊨▲△")>0||name.indexOf("▼▽㊐▲△")>0||name.indexOf("▼▽㊊▲△")>0){
				name = name.replace("▼▽㊤▲△","'");
				name = name.replace('▼▽㊦▲△','"');
				name = name.replace("▼▽㊧▲△","‘");
				name = name.replace('▼▽㊨▲△','’');
				name = name.replace('▼▽㊐▲△','“');
				name = name.replace('▼▽㊊▲△','”');
			}else{
				result = false;
			}
		}
		ztree.getNodeByParam("id",childNodes.id,null).name =name;
		ztree.updateNode(ztree.getNodeByParam("id",childNodes.id,null));
	}
}


</script>
<style>
	.ztreexqzz_c li span.button.switch{ left:0px;}   /* 需求追踪页面-选择章节弹框折叠控制按钮距离调整   */
</style>
<body>

<div class="mubanclass">
   	<div class="zTreeDemoBackground left">
       <ul id="treeDemo" class="ztree ztreexqzz_a ztreexqzz_c"></ul>
    </div>
    
    <div class="permission_an mubanclass_an ma mt20">
    	<a href="javascript:;" class="per_baocun" id="save">提 交</a>
        <a href="javascript:;" class="per_gbi" id="close">取 消</a>
    </div>
</div>


</body>

<script>
	window.onload = function(){
		initWidth();
	}
	var  resizeTimer = null;
	window.onresize = function(){
	    if(resizeTimer) clearTimeout(resizeTimer);
	    resizeTimer = setTimeout("initWidth()",100);
	 } 
	function initWidth(){
		var width = $("#treeDemo").width();
		$("#treeDemo li .le_5").css("max-width",width-160);  /* 需求追踪页面四级及五级目录树缺省显示调整 170511  */
		$("#treeDemo li .le_4").css("max-width",width-140);
		$("#treeDemo li .le_3").css("max-width",width-120);  // width(width-100);
		$("#treeDemo li .le_2").css("max-width",width-100);   
		$("#treeDemo li .le_1").css("max-width",width-80);
		$("#treeDemo .le_0").css("max-width",width-60);
	}
</script> 

</html>