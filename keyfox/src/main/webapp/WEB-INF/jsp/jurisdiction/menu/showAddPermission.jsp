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
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript">
var permissionList;
$(function (){
	permissionList = $("#permissionList").bootstrapTable({
		url : '${_baseUrl}/permission/getNoMenuPermissionList',
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
		    order : params.order
	   }
	}
	
	/* 关闭第二层弹出框 */
	$("#close").click(function (){
		parent.closeWin();
	});
	
	/* 保存 */
	$("#submit").click(function (){
		var selected = permissionList.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要操作的数据");
			return false;
		}
		var permissionIds = [];
		for(i in selected){
			permissionIds.push(selected[i].permissionId);
		}
		
		$.ajax({
			url : "${_baseUrl}/menu/insertMenuPermission",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {permissionIds : permissionIds.join(','),menuId:"${menuId}"},
			success : function(json) {
				layer.msg(json.message,{shift:5,time:1000},function(){
					parent.closeWin();
					parent.refreshTable();
				});
				
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
 <div class="personnel_cont">
   <!--tab-w-01----->
   <table id="permissionList" class="tab-w-01 tab-w-auto"></table>         
</div>
<div class="permission_an mubanclass_an ma mt30">
    <a href="javascript:;" class="per_baocun" id="submit">保 存</a>
    <a href="javascript:;" class="per_gbi" id="close">关 闭</a>
</div>
</body>
</html>