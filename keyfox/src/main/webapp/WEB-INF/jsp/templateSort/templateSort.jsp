<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html style="overflow:hidden;">
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>文档模板类型</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<link type="text/css" rel="stylesheet" href="${_resources}css/zTreeStyle.css">
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
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
	
	var zNodes = eval('(${zNodes})');
	
	$(document).ready(function(){
		ztree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
		updateParentScope();
		nodes = ztree.getNodes(); 
		ztree.selectNode(nodes[0]);
		$("#currentId").val(nodes[0].id);
		$("#currentName").val(nodes[0].name);
	});
	
	function addDiyDom(treeId, treeNode) {
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_"+treeNode.level)
		aObj.addClass("le_"+treeNode.level)
	};
	
	function onClick(e,treeId, treeNode) {
		treeNodeOnclick(treeNode.id,treeNode.name);
	}
	

	//点击节点时将节点id放到input中
	function treeNodeOnclick(id,name){
		$("#currentId").val(id);
		$("#currentName").val(name);
		
	} 
	
	function updateParentScope(){
		parent.documentTemplateSorts = '${documentTemplateSorts}';
	}
	
	//新增分类
	function  addTemplateSort(){
		var path="${_baseUrl}/templateSortController/judgeNodeGrade";
		var id =$("#currentId").val();
		if(id ==""){
			layer.msg("请选择自定义的分类");
			return false;
		}
		 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"id":id      
			},    
			dataType:"json",    
			success: function (data) { 
				if(data.message == "false"){
					layer.msg("不能再添加子节点");
				}else{
					if(ifOperate("add")){
						$("#popIframe").empty();	
						$("#popDiv").dialog({
							title:'新增模板分类',
							autoOpen: true,
							modal: true,
							position:[40,20],
							height: 180,
							width: 380
						});	
						$("#popIframe").attr("width","100%");
						$("#popIframe").attr("height","95%");
						$("#popIframe").attr("src","${_baseUrl}/templateSortController/addTemplateSortPage?parentId="+id);									
				
					}else{
						layer.msg("请选择自定义的分类");
					}	
				}	
			}   
		}); 
	}	
		
	
	//删除分类
	function delTemplateSort(){
		var id =$("#currentId").val();
		if(id==""){
			layer.msg("请选择要删除的节点");
		}else{
			if(ifOperate("delete")){
				 var path="${_baseUrl}/templateSortController/delTemplateSort";
				 $.ajax({    
						type: "POST",    
						async: false,    
						url:path,   
						data:{
							"id":id      
						},    
						dataType:"json",    
						success: function (data) {   
							layer.msg(data.message);
							refreshTree(data.data);	
						}   
				}); 
			}else{
				layer.msg("请选择自定义的分类");
			}
		}
	}
	//修改分类
	function alter(){
		var id = $("#currentId").val();
		if(id==""){
			layer.msg("请选择要修改的节点");
		}else{
			if(ifOperate("update")){
				var name = $("#currentName").val();
				$("#popIframe").empty();	
				$("#popDiv").dialog({
					title:'修改模板分类信息',
					autoOpen: true,
					modal: true,	
					height: 220,
					width: 450
				});	
				$("#popIframe").attr("width","100%");
				$("#popIframe").attr("height","95%");
				$("#popIframe").attr("src","${_baseUrl}/templateSortController/alterTemplateSortPage?parentId="+id);
			}else{
				layer.msg("请选择自定义的分类");
			}
			
		}
	}
	
	//判断当前选中的分类是否可以新增，删除 ，修改
	function ifOperate (f){
		var result = false;
		var id = $("#currentId").val();
		if(id==""){
			result = false;
		}else{
			var path="${_baseUrl}/templateSortController/ifOperate";
			 $.ajax({    
				type: "POST",    
				async: false,    
				url:path,   
				data:{
					"id":id,
					"method":f
				},    
				dataType:"json",    
				success: function (data) {  
					if(data.code =='1'){
						result = true;
					}else{
						result = false;
					}
				}   
			}); 
		}
		return result;
	}
	
	
    function refreshTree(znode){
    	zNodes = eval(znode);
		ztree =$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		nodes = ztree.getNodes(); 
		ztree.selectNode(nodes[0]);
		$("#currentId").val(nodes[0].id);
		$("#currentName").val(nodes[0].name);
    }
	/* 关闭弹出框 */
	function closeWin(){
		$("#popDiv").dialog('close');
	}		
</script>

<style>
	.ztreexmgli .level_1 a { max-width:300px;}
	.ztreexmgli .level_2 a { max-width:300px;}    // 修改子节点显示宽度
</style> 

</head>
<body style="overflow: hidden; height:387px;">
		<div class="fr" style="top: 0px;">
			 <div class="glqxian_btn mt20">
			 	<shiro:hasPermission name="templateSortController:addTemplateSortPage">
			        <a href="javascript:;" class="glqxian_btn1 fl mr18" onclick="addTemplateSort();">新增</a>
			    </shiro:hasPermission>
				<shiro:hasPermission name="templateSortController:alterTemplateSortPage">
			        <a href="javascript:;" class="glqxian_btn1 fl mr18" onclick="alter();">修改</a>
			    </shiro:hasPermission>
				<shiro:hasPermission name="templateSortController:delTemplateSort">
			        <a href="javascript:;" class="glqxian_btn1 fl" onclick="delTemplateSort();">删除</a>
			    </shiro:hasPermission>
			 </div>
		</div>
	    <div class="menu menulist" style="top:70px;" >
	        <div class="menu_tit">
	      		  文档模板分类
	        </div>
	        <div class="list">
	            <input type="hidden" name ="currentId" id="currentId" value=""/>
	            <input type="hidden" name ="currentName" id="currentName"/>
	            <div class="zTreeDemoBackground list_rolla list_rolla_1 left">
	                <ul id="treeDemo" class="ztree ztreexmgli ztreexmgli2"></ul>
	             </div>        
	         </div>
	     </div> 
    <div id="popDiv" style="display: none;z-index:2000;" >
		<iframe id="popIframe" border="0" frameborder="0" style="overflow: hidden;"></iframe>
	</div>
</body>
</html>