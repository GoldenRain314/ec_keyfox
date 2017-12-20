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
		$("#styleDocumentName").val(fileName);
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
	if($("#form").validationEngine('validate')){
		$("#submit").attr("onclick","")
		$('#form').ajaxSubmit(options);
	}
	
}

//验证样式输出文档
function checkSelect(){	
	var select = $("select[name='styleType']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			var value = $(options[i]).val();
			if(value=="请选择"){
				return "请选择模板类型";
			}else{
				return true;
			}
		}
	}
	
}

//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}

function judgeName(){
	var path="${_baseUrl}/styleTemplateController/judgeStyleName";
	var name = $("#styleDocumentName").val();
	var type = $("#styleType").val();
	if(name !=""){
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"styleName":name,
				"type":type
			},
			dataType:"json",    
			success: function (json) {   
				if(json.code=="1"){
					layer.msg("模板名称已经存在");
					$("#styleDocumentName").val("");
				}
			}   
		});
	}
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
<div style="padding-bottom:5px;">
<form action="${_baseUrl}/styleTemplateController/styleTemplateUpload" id="form" method="post"  enctype="multipart/form-data">
<div class="popup_tit mtmb20">新增样式模板</div>
<div class="jbinformation" style="width:561px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="21%" height="50" align="center" valign="middle" bgcolor="#f7f4f4">样式类型</td>
        <td width="79%" valign="middle">
	        <div class="jbxinxi_s">
	        <select name="styleType" id = "styleType" class="validate[required,funcCall[checkSelect]]"  onchange="judgeName();"  style="width:320px; padding:5px 0;" >   
	        	<option >请选择</option>	
				<option value="inSet">样式定义库</option>
				<option value="outSet">样式输出库</option>
			</select>
			</div>
			<div class="jbxinxi_span1">*</div>
		</td>
		</tr>
		<tr>
        <td width="150" align="center" bgcolor="#f7f4f4" >样式文档名称</td>
        <td width="185"><div class="jbxinxi_s"><input type="text" name="styleDocumentName" id="styleDocumentName" onblur="judgeName();" class="jbxinxi_input validate[maxSize[50] required]" style="width:314px;"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">样式文档</td>
        <td><div class="jbxinxi_s jbxinxi_sj" style="width:321px;"><input type="file" width="100" name="multipartFile" id="textfield" class="jbxinxi_input_f validate[required,funcCall[judgeFileType]]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
    </table>
</div>
<div class="permission_an mubanclass_an ma mt20">
	<shiro:hasPermission name="styleTemplateController:styleTemplateUpload">
       <a href="javascript:;" id="submit" onclick="formSubmit();" class="per_baocun">保 存</a>
    </shiro:hasPermission>
    
    <a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">关 闭</a>
</div>

</form>
</div>

</body>
<style>
	.jbinformation .jbxinxi_input{ width:314px;}
</style>
</html>