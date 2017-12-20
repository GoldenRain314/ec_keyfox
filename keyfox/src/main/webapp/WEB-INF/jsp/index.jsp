<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>TZ新项目首页</title>
<%@ include file="/WEB-INF/jsp/common/tz.jsp" %>
</head>
<body>
<div class='wrap'>
    <div class='header'>
        <div class='logo fl clearfix'>
            <h1>网络探针综合平台</h1>
        </div>
        <div class='install fr clearfix'>
            <div id='define' class='define' href="javascript:;">
                <div>
                    admin
                </div>
                <div id='tag-define' class='tag'>
                    <div class='d-box'></div>
                    <div class='arrow'>
                        <em></em><span></span>
                    </div>
                    <ul>
                        <li id='t-d-cancel'>注销</li>
                        <li onclick='alterPwd()'>修改密码</li>
                        <li>退出</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div id='iframeCont' class='iframeCont'>
        <iframe name='contIframe' class='contIframe' width='100%' height='100%' frameborder="none" scrolling="auto" src="${_baseUrl}/tzController/left_ztree" ></iframe>
    </div>
</div>
</body>
<script type='text/javascript'>
    var initWidth = document.documentElement.clientWidth;
    initHeight();
    setDefine();
    setAuto();
    // =============================================
    window.onresize = function(){
        setTimeout('initHeight();setAuto();',100);
        initWidth = document.documentElement.clientWidth;
    }
    // =============================================
    function initHeight(){
        var topH = $('.header').height(),
                initheight = document.documentElement.clientHeight - topH -5,
                oCont = $('#iframeCont') ;
        oCont.height(initheight);
    };
     // 定义下拉菜单
    function setDefine(){
        var oIn = $('#define'),
                oTag = $('#tag-define');
        oIn.mouseover(function(){
            oTag.css('display','block');
            $('#t-d-cancel').trigger('click');
        }).mouseleave(function(){
            oTag.css('display','none');
        })
    };
    // 修改密码弹框
    function alterPwd(){
        layui.use('layer',function(){
            var layer = layui.layer;
            layer.config({
                type: 2,
                shade: [0.5,'#fff'],
                btnAlign: 'c',
                skin: 'my-style',
                extend: 'myskin/style.css'
            });
            layer.open({
                title: '修改密码',
                area: ['500px','400px'],
                content: 'changePwd.html'
            });
        });
    }
    // 设置自适应
    function setAuto(){
        var initwidth = document.documentElement.clientWidth;

        if(initwidth >= '1680'){
            $('html').css('font-size','100%');
        }else if(initwidth >= '1025'){
            $('html').css('font-size','90%');
        }else {
            $('html').css('font-size','80%');
        }
    }
</script>
</html>