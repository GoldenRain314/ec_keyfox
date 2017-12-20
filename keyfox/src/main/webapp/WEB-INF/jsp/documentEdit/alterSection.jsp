<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>修改章节信息</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
$(function(){
	
	$("#form").validationEngine({
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
	
	//alert("${section.sectionName}");
	
})

document.onkeydown=function(event) 
{ 
	e = event ? event :(window.event ? window.event : null); 
	if(e.keyCode==13){ 
		return false; 
	} 
} 

//表单提交方法
function onSubmit(){
	var treeName =$("#sectionName").val();
	var treeNumber = $("#sectionNumber").val();
	var oldName = $("#oldname").val();
	var nodeId = $("#sectionId").val();
	var options = {
		dataType:"json",
		success:function(json){
			if(json.code =="1"){
				layer.msg(json.message,{shift:5,time:1500},function(){
					parent.closeWin();
					parent.ztree.getNodeByParam("id",nodeId,null).name =treeNumber+""+treeName;
					parent.ztree.updateNode(parent.ztree.getNodeByParam("id",nodeId,null));
					parent.isAdd ="yes";
				});
			}else{
				layer.msg("系统错误",{shift:5,time:1500},function(){
					parent.closeWin();
					parent.isAdd ="yes";
				});
			}
		},
		error:function(json){
			layer.msg("发生错误");
			parent.closeWin();
			parent.isAdd ="yes";
		}
	};
	 if($("#form").validationEngine('validate')){
		if(oldName==treeName){
			layer.msg("未做任何修改",{shift:5,time:1500});
		}else{
			$("#submit").attr("onclick","")
			$('#form').ajaxSubmit(options);
		}
	} 
}
//验证必填提示显示位置
function tipPostion(){
	$("#form").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomRight',//提示信息的位置
		inlineValidation: true,//是否即时验证，false为提交表单时验证,默认true  
	});
}
//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}


</script>
<style type="text/css">
	.editTextarea{
       border:1px solid #eee;
       font-size:14px;
       font-family: Microsoft Yahei,Arial;
       padding:1px;
       height:27px;
       overflow:auto;
       width:88%;
       text-align:left;
       padding:5px;
}
</style>
</head>
<body style="overflow-y:auto; ">
<div class="chapter_popup">
  <div class="popup_tit mtmb20">修改章节信息</div>
    <div class="chapter_tc_c">
    <form action="${_baseUrl}/sectionController/saveAlter" id ="form" name ="form" method="post">
    	<table width="571" border="0" cellspacing="0" cellpadding="0" id ="sectionTable" class="tablebox">
    	<input value ="${section.id }" id = "sectionId" name ="sectionId" type="hidden"/>
    	<input value ="${section.sectionName }" id = "oldname" name="oldname" type="hidden"/>
         <tr>
            <td height="45" align="center"><strong>章节号</strong></td>
            <td align="center"><strong>章节名称</strong></td>
          </tr>
          	<tr >
          		<td height="45" align="center" >
          			<input type="text" value="${section.sectionNumber }" class="input_text"  readonly="readonly" id="sectionNumber" name="sectionNumber"/>
          		</td>
          		<td height="45" align="center" >
          			<%-- <input type="text" value="${section.sectionName }"  class="input_text validate[required]"  onkeypress="judge_enter();" onkeydown="judge_enter();" id="sectionName" name="sectionName"/> --%>
          			<textarea class="editTextarea validate[required,maxSize[50]]" rows="2" cols=""  id="sectionName" name="sectionName">${section.sectionName }</textarea>
          		</td>
          		
          	</tr>
        </table>
   	</form>
    </div>
     <div class="permission_an mubanclass_an ma mt20">
    	<a href="javascript:;" class="per_baocun" id="submit" onclick="onSubmit();">提 交</a>
        <a href="javascript:;" class="per_gbi" onclick="cancelAndClose();">取 消</a>
    </div>
</div>
	
</body>
</html>