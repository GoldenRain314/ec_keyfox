<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>任务分配</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}datepicker/WdatePicker.js"></script>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript" src="${_resources}js/setUserIdAndName.js"></script>
<script type="text/javascript">
var id = "${id}";
var projectId = "${projectId}";
var ids = "${ids}";
var check0 =false;
var check1 =false;
var check2 =false;
$(function(){
	$("#id").val(id);
	$("#projectId").val(projectId);
})
$(function(){
	$("#editDocument").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomLeft',//提示信息的位置
		inlineValidation: false//是否即时验证，false为提交表单时验证,默认true  
		
	});
	
})
function validateStartTime(){
	var startTime = $("#startTime").val();
	var endTime = $("#endTime").val();
	if(endTime != "" && startTime != ""){
		if(startTime > endTime){
			layer.msg( "开始时间不能晚于结束时间");
			$("#startTime").val("");
		}
	}
	
}
function validateEndTime(){
	var startTime = $("#startTime").val();
	var endTime = $("#endTime").val();
	if(startTime != "" && endTime != ""){
		if(endTime < startTime){
			layer.msg( "结束时间不能早于开始时间。");
			$("#endTime").val("");
		}
	}
}

function checkStartTime(){
	var time = $("#startTime").val();
	if(time == ""){
		return "此处必须选择相应的选项。";
	}else{
		return true;
	}
}


function checkEndTime(){
	var time = $("#endTime").val();
	if(time == ""){
		return "此处必须选择相应的选项。";
	}else{
		return true;
	}
}

function submit(){
	var documentManager = $("#manager_id").val();
	if(documentManager.indexOf(",") > 0){
		layer.msg("文档负责人只能有一个");
		return;
	}
	
	if("${templateId}" != ""){
		//协同编辑方式
		var team_id = $("#team_id").val();
		var synergyTypeValue = $("input[name='synergyType']:checked").val();
		if(team_id != ""){
			if(synergyTypeValue != "1" && synergyTypeValue != "2"){
				layer.msg("请选择协同方式");
				return;
			}
		}
		if(synergyTypeValue == "1" || synergyTypeValue == "2"){
			if(team_id==""){
				layer.msg("请选择协同编制人");
				return;
			}
		}
		
	}
	
	
	if($("#editDocument").validationEngine('validate')){
	    $("#editDocument").attr("action", "${_baseUrl}/documentList/saveDocumentMessage?ids="+ids);
		$('#editDocument').submit();
		parent.refreshWin();
	}
	
}
//弹出选择软件文档负责人选择框
function choiceManager(inputId){
	var managerId;
	var path = "";
	if(inputId == "manager"){
		var team_id = $("#team_id").val();
		managerId = $("#manager_id").val();
		path = "${_baseUrl}/departmentController/selectManagerUser?inputId="+inputId+"&managerId="+managerId+"&number="+Math.random()+"&team_id="+team_id;
	}else{
 		var docManager =$("#manager_id").val();
		managerId = $("#team_id").val();
		path = "${_baseUrl}/departmentController/selectDepartUser?inputId="+inputId+"&managerId="+managerId+"&number="+Math.random()+"&docManager="+docManager;
	}
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'人员选择',
		autoOpen: true,
		modal: true,	
		height: 360,
		width: 700
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src",path);
	
}
function closeWin(){
	$("#popDiv").dialog('close');
}


function getCheckStatus(i){
	 if(i==0){
		 if(check0){
			 $("#"+i).prop("checked",false);
		 }
	 }
	 if(i==1){
		 if(check1){
			 $("#"+i).prop("checked",false);
		 }
	 }
	 check0 = $("#0").prop("checked");
	 check1 = $("#1").prop("checked");
	 var synergyTypeValue = $("input[name='synergyType']:checked").val();
	 if(synergyTypeValue ==undefined){
		 $("#team_id").val("");
		 $("#team_name").val("");
	 }
}


</script>
</head>
<body>

 <!--<div class="permission_tit">
