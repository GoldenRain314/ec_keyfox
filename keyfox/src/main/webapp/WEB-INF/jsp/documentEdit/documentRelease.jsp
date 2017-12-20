<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>文档发布</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">

var documentId ="${documentId}";
var projectId ="${projectId}";
var judge ="";
//取消和关闭调用的方法
function cancelAndClose(){	
	parent.closeWin();
}
$(function(){
	$("#version").validationEngine({
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
	
})


document.onkeydown=function(event) 
{ 
	e = event ? event :(window.event ? window.event : null); 
	if(e.keyCode==13){ 
		return false; 
	} 
} 


$(document).ready(function(){
	judgeDocumentSectionMark();
})
function returnSectionMark(){
	
	var path="${_baseUrl}/documentSectionController/setSectionMarkPage?documentId="+documentId+"&projectId="+projectId+"&pathMark=release";
	window.location.href=path;
	
}

//判断文档是否为438B追踪关系，判断必填的章节，是否有设置章节标识
function judgeDocumentSectionMark(){
	var path="${_baseUrl}/documentController/judgetRequiredSectionMark";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,
		data:{
			"documentId":documentId,
			"projectId":projectId
		},
		dataType:"json",    
		success: function (data) {   
		    if(data.code=="0"){
		    	getPreposeDocument();
		    }else{
		    	if (data.message == "有虚拟章节的名称为空哦"){
		    		layer.confirm("请先设置章节名称和标识，并确保完整",{
			    		btn:['确定']},
			    		function (){
			    			returnSectionMark();
			    		}
			    	);
		    	} else {
			    	layer.confirm("请先设置章节标识，并确保完整",{
			    		btn:['确定']},
			    		function (){
			    			returnSectionMark();
			    		}
			    	);
		    	}
		    }
		}   
	}); 	
}
//判断章节内容是否为空
function judgeBlankSection(){
	var path="${_baseUrl}/documentController/judgeSectionIfSpace";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,
		data:{
			"documentId":documentId,
			"projectId":projectId
		},
		dataType:"json",    
		success: function (data) {   
			if(data.code=='1'){
				var jsonObj=eval("("+data.message+")");
				if(jsonObj!=null){
					if(jsonObj.length>0){
						$("#blankDiv").attr("style","display:black");
						jQuery("#sectionBlank").append("<tr><td height='45' align='center'><strong>序号</strong></td><td align='center'><strong>章节号</strong></td> <td align='center'><strong>章节名称</strong></td></tr>");
						$.each(jsonObj, function (i, item) {
							var app = "";
					 		app += "<tr><td height='42' align='center'>" + (i + 1);
					 		if(item.sectionNumber == "" || item.sectionNumber == null){
					 			app += "</td><td align='center'>-</td><td align='center'>"+item.sectionName+"</td></tr>";
					 		} else {
					 			app += "</td><td align='center'>"+item.sectionNumber+"</td><td align='center'>"+item.sectionName+"</td></tr>";
					 		}
							jQuery("#sectionBlank").append(
					 				//"<tr><td height='42' align='center'>"+(i+1)+"</td><td align='center'>"+"<c:if test="${empty item.sectionNumber}">-</c:if>"+item.sectionNumber+"</td><td align='center'>"+item.sectionName+"</td></tr>"
					 				app
							);
							
					 	});
					}
				}
				$("#content").attr("style","display:black");
				$("#versionDiv").attr("style","display:black");
			}else{
				if(data.code=='2'){
					layer.confirm("文档内容为空，请先进行编写",{
			    		btn:['确定']},
			    		function (){
			    			parent.closeWin();
			    		}
			    	);
				}else{
					if(data.code=='0'){
						$("#content").attr("style","display:black");
						$("#versionDiv").attr("style","display:black");
					}
				}
			}
			
		}   
	}); 	
}

//判断文档是否有前置文档
function getPreposeDocument(){
	var path="${_baseUrl}/documentController/judgePreposeDocument";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,
		data:{
			"documentId":documentId,
			"projectId":projectId
		},
		dataType:"json",    
		success: function (data) {   
		    if(data.message=="true"){
		    	if(data.code=='0'){
		    		layer.confirm("当前文档有前项追踪文档，建议确认文档的需求追踪关系",{  
			    		btn:['确定','跳过此步']},
			    		function (){
			    			parent.parent.skipModule("需求追踪","${_baseUrl}/dd/showTraceRelation?documentId="+documentId+"&projectId="+projectId);
			    		},function (){
			    			judgeBlankSection();
			    		}
			    	);
		    		
		    	}else{
		    		layer.confirm("当前文档有前项追踪文档，需要建立需求追踪关系",{   /* 提示语中“……前置……”修改为“……前项……” */
			    		btn:['确定']},
			    		function (){
			    			parent.parent.skipModule("需求追踪","${_baseUrl}/dd/showTraceRelation?documentId="+documentId+"&projectId="+projectId);
			    		}
			    	);
		    	}
		    	
		    }else{
		    	judgeBlankSection();
		    }
		}   
	}); 	
}

