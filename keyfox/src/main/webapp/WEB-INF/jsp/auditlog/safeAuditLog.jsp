<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>日志管理</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript" src="${_resources}datepicker/WdatePicker.js"></script>
<script type="text/javascript">
var menuList;
$(function (){
	//初始化表格
	menuList = $("#menuList").bootstrapTable({
		url : '${_baseUrl}/auditLogController/safeAuditLog?startDate=${startDate}&endDate=${endDate}',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
        columns: [{
        	 field: 'checked',
             checkbox: true
         }, {
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'logName',
            title: '日志名称',
            width: 80/* ,
            formatter : function(value, row, index) {
            	var str="";
				str +="<a onClick=\"editFun('"+row.id+"');\">"+value+"</a>";  
				return str;
			} */
        },{
            field: 'logNameType',
            title: '日志名称类型',
            width: 100
        },
        {
            field: 'ipAddress',
            title: 'IP ',
            width: 100
        },
        {
            field: 'operTime',
            title: '操作时间 ',
            width: 130
        },
        {
            field: 'comments',
            title: '详情',
            align: 'left',
            width: 200
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    startTime:$("#startTime").val(),
		    endTime:$("#endTime").val()
	   }
	}
	
})

function deleteFun(id){
	 var rows= $("#menuList").bootstrapTable('getSelections');
		if(rows.length==0){
			layer.msg("请先选择需要操作的数据");
		}else{
			var rowsString = JSON.stringify(rows); 
			var path="${_baseUrl}/auditLogController/delete";
			 $.ajax({    
					type: "POST",    
					async: false,    
					url:path,   
					data:{
						"rows":rowsString,
					},    
					dataType:"text",    
					success: function (data) {
						layer.msg("删除成功");
						menuList.bootstrapTable('refresh');	
					}   
				}); 
		} 
}
function addFun(){
	 $("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'添加审计',
			autoOpen: true,
			modal: true,	
			height: 600,
			width: 1000
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","100%");
		$("#popIframe").attr("src","${_baseUrl}/auditLogController/addPage");
}
function addSnapshotFun(){
	var rows= $("#menuList").bootstrapTable('getSelections');
	if(rows.length==0){
		layer.msg("请先选择需要操作的数据");
	}else{
		var rowsString = JSON.stringify(rows); 
		var path="${_baseUrl}/auditLogController/addSnapshot";
		 $.ajax({    
				type: "POST",    
				async: false,    
				url:path,   
				data:{
					"rows":rowsString,
				},    
				dataType:"text",    
				success: function (data) {  
					layer.msg("归档成功",{time:2000},function(){
						menuList.bootstrapTable('refresh');	
					});
				}   
			}); 
	} 
}
function editFun(id){
	 $("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'查看详情',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 800
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/auditLogController/editPage?id="+id);
}
function exportExcel(){
	var path= '${_baseUrl}/auditLogController/exportExcel?type=safeAudit&startDate='+$("#startTime").val()+'&endDate='+$("#endTime").val();
	window.location.href=path;
}
/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	var startDate = $("#startTime").val();
	var endDate = $("#endTime").val();
	if(endDate < startDate){
		layer.msg("结束时间不能比开始时间早");
		return;
	}
	menuList.bootstrapTable('refresh',{url:'${_baseUrl}/auditLogController/safeAuditLog?startDate='+startDate+'&endDate='+endDate});
}
</script>

</head>
<body>
<div class="main_cont">
        	<div class="main_c">
                <div class="current_cont">
                    <div class="fl current_c">
                         当前位置 ： <a href="javascript:;">审计管理</a>  >  <a href="javascript:;">审计管理</a>  >  安全审计员审计
                    </div>            
                    <div class="fr current_j">
                        <ul>
                        	<li>
                            	<%-- <shiro:hasPermission name="auditLogController:addSnapshot_3"> --%>
							       <a href="javascript:;" class="current_1" onClick="addSnapshotFun();">归档</a>
							  <%--   </shiro:hasPermission> --%>
                            </li>
                            <li>
                            	<%-- <shiro:hasPermission name="auditLogController:delete_3"> --%>
							       <a href="javascript:;" class="current_5" onClick="deleteFun();">删除</a>
							    <%-- </shiro:hasPermission> --%>
                            </li>
                            <li>
							     <a href="javascript:;" class="current_6" onClick="exportExcel();">导出</a>
                            </li>
                        </ul>
                    </div>
                    <div class="fr current_s1">
                       <dl>
                   			<dt>开始时间:</dt>
                   			<dd><input id="startTime" type="text" value="${startDate }" onFocus="WdatePicker({startDate:'%y-%M-01 00:00:00',dateFmt:'yyyy-MM-dd HH:mm:ss',alwaysUseStartDate:true})" class="input_text current_input"></dd>
                   		</dl>
                   		<dl>
                   			<dt>结束时间:</dt>
                   			<dd><input id="endTime" type="text" value="${endDate }" onFocus="WdatePicker({startDate:'%y-%M-01 00:00:00',dateFmt:'yyyy-MM-dd HH:mm:ss',alwaysUseStartDate:true})" class="input_text current_input"></dd>
                   		</dl>
                   		<dl>
                   			<dt><a href="javascript:refreshTable()">查询</a></dt>
                   		</dl>
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                            
                </div>
                </div>
        <table id="menuList" class="tab-w-01 tab-w-auto"></table>
        </div>
     <div id="popDiv" style="display: none;">
		<iframe id="popIframe"></iframe>
	</div>
</body>
</html>