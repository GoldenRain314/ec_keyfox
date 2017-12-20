<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加涉密等级</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}datepicker/WdatePicker.js"></script>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript">
$(function (){
	$("#standardLibrary").validationEngine({
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
	
	
	$("#close").click(function (){
		parent.closeWin();
	});
	
	/* 提交 */
	$("#submit").click(function (){
		var formChecked = $('#standardLibrary').validationEngine('validate');
		if(formChecked){
			var options = {
				dataType:"json",
				success:function(json){
					if(json.code == '1'){
						$("#standardLibrary").attr("action","");
						layer.msg(json.message,{shift:5,time:1000},function(){
							parent.refreshTable();
							parent.closeWin();
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
			$('#standardLibrary').ajaxSubmit(options);
		}
	});
})
function isHaveName(){
	 var name = $("#documentName").val();
	 $.ajax({ 
			url:'${_baseUrl}/standardLibrary/isHaveName', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"name":name},
			async: false,
			success: function(data){
				if(data == "false"){
					$("#documentName").val("");
					layer.msg( "该名称已经存在");
				}
      	    },
			error:function(){
				layer.msg( "系统错误");
			}
	  });
 }
</script>
</head>
<body>

<form action="${_baseUrl}/standardLibrary/saveLibraryMessage" id="standardLibrary" method="post">
	<div class="jbinformation roleshux">
		<table width="723" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="120" height="50" align="center" bgcolor="#f7f4f4">文档名称</td>
		    <td width="237" valign="middle"><div class="jbxinxi_s" style="width:auto;">
		    	<input type="text" name="documentName" id="documentName" value="${standardLibrary.documentName }" onblur="isHaveName();" class="validate[required,maxSize[200]] jbxinxi_input" style="width:195px;"></div><div class="jbxinxi_span1">*</div></td>
		  	<td width="129" height="50" align="center" bgcolor="#f7f4f4">文档标识</td>
		    <td width="237" valign="middle"><div class="jbxinxi_s" style="width:auto;">
		    	<input type="text" name="documentCode" id="documentCode" value="${standardLibrary.documentCode }" class="jbxinxi_input validate[maxSize[200]]" style="width:195px;"></div></td>
		  </tr>
		  <tr>
		    <td width="150" align="center" valign="middle" bgcolor="#f7f4f4">发布日期</td>
		    <td width="230"><div class="jbxinxi_s" style="width:auto;">
		    	<input type="text" name="releaseDate" id="releaseDate" value="${standardLibrary.releaseDate }" class="validate[required,maxSize[200]] jbxinxi_input" onClick="WdatePicker()" style="width:195px;"></div><div class="jbxinxi_span1">*</div>
		    </td>
		    <td width="150" height="50" align="center" bgcolor="#f7f4f4">来源(编制单位)</td>
		    <td width="187" valign="middle"><div class="jbxinxi_s" style="width:auto;">
		    	<input type="text" name="source" id="source" value="${standardLibrary.source }" class="validate[required,maxSize[200]] jbxinxi_input" style="width:195px;"></div><div class="jbxinxi_span1">*</div></td>
		  </tr>
		  <tr>
		    <td width="150" height="50" align="center" bgcolor="#f7f4f4">缩略名</td>
		    <td width="187" valign="top"><div class="jbxinxi_s" style="width:auto;">
		    	<input type="text" name="slug" id="slug" value="${standardLibrary.slug }" class="jbxinxi_input validate[maxSize[200]]" style="width:195px;"></div></td>
		    <td width="150" height="50" align="center" bgcolor="#f7f4f4">版本</td>
		    <td width="187" valign="top"><div class="jbxinxi_s" style="width:auto;">
		    	<input type="text" name="versions" id="versions" value="${standardLibrary.versions }" class="jbxinxi_input validate[maxSize[200]]" style="width:195px;"></div></td>
		  </tr>
	</table>
	</div>
	<input type="hidden" value="${standardLibrary.id }" name="id" />
	<div class="permission_an mubanclass_an ma mt30">
	    <shiro:hasPermission name="standardLibrary:saveLibraryMessage">
	       <a href="javascript:;" class="per_baocun" id="submit">确 定</a>
	    </shiro:hasPermission>
	    <a href="javascript:;" class="per_gbi" id="close">取 消</a>
	</div>
</form>
</body>
</html>