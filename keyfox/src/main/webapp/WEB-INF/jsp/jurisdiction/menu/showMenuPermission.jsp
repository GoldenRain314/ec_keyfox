<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>菜单权限</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var menuPermissionList;
$(function (){
	menuPermissionList = $("#menuPermissionList").bootstrapTable({
		url : '${_baseUrl}/menu/getMenuPermissionList',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{
        	 field: 'checked',
             checkbox: true
         }, {
            field: 'permissionId',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'menuId',
            title: 'menuId',
            visible:false,
            width: 5
        },{
            field: 'permissionName',
            title: '权限名称',
            width: 100
        },{
            field: 'permission',
            title: '权限',
            width: 100
        },{
            field: 'permissionUrl',
            title: '权限地址',
            width: 100
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    menuId : "${menuId}"
	   }
	}
	
	/* 关联权限 */
	$("#addPermission").click(function (){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'关联权限',
			autoOpen: true,
			modal: true,	
			height: 340,
			width: 600
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","100%");
		$("#popIframe").attr("src","${_baseUrl}/menu/showAddPermission?menuId=${menuId}");
	});
	
	/* 删除关联关系 */
	$("#delPermission").click(function (){
		
		var selected = menuPermissionList.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要操作的数据");
			return false;
		}
		var permissionIds = [];
		for(i in selected){
			permissionIds.push(selected[i].permissionId);
		}
		
		$.ajax({
			url : "${_baseUrl}/menu/delPermission",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {permissionIds : permissionIds.join(','),menuId:"${menuId}"},
			success : function(json) {
				layer.msg(json.message);
				refreshTable();
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	});
	
	
});

/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	menuPermissionList.bootstrapTable('refresh');
}



</script>
</head>
<body>
<div class="wdang_main">
       <div class="glqxian_btn mb20">
	       <shiro:hasPermission name="menu:delPermission">
			    <a href="javascript:;" class="glqxian_btn1 glqxian_btn1_1 fr" id="delPermission">删除权限</a>
		    </shiro:hasPermission>
	       	<shiro:hasPermission name="menu:showAddPermission">
		        <a href="javascript:;" class="glqxian_btn1 fr mr18" id="addPermission">关联权限</a>
		    </shiro:hasPermission>
	       	<div class="clear"></div>
       </div>
      	<div class="personnel_cont">
	    <table id="menuPermissionList" class="tab-w-01 tab-w-auto" width="100%" border="0" cellspacing="0" cellpadding="0">
	    </table>
	</div>
  </div>
<div id="popDiv" style="display: none;">
	<iframe id="popIframe" style="width:100%; height:284px;" frameborder="0" border="0"></iframe>
</div>
</body>
</html>