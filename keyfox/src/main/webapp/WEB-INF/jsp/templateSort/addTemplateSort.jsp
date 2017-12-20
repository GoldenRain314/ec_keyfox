<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>新增模板分类</title>
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript">
$(function(){
	$("#form").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomLeft',//提示信息的位置
		autoPositionUpdate:false, 
		inlineValidation: true,//是否即时验证，false为提交表单时验证,默认true  
		failure : function() {
		    layer.message("验证失败，请检查");
			return false;  
		},//验证失败时调用的函数
		ajaxFormValidation: true,//开始AJAX验证
		//success : function() {
		//	$("#addForm").submit();
		//}//验证通过时调用的函数 
		//onAjaxFormComplete: ajaxValidationCallback
	});
	
})

function formSubmit(){
	var options = {
		dataType:"json",
		success:function(json){
			if(json.code == '1'){
				layer.msg(json.message,{shift:5,time:1500},function(){
					parent.closeWin();
					parent.refreshTree(json.data);
				});
			}
			if(json.code == '0'){
				layer.msg(json.message);
			}
		},
		error:function(json){
			layer.msg("发生错误");
		}
	};
	if($("#form").validationEngine('validate')){
		$("#submit").attr("onclick","")
		$('#form').ajaxSubmit(options);
	}
	
}


//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}

function judgeName(){
	var path="${_baseUrl}/templateSortController/judgeSortName";
	var name = $("#sortName").val();
	if(name !=""){
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"sortName":name
				
			},
			dataType:"json",    
			success: function (json) {   
				if(json.code=="1"){
					layer.msg("分类名称已经存在");
					$("#sortName").val("");
				}
			}   
		});
	}
}
</script>
<body>
<div style="padding-bottom:5px;">
<form action="${_baseUrl}/templateSortController/saveTemplateSort" method="post" id="form" name="form">
<input type="hidden" name="parentId" value="${parentId}">

<div class="jbinformation" style="width:353px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
        <td width="24%" align="center" bgcolor="#f7f4f4" >分类名称:</td>
        <td width="76%"><div class="jbxinxi_s"><input type="text" name="sortName" id="sortName" onblur="judgeName();" class="jbxinxi_input validate[maxSize[50] required]" style="width:225px;"></div><div class="jbxinxi_span1">*</div></td>
      </tr>  
    </table>
</div>
</form>
<div class="permission_an mubanclass_an ma mt20">
	<shiro:hasPermission name="templateSortController:saveTemplateSort">
       <a href="javascript:;" id="submit" onclick="formSubmit();" class=" per_baocun">保 存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class=" per_gbi" onclick="cancelAndClose();">关 闭</a>

</div>

</div>



</body>
</html>