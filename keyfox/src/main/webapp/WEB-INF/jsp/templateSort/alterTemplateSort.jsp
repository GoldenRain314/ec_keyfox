<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>修改分类数据</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
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
	$("#submit").click(function (){
		judgeName();
		var options = {
			dataType:"json",
			success:function(json){
					layer.msg(json.message,{shift:5},function(){
						parent.closeWin();
						parent.ztree.getNodeByParam("id","${parentId}",null).name =$("#sortName").val();
						parent.ztree.updateNode(parent.ztree.getNodeByParam("id","${parentId}",null));
					});
			},
			error:function(json){
				layer.msg("发生错误");
			}
		};
		if($("#form").validationEngine('validate')){
			$('#form').ajaxSubmit(options);
		}
	});
})
//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}

function judgeName(){
	var path="${_baseUrl}/templateSortController/judgeSortName";
	var oldName ="${name}";
	var name = $("#sortName").val();
	if(name !=""){
		if(name ==oldName){
			layer.msg("没有做任何修改");
		}else{
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
}


</script>
<body>
<form action="${_baseUrl}/templateSortController/alterTemplateSort" method="post" id="form" name="form">
<input type="hidden" name="id" value="${parentId}">

<div class="jbinformation">
    <table width="400" border="0" cellspacing="0" cellpadding="0">
		<tr>
        <td width="50" align="center" bgcolor="#f7f4f4" >分类名称:</td>
        <td width="85"><div class="jbxinxi_s"><input type="text" name="sortName" id="sortName"  onblur="judgeName();"  value="${name}" class="jbxinxi_input validate[maxSize[50] required]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>  
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="templateSortController:alterTemplateSort">
       <a href="javascript:;" id="submit" class=" per_baocun">保 存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class=" per_gbi" onclick="cancelAndClose();">关 闭</a>

</div>
</form>
</body>
</html>