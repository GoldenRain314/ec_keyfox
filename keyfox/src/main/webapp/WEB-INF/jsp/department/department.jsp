<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>部门列表</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript">
var menuList;
/* var deptNameMap;
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
}); */
$(function (){
	//初始化表格
	menuList = $("#menuList").bootstrapTable({
		url : '${_baseUrl}/departmentController/select',
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
            field: 'deptName',
            title: '部门名称',
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
				str +="<a onClick=\"editFun('"+row.id+"');\">"+value+"</a>";  
				return str;
			}
        },{
            field: 'parentName',
            title: '上级部门',
            width: 100
        },{
            field: 'deptNumber',
            title: '部门编号',
            width: 100
        },{
            field: 'userCount',
            title: '部门人数',
            width: 100
        },{
            field: 'deptCreateTime',
            title: '部门创建时间 ',
            width: 100
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    deptName:$("#departName").val()
	   }
	}
	
	$("#departName").keydown(function(event) {//给输入框绑定按键事件
	    if(event.keyCode == "13") {//判断如果按下的是回车键则执行下面的代码
	    	refreshTable();
	  	}
	})
	
})

function deleteFun(){
	 var rows= $("#menuList").bootstrapTable('getSelections');
		if(rows.length==0){
			layer.msg("请先选择需要删除的部门");
		}else{
			var rowsString = JSON.stringify(rows); 
			var path="${_baseUrl}/departmentController/delete";
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
		title:'添加部门',
		autoOpen: true,
		modal: true,	
		height: 480,
		width: 900
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","100%");
	$("#popIframe").attr("src","${_baseUrl}/departmentController/addPage");
}
function editFun(id){  
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'修改部门信息',
		autoOpen: true,
		modal: true,	
		height: 480,
		width: 900
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/departmentController/editPage?id="+id);
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
                         当前位置 ： <a href="javascript:;">组织机构</a>  >  <a href="javascript:;">部门管理</a>  >  所有部门
                    </div>            
                    <div class="fr current_j">
                        <ul>
                            <li>
                            	<shiro:hasPermission name="departmentController:addPage">
						            <a href="javascript:;" class="current_1" onClick="addFun();">添加部门</a>
						        </shiro:hasPermission>
                            </li>
                            <li>
                            	<shiro:hasPermission name="departmentController:delete">
						            <a href="javascript:;" class="current_2" onClick="deleteFun();">删除部门</a>
						        </shiro:hasPermission>
                            </li>
                            <div class="clear"></div>
                        </ul>
                    </div>
                    <div class="fr current_s">
                        <div class="fl current_s_i"><input name="" id="departName" type="text" class="input_text1" value="请输入部门名称..." onFocus="if(this.value=='请输入部门名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入部门名称...';}"></div>
                        <div class="fl current_s_a"><input name="" type="button" value="搜索" class="input_btn1" onclick="refreshTable()"></div>   <!-- 更改内容信息 高级搜索==搜索 -->
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                            
                </div>
                </div>
        <table id="menuList" class="tab-w-01 tab-w-auto"></table>
        </div>
     <div id="popDiv" style="display: none; overflow: hidden;">
		<iframe id="popIframe" border="0" frameborder="0"></iframe>
	</div>
</body>
</html>