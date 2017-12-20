<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" /> 
<style type="text/css">
html, body, div, span, h1, h2, h3, h4, h5, h6, p, abbr, address, cite, code, del, dfn, em, img, sub, sup, var, i, dl, dd, dt, ol, ul, li, fieldset, form, label, legend, table, caption, tbody, tfoot, thead, tr, th, td, article, aside, figure, footer, header, hgroup, menu, nav, section, time, mark, audio, video{margin:0;padding:0; zoom:1;}
article, aside, figure, footer, header, hgroup, nav, menu, section {display: block;}
h1,h2,h3,h4,h5,h6{font-size:100%; }
input, select {	vertical-align: middle;}
textarea{resize:none;}
a,button{outline: none;*star: expression(this.onFocus=this.blur());cursor: pointer;}
img{vertical-align:top;}
ul,li{ list-style:none;}
a{text-decoration:none;color: #404040;}
a:hover{ color:#303030;}
a:active{text-decoration:none;color: #404040;}
.button_div_return{
	height:27px;
	line-height:27px;
	overflow:hidden;
	margin-top:10px;
	margin-bottom:10px;
}
.button_return{
	float: right;
	font-family:Microsoft Yahei,Arial;
	border:1px solid #017fed;
	background:#0080ed;
	padding:0 15px;
	font-size:14px;
	border-radius:4px;
	transition:all 0.3s;
	color:#fff;
}
.button_return:hover{
	
	color:#fff;
}

</style>
<title>文档预览</title>
<script type="text/javascript">
function returnToFirst(){
	history.go(-1);
}
</script>
 </head>
 
 <body>
   <div class="xmugonj_cont ma" style="display:block;">
	    <div class="button_div_return">
			<a href="javascript:;" class="button_return" onclick="returnToFirst();">返回</a>
	    </div>
   </div>
<div class="wdang_cont">
     	<iframe name="projectForming" id="projectForming" style="width:100%; height:400px;" src="${_baseUrl}/documentController/documentPreview?documentId=${documentId }&projectId=${projectId }" frameborder=0 ;scrolling="auto">
  </div>
</body>
</html>
