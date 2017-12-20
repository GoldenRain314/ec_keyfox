<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>任务分配</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var taskAssignList;
var projectId = "${projectId}";
var id = "${id}";
$(function (){
	var  random= Math.random();
	$("#taskAssign", window.parent.document).removeAttr("disabled"); 
	taskAssignList = $("#taskAssignList").bootstrapTable({
		url : '${_baseUrl}/documentList/getTaskDocumentList?projectId='+projectId+'&type=${type}&number='+random,
		pagination: true,
		pageList: [50],
  		queryParams: queryParams,
  		columns: [{
       	 field: 'checked',
         checkbox: true
     	},{
           field: 'id',
           title: 'id',
           visible:false,
           width: 5
       },{
           field: 'projectId',
           title: 'projectId',
           visible:false,
           width: 5
       },{
           field: 'serial',
           title: '序号',
           width: 50,
           formatter : function(value, row, index) {
           	if(status){
           		var str=value;
           	}else{
           		var str=index+1;
           	}
			return str;
           }
       },{
            field: 'templateName',
            title: '工作产品',
            width: 100
        },{
            field: 'startTime',
            title: '预计开始时间',
            width: 100,
            formatter:function(value,row,index){
            	if(value == "" || value == null){
            		return value;
            	}else{
            		return value.substring(0,value.length - 3);
            	}
            }
        },{
            field: 'endTime',
            title: '预计结束时间',
            width: 100,
            formatter:function(value,row,index){
            	if(value == "" || value == null){
            		return value;
            	}else{
            		return value.substring(0,value.length - 3);
            	}
            }
        },{
            field: 'documentManagerName',
            title: '文档负责人',
            width: 100
        },{
            field: 'documentTeamPeopleName',
            title: '协同编制人员',
            width: 100
        },{
            field: 'operation',
            title: '操作',
            width: 20,
            formatter : function(value, row, index) {
 					return "<a onClick=\"editProjectDocument('"+row.id+"','"+row.projectId+"');\">编辑</a>";
 			}
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: 50,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order
	   }
	}
})
function editProjectDocument(id,projectId){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'项目文档编制任务分配',
		autoOpen: true,
		modal: true,	
		height: 470,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/document/editProjectDocument?id="+id+"&projectId="+projectId);
}
/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}
function refreshWin(){
	layer.msg("编辑成功",{shift:1},function(){
		window.location.reload(true);
		closeWin();
	});
	
}
function batchEditDocument(){
	var objects =  $("#taskAssignList").bootstrapTable('getSelections');
	if(objects.length < 1){
		layer.msg("还没有选择文档");
		return;
	}
	var obj = JSON.stringify(objects); 
	var jsonObj=eval("("+obj+")");
	var ids = new Array();
 	for(var i in jsonObj){
 		ids[i] = jsonObj[i].id;
 	}
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'项目文档编制任务分配',
		autoOpen: true,
		modal: true,	
		height: 550,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/document/editProjectDocument?ids="+ids+"&projectId="+projectId);
}
function gotoProjectAndDocument(){
	$.ajax({
		url:'${_baseUrl}/documentList/checkTaskIsOrAssign',
		type:'post', //数据发送方式 
		dataType:'text', //接受数据格式 
		data:{"projectId":projectId},
		async: false,
		success: function(data){
			 if(data == "success"){
				 layer.load(2);
				 var path="${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&id="+id+"&source=taskAssign";
				 window.parent.location.href=path;
			 }else if(data == "fail"){
				 layer.msg("没有完成项目所有工作产品的任务分配");
			 }else if(data == "error"){
				 layer.msg("该项目下还没有文档");
			 }
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
	/* var path="${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&id="+id+"&source=taskAssign";
	window.parent.location.href=path; */
}
function closeWin(){
	$("#popDiv").dialog('close');
}
</script>
</head>
<body>
     <div class="xmugonj_cont ma" style="display:block;">
         <div class="xmugonj_ta_j task_cont widthauto">
     	 <div class="glqxian_btn xmugonj_btn3 mtmb20">
     	 	<shiro:hasPermission name="document:editProjectDocument">
	            <a href="javascript:;" class="fr glqxian_btn1" onclick="batchEditDocument();">批量填写</a>
	        </shiro:hasPermission>	
     	 </div>
         <div class="xmugonj_ta_j task_cont widthauto">
         	<table id="taskAssignList" class="tab-w-01 tab-w-auto"></table>   
			<div class="permission_an xmugonj_bc ma">
				<shiro:hasPermission name="documentList:showProjectAndDocument">
		           <a href="javascript:;" class="per_baocun" onClick="gotoProjectAndDocument();">保 存</a>
		        </shiro:hasPermission>	
            </div>
         </div>
         </div>
    </div>
	<div class="clear"></div>
	<div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>
</body>
</html>