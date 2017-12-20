<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>样式模板定义</title>
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
		promptPosition:'bottomLeft',//提示信息的位置
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
		$("#modelName").val(fileName);
		judgeName();
		
	});
});
function formSubmit(){
	var options = {
		dataType:"text",
		success:function(json){
			layer.msg(json,{shift:5,time:1500},function(){
				parent.closeWin();
				parent.refreshTable();
			
			});
		},
		error:function(json){
			layer.msg("发生错误");
			parent.closeWin();
			parent.refreshTable();
		}
	};
	
	judgeName();
	if($("#form").validationEngine('validate')){
		$("#submit").attr("onclick","");
		$('#form').ajaxSubmit(options);
	}
	
}

//验证范本类型
function checkSelect(){	
	var select = $("select[name='modelType']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			var value = $(options[i]).val();
			if(value=="请选择"){
				return "请选择范本类型";
			}else{
				return true;
			}
		}
	}
	
}
//验证文档类型
function checkSelectDoc(){	
	var select = $("select[name='documentType']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			var value = $(options[i]).val();
			if(value=="请选择"){
				return "请选择文档类型";
			}else{
				return true;
			}
		}
	}
	
}
//验证适用范围
function checkSelectScope(){	
	var select = $("select[name='applicableScope']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			var value = $(options[i]).val();
			if(value=="请选择"){
				return "请选择适用范围";
			}else{
				return true;
			}
		}
	}
	
}

function checkSelectStandard(){
	var select = $("select[name='applicableStandrad']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			var value = $(options[i]).val();
			if(value=="请选择"){
				return "请选择适用标准";
			}else{
				return true;
			}
		}
	}
	
}

function judgeName(){
	var path="${_baseUrl}/docModel/judgeModelName";
	var name = $("#modelName").val();
	var type ="";
	var select = $("select[name='modelType']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			type = $(options[i]).val();
		}
	}	
	if(name !=""){
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"modelName":name,
				"type":type
			},
			dataType:"json",    
			success: function (json) {   
				if(json.code=="1"){
					layer.msg(json.message);
					$("#modelName").val("");
				}
			}   
		});
	}
}
//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}

function judgeFileType(){	
	var fileType = $("#textfield").val();
	var typeMark =  fileType.substring(fileType.length-4,fileType.length);
	if(typeMark ==".doc"||typeMark ==".DOC"||(typeMark =="docx" &&fileType.indexOf("."))||(typeMark=="DOCX"&&fileType.indexOf("."))){
		return true;
	}else{
		return "请选择doc或docx文件！"
	}
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
<form action="${_baseUrl}/docModel/saveModel" id="form" method="post"  enctype="multipart/form-data">
<div class="form_boxa">
<div class="popup_tit mtmb20">新增文档范本</div>
<div class="jbinformation widthauto">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="30%" height="50" align="center" valign="middle" bgcolor="#f7f4f4">范本类型:</td>
        <td width="70%" valign="middle">
	        <div class="jbxinxi_s jbxinxi_ss">
	        <select name="modelType" class="validate[maxSize[50] required,funcCall[checkSelect]]" style="width:249px;">   
	        	<option >请选择</option>	
				<option value="guide">编写指南</option>
				<option value="explain">编写说明</option>
				<option value="example">编写示例</option>
			</select>
			</div>
			<div class="jbxinxi_span1">*</div>
		</td>
		</tr>
	 <tr>
        <td width="20%" align="center" bgcolor="#f7f4f4" >文档名称:</td>
        <td width="80%"><div class="jbxinxi_s jbxinxi_ss"><input type="text" name="modelName" id="modelName"   onblur="judgeName();" class="jbxinxi_input validate[maxSize[50] required]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td width="20%" height="50" align="center" valign="middle" bgcolor="#f7f4f4">文档类型:</td>
        <td width="80%" valign="middle">
	        <div class="jbxinxi_s jbxinxi_ss">
	        <select name="documentType" class="validate[required,funcCall[checkSelectDoc]]" style="width:249px;">   
	        	<option >请选择</option>	
				<c:forEach items="${listDocumentType}" var="documentType">
				 	<option value="${documentType.documentType}">${documentType.documentType}</option>
				</c:forEach>
			</select>
			</div>
			<div class="jbxinxi_span1">*</div>
		</td>
	</tr>
	<tr>
        <td width="20%" height="50" align="center" valign="middle" bgcolor="#f7f4f4">适用范围:</td>
        <td width="80%" valign="middle">
	        <div class="jbxinxi_s jbxinxi_ss">
	        <select name="applicableScope" class="validate[required,funcCall[checkSelectScope]]" style="width:249px;">   
	        	<option>请选择</option>	
				<c:forEach items="${listDtApplication}" var="dtApplication">
				 	<option value="${dtApplication.application}">${dtApplication.application} </option>
				</c:forEach>
			</select>
			</div>
			<div class="jbxinxi_span1">*</div>
		</td>
	</tr>
 	<tr>
       <td width="20%" align="center" bgcolor="#f7f4f4" >适用标准 :</td>
       <td width="80%">
       <div class="jbxinxi_s jbxinxi_ss">
	        <select name="applicableStandrad" class="validate[required,funcCall[checkSelectStandard]]" style="width:249px;">   
	        	<option >请选择</option>	
				<c:forEach items="${listStandardLibrary}" var="standardLibrary">
				 	<option value="${standardLibrary.documentName}">${standardLibrary.documentName} </option>
				</c:forEach>
			</select>
			</div>
			<div class="jbxinxi_span1">*</div></td>
    </tr>
    <tr>
       <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">上传文件:</td>
       <td><div class="jbxinxi_s jbxinxi_ss" style="width:248px;"><input type="file" width="100" name="multipartfile" id="textfield" class="jbxinxi_input_f validate[required,funcCall[judgeFileType]]"></div><div class="jbxinxi_span1">*</div></td>
    </tr>
      
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
    <a href="javascript:;" id="submit" onclick="formSubmit();" class="per_baocun">保 存</a>
    <a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">关 闭</a>
</div>
</div>
</form>
</body>
</html>