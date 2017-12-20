<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>文档模板基本信息</title>

</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript">
var beforeSrc ="";
function selectCreate(value){
	if(value=="newCreate"){
		var frame = $("#templatelist");
		var src  = $(frame).attr("src");
		beforeSrc=src;
		$(frame).attr("src","");
		setTimeout(function(){
			$("#popIframe").empty();	
			$("#popDiv").dialog({
				title:'新增适用范围',
				autoOpen: true,
				modal: true,	
				height: 300,
				width: 500,
				close:function(event,uri){
					showBeforeSection();
				}
			});	
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/applicableScopeController/newApplicableScope");
		},1500);	
	}
}
function getApplicationScope(){
	var path="${_baseUrl}/applicableScopeController/SelectAllApplicableScope";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,
		dataType:"json",    
		success: function (data) {   
			var jsonObj=eval("("+data.message+")");
			var options="";
			if(jsonObj.length>0){
				options+="<option>请选择</option>";
				$.each(jsonObj, function (i, item) {
					options+="<option value='"+item.scopeName+"'>"+item.scopeName+"</option>";
			 	});
			}
			//options+="<option value='newCreate'>新建适用范围</option>";
			$("#applicationScope").html(options);			
		}   
	}); 	
}

$(function(){
	$("#form").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'topRight',//提示信息的位置
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
//删除刚才上传的模板数据
function del(){
	var path ="${_baseUrl}/documentTemplateController/delDocumentTemplate";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"id":"${documentTemplate.id}"      
		},    
		dataType:"json",    
		success: function (data) {   
			parent.closeWin();
		}   
	}); 
}

function formSubmit(){
	var options = {
		dataType:"json",
		success:function(json){
				layer.msg(json.message,{offset:['85%','45%']},function(){
					parent.closeWin();
					parent.refreshTable();	
				});
		},
		error:function(json){
			layer.msg("发生错误");
		}
	};
	if($("#form").validationEngine('validate')){
		$("#submit").attr("onClick","");	
		$('#form').ajaxSubmit(options);
	}
}



//文档分类管理
function defineTemplateSort(){
	var frame = $("#templatelist");
	var src  = $(frame).attr("src");
	beforeSrc=src;
	$(frame).attr("src","");
	setTimeout(function(){
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'文档模板分类管理',
			autoOpen: true,
			modal: true,	
			height: 430,
			position:'top',
			width: 500,
			close:function(event,uri){
				showBeforeSection();
			}
			
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/templateSortController/showTemplateSort");
	},1500);
}
//选择文档模板分类
function selectTemplateSort(){
	var frame = $("#templatelist");
	var src  = $(frame).attr("src");
	beforeSrc=src;
	$(frame).attr("src","");
	
	var documentType = $("#id").val();
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'文档模板分类管理',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 330,
		width:350
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/templateSortController/setTemplateSort?id="+documentType+"&type=alter");
}
/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

//验证活动类型
function checkSelectOut(){	
	var select = $("select[name='styleOutTemplate']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			var value = $(options[i]).val();
			if(value=="请选择"){
				return "请选择样式输出模板";
			}else{
				return true;
			}
		}
	}
	
}
//验证活动名称
function checkSelectSet(){	
	var select = $("select[name='styleSetTemplate']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			var value = $(options[i]).val();
			if(value=="请选择"){
				return "请选择样式定义模板";
			}else{
				return true;
			}
		}
	}
	
}

//验证适用范围
function checkSelectScope(){	
	var select = $("select[name='applicationScope']");
	var options = $(select).find("option");
	var value="";
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			value = $(options[i]).val();
			
		}
	}

	if(value=="请选择"){
		return "请选择适用范围";
	}else{
		return true;
	}
}
var activeName = null;
var activeType = null;

function showBeforeSection(){
	var frame = $("#templatelist");
	if(beforeSrc!=""){
		$(frame).attr("src",beforeSrc);
	}
}
//根据活动类型，切换活动名称
function addName(value){
	var path ="${_baseUrl}/activeName/getActiveName";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"activeType":value      
		},    
		dataType:"json",    
		success: function (json) {   
			if(json.code=="1"){
				var jsonObj=eval("("+json.message+")");
				var options="";
				options+="<option>请选择</option>";
				if(jsonObj.length>0){
					
					$.each(jsonObj, function (i, item) {
						options+="<option value='"+item.id+"'>"+item.activeName+"</option>";
				 	});
				}
				$("#actionName").html(options);	
			}
		}   
	}); 
}

