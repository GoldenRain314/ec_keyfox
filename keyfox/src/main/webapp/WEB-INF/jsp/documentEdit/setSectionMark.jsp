<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html style="overflow:auto; width:570px;" >
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<META HTTP-EQUIV="pragma" CONTENT="no-cache">   
<title>设置章节标识</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript">

var documentId ="${documentId}";
var projectId ="${projectId}";
var pathMark ="${pathMark}";

function onSubmit(){
	// 验证标识是否重复
	var count = validateMark();
	if(count > 0){
		return false;
	}
		// 当章节名称为空时，用户输入的内容
		var sectionNameAndId = "[";
		var nameInput = $("input[name='secName']");
		for(var n=0;n<nameInput.length;n++){
			var name = $(nameInput[n]).val();
			var tr =$(nameInput[n]).parents("tr");
			var id = $(tr).find("td:eq(0)").find("input").val();
			if(sectionNameAndId.length > 1){
				sectionNameAndId += ",{id:'"+id+"',sectionName:'"+name+"'}";
			} else {
				sectionNameAndId += "{id:'"+id+"',sectionName:'"+name+"'}";
			}
		}
		sectionNameAndId += "]";
		//alert(sectionNameAndId);
		
	
	
		var sectionIdAndMark="[";
		var markInput = $("input[name='mark']");
		for(var i=0;i<markInput.length;i++){
			var mark = 	$(markInput[i]).val();
			var parent = markInput[i].parentNode;
			var beforeMark =$( $(parent).find("input[name='beforeMark']")).val();	
			var tr =$(markInput[i]).parents("tr");
			var id = $(tr).find("td:eq(0)").find("input").val();
			 if(mark!=beforeMark){
				if(sectionIdAndMark.length>1){
					sectionIdAndMark+=",{id:'"+id+"',sectionMark:'"+mark+"'}";
				}else{
					sectionIdAndMark+="{id:'"+id+"',sectionMark:'"+mark+"'}";
				}
			}
		}
		sectionIdAndMark+="]";
		/* alert($("#form").validationEngine('validate')); */
		if($("#form").validationEngine('validate')){
			var path="${_baseUrl}/sectionController/saveSectionMark";
			$.ajax({    
				type: "POST",    
				async: false,    
				url:path, 
				data:{
					"sectionIdAndMark":sectionIdAndMark,
					"documentId":documentId,
					"projectId":projectId,
					"sectionNameAndId":sectionNameAndId
				}, 
				dataType:"json",    
				success: function (data) {
					//alert(pathMark);
					layer.msg(data.message,{shift:2,time:2000},function(){
						if(pathMark=="release"){
							var path="${_baseUrl}/documentController/documentRelease?documentId="+documentId+"&projectId="+projectId;
							window.location.href=path;
						}else{
							cancelAndClose();
						}
						
					});
				}   
			}); 
			
		}	
		
}

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
	//validateMark();
});


//判断章节标识不能重复
function judgeSectionMark(obj){
	var mark = $(obj).val();
	var inputs = $("input[name='mark']");
	var count = 0;
	if(mark.indexOf("\'")>=0||mark.indexOf("\"")>=0){
		layer.msg("章节标识不能含有英文单引号或者双引号");
		$(obj).val("");
	}
	if(mark!=""){
		for(var i=0;i<inputs.length;i++){
			var inputMark = $(inputs[i]).val();
			if(inputMark==mark){
				count++;
			}
		}
		if(count>1){
			layer.msg("章节标识不能重复");
			$(obj).val("");
		}
	}else{
		return;
	}
		
}


//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}

document.onkeydown=function(event) 
{ 
	e = event ? event :(window.event ? window.event : null); 
	if(e.keyCode==13){ 
		return false; 
	} 
}; 

$(document).ready(function(){
	validateMark();
});

