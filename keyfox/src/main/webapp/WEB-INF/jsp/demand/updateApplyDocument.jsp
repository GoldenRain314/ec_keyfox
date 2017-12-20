<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html style="overflow:auto; width:544px; height:600px;">
<head style="overflow-y:hidden;">
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
var left_sectionId = "";
var projectId= "${projectId}";
var contentCopyTemplateId= "${contentCopyTemplateId}";
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
var sectionName = "";
var colour = new Array("red","blue","green");

//点击左侧章节出现内容
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
//点击右侧章节出现内容
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
		onClick: this.onClickRight,
		//onCheck: this.onCheckRight
	}

};

//左侧菜单树
var zNodesLeft = "";
//右侧菜单树
var zNodesRight;

$(function (){
	
	$("#save").click(function (){
		
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
		var nodes = treeObj.getCheckedNodes(true); 
		var traceSectionIds = [];
		var traceSectionId = [];
		for(var i=0;i<nodes.length;i++){
			traceSectionIds.push(nodes[i].name);
			traceSectionId.push(nodes[i].id);
		}
		
		var sectionId = "";
		var sectionName = "";
		if(traceSectionIds.length == 0){
			layer.msg("选择要复用的章节");
			return false;
		}
		
		var reuseDocumentId = $("#reuseDocumentId").val();
		
		$.ajax({
			url : "${_baseUrl}/demand/updateApply",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {
	  				applyDocumentIds:$("#documentList").val(),
	  				applyDocumentName:$("#documentList option:selected").attr("title"),
	  				applySectionId:traceSectionId.join(","),
	  				applySectionName:traceSectionIds.join(","),
	  				projectId:"${projectId}",
	  				id:"${id}",
	  				"reuseDocumentId" : reuseDocumentId
	  				
	  				//showTraceSectionId:$("#showTraceSectionId").val(),
	  				
	  			},
			success : function(json) {
				if(json.message == "请选择未建立过复用关系的章节"){
					layer.msg(
						json.message,
						{shift : -1},
						function(){
							document.location.reload();
						}
					);
				} else {
					layer.msg(json.message);
				}
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	}); 
	$("#cancel").click(function (){
	
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
		var nodes = treeObj.getCheckedNodes(true); 
		var traceSectionIds = [];
		var traceSectionId = [];
		for(var i=0;i<nodes.length;i++){
			traceSectionIds.push(nodes[i].name);
			traceSectionId.push(nodes[i].id);
		}
		if(traceSectionIds.length == 0){
			layer.msg("请选择要取消复用的章节");
			return false;
		}
		// 取消复用前先验证本次取消完之后是否还有适用文档
		$.ajax({
			url : "${_baseUrl}/demand/cancelReuse",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {
	  			applyDocumentIds:$("#documentList").val(),
  				applyDocumentName:$("#documentList option:selected").attr("title"),
  				applySectionId:traceSectionId.join(","),
  				applySectionName:traceSectionIds.join(","),
  				id:"${id}",
  				projectId:"${projectId}",
  				"isTotal":0
	  			},
			success : function(data) {
				if(data.message == "0" || data.message == 0){
					// 全部删除，提示是否进行
					layer.confirm("是否取消全部适用文档章节?<br>点击'是'：取消并删除当前复用记录；<br>点击'否'：重新选择文档章节。",
							{btn: ['是','否'] }, //按钮
							function(){
								// 直接删除当前复用记录
								$.ajax({
									url : "${_baseUrl}/demand/deleteContentReuse",
									type : "post",
									dataType : "json",
									async : false,
									data : {
										id : "${id}"
									},
									success : function(data){
										layer.msg("删除成功",
												  {time : 1500},
												  function(){
													  giveBack();
												  });
									}
								});
							}
					);
				} else if(data.message == "1" || data.message == 1){
					$.ajax({
						url : "${_baseUrl}/demand/cancelReuse",
						type : "post",
						dataType : "json",
						async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
				  		data : {
				  			applyDocumentIds:$("#documentList").val(),
			  				applyDocumentName:$("#documentList option:selected").attr("title"),
			  				applySectionId:traceSectionId.join(","),
			  				applySectionName:traceSectionIds.join(","),
			  				id:"${id}",
			  				projectId:"${projectId}",
			  				"isTotal":1
				  			},
						success : function(data) {
							//window.location.href = "${_baseUrl}/dd/showTraceRelation?projectId=${projectId}&documentId=${documentId}";
							layer.msg(
									data.message,
									{shift : -1},
									function(){
										document.location.reload();
									}
									);
							var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
						        treeObj.checkAllNodes(false);
							//document.location.reload();
						},
						error:function(data){
							layer.msg("网络忙，请稍后重试");
						}
					});
				} else {
					layer.msg(data.message,
							{shift : -1},
							function(){
								document.location.reload();
							});
				}
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
		}//验证通过时调用的函数 
	});
	
	initLeftTree();
	
	replaceRefer();
});

function addDiyDom(treeId, treeNode) {
	var liObj = $("#" + treeNode.tId);
	var aObj = $("#" + treeNode.tId + "_span");
	liObj.addClass("level_"+treeNode.level);
	aObj.addClass("le_"+treeNode.level);
};

function onClickRight(e,treeId, treeNode){
	$("input[type='radio']:checked").removeAttr("checked");
	var docName = "${docName}";
	
	//alert(111444);
	$.ajax({
		//url:'${_baseUrl}/dd/selectSectionContentBySectionId?rand='+Math.random(),
		url : '${_baseUrl}/dd/querySectionInitialContentBySectionId?rand='+ Math.random(),		
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		data:{
			"sectionId":treeNode.id,
			"projectId":projectId,
			"sectionName":treeNode.name,
			"documentName":docName
		},
		async: false,
		success: function(data){
			
			$("#right_content").html(data.content?data.content:"无");
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
}
function initTreecheck(){
	var applySectionId="${applySectionId}";
	
	var arr = applySectionId.split(',');
	  
	for ( var k in arr) {
			var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
			if(treeObj.getNodeByParam("id", arr[k], null) != null){
				treeObj.checkNode(treeObj.getNodeByParam("id", arr[k], null), true,true);
			}
		}
	}

	/* 加载右侧的树    并初始化追踪关系 */
	function initLeftTree() {
		
		$.ajax({
			url : "${_baseUrl}/dd/contentReuseApplySetion",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
			data : {
				documentId : "${applyDocumentIds}",
				projectId : "${projectId}"
			},
			success : function(json) {
				zNodesRight = eval('(' + json.zNodes + ')');
				var rTree = $.fn.zTree.init($("#treeDemo_r"), setting_r,
						zNodesRight);
				var nodes = rTree.transformToArray(rTree.getNodes());

				for ( var i = 0; i < nodes.length; i++) {

					if (nodes[i].level < 3) {

						rTree.expandNode(nodes[i]);
					}

					if (nodes[i].level == 0) {

						nodes[i].nocheck = true;
						rTree.updateNode(nodes[i]);
					}
				}

				replaceReferR();

				$("#rightTree").html(json.documentName);
				initTreecheck();
			},
			error : function(data) {
				layer.msg("网络忙，请稍后重试");
			}
		});

		//将树节点颜色修改成默认
		var leftTreeDefaultFont = $.fn.zTree.getZTreeObj("treeDemo");
		//左侧树节点
		var leftTreenodes = leftTreeDefaultFont.transformToArray(leftTreeDefaultFont.getNodes());
		for ( var ll = 0; ll < leftTreenodes.length; ll++) {
			var node = leftTreenodes[ll];
			node.font = {
				'color' : ''
			};
			leftTreeDefaultFont.updateNode(node);
		}
		//根据文档ID 追踪的文档ID  项目ID 获取追踪关系,并选中
		/* $.ajax({
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
		}); */

		//438b 固定追踪关系上色
		initColour();

		//设置显示追踪章节名称
		initshowTraceSectionValue();

	}

	/* 加载左侧的树    并初始化追踪关系 */
	function initLeftTree1() {
		var docment = $("#documentList").val();
		$.ajax({
			url : "${_baseUrl}/dd/contentReuseApplySetion",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
			data : {
				documentId : docment,
				projectId : "${projectId}"
			},
			success : function(json) {
				zNodesRight = eval('(' + json.zNodes + ')');
				var rTree = $.fn.zTree.init($("#treeDemo_r"), setting_r,
						zNodesRight);
				var nodes = rTree.transformToArray(rTree.getNodes());

				for ( var i = 0; i < nodes.length; i++) {

					if (nodes[i].level < 3) {

						rTree.expandNode(nodes[i]);
					}

					if (nodes[i].level == 0) {
						nodes[i].nocheck = true;
						rTree.updateNode(nodes[i]);
					}
				}

				replaceReferR();

				$("#rightTree").html(json.documentName);
				initTreecheck();
			},
			error : function(data) {
				layer.msg("网络忙，请稍后重试");
			}
		});

		//将树节点颜色修改成默认
		var leftTreeDefaultFont = $.fn.zTree.getZTreeObj("treeDemo");
		//左侧树节点
		var leftTreenodes = leftTreeDefaultFont
				.transformToArray(leftTreeDefaultFont.getNodes());
		for ( var ll = 0; ll < leftTreenodes.length; ll++) {
			var node = leftTreenodes[ll];
			node.font = {
				'color' : ''
			};
			leftTreeDefaultFont.updateNode(node);
		}

		initColour();

		//设置显示追踪章节名称
		initshowTraceSectionValue();

	}

	function replaceRefer() {
		var ztree = $.fn.zTree.getZTreeObj("treeDemo");
		var nodes = ztree.transformToArray(ztree.getNodes());
		for ( var i = 0; i < nodes.length; i++) {
			var childNodes = nodes[i];//㊤㊥㊦㊧㊨㊐㊊
			var name = childNodes.name;
			var result = true;
			while (result) {
				if (name.indexOf("▼▽㊤▲△") > 0 || name.indexOf("▼▽㊦▲△") > 0
						|| name.indexOf("▼▽㊧▲△") > 0
						|| name.indexOf("▼▽㊨▲△") > 0
						|| name.indexOf("▼▽㊐▲△") > 0
						|| name.indexOf("▼▽㊊▲△") > 0) {
					name = name.replace("▼▽㊤▲△", "'");
					name = name.replace('▼▽㊦▲△', '"');
					name = name.replace("▼▽㊧▲△", "‘");
					name = name.replace('▼▽㊨▲△', '’');
					name = name.replace('▼▽㊐▲△', '“');
					name = name.replace('▼▽㊊▲△', '”');
				} else {
					result = false;
				}
			}
			ztree.getNodeByParam("id", childNodes.id, null).name = name;
			ztree.updateNode(ztree.getNodeByParam("id", childNodes.id, null));
		}
	}

	//treeDemo_r
	function replaceReferR() {
		var ztree = $.fn.zTree.getZTreeObj("treeDemo_r");
		var nodes = ztree.transformToArray(ztree.getNodes());
		for ( var i = 0; i < nodes.length; i++) {
			var childNodes = nodes[i];//㊤㊥㊦㊧㊨㊐㊊
			var name = childNodes.name;
			var result = true;
			while (result) {
				if (name.indexOf("▼▽㊤▲△") > 0 || name.indexOf("▼▽㊦▲△") > 0
						|| name.indexOf("▼▽㊧▲△") > 0
						|| name.indexOf("▼▽㊨▲△") > 0
						|| name.indexOf("▼▽㊐▲△") > 0
						|| name.indexOf("▼▽㊊▲△") > 0) {
					name = name.replace("▼▽㊤▲△", "'");
					name = name.replace('▼▽㊦▲△', '"');
					name = name.replace("▼▽㊧▲△", "‘");
					name = name.replace('▼▽㊨▲△', '’');
					name = name.replace('▼▽㊐▲△', '“');
					name = name.replace('▼▽㊊▲△', '”');
				} else {
					result = false;
				}
			}
			ztree.getNodeByParam("id", childNodes.id, null).name = name;
			ztree.updateNode(ztree.getNodeByParam("id", childNodes.id, null));
		}
	}

	/* 关闭弹出框 */
	function closeWin() {
		$("#popDiv").dialog('close');
	}

	function setTraceNameAndId(name, id) {
		$("#showTraceSectionName").val(name);
		$("#showTraceSectionId").val(id);
	}

	function getFont(treeId, node) {
		return node.font ? node.font : {};
	}

	function initshowTraceSectionValue() {
		$.ajax({
			url : "${_baseUrl}/dd/getShowDocumentTraceSectionId?rand="
					+ Math.random(),
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
			data : {
				documentId : "${documentId}",
				projectId : "${projectId}",
				traceDocumentId : $("#documentList").val()
			},
			success : function(json) {
				//加载需求追踪列表添加的章节
				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
				var node = treeObj.getNodeByParam("id", json.message, null);
				if (node != undefined) {
					$("#showTraceSectionId").val(node.id);
					$("#showTraceSectionName").val(node.name);
				}
			},
			error : function(data) {

				layer.msg("网络忙，请稍后重试");
			}
		});

	}

	function initColour() {
		if ("true" == "${b438}") {
			//438B 加载固定追踪关系,修改字体颜色
			$.ajax({
				url : "${_baseUrl}/dd/get438BTraceFixed",
				type : "post",
				dataType : "json",
				async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
				data : {
					documentId : "${documentId}",
					traceDocumentId : $("#documentList").val(),
					projectId : "${projectId}"
				},
				success : function(json) {
					var traceJson = eval('(' + json.traceString + ')');
					//显示追踪关系的章节
					var showTraceSectionName = json.showTraceSection;

					if (showTraceSectionName != undefined)
						showTraceSectionName = showTraceSectionName.replace(
								/\s/ig, '');

					for ( var i = 0; i < traceJson.length; i++) {
						//追踪的章节号
						var sectionNumber = traceJson[i].sectionNumber;

						var leftTree = $.fn.zTree.getZTreeObj("treeDemo");
						//左侧树节点
						var nodes = leftTree.transformToArray(leftTree
								.getNodes());

						/* 展示需求追踪关系的章节 */
						/* for(var lt=0;lt=nodes.length;lt++){ */
						for ( var lt in nodes) {
							var node = nodes[lt];
							if (node != undefined) {
								var nodeName = node.name;
								if (nodeName == showTraceSectionName) {
									$("#showTraceSectionId").val(node.id);
									$("#showTraceSectionName").val(nodeName);
								}
							}
						}

						//给左侧树上色
						initLeftTreeColor(sectionNumber);
						//右侧树上色
						initRightTreeColor(traceJson[i].traceSectionNumber)
					}
				},
				error : function(data) {
					layer.msg("网络忙，请稍后重试");
				}
			});
		}
	}
	
	/* 初始化左侧菜单颜色 */
	function initLeftTreeColor(sectionNumber) {

		var leftTree = $.fn.zTree.getZTreeObj("treeDemo");
		//左侧树节点
		var nodes = leftTree.transformToArray(leftTree.getNodes());

		var sectionNumberList = sectionNumber.split(";");
		for ( var l = 0; l < sectionNumberList.length; l++) {
			var sectionNumberOne = sectionNumberList[l].split(",");
			for ( var ll = 0; ll < sectionNumberOne.length; ll++) {
				//需要所有子节点追踪的章节
				var indexof = sectionNumberOne[ll].indexOf(".X");

				var traceSectionNumbers = "";

				if (indexof > 0)
					traceSectionNumbers = sectionNumberOne[ll].substring(0,
							indexof + 1);
				//左侧
				for ( var lt in nodes) {
					var node = nodes[lt];
					var sectionNumber = node.sectionNumber;
					var nodeName = node.name;
					if (traceSectionNumbers == "") {
						if (sectionNumber != undefined) {
							sectionNumber = sectionNumber.replace(/\s/ig, '');
							if (sectionNumber == sectionNumberOne[ll]) {
								node.font = {
									'color' : colour[l]
								};
								leftTree.updateNode(node);
							}
						}
					} else {
						if (nodeName != undefined) {
							if (nodeName.indexOf(traceSectionNumbers) == 0) {
								node.font = {
									'color' : colour[l]
								};
								leftTree.updateNode(node);
							}
						}
					}

				}

			}
		}
		var divs = $("div.jspPane");
		$.each(divs, function(i, item) {
			$(item).css("left", "0px");
		})
	}

	//右侧
	function initRightTreeColor(traceSectionNumber) {
		var rightTreeR = $.fn.zTree.getZTreeObj("treeDemo_r"); //获取树
		var rightNodes = rightTreeR.transformToArray(rightTreeR.getNodes());
		var traceSectionNumberList = traceSectionNumber.split(";");

		for ( var l = 0; l < traceSectionNumberList.length; l++) {
			var traceSectionNumberOne = traceSectionNumberList[l].split(",");
			for ( var ll = 0; ll < traceSectionNumberOne.length; ll++) {
				//需要所有子节点追踪的章节
				var indexofTrace = traceSectionNumberOne[ll].indexOf(".X");

				var rightTraceSectionNumbers = "";

				if (indexofTrace > 0) {
					rightTraceSectionNumbers = traceSectionNumberOne[ll]
							.substring(0, indexofTrace + 1);
				}

				for ( var lr in rightNodes) {
					var node = rightNodes[lr];
					var sectionNumber = node.sectionNumber;
					var nodeName = node.name;
					if (rightTraceSectionNumbers == "") {
						if (sectionNumber != undefined) {
							sectionNumber = sectionNumber.replace(/\s/ig, '');
							var sec = traceSectionNumberOne[ll].replace(/\s/ig,
									'');
							if (sectionNumber == sec) {
								node.font = {
									'color' : colour[l]
								};
								rightTreeR.updateNode(node);
							}
						}
					} else {
						if (nodeName != undefined) {
							if (nodeName.indexOf(rightTraceSectionNumbers) == 0) {
								node.font = {
									'color' : colour[l]
								};
								rightTreeR.updateNode(node);
							}
						}
					}
				}
			}
		}
		var divs = $("div.jspPane");
		$.each(divs, function(i, item) {
			$(item).css("left", "0px");
		})
	}
	function returnHistory() {

		var random = Math.random();
		var referrer = document.referrer;
		if (referrer.indexOf("/dd/showDemandDocumentList") > 0) {
			history.go(-1);
		} else {
			parent
					.skipModule(
							"文档编写",
							"${_baseUrl}/documentSectionController/sectionTree?projectId=${projectId}&documentId=${documentId}&status=${status}&isOk=${isOk}&random="
									+ random);
		}
	}

	function setLeft() {
		var divs = $("div.jspPane");
		$.each(divs, function(i, item) {
			$(item).css("left", "0px");
		})
	}
	function giveBack() {
		parent.closewin();
		parent.refreshTable();
	}
	// 勾选时验证适用文档章节是否建立了多份引用文档章节的对应关系
	function onCheckRight(e,treeId, treeNode){
		var applyDocumentIds = $("#documentList").val();
		var reuseDocumentId = $("#reuseDocumentId").val();
		var checkTreeNode = treeNode.id;
		if(treeNode.checked){
			$.ajax({
				url : "${_baseUrl}/demand/provingReuse",
				type : "post",
				async : false,
				dataType : "json",
				data : {
					"applyDocumentIds" : applyDocumentIds,
					"reuseDocumentId" : reuseDocumentId,
					"checkTreeNode" : checkTreeNode
				},
				success : function(data){
					var message = data.message;
					if(message == "请选择未建立过复用关系的章节"){
						layer.msg(message);
						var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
						var node = treeObj.getNodeByTId(treeNode.tId);
						treeObj.checkNode(node,false,false);
					}
				}
			}); 
		}
		
	}
</script>
<body >
    <div class="document_main" >
        <div class="xiugaixq_cont">
       <input  id="documentList" type="hidden" value="${applyDocumentIds}">
       <input id="reuseDocumentId" type="hidden" value="${reuseDocumentId}">
            <hr class="fl" size="1"  style="border: 1px dashed #ccc; height: 500px;">
            <div class="fl xiugaixq_list" id="rightTreeContent" onmouseover="setLeft();" onmousedown="setLeft();" onmouseout="setLeft();" onmousewheel="setLeft();" onmouseenter="setLeft();" onmousemove="setLeft();" onmouseup="setLeft();" onmouseleave="setLeft();"  style="margin-left: 5px;padding-left: 5px;">
                <div class="xiugaixq_list_tit" style="left: 0px;"><span id="rightTree"></span></div>
                <div class="xiugaixq_list_c"  style="left: 0px;">
                    <div class="zTreeDemoBackground treedemo_xqzz2 left">
                        <ul id="treeDemo_r" class="ztree ztreexqzz_a ztreexqzz_b" style="margin-left: 5px;left: 0px;"></ul>
                    </div>
                </div>
            </div>
            <div class="fl xiugaixq_list xiugaixq_list2 xiugaixq_list3">          	
            	
            	<div class="xiugaixq_text2">
            		<div id="right_content" class="xiugaixq_texta"></div>
            	</div>
            	
           	</div>
            <div class="clear"></div>
        </div>
        
        <div class="permission_an xiugaixq_anw mt30" style=" width:544px;">
        	<shiro:hasPermission name="dd:insertTraceTelation">
		        <a href="javascript:;" class="per_baocun" id="save">复用</a>
		    </shiro:hasPermission>
		    <shiro:hasPermission name="dd:deleteTraceTelation">
		   		<a href="javascript:;" class="per_baocun" id="cancel">取消复用</a>
		    </shiro:hasPermission>
		    <shiro:hasPermission name="dd:returnDocumentDemand">
		        <a onclick="giveBack()" class="per_gbi" >返回</a>
		    </shiro:hasPermission>
        </div>
        <input type="hidden" id="sectionIds">
          <input type="hidden" id="sectionNames">
        </div>
    </div>
    <div id="popDiv" style="display: none; overflow:hidden;">
		<iframe id="popIframe" border="0" frameborder="0"></iframe>
	</div>
</body>

</html>