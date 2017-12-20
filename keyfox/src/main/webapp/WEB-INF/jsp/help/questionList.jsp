<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>问题列表</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">

</script>

<style>
	.main_cont { margin:0;}
	.dingxwd_main { margin:0;}
	.help_cont_t { padding-bottom:20px;}
</style>

<body>
   <div class="main_cont dingxwd_main" > <!-- style="margin-left:251px;" -->
       <div class="main_c">
           <div class="help_list pt50">
               <h2 class="help_cont_tit">${menuName }</h2>
               <ul>
               	<c:forEach var="list" items="${list }">
               		<li><a href="${_baseUrl}/hq/showQuestionDetails?qId=${list.qId}" title="${list.qName }">${list.qName }</a></li>   <!-- 添加title属性缺省时提示内容信息 _0603 -->
               	</c:forEach>
               	<div class="clear"></div>
               </ul>
           </div>
           
       </div>
   </div>
<div id="popDiv" style="display: none;">
	<iframe id="popIframe"></iframe>
</div>
</body>
</html>