<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登陆</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
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
	menuList = $("#menuList").bootstrapTable({
		url : '${_baseUrl}/userController/userPwdResetList',
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
        }, {
            field: 'userName',
            title: '姓名',
            width: 100
        },
        {
            field: 'userId',
            title: '用户账号',
            width: 100
        },
        {
            field: 'departId',
            title: '部门',
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
            	for(var i=0; i<deptNameMap.length; i++){
					if (deptNameMap[i].id == value) return deptNameMap[i].deptName;
				}
				return '-';    /* 内容为空时添加‘-’ */
			}
        },{

            field: 'passwordOld',
            title: '初始密码',
            width: 100
        },{

            field: 'initPwdTime',
            title: '初始化时间',
            width: 100
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    name:$("#name").val()
	   }
	}
	
	$("#name").keydown(function(event) {//给输入框绑定按键事件
	    if(event.keyCode == "13") {//判断如果按下的是回车键则执行下面的代码
	    	refreshTable();
	  	}
	})
	
})

function deleteFun(){
	var rows= $("#menuList").bootstrapTable('getSelections');
	if(rows.length==0){
		layer.msg("请先选择删除人员");
	}else{
		var rowsString = JSON.stringify(rows); 
		var path="${_baseUrl}/userController/delPwdResetList";
		 $.ajax({    
				type: "POST",    
				async: false,    
				url:path,   
				data:{
					"rows":rowsString,
				},    
				dataType:"text",    
				success: function (data) {
					layer.msg(data);
					menuList.bootstrapTable('refresh');	
				}   
			}); 
	}
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
                         当前位置 ： <a href="javascript:;">组织机构</a>  >  <a href="javascript:;">用户管理</a>  >  初始密码
                    </div>            
                    <div class="fr current_j">
                        <ul>
                            <li>
                            	<shiro:hasPermission name="userController:delPwdResetList">
							        <a href="javascript:;" class="current_2" onClick="deleteFun();">删除</a>
							    </shiro:hasPermission>
                            </li>
                            <div class="clear"></div>
                        </ul>
                    </div>
                    <div class="fr current_s">
                        <div class="fl current_s_i"><input name="" id="name" type="text" class="input_text1" value="请输入姓名..." onFocus="if(this.value=='请输入姓名...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入姓名...';}"></div>
                        <div class="fl current_s_a"><input name="" onclick="refreshTable()" type="button" value="搜索" class="input_btn1"></div>    <!-- 提示信息内容一致   -->
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