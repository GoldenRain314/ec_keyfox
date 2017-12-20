<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
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
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript">
var menuList;
var deptNameMap;

if (!Array.prototype.indexOf)
{
  Array.prototype.indexOf = function(elt /*, from*/)
  {
    var len = this.length >>> 0;

    var from = Number(arguments[1]) || 0;
    from = (from < 0)
         ? Math.ceil(from)
         : Math.floor(from);
    if (from < 0)
      from += len;

    for (; from < len; from++)
    {
      if (from in this &&
          this[from] === elt)
        return from;
    }
    return -1;
  };
}


$(function (){
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
        }, {
            field: 'userName',
            title: '姓名',
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
				str +="<a onClick=\"editFun('"+row.id+"');\">"+value+"</a>";  
				return str;
			}
        },
        {
            field: 'userId',
            title: '用户账号',
            width: 100
        },
        {
            field: 'deptName',
            title: '部门',
            width: 100/* ,
            formatter : function(value, row, index) {
            	var str='';
            	for(var i=0; i<deptNameMap.length; i++){
					if (deptNameMap[i].id == value) return deptNameMap[i].deptName;
					else return '-';      
				}
				return str;
			} */
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
            	if(row.userLock =='1'){
            		return "锁定";
            	}
            	if("1" == value){
            		return "禁用";
            	}else if("0" == value){
            		return "启用";
            	}
				/* if (1== value) {
					return "<a onClick=\"statusFun('"+row.id+"','"+value+"');\">禁用</a>";
				}
				return "<a onClick=\"statusFun('"+row.id+"','"+value+"');\">启用</a>"; */
			}
        },
        {
            field: 'sort',
            title: '上移',
            width: 30,
            formatter : function(value, row, index) {
				return "<a onClick=\"sortFun('"+row.id+"','"+value+"','0');\">上移</a>";
			}
        },
        {
            field: 'sort',
            title: '下移',
            width: 30,
            formatter : function(value, row, index) {
					return "<a onClick=\"sortFun('"+row.id+"','"+value+"','1');\">下移</a>";
			}
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    userNameForSerch:$("#userNameForSerch").val()
	   }
	}
	
	$("#userNameForSerch").keydown(function(event) {//给输入框绑定按键事件
	    if(event.keyCode == "13") {//判断如果按下的是回车键则执行下面的代码
	    	refreshTable();
	  	}
	})
	
});
function addFun(){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'添加用户',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 900
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","100%");
	$("#popIframe").attr("src","${_baseUrl}/userController/addPage");

}
function editFun(id){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'修改用户',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 900
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
/* 重置密码 */
function pwdResetFun(userId){
	var rows= $("#menuList").bootstrapTable('getSelections');
	if(rows.length==0){
		layer.msg("请先选择人员");
	}else{
		var rowsString = JSON.stringify(rows);
		var path="${_baseUrl}/userController/PwdReset";
		 $.ajax({    
				type: "POST",    
				async: false,    
				url:path,   
				data:{
					"rows":rowsString
				},    
				dataType:"text",    
				success: function (data) {
					layer.msg(data);
					refreshTable();//刷新当前页面.		
				}   
			});  
	}  
}

function statusFun(status){
	var selected = menuList.bootstrapTable('getSelections');
	if(selected.length < 1){
		layer.msg("请选择要操作的数据");
		return false;
	}
	if(status=='1'){
		var rowsString = JSON.stringify(selected); 
		if(rowsString.indexOf("系统管理员")>0||rowsString.indexOf("安全保密员")>0||rowsString.indexOf("安全审计员")>0){
			layer.msg("平台初始化用户，不可操作");
			return false;
		}
	}
	
	var ids = [];
	for(i in selected){
		ids.push(selected[i].id);
	}
	
	var jy= false;
	var qy = false;
	for(i in selected){
		if(selected[i].userStatus == 1) {
			jy = true;
		}
		if(selected[i].userStatus == 0) {
			qy = true;
		}
	}
	if(status=='1' && jy == true){
		layer.msg("选择的用户中已存在禁用状态的用户");
		return false;
	}else if(status=='0' && qy == true) {
		layer.msg("选择的用户中已存在启用状态的用户");
		return false;
	} else{
		var path="${_baseUrl}/userController/updateStatus";
		 $.ajax({    
				type: "POST",    
				async: false,    
				url:path,   
				data:{
					"ids":ids.join(","),
					"userStatus":status
				},    
				dataType:"json",    
				success: function (data) {
					layer.msg(data.message,{shift:5,time:800},function(){
						refreshTable();//刷新当前页面.		
					});
				}   
		});  
	}
}
/* 排序 */
function sortFun(id,sort,type){
	 var path="${_baseUrl}/userController/updateSort";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"id":id,
				"sort":sort,
				"type":type
			},    
			dataType:"text",    
			success: function (data) {   
				layer.msg(data,{shift:5,time:1000},function(){
					refreshTable();//刷新当前页面.		
				});
			}   
		});                
}
function unlockFun(){
	var rows= $("#menuList").bootstrapTable('getSelections');
	if(rows.length==0){
		layer.msg("请先选择解锁人员");
	}else{
		var rowsString = JSON.stringify(rows);
		var path="${_baseUrl}/userController/updateLock";
		 $.ajax({    
				type: "POST",    
				async: false,    
				url:path,   
				data:{
					"rows":rowsString
				},    
				dataType:"text",    
				success: function (data) {   
					layer.msg("解锁成功");
					refreshTable();//刷新当前页面.		
				}   
			});  
	}            
}
/* 注销用户  */
function logoutFun(){
	var rows= $("#menuList").bootstrapTable('getSelections');
	//系统管理员、安全保密员、安全审计员
	
	if(rows.length==0){
		layer.msg("请先选择注销人员");
	}else{
		var logOut="1";
		var rowsString = JSON.stringify(rows); 
		if(rowsString.indexOf("系统管理员")>0||rowsString.indexOf("安全保密员")>0||rowsString.indexOf("安全审计员")>0){
			layer.msg("平台初始化用户，不可操作");
			return false;
		}
		
		var path="${_baseUrl}/userController/updateLogout";
		 $.ajax({    
				type: "POST",    
				async: false,    
				url:path,   
				data:{
					"rows":rowsString,
					"logOut":logOut
				},    
				dataType:"text",    
				success: function (data) {
					if(data == "0"){
						layer.msg("注销成功");
					}
					refreshTable();//刷新当前页面.		
				}   
			}); 
	}
}

