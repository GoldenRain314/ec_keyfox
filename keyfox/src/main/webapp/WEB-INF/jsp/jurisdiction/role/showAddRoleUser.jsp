<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加用户</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />

<script type="text/javascript">
var userList;
$(function (){
	userList = $("#userList").bootstrapTable({
		url : '${_baseUrl}/role/getAddRoleUserList',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{
        	 field: 'checked',
             checkbox: true
         }, {
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'userName',
            title: '姓名',
            width: 100
        },{
            field: 'userId',
            title: '用户账号',    /* 修改标题 ，更换姓名和用户账号位置  */
            width: 100
        },
        {
            field: 'deptName',
            title: '部门',
            width: 100
        },{
            field: 'userCreationTime',
            title: '创建日期',
            width: 100
        }]
    });
	
	$("#search").click(function (){
		  userList.bootstrapTable('refresh');
	})
	
	$("#userName").keydown(function(event) {//给输入框绑定按键事件
        if(event.keyCode == "13") {//判断如果按下的是回车键则执行下面的代码
            userList.bootstrapTable('refresh');
    	}
	})
	
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    roleId : '${roleId}',
		    roleName : ($("#userName").val()=="请输入姓名...")?'':$("#userName").val()    /* 修改传参逻辑  */
	   }
	}
	
	/* 关闭弹出框*/
	$("#close").click(function (){
		parent.closeWin();
	});
	
	/* 提交 */
	$("#submit").click(function (){
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
			url : "${_baseUrl}/role/saveRoleUser",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {userIds : userIds.join(','),roleId:"${roleId}"},
			success : function(json) {
				layer.msg(json.message);
				parent.refreshTable();
				parent.closeWin();
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	});
	
	
})

</script>
</head>
<body>
<div class="wdang_main">
	<div class="select_user" align="right" style="margin-bottom:10px;">
		<table>
			<tr><td><input class="input_text xmulist2_input" type="text" id="userName" style="width:95%; padding-left:10px;" value="请输入姓名..." onfocus="if(this.value=='请输入姓名...')this.value=''" onblur="if(this.value=='')this.value='请输入姓名...'" /></td><td><input class="dyi_btna dyi_btnabox dyi_btna1" type="button" id="search" value="搜索" style=" height:26px;"/></td></tr>
		</table>    <!-- 更改样式统一规范 ,修改按钮高度统一  -->
	</div>
	<div class="personnel_cont">
	    <table id="userList" class="tab-w-01 tab-w-auto" width="100%" border="0" cellspacing="0" cellpadding="0">
	    </table>
	</div>
	<div class="permission_an mubanclass_an ma mt30">
		<shiro:hasPermission name="role:saveRoleUser">
	        <a href="javascript:;" class="per_baocun" id="submit">保 存</a>
	    </shiro:hasPermission>
	    <a href="javascript:;" class="per_gbi" id="close">关 闭</a>
	</div>
</div>

</body>
</html>