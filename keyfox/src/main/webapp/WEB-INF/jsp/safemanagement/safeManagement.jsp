<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>安全设置</title>
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
		url : '${_baseUrl}/safeManagementController/select',
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
            field: 'systemLevel',
            title: '系统密级',
            width: 100,
            formatter : function(value, row, index) {
            	var str=value;
            	if(value==0){
            		return "<a href='javascript:void(0)' onclick=\"editFun('"+row.id+"')\">普通</a>";
            	}
				 if(value==1){
					 return "<a href='javascript:void(0)' onclick=\"editFun('"+row.id+"')\">秘密</a>";
				 }
				 if(value==2){
					 return "<a href='javascript:void(0)' onclick=\"editFun('"+row.id+"')\">机密</a>";
				 }
				 if(value==3){
					 return "<a href='javascript:void(0)' onclick=\"editFun('"+row.id+"')\">绝密</a>";
				 }
				return str;
			}
        },{
            field: 'pwdLocktimes',
            title: '密码锁定次数',
            width: 100
        },{
            field: 'minimumPwdLength',
            title: '最短密码长度',
            width: 100
        },{
            field: 'maximumPwdLength',
            title: '最长密码长度',
            width: 100
        },
        {
            field: 'pwdExpirationTime',
            title: '密码失效时间(天)',
            width: 100
        },
        {
            field: 'userInactiveTime',
            title: '用户非活跃时间(天)',
            width: 100
        },
        {
            field: 'pwdChangeCycle',
            title: '口令更换周期 (天)',
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
		layer.msg("请先选择要删除的数据");
	}else{
		var rowsString = JSON.stringify(rows); 
		var path="${_baseUrl}/safeManagementController/delete";
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
		title:'添加安全设置',
		autoOpen: true,
		modal: true,	
		height: 420,
		width: 780
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","100%");
	$("#popIframe").attr("src","${_baseUrl}/safeManagementController/addPage");
}

function editFun(id){ 
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'修改安全设置信息',
		autoOpen: true,
		modal: true,	
		height: 420,
		width: 780
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/safeManagementController/editPage?id="+id);
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
                         当前位置 ： <a href="javascript:;">安全管理</a>  >  <a href="javascript:;">安全设置</a>  >  安全设置列表
                    </div>            
                    <div class="fr current_j">
                        <ul>
                            <li>
                            	<shiro:hasPermission name="safeManagementController:addPage">
							       <a href="javascript:;" class="current_1" onClick="addFun();">添加</a>
							    </shiro:hasPermission>
                            </li>
                            <li>
                            	<shiro:hasPermission name="safeManagementController:delete">
							       <a href="javascript:;" class="current_2" onClick="deleteFun();">删除</a>
							    </shiro:hasPermission>
                            </li>
                            <div class="clear"></div>
                        </ul>
                    </div>
                   <!--  <div class="fr current_s">
                        <div class="fl current_s_i"><input name="" type="text" class="input_text1" value="搜索您想寻找的..." onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
                        <div class="fl current_s_a"><input name="" type="button" value="高级搜索" class="input_btn1"></div>
                        <div class="clear"></div>
                    </div> -->
                    <div class="clear"></div>
                            
                </div>
                </div>
        <table id="menuList" class="tab-w-01 tab-w-auto"></table>
        </div>
     <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="0"></iframe>
	</div>
</body>
</html>