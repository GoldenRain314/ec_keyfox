<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>权限管理</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />

<script type="text/javascript">
var permissionList;
$(function (){
	permissionList = $("#permissionList").bootstrapTable({
		url : '${_baseUrl}/permission/getPermissionList',
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
            width: 100,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"showDetail('"+row.permissionId+"')\">"+value+"</a>";
            }
        },{
            field: 'menuName',
            title: '关联菜单名称',
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
		    permissionName:$("#permissionName").val()
	   }
	}
	/* 添加权限*/
	$("#addPermission").click(function (){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'添加权限',
			autoOpen: true,
			modal: true,	
			height: 400,
			width: 800
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/permission/showAddPermission");
	});
	
	/* 删除权限 */
	$("#delPermission").click(function (){
		var selected = permissionList.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要删除的数据");
			return false;
		}
		
		var permissionIds = [];
		for(i in selected){
			permissionIds.push(selected[i].permissionId);
		}
		
		$.ajax({
			url : "${_baseUrl}/permission/delePermission",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {permissionIds : permissionIds.join(',')},
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

/* 查看详情,或 修改信息 */
function showDetail(id){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'详细信息',
		autoOpen: true,
		modal: true,	
		height: 400,
		width: 800
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","100%");
	$("#popIframe").attr("src","${_baseUrl}/permission/showAddPermission?permissionId="+id);
}


/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	permissionList.bootstrapTable('refresh');
}


</script>
</head>
<body>
<div class="main_cont">
       	<div class="main_c">
               <div class="current_cont">
                   <div class="fl current_c">
                        当前位置 ： <a href="javascript:;">授权管理</a>  >  <a href="javascript:;">权限管理</a>  >  所有权限
                   </div>            
                   <div class="fr current_j">
                   
                       <ul>
                       

                           	<li><a href="javascript:;" class="current_1" id="addPermission">添加权限</a></li>
				           
				           
				           
                           	<li><a href="javascript:;" class="current_2" id="delPermission">删除权限</a></li>

                           <div class="clear"></div>
                       </ul>
                   </div>
                   <div class="fr current_s">
                       <div class="fl current_s_i"><input name="" type="text" id="permissionName" class="input_text1" value="搜索您想寻找的..." onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
                       <div class="fl current_s_a"><input name="" type="button" onclick="refreshTable()" value="高级搜索" class="input_btn1"></div>
                       <div class="clear"></div>
                   </div>
                   <div class="clear"></div>
                           
               </div>
               
               <div class="personnel_cont">
		        <!--tab-w-01----->
		        <table id="permissionList" class="tab-w-01 tab-w-auto"></table>         
               </div>
    	 </div>
     </div>
     
    <div id="popDiv" style="display: none;">
		<iframe id="popIframe" frameborder="0" border="0"></iframe>
	</div>
</body>
</html>