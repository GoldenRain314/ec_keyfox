<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>文档模板库</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>

<script type="text/javascript">
$(function(){	
	var source = "${source}";
	if(source != null && source != ""){
		$("#project").click();
		var frame=	$("#templatelist");
		$(frame).attr("src","${_baseUrl}/projectTemplateTypeController/showAllProjectTemplate");
	}
	$("#define").click(function(){
		var frame=	$("#templatelist");
		frame.height = 1000;
		$(frame).attr("src","${_baseUrl}/documentTemplateController/showDefineDocumentTemplate");
	});

	$("#standrad").click(function(){
		var frame=	$("#templatelist");
		$(frame).attr("src","${_baseUrl}/documentTemplateController/showStandradDocumentTemplate");
	});
	$("#style").click(function(){
		var frame=	$("#templatelist");
		$(frame).attr("src","${_baseUrl}/styleTemplateController/styleTemplateAll");
	});

	$("#project").click(function(){
		var frame=	$("#templatelist");
		$(frame).attr("src","${_baseUrl}/projectTemplateTypeController/showAllProjectTemplate");
	});
})

</script>
<body>
     <div class="ma main">
    	<div class="wdang_main mt20"  >
        	<!-- <div class="page_tit_warp mtmb20"><div class="page_tit"><span>文档模板库</span></div></div> -->
        	<div class="wdang_tab" >
	            	<a href="javascript:;" id="define" class="wdtab_on">自定义文档模板</a>
	        	<%-- <shiro:hasPermission name="documentTemplate:define">
	            </shiro:hasPermission> --%>
	            <shiro:hasPermission name="documentTemplate:standrad">
	                <a href="javascript:;" id="standrad" >标准文档模板</a>
	            </shiro:hasPermission>
                <a href="javascript:;" id="style">样式模板定义</a>
	            <%-- <shiro:hasPermission name="documentTemplate:style">
	            </shiro:hasPermission> --%>
                <a href="javascript:;" id="project">项目模板类型定义</a>  
	            <%-- <shiro:hasPermission name="documentTemplate:project">
	            </shiro:hasPermission> --%>
            </div>           
            <div style="display:block;" class="iframe_aa">
          		<iframe name="tmpViewList" id="templatelist" style="width:100%; height:100%;" border="0" frameborder="no" src="${_baseUrl}/documentTemplateController/showDefineDocumentTemplate">
            </div>
        </div>
    </div> 
    
    <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>  
</body>
</html>