<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title></title>
    <link rel="stylesheet" href="${_resources}/TZ/layui/css/layui.css"  media="all">
    <script src='${_resources}/TZ/layui/layui.js' type='text/javascript'></script>
    <%@ include file="/WEB-INF/jsp/common/tz.jsp" %>
    <style type="text/css">
        .layui-colla-icon{left:98%}
        .layui-collapse{width: 99%;margin: auto;border: 0}
        .layui-colla-item{margin: 5px;border-radius: 5px}
        .layui-colla-content{border-top: 1px solid #ccc;background: #f2f2f2;}
        .layui-form-label{width: 140px;text-align:left;padding: 5px 15px;}
        .layui-input, .layui-textarea{width:50%}
        .layui-input-block{line-height: 30px}
        input[type="radio"], input[type="checkbox"]{margin: 0px 0px 3px 1px}
        .layui-input-block input{margin-left: 10px}
        .nwwd{overflow: hidden;margin:auto;width: 100%;}
        .nwwd_div1{width:49%;height:100%;float: left}
        .nwwd_div1 span{margin-left: 20px}
        .nwwd_div_important{overflow: hidden;margin: auto;text-align: center}
        .nwwd_important_table1,.nwwd_important_table3{width:98%;height:100%;float: left;margin-left:0.5%}
        .nwwd_important_table1 thead th,.nwwd_important_table2 thead th{text-align: center;border:1px solid #ccc;width:45%;height:40px}
        .nwwd_important_table3 thead th{text-align: center;border:1px solid #ccc;height:40px}
        .nwwd_important_table1 tbody tr td,.nwwd_important_table2 tbody tr td,.nwwd_important_table3 tbody tr td{text-align: center;border:1px solid #ccc;width:45%;height:40px}
        .nwwd_important_table2{width:98%;height:100%;border: 1px solid #ccc;float: left;margin-left: 2%}
        .nwwd_btn{text-align: center}
        .nwwd_btn a{display: inline-block;background:url("${_resources}/TZ/img/tianjia.png") no-repeat;width: 184px;height: 30px;line-height: 30px;color: #fff;margin-top: 20px}
        .btn_a a{display: inline-block;width: 200px;  height: 40px;  line-height: 40px; text-align: center;background: #007DDB;color: #fff;border-radius: 4px;margin-left: 20px}
        .btn_a{margin-top: 10px}
    </style>
</head>
<body>
<div class="main">
    <div class="btn_a">
        <a href="javascript:;">启动采集</a>
        <a href="javascript:;">关闭采集</a>
        <a href="javascript:;">自动开启</a>
    </div>
    <div class="layui-collapse" lay-filter="test">
        <div class="layui-colla-item">
            <h5 class="layui-colla-title">
                流量采集
            </h5>
            <div class="layui-colla-content layui-show">
                <div class="layui-form-item">
                    <label class="layui-form-label">网卡：</label>
                    <div class="layui-input-block">
                        <input type="radio" name="sex" value="网卡1" title="网卡1" checked="">网卡1
                        <input type="radio" name="sex" value="网卡2" title="网卡2">网卡2
                        <input type="radio" name="sex" value="网卡3" title="网卡3">网卡3
                        <input type="radio" name="sex" value="网卡4" title="网卡4">网卡4
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">线程数量：</label>
                    <div class="layui-input-block">
                        <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-colla-item">
            <h5 class="layui-colla-title">基本参数</h5>
            <div class="layui-colla-content">
                <div class="layui-form-item">
                    <label class="layui-form-label">日志刷新率：</label>
                    <div class="layui-input-block">
                        <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">链接：</label>
                    <div class="layui-input-block">
                        <input type="radio" name="sex" value="网卡1" title="网卡1" checked="">TCP组链接
                        <input type="radio" name="sex" value="网卡2" title="网卡2">UDP组链接
                        <input type="radio" name="sex" value="网卡3" title="网卡3">IP非TCP/UDP组链接
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">IPV4链接数量：</label>
                    <div class="layui-input-block">
                        <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">IPV6链接数量：</label>
                    <div class="layui-input-block">
                        <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-colla-item" style="position:relative">
            <h5 class="layui-colla-title" >网络设置</h5>
            <div style="position: absolute;top: 10px;left:150px">
                <input type="checkbox"/>
                <a href="">启用</a>
            </div>
            <div class="layui-colla-content">
                <div class="layui-form-item">
                    <label class="layui-form-label">主机数量：</label>
                    <div class="layui-input-block">
                        <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">内网MAC数量：</label>
                    <div class="layui-input-block">
                        <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
                    </div>
                </div>
                <div class="nwwd">
                    <div class="nwwd_div1">
                        <span>DMZ网段</span>
                        <div class="nwwd_div_important">
                            <table class="nwwd_important_table1">
                                <thead>
                                <tr>
                                    <th>IP</th>
                                    <th>Mask</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="nwwd_btn">
                            <a href="javascript:;" class="btn1">添加</a>
                        </div>
                    </div>
                    <div class="nwwd_div1">
                        <span>DMZ网段</span>
                        <div class="nwwd_div_important">
                            <table class="nwwd_important_table2">
                                <thead>
                                <tr>
                                    <th>IP</th>
                                    <th>Mask</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="nwwd_btn">
                            <a href="javascript:;" class="btn2">添加</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-colla-item">
            <h5 class="layui-colla-title">采集参数</h5>
            <div class="layui-colla-content">
                <div class="layui-form-item" style="position:relative">
                    <label class="layui-form-label">TCP保存：</label>
                    <div style="position: absolute;left:100px;top: 5px;">
                        <input type="checkbox"/>
                        <a href="">启用</a>
                    </div>
                    <div class="layui-input-block" style="margin-left: 170px">
                        <div class="fl" style="margin-left: 15px">单个连接缓存包数</div>
                        <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题">
                    </div>
                </div>
                <div class="layui-form-item" style="position:relative">
                    <label class="layui-form-label">协议分析：</label>
                    <div style="position: absolute;left:100px;top: 5px;">
                        <input type="checkbox"/>
                        <a href="">启用</a>
                    </div>
                    <div class="layui-input-block" style="margin-left: 170px">
                        <input type="radio" name="sex" value="TCP组链接" title="TCP组链接" checked="">异常协议保留
                        <input type="radio" name="sex" value="UDP组链接" title="UDP组链接">TLS握手
                        <input type="radio" name="sex" value="异常TTL" title="异常TTL">异常TTL
                        <input type="text" name="title" lay-verify="title" autocomplete="off" class="">
                        <div style="display: inline-block">IP:TTL小于该值的IP包认为异常</div>
                    </div>
                </div>
                <div class="layui-form-item" style="position:relative">
                    <label class="layui-form-label">协议分析：</label>
                    <div style="position: absolute;left:100px;top: 5px;">
                        <input type="checkbox"/>
                        <a href="">启用</a>
                    </div>
                    <div class="layui-input-block" style="margin-left: 170px">
                        <input type="radio" name="sex" value="链接记录" title="链接记录" checked="">连接
                        <input type="radio" name="sex" value="DNS" title="DNS">DNS
                        <input type="radio" name="sex" value="TSL" title="TSL">TSL
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="nwwd">
                        <div class="nwwd_div1">
                            <span>HTTP Title</span>
                            <div class="nwwd_div_important">
                                <table class="nwwd_important_table3">
                                    <thead>
                                    <tr>
                                        <th style="width: 90%">HTTP 列表</th>
                                        <th style="width: 10%">操作</th>
                                    </tr>
                                    </thead>
                                </table>
                            </div>
                            <div class="nwwd_btn">
                                <a href="javascript:;" class="btn3">添加</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
<script type="text/javascript">
   layui.use(['element', 'layer'], function(){
        var element = layui.element;
        var layer = layui.layer;
        //监听折叠
        element.on('collapse(test)', function(data){
        });
    });
   $(function(){
       $(".btn1").click(function(){
           var html = "<tr><td>192.168.1.10</td><td>255.255.255.255</td><td><a href='javascript:;'>删除</a></td></tr>";   //自己定义好要添加的信息
           $(".nwwd_important_table1").append(html);  //添加对应的内容到table
       });
   });
   $(function(){
       $(".btn2").click(function(){
           var html = "<tr><td>192.168.1.10</td><td>255.255.255.255</td><td><a href='javascript:;'>删除</a></td></tr>";   //自己定义好要添加的信息
           $(".nwwd_important_table2").append(html);  //添加对应的内容到table
       });
   });
   $(function(){
       $(".btn3").click(function(){
           var html = "<tr><td>192.168.1.10</td><td><a href='javascript:;'>删除</a></td></tr>";   //自己定义好要添加的信息
           $(".nwwd_important_table3").append(html);  //添加对应的内容到table
       });
   });

</script>
</html>