</div>-->
<form name ="editDocument" id="editDocument" action="" method="post">
	<div class="jbinformation roleshux">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="150" height="50" align="center" bgcolor="#f7f4f4">预计开始时间</td>
			    <c:choose>
			    	<c:when test="${documentVo.startTime == '' || empty documentVo.startTime }">
			    		<td width="187" valign="middle"><div class="jbxinxi_s" style="width:289px;"><input type="text" readonly="readonly"  value="${startDate }" onblur="validateStartTime();" name="startTime" id="startTime" class="jbxinxi_input validate[required]" onClick="WdatePicker({startDate:'%y-%M-01 00:00:00',dateFmt:'yyyy-MM-dd HH:mm:ss',alwaysUseStartDate:true})" style="width:282px;"></div><div class="jbxinxi_span1">*</div></td>
			    	</c:when>
			    	<c:otherwise>
			    		<td width="187" valign="middle"><div class="jbxinxi_s" style="width:289px;"><input type="text" readonly="readonly" value="${documentVo.startTime}" onblur="validateStartTime();" name="startTime" id="startTime" class="jbxinxi_input validate[required]" onClick="WdatePicker({startDate:'%y-%M-01 00:00:00',dateFmt:'yyyy-MM-dd HH:mm:ss',alwaysUseStartDate:true})" style="width:282px;"></div><div class="jbxinxi_span1">*</div></td>
			    	</c:otherwise>
			    </c:choose>
			    
			  </tr>
			  <tr>
				<td width="150" height="50" align="center" valign="middle" bgcolor="#f7f4f4">预计结束时间</td>
				<c:choose>
			    	<c:when test="${documentVo.endTime == '' || empty documentVo.endTime }">
			    		<td width="230"><div class="jbxinxi_s" style="width:289px;"><input type="text" value="${endDate }" onblur="validateEndTime();" name="endTime" id="endTime" readonly="readonly" class="jbxinxi_input validate[required]" onClick="WdatePicker({startDate:'%y-%M-01 00:00:00',dateFmt:'yyyy-MM-dd HH:mm:ss',alwaysUseStartDate:true})"style="width:282px;"></div><div class="jbxinxi_span1">*</div></td>
			    	</c:when>
			    	<c:otherwise>
			    		<td width="230"><div class="jbxinxi_s" style="width:289px;"><input type="text" value="${documentVo.endTime }" onblur="validateEndTime();" name="endTime" readonly="readonly" id="endTime" class="jbxinxi_input validate[required]" onClick="WdatePicker({startDate:'%y-%M-01 00:00:00',dateFmt:'yyyy-MM-dd HH:mm:ss',alwaysUseStartDate:true})"style="width:282px;"></div><div class="jbxinxi_span1">*</div></td>
			    	</c:otherwise>
			    </c:choose>
		 	  </tr>
			  <tr>
			    <td height="50" align="center" bgcolor="#f7f4f4">文档负责人</td>   
			    <td valign="middle">
			    	<div class="jbxinxi_s" style="width:289px;">
			    		<input readonly value="${documentVo.documentManagerName }" type="text" name="manager" id="manager_name" class="jbxinxi_input validate[required]" style="width:282px;">
			    	</div>
			    	<div class="jbxinxi_span1">*</div>  <!-- 必填项统一样式  -->
			    	<div>
			    		<input type="hidden" name="documentManager" id="manager_id" value="${documentVo.documentManager }"/>
			    	</div>
			    	<div style="float:left; height:38px; line-height:50px; margin-left:10px; padding-top:12px;">
			    		<a onClick="choiceManager('manager');" class="per_baocun" id="manager">选择</a>
			    	</div>
			    </td>
			  </tr>
			  <c:choose>
			  	<c:when test="${templateId != '' && !empty templateId}">
				  <tr>
				    <td height="50" align="center" bgcolor="#f7f4f4">协同编制方式</td>
				    <td valign="middle">
				    	<div class="jbxinxi_s">
				    		<input type="radio" id="0" name="synergyType" value="1" onclick="getCheckStatus(0);"  
				  				<c:if test ="${SnergyType =='1'}"> checked='checked'</c:if>
				    		>针对文档章节 <span style="margin-left: 10px; color: #C6C6C6">多个协同编写人员编制同一份文档，且需要按照文档章节细分协同编制任务和分配权限，对分配的章节有编辑权限</span>
				    		<br/>
				    		<input type="radio" id="1" name="synergyType" value="2" onclick="getCheckStatus(1);"
				    			<c:if test ="${SnergyType =='2'}"> checked='checked'</c:if>
				    		>针对单个文档 <span style="margin-left: 10px; color: #C6C6C6">协同编写人员针对选中文档的所有章节均有编辑权限，且不按照文档章节细分协同编制任务
				    		</span>
				    		<input type="radio" id ="2"    name="synergyType" value="3" style="display: none;"
				    			<c:if test ="${SnergyType=='' ||SnergyType == '3'}"> checked='checked'</c:if>
				    		 >
				    	</div>
				    </td>
				  </tr>
				  <tr>
					 <td height="50" align="center" bgcolor="#f7f4f4">协同编制人员</td>
					 <td valign="top"><div class="jbxinxi_s" style="width:289px;"><input readonly value="${documentVo.documentTeamPeopleName }" type="text" name="team" id="team_name" class="jbxinxi_input" style="width:282px;"></div><div><input type="hidden" name="documentTeamPeople" id="team_id" value="${documentVo.documentTeamPeople }"/></div><div style="float:left; height:38px; line-height:50px; margin-left:10px; padding-top:12px;"><a onClick="choiceManager('team');" id="manager" class="per_baocun">选择</a></div></td>
				 </tr>
				</c:when>
				<c:otherwise>
				
				</c:otherwise>
			  </c:choose>
		</table>
</div>
	<input type="hidden" name="id" id="id" />
	<input type="hidden" name="projectId" id="projectId" />
</form>
<div class="permission_an samllbtn ma mtmb20">
	<shiro:hasPermission name="documentList:saveDocumentMessage">
       <a href="javascript:;" class="per_baocun" onclick="submit();">保 存</a>
    </shiro:hasPermission>	
    <a href="javascript:;" class="per_gbi" onclick="parent.closeWin();">关 闭</a>
</div>
<div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
</div>
</body>
</html>