//判断版本是否可用
function judgeVersion(){
	var version  = $("#version").val();
	var path="${_baseUrl}/documentController/judgeDocumentVersion";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,
		data:{
			"documentId":documentId,
			"projectId":projectId,
			"version" :version
		},
		dataType:"json",    
		success: function (data) {   
		    if(data.message=="true"){
		    	return true;
		    }else{
		    	layer.msg("版本已存在!");
		    	return false;
		    }
		}   
	}); 			
}
//确认追踪关系
function confirmTrack(){
	//parent.editPwdFun();
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'文档追踪',
		autoOpen: true,
		modal: true,	
		height: 350,
		width: 400
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentController/confirmTrack?documentId="+documentId+"&projectId="+projectId); 
}	
//执行发布
function excuteRelease(){
	if($("#form").validationEngine('validate')){
	
		var version  = $("#version").val();
		var path="${_baseUrl}/documentController/judgeDocumentVersion";
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"documentId":documentId,
				"projectId":projectId,
				"version" :version
			},
			dataType:"json",    
			success: function (data) {   
			    if(data.message=="true"){
			    	
			    		if(version !=""){
			    			path="${_baseUrl}/documentController/releseDocument";
			    			$.ajax({    
			    				type: "POST",    
			    				async: false,    
			    				url:path,
			    				data:{
			    					"documentId":documentId,
			    					"projectId":projectId,
			    					"version" :version
			    				},
			    				dataType:"json",    
			    				success: function (data) {   
			    					layer.msg(data.message,{time:2000},function(){
			    						operator ="${operator}";
			    						if(data.code!=""&&data.code!=null){
			    							parent.updateTree(data.data,data.code,data.token);
			    						}
			    						parent.getEditPercentage();
			    						parent.status = '3';
			    						returnChangeForm();
			    						parent.closeWin();
			    						parent.getButton();
			    					});	
			    				}   
			    			}); 	
			    		}
			    	
			    	return true;
			    }else{
			    	layer.msg("版本已存在!");
			    	return false;
			    }
			}   
		}); 
	}	
}
//跳转内容变更单
function returnChangeForm(){
	var path="${_baseUrl}/documentController/judgeChangeStatus";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,
		data:{
			"documentId":documentId,
			"projectId":projectId
		},
		dataType:"json",    
		success: function (json) {   
			if(json.code=="1"){
				parent.parent.skipModule("变更分析","${_baseUrl}/cdc/showChangeContent?projectId="+projectId+"&documentId="+json.message+"&changeId="+json.data);
			}else{
				return ;
			}
			
		}   
	}); 	
	
}


/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

</script>
</head>
<body>
<br>
<div class="chapter_popup"  id = "content" style="display:none;">
  <div class="chapter_tc_tit" id="blankDiv" style="display:none;">以下章节没有内容，建议填写后再发布。</div>
    <div class="chapter_tc_c1 mt20">
    	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="sectionBlank" class="tablebox">
    	 
        </table>
    </div>
    <div id="versionDiv" style="display:none;" >
    	<form action="" id="form" name="form">
	    	<div class="chapter_tc_u mt20">
	    		<span>请输入版本号：</span>
	    		<p><input type="text"   name="version" id="version" class="validate[required,maxSize[50]] input_text" style="width:200px; border:1px solid #d4d4d4;" onblur="judgeVersion();"/></p>
	    		<i>*</i>
	    		<div class="clear"></div>
	    	</div>
		</form>
		<div class="permission_an mubanclass_an ma mt20" style="width: 280px;">
	    	<a href="javascript:;" class=" fl per_baocun"  id="release"  onclick="excuteRelease();">发布</a>
	        <a href="javascript:;" class="fr per_gbi" onclick="cancelAndClose();">返回</a>
	    </div> 
    </div>
	<div id="popDiv" style="display: none;">
			<iframe id="popIframe" border="0" frameborder="0"></iframe>
	</div>
</div>

<div class="chapter_popup" id="blank" style="display:none;">
  	 <div class="chapter_tc_c1 mt20">
    	<h1 style="text-align: center;font-size: 20px;">文档内容为空，请先进行编写，再发布</h1>
    </div>
    <div class="permission_an mubanclass_an mt20" style="text-align: center;">
	        <a href="javascript:;" class="per_baocun" onclick="cancelAndClose();">确定</a>
	 </div>
</div>

</body>
</html>