<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>文档预览</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${_resources}js/jquery.ztree.excheck.js"></script>
<script type="text/javascript" src="${_resources}js/jquery.jscrollpane.js"></script>
<script type="text/javascript" src="${_resources}js/jquery.mousewheel.js"></script>

<link rel="stylesheet" href="${_resources}css/zTreeStyle_class.css" />
<link rel="stylesheet" href="${_resources}css/jquery.jscrollpane1.css" />	
<%-- 
<link type="text/css" rel="stylesheet" href="${_resources}css/zTreeStyle_class.css">
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${_resources}js/jquery.ztree.excheck.js"></script>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" /> --%>
<script type="text/javascript">

	var documentId = "${documentId}";
	var projectId = "${projectId}";
	var templateId = "${templateId}";

	var ztree;
	 var setting = {	
			view: {
				showLine: true,
				selectedMulti: false,
				addDiyDom: addDiyDom,

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
				onClick: this.onClick		
			}

		};
	
	var zNodes = eval('(${zNodes})');
	
	$(document).ready(function(){
		ztree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
		
		ztree.expandNode(ztree.getNodeByParam("id","${nodeId}",null));//展开指定节点
		ztree.selectNode(ztree.getNodeByParam("id","${nodeId}",null));//选中指定节点
		ztree.setting.callback.onClick(null, ztree.setting.treeId, ztree.getNodeByParam("id","${nodeId}",null));//触发函数
		replaceRefer();
	});
	
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
	
	function addDiyDom(treeId, treeNode) {
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_"+treeNode.level)
		aObj.addClass("le_"+treeNode.level)
	}; 
	 
	 
	 /*	var setting = {
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
				$("#py").bind("change", setCheck);
				$("#sy").bind("change", setCheck);
				$("#pn").bind("change", setCheck);
				$("#sn").bind("change", setCheck);
			}); 
	 */
	function onClick(e,treeId, treeNode) {
	 	$.ajax({
			url:'${_baseUrl}/sectionController/showSectionContent',
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			data: {sectionId:treeNode.id},
			async: true,
			success: function(data){
				$("#sectionContent").html(data.data);		
	        },
			error:function(){
				layer.msg( "系统错误");
			}
		});
	}
	
	function returnHistory(){
		window.location.href="${_baseUrl}/document/selectSection?templateId="+templateId+"&projectId="+projectId+"&documentId="+documentId;
	}
	
	function submitData(){
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
		var nodes = treeObj.getCheckedNodes(true);
		if(nodes.length==0){
			layer.msg("至少选择一个章节");
			return;
		}
		var sectionJson ="[";
		for(var i=0;i<nodes.length;i++){
			var s = nodes[i].name.indexOf("'");
			// 去掉名称后边的标识
			var marks = nodes[i].name;
			
			var name = replaceMark(marks);
			if(s != -1){
				if(sectionJson=="["){
					
					sectionJson+="{id:'"+nodes[i].id+"',name:"+'"'+name+'"}';
				}else{
					sectionJson+=",{id:'"+nodes[i].id+"',name:"+'"'+name+'"}';
				}
			} else {
				if(sectionJson=="["){
					sectionJson+="{id:'"+nodes[i].id+"',name:'"+name+"'}";
				}else{
					sectionJson+=",{id:'"+nodes[i].id+"',name:'"+name+"'}";
				}
			}
		}
		sectionJson+="]";
		parent.addSelectSection(sectionJson);
		parent.closeWin();
	}
	
	function cancelAndClose(){
		parent.closeWin();
	}
	
	function replaceMark(marks){
		if(marks.indexOf("【") != -1){
			marks = marks.substring(0,marks.indexOf("【"));
			return marks;
		} else {
			return marks;
		}
	}
	
</script>
</head>
<body>
	<%-- <div style="width: 100%;float: left; border: 1px solid green; ">
		<!-------左侧菜单------>
	    <div class="fl menu " style="top:0px;">
	        <div class="menu_tit">${documentName}</div>
	            <div class="list">
	                <div class="zTreeDemoBackground list_rolla1 left">
	                    <ul id="treeDemo" class="ztree ztreea"></ul>
	                </div>        
	            </div>
	         </div>   
	    </div>
	    
	    <div class="popup_tit mtmb10">选择文档模板分类</div>
    	<div class="mubanclass_list">
    	<div class="zTreeDemoBackground left">
            <ul id="treeDemo" name="treeDemo" class="ztree ztreexqzz_a ztreexqzz_c"></ul>
        </div>
   		 </div>
	    
        <!-------中间内容------>
        <div class=" fl" style=" margin-left:255px;width: 100%;height:100%;">
		<h1>内容预览:</h1>		      
        	   
        </div>     
    	
    </div> --%>
    
    <div style="float: left;width: 49%;height: 354px; padding-top:10px; background:#f4f4f4;">
    	<span title="${documentName}" style="display:block; font-size:14px; text-align: center; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; padding:0 20px 0 10px;">${documentName}</span>
    	 <div class="list">
               <div class="zTreeDemoBackground list_rolla1a left" style="width:277px;">
                   <ul id="treeDemo" class="ztree ztreea1027"></ul>
               </div>        
	      </div>
    </div>
    <div style="float: right;width: 49%;height: 354px; padding-top:10px; background:#f4f4f4;">
    	<h1 style="font-size:14px; text-align: center;">内容预览</h1>
    	
    	<div class="section_t1">
    		<div class="section_t1a" id="sectionContent"></div>
    	
    	</div>
    </div>
     <div style="width: 100%;float: left; margin-top:11px;">
     	<div class="permission_an mubanclass_an mt20" >
    	<a href="javascript:;" class="per_baocun"  onclick="submitData();">提 交</a>
        <a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">取 消</a>
    	</div> 
    </div> 
</body>

</html>