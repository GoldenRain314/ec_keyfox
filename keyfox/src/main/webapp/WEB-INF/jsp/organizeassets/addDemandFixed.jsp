<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 验证权限问题 -->
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加追踪关系</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript">
$(function (){
	$("#addRole").validationEngine({
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
		var formChecked = $('#addRole').validationEngine('validate');
		if(formChecked){
			var options = {
				dataType:"json",
				success:function(json){
					if(json.code == '1'){
						layer.msg(json.message,{shift:5,time:1000},function(){
							parent.refreshTable();
							//parent.closeWin();
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
			$('#addRole').ajaxSubmit(options);
		}
	});
})
</script>
</head>
<body>

<form action="${_baseUrl}/fixed/insertFixedDemand" id="addRole" method="post">
	<div class="jbinformation roleshux">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="120" height="50" align="center" bgcolor="#f7f4f4">文档名称</td>
	    <td width="237" valign="middle">
	    	<input type="hidden" name="id" id="id" value="${fixedInfo.id }"/>
	    	<div class="qr_input">
		    	<select class="qr_select" id="documentId" name="documentId" style="width:202px; height:auto; padding:5px 0;" >
		    		<c:forEach items="${selectByDemandList }" var="document">
		    			<option value="${document.id }" <c:if test="${document.id == fixedInfo.documentId }"> selected="selected"</c:if>>${document.modelName }</option>
		    		</c:forEach>
		      	</select>
	      	</div>
	    </td>
	    
	    <td width="129" align="center" valign="middle" bgcolor="#f7f4f4">被追踪文档名称</td>
	    <td width="237">
	   		<div class="qr_input">
		    	<select class="qr_select" id="traceDocumentId" name="traceDocumentId" style="width:202px; height:auto; padding:5px 0;" >
		    		<c:forEach items="${selectByDemandList }" var="document">
		    			<option value="${document.id }" <c:if test="${document.id == fixedInfo.traceDocumentId }"> selected="selected"</c:if> >${document.modelName }</option>
		    		</c:forEach>
		      	</select>
	      	</div>
	    </td>
	  </tr>
	  <tr>
	    <td width="120" height="50" align="center" bgcolor="#f7f4f4">文档章节名称</td>
	    <td width="237" valign="middle"><div class="jbxinxi_s">
	    	<input type="text" name="sectionName" id="sectionName" value="${fixedInfo.sectionName }" class="jbxinxi_input" style="width:195px;"></div></td>
	    <td width="129" align="center" valign="middle" bgcolor="#f7f4f4">被追踪文档章节名称</td>
	    <td width="237"><div class="jbxinxi_s">
	    	<input type="text" name="traceSectionName" id="traceSectionName" value="${fixedInfo.traceSectionName }" class="jbxinxi_input" style="width:195px;"></div>
	    </td>
	  </tr>
	  <tr>
	    <td width="120" height="50" align="center" bgcolor="#f7f4f4">文档章节号</td>
	    <td width="237" valign="middle"><div class="fl jbxinxi_s" style="width:auto">
	    	<input type="text" name="sectionNumber" id="sectionNumber" value="${fixedInfo.sectionNumber }" class="validate[required] jbxinxi_input" style="width:195px;"></div><div class="jbxinxi_span1">*</div></td>
	    <td width="129" align="center" valign="middle" bgcolor="#f7f4f4">被追踪文档章节号</td>
	    <td width="237"><div class="jbxinxi_s" style="width:auto">
	    	<input type="text" name="traceSectionNumber" id="traceSectionNumber" value="${fixedInfo.traceSectionNumber}" class="validate[required] jbxinxi_input" style="width:195px;"></div><div class="jbxinxi_span1">*</div>
	    </td>
	  </tr>

	  <tr>
	    <td height="50" align="center" bgcolor="#f7f4f4">保存追踪关系的章节位置</td>
	    <td width="237"><div class="fl jbxinxi_s" style="width:auto;">
	    	<input type="text" name="showTraceSectionId" id="showTraceSectionId" value="${fixedInfo.showTraceSectionId}" class="validate[required] jbxinxi_input" style="width:195px;"></div><div class="jbxinxi_span1">*</div>
	    </td>
	    <td width="129" bgcolor="#f7f4f4">&nbsp;</td>
	    <td width="237">&nbsp;</td>
        
    </table>
	</div>
	<div class="permission_an mubanclass_an ma mt30">
	    <a href="javascript:;" class="per_baocun" id="submit">确 定</a>
	    <a href="javascript:;" class="per_gbi" id="close">取 消</a>
	</div>
</form>
</body>
</html>