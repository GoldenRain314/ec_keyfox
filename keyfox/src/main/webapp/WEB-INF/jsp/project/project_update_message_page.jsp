<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title></title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0 minimal-ui"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<script type="text/javascript">

$(function(){
	$("#projectDefinition").validationEngine({
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
	
})
function isHaveName(){
	 var nodeName=$("#name").val();
	 var parentId = $("#parentId").val();
	 
	 if("${info.name}" ==nodeName||"${info.directoryLevel}"!=1){
		 return;
	 }
	
	 $.ajax({ 
			url:'${_baseUrl}/project/isHaveName', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"nodeName":nodeName,"parentId":parentId},
			async: false,
			success: function(data){
				if(data == "false"){
					$("#name").val("");
					if("${info.directoryLevel}" == 1){
						layer.msg( "项目名称重复！");
					}else{
						layer.msg( "该节点名已经存在！");
					}
				}
      	},
			error:function(){
				layer.msg( "系统错误");
			}
	  });
 }
function saveMessage(){
	 if($("#projectDefinition").validationEngine('validate')){
			var nodeName=$("#name").val();
			var nodeCode=$("#nodeCode").val();
			var nodeId = $("#nodeId").val();
			var options = {
					dataType:"json",
					success:function(json){
						if(json.code == '1'){
							$("#submit").removeAttr('onclick');
							layer.msg(json.message,{shift:1000},function(){
								parent.parent.location.href="${_baseUrl}/project/showtree?nodeId="+$("#parentId").val();
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
				$('#projectDefinition').ajaxSubmit(options);
				
		}
		
 }
function closeWindow(){
	 parent.closeWin();
 }
</script>
</head>
<body>
<!--<div class="permission_tit">

</div>-->
<div class="jbinformation roleshux">
	<form name="projectDefinition" id="projectDefinition" action="${_baseUrl}/project/updateMessage" method="post">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="150" height="50" align="center" id="l1" bgcolor="#f7f4f4">项目名称</td>
			    <td width="187" valign="middle"><div class="jbxinxi_s"><input type="text" name="name" value="${info.name }" id="name" onblur="isHaveName();" class="jbxinxi_input validate[maxSize[50],required]"></div><div class="jbxinxi_span1">*</div></td>
			  </tr>
			  <tr>
			    <td width="150" height="50" align="center" id="l2" bgcolor="#f7f4f4">项目标识</td>
			    <td width="187" valign="middle"><div class="jbxinxi_s"><input type="text" name="nodeCode" value="${info.nodeCode }" id="nodeCode" class="jbxinxi_input validate[required,maxSize[50]]"></div><div class="jbxinxi_span1">*</div></td>
			  </tr>
		</table>
		<input type = "hidden" name = "nodeId" id ="nodeId" value="${info.nodeId }">
		<input type = "hidden" name = "parentId" id ="parentId" value="${info.parentId }" >
		
	</form>
	
	<div class="permission_an mubanclass_an ma mt30">
        <shiro:hasPermission name="project:updateMessage">
            <a href="javascript:;" id="submit" class="per_baocun" onclick="saveMessage();">保 存</a>
        </shiro:hasPermission>
		<a href="javascript:;" onclick="closeWindow();" class="per_gbi">关 闭</a>
	</div>
</div>
</body>
</html>