/**
 * 批量导入用户
 */
function batchImport(){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'批量导入',
		autoOpen: true,
		modal: true,	
		height: 400,
		width: 700        /* 修改弹框名称及显示大小   */
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/userController/showBatchImport?rand="+Math.random());    
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
                         	当前位置 ： <a href="javascript:;">用户管理</a>  >  <a href="javascript:;">用户列表</a>  >  所有人员
                    </div>      
                    <div class="fr current_j">
                        <ul>
                            <li>
                            	<shiro:hasPermission name="userController:addPage">
							        <a href="javascript:;" class="current_1" onClick="addFun();">添加人员</a>
							    </shiro:hasPermission>
                            </li>
                            <li>
                            	<shiro:hasPermission name="userController:updateLogout">
							        <a href="javascript:;" class="current_2" onClick="logoutFun();">注销人员</a>
							    </shiro:hasPermission>
                            	
                            </li>
                            <li>
                            	<shiro:hasPermission name="userController:PwdReset">
							        <a href="javascript:;" class="current_3" onClick="pwdResetFun();">密码重置</a>
							    </shiro:hasPermission>
                            </li>
                            <li>
                            	<shiro:hasPermission name="userController:updateLock">
							        <a href="javascript:;" class="current_4" onClick="unlockFun();">解锁</a>
							    </shiro:hasPermission>
                            </li>
                            <li>
                            	<shiro:hasPermission name="userController:updateStatus_0">
							        <a href="javascript:;" class="current_7" onClick="statusFun('0');">启用</a>    <!-- 更换小图标  -->
							    </shiro:hasPermission>
                            </li>
                            <li>
                            	<shiro:hasPermission name="userController:updateStatus_1">
							        <a href="javascript:;" class="current_8" onClick="statusFun('1');">禁用</a>    <!-- 更换小图标  -->
							    </shiro:hasPermission>
                            </li>
                            <li>
                            	<%-- <shiro:hasPermission name="userController:updateStatus_1"> --%>
							        <a href="javascript:;" class="current_9" onClick="batchImport();">批量导入</a>    <!-- 更换小图标  -->
							    <%-- </shiro:hasPermission> --%>
                            </li>
                            <div class="clear"></div>
                        </ul>
                    </div>
                    <div class="fr current_s" style="margin:22px 0 20px 0;">   <!-- 更改搜索框显示位置  -->
                        <div class="fl current_s_i"><input id="userNameForSerch" name="" type="text" class="input_text1" value="请输入姓名..." onFocus="if(this.value=='请输入姓名...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入姓名...';}"></div>
                        <div class="fl current_s_a"><input name="" type="button" value="搜索" class="input_btn1" onclick="refreshTable()"></div>   <!-- 修改信息与内容一致  -->
                        <div class="clear"></div>
                    </div>
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