<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>变更类型</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
	$(function (){
		$("#submit").click(function (){
			if("1" == $("input[name='errorType']:checked").val()){
				//勘误错误
				parent.openReplacePage("${projectId}");
				
			}else{
				parent.skipChangeRequestNote("${projectId}");
			}
		});
		
	})
</script>
<body>
	<div class="nrlx_box">
		<span>请选择变更内容类型</span>
   <ul>
   
   	<li><i><input type="radio" name="errorType" checked="checked" value="1"  /></i><p>勘误变更   少量文字错误，修改后不变更文档版本</p><div class="clear"></div></li>
   
   	<li><i><input type="radio" name="errorType" value="0" /></i><p>需求变更   文档内容变更，修改后变更文档版本</p><div class="clear"></div></li>
   </ul>
   <div class="nrlx_btn">
   	<input type="button" value="提交" id="submit" class="nrlx_btna" />
   
   </div>
   
    
</div>

</body>
</html>