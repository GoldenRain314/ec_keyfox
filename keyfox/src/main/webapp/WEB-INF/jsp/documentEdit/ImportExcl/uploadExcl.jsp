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
<title>上传excl</title>
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<%-- <%@ include file="/WEB-INF/jsp/common/inc.jsp" %> --%>   <!-- 加载多次  -->
<script type="text/javascript">
//表单提交方法
function formSubmit(){
	
	var options = {
		dataType:"json",
		success:function(json){
			layer.closeAll('loading');
			if(json.code =="1"){
				layer.msg("上传成功");
				cancelAndClose();
				if(typeof(parent.importDataRefruseTree) != undefined){
					parent.importDataRefruseTree();
				}
			}else{
				if(json.code=="2"){
					layer.msg("上传失败");
				}
			}
		},
		error:function(json){
			layer.msg("发生错误");
			parent.closeWin();
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
		return "请选择xls或xlsx文件！"    /* 修改内容文字大小写  */
	}
}


function judgeVisioFileType(){	
	var fileType =$("#textVisiofield").val();
	var typeMark =  fileType.substring(fileType.length-4,fileType.length);
	if(typeMark ==".vsd"||typeMark ==".VSD"){
		return true;
	}else{
		return "请选择vsd文件！"
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
<form name="testFileFileUpload" id="form" action ="${_baseUrl}/dic/analysisExcl" method="post"  enctype="multipart/form-data" > 
<div class="popup_tit mtmb20">上传文档数据</div>
<div class="jbinformation" style="width:100%;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">上传excel文档</td>
        <td></td>
        <td><div class="jbxinxi_s jbxinxi_sj" style="width:248px;"><input type="file" name="multipartfile" id="textfield" class="jbxinxi_input_f validate[required,funcCall[judgeFileType]]"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">上传visio文档</td>
        <td><input id="documentId" name="documentId" value="${documentId}" type="hidden"/></td>
        <td><div class="jbxinxi_s jbxinxi_sj" style="width:248px;"><input type="file" name="multipartVisiofile" id="textVisiofield" class="jbxinxi_input_f validate[required,funcCall[judgeVisioFileType]]"></div><div class="jbxinxi_span1">*</div></td>
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