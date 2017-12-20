<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0 minimal-ui"/>
<meta name="apple-mobile-web-app-capable" content="yes"/> -->
<title>文档管理工具</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<style type="text/css">
body,html{
	height:100%;
	overflow:hidden;
}
</style>
<script type="text/javascript">
/* 让js支持indexof方法 */
if (!Array.prototype.indexOf)
{
  Array.prototype.indexOf = function(elt /*, from*/)
  {
    var len = this.length >>> 0;

    var from = Number(arguments[1]) || 0;
    from = (from < 0)
         ? Math.ceil(from)
         : Math.floor(from);
    if (from < 0)
      from += len;

    for (; from < len; from++)
    {
      if (from in this &&
          this[from] === elt)
        return from;
    }
    return -1;
  };
}


$(function (){
	var menuParents = '${menuParents}';
	var menuJson = eval('(' + menuParents + ')');
	var li = "";
	for(var i=0;i<menuJson.length;i++){
		li += "<li><a id=\""+menuJson[i].menuId+"\" href=\"javascript:;\" onclick=\"skip('"+menuJson[i].menuUrl+"','"+menuJson[i].menuId+"');changeCss(this)\" class=\""+menuJson[i].classType+"\">"+menuJson[i].menuName+"</a></li>";
	}
	$("#ul").children("li").remove();
	$("#ul").append(li);
	
	//默认点击第一个
	$("#ul>li:visible:first >a").click();
	
	//提示修改密码
	if("true" == "${updateMessage}"){
		layer.confirm('密码即将失效，请尽快更换平台登录密码。', {
		  btn: ['确定','取消'] //按钮
		}, function(index){
			layer.close(index);
			editPwdFun();
		});
	}
	
	/* 退出 */
	$("#login_out_close_windows").click(function(){
		$.ajax({
	        type: "post",
	        dataType: "html",
	        url: '${_baseUrl}/logout/closewindows',
	        data: {},
	        success: function (data) {
	        	//关闭浏览器支持火狐
	         	var userAgent = navigator.userAgent;
				if (userAgent.indexOf("Firefox") != -1 || userAgent.indexOf("Chrome") !=-1) {
				   window.location.href="about:blank";
				} else {
				   window.opener = null;
				   window.open("", "_self");
				   window.close();
				};
	        }
	    });
	});
});


function changeCss(evl){
	var child = evl.parentNode.parentNode.childNodes;
	for(var i=0;i<child.length;i++){
		if(child[i].nodeName=="LI"){
			child[i].removeAttribute("class");
		}
	}
	evl.parentNode.setAttribute("class","navicon_on");
}

/* 跳转 */
function skip(url,menuId){
	var div = document.getElementById("indexIframe");
	div.src ="${_baseUrl}"+url+"?menuId="+menuId;
}


function closeAndSkip(moduleName,url,id){
	//将消息修改成已读
	$.ajax({
        type: "post",
        dataType: "json",
        url: '${_baseUrl}/index/updateMessageStatus',
        data: {messageId:id},
        success: function (data) {
        	if("1" == data.code){
        		//关闭弹出框
        		closeWin();
        		//跳转
        		skipModule(moduleName,url);
        	}else{
        		layer.msg(data.message);
        	}
        },
        error:function(json){
			layer.msg("发生错误");
		}
    });
}

//跳转  跳转到上下结构
function skipModule(moduleName,url){
	//修改css样式
	$("#ul").children("li").each(function (){
		$(this).removeAttr("class");
		var a = $(this).children("a");
		if(a.html() == moduleName){
			$(this).attr("class","navicon_on");
			if("" == url){
				a.click();
			}
		}
	});
	//跳转路径
	if("" != url){
		var div = document.getElementById("indexIframe");
		div.src = url;
	}
}



function editPwdFun(){
	
	saveReplace();
	$("#editPwdIframe").empty();	
	$("#editPwdDiv").dialog({
		title:'修改密码',
		autoOpen: true,
		modal: true,	
		height: 320,
		width: 610,
		close:function(event,uri){
			showBeforeSection();
			
		}
	});	
	$("#editPwdIframe").attr("width","100%");
 	$("#editPwdIframe").attr("height","95%");
	$("#editPwdIframe").attr("src","${_baseUrl}/userController/editPwdPage"); 
	
}
	
/* 待办事项 */
function showHandMessage(){
 	$("#editPwdIframe").empty();	
	$("#editPwdDiv").dialog({
		title:'待办事项',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 900
	});	
	$("#editPwdIframe").attr("width","100%");
	$("#editPwdIframe").attr("height","95%");
	$("#editPwdIframe").attr("src","${_baseUrl}/index/showHandMessage");
	
	//iframe层
	/* layer.open({
	  type: 2,
	  title: '待阅事项',
	  shadeClose: true,
	  maxmin: true,
	  area: ['900px', '500px'],
	  content: '${_baseUrl}/index/showHandMessage' //iframe的url
	});  */
	
	
}





/* 待阅事项 */
function showReadMessage(){
	$("#editPwdIframe").empty();	
	$("#editPwdDiv").dialog({
		title:'待阅事项',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 900
		
	});	
	$("#editPwdIframe").attr("width","100%");
	$("#editPwdIframe").attr("height","95%");
	
	$("#editPwdIframe").attr("src","${_baseUrl}/index/showReadMessage");
	
	//iframe层
	/* layer.open({
	  type: 2,
	  title: '待阅事项',
	  shadeClose: true,
	  maxmin: true,
	  area: ['900px', '500px'],
	  content: '${_baseUrl}/index/showReadMessage' //iframe的url
	});  */
}

