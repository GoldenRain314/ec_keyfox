<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>添加章节</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript">
$(function(){
	$("#form").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomRight',//提示信息的位置
		inlineValidation: true,//是否即时验证，false为提交表单时验证,默认true  
		failure : function() {
		    layer.message("验证失败，请检查");
			return false;  
		},//验证失败时调用的函数
		ajaxFormValidation: true,//开始AJAX验证
		success : function() {
		//	$("#addForm").submit();
		}//验证通过时调用的函数 
		//onAjaxFormComplete: ajaxValidationCallback
	});
	
})

//表单提交方法
function onSubmit(){
	var options = {
		dataType:"json",
		success:function(json){
			layer.msg(json.message,{shift:5,time:1500},function(){
				parent.closeWin();
			});
		},
		error:function(json){
			layer.msg("发生错误");
			parent.closeWin();
		}
	};
	if($("#form").validationEngine('validate')){
		$("#submit").attr("onclick","")
		$('#form').ajaxSubmit(options);
	}
}
//验证必填提示显示位置
function tipPostion(){
	$("#form").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'center',//提示信息的位置
		inlineValidation: true,//是否即时验证，false为提交表单时验证,默认true  
	});
}
//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}

document.onkeydown=function(event) 
{ 
	e = event ? event :(window.event ? window.event : null); 
	if(e.keyCode==13){ 
		return false; 
	} 
} 

</script>
</head>
<body>
<div class="chapter_popup">
    <div class="chapter_tc_c">
    <form action="${_baseUrl}/documentList/saveTitle" id ="form" name ="form" method="post">
    	<table width="571" border="0" cellspacing="0" cellpadding="0" id ="sectionTable" class="tablebox">   	
    	<input value ="${documentId}" id = "documentId" name="documentId" type="hidden"/>
          <tr>
            <td height="45" align="center"><strong>正文标题</strong></td>
          </tr>
          <tr >
          	 <td height="45" align="center" > 
          			<input type="text" value="${contextTitle}"  class="input_text validate[maxSize[100]]" id="contextTitle"  name="contextTitle"/>
       		 </td>
       	  </tr>
        </table>
   	</form>
    </div>
     <div class="permission_an mubanclass_an ma mt20">
    	<a href="javascript:;" class="per_baocun" id="submit" onclick="onSubmit();">提 交</a>
        <a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">取 消</a>
    </div>
</div>
	
</body>
</html>