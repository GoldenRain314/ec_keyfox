<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户列表</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var menuList;
var deptNameMap;
$.ajax({
	type: "POST",
	url: '${_baseUrl}/departmentController/getParentId',
	dataType: "json",
	async : false,
	success: function(result){
		deptNameMap = result;
	},
	error : function (XMLHttpRequest, textStatus, errorThrown) {
	}
});
$(function (){
	//初始化表格
	menuList = $("#menuList").bootstrapTable({
		url : '${_baseUrl}/userController/select',
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
            field: 'userId',
            title: '用户登陆名',
            width: 100
        },
        {
            field: 'userName',
            title: '用户名称',
            width: 100
        },
        {
            field: 'departId',
            title: '所属部门',
            width: 100,
            formatter : function(value, row, index) {
            	var str=value;
            	for(var i=0; i<deptNameMap.length; i++){
					if (deptNameMap[i].id == value) return deptNameMap[i].deptName;
				}
				return str;
			}
        },{

            field: 'post',
            title: '职务',
            width: 100
        },{

            field: 'email',
            title: '电子邮箱',
            width: 100
        },{

            field: 'officeTelephone',
            title: '办公电话',
            width: 100
        },
        {
            field: 'userStatus',
            title: '用户状态',
            width: 100,
            formatter : function(value, row, index) {
				if (1== value) {
					return "<a onClick=\"statusFun('"+row.id+"','"+value+"');\">禁用</a>";
				}
				return "<a onClick=\"statusFun('"+row.id+"','"+value+"');\">启用</a>";
			}
        },
        {
            field: 'userLock',
            title: '锁定/解锁 ',
            width: 100,
            formatter : function(value, row, index) {
				if (1== value) {
					return "<a onClick=\"lockFun('"+row.id+"','"+value+"');\">锁定</a>";
				}
				return "<a onClick=\"lockFun('"+row.id+"','"+value+"');\">解锁</a>";
			}
        },
        {
            field: 'logout',
            title: '注销/还原 ',
            width: 100,
            formatter : function(value, row, index) {
				if (1== value) {
					return "<a onClick=\"logoutFun('"+row.id+"','"+value+"');\">注销</a>";
				}
				return "<a onClick=\"logoutFun('"+row.id+"','"+value+"');\">还原</a>";
			}
        },
        {
        	field : 'action',
        	title : '操作',
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
				str +="<a onClick=\"editFun('"+row.id+"');\">编辑</a>";  
				str += "&nbsp;";
				str +="<a onClick=\"deleteFun('"+row.id+"');\">删除</a>";
				str += "&nbsp;";
				str +="<a onClick=\"editPwdFun('"+row.userId+"');\">修改密码</a>";
				str += "&nbsp;";
				str +="<a onClick=\"pwdResetFun('"+row.userId+"');\">重置密码</a>";
				return str;
			}
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
	 var path="${_baseUrl}/userController/delete";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"id":id      
			},    
			dataType:"text",    
			success: function (data) {   
			    alert(data);
			    window.location.reload();//刷新当前页面.		
			}   
		}); 
}
function addFun(){
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'添加用户',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 800
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/userController/addPage");

}
function editFun(id){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'修改用户',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/userController/editPage?id="+id);
}
function editPwdFun(userId){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'修改密码',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/userController/editPwdPage?userId="+userId);       
}
function pwdResetFun(userId){

	 $("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'密码重置',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 800
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/userController/pwdResetPage?userId="+userId);
}

function statusFun(id,status){
	 var path="${_baseUrl}/userController/updateStatus";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"id":id,
				"status":status
			},    
			dataType:"text",    
			success: function (data) {   
			    window.location.reload();//刷新当前页面.		
			}   
		});                
}
function lockFun(id,lockStatus){
	 var path="${_baseUrl}/userController/updateLock";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"id":id,
				"lockStatus":lockStatus
			},    
			dataType:"text",    
			success: function (data) {   
			   // alert(data);
			    window.location.reload();//刷新当前页面.		
			}   
		});                
}
function logoutFun(id,logout){
	 var path="${_baseUrl}/userController/updateLogout";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"id":id,
				"logout":logout
			},    
			dataType:"text",    
			success: function (data) {   
			   // alert(data);
			    window.location.reload();//刷新当前页面.		
			}   
		});                
}

</script>

</head>
<body>


<div class="box " >
        <div class="" style="margin:10px;text-align:left;" >
        </div>
        <input type="button" onClick="addFun();" value="新增"/>
        <table id="menuList" class="tab-w-01 tab-w-auto"></table>
        </div>
<div id="popDiv" style="display: none;">
		<iframe id="popIframe"></iframe>
	</div>
</body>
</html>