document.onkeydown=function(event) 
{ 
	e = event ? event :(window.event ? window.event : null); 
	if(e.keyCode==13){ 
		return false; 
	} 
} 

</script>
<body>
<form action = "${_baseUrl}/documentTemplateController/documentTemplateInfo" method="post" id="form">
<input type="hidden" value="${documentTemplate.id}" name="id" id ="id"/>
 <div class="jbinformation wdmubansr shcuan_t" style="top:0px; clear: both;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="101" height="50" align="center" valign="middle" bgcolor="#f7f4f4">文档模板名称</td>
            <td width="352px" align="center" valign="middle" >
            <div class="jbxinxi_s" style="width: 210px;"><input type="text" readonly="readonly" disabled="disabled" style="width: 202px;" value ="${documentTemplate.documentTemplateName} " name ="documentTemplateName" class="jbxinxi_input validate[required]"></div><div class="jbxinxi_span1">*</div>    <!--  统一样式  -->
            </td>
           </tr>
           <tr>
            <td width="105" align="center" valign="middle" bgcolor="#f7f4f4">模板分类</td>
            <td  align="center" valign="middle">
             <div class="jbxinxi_s" style="width:210px;">
                <input type="text"  name ="documentTypeName" style="width: 202px;"  id="documentTypeName" value ="${documentTypeName }" readonly class="jbxinxi_input validate[required]">
             	<input type="hidden"   name ="documentType" id="documentType" value="${documentTemplate.documentType}"  class="jbxinxi_input validate[required]"></div>
          		<div class="jbxinxi_span1">*</div>
          		<div class="fl xzan_btn" style="margin:10px 0 0 10px;">
            <a href="javascript:;" onclick="selectTemplateSort();">选 择</a></div>
          </td>
          </tr>	
          <tr align="center" valign="middle">
            <td height="50px;"  bgcolor="#f7f4f4">适用范围</td>
            <td width="352"  align="left" valign="top">
            <div class="jbxinxi_s" style="width: 210px; margin:14px 0 0 10px;">
	         <select class="qr_select  validate[required,funcCall[checkSelectScope]]" style="width: 208px; padding:0; height: 27px;"  name="applicationScope" id="applicationScope"   onchange="selectCreate(this.options[this.options.selectedIndex].value)">
					<option >请选择</option>
				<c:forEach items="${listApplicableScope}" var="applicableScope">
					<option value="${applicableScope.id }"
					<c:if test="${documentTemplate.applicationScope ==applicableScope.id}"> selected = "selected"</c:if>
					>${applicableScope.scopeName }</option>
				</c:forEach>
	        </select>
	        </div>
            <div class="jbxinxi_span1">*</div>
            </td>
            </tr>
            <tr  align="center" valign="middle">
            <td  height="50px;"  bgcolor="#f7f4f4">活动类型</td>
            <td width="235" align="left" valign="top"><div class="jbxinxi_s" style="margin:14px 0 0 10px">
            <select   name ="activeType" id="activeType" class="qr_select" style="width: 208px; padding:0; height: 27px;" onchange="addName(this.options[this.options.selectedIndex].value)">
              <option value="">请选择</option>
              <c:forEach items="${listActiveType}" var="activeType">
				<option value="${activeType.id }" 
					<c:if test="${documentTemplate.activeType ==activeType.id}"> selected = "selected"</c:if>
				>${activeType.activeType }</option>
			</c:forEach>
            </select>
            </div></td>
             </tr>
            <tr  align="center" valign="middle">
            <td  height="50px;" bgcolor="#f7f4f4">活动名称</td>
            <td width="235" align="left" valign="top">
            <div class="jbxinxi_s" style="margin:14px 0 0 10px;">
              <select class="qr_select"  name ="actionName" id="actionName" style="width: 208px; padding:0; height: 27px;" >
                <option value="">请选择</option>
                <c:forEach items="${activeNames}" var="activeName">
                	<option value="${activeName.id }" 
                	<c:if test="${documentTemplate.actionName ==activeName.id}"> selected = "selected"</c:if>
                	>${activeName.activeName }</option>
                </c:forEach>
              </select>
            </div></td>
          </tr>
        </table>
	</div>
    </div>
    <div class="permission_an mubanclass_an ma mt30">
    <a href="javascript:;" id="submit" class=" per_baocun" onclick="formSubmit();">确定</a>
    <a href="javascript:;" onclick="parent.closeWin();" class="per_gbi">返回</a>
    </div>
  
  
  <div id="popDiv" style="position:relative; z-index:1000; display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>  
	 
	 
</form>
</body>
</html>