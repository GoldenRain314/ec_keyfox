<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html style="overflow-y:hidden;">
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
var left_sectionId = "";

var projectId= "${projectId}";

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


//引用列表val
var quoteid = "";
var quotename = "";

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
		onCheck:this.onCheckRight
	}

};



//左侧菜单树
var zNodesLeft = "";
//右侧菜单树
var zNodesRight;

$(function (){
	
		$("#documentList1").click(
				function() {

					quoteid = $("#documentList1").val();
					quotename = $("#documentList1 option:selected").attr("title");
					//alert(quoteid);
					 /* $("#documentList").append(
							"<option value="+documentids+" title="+documentname+">"
									+ documentname + "</option>"); */
				
				});

		var ask = true;//禁止多次提交
		$("#save").click(
						function() {

							var document_r = $("#documentList").val();
							if (document_r == "" || document_r == "请选择") {

								layer.msg("请选择要适用的文档");
								return false;
							}

							var document_rr = $("#documentList1").val();
							if (document_rr == "" || document_rr == "请选择") {
								layer.msg("请选择要引用的文档");
								return false;
							}
							if (document_r == document_rr) {
								layer.msg("文档自己不能复用自己");
								return false;
							}
							var sectionId_rr = $("#sectionIds").val();
							if (sectionId_rr == "") {
								layer.msg("请选择要引用的章节");
								return false;
							}
							var reuseDocumentName = $("#leftTree").text();
							var sectionName = $("#sectionNames").val();
							if (reuseDocumentName == sectionName) {
								layer.msg("请选择要引用的章节");
								return false;
							}

							var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
							var nodes = treeObj.getCheckedNodes(true);
							var traceSectionIds = [];
							var traceSectionId = [];
							for ( var i = 0; i < nodes.length; i++) {
								traceSectionIds.push(nodes[i].name);
								traceSectionId.push(nodes[i].id);
							}

							var sectionId = "";
							var sectionName = "";
							if (traceSectionIds.length == 0) {
								layer.msg("请选择要适用的章节");
								return false;
							}
							if ($("#documentContentReuseId").val() != "") {
								if (ask) {
									ask = false;
									$.ajax({
												url : "${_baseUrl}/demand/updateApply",
												type : "post",
												dataType : "json",
												async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
												data : {
													applyDocumentIds : $(
															"#documentList")
															.val(),
													applyDocumentName : $(
															"#documentList option:selected")
															.attr("title"),
													applySectionId : traceSectionId
															.join(","),
													applySectionName : traceSectionIds
															.join(","),
													projectId : "${projectId}",
													id : $(
															"#documentContentReuseId")
															.val()
												//showTraceSectionId:$("#showTraceSectionId").val(),

												},
												success : function(json) {
													/* //复用成功后，跳回复用列表页
													layer.msg("操作成功", {
														shift : -1
													},//取消弹框的跳动
													function() {
														history.go(-1);
													}); */
													layer.msg("操作成功",
															{shift:-1},
															function(){
																//document.location.reload();
																ask = true;
																// 保存复用关系ID
																
																});
													
												},
												error : function(data) {
													layer.msg("网络忙，请稍后重试");
												}
											});
								}
							} else {
								if (ask) {
									ask = false;
									$.ajax({
												url : "${_baseUrl}/dd/saveReuse",
												type : "post",
												dataType : "json",
												async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
												data : {
													reuseDocumentIds : $("#documentList1").val(),
													reuseDocumentName : $(
															"#documentList1 option:selected")
															.attr("title"),
													reuseSectionId : $(
															"#sectionIds")
															.val(),
													reuseSectionName : $(
															"#sectionNames")
															.val(),
													applyDocumentIds : $(
															"#documentList")
															.val(),
													applyDocumentName : $(
															"#documentList option:selected")
															.attr("title"),
													applySectionId : traceSectionId
															.join(","),
													applySectionName : traceSectionIds
															.join(","),
													projectId : "${projectId}"
												//showTraceSectionId:$("#showTraceSectionId").val(),

												},
												success : function(json) {
													/* //复用成功后，跳回复用列表页
													layer.msg(json.message, {
														shift : -1
													},//取消弹框的跳动
													function() {
														history.go(-1);
													}); */
													var message = json.message.split(",");
													if(message.length == 2){
														var documentContentReuseId = message[1];
														// 不初始化追踪关系时，为updata操作
														$("#documentContentReuseId").val(documentContentReuseId);
													}
													layer.msg(message[0],
															{shift:-1},
															function(){
																//document.location.reload();
																ask = true;
																
															});
													
													//修改当前节点颜色为已创建追踪关系
													var leftTreeFor = $.fn.zTree
															.getZTreeObj("treeDemo");
													var nodeFor = leftTreeFor
															.getNodeByParam(
																	"id",
																	sectionId,
																	null);
													nodeFor.font = {
														'color' : '#802A2A'
													};
													for ( var i = 0; i < nodes.length; i++) {
														nodes[i].font = {
															'color' : '#802A2A'
														};
														treeObj
																.updateNode(nodes[i]);
													}
													//alert(nodes.font.color);
													leftTreeFor
															.updateNode(nodeFor);
												},
												error : function(data) {
													layer.msg("网络忙，请稍后重试");
												}
											});
								}
							}

						});
		$("#cancel")
				.click(
						function() {
							$('#showTraceSectionName').validationEngine(
									'validate');

							var showTraceSectionId = $("#showTraceSectionId")
									.val();

							var document_r = $("#documentList").val();
							if (document_r == "") {
								layer.msg("请选择要追踪的文档");
								return false;
							}

							if (showTraceSectionId == "") {
								layer.msg("请选择需求追踪列表存放章节");
								return false;
							}

							if (sectionId == "") {
								layer.msg("请选择左侧章节");
								return false;
							}

							var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
							var nodes = treeObj.getCheckedNodes(true);
							var traceSectionIds = [];
							for ( var i = 0; i < nodes.length; i++) {
								traceSectionIds.push(nodes[i].id);
							}

							if (traceSectionIds.length == 0) {
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
											sectionId : sectionId,
											traceDocumentId : $("#documentList")
													.val(),
											traceSectionIds : traceSectionIds
													.join(","),
											projectId : "${projectId}",
											showTraceSectionId : $(
													"#showTraceSectionId")
													.val(),
											traceRelation : $(
													"input[name='traceRelation']:checked")
													.val()
										},
										success : function(data) {
											//window.location.href = "${_baseUrl}/dd/showTraceRelation?projectId=${projectId}&documentId=${documentId}";
											layer.msg(data.message);
											initRightTree();
										},
										error : function(data) {
											layer.msg("网络忙，请稍后重试");
										}
									});
						});
	});

	$(document).ready(function() {

		$("#showTraceSectionName").validationEngine({
			autoHidePrompt : true,//自动隐藏
			showOnMouseOver : true,//当鼠标移出时触发
			promptPosition : 'bottomRight',//提示信息的位置
			inlineValidation : true,//是否即时验证，false为提交表单时验证,默认true  
			failure : function() {
				layer.message("验证失败，请检查");
				return false;
			},//验证失败时调用的函数
			ajaxFormValidation : true,//开始AJAX验证
			success : function() {
			}//验证通过时调用的函数 
		});

		//初始化左侧菜单树
		var leftTree = $.fn.zTree.init($("#treeDemo"), setting, zNodesLeft);
		var nodes = leftTree.transformToArray(leftTree.getNodes());
		for ( var i = 0; i < nodes.length; i++) {
			if (nodes[i].level < 3) {
				leftTree.expandNode(nodes[i]);
			}
		}
		initLeftTree1();
		replaceRefer();
	});

	function addDiyDom(treeId, treeNode) {
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_" + treeNode.level)
		aObj.addClass("le_" + treeNode.level)
	};

	function onClickLeft(e, treeId, treeNode) {
		left_sectionId = treeNode.id;
		sectionId = treeNode.id;
		sectionName = treeNode.name;
		$("#sectionIds").val(sectionId);
		$("#sectionNames").val(sectionName);
		//1、初始化右侧的树

		$("input[type='radio']:checked").removeAttr("checked");

		$.ajax({
			url : '${_baseUrl}/dd/selectSectionContentBySectionId?rand='
					+ Math.random(),
			type : 'post', //数据发送方式 
			dataType : 'json', //接受数据格式 
			data : {
				"sectionId" : treeNode.id
			},
			async : false,
			success : function(data) {
				initRightTree();
				$("#left_content").html(data.content);

			},
			error : function() {
				layer.msg("系统错误");
			}
		});
	}
	function onClickRight(e, treeId, treeNode) {
		var docName = $("#documentList option:selected").text();
		
		$("input[type='radio']:checked").removeAttr("checked");
		$.ajax({
			//url : '${_baseUrl}/dd/selectSectionContentBySectionId?rand='+ Math.random(),
			url : '${_baseUrl}/dd/querySectionInitialContentBySectionId?rand='+ Math.random(),
			type : 'post', //数据发送方式 
			dataType : 'json', //接受数据格式 
			data : {
				"sectionId" : treeNode.id,
				"sectionName" : treeNode.name,
				"documentName" : docName,
				"proId" : projectId,
				"ids" : "${ids}"
			},
			async : false,
			success : function(data) {
				//alert(data.content);
				$("#right_content").html(data.content);
			},
			error : function() {
				layer.msg("系统错误");
			}
		});
	}
	function onCheckRight(e, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
		var nodes = treeObj.getCheckedNodes(true);
		for ( var i = 0; i < nodes.length; i++) {
			if (treeNode.id == nodes[i].id) {
				$.ajax({
					url : '${_baseUrl}/dd/testApplySection?rand='
							+ Math.random(),
					type : 'post', //数据发送方式 
					dataType : 'json', //接受数据格式 
					data : {
						"applySectionId" : treeNode.id,
						"reuseDocumentIds" : $("#documentList1").val(),
						"applyDocumentIds" : $("#documentList").val(),
						projectId : "${projectId}"
					},
					async : false,
					success : function(data) {

						var documentContentReuse = eval(data);
						$("#documentContentReuseId").val(
								documentContentReuse.id);
						initLeftTreeColors(documentContentReuse.reuseSectionId,
								documentContentReuse.reuseSectionName);
						initLeftContent(documentContentReuse.reuseSectionId);
						$("#rightTree").html(
								documentContentReuse.applyDocumentName);
						var arr = documentContentReuse.applySectionId
								.split(',');
						for ( var k in arr) {
							var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
							if(treeObj.getNodeByParam("id",arr[k], null) != null){
								treeObj.checkNode(treeObj.getNodeByParam("id",arr[k], null), true, true);
							}
						}
						layer.msg("复用关系已建立");
					},
					error : function() {

					}
				});
			}

		}

		/*  $.ajax({
			url:'${_baseUrl}/dd/textApplySection?rand='+Math.random(), 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			data:{"applySectionId":treeNode.id,"reuseDocumentIds" :$("#documentList1").val(),"applyDocumentIds":$("#documentList").val(),projectId:"${projectId}"},
			async: false,
			success: function(data){
				
				var documentContentReuse = eval(data);
				$("#documentContentReuseId").val(documentContentReuse.id);
				initLeftTreeColors(documentContentReuse.reuseSectionId,documentContentReuse.reuseSectionName);
				initLeftContent(documentContentReuse.reuseSectionId);
				$("#rightTree").html(documentContentReuse.applyDocumentName);
				var arr = documentContentReuse.applySectionId.split(',');
				  for(var k in arr){	
					  var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r"); 
					  treeObj.checkNode(treeObj.getNodeByParam("id", arr[k], null), true, true); 
						}
				  layer.msg("复用关系已建立"); 
				  
		       },
			error:function(){
				 layer.msg("复用关系"); 
			}
		}); */
	}

	function initLeftContent(id) {
		$.ajax({
			url : '${_baseUrl}/dd/selectSectionContentBySectionId?rand='
					+ Math.random(),
			type : 'post', //数据发送方式 
			dataType : 'json', //接受数据格式 
			data : {
				"sectionId" : id
			},
			async : false,
			success : function(data) {
				$("#left_content").html(data.content);
			},
			error : function() {
				layer.msg("系统错误");
			}
		});
	}

	/* 加载右侧的树    并初始化追踪关系 */
	function initRightTree() {
		$("#documentContentReuseId").val("");
		var document_r = $("#documentList").val();
		if (document_r == "请选择") {
			//layer.msg("请选择要适用的文档");
			return false;
		}

		if (document_r == "${documentId}") {
			layer.msg("同一份文档不能建立追踪关系");
			return false;
		}

		$.ajax({
			url : "${_baseUrl}/dd/checkReuse",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
			data : {
				projectId : projectId,
				reuseDocumentIds : $("#documentList1").val(),
				reuseSectionId : $("#sectionIds").val(),
				applyDocumentIds : $("#documentList").val()
			},
			success : function(json) {
				var documentContentReuse = eval(json);
				if (json == null) {
					$.ajax({
						url : "${_baseUrl}/dd/contentReuseApplySetion",
						type : "post",
						dataType : "json",
						async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
						data : {
							documentId : document_r,
							projectId : projectId
						},
						success : function(json) {
							zNodesRight = eval('(' + json.zNodes + ')');
							var rTree = $.fn.zTree.init($("#treeDemo_r"),
									setting_r, zNodesRight);
							var nodes = rTree
									.transformToArray(rTree.getNodes());
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
						},
						error : function(data) {
							layer.msg("网络忙，请稍后重试");
						}
					});
				} else {
					$("#documentContentReuseId").val(documentContentReuse.id);
					$.ajax({
						url : "${_baseUrl}/dd/contentReuseApplySetion",
						type : "post",
						dataType : "json",
						async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
						data : {
							documentId : documentContentReuse.applyDocumentIds,
							projectId : documentContentReuse.projectId
						},
						success : function(json) {
							zNodesRight = eval('(' + json.zNodes + ')');
							var rTree = $.fn.zTree.init($("#treeDemo_r"),
									setting_r, zNodesRight);
							var nodes = rTree
									.transformToArray(rTree.getNodes());

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

							$("#rightTree").html(documentContentReuse.applyDocumentName);
							var arr = documentContentReuse.applySectionId.split(',');
							for ( var k in arr) {
								var treeObj = $.fn.zTree.getZTreeObj("treeDemo_r");
								if(treeObj.getNodeByParam("id",arr[k], null) != null){
									treeObj.checkNode(treeObj.getNodeByParam("id",arr[k], null), true, true);
								}
							}
							layer.msg("复用关系已建立");

						},
						error : function(data) {
							layer.msg("网络忙，请稍后重试");
						}
					});
				}
			},
			error : function(data) {
				$.ajax({
					url : "${_baseUrl}/dd/contentReuseApplySetion",
					type : "post",
					dataType : "json",
					async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
					data : {
						documentId : document_r,
						projectId : projectId
					},
					success : function(json) {
						zNodesRight = eval('(' + json.zNodes + ')');
						var rTree = $.fn.zTree.init($("#treeDemo_r"),
								setting_r, zNodesRight);
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
					},
					error : function(data) {
						layer.msg("网络忙，请稍后重试");
					}
				});
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
	
	
	
	/* 加载左侧的树    并初始化追踪关系 */
	function initLeftTree1() {
		
		//去除适用文档列表的已发布和引用列表的内容
		deleteRepeat();
		
		var document = $("#documentList1").val();

		if (document == "请选择") {
			$("#left_content").val("");
			layer.msg("请选择要引用的文档");
			return false;
		}

		if (document == "${documentId}") {
			layer.msg("同一份文档不能建立引用关系");
			return false;
		}
		
		$.ajax({
			url : "${_baseUrl}/dd/contentReuse?rand=" + Math.random(),
			//url :"${_baseUrl}/documentSectionController/trackSectionTree?rand="+Math.random(),
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
			data : {
				documentId : document,
				projectId : projectId
			},
			success : function(json) {
				zNodesLeft = eval('(' + json.zNodes + ')');
				var rTree = $.fn.zTree
						.init($("#treeDemo"), setting, zNodesLeft);
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
				$("#leftTree").html(json.documentName);
				$("#leftTree").attr("title",json.documentName);    /* 添加title标签   */
				$("#leftTree").css({"overflow":"hidden","text-overflow":"ellipsis","white-space":"nowrap","padding":"0 30px 0 10px"});
				initLeftTreeColors(nodes[1].id, nodes[1].name);
				initLeftContent(nodes[1].id);
				
				//replaceReferR();
				replaceRefer();
				

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

		//根据文档ID 追踪的文档ID  项目ID 获取追踪关系,并选中
		$.ajax({
			url : "${_baseUrl}/dd/getDocumentTraceList?checked=checked&rand="
					+ Math.random(),
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
			data : {
				documentId : "${documentId}",
				projectId : "${projectId}",
				traceDocumentId : $("#documentList1").val(),
				sectionId : sectionId
			},
			success : function(json) {
				var jsonObj = eval('(' + json.json + ')');
				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
				var treeObjleft = $.fn.zTree.getZTreeObj("treeDemo");
				//$("input[type=radio][name='traceRelation'][value="+json.traceRelation+"]").attr("checked",'checked')
				//已建立追踪关系的章节颜色
				var sId = json.sId;
				if (sId != undefined) {
					var sIds = sId.split(",");
					for ( var i = 0; i < sIds.length; i++) {
						var nodeForColor = treeObjleft.getNodeByParam("id",
								sIds[i], null);
						if (nodeForColor != undefined) {
							nodeForColor.font = {
								'color' : '#802A2A'
							};
							treeObjleft.updateNode(nodeForColor);
						}
					}
				}
				if (jsonObj != undefined) {
					for ( var i = 0; i < jsonObj.length; i++) {
						//选中 并展开
						var node = treeObj.getNodeByParam("id",
								jsonObj[i].traceSectionId, null);
						//选中
						treeObj.checkNode(node, true, true);
						node.font = {
							'color' : '#802A2A'
						};
						treeObj.updateNode(node);
						//展开
						treeObj.expandNode(node);//展开指定节点
						treeObj.selectNode(node);//选中指定节点
					}
				}

			},
			error : function(data) {
				layer.msg("网络忙，请稍后重试");
			}
		});

		//438b 固定追踪关系上色
		initColour();

		//设置显示追踪章节名称
		initshowTraceSectionValue();
		

	}
	function initLeftTreeColors(reuseSectionId, reuseSectionName) {

		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
		var node = treeObj.getNodeByParam("id", reuseSectionId, null);
		treeObj.selectNode(node);
		$("#sectionIds").val(reuseSectionId);
		$("#sectionNames").val(reuseSectionName);
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

	function initLeftTree() {
		$.ajax({
			url : "${_baseUrl}/dd/contentReuse",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
			data : {
				documentId : "${documentId}",
				projectId : "${projectId}"
			},
			success : function(json) {
				zNodesLeft = eval('(' + json.zNodes + ')');
				$("#leftTree").html(json.documentName + json.documentVersion);
				$("#documentName").html(json.documentName);
				$("#version").html(
						json.documentVersion.substring(2,
								json.documentVersion.length - 1));
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
		});
	}
	
	
	function deleteRepeat(){
		// 向右侧的列表添加左侧的值
		//alert(quoteid);
		if(quoteid != ""){ 
		
			$("#documentList").append(
					"<option value="+quoteid+" title="+quotename+">"
							+ quotename + "</option>");
		
		}
		
		
		//从适用文档列表删除引用文档以选择的值
		var documentid = $("#documentList1").val();
		$("#documentList option[value='" + documentid + "']").remove(); 
			
		//获取已发布的文档,从适用文档列表中删除
		$.ajax({
			url : "${_baseUrl}/dd/queryPublishDocument",
			type : "post",
			dataType : "json",
			async : false,
			data : {
					projectId : projectId,
					status : "3"
				},
				success : function(data) {
					$.each(data,function(i,obj){
						//alert(obj.id);
						$("#documentList option[value='" + obj.id + "']").remove();
					});
				}
			});
			
			
			//去除列表的重复项
			$("#documentList option").each(
				function(){
					var gettext = $(this).text();
					if($("#documentList option:contains("+gettext+")").length > 1){
						$("#documentList option:contains("+gettext+"):gt(0)").remove();
				};
			});
			
			
			// 更新quoteid、quotename中的值
			quoteid = $("#documentList1").val();
			quotename = $("#documentList1 option:selected").attr("title");
		
		};
	
</script>
<body>
    <div id="document_main" class="document_main" style="overflow:auto;">
        <div class="xiugaixq_cont">
        <div class="xiugaixq_box">
        <div class="fl xmugonj_bz xiugaixq_bz2" style="margin-left: 5px;top: 10px;margin-top: 0px;">
            <dl>
                <dt>引用文档&nbsp;：</dt>
                <dd>
                    <select class="xmugonj_select" id="documentList1" onchange="initLeftTree1()">
                    	<c:forEach items="${documentList}" var="doc">
                    		<option value="${doc.id}" title="${doc.templateName }"<c:if test="${quoteDocumentId == doc.id}"> selected="selected"</c:if>>${doc.templateName}</option>
                    	</c:forEach>
                    </select>
                </dd>               
            </dl>         
        </div>           	 
      		<div class="fl xmugonj_bz xiugaixq_bz2" style="margin-left: 5px;top: 10px;margin-top: 0px;">
            <dl>
                <dt>适用文档&nbsp;：</dt>
                <dd>
                    <select class="xmugonj_select" id="documentList" onchange="initRightTree()">
                     <option>请选择</option>
                    	<c:forEach items="${documentList}" var="doc">
                    	
                    		<option value="${doc.id}" title="${doc.templateName}"<c:if test="${trackDocumentId == doc.id}"> selected="selected"</c:if>>${doc.templateName }</option>
                    	</c:forEach>
                    </select>
                </dd>
                <div class="clear"></div>
            </dl>         
        </div>           	 
        </div>
        <div class="xiugaixq_list_cont">
            <div class="fl xiugaixq_list">
                <div class="xiugaixq_list_tit"><span id="leftTree"></span></div>
                <div class="xiugaixq_list_c">
                    <div class="zTreeDemoBackground treedemo_xqzz1 left">
                        <ul id="treeDemo" class="ztree ztreexqzz_a"></ul>
                    </div>
                </div>
            </div>
            
            <div class="fl xiugaixq_list xiugaixq_list3">
            	<div class="xiugaixq_text">
            		<div id="left_content" class="xiugaixq_texta"></div>
            	</div>
           	</div>
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
        
        <div class="permission_an xiugaixq_anw mt30" >
        	<shiro:hasPermission name="dd:insertTraceTelation">
		        <a href="javascript:;" class="per_baocun" id="save">复用</a>
		    </shiro:hasPermission>
		 <%--    <shiro:hasPermission name="dd:deleteTraceTelation">
		   		<a href="javascript:;" class="per_baocun" id="cancel">取消复用</a>
		    </shiro:hasPermission> --%>
		    <shiro:hasPermission name="dd:returnDocumentDemand">
		        <a href="javascript:history.go(-1);" class="per_gbi" >返回</a>
		    </shiro:hasPermission>
        </div>
        <input type="hidden" id="sectionIds">
          <input type="hidden" id="sectionNames">
           <input type="hidden" id="documentContentReuseId">
        </div>
    </div>
    <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="0"></iframe>
	</div>
</body>
<script type="text/javascript">
var  resizeTimer = null;
window.onload = function(){initHeight();}
window.onresize = function(){
    if(resizeTimer) clearTimeout(resizeTimer);
    resizeTimer = setTimeout("initHeight()",100);
 }
function initHeight(){
	var topH = 0; 
	if(navigator.userAgent.indexOf("MSIE")>0) {//IE浏览器
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
	$("#document_main").css( "height",initheight ); 
}
</script> 
</html>