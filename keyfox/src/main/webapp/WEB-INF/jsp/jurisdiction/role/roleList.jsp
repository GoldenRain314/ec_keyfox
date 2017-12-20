<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>角色管理</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>

<script type="text/javascript">

var roleList;
var userId = "${userId}";
$(function (){
	roleList = $("#roleList").bootstrapTable({
		url : '${_baseUrl}/role/getRoleList',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{
        	 field: 'checked',
             checkbox: true,
             formatter: function(value, row, index){
             	if(userId != "sysadmin" && (row.roleName == '系统管理员' || row.roleName == '安全审计员' || row.roleName == '安全保密员')){
             		return {
                        disabled: true
                    };
             	}
             }
         }, {
            field: 'roleId',
            title: 'id',
            visible:false,
            width: 100
        },{
            field: 'roleName',
            title: '角色名称',
            width: 200,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"showDetail('"+row.roleId+"')\">"+value+"</a>";
            }
        },{
            field: 'roleCode',
            title: '角色编号',
            width: 100
        },{
            field: 'createTime',
            title: '创建时间',
            width: 100
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    roleName:$("#roleName").val()
	   }
	}
	/* 添加角色 */
	$("#addRole").click(function (){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'添加角色',
			autoOpen: true,
			modal: true,
			//left:0,
			//top:0,
			position:'center',
			height: 500,
			width: 950
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/role/showDetail");
	});
	
	/* 删除角色 */
	$("#delRole").click(function (){
		var selected = roleList.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要删除的数据");
			return false;
		}
		var roleIds = [];
		for(i in selected){
			roleIds.push(selected[i].roleId);
		}
		
		$.ajax({
			url : "${_baseUrl}/role/deleRole",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {roleIds : roleIds.join(',')},
			success : function(json) {
				layer.msg(json.message);
				refreshTable();
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	});
	
	$("#roleName").keydown(function(event) {//给输入框绑定按键事件
	    if(event.keyCode == "13") {//判断如果按下的是回车键则执行下面的代码
	    	refreshTable();
	  	}
	})
})

/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	roleList.bootstrapTable('refresh');
}

/* 角色详细信息 */
function showDetail(roleId){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'详细信息',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 950
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/role/showDetail?roleId="+roleId);
}

</script>
</head>
<body>
<div class="main_cont">
       	<div class="main_c">
               <div class="current_cont">
                   <div class="fl current_c">
                        当前位置 ： <a href="javascript:;">授权管理</a>  >  <a href="javascript:;">角色管理</a>  >  所有角色
                   </div>            
                   <div class="fr current_j">
                       <ul>
                           <li>	
                           		<shiro:hasPermission name="role:showDetail">
							        <a href="javascript:;" class="current_1" id="addRole">添加角色</a>
							    </shiro:hasPermission>
                           	</li>
                           <!-- <li><a href="javascript:;" class="current_3" id="updateRole">修改角色</a></li> -->
                           <li>
                           		<shiro:hasPermission name="role:deleRole">
							        <a href="javascript:;" class="current_2" id="delRole">删除角色</a>
							    </shiro:hasPermission>
                           </li>
                           <div class="clear"></div>
                       </ul>
                   </div>
                   <div class="fr current_s">
                       <div class="fl current_s_i"><input name="" id="roleName" type="text" class="input_text1" value="请输入角色名称..." onFocus="if(this.value=='请输入角色名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入角色名称...';}"></div>
                       <div class="fl current_s_a"><input name="" type="button" onclick="refreshTable()" value="搜索" class="input_btn1"></div>
                       <div class="clear"></div>
                   </div>
                   <div class="clear"></div>
                           
               </div>
               
               <div class="personnel_cont">
		        <!--tab-w-01----->
		        <table id="roleList" class="tab-w-01 tab-w-auto"></table>         
               </div>
           
    	 </div>
     </div>
     
     <div id="popDiv" style="display: none;overflow: hidden;">
		<iframe id="popIframe" style="width:100%; height:434px;" frameborder="0" scrolling="no"></iframe>
	</div>
</body>
</html>