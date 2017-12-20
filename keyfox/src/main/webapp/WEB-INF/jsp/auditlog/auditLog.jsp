<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<script type="text/javascript">
var menuList;
$(function (){
	//初始化表格
	menuList = $("#menuList").bootstrapTable({
		url : '${_baseUrl}/auditLogController/select',
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
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
				str +="<a onClick=\"editFun('"+row.id+"');\">"+value+"</a>";  
				return str;
			}
        },{
            field: 'logNameType',
            title: '日志名称类型',
            width: 100
        },{
            field: 'userId',
            title: '用户账号',
            width: 100
        },
        {
            field: 'userName',
            title: '用户名',
            width: 100
        },{
            field: 'deptName',
            title: '部门 ',
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
            width: 100
        },
        {
            field: 'comments',
            title: '详情',
            width: 100
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order
	   }
	}
	
})

function deleteFun(id){
	 var rows= $("#menuList").bootstrapTable('getSelections');
		if(rows.length==0){
			layer.msg("请先选择删除信息");
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
/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	menuList.bootstrapTable('refresh');
}
</script>

</head>
<body>
<div class="main_cont">
        	<div class="main_c">
                <div class="current_cont">
                    <div class="fl current_c">
                         当前位置 ： <a href="javascript:;">审计管理</a>  >  <a href="javascript:;">审计管理</a>  >  管理员审计
                    </div>            
                    <div class="fr current_j">
                        <ul>
                            <li><a href="javascript:;" class="current_1" onClick="addFun();">归档</a></li>
                            <li><a href="javascript:;" class="current_2" onClick="deleteFun();">删除</a></li>
                            <div class="clear"></div>
                        </ul>
                    </div>
                    <div class="fr current_s">
                        <div class="fl current_s_i"><input name="" type="text" class="input_text1" value="搜索您想寻找的..." onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
                        <div class="fl current_s_a"><input name="" type="button" value="高级搜索" class="input_btn1"></div>
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