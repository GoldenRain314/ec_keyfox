<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>展示需求追踪关系表格</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
$(function(){
	layer.msg('正在查询追踪关系', {icon: 16},{offset:['10%','75%']});	
	$("#implement").click(function(){
		var iframe = document.getElementById("templatelist");
		iframe.src = "${_baseUrl}/dd/checkDesignTrack?projectId=${projectId}";
		layer.msg('正在查询追踪关系', {icon: 16},{offset:['10%','75%']});	
		
		if(navigator.userAgent.indexOf("MSIE")>0 ){
			if (iframe.attachEvent){ 
				iframe.attachEvent("onload", function(){ 
					setTimeout("setIframeHeight()",100);
				}); 
			} else { 
				iframe.onload = function(){ 
					setTimeout("setIframeHeight()",100);
				}; 
			} 
		}
		
	});
	$("#test").click(function(){
		layer.msg('正在查询追踪关系', {icon: 16},{offset:['10%','75%']});	
		var iframe = document.getElementById("templatelist");
		iframe.src = "${_baseUrl}/dd/checkTestTrack?projectId=${projectId}";
		
		if(navigator.userAgent.indexOf("MSIE")>0 ){
			if (iframe.attachEvent){ 
				iframe.attachEvent("onload", function(){ 
					setTimeout("setIframeHeight()",100);
				}); 
			} else { 
				iframe.onload = function(){ 
					setTimeout("setIframeHeight()",100);
				}; 
			} 
		}
		
	});
	initHeight();
	if(navigator.userAgent.indexOf("MSIE")>0 ){
		setIframeHeight();
	}
})
// 设置iframe高度随内容页高度适应
window.onresize = function(){
	setTimeout(function(){
		var initheight = $("#templatelist").contents().find("body").height() + 30;
		$("#templatelist").parent().height(initheight);
	},100);
}  

function initHeight(){
	$("#templatelist").load (function(){
		setTimeout(function(){
			var initheight = $("#templatelist").contents().find("body").height() + 30;
			$("#templatelist").parent().height(initheight);
		},100);
	})
}

// 设置iframe高度随内容页高度适应兼容ie浏览器
function setIframeHeight(){
	var newHeight = 0;
	try{
		var iframe = document.getElementById("templatelist"); 
		if(iframe.Document){
			newHeight = iframe.Document.body.clientHeight + 300 +"px";
		}else{
			newHeight = iframe.contentDocument.body.clientHeight + 300 + "px";
		}
		iframe.parentNode.parentNode.style.height = newHeight;
	}catch(e){
		throw new error("error");
	} 
}

</script>
<body>
    <div class="ma main">
		<div class="wdang_main mt20"  >
    		<div class="page_tit_warp mtmb20"><div class="page_tit"><span>需求全景追踪</span></div></div>
        	<div class="wdang_tab" >
            	<a href="javascript:;" id="implement" class="wdtab_on">软件实现类</a>
                <a href="javascript:;" id="test" >软件测试类</a>
            </div>           
            <div style="display:block;" id="iframe_aa" class="iframe_aa">
          		<iframe name="tmpViewList" id="templatelist" style="width:100%; height:100%;" border="0" frameborder="no" src="${_baseUrl}/dd/checkDesignTrack?projectId=${projectId}">
            </div>
        </div>
    </div>
</body>
</html>