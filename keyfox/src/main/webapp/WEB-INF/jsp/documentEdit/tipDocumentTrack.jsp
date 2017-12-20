<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>提示追踪页</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>

<script type="text/javascript">

//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
	parent.judgeBlankSection();
}

</script>
</head>
<body>
<div >
  <div class="chapter_tc_tit" >当前文档有前项追踪文档，建议确认文档的需求追踪关系。</div>   <!-- “……前置……”修改为“……前项……” -->
    
	<div class="permission_an mubanclass_an ma" style="width: 280px;margin-top: 30px;">
    	<a href="javascript:;" class=" fl per_baocun"  onclick="">确定</a>
        <a href="javascript:;" class="fr per_gbi" onclick="cancelAndClose();">跳过此步</a>
    </div> 
</div>
</body>
</html>