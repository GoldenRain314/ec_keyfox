<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE HTML>
<head>
	<%
		String uri = request.getContextPath() + "/index";
	%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>错误信息</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<script type="text/javascript">
		if("禁止重复提交数据" == "${message}"){
			window.location.href = "<%=uri%>";
		}else{
			setTimeout("window.history.back(-1);",2000);
		}
	</script>
  </head>
  <body>
    	${message} <br>
  </body>
</html>
