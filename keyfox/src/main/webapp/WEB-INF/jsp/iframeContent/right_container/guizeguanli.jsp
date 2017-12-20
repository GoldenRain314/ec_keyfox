<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>DDOS</title>
    <%@ include file="/WEB-INF/jsp/common/tz.jsp" %>
    <style type="text/css">
        .head{width: 98%;height:40px;line-height: 30px;margin: 10px auto;overflow: hidden}
        .head_left{float: left;}
        .head_left input{background: url("${_resources}/TZ/img/sousuo.png") no-repeat 10px;padding-left:40px;height: 40px;width: 400px;border-radius: 4px }
        .head_right{float: right;width: 225px;}
        .head_right a{margin-left: 10px;background: #007DDB;color: #fff;border-radius: 4px;display: inline-block;  height: 40px;  line-height: 40px;  width: 100px;  text-align: center;}
        .table_inline thead tr th{  white-space: nowrap;text-align: center;vertical-align: middle!important;}
        .table_inline tbody tr td{  vertical-align: middle!important;  font-size: 12px;  white-space: nowrap;}
        .table_inline{  width:100%;  text-align: center;  margin:0px auto!important;}
        .table_inline thead tr{  background-color:#ebebeb;}
        .table_inline > thead > tr > th, .table_inline > thead > tr > td{  border-bottom-width:0px;}
        .table_inline tbody tr td a{display: inline-block;width: 20px;height: 20px;border: 1px solid #ccc;margin-left: 5px}
        .t1{background:url("${_resources}/TZ/img/1.png") no-repeat;width: 100%;height:200px}
        .t2{float: left;background:url("${_resources}/TZ/img/2.png") no-repeat;width: 50%;height:210px}
        .t3{float: left;background:url("${_resources}/TZ/img/3.png") no-repeat;width: 50%;height:210px}
    </style>
</head>
<body>
<div class="main">
    <div class="head">
        <div class="head_left">
            <input type="text" placeholder="搜索需要查询的规则ID"/>
        </div>
        <div class="head_right">
            <a href="javascript:;">查看规则</a>
            <a href="javascript:;">添加规则</a>
        </div>
    </div>
    <div style="overflow: auto; width:98%;margin: auto;">
        <table class="table table-bordered table_inline" >
            <thead>
            <tr>
                <th>规则ID</th>
                <th>规则名</th>
                <th>规则描述</th>
                <th>规则状态</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>3007</td>
                <td>Pro_HTTP</td>
                <td>IPRuleTest</td>
                <td>running</td>
            </tr>
            <tr>
                <td>3007</td>
                <td>Pro_HTTP</td>
                <td>IPRuleTest</td>
                <td>running</td>
            </tr>
            <tr>
                <td>3007</td>
                <td>Pro_HTTP</td>
                <td>IPRuleTest</td>
                <td>running</td>
            </tr>
            <tr>
                <td>3007</td>
                <td>Pro_HTTP</td>
                <td>IPRuleTest</td>
                <td>running</td>
            </tr>
            <tr>
                <td>3007</td>
                <td>Pro_HTTP</td>
                <td>IPRuleTest</td>
                <td>running</td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="t1"></div>
    <div>
        <div class="t2"></div>
        <div class="t3"></div>
    </div>

</div>
</body>
<script type="text/javascript">

</script>
</html>