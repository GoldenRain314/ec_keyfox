<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>测试管理</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>


<script type="text/javascript">
$(document).keyup(function(event){
	  if(event.keyCode ==13){
		  logCheck();
	  }
	});
$(function (){
	
	if (window!=top) // 判断当前的window对象是否是top对象
		top.location.href =window.location.href; 
	
	var success = "${success}";
	if("1" == success){
		layer.msg("${message}");
	}
	
	var errorMessage = '${errorMessage}';
	if('' != errorMessage){
		layer.msg(errorMessage);
	}
	
	changeColor();
	
});

function logCheck(){
	if($("#testUser").validationEngine('validate')){
		$("#testUser").submit();
	}
}

// 重置后改变输入框文字颜色并在密码输入框中添加提示信息
function changeColor(){
	$("input[type='reset']").click(function(){
		$("#userId").css('color','#C3C3C3');
		$("#password").css('color','#C3C3C3');
	})
	$(" .clearCross").css({'height':'34px','margin-top':'8px'});   /* 修改显示位置  */
}

</script>
<style>
.pwd-place {
    position: absolute;
    font-family: Microsoft Yahei,Arial;
	font-size: 14px;
	color: #C3C3C3;
    width: 380px;
    height: 50px;
    top:0;
    left:50px;
 }

</style>

</head>
<body>
<div class="ma land_header">
	<div class="land_header_c ma">
		<div class="fl land_logoa"><img src="${_resources }images/land_logoa.png" alt="" ></div>
		<div class="land_logob ma"><img src="${_resources }images/land_header_t.png" alt="" ></div>
    </div>
</div>
<div class="land_main">
	<div class="land_cont ma">
    	<div class="fl land_cont_l">
    		<div class="land_logo"><img src="${_resources }images/land_logo.png" alt="" ></div>
    		<div id="demo" class="demo">
			<div id="demo1">	
			<br>	    	
            	<p>文档自动化编制工具是一个通用性强、适用范围广的文档协同编制平台，可减轻一线文档编写人员的繁琐工作，并给项目管理人员提供本地化文档编制标准的落地实施和项目技术文档统一管理的平台。与此同时，通过项目文档模板的复用、文档格式自动化套用等技术手段，提高文档编制的效率；通过文档内容溯源与内容变更影响分析减少文档间的差异性，为产品研制积累完整、准确、合规的技术文档资源。</p>
		    	
		    	<p>产品特点如下：</p>
		    	<p>（1）灵活定制各类文档模板、样式定义库、样式输出库，满足用户定制化文档标准的实施，实现文档格式与内容的一体化和差异化管理。</p>
		    	<p>（2）文档模板的智能化复用，大幅度减轻不必要的繁琐工作，提高工作效率。</p>
				<p>（3）有效的文档版本管理与控制,实现高效、易用、可信的版本管控。</p>
				<p>（4）标准化的文档自动生成，减轻一线人员繁琐的格式设置工作，一键生成项目全套文档，并保证项目文档的完备与齐全。</p>
				<p>（5）通过构建文档之间内容的关联关系，实现技术文档的需求双向追踪分析，并提供项目所有文档需求的全景追踪，确保需求追踪的完整性和严谨性。</p>
				<p>（6）文档内容变更全面、准确、高效的影响域分析，确保文档变更及时传达到相关方，保证内容变更的一致性。</p>
				<p>（7）高效的文档自动化生成的协同编制平台，提高文档编写效率，并满足用户本地化文档编制要求落地的适配要求，推动文档编制规范的统一执行，减少项目成员文档编写的差异性。</p>
		    
		    </div>
			<div id="demo2"></div>
			</div>
    	
        </div>
        <form name="testUser" id="testUser" action="${_baseUrl}/login" method="post">
	        <div class="fl land_cont_r">
	        	<dl>
	            	<dt>用户名：</dt>
	                <dd><input name="userId" id="userId" type="text" class="validate[required] land_input land_input1" value="请输入您的账号" onFocus="if(this.value=='请输入您的账号'){this.value='';$(this).css('color','black')}" onBlur="if(this.value==''){this.value='请输入您的账号';$(this).css('color','#C3C3C3')}else{$(this).css('color','black')}" /></dd>    <!-- 改变输入框的颜色  -->
	            </dl>
	            <dl>
	            	<dt>密&nbsp;&nbsp;&nbsp;&nbsp;码：</dt>
	                <dd style="position:relative;">
	                	<input name="password" id="password" type="password" class="validate[required] land_input land_input2" value="" onFocus="if(this.value==''){$(this).css('color','black');}" onBlur="if(this.value==''){$(this).css('color','#C3C3C3');}">   
	                </dd>   
	            </dl>
	            <div class="land_btnbox">
	            	<!-- <input type="text" name="kaptcha" width="50px" />
			    	<img src="Kaptcha.jpg" width="100" id="kaptchaImage" title="看不清，点击换一张" /> 
			    	<br/><br/>  -->
	            	<input name="" type="button" value="登 录" class="fl land_btn land_btn1" onClick="logCheck();">
	                <input name="" type="reset" value="重 置" class="fr land_btn land_btn2">
	                <input type="hidden" name="isRemember" id="isRemember" value="">
        			<input type="hidden" name="token" id="token" value="${token}">
	            </div>
	        </div>
        </form>
        <div class="clear"></div>
    </div>
    <div class="land_footer"><span>法律声明 ©2015-2018.3.11</span><span><a target="_blank" href="http://www.keyware.com.cn">www.keyware.com.cn</a></span><span>Tel:010-80750488&nbsp;&nbsp;版权所有：北京关键科技股份有限公司</span></div>
</div>
<script type="text/javascript">
var speed=50
   demo2.innerHTML=demo1.innerHTML
   function Marquee(){
   if(demo2.offsetTop-demo.scrollTop<=0)
   demo.scrollTop-=demo1.offsetHeight
   else{
   demo.scrollTop++
   }
   }
   var MyMar=setInterval(Marquee,speed)
   demo.onmouseover=function() {clearInterval(MyMar)}
   demo.onmouseout=function() {MyMar=setInterval(Marquee,speed)}
</script>
</body>




</html>