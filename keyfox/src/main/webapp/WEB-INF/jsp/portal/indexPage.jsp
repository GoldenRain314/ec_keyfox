<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档管理工具</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}/css/loginPage.css">

<body>
<div class="login">
    <h1>网络探针综合平台</h1>
    <form id="testUser" name="testUser" action="${_baseUrl}/login" method="post">
        <input class="validate[required] input1" name="userId" id="userId" type="text" placeholder="请输入用户名"/>
        <input class="validate[required] input2"  name="password" id="password" type="password"  placeholder="请输入密码"/>
        <input type="hidden" name="isRemember" id="isRemember" value="">
        <input type="hidden" name="token" id="token" value="${token}">
        <button class="but" id="loginButton" type="button" onclick="r();"  >登录</button>
    </form>
</div>
</body>
<script type="text/javascript">
    function r()
    {
        var username=document.getElementById("userId");
        var pass=document.getElementById("password");
        if(username.value=="")
        {
            alert("请输入用户名");
            username.focus();
            return;
        }
        if(pass.value=="")
        {
            alert("请输入密码");
            return;
        } 
        if($("#testUser").validationEngine('validate')){
	        $("#loginButton").attr("disabled","true"); //设置变灰按钮  
	        $("#testUser").submit();
	        setTimeout("$('#loginButton').removeAttr('disabled')",5000); 
        }
    }
    //ie10以下placeholder兼容样式
    $(function () {
        //浏览器不支持 placeholder 时才执行
        if (!('placeholder' in document.createElement('input'))) {
            $('[placeholder]').each(function () {
                var $tag = $(this); //当前 input
                var $copy = $tag.clone();   //当前 input 的复制
                if ($copy.val() == "") {
                    $copy.css("color", "#fff");
                    $copy.val($copy.attr('placeholder'));
                }
                $copy.focus(function () {
                    if (this.value == $copy.attr('placeholder')) {
                        this.value = '';
                        this.style.color = '#fff';
                    }
                });
                $copy.blur(function () {
                    if (this.value=="") {
                        this.value = $copy.attr('placeholder');
                        $tag.val("");
                        this.style.color = '#fff';
                    } else {
                        $tag.val(this.value);
                    }
                });
                $tag.hide().after($copy.show());    //当前 input 隐藏 ，具有 placeholder 功能js的input显示
            });
        }
    });
    $(function() {
    	   if (navigator.userAgent.toLowerCase().indexOf("chrome") >= 0) {
    	      $(window).load(function(){
    	         $('input:not(input[type=submit])').each(function(){
    	         var outHtml = this.outerHTML;
    	         $(this).append(outHtml);
    	         });
    	      });
    	   }
    	});
</script>



</html>