<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html style="overflow:auto; width:544px; height:600px;">
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
var reuseSectionId= "${reuseSectionId}";
var reuseSectionName= "${reuseSectionName}";
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
		if(nodes[i].level < 3){
			leftTree.expandNode(nodes[i]);
		}
			
	}

	 replaceRefer();
	
	 initSectionContent(reuseSectionId);
	
	initTreeColor(reuseSectionId);
	$("#documentList").change();
	
	
});
function  initTreeColor(reuseSectionId){

	var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
	var node = treeObj.getNodeByParam("id", reuseSectionId, null);
	treeObj.selectNode(node);
}
function addDiyDom(treeId, treeNode) {
	var liObj = $("#" + treeNode.tId);
	var aObj = $("#" + treeNode.tId + "_span");
	liObj.addClass("level_"+treeNode.level);
	aObj.addClass("le_"+treeNode.level);
};

function onClickLeft(e,treeId, treeNode){
	left_sectionId = treeNode.id;
	sectionId = treeNode.id;
	
	var sectionName=treeNode.name;
	$("#sectionIds").val(sectionId);
	$("#sectionNames").val(sectionName);
	//1、初始化右侧的树
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
//初始化章节内容
function initSectionContent(id){
	left_sectionId = id;
	sectionId = id;
	$.ajax({
		url:'${_baseUrl}/dd/selectSectionContentBySectionId?rand='+Math.random(), 
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		data:{"sectionId":id},
		async: false,
		success: function(data){
			$("#left_content").html(data.content);
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
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



function initLeftTree(){
	$.ajax({
		url : "${_baseUrl}/documentSectionController/trackSectionTree",
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {documentId : "${reuseDocumentIds}",projectId:"${projectId}"},
		success : function(json) {
			zNodesLeft = eval('('+json.zNodes+')');				
			$("#leftTree").html(json.documentName+json.documentVersion);
			$("#documentName").html(json.documentName);
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
	  				documentId : "${reuseDocumentIds}",
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
  	})
}


function returnHistory(){
	
	var  random= Math.random();
	var referrer = document.referrer;
	if(referrer.indexOf("/dd/showDemandDocumentList") > 0){
		history.go(-1);
	}else{
		parent.skipModule("文档编写","${_baseUrl}/documentSectionController/sectionTree?projectId=${projectId}&documentId=${documentId}&status=${status}&isOk=${isOk}&random="+random);
	}
}



function setLeft(){
	var divs =$("div.jspPane");
 	$.each(divs, function (i, item) {
 		$(item).css("left","0px");
 	})
}

function save(id){
	var changeId = $("#sectionIds").val();
	var thisReuseDocumentIds = "${reuseDocumentIds}";
	if(changeId == ""){
		layer.msg("请选择引用文档章节");
		return false;
	}
	if(changeId == thisReuseDocumentIds){
		layer.msg("请选择引用文档章节");
		return false;
	}
	
	$.ajax({
		url : "",
		type : "post",
		dataType : "json",
		async : false,
		data : {
			id:id,
			reuseSectionId:$("#sectionIds").val(),
			reuseSectionName:$("#sectionNames").val()
		},
		success : function(data) {
			if(data.message == "请选择未建立过复用关系的章节"){
				layer.msg("请选择未建立过复用关系的章节");
				return false;
			}
		}
	});
	
	$.ajax({
			url : "${_baseUrl}/demand/updateReuse",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {
	  				id:id,
	  				reuseSectionId:$("#sectionIds").val(),
	  				reuseSectionName:$("#sectionNames").val(),	  					  			
	  				//showTraceSectionId:$("#showTraceSectionId").val(),
	  				
	  			},
			success : function(json) {
				layer.msg(json.message);
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	 
};

function giveBack(){
	parent.closewin();
	parent.refreshTable();
}
</script>
<body>
    <div class="document_main" >    
        <div class="xiugaixq_cont">
        <div class="xiugaixq_box" style="width:544px;">        	 
        	<div class="clear"></div>      
        </div>        
        <div class="xiugaixq_list_cont" style="width:544px;">
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
            		<div id="left_content" class="xiugaixq_texta" ></div>
            	</div>
           	</div>          
        
        </div> 
         <input type="hidden" id="sectionIds" value="${sectionIds}">
          <input type="hidden" id="sectionNames" value="${sectionNames}">
        </div>
       
         <div class="permission_an xiugaixq_anw mt30" style="padding-top: 550px; padding-bottom:50px; width:544px;">
        	
		        <a onclick="save('${id}')" class="per_baocun" id="save">确定</a>

		        <a onclick="giveBack()" class="per_gbi" >返回</a>
		
        </div>
    </div>
    
</body>


</html>