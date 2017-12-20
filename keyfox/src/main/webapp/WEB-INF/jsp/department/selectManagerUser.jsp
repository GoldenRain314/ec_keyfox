<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择人员</title>
</head>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0 minimal-ui"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<link type="text/css" rel="stylesheet" href="${_resources}css/base.css">
<link type="text/css" rel="stylesheet" href="${_resources}css/style.css">
<link type="text/css" rel="stylesheet" href="${_resources}css/response.css">
<link type="text/css" rel="stylesheet" href="${_resources}css/zTreeStyle_class.css">
<link type="text/css" rel="stylesheet" href="${_resources}css/jquery.jscrollpane1.css">
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript" src="${_resources}js/jquery.js"></script>
<script type="text/javascript" src="${_resources}js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${_resources}js/jquery.ztree.excheck.js"></script> 
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script> 
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<script type="text/javascript" src="${_resources}layer/layer.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script language="javascript" type="text/javascript" src="${_resources}js/jquery.jscrollpane.js"></script>
<script language="javascript" type="text/javascript" src="${_resources}js/jquery.mousewheel.js"></script>
<script type="text/javascript">
if (!Array.prototype.indexOf){  
    Array.prototype.indexOf = function(elt /*, from*/){  
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
var userListHtml="";
var userIdList="";
var userNameList="";
var selectUserList = [];
var managerIdSplit = "";
var checkedHtml = "";
$(function (){
	var managerIds = "${managerId}";
	managerIdSplit = managerIds.split(",");
	$("#save").click(function (){
		var inputId='${inputId}';
		var stringJson = "["+selectUserList.join(",")+"]";
		
		//修改Bug[3328] [#3328] 程序错误，部门管理人不是必填项，但修改时无法取消勾选
		if(inputId == "charge" || inputId == "project_manager"){
			if(stringJson.indexOf("},{") >= 0){
				layer.msg("您只能选择一个负责人");
				return;
			}else if(stringJson.length == 2){
				layer.msg("您还没有选择负责人");
				return;
			}
		} else if(inputId == "manager"){
			if(stringJson.indexOf("},{") >= 0){
				layer.msg("您只能选择一个负责人");
				return;
			}
		}
		parent.setUserIdAndName(stringJson,inputId);
		parent.closeWin();
	});
	
	$("#close").click(function (){
		parent.closeWin();
	});
	
	$("#allDelFun").click(function (){
		userListHtml="";
		userIdList="";
		userNameList="";
		$("#userList").html(userListHtml);
	});
	
	$("#delFun").click(function (){
		parent.closeWin();
	});
	
	$("#searchValue").keydown(function(event) {//给输入框绑定按键事件
	    if(event.keyCode == "13") {//判断如果按下的是回车键则执行下面的代码
	    	search();
	  	}
	})
	
	$("#search").click(function (){
		search();
	});
	
	function search(){

		//要搜索的值
		var value = $("#searchValue").val();
		
		//获取选择的目录：
		var path="${_baseUrl}/userController/selectDepartUser";
	 	 $.ajax({    
			type: "post",    
			async: false,    
			url:path,   
			data:{
				"value":value
			},    
			dataType:"json",    
			success: function (data) {   
			    var obj = JSON.stringify(data);
			    innerHtml="";
			    if(obj=="[]"){
					innerHtml+=""; 
				}else{ 
					var tree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
					var nodes = tree.transformToArray(tree.getNodes()); 
					if(value=='搜索您想寻找的...'){
						tree.selectNode(tree.getNodeByParam("id",nodes[0].id,null));//选中指定节点
					}else{
						var count = 0;
						var depId ="";
						for(var i=0;i<data.length;i++){
							if(depId ==""){
								depId  = data[i].departId;
								count++;
							}else{
								if(depId !=data[i].departId){
									count++;
								}
							}
						}
						if(count>1){
							tree.selectNode(tree.getNodeByParam("id",nodes[0].id,null));//选中指定节点
						}else{
							if(data[0].departId ==null||data[0].departId =="null"||data[0].departId==""){
								tree.selectNode(tree.getNodeByParam("id",nodes[0].id,null));//选中指定节点
							}else{
								tree.selectNode(tree.getNodeByParam("id",depId,null));//选中指定节点
							}
						}
					}
					for(var i=0;i<data.length;i++){	
					    if (!Array.prototype.indexOf){  
				            Array.prototype.indexOf = function(elt /*, from*/){  
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
						
						//var index = managerIdSplit.indexOf(data[i].id);
						
						if(managerIdSplit.indexOf(data[i].id) >= 0){
							innerHtml+="<p><input checked='checked' class='chk_all' name='"+data[i].id+"_chk' id='"+data[i].id+"' value='"+data[i].userName+"' type='radio' onClick=\"addSelectUser('"+data[i].userId+"','"+data[i].userName+"','"+data[i].id+"');\"><span>"+data[i].userName+"</span></p>";
							//判断如果右侧已存在，则不需要在加入
							var flag = true;
							for(var ii=0;ii<selectUserList.length;ii++){
					 			var obj = JSON.parse(selectUserList[ii]);
					 			if(data[i].id == obj.id){
					 				flag = false;
					 			}
					 		}
							if("${team_id}".indexOf(data[i].id) >= 0){
								flag =false;
							}
							
							if(flag){
						 		selectUserList = [];
								selectUserList.push("{\"userId\":\""+data[i].userId+"\",\"userName\":\""+data[i].userName+"\",\"id\":\""+data[i].id+"\"}");
						 		var html = "<p id='p_"+data[i].id+"'><input type='hidden' id='userId' name='userId' value='"+data[i].userId+"'/><input type='hidden' id='userName' name='userName' value='"+data[i].userName+"'/><span>"+data[i].userName+"</span></p>";
						 		$("#selectUser").html("");
						 		$("#selectUser").append(html); 
							}
							
						}else{
							
							if("${team_id}".indexOf(data[i].id)<0 ){
								innerHtml+="<p><input class='chk_all' name='"+data[i].departId+"_chk' id='"+data[i].id+"' value='"+data[i].userName+"' type='radio' onClick=\"addSelectUser('"+data[i].userId+"','"+data[i].userName+"','"+data[i].id+"');\"><span>"+data[i].userName+"</span></p>";
							}	
						}
					}
				}                 
			    $("#userList").children("p").remove();
				$("#userList").append(innerHtml); 
				
				//默认选中右侧已有人员
				for(var i=0;i<selectUserList.length;i++){
		 			var obj = JSON.parse(selectUserList[i]);
		 			$("#"+obj.id).attr("checked",true);
		 		}
				
			}   
		});
	}

});

	var setting = {	
		view: {
			showLine: true,
			selectedMulti: false,
			addDiyDom: addDiyDom
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			onNodeCreated: this.onNodeCreated,				
			onClick: onClick		
		}
	
	};
	var zNodes = eval("${zNodes}");

	$(function (){
		var tree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
		
		var nodes = tree.transformToArray(tree.getNodes()); 
		for(var lt=0;lt<nodes.length;lt++){
			var node = nodes[lt];
			//var nodeName = node.name;
			
			//if(nodeName == "所有部门"){
			if(lt==0){
				tree.setting.callback.onClick(null, tree.setting.treeId, node);//触发函数
			}
			
			//}
		}
		
		if($(".zzjgs_sorll").size()>0){
			$('.zzjgs_sorll').jScrollPane();
		}
		if($(".mulu_jieg").size()>0){
			$('.mulu_jieg').jScrollPane();
		}
		
	});
	
	function addDiyDom(treeId, treeNode) {
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_"+treeNode.level);
		aObj.addClass("le_"+treeNode.level);
	};
	
	 if (!Array.prototype.indexOf){  
         Array.prototype.indexOf = function(elt /*, from*/){  
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
	
	function onClick(e,treeId, treeNode){
		var path = "";
		if("${set_document_departId}" != ''){
			path="${_baseUrl}/userController/selectDepartUser?set_document_departId=${set_document_departId}";
		}else if("${source}" != ''){
			path="${_baseUrl}/userController/selectDepartUser?source=${source}";
		}else{
			path="${_baseUrl}/userController/selectDepartUser";
		}
		
	 	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"departId":treeNode.id     
			},    
			dataType:"json",    
			success: function (data) {   
			    var obj = JSON.stringify(data);
			    innerHtml="";
			    if(obj=="[]"){
					innerHtml+=""; 
				}else{  
					for(var i=0;i<data.length;i++){	
						if(managerIdSplit.indexOf(data[i].id) >= 0){
							innerHtml+="<p><input class='chk_all' checked='checked' name='"+treeNode.id+"_chk' id='"+data[i].id+"' value='"+data[i].userName+"' type='radio' onClick=\"addSelectUser('"+data[i].userId+"','"+data[i].userName+"','"+data[i].id+"');\"><span>"+data[i].userName+"</span></p>";
							//判断如果右侧已存在，则不需要在加入
							var flag = true;
							for(var ii=0;ii < selectUserList.length;ii++){
					 			var obj = JSON.parse(selectUserList[ii]);
					 			if(data[i].id == obj.id){
					 				flag = false;
					 			}
					 		}
							
							if("${team_id}".indexOf(data[i].id) >= 0){
								flag = false;
							}	
							if(flag){
								selectUserList = [];
								selectUserList.push("{\"userId\":\""+data[i].userId+"\",\"userName\":\""+data[i].userName+"\",\"id\":\""+data[i].id+"\"}");
						 		var html = "<p id='p_"+data[i].id+"'><input type='hidden' id='userId' name='userId' value='"+data[i].userId+"'/><input type='hidden' id='userName' name='userName' value='"+data[i].userName+"'/><span>"+data[i].userName+"</span></p>";
						 		$("#selectUser").html("");
						 		$("#selectUser").append(html);
							}
							
						}else{
							
							if("${team_id}".indexOf(data[i].id) < 0 ){
								innerHtml+="<p><input class='chk_all' name='"+treeNode.id+"_chk' id='"+data[i].id+"' value='"+data[i].userName+"' type='radio' onClick=\"addSelectUser('"+data[i].userId+"','"+data[i].userName+"','"+data[i].id+"');\"><span>"+data[i].userName+"</span></p>";
							}
						}
					}
				}                 
			    $("#userList").children("p").remove();
				$("#userList").append(innerHtml); 
				
				//默认选中右侧已有人员
				for(var i=0;i<selectUserList.length;i++){
		 			var obj = JSON.parse(selectUserList[i]);
		 			$("#"+obj.id).attr("checked",true);
		 		}
				
			}   
		});
	}
	
	function disabledNode(e) {
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		disabled = e.data.disabled,
		nodes = zTree.getSelectedNodes();
		if (nodes.length == 0) {
			layer.msg("请先选择一个节点");
		}
	
		for (var i=0, l=nodes.length; i<l; i++) {
			zTree.setChkDisabled(nodes[i], disabled);
		}
	}
	
	/* 选择一个节点添加到右侧 */
 	function addSelectUser(userId,userName,id){
	 	$("#selectUser").html(""); 
	 	//修改Bug[3328] [#3328] 程序错误，部门管理人不是必填项，但修改时无法取消勾选
	 	$('.chk_all').each(function(){
	        	$(this).change(function() { 
	        		 if($(this).attr('checked')){
	 	                $('.chk_all').removeAttr('checked');
	 	                $(this).attr('checked','checked');
	 	            }
	        	}); 
		});
	 	if('${inputId}' == 'manager'){
	 		if($("#"+id).attr("checked")){
				selectUserList.length=0;
		 		selectUserList.push("{\"userId\":\""+userId+"\",\"userName\":\""+userName+"\",\"id\":\""+id+"\"}");
		 		var html = "<p id='p_"+id+"'><input type='hidden' id='userId' name='userId' value='"+userId+"'/><input type='hidden' id='userName' name='userName' value='"+userName+"'/><span>"+userName+"</span></p>";
		 		$("#selectUser").append(html); 
			} else{
				selectUserList.length=0;
			} 
	 	} else{
	 		if($("#"+id).attr("checked")){
				selectUserList.length=0;
		 		selectUserList.push("{\"userId\":\""+userId+"\",\"userName\":\""+userName+"\",\"id\":\""+id+"\"}");
		 		var html = "<p id='p_"+id+"'><input type='hidden' id='userId' name='userId' value='"+userId+"'/><input type='hidden' id='userName' name='userName' value='"+userName+"'/><span>"+userName+"</span></p>";
		 		$("#selectUser").append(html); 
			}
	 		//[#3505] 功能修复：选择项目文档负责人后无法保存（偶现） 复现：快速搜素，在结果中先选中一个人，再选下方的会出现，选择上方的不出现；如果不搜索，不会出现
	 		//在人员切换的瞬间有2个人被选中，排列顺序是按照列表顺序的；selectUserList始终只有一个，并且是第二次点击的
	 		//如果第二次点击是下面的，那么条件满足就把selectUserList删掉了，保存时从selectUserList读取不到数据,就提示没有选择负责人。
			//for(var i=0;i<selectUserList.length;i++){
	 		//	var obj = JSON.parse(selectUserList[i]);
	 		//	if($($("input:checked")[0]).attr("id") != obj.id){
	 		//		selectUserList.splice(i,1);
	 		//	}
	 		//}
	 	}
		
	}
	
</script>
<body>
<div class="catalog_popup">
    <div class="catalog_lb catalog_li1">
        <div class="catalog_popup_t"><a href="javascript:;">目录结构</a></div>
        <div class="catalog_list">
            <div class="zTreeDemoBackground mulu_jieg left">
                <ul id="treeDemo" class="ztree ztree_mulu"></ul>
            </div> 
        </div>
        
    </div>
    <div class="catalog_lb catalog_li2">
        <div class="catalog_popup_t"><a href="javascript:;">组织机构树</a></div>
        <div class="zzjgs_sorll" style="margin-top:10px;">
	        <div class="zzjgs_cont" id="userList" style="padding:0 0 0 26px;">
	            
	        </div>
        </div>
    </div>
    <div class="catalog_lb catalog_li3">
        <div class="current_s catalog_s" style="margin:21px 0 0 10px;">
            <div class="fl current_s_i"><input name="" id="searchValue" type="text" class="input_text1" value="搜索您想寻找的..." onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
            <div class="fl current_s_a"><a id="search"><input name="" type="button" value="快速搜索" class="input_btn1"></a></div>
            <div class="clear"></div>
        </div>
        <div class="yxuan_list" style="margin:24px 0 0 16px;">
            <span class="yxuan_list_t">已选列表</span>
            <div class="yxuan_list_c" id="selectUser" style="padding:5px; height:369px; line-height:24px;">
            	
            </div>
        
        </div>
        
    </div>

</div>

<div class="permission_an mubanclass_an ma mt30">
    <a href="javascript:;" class="per_baocun" id="save">保 存</a>
    <a href="javascript:;" class="per_gbi" id="close">关 闭</a>
</div>
</body>
</html>