<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>建立文档章节的追踪关系</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${_resources}js/jquery.ztree.excheck.js"></script>
<link rel="stylesheet" href="${_resources}css/zTreeStyle_class.css" />
<link rel="stylesheet" href="${_resources}css/jquery.jscrollpane1.css" />													
<script type="text/javascript">

var check0 =false;
var check1 =false;
var check2 =false;
var ruanjianshejishuomingFlag = true;

//设置取消单选框选中效果
function getCheckStatus(i){
	 if(i==0){
		 if(check0){
			 $("#"+i).prop("checked",false);
		 }
	 }
	 if(i==1){
		 if(check1){
			 $("#"+i).prop("checked",false);
		 }
	 }
	 if(i==2){
		 if(check2){
			 $("#"+i).prop("checked",false);
		 }
	 }
	 check0 = $("#0").prop("checked");
	 check1 = $("#1").prop("checked");
	 check2 = $("#2").prop("checked");
}

var left_sectionId = "";
if (!Array.prototype.indexOf)
{
  Array.prototype.indexOf = function(elt /*, from*/)
  {
    var len = this.length >>> 0;

    var from = Number(arguments[1]) || 0;
    from = (from < 0)
         ? Math.ceil(from)
         : Math.floor(from);
    if (from < 0)
      from += len;

    for (; from < len; from++)
    {
      if (from in this &&
          this[from] === elt)
        return from;
    }
    return -1;
  };
}

/* 左侧菜单的章节ID */
var sectionId = "";
var sectionName="";


var colour = new Array("red","blue","green");

var setting = {	
	view: {
		showLine: true,
		selectedMulti: false,
		addDiyDom: addDiyDom,
		fontCss: getFont, 
		nameIsHTML : true
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
		onClick: this.onClickLeft		
	}
};

var setting_r = {	
	view: {
		showLine: true,
		selectedMulti: false,
		addDiyDom: addDiyDom,
		fontCss: getFont, 
		nameIsHTML : true
	},
	check: {
		enable: true,
		chkboxType :{ "Y" : "", "N" : "" }
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
		onClick: this.onClickRight		
	}

};

//左侧菜单树
var zNodesLeft = "";
//右侧菜单树
var zNodesRight;

