<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link type="text/css" rel="stylesheet" href="${_resources}css/zTreeStyle_class.css">
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${_resources}js/jquery.ztree.excheck.js"></script>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<title>添加菜单</title>

<script type="text/javascript">

var setting = {
		check: {
			enable: true
		},
		data: {
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "pId"
			}
		}
	};

	var zNodes =eval('(${zNodes})');
	
	var code;
	
	function setCheck() {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
		py = $("#py").attr("checked")? "p":"",
		sy = $("#sy").attr("checked")? "s":"",
		pn = $("#pn").attr("checked")? "p":"",
		sn = $("#sn").attr("checked")? "s":"",
		type = { "Y":py + sy, "N":pn + sn};
		zTree.setting.check.chkboxType = type;
		showCode('setting.check.chkboxType = { "Y" : "' + type.Y + '", "N" : "' + type.N + '" };');
	}
	function showCode(str) {
		if (!code) code = $("#code");
		code.empty();
		code.append("<li>"+str+"</li>");
	}
	
	$(document).ready(function(){
		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		setCheck();
		sub();
		$("#py").bind("change", setCheck);
		$("#sy").bind("change", setCheck);
		$("#pn").bind("change", setCheck);
		$("#sn").bind("change", setCheck);
	});

function judgeSelectTemplateSort(){
	var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
	var nodes = treeObj.getCheckedNodes(true);
	var name="";
	var id="${sortId}";
	var ids = "";
	for(var i=0;i<nodes.length;i++){
		if(name.length>0){
			name  +=";"+nodes[i].name;
		}else{
			name  =nodes[i].name;
		}
		if(ids.length>0){
			ids  +=","+nodes[i].id;
		}else{
			ids = nodes[i].id;
		}
	}
	if(id!=null&&id!=""){
		setDocumentSort(id,ids);
	}else{
		var documentType = $("#documentType", window.parent.document);
		var documentTypeName = $("#documentTypeName", window.parent.document);
		$(documentTypeName).attr("readonly","");
		$(documentTypeName).val(name);
		$(documentType).val(ids);
		$(documentTypeName).attr("readonly","readonly");
		parent.closeWin();
	}	
}

function setDocumentSort(id,name){
	var path="${_baseUrl}/documentTemplateController/reSetTemplateSortInfo";
	 $.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"id":id,
			"templateSort":name
		},    
		dataType:"json",    
		success: function (data) { 
			layer.msg(data.message,{shift:5,time:1500},function(){
				parent.closeWin();
			    parent.refreshTable();	
			});
		}   
	}); 
}
//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}	

function sub(){
	var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
	treeObj.expandAll(true);    // 展开所有子节点 
	for( var i=0; i< zNodes.length+1; i++){
		if(zNodes[i] != undefined)
			$("#treeDemo_"+(i+1)+"_span").html(subProjectName(zNodes[i].name));
	}
}
 function subProjectName(name){
	if(name.length>20){
		name = name.substring(0,20);
		name += "...";
	}
	return name;
} 

</script>
</head>
<body>
<div class="mubanclass">
	<div class="popup_tit mtmb10">选择文档模板分类</div>
    <div class="mubanclass_list">
    	<div class="zTreeDemoBackground left">
            <ul id="treeDemo" name="treeDemo" class="ztree ztreexqzz_a ztreexqzz_c"></ul>
        </div>
    </div>
    
    <div class="permission_an mubanclass_an mt20">
    	<a href="javascript:;" class="per_baocun"  onclick="judgeSelectTemplateSort();">提 交</a>
        <a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">取 消</a>
    </div>   
</div>

</body>
</html>