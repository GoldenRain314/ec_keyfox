<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>详情</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
$(function(){
	//默认点击第一个
	$("#ul>li:visible:first >a").click();
});

var roleId = "${roleId}";

/* 展示详情界面 */
function showDetail(evl){
	changeCSS(evl);
	var div = document.getElementById("detail");
	div.src ="${_baseUrl}/role/showRoleInfo?roleId=" + roleId;
}

/* 角色成员 */
function showUserByRoleId(evl){
	if("" != roleId){
		changeCSS(evl);
		var div = document.getElementById("detail");
		div.src ="${_baseUrl}/role/showUserByRoleId?roleId=" + roleId;
	}else{
		layer.msg("请先保存角色信息");
	}
}
/* 授权管理 */
function showAccredit(evl){
	if("" != roleId){
		changeCSS(evl);
		var div = document.getElementById("detail");
		div.src ="${_baseUrl}/role/showAccredit?roleId=" + roleId;
	}else{
		layer.msg("请先保存角色信息");
	}
}

function changeCSS(evl){
	var a = document.getElementsByTagName("a");
	for(var i in a){
		if(a[i].nodeName=="A"){
			a[i].removeAttribute("class");
		}
	}
	evl.setAttribute("class","qxsz_on");
}

function closeWin(){
	parent.closeWin();
}

function setRoleId(id){
	roleId = id;
}

function refreshTable(){
	parent.refreshTable();
}

function click(id){
	$("#"+id).click();
}

</script>
</head>
<body>
<div>
    <div class="permission_tit">
    	<ul id="ul">
        	<li><a href="javascript:;" class="qxsz_on" onclick="showDetail(this)">角色属性</a></li>
            <li><a href="javascript:;" onclick="showUserByRoleId(this)" id="roleUserList" >角色成员</a></li>
            <li><a href="javascript:;" onclick="showAccredit(this)">权限设置</a></li>
            <div class="clear"></div>
        </ul>
    </div>
	<iframe id="detail" style="width:100%; height:365px;" border="0" frameborder="0" src=""></iframe>
</div>

</body>
</html>