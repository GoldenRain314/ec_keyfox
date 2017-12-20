<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>修改文档模板</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript">
//表单提交方法
function formSubmit(){
	tipPostion();
	var options = {
			dataType:"text",
			success:function(json){
				layer.msg(json,{shift:2,time:2000},function(){
					parent.closeWin();
				});
			},
			error:function(json){
				layer.msg("发生错误");
			}
		};
		if($("#form").validationEngine('validate')){
			$("#submit").attr("onclick","");
			$('#form').ajaxSubmit(options);
		}
}
//验证必填提示显示位置
function tipPostion(){
	$("#form").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomRight',//提示信息的位置
		inlineValidation: true,//是否即时验证，false为提交表单时验证,默认true  
	});
}
//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}

function judgeFileType(){	
	var fileType =$("#textfield").val();
	var typeMark =  fileType.substring(fileType.length-4,fileType.length);
	if(typeMark ==".doc"||typeMark ==".DOC"||(typeMark =="docx" &&fileType.indexOf("."))||(typeMark=="DOCX"&&fileType.indexOf("."))){
		return true;
	}else{
		return "请选择doc或docx文件！"
	}
}

</script>
</head>
<body>
<form name="testFileFileUpload" id="form" action ="${_baseUrl}/documentTemplateController/alertStandardTemplate" method="post"  enctype="multipart/form-data" > 
<div class="popup_tit mtmb20">修改文档模板</div>
<input type="hidden" value="${source}" name="type" id ="type" />	
<div class="jbinformation" style="width:100%;">
	<input type="hidden" name="documentId" value="${documentId}">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
        <td width="25%" align="center" bgcolor="#f7f4f4" name="documentTemplateName">文档模板名称</td>
        <td width="75%"><div class="jbxinxi_s"><input type="text" name="documentTemplateName" id="documentTemplateName" value="${documentName}" disabled="disabled" class="jbxinxi_input validate[required]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">新文档</td>
        <td><div class="jbxinxi_s jbxinxi_sj"><input type="file" name=multipartfile id="textfield" class="jbxinxi_input_f validate[required,funcCall[judgeFileType]]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="documentTemplateController:alertStandardTemplate">
       <a href="javascript:;" id="submit" onclick="formSubmit();" class=" per_baocun">保 存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class=" per_gbi" onclick="cancelAndClose();" >关 闭</a>

</div>		
</form>
</body>

</html>