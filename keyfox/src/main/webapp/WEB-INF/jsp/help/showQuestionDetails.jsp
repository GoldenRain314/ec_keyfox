<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>问题详情</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
$(function (){
	$.ajax({
		url : "${_baseUrl}/hq/getQuestionValue",
		type : "get",
		dataType : "text",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {qId:"${info.qId}"},
		success : function(json) {
			$("#content").append(json);
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
})
</script>

<style>
	.main_cont { margin:0;}
	.dingxwd_main { margin:0;}
	.help_cont_t { padding-bottom:20px;}
</style>

<body>
    <div class="main_cont dingxwd_main" >  <!-- style="margin-left:251px;" -->
        <div class="main_c">
            <div class="help_cont pt50">
            	<div class="fr permission_tit help_return">
                    <ul>
                        <li><a href="javascript:history.go(-1)">返回</a></li>
                        <div class="clear"></div>
                    </ul>
                </div>
                <h2 class="help_cont_tit">${info.qName }</h2>
                <div class="help_cont_t mt30" id="content">
               <!-- <p> 供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？供应商供应商报价后可以修改报价信息吗？供应商报价后可以修改报价信息吗？</p> -->
                </div>
            </div>
        </div>
        
    </div>
</body>
</html>