function saveReplace(){
	try{
	$(window.parent.document).contents().find("#indexIframe")[0].contentWindow.saveReplace();
	}
	catch(err){
		return;
	}		
}
function showBeforeSection(){
	try{
	$(window.parent.document).contents().find("#indexIframe")[0].contentWindow.showBeforeSection();
	}
	catch(err){
		return;
	}		
}
/* 关闭弹出框 */
function closeWin(){
	$("#editPwdDiv").dialog('close');
}

</script>

<style>
 	.maBox { width:100%; height:187px; position:relative; }
  	.icon { border:2px solid #0670C8; border-radius: 6px; width:30px; height:30px; color:#666; font-size:8px; -webkit-text-size-adjust:none; -webkit-transform-origin-x: 0;
　　-webkit-transform: scale(0.6666667); position:absolute; z-index:9000; right:20px; }   
  	.icon .iconTop { width:30px; height:30px; text-align:center; line-height:40px; background:url(${_resources}images/top.png) 0 0 no-repeat; }
  	.icon .iconDown { width:30px; height:30px; text-align:center; line-height:40px; background:url(${_resources}images/down.png) 0 0 no-repeat; }
</style>

</head>
<body>
<div class="container">
	<!-- 头部开始  -->
	<div id="maBox" class="maBox">
	    <div class="ma header">
	        <div class="fl logo">
	        	<img src="${_resources}images/logo.png" alt="" >
	        </div>
	        <ul>
	            <li class="topicon_1">${userName}，您好，欢迎访问并使用！</li>
	            <!-- <li class="topicon_2"><a href="javascript:;">设计</a></li> -->
	            <li class="topicon_3"><a href="javascript:;" onClick="editPwdFun();">修改密码</a></li>
	            <li class="topicon_4"><a href="${_baseUrl}/logout">注销</a></li>
	        </ul>
	    </div>
	    <div class="ma nav" >
	        <ul id="ul">
	            <!-- <li><a href="javascript:;" class="nav_icon1">首页</a></li>
	            <li><a href="javascript:;" class="nav_icon1">项目管理</a></li>
	            <li><a href="javascript:;" class="nav_icon2">组织资产</a></li>
	            <li class="navicon_on"><a href="javascript:;" class="nav_icon3">用户管理</a></li>
	            <li><a href="javascript:;" class="nav_icon4">组织管理</a></li>
	            <li><a href="javascript:;" class="nav_icon5">授权管理</a></li>
	            <li><a href="javascript:;" class="nav_icon6">审计管理</a></li>
	            <li><a href="javascript:;" class="">文档模板管理</a></li>
	            <li><a href="javascript:;" class="nav_icon8">文档范本库</a></li>
	            <li><a href="javascript:;" class="nav_icon9">帮助</a></li>  -->
	        </ul>
	    </div>
	</div>
	<!-- 头部结束 -->
	
	<!-- 点击小图标开始  -->
	<div class="icon">
		<div id="iconTop" class="iconTop" onclick="slipHidden();initHeight();"></div>
		<div id="iconDown" class="iconDown" onclick="slipShow();initHeight();" style="display:none;"></div>
	</div> 
	<!-- 点击小图标结束  -->
	   
    <div id="iframeCont" class="iframe_cont" style="margin-top:0px;">
        <iframe id="indexIframe" frameborder="0" style="width:100%; height:100%;" src=""></iframe>       
    </div> 
	<div class="clear"></div>

</div>
   <div id="editPwdDiv" style="display: none;" >
		<iframe id="editPwdIframe" border="0" frameborder="0"></iframe>
	</div> 
	<div id="divs" >
		
	</div>
</body>

<script>
	window.onload = function(){
		initHeight();
	}
	window.onresize = function(){
		var  resizeTimer = null;
	    if(resizeTimer) clearTimeout(resizeTimer);
	    resizeTimer = setTimeout("initHeight()",100);
	 }
	function initHeight(){
		var oMaBox = document.getElementById("maBox");
		var topH = oMaBox.getBoundingClientRect().height; 
		
		if(navigator.userAgent.indexOf("MSIE")>0 || navigator.userAgent.indexOf("like Gecko")>0) {//IE浏览器
			topH = oMaBox.clientHeight; 
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Firefox")>0){//Firefox浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Opera")>0){//Opera浏览器
			initheight = document.body.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Chrome")>0){//Chrome谷歌浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Safari")>0){//Safari浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		$("#iframeCont").css( "height",initheight );
		
	}
	function slipHidden(){
		var oTop = document.getElementById("iconTop");
		var oDown = document.getElementById("iconDown");
		var oBox = document.getElementById("maBox");
		oTop.style.display = "none";
		oDown.style.display = "block";
		oBox.style.display = "none";
	}
	function slipShow(){
		var oTop = document.getElementById("iconTop");
		var oDown = document.getElementById("iconDown");
		var oBox = document.getElementById("maBox");
		oTop.style.display = "block";
		oDown.style.display = "none";
		oBox.style.display = "block";
	}
</script>

</html>