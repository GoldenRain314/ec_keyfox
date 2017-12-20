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
<title>批量导入用户</title>
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<%-- <%@ include file="/WEB-INF/jsp/common/inc.jsp" %> --%>
<script type="text/javascript">

$(function (){
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
	
});

//表单提交方法
function formSubmit(){
	var options = {
		dataType:"json",
		success:function(json){
			layer.closeAll('loading');
			if(json.code =="1"){
				layer.msg(json.message,{shift:5,time:1500},function(){
					parent.refreshTable();
					cancelAndClose();
				});
			}else{
				if(json.code=="0"){
					layer.msg(json.message);
				}
			}
		},
		error:function(json){
			layer.msg("发生错误");
			//parent.closeWin();
		}
	};
	
	if($("#form").validationEngine('validate')){
		layer.load(2);
		$('#form').ajaxSubmit(options);	
	}
	
}

function judgeFileType(){
	var fileType =$("#textfield").val();
	var typeMark =  fileType.substring(fileType.length-4,fileType.length);
	if(typeMark ==".xls"||typeMark ==".XLS"||(typeMark =="xlsx" &&fileType.indexOf("."))||(typeMark=="XLSX"&&fileType.indexOf("."))){
		return true;
	}else{
		return "请选择xls或xlsx文件！";    /* 字体显示大小写统一  */
	}
}

//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();

}


</script>
</head>
<body>
<div style="padding-bottom:5px;">
<form name="testFileFileUpload" id="form" action ="${_baseUrl}/userController/analysisExcl" method="post"  enctype="multipart/form-data" > 
<div class="popup_tit mtmb20">上传文档数据</div>    <!--  修改文字样式并添加小图标    -->
<div class="popup_down">
	<a href="${_baseUrl}/userController/downloadExcl" class="current_10" style=" width:140px;">下载excel模板</a>       <!-- 修改文字 excel  --> 
</div>
<div class="jbinformation" style="width:100%; margin-top:10px;">
    <table width="100%" border="0" cellspacing="0" cllpadding="0">
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">上传excel文档</td>
        <td></td>
        <td><div class="jbxinxi_s jbxinxi_sj" style="width:248px;"><input type="file" name="multipartfile" id="textfield" class="jbxinxi_input_f validate[required,funcCall[judgeFileType]]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
    <a href="javascript:;" id="submit" onclick="formSubmit()" class=" per_baocun">保 存</a>
    <a href="javascript:;" class=" per_gbi" onclick="cancelAndClose();" >关 闭</a>
</div>		
</form>
</div>
</body>

</html>