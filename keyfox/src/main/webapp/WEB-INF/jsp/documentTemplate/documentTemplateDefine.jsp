<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>

<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<title>文档模板上传</title>
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<%-- <%@ include file="/WEB-INF/jsp/common/inc.jsp" %> --%>
<script type="text/javascript">
//表单提交方法
function formSubmit(){
	tipPostion();
	if($("#form").validationEngine('validate')){
		var fileType =$("#textfield").val();
		 layer.load(2);
		$("#submit").attr("onclick","");
		$('#form').submit();
	}	
}

function judgeFileType(){
	var fileType =$("#textfield").val();
	var typeMark =  fileType.substring(fileType.length-4,fileType.length);
	if(typeMark == ".doc"||typeMark ==".DOC"||(typeMark =="docx" &&fileType.indexOf("."))||(typeMark=="DOCX"&&fileType.indexOf("."))){
		return true;
	}else{
		return "请选择doc或docx文件！";
	}
}


//验证必填提示显示位置
function tipPostion(){
	$("#form").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomLeft',//提示信息的位置
		inlineValidation: true,//是否即时验证，false为提交表单时验证,默认true  
	});
}
//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}

function judgeName(){
	var path="${_baseUrl}/documentTemplateController/judgeDocumentName";
	var name = $("#documentTemplateName").val();
	var type = $("#type").val();
	if(name !=""){
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"docName":name,
				"type":type
			},
			dataType:"json",    
			success: function (json) {   
				if(json.code=="1"){
					layer.msg("模板名称已经存在");
					$("#documentTemplateName").val("");
				}
			}   
		});
	}
}

document.onkeydown=function(event) { 
	e = event ? event :(window.event ? window.event : null); 
	if(e.keyCode==13){ 
		return false; 
	} 
};

function judge_enter(){
	 if(window.event.keyCode==13){
		 event.returnValue = false;//阻止刷新页面
   }
}

$(function (){
	$("#textfield").change(function (){
		var path = $("#textfield").val();
		var pos1 = path.lastIndexOf('/');
		var pos2 = path.lastIndexOf('\\');
		var pos = Math.max(pos1, pos2);
		var fileName;
		if( pos<0 )
			fileName = path;
		else
			fileName = path.substring(pos+1); 
		fileName = fileName.substring(0,fileName.lastIndexOf("."));
		$("#documentTemplateName").val(fileName);
		judgeName();
		
	});
})

</script>
<style>
	.jbinformation .jbxinxi_input { width:500px;}  /* 修改输入框宽度样式  */
</style>
</head>
<body>
<div style="padding-bottom:5px;">
<form name="testFileFileUpload" id="form" action ="${_baseUrl}/documentTemplateController/documentTemplateUpload " method="post"  enctype="multipart/form-data" > 
<div class="popup_tit mtmb20">新增文档模板</div>
<input type="hidden" value="${source}" name="type" id ="type" />	
<div class="jbinformation" style="width:100%;">
    <table width="836px" border="0" cellspacing="0" cellpadding="0" style=" margin:0 auto;">
		<tr>
        <td width="25%" align="center" bgcolor="#f7f4f4" name="documentTemplateName">文档模板名称</td>
        <td width="75%"><div class="jbxinxi_s"><input type="text" name="documentTemplateName" id="documentTemplateName" onblur="judgeName();" value="${documentTemplateName }" onkeypress="judge_enter();" onkeydown="judge_enter();" class="jbxinxi_input validate[maxSize[50] required]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">上传文档</td>
        <td><div class="jbxinxi_s jbxinxi_sj" style="width:248px;"><input type="file" name=multipartfile id="textfield" class="jbxinxi_input_f validate[required,funcCall[judgeFileType]]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="documentTemplateController:documentTemplateUpload">
       <a href="javascript:;" id="submit" onclick="formSubmit();" class=" per_baocun">保 存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class=" per_gbi" onclick="cancelAndClose();" >关 闭</a>

</div>		
</form>
</div>
</body>

</html>