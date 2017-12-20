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
        .table_inline thead tr th{
            white-space: nowrap;
            text-align: center;
            vertical-align: middle!important;
        }
        .table_inline tbody tr td{
            vertical-align: middle!important;
            font-size: 12px;
            white-space: nowrap;
        }
        .table_inline{
            width:100%;
            text-align: center;
            margin:10px auto!important;
        }
        .table_inline thead tr{
            background-color:#ebebeb ;
        }
        .table_inline > thead > tr > th, .table_inline > thead > tr > td{
            border-bottom-width:0px;
        }
        .table_inline tbody tr td a{display: inline-block;width: 20px;height: 20px;border: 1px solid #ccc;margin-left: 5px}
    </style>
</head>
<body>
<div class="main">
    <div style="overflow: auto; width:98%;margin: auto;">
        <table class="table table-bordered table_inline" >
            <thead>
            <tr>
                <th>任务名称</th>
                <th>任务状态</th>
                <th>开始时间</th>
                <th>结束时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>任务1</td>
                <td>新建</td>
                <td>2017/02/11</td>
                <td>2017/02/19</td>
                <td>
                    <a href="javascript:;">1</a>
                    <a href="javascript:;">2</a>
                    <a href="javascript:;">3</a>
                    <a href="javascript:;">4</a>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="b1"><img src="${_resources}/TZ/img/b1.png" alt=""/></div>
    <div style="overflow: hidden">
        <div class="b2 fl"><img src="${_resources}/TZ/img/b2.png" alt=""/></div>
        <div class="b3 fl"><img src="${_resources}/TZ/img/b3.png" alt=""/></div>
    </div>

</div>
</body>
<script type="text/javascript">

</script>
</html>