$(function (){

	$("#docLocation").html(subProjectName("${localhost }"));

	/* if("${trackDocumentId}" != ""){
		$("#documentList").val("${trackDocumentId}");
	}else if("${approveDocumentId}" != ""){
		$("#documentList").val("${approveDocumentId}");
	} */
	
     $("#save").mouseleave(function(){       /* 修改BUG 火狐浏览器字体颜色演示问题  */
		$("#save").css("color","#fff");
	});
	$("#cancel").mouseleave(function(){       /* 修改BUG 火狐浏览器字体颜色演示问题  */
		$("#cancel").css("color","#fff");
	});
	$("#goBack").mouseleave(function(){       /* 修改BUG 火狐浏览器字体颜色演示问题  */
		$("#goBack").css("color","#fff");
	});
	$("#save").click(function (){
		if(ruanjianshejishuomingFlag == false){
			layer.msg("请选择左侧章节");
			return false;
		}
		
		if("软件设计说明" == $("#documentList").find("option:selected").text() && "${documentId}" == $("#documentList").val() && "${b438}" == 'true'){
			var leftT = $.fn.zTree.getZTreeObj("treeDemo");
			var treeNode = leftT.getNodeByParam("id",sectionId);
			var style = getFont(treeNode.id,treeNode);
			if("red" != style.color && "#802A2A" != style.color){
				layer.msg("不允许建立追踪关系");
				return;
			}
		}
		
		//[#3500] 提示重复 选一即可
		//$('#showTraceSectionName').validationEngine('validate');
		
		var showTraceSectionId = $("#showTraceSectionId").val();
		
		var document_r = $("#documentList").val();
		if(document_r == ""){
			layer.msg("请选择要追踪的文档");
			return false;
		}
		
		if(showTraceSectionId == ""){
			layer.msg("请选择需求追踪列表存放章节");
			return false;
		}
		
		if(sectionId == ""){
			layer.msg("请选择左侧章节");
			return false;
		}
		if(sectionName!=""){
			if("前言" == sectionName || sectionName.indexOf("附录-附图") > 0  || sectionName.indexOf("附件") > 0 || sectionName.indexOf("附录-附表") > 0 || sectionName.indexOf("附录-附件") > 0){
				layer.msg(sectionName+"不能建立追踪关系");
				return false;
			}
		}
		
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
		var nodes = treeObj.getCheckedNodes(true); 
		var traceSectionIds = [];
		for(var i=0;i<nodes.length;i++){
			traceSectionIds.push(nodes[i].id);
		}
		
		if(traceSectionIds.length == 0){
			layer.msg("请选择右侧章节");
			return false;
		}
		
		$.ajax({
			url : "${_baseUrl}/dd/insertTraceTelation",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {
	  				documentId : "${documentId}",
	  				sectionId:sectionId,
	  				traceDocumentId:$("#documentList").val(),
	  				traceSectionIds:traceSectionIds.join(","),
	  				projectId:"${projectId}",
	  				showTraceSectionId:$("#showTraceSectionId").val(),
	  				traceRelation:$("input[name='traceRelation']:checked").val()
	  			},
			success : function(json) {
				layer.msg(json.message);
				//修改当前节点颜色为已创建追踪关系
				var leftTreeFor = $.fn.zTree.getZTreeObj("treeDemo");
				var nodeFor = leftTreeFor.getNodeByParam("id",sectionId,null);
				nodeFor.font={'color':'#802A2A'};
				for(var i=0;i<nodes.length;i++){
					nodes[i].font={'color':'#802A2A'};
					treeObj.updateNode(nodes[i]);
				}
				//alert(nodes.font.color);
				leftTreeFor.updateNode(nodeFor);
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	});
	$("#cancel").click(function (){
		$('#showTraceSectionName').validationEngine('validate');
		
		var showTraceSectionId = $("#showTraceSectionId").val();
		
		var document_r = $("#documentList").val();
		if(document_r == ""){
			layer.msg("请选择要追踪的文档");
			return false;
		}
		
		if(showTraceSectionId == ""){
			layer.msg("请选择需求追踪列表存放章节");
			return false;
		}
		
		if(sectionId == ""){
			layer.msg("请选择左侧章节");
			return false;
		}
		
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
		var nodes = treeObj.getCheckedNodes(true); 
		var traceSectionIds = [];
		for(var i=0;i<nodes.length;i++){
			traceSectionIds.push(nodes[i].id);
		}
		
		if(traceSectionIds.length == 0){
			layer.msg("请选择右侧章节");
			return false;
		}
		
		$.ajax({
			url : "${_baseUrl}/dd/deleteTraceTelation",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {
	  				documentId : "${documentId}",
	  				sectionId:sectionId,
	  				traceDocumentId:$("#documentList").val(),
	  				traceSectionIds:traceSectionIds.join(","),
	  				projectId:"${projectId}",
	  				showTraceSectionId:$("#showTraceSectionId").val(),
	  				traceRelation:$("input[name='traceRelation']:checked").val()
	  			},
			success : function(data) {
				//window.location.href = "${_baseUrl}/dd/showTraceRelation?projectId=${projectId}&documentId=${documentId}";
				layer.msg(data.message);
				initRightTree();
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	});
});

$(document).ready(function(){
	$("#showTraceSectionName").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomRight',//提示信息的位置
		inlineValidation: true,//是否即时验证，false为提交表单时验证,默认true  
		failure : function() {
		    layer.message("验证失败，请检查");
			return false;  
		},//验证失败时调用的函数
		ajaxFormValidation: true,//开始AJAX验证
		success : function() {
		//	$("#addForm").submit();
		}//验证通过时调用的函数 
		//onAjaxFormComplete: ajaxValidationCallback
	});
	
	//加载左侧菜单
	initLeftTree();
	//初始化左侧菜单树
	var leftTree = $.fn.zTree.init($("#treeDemo"), setting, zNodesLeft);
	var nodes = leftTree.transformToArray(leftTree.getNodes());
	for(var i=0;i<nodes.length;i++){
		$("#treeDemo_"+i+"_switch").click(function(){    /* 初始化二三级目录树  170512  */
			initWidth();
		});
		if(nodes[i].level < 3){   
			leftTree.expandNode(nodes[i]);
		}
		
	}
	replaceRefer();
	//默认加载右侧数据
	$("#documentList").change();
});

function addDiyDom(treeId, treeNode) {
	var liObj = $("#" + treeNode.tId);
	var aObj = $("#" + treeNode.tId + "_span");
	liObj.addClass("level_"+treeNode.level);
	aObj.addClass("le_"+treeNode.level);
};

function onClickLeft(e,treeId, treeNode){
	sectionName=treeNode.name;
	left_sectionId = treeNode.id;
	sectionId = treeNode.id;
	
	if("前言" == treeNode.name || treeNode.name.indexOf("附录-附图") > 0  ||  treeNode.name.indexOf("附件") > 0  ||treeNode.name.indexOf("附录-附表") > 0  || treeNode.name.indexOf("附录-附件") > 0){	
		hideCheck();
		layer.msg( treeNode.name+"不允许建立追踪关系");
		return;
	}
	
	if("软件设计说明" == $("#documentList").find("option:selected").text() && "${documentId}" == $("#documentList").val() && "${b438}" == 'true'){
		var style = getFont(treeId,treeNode);
		if("red" != style.color && "#802A2A" != style.color){
			layer.msg("不允许建立追踪关系");
			ruanjianshejishuomingFlag = false;
			return;
		}else{
			ruanjianshejishuomingFlag = true;
		}
	}
	
	
	//1、初始化右侧的树
	initRightTree();
	
	// 右侧树宽度自适应
	var width = $("#xiugaixq_list_c").width();
	$("#treeDemo_r li .le_5").css("max-width",width-170);   /* 需求追踪页面四级及五级目录树缺省显示调整   */
	$("#treeDemo_r li .le_4").css("max-width",width-150);
	$("#treeDemo_r li .le_3").css("max-width",width-130);
	$("#treeDemo_r li .le_2").css("max-width",width-110);
	$("#treeDemo_r li .le_1").css("max-width",width-90);
	$("#treeDemo_r li .le_0").css("max-width",width-70);
	
	$("input[type='radio']:checked").removeAttr("checked");
	$.ajax({
		url:'${_baseUrl}/dd/selectSectionContentBySectionId?rand='+Math.random(), 
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		data:{"sectionId":treeNode.id},
		async: false,
		success: function(data){
			$("#left_content").html(data.content);
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
}
function onClickRight(e,treeId, treeNode){
	$("input[type='radio']:checked").removeAttr("checked");
	$.ajax({
		url:'${_baseUrl}/dd/selectSectionContentBySectionId?rand='+Math.random(), 
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		data:{"sectionId":treeNode.id,"left_sectionId":left_sectionId},
		async: false,
		success: function(data){
			$("#right_content").html(data.content);
			//$("input[type=radio][name='traceRelation'][value="+data.traceRelation+"]").attr("checked",'checked');
			var radios = document.getElementsByName("traceRelation");
			for(var i=0;i<radios.length;i++){
				if(radios[i].value == data.traceRelation){
					radios[i].checked = true;
				}
			}
			var  showTraceSectionName = $("#showTraceSectionName").val();
			if(!( showTraceSectionName.indexOf("可追踪性")>0 && showTraceSectionName.indexOf("需求")>=0 )){
				$("#showTraceSectionName").val(data.showSection);
				$("#showTraceSectionId").val(data.showSectionId);
			}
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
}
function hideCheck(){
	var document_r = $("#documentList").val();
	$.ajax({
		url : "${_baseUrl}/documentSectionController/trackSectionTree?rand="+Math.random(),
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {documentId : document_r,projectId:"${projectId}",documentId_left:"${documentId}"},
		success : function(json) {
			zNodesRight = eval('('+json.zNodes+')');
			var rTree = $.fn.zTree.init($("#treeDemo_r"), setting_r, zNodesRight);
			var nodes = rTree.transformToArray(rTree.getNodes());
			for(var i=0;i<nodes.length;i++){
				nodes[i].nocheck=true;
				rTree.expandNode(nodes[i]);
				rTree.updateNode(nodes[i]);
				
			}
			
			replaceReferR();
			
			$("#rightTree").html(json.documentName+json.documentVersion);
			if(json.relation == '0'){
				$("#relation").html("直接关联");
			}else if(json.relation == '1'){
				$("#relation").html("间接关联");
			}else{
				$("#relation").html("");
			}
			if("" == json.version_right || null == json.version_right || undefined == json.version_right){
				$("#version_right").html("暂未发布");
			}else{
				$("#version_right").html(json.version_right);
			}
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
	
}
/* 加载右侧的树    并初始化追踪关系 */
function initRightTree(){
	
	ruanjianshejishuomingFlag = true;
	
	//sectionId = "";
	var document_r = $("#documentList").val();
	if(document_r == ""){
		layer.msg("请选择要追踪的文档");
		return false;
	}
	
	/* if(document_r == "${documentId}"){
		layer.msg("同一份文档不能建立追踪关系");
		return false;
	} */
	
	var isEditShowTrace = "";
	$.ajax({
		url : "${_baseUrl}/documentSectionController/trackSectionTree?rand="+Math.random(),
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {documentId : document_r,projectId:"${projectId}",documentId_left:"${documentId}"},
		success : function(json) {
			zNodesRight = eval('('+json.zNodes+')');
			isEditShowTrace = json.isEditShowTrace;
			var rTree = $.fn.zTree.init($("#treeDemo_r"), setting_r, zNodesRight);
			var nodes = rTree.transformToArray(rTree.getNodes());
			for(var i=0;i<nodes.length;i++){
				$("#treeDemo_r_"+i+"_switch").click(function(){    /* 初始化二三级目录树  */
					initWidth();
				});
				
				if(nodes[i].level < 3){
					rTree.expandNode(nodes[i]);
				}
				
				/*一级目录不能建立追踪关系  */
				if(nodes[i].level == 0){
					nodes[i].nocheck=true;
					rTree.updateNode(nodes[i]);
				}
				
				/* 前言 附录 不能建立追踪关系 */
				
				if(nodes[i].name=="前言" ||  nodes[i].name.indexOf("附录-附图") > 0  || nodes[i].name.indexOf("附录-附表") > 0 || nodes[i].name.indexOf("附录-附件") > 0){
					nodes[i].nocheck=true;
					rTree.updateNode(nodes[i]);
				}
				
				
				/* 自己不能与自己建立追踪关系 */
				if(nodes[i].id == sectionId){
					nodes[i].nocheck=true;
					rTree.updateNode(nodes[i]);
				}
			}
			
			replaceReferR();
			
			$("#rightTree").html(json.documentName+json.documentVersion);
			if(json.relation == '0'){
				$("#relation").html("直接关联");
			}else if(json.relation == '1'){
				$("#relation").html("间接关联");
			}else{
				$("#relation").html("");
			}
			if("" == json.version_right || null == json.version_right || undefined == json.version_right){
				$("#version_right").html("暂未发布");
			}else{
				$("#version_right").html(json.version_right);
			}
			
			
			if(json.showTraceName != undefined){
				var secName = json.showTraceName;
				var secId = json.showTraceId;
				if(secName.length != 0){
					$("#showTraceSectionName").val(secName);
					$("#showTraceSectionId").val(secId);
					$("#showTraceSectionName").attr("disabled",true);
				}
			}
			
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
	
	//将树节点颜色修改成默认
	var leftTreeDefaultFont = $.fn.zTree.getZTreeObj("treeDemo");
	//左侧树节点
	var leftTreenodes = leftTreeDefaultFont.transformToArray(leftTreeDefaultFont.getNodes());
	for(var ll = 0;ll<leftTreenodes.length;ll++){
		var node = leftTreenodes[ll];
		node.font={'color':''};
		leftTreeDefaultFont.updateNode(node);
	}
	
	
	//根据文档ID 追踪的文档ID  项目ID 获取追踪关系,并选中
	$.ajax({
		url : "${_baseUrl}/dd/getDocumentTraceList?checked=checked&rand="+Math.random(),
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {
  			documentId : "${documentId}",
  			projectId:"${projectId}",
  			traceDocumentId:$("#documentList").val(),
  			sectionId:sectionId
  		},
		success : function(json) {
			var jsonObj = eval('('+json.json+')');
			var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
			var treeObjleft = $.fn.zTree.getZTreeObj("treeDemo");
			//$("input[type=radio][name='traceRelation'][value="+json.traceRelation+"]").attr("checked",'checked')
			//已建立追踪关系的章节颜色
			var sId = json.sId;
			if(sId != undefined){
				var sIds = sId.split(",");
				for(var i=0;i<sIds.length;i++){
					var nodeForColor = treeObjleft.getNodeByParam("id",sIds[i],null);
					if(nodeForColor != undefined){
						nodeForColor.font={'color':'#802A2A'};
						treeObjleft.updateNode(nodeForColor);
					}
				}
			}
			if(jsonObj != undefined){
				for(var i=0;i<jsonObj.length;i++){
					//选中 并展开
					var node = treeObj.getNodeByParam("id",jsonObj[i].traceSectionId,null);
					//选中
					treeObj.checkNode(node, true, true);
					node.font={'color':'#802A2A'};
					treeObj.updateNode(node);
					//展开
					treeObj.expandNode(node);//展开指定节点
					treeObj.selectNode(node);//选中指定节点
				}
			}
			
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
	
	//438b 固定追踪关系上色
	initColour();
	
	//设置显示追踪章节名称
	initshowTraceSectionValue(isEditShowTrace);
	
}

/* 选择追踪关系保存的章节ID */
function showTraceSectionName(){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'选择章节',
		autoOpen: true,
		modal: true,	
		position : 'top',
		height: 400,      /* 弹框大小修改  */
		width: 600
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/dd/showTraceSectionName?projectId=${projectId}&documentId=${documentId}");
}

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

//treeDemo_r
function  replaceReferR(){
	var ztree = $.fn.zTree.getZTreeObj("treeDemo_r");
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


/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function setTraceNameAndId(name,id){
	$("#showTraceSectionName").val(name);
	$("#showTraceSectionId").val(id);
}

function getFont(treeId, node) {  
    return node.font ? node.font : {};  
} 

function initshowTraceSectionValue(isEditShowTrace){
	$.ajax({
		url : "${_baseUrl}/dd/getShowDocumentTraceSectionId?rand="+Math.random(),
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {documentId : "${documentId}",projectId:"${projectId}",traceDocumentId:$("#documentList").val()},
		success : function(json) {
			//加载需求追踪列表添加的章节
			var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
			var node = treeObj.getNodeByParam("id",json.message,null);
			if(node != undefined){
				$("#showTraceSectionId").val(node.id);
				$("#showTraceSectionName").val(node.name);
			}
			// 438B的处理方式
			if("true" == "${b438}"){
				if("${defaultTraceDocumentId}" == null || "${defaultTraceDocumentId}" == ""){
					$("#showTraceSectionName").attr("disabled",false);
				}else if("${defaultTraceDocumentId}" == $("#documentList").val()){
					if(isEditShowTrace == "" || isEditShowTrace == undefined){
						$("#showTraceSectionName").attr("disabled",false);
					}else{
						$("#showTraceSectionName").attr("disabled",true);
					}
				}else{
					if("软件设计说明" == $("#documentList").find("option:selected").text() && "${documentId}" == $("#documentList").val() && "${b438}" == 'true'){
						$("#showTraceSectionName").attr("disabled",true);
					}else{
						$("#showTraceSectionName").attr("disabled",false);
					}
				}
			}
			changeColor();
		},
		error:function(data){
			
			layer.msg("网络忙，请稍后重试");
		}
	});
	
}
/* 改变需求追踪列表添加字体颜色  */
function changeColor(){
	if($("#showTraceSectionName").attr("disabled") == false || $("#showTraceSectionName").attr("disabled") == undefined){
		$("#showTraceSectionName").css({"border":"1px solid #DCDCDC","color":"black"});
	}else{
		$("#showTraceSectionName").css({"border":"1px solid #DCDCDC","color":"gray"}); 
	}
}
function initLeftTree(){
	$.ajax({
		url : "${_baseUrl}/documentSectionController/trackSectionTree",
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {documentId : "${documentId}",projectId:"${projectId}",left : "left"},
		success : function(json) {
			zNodesLeft = eval('('+json.zNodes+')');
			$("#leftTree").html(json.documentName+json.documentVersion);
			$("#leftTree").attr("title",json.documentName+json.documentVersion);   /* 添加title属性标签   */
			$("#leftTree").css({"overflow":"hidden","text-overflow":"ellipsis","white-space":"nowrap","padding":"0 20px 0 10px"});   /* 添加title属性标签   */
			$("#documentName").html(json.documentName);
			$("#documentName").attr("title",json.documentName);  /* 添加title标签 属性   */
			$("#version").html(json.documentVersion.substring(2,json.documentVersion.length-1));
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
}



function initColour(){
	if("true" == "${b438}"){
		//438B 加载固定追踪关系,修改字体颜色
		$.ajax({
			url : "${_baseUrl}/dd/get438BTraceFixed",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {
	  				documentId : "${documentId}",
	  				traceDocumentId:$("#documentList").val(),
	  				projectId:"${projectId}"
	  			},
			success : function(json) {
				var traceJson = eval('('+json.traceString+')');
				//显示追踪关系的章节
				var showTraceSectionName = json.showTraceSection;
				
				if(showTraceSectionName != undefined)
					showTraceSectionName = showTraceSectionName.replace(/\s/ig,'');
				
				for(var i=0;i<traceJson.length;i++){
					//追踪的章节号
					var sectionNumber = traceJson[i].sectionNumber;
					
					var leftTree = $.fn.zTree.getZTreeObj("treeDemo");
					//左侧树节点
					var nodes = leftTree.transformToArray(leftTree.getNodes()); 
					
					/* 展示需求追踪关系的章节 */
					/* for(var lt=0;lt=nodes.length;lt++){ */
					for(var lt in nodes){
						var node = nodes[lt];
						if(node != undefined){
							var nodeName = node.name;
							if(nodeName == showTraceSectionName){
								$("#showTraceSectionId").val(node.id);
								$("#showTraceSectionName").val(nodeName);
							}
						}
					}
					
					//给左侧树上色
					initLeftTreeColor(sectionNumber);
					//右侧树上色
					initRightTreeColor(traceJson[i].traceSectionNumber);
				}
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	}
}

/* 初始化左侧菜单颜色 */
function initLeftTreeColor(sectionNumber){
	
	var leftTree = $.fn.zTree.getZTreeObj("treeDemo");
	//左侧树节点
	var nodes = leftTree.transformToArray(leftTree.getNodes()); 
	
	var sectionNumberList = sectionNumber.split(";");
	for(var l =0;l<sectionNumberList.length;l++){
		var sectionNumberOne = sectionNumberList[l].split(",");
		for(var ll=0;ll<sectionNumberOne.length;ll++){
			//需要所有子节点追踪的章节
			var indexof = sectionNumberOne[ll].indexOf(".X");
			
			var traceSectionNumbers = "";
			
			if(indexof > 0)
				traceSectionNumbers = sectionNumberOne[ll].substring(0,indexof+1);
			//左侧
			for(var lt in nodes){
				var node = nodes[lt];
				var sectionNumber = node.sectionNumber;
				var nodeName = node.name;
				if(traceSectionNumbers == ""){
					if(sectionNumber != undefined){
						sectionNumber = sectionNumber.replace(/\s/ig,'');
						if(sectionNumber == sectionNumberOne[ll]){
							node.font={'color':colour[l]};
							leftTree.updateNode(node);
						}
					}
				}else{
					if(nodeName != undefined){
						if(nodeName.indexOf(traceSectionNumbers) == 0){
							node.font={'color':colour[l]};
							leftTree.updateNode(node);
						}
					}
				}
				
			}
		}
	}
	var divs =$("div.jspPane");
  	$.each(divs, function (i, item) {
  		$(item).css("left","0px");
  	});
}

//右侧
function initRightTreeColor(traceSectionNumber){
	var rightTreeR = $.fn.zTree.getZTreeObj("treeDemo_r"); //获取树
	var rightNodes = rightTreeR.transformToArray(rightTreeR.getNodes());
	var traceSectionNumberList = traceSectionNumber.split(";");
	
	for(var l=0;l<traceSectionNumberList.length;l++){
		var traceSectionNumberOne = traceSectionNumberList[l].split(",");
		for(var ll=0;ll<traceSectionNumberOne.length;ll++){
			//需要所有子节点追踪的章节
			var indexofTrace = traceSectionNumberOne[ll].indexOf(".X");
			
			var rightTraceSectionNumbers = "";
			
			if(indexofTrace > 0){
				rightTraceSectionNumbers = traceSectionNumberOne[ll].substring(0,indexofTrace+1);
			}
			
			for(var lr in rightNodes){
				var node = rightNodes[lr];
				var sectionNumber = node.sectionNumber;
				var nodeName = node.name;
				
				if(rightTraceSectionNumbers == ""){
					if(sectionNumber != undefined){
						sectionNumber = sectionNumber.replace(/\s/ig,'');
						var sec = traceSectionNumberOne[ll].replace(/\s/ig,'');
						if(sectionNumber == sec){
							node.font={'color':colour[l]};
							rightTreeR.updateNode(node);
						}
					}
				}else{
					if(nodeName != undefined){
						if(nodeName.indexOf(rightTraceSectionNumbers) == 0){
							node.font={'color':colour[l]};
							rightTreeR.updateNode(node);
						}
					}
				}
				
				if("软件设计说明" == $("#documentList").find("option:selected").text() && "${documentId}" == $("#documentList").val()){
					var style = getFont(node.id,node);
					if("red" == style.color){
						rightNodes[lr].chkDisabled =false;
						rightTreeR.updateNode(rightNodes[lr]);
					}else{
						rightNodes[lr].chkDisabled = true;
						rightTreeR.updateNode(rightNodes[lr]);
					}
				}
			}
		}
	}
	var divs =$("div.jspPane");
  	$.each(divs, function (i, item) {
  		$(item).css("left","0px");
  	});
}
function returnHistory(){
	
	var random = Math.random();
	var referrer = document.referrer;
	if(referrer.indexOf("/dd/showDemandDocumentList") > 0){
		history.go(-1);
	}else{
		parent.skipModule("文档编写","${_baseUrl}/documentSectionController/sectionTree?projectId=${projectId}&documentId=${documentId}&status=${status}&isOk=${isOk}&random="+random);
	}
}

function showHistoryDemandTraceTable(documentId,projectId){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'查看追踪关系',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 950
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/dd/showHistoryTraceDetailed?documentId="+documentId+"&projectId="+projectId);
}
function zhennixiang(documentId,projectId){
	var documentVersion=document.getElementById("version");
	var trackDocumentId=  $("#documentList option:selected").val();
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:"正逆向追踪关系",
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 950
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/dd/requirementPositiveAndAgainstTable?documentId="+documentId+"&projectId="+projectId+"&documentVersion="+documentVersion+"&trackDocumentId="+trackDocumentId);
}

function setLeft(){
	var divs =$("div.jspPane");
 	$.each(divs, function (i, item) {
 		$(item).css("left","0px");
 	});
}

/* 项目名称缺省显示 */
function subProjectName(name){
	if(name.length > 35){
		name = name.substring(0,35);
		name += "...";
	}
	return name;
}

</script>

<body>
    <div class="document_main" style="overflow-y:hidden; overflow-x:auto;">
    	<!-- <div class="page_tit_warp mtmb20"><div class="page_tit"><span>修改需求追踪</span></div></div> -->
        <div class="xiugaixq_cont" >   <!-- style=" width:1100px; margin:0 auto;" -->
        <div class="xiugaixq_box" style=" width:100%; ">
        <div>
         <p style=" margin:0; height:30px;"><strong style="color:#666;float: left;">项目文档位置&nbsp;：</strong><span id="docLocation" title="${localhost }">${localhost }</span>    <!-- 内容显示过长时缺省显示 35字符   -->
         	<c:if test="${b438 == 'true' || dzz712 == 'true'}">
	         	<c:if test="${defaultTraceDocumentId != ''}">
		         	<button type="button" style=" border-radius: 4px; margin-right:12px; height:30px; line-height:27px; float: right; font-family: Microsoft Yahei,Arial; border: 1px solid #017fed; background: #0080ed; transition: all 0.3s; color: #fff; background-color:#38f;" onclick="zhennixiang('${documentId }','${projectId}')" >需求正逆向追踪表</button>
	         	</c:if>
         	</c:if>
         </p>        
         </div>
        <div class="fl xmugonj_curr xuqiuzz_curr" style=" width:50%;">     	
            <p style="margin-top: 2px;"><strong style=" float:left;">文&nbsp;&nbsp;档&nbsp;&nbsp;&nbsp;名&nbsp;&nbsp;称&nbsp;：</strong><span  id="documentName" style=" display:block; float:left; width:150px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; "></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>当前最新版本&nbsp;：</strong><span id="version"></span></p>
            <p><strong>文档关联关系&nbsp;：</strong><span id="relation"></span></p>
            <p><strong>需求追踪历史记录：</strong><a href="javascript:;" onclick="showHistoryDemandTraceTable('${documentId }','${projectId}')">查看</a>               </p>          
        </div>
        <%-- <div class="xiugaixq_t1">
        	<strong>${documentInfo.templateName }</strong>当前最新版本:${documentInfo.documentVersion }<br>
            系统自动建立的内容复用和章节间的追踪关系，请关联具体明细章节的追踪关系。
        </div> --%>
        <div class="fl xmugonj_bz xiugaixq_bz2" style=" top: 10px;margin-top: 0px; height:20px;">
            <dl>
                <dt style="line-height: 20px;">前项文档名称&nbsp;：</dt>
                <dd style=" padding-top:0;">
                    <select class="xmugonj_select" id="documentList" onchange="initRightTree()">
                    	<c:forEach items="${documentLists }" var="doc">
                    		<c:if test="${defaultTraceDocumentId == '' }">
	                    		<option value="${doc.id }" title="${doc.templateName }"  <c:if test="${trackDocumentId == doc.id }">selected="selected"</c:if> >${doc.templateName }</option>
                    		</c:if>
                    		<c:if test="${defaultTraceDocumentId != '' }">
	                    		<option value="${doc.id }" title="${doc.templateName }"  <c:if test="${defaultTraceDocumentId == doc.id }">selected="selected"</c:if> >${doc.templateName }</option>
                    		</c:if>
                    	</c:forEach>
                    </select>
                </dd>
                <dt style="margin-left:10px; line-height: 20px;"><strong>当前最新版本</strong>&nbsp;：</dt>
                <dd style="width:60px; padding-top:0;">
                    <span id="version_right"></span>
                </dd>
                <div class="clear"></div>
            </dl>         
        </div>           	 
        	<div class="clear"></div>
      
        </div>
        
        <div class="xiugaixq_list_cont" style=" width:100%; ">
            <div class="fl xiugaixq_list" style=" width:24%; margin-right:0.5%;">
                <div class="xiugaixq_list_tit"><span id="leftTree"></span></div>
                <div id="xiugaixq_list_c" class="xiugaixq_list_c">
                    <div class="zTreeDemoBackground treedemo_xqzz1 left">
                        <ul id="treeDemo" class="ztree ztreexqzz_a"></ul>
                    </div>
                </div>
            </div>
            
            <div class="fl xiugaixq_list xiugaixq_list3" style=" width:24.8%; margin-right:0.5%; ">
            	<div class="xiugaixq_text">
            		<div id="left_content" class="xiugaixq_texta"></div>
            	</div>
           	</div>
            <hr class="fl" size="1"  style="border: 1px dashed #ccc; height: 500px;">
            <div class="fl xiugaixq_list" id="rightTreeContent" onmouseover="setLeft();" onmousedown="setLeft();" onmouseout="setLeft();" onmousewheel="setLeft();" onmouseenter="setLeft();" onmousemove="setLeft();" onmouseup="setLeft();" onmouseleave="setLeft();"  style="margin-left: 0.5%; margin-right:0.5%;  width:24%; ">
                <div class="xiugaixq_list_tit" style="left: 0px;"><span id="rightTree"></span></div>
                <div id="xiugaixq_list_c" class="xiugaixq_list_c"  style="left: 0px;">
                    <div class="zTreeDemoBackground treedemo_xqzz2 left">
                        <ul id="treeDemo_r" class="ztree ztreexqzz_a ztreexqzz_b" style="margin-left: 5px;left: 0px;"></ul>
                    </div>
                </div>
            </div>
            <div class="fl xiugaixq_list xiugaixq_list2 xiugaixq_list3" style=" width:24%; ">          	
            	<div class="xiugaixq_text2">
            		<div id="right_content" class="xiugaixq_texta"></div>
            	</div>
            	
           	</div>
            <div class="clear"></div>
        </div>
         <div class="xmugonj_bz xiugaixq_input_t" style=" width:100%; ">
            <dl>
                <dt style="float:none;">内容追踪类型&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;color:#C6C6C6; " >建议填写，以确保变更影响域分析的全面性和准确性</span></dt>
                <dd style="float:none; width:280px; margin-left:0; padding-top:10px;">
                    <input name="traceRelation" id="0"  type="radio" onclick="getCheckStatus(0);"  value="0" style="padding:0; width:auto; margin-right:10px; margin-top:0;" />强关联<!--  &nbsp;&nbsp;&nbsp;&nbsp;<span>业务级文档内容显性关联，如内容变更必然导致关联内容的修改</span> -->
                    <input name="traceRelation" id="1" type="radio" onclick="getCheckStatus(1);"  value="1" style="padding:0; width:auto; margin-right:10px; margin-top:0;" />弱关联<!-- &nbsp;&nbsp;&nbsp;&nbsp;<span>业务级文档内容隐性关联，如内容变更可能或不导致关联内容的修改</span> -->
                    <input name="traceRelation" id="2" type="radio" onclick="getCheckStatus(2);"  value="2" style="padding:0; width:auto; margin-right:10px; margin-top:0;" />内容引用<!-- &nbsp;&nbsp;&nbsp;<span>文字级的复制或引用，无业务的关联性</span> -->
                </dd>
                <div class="clear"></div>
            </dl>
        </div>
        <div class="xmugonj_bz xiugaixq_input_t" style=" width:100%; ">
            <dl>
                <dt>需求追踪列表添加位置</dt>   <!-- 更名为：“需求追踪列表添加位置”_170603 -->
                <dd>
                    <input name="showTraceSectionName" type="text" id="showTraceSectionName" class="validate[required] input_text" readonly="readonly" onclick="showTraceSectionName()" >
                    <input type="hidden" id="showTraceSectionId" name="showTraceSectionId" value="" />
                </dd>
                <div class="clear"></div>
            </dl>
        </div>
        
        <div class="permission_an xiugaixq_anw mt30" style=" width:100%; ">
        	<shiro:hasPermission name="dd:insertTraceTelation">
		        <a href="javascript:;" class="per_baocun" id="save">建立关联</a>
		    </shiro:hasPermission>
		    <shiro:hasPermission name="dd:deleteTraceTelation">
		   		<a href="javascript:;" class="per_baocun" id="cancel">取消关联</a>
		    </shiro:hasPermission>
		    <shiro:hasPermission name="dd:returnDocumentDemand">
		        <a href="javascript:returnHistory();" class="per_gbi" id="goBack" >返回</a>
		    </shiro:hasPermission>
        </div>
        </div>
    </div>
    <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="0"></iframe>
	</div>
</body>

<!-- 表格宽度自适应 -->
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
		var width = $("#xiugaixq_list_c").width();
		$("#treeDemo_1 li .le_5").css("max-width",width-160);  /* 需求追踪页面四级及五级目录树缺省显示调整 170511  */
		$("#treeDemo_1 li .le_4").css("max-width",width-140);
		$("#treeDemo_1 li .le_3").css("max-width",width-120);  // width(width-100);
		$("#treeDemo_1 li .le_2").css("max-width",width-100);   
		$("#treeDemo_1 li .le_1").css("max-width",width-80);
		$("#treeDemo_1 .le_0").css("max-width",width-60);
		
		$("#treeDemo_r li .le_5").css("max-width",width-170);
		$("#treeDemo_r li .le_4").css("max-width",width-150);
		$("#treeDemo_r li .le_3").css("max-width",width-130);
		$("#treeDemo_r li .le_2").css("max-width",width-110);
		$("#treeDemo_r li .le_1").css("max-width",width-90);
		$("#treeDemo_r li .le_0").css("max-width",width-70);
	}
</script> 
<style>
	.xiugaixq_cont { width:80%; margin:0 auto; padding:20px 0 0 0;}
	.ztreexqzz_a li .le_4 { max-width:200px;}
	.ztreexqzz_a li .le_5 { max-width:250px;}
	table { table-layout:fixed; width:336px; max-width:336px; }    /* 设置预览内表格不随浏览器宽度而变化   */
	td { word-break:break-all; width:40px;}
	@media screen and (max-width: 1366px) {    
   		.xiugaixq_cont { width:100%; padding-left:12px;}
	}
	.permission_an .per_gbi:hover { background:#555;}    /* 需求追踪页面-返回按钮样式修改   */
	.permission_an a:hover { text-decoration: none; color: white; background: #316CB5; }   /* 需求追踪页面-建立关联、取消关联按钮样式修改   */
	a:focus { outline: none; }
	.clearCross { display:none;}   /* 取消小图标显示  */
</style>
</html>










