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

/* 展示详情界面 */
function showDetail(menuId){
	var div = document.getElementById("detail");
	div.src ="${_baseUrl}/menu/showMenuInfo?menuId=" + menuId;
}

/* 显示菜单下所有权限 */
function showPermissionByMenuId(menuId){
	var div = document.getElementById("detail");
	div.src ="${_baseUrl}/menu/showMenuPermission?menuId=" + menuId;
}

function showAccredit(roleId){
	var div = document.getElementById("detail");
	div.src ="${_baseUrl}/role/showAccredit?roleId=" + roleId;
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

function refreshTable(){
	parent.refreshTable();
}

</script>
</head>
<body>
<div>
    <div class="permission_tit">
    	<ul id="ul">
        	<li><a href="javascript:;" class="qxsz_on" onclick="showDetail('${menuId}');changeCSS(this);">菜单属性</a></li>
            <li><a href="javascript:;" onclick="showPermissionByMenuId('${menuId}');changeCSS(this)" >权限按钮</a></li>
            <div class="clear"></div>
        </ul>
    </div>
	<iframe id="detail" frameborder="0" border="0" style="width:100%; height:350px;" src=""></iframe>
</div>

</body>
</html>