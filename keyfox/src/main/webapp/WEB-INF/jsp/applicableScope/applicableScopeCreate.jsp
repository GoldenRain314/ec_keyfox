<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>适用范围</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
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


function formSubmit(){
	var options = {
		dataType:"json",
		success:function(json){
			if(json.code == '1'){
				layer.msg(json.message,{shift:5,time:1500},function(){
					parent.closeWin();
					parent.getApplicationScope();
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
	var path="${_baseUrl}/applicableScopeController/judgeScopeName";
	var name = $("#scopeName").val();
	if(name !=""){
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"scopeName":name
			},
			dataType:"json",    
			success: function (json) {   
				if(json.code=="1"){
					layer.msg("范围名称已经存在");
					$("#scopeName").val("");
				}
			}   
		});
	}
}

</script>
</head>
<body>
<form action="${_baseUrl}/applicableScopeController/addApplicableScope"  method="post" id="form">
<div class="jbinformation">
    <table width="400" border="0" cellspacing="0" cellpadding="0">
		<tr>
        <td width="50" align="center" bgcolor="#f7f4f4" >范围名称:</td>
        <td width="85"><div class="jbxinxi_s"><input type="text" name="scopeName" id="scopeName" onblur="judgeName();" class="jbxinxi_input validate[required]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>  
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
    <a href="javascript:;" id="submit" onclick="formSubmit();" class=" per_baocun">保 存</a>
    <a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">关 闭</a>

</div>		
</form>
</body>
</html>