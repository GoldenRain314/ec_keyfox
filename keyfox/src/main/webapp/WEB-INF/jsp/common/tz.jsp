<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<script>
var _baseUrl = "${_baseUrl }";
</script>

<script src='${_resources}/TZ/js/jquery-1.11.2.js' type='text/javascript'></script>
<script src='${_resources}/TZ/js/jquery.cookie.js' type='text/javascript'></script>
<script src='${_resources}/TZ/js/jquery.form.js' type='text/javascript'></script>
<!-- ie8 兼容bootstrap  -->
<script src='${_resources}/TZ/js/html5shiv.min.js' type='text/javascript'></script>
<script src='${_resources}/TZ/js/respond.min.js' type='text/javascript'></script>
<!-- bootstrap table js 表格插件 -->
<script src='${_resources}/TZ/js/bootstrap.min.js' type='text/javascript'></script>
<script src='${_resources}/TZ/js/bootstrap-table.js' type='text/javascript'></script>
<!-- 弹出框js -->
<script src='${_resources}/TZ/js/layer.js' type='text/javascript'></script>
<link href='${_resources}/TZ/css/layer.css' type='text/css' rel='stylesheet' />
<link href='${_resources}/TZ/css/bootstrap.min.css' type='text/css' rel='stylesheet' />
<link href='${_resources}/TZ/css/bootstrap-table.min.css' type='text/css' rel='stylesheet' />
<!--  树结构  -->
<script type="text/javascript" src="${_resources}/TZ/js/jquery.ztree.core.js"></script>
<link href='${_resources}/TZ/css/style.css' type='text/css' rel='stylesheet' />
<%-- json2.js,这样ie8(兼容模式),ie7和ie6就可以支持JSON对象 
序列化方法
var jsonObj = { id: '01', name: 'Tom' };
JSON.stringify(jsonObj);
反序列化方法
var jsonString = "{ id: '01', name: 'Tom' }";
JSON.parse(jsonString);
--%>
<script src='${_resources}/TZ/js/json2.js' type='text/javascript'></script>
<script src='${_resources}/TZ/js/echarts.js' type='text/javascript'></script>
<script src='${_resources}/TZ/js/highcharts.js' type='text/javascript'></script>