function validateMark(){
	var inputs = $("input[name='mark']");
	var count = 0;
	for(var i=0;i<inputs.length;i++){
		var marks = $(inputs[i]).val();
		if(marks != "" && marks != null){
			for(var u=i+1;u<inputs.length;u++){
				var mark = $(inputs[u]).val();
				if(mark != "" && mark != null){
					if(marks==mark){
						count++;
					}
				}
			}
		}
	}
	if(count > 0){
		layer.msg("章节标识不能重复");
	}
	return count;
}

</script>
</head>
<body>
<div class="chapter_popup">
  <div class="popup_tit mtmb20">章节标识列表</div>
    <div class="chapter_tc_c1">
    	<form action="" id="form" name="form">
    	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tablebox">
          <tr>
            <td width="16%" height="45" align="center"><strong>章节号</strong></td>
            <td width="42%" align="center"><strong>章节名称</strong></td>
            <td width="42%" align="center"><strong>章节标识</strong></td>
          </tr>
          <c:forEach items="${listSection }" var="Section">
          	<tr>
          		<td height="42" align="center"  
          		 <c:forEach  items="${listRequireSection }" var="RequireSection">
          			<c:if test="${Section.id==RequireSection.id}"> style="color:red" </c:if>
          		</c:forEach> >
          			<input type="hidden" value="${Section.id }" id="id" name="id"/>
          			<c:if test="${empty Section.sectionNumber}">-</c:if>
          			${Section.sectionNumber }
          		</td>
            	<td align="center" 
	            	<c:forEach  items="${listRequireSection }" var="RequireSection">
	          			<c:if test="${Section.id==RequireSection.id}"> style="color:red" </c:if>
	          		</c:forEach> 
            	>
            	<!-- 当章节名称为空时，页面显示一个文本框，添加必填验证。名称不为空时直接显示名称 -->
            	<c:if test="${Section.sectionName == null}">
            		<input class="fl validate[required,maxSize[50]]" 
            			   style="border:1px solid #eee; width:88%;height: 27px; margin-left:6px; padding-left: 3px; line-height:27px;font-family:Microsoft Yahei,Arial;font-size:14px;color:#7b7b7b;"
            			   name="secName"/><span style="color: red">*</span> 
            	</c:if>
            	<c:if test="${Section.sectionName != null}">
	            	${Section.sectionName }
            	</c:if>
            	</td>
            	
            	<td align="left">
            		<input type="hidden" name="beforeMark"  value="${Section.sectionMark }"/>
            		<input type="text"   onmouseout="judgeSectionMark(this);"   onblur="judgeSectionMark(this);" 
            		
	            		<c:forEach  items="${listRequireSection }" var="RequireSection">
	      					<c:if test="${Section.id==RequireSection.id}"> class="validate[required,maxSize[50]]" </c:if>
	      					<%-- <c:if test="${Section.id != RequireSection.id}">  </c:if> --%>
	      				</c:forEach>
		            	style="border:1px solid #eee; width:88%;height: 27px; margin-left:6px; padding-left: 3px; line-height:27px;font-family:Microsoft Yahei,Arial;font-size:14px;color:#7b7b7b;"
						name="mark" value="${Section.sectionMark }" 
	            		<c:forEach  items="${listRequireSection }" var="RequireSection">
	          				<c:if test="${Section.id != RequireSection.id}"> class ="validate[maxSize[50]]"</c:if>
	          			</c:forEach> 
            	  />
            	  <c:forEach  items="${listRequireSection }" var="RequireSection">
          			   <c:if test="${Section.id==RequireSection.id}"> <span style="color: red">*</span> </c:if>
          		 </c:forEach> 
              </td>
          	</tr>
          </c:forEach>          
        </table>
        </form>
    </div>
     <div class="permission_an mubanclass_an ma mt20">
    	<a href="javascript:;" class="per_baocun" onclick="onSubmit();">提 交</a>
        <a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">取 消</a>
    </div>
</div>
	
</body>
</html>