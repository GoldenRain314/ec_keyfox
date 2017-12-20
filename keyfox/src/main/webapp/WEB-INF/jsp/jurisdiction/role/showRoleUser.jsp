<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>角色成员</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />

<script type="text/javascript">
var userList;
$(function (){
	userList = $("#userList").bootstrapTable({
		url : '${_baseUrl}/role/getRoleUserList',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{
        	 field: 'checked',
             checkbox: true,
             formatter: function(value, row, index){
               	if(row.userId == 'admin' || row.userId == 'safeaudit' || row.userId == 'safesecret'){
               		return {
                          disabled: true
                      };
               	}
             }
         }, {
             field: 'id',
             title: 'id',
             visible:false,
             width: 5
         },{
            field: 'userName',
            title: '姓名',   /* 修改标题名称  */
            width: 100,
            formatter: function(value, row, index){
               	if(row.userStatus == "1" || row.userLock == "1" || row.logout == "1"){
               		return "<span style='color:#C0C0C0'>"+value+"</span>";
               	}else{
               		return value;
               	}
               	
             }
        },{
            field: 'userId',
            title: '用户账号',
            width: 100,
            formatter: function(value, row, index){
               	if(row.userStatus == "1" || row.userLock == "1" || row.logout == "1"){
               		return "<span style='color:#C0C0C0'>"+value+"</span>";
               	}else{
               		return value;
               	}
               	
             }
        },{
            field: 'departName',
            title: '部门',
            width: 100,
            formatter: function(value, row, index){
               	if(row.userStatus == "1" || row.userLock == "1" || row.logout == "1"){
               		return "<span style='color:#C0C0C0'>"+value+"</span>";
               	}else{
               		return value;
               	}
               	
             }
        },{
            field: 'userCreationTime',
            title: '创建日期',
            width: 100,
            formatter: function(value, row, index){
               	if(row.userStatus == "1" || row.userLock == "1" || row.logout == "1"){
               		return "<span style='color:#C0C0C0'>"+value+"</span>";
               	}else{
               		return value;
               	}
             }
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    roleId : '${roleId}'
	   }
	}
	
	/* 添加关联关系 */
	$("#addUser").click(function (){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'添加角色成员',
			autoOpen: true,
			modal: true,	
			height: 350,
			width: 700
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","100%");
		$("#popIframe").attr("src","${_baseUrl}/role/showAddRoleUser?roleId=${roleId}");
	});
	
	/* 删除关联用户 */
	$("#delUser").click(function (){
		var selected = userList.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要操作的数据");
			return false;
		}
		var userIds = [];
		for(i in selected){
			userIds.push(selected[i].id);
		}
		
		$.ajax({
			url : "${_baseUrl}/role/delUserRole",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {userIds : userIds.join(','),roleId:"${roleId}"},
			success : function(json) {
				layer.msg(json.message);
				refreshTable();
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	});
	
	
	
})

/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	userList.bootstrapTable('refresh');
}


</script>
</head>
<body>
<div class="wdang_main">
       	<div class="glqxian_btn xmugonj_btn2 mb20">
       		<shiro:hasPermission name="role:showAddRoleUser">
		        <a href="javascript:;" class="fr glqxian_btn1" id="addUser">新增</a>
		    </shiro:hasPermission>
	       	<shiro:hasPermission name="role:delUserRole">
		        <a href="javascript:;" class="fr glqxian_btn1 glqxian_btn1_1 mr18" id="delUser">删除</a>
		    </shiro:hasPermission>
       	</div>
      	<div class="personnel_cont">
	    <table id="userList" class="tab-w-01 tab-w-auto" width="100%" border="0" cellspacing="0" cellpadding="0">
	    </table>
	</div>
  </div>
<div id="popDiv" style="display: none;overflow: hidden;">
	<iframe id="popIframe" border="0" frameborder="0"></iframe>
</div>

</body>
</html>