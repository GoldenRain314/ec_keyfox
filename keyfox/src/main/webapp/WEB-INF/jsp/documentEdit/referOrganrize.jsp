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
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript">
	var ztree;
	var menuName="";
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
	});
	
	function addDiyDom(treeId, treeNode) {
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_"+treeNode.level);
		aObj.addClass("le_"+treeNode.level);
	};
	
	function onClick(e,treeId, treeNode) {
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		zTree.expandNode(treeNode);
		menuName = treeNode.name;
		var div = document.getElementById("rightIframe");
		div.src ="${_baseUrl}"+treeNode.menuUrl+"?menuId="+treeNode.menuId+"&source=${source}&setPageSize=${setPageSize}";
	}
	
	//提交数据
	function submitData(){
		if(menuName=="软件管理类"||menuName=="软件测试类"||menuName=="软件设计类"){
			layer.msg("请先选择可引用的数据分类",{time:1500});
			return;
		}
		var selectId = document.getElementById('rightIframe').contentWindow.getSelect();
		if(selectId==""){
			layer.msg("请先选择要引用的数据",{time:1500});
			return;
		}
		
		$.ajax({    
			type: "POST",    
			async: false,    
			url:"${_baseUrl}/referOrganize/insertOrganize",
			data:{
				"selectId":selectId,
				"menuName":menuName,
				"sectionId":"${sectionId}"
			},
			dataType:"json",    
			success: function (data) {   
				layer.msg(data.message,{time:2000},function(){
					parent.closeWin();
				});
				
			},
			error:function(){
				layer.msg("系统错误，请重新选择引用",{time:2000},function(){
					parent.closeWin();
				});
			}
		}); 	
	}
   function cancelAndClose(){
	   parent.closeWin();
   }
</script>
</head>
<body>
	<div class="ma main">
		<!-------左侧菜单------>
	    <div class="fl menu" style="height:434px;">
	        <div class="menu_tit">${menuInfo.menuName }</div>
	            <div class="list">
	                <div class="zTreeDemoBackground list_rolla2a left">
	                    <ul id="treeDemo" class="ztree ztreexmgli"></ul>
	                </div>        
	            </div>
	    </div>
		
        <!-------中间内容------>
        <div class="iframe_yhgl1" style="height:434px; padding-left:250px;">
        	<iframe id="rightIframe" frameborder="0" style="width:100%; height:100%;" src=""></iframe>     
        </div>    
        
	     <div class="zuzhizyy_btn">
	    
	     	<div class="permission_an mubanclass_an mt20" >
	    	<a href="javascript:;" class="per_baocun"  onclick="submitData();">提 交</a>
	        <a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">取 消</a>
	    	</div> 
	    </div>  
         
    	<div class="clear"></div>
    </div>
</body>
</html>