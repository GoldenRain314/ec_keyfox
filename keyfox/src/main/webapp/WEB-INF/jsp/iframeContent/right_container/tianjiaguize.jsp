<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title></title>
    <%@ include file="/WEB-INF/jsp/common/tz.jsp" %>
    <style type="text/css">
        .layui-form-item{width: 30%;float: left;clear: none;margin-left: 40px}
        .layui-input-block{width:75%;margin-left:0px;float: left}
        .layui-form-label{text-align:left;padding: 9px 5px;}
        .layui-input-block{line-height: 30px}
        input[type="radio"], input[type="checkbox"]{margin: 0px 0px 0px 15px}
    </style>
</head>
<body>
<div class="main">
    <div style="overflow: hidden;margin-top: 20px;">
        <div class="layui-form-item">
            <label class="layui-form-label">ID</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">规则名称</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">levei</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
            </div>
        </div>
    </div>
    <div style="overflow: hidden;">
        <div class="layui-form-item">
            <label class="layui-form-label">采集模式：</label>
            <div class="layui-input-block">
                <input type="radio" name="sex" value="单包" title="单包" checked="">单包
                <input type="radio" name="sex" value="链接" title="链接">链接
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">保存数据量</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-block">
                <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
            </div>
        </div>
    </div>
    <div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
    </div>
</div>
</body>
<script type="text/javascript">

</script>
</html>