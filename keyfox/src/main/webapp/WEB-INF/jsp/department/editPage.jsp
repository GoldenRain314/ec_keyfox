<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改部门信息</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<style type="text/css">
body{	
	overflow:hidden;
}
</style>
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript" src="${_resources}js/setUserIdAndName.js"></script>
<script type="text/javascript">
$(function (){
	
	$("#department").validationEngine({
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
		parent.refreshTable();
		parent.closeWin();
	});
	
	$("#submit").click(function (){
		if($("#department").validationEngine('validate')){
		$("#submit").unbind("click");
		var options = {
				dataType:"json",
				success:function(json){
					if(json.code == '1'){
						layer.msg(json.message,{shift:5},function(){
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
			$('#department').ajaxSubmit(options);
		}
	});
	
/* 	var id='${id}';
	$.ajax({
		cache:false,
		async:false,
		type:"POST",
		data:{
			"id":id      
		},
		url:'${_baseUrl}/departmentController/getParentId',
		dataType:"json",
		success: function(data){
			var obj=JSON.stringify(data);
			var innerHtml="<select id='parentId' name='parentId' style='height:26px; width:150px; margin-left:20px;'>";
			if(obj=="[]"){
				innerHtml+="<option value=''></option>"; 
			}else{
				innerHtml+="<option value=''></option>";    
				for(var i=0;i<data.length;i++){	
					innerHtml+="<option value='"+data[i].id+"'>"+data[i].deptName+"</option>";    
				}  
			}
			innerHtml+="</select>";                  
			$("#depart").html(innerHtml);
		}
	}); */
	
	/* var path="${_baseUrl}/departmentController/viewInfo";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"id":id      
		},    
		dataType:"json",    
		success: function (data) {
			$("#deptNumber").val(data.deptNumber);
			$("#superLeader").val(data.superLeader);
			$("#interfacePerson").val(data.interfacePerson);
			$("#departAbbrevia").val(data.departAbbrevia);
			$("#manager").val(data.manager);
			$("#charge").val(data.charge);
			$("#deptName").val(data.deptName);
			$("#parentId").val(data.parentId);
			$("#deptCreateTime").val(data.deptCreateTime);
			$("#comments").val(data.comments);
			$("#id").val(data.id);
		}   
	});  */
});

function selectUser(inputId){
	var choicedParentDepart = $("#parentId").val();
	var managerId;
	if(inputId=="charge"){
		managerId = $("#charge_id").val();//"${department.charge }";
	}else if(inputId == "interfacePerson"){
		managerId = $("#interfacePerson_id").val();//"${department.interfacePerson }";
	}else if(inputId == "superLeader"){
		managerId = $("#superLeader_id").val();//"${department.superLeader }";
	}else if(inputId == "manager"){
		managerId = $("#manager_id").val();//"${department.manager }";
	}
  	$("#selectIframe").empty();	
	$("#selectDiv").dialog({
		title:'选择人员',
		autoOpen: true,
		modal: true,	
		height: 680,
		width: 800
	});
	
	$("#selectIframe").attr("width","100%");
	$("#selectIframe").attr("height","100%");
	if(inputId == 'superLeader'){
		$("#selectIframe").attr("src","${_baseUrl}/departmentController/selectDepartUser?inputId="+inputId+"&choicedParentDepart="+choicedParentDepart+"&managerId="+managerId);
	}else if(inputId == 'manager'){
		//修改Bug【3328】 部门管理人不是必填项，但修改时无法取消勾选 
		$("#selectIframe").attr("src","${_baseUrl}/departmentController/selectDepartUser?inputId="+inputId+"&managerId="+managerId);
	}else if(inputId == 'charge'){
		$("#selectIframe").attr("src","${_baseUrl}/departmentController/selectManagerUser?inputId="+inputId+"&managerId="+managerId);
	}else{
		$("#selectIframe").attr("src","${_baseUrl}/departmentController/selectDepartUser?inputId="+inputId+"&managerId="+managerId);
	}
	  		
}

/* 关闭弹出框 */
function closeWin(){
	$("#selectDiv").dialog('close');
}
</script>
</head>
<body>
<div style="padding-bottom:5px;">
	<form name="department" id="department" action="${_baseUrl}/departmentController/edit" method="post">  
		<input type="hidden" name="id" id="id" value="${department.id }" /><br/>
<div class="jbinformation" style="width:861px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="15%" height="50" align="center" valign="middle" bgcolor="#f7f4f4">部门名称</td>
        <td width="35%" valign="middle"><div class="jbxinxi_s"><input type="text" name="deptName" id="deptName" value="${department.deptName }"  disabled="disabled" class="validate[required,maxSize[25]] jbxinxi_input" style="width:204px;"></div><div class="jbxinxi_span1">*</div></td>
        <td width="15%" align="center" bgcolor="#f7f4f4">部门编号</td>
        <td width="35%"><div class="jbxinxi_s"><input type="text" name="deptNumber" id="deptNumber" value="${department.deptNumber }" disabled="disabled"   class="validate[required,maxSize[25]] jbxinxi_input" style="width:204px;"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">部门简称</td>
        <td valign="top"><div class="jbxinxi_s"><input type="text" name="departAbbrevia" id="departAbbrevia" value="${department.departAbbrevia }" class="jbxinxi_input validate[maxSize[25]]" style="width:204px;"></div></td>
        <td align="center" bgcolor="#f7f4f4">上级部门 </td>
    	<td>
    		<div class="qr_input">
    			<select class="qr_select" id="parentId" name="parentId" style='width:212px;' onchange='getChoiceDepart();'>
    				<option value="">请选择上级部门</option>
          			<c:forEach items="${departmentList }" var="dept">
          				<option value="${dept.id }" <c:if test="${dept.id == department.parentId }">selected="selected"</c:if> >${dept.deptName }</option>
          			</c:forEach>
      			</select>
      		</div>
      	</td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">部门负责人</td>
        
        <td valign="center">
        	<div class="jbxinxi_s">
        		<input type="text" name="chargeName" id="charge_name" value="${department.chargeName }" readonly class="validate[required] jbxinxi_input" style="width:204px;"/>
        		<input type="hidden" name="charge" id="charge_id" value="${department.charge }"/>
        		<a href="javascript:;" class="fl per_baocun"  onClick="selectUser('charge');">
        			选择
        		</a>
        		
        	</div>
        	<div class="jbxinxi_span1">*</div>
        </td>
        <td align="center" bgcolor="#f7f4f4">部门接口人</td>
        <td valign="center">
        	<div class="qr_input">
        		<input type="text" name="interfacePersonName" id="interfacePerson_name" value="${department.interfacePersonName }" readonly class="jbxinxi_input validate[maxSize[50]" style="width:204px;">
        		<input type="hidden" name="interfacePerson" id="interfacePerson_id" value="${department.interfacePerson }"/>
        		<a href="javascript:;" class="fl per_baocun" onClick="selectUser('interfacePerson');">
        			选择
        		</a>
        		<br/>
        	</div>
        </td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">上级主管领导</td>
        <td>
        	<div class="qr_input">
        		<input type="text" name="superLeaderName" id="superLeader_name" value="${department.superLeaderName }" readonly class="jbxinxi_input validate[maxSize[50]" style="width:204px;">
        		<input type="hidden" name="superLeader" id="superLeader_id" value="${department.superLeader }"/>
       			<a href="javascript:;" class="fl per_baocun" onClick="selectUser('superLeader');">
       				选择
       			</a>
       			<br/>
       		</div>
       	</td>
        <td align="center" bgcolor="#f7f4f4">部门管理人</td>
        <td>
        	<div class="qr_input">
        		<input type="text" name="managerName" id="manager_name" value="${department.managerName }" readonly class="jbxinxi_input validate[maxSize[50]" style="width:204px;">
        		<input type="hidden" name="manager" id="manager_id" value="${department.manager }"/>
        		<a href="javascript:;" class="fl per_baocun" onClick="selectUser('manager');">
        			选择
        		</a>
        		<br/>
        	</div>
        </td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">部门描述</td>
        <td height="100" colspan="4"><div class="bjxinxi_beizhu" style="padding-right:0;"><textarea name="comments" id="comments"  cols="" rows="" class="validate[maxSize[4000]]  beizhu_text" style="width:97%;">${department.comments }</textarea></div></td>
      </tr>
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="departmentController:edit">
        <a href="javascript:;" class="per_baocun" id="submit">保存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class="per_gbi" id="close">关闭</a>
</div>
	</form> 
	 <div id="selectDiv" style="display: none;overflow: hidden;">
		<iframe id="selectIframe" border="0" frameborder="0"></iframe>
	</div>
</div>
</body>
</html>