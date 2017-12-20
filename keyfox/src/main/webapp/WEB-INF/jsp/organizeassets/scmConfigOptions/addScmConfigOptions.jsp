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
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript">
$(function (){
	$.ajax({ 
		url:'${_baseUrl}/scmBaseline/selectAllScmBaselineMessage', 
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		async: false,
		success: function(data){
		 	var jsonObj=eval("("+data.json+")");
		 	$.each(jsonObj, function (i, item) {
		 		if("${scmConfigOptions.baselineName}"==item.baselineName){
		 			jQuery("#baselineName").append("<option value="+ item.baselineName+" selected='selected'>"+ item.baselineName+"</option>");
		 		}else{
		 			jQuery("#baselineName").append("<option value="+ item.baselineName+">"+ item.baselineName+"</option>");
		 		}
		 		
		 	}); 
       },
		error:function(){
			layer.msg( "系统错误");
		}
    });	
	$("#scmConfigOptions").validationEngine({
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
		var formChecked = $('#scmConfigOptions').validationEngine('validate');
		if(formChecked){
			var options = {
				dataType:"json",
				success:function(json){
					if(json.code == '1'){
						$("#scmConfigOptions").attr("action","");
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
			$('#scmConfigOptions').ajaxSubmit(options);
		}
	});
})
function isHaveName(){
	 var name = $("#configOptionsName").val();
	 $.ajax({ 
			url:'${_baseUrl}/scmConfigOptions/isHaveName', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"name":name},
			async: false,
			success: function(data){
				if(data == "false"){
					$("#configOptionsName").val("");
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

<form action="${_baseUrl}/scmConfigOptions/saveScmConfigOptionsMessage" id="scmConfigOptions" method="post">
	<div class="jbinformation roleshux">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="15%" height="50" align="center" bgcolor="#f7f4f4">配置项名称</td>
		    <td width="35%" valign="middle"><div class="jbxinxi_s">
		    	<input type="text" name="configOptionsName" id="configOptionsName" onblur="isHaveName();" value="${scmConfigOptions.configOptionsName }" class="validate[required,maxSize[200]] jbxinxi_input inputtable_4"></div><div class="jbxinxi_span1">*</div></td>
		  	<td width="15%" height="50" align="center" bgcolor="#f7f4f4">配置项标识</td>
		    <td width="35%" valign="middle"><div class="jbxinxi_s">
		    	<input type="text" name="configOptionsCode" id="configOptionsCode" value="${scmConfigOptions.configOptionsCode }" class="validate[required,maxSize[200]] jbxinxi_input inputtable_4"></div><div class="jbxinxi_span1">*</div></td>
		  </tr>
		  <tr>
		    <td width="15%" align="center" valign="middle" bgcolor="#f7f4f4">所属基线名称</td>
		    <td width="35%"><div class="jbxinxi_s">
		    	<!--<input type="text" name="baselineName" id="baselineName" value="${scmConfigOptions.baselineName }" class="validate[required] jbxinxi_input"></div><div class="jbxinxi_span1">*</div> -->
		    	<select name="baselineName" class="xmugonj_select validate[required]" id="baselineName" style="width:232px;"></select></div><div class="jbxinxi_span1 validate[maxSize[200]]">*</div>
		    </td>
		    <td width="15%" height="50" align="center" bgcolor="#f7f4f4">配置项内容</td>
		    <td width="35%" valign="top"><div class="jbxinxi_s">
		    	<input type="text" name="configOptionsContent" id="configOptionsContent" value="${scmConfigOptions.configOptionsContent }" class="validate[maxSize[200]] jbxinxi_input inputtable_4"></div></td>
		  </tr>
	</table>
	</div>
	<input type="hidden" value="${scmConfigOptions.id }" name="id" />
	<div class="permission_an mubanclass_an ma mt30">
	    <shiro:hasPermission name="scmConfigOptions:saveScmConfigOptionsMessage">
	       <a href="javascript:;" class="per_baocun" id="submit">确 定</a>
	    </shiro:hasPermission>
	    <a href="javascript:;" class="per_gbi" id="close">取 消</a>
	</div>
</form>
</body>
</html>