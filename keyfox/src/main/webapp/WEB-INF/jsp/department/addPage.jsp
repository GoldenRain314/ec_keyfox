<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加部门</title>
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
var departIdNameMap;
/* $.ajax({
	type: "POST",
	url: '${_baseUrl}/departmentController/getParentId',
	dataType: "json",
	async : false,
	success: function(result){
		departIdNameMap = result;
	},
	error : function (XMLHttpRequest, textStatus, errorThrown) {
	}
}); */
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
	
	
	var path='${_baseUrl}/departmentController/getParentId';
	$.ajax({
		cache:false,
		async:false,
		type:"POST",
		url:path,
		dataType:"json",
		success: function(data){
			var obj=JSON.stringify(data);
			var innerHtml="<select id='parentId' name='parentId' class='qr_select' style='width:212px;' onchange='getChoiceDepart();'>";
			if(obj=="[]"){
				innerHtml+="<option value=''>请选择上级部门</option>"; 
			}else{
				innerHtml+="<option value=''>请选择上级部门</option>";    
				for(var i=0;i<data.length;i++){	
						innerHtml+="<option value='"+data[i].id+"'>"+data[i].deptName+"</option>";    
				}  
			}
			innerHtml+="</select>";     
			$("#depart").html(innerHtml);
		}
	})
	
	$("#submit").click(function (){
		if($("#department").validationEngine('validate')){
			var deptName=$("#deptName").val();
			$.ajax({
				cache:false,
				async:false,
				type:"GET",
				url:"${_baseUrl}/departmentController/checkDepartMentName?name="+$("#deptName").val(),
				dataType:"json",
				success: function(data){
					if(data.code == "1"){
						layer.msg(data.message);
					}else{
						var options = {
							dataType:"json",
							success:function(json){
								if(json.code == '1'){
									$("#submit").unbind("click");
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
				},
				error:function(json){
					layer.msg("系统异常,请联系管理员");
				}
			});
		}
	});
	
	$("#close").click(function (){
		parent.refreshTable();
		parent.closeWin();
	});

})
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
function valUserIdName(userId,userName,inputId){
	/* alert(userId,userName); */
	$("#"+inputId).val(userName);
}

function getChargeId(inputId){
	selectUser(inputId);
}

function getInterfacePersonId(inputId){
	selectUser(inputId);
}
function getSuperLeaderId(){
	var inputId="superLeader";
	selectUser(inputId);
}
function getManagerId(){
	var inputId="manager";
	selectUser(inputId);
}
</script>
</head>
<body>
<div style="padding-bottom:5px;">
	<form name="department" id="department" action="${_baseUrl}/departmentController/add" method="post">  
<!-- 	<div class="permission_tit">
    <ul>
        <li><a href="javascript:;" class="qxsz_on">部门信息</a></li>
        <div class="clear"></div>
    </ul>
</div> --><br/>
    	<div class="jbinformation" style="width:861px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="15%" height="50" align="center" valign="middle" bgcolor="#f7f4f4">部门名称</td>
        <td width="35%" valign="middle"><div class="jbxinxi_s"><input type="text" name="deptName" id="deptName" class="validate[required,maxSize[25]] jbxinxi_input" style="width:204px;"></div><div class="jbxinxi_span1">*</div></td>
        <td width="15%" align="center" bgcolor="#f7f4f4">部门编号</td>
        <td width="35%"><div class="jbxinxi_s"><input type="text" name="deptNumber" id="deptNumber" class="validate[required,maxSize[25],custom[onlyLetterNumber]] jbxinxi_input" style="width:204px;"></div><div class="jbxinxi_span1">*</div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">部门简称</td>
        <td valign="top" ><div class="jbxinxi_s"><input type="text" name="departAbbrevia" id="departAbbrevia" class="jbxinxi_input validate[maxSize[25]]" style="width:204px;"></div></td>
        <td align="center" bgcolor="#f7f4f4">上级部门 </td>
        <td valign="center"><div class="qr_input"><span id="depart" ></span></div></td>
      </tr>
      <tr>
        <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">部门负责人</td>
       <td valign="center">
        	<div class="jbxinxi_s">
        		<input type="text" name="chargeName" id="charge_name" readonly class="validate[required,validate[maxSize[50]] jbxinxi_input" style="width:204px;"/>
        		<input type="hidden" name="charge" id="charge_id"/>
        		<a href="javascript:;" class="fl per_baocun"  onClick="selectUser('charge');">
        			选择
        		</a>
        		
        	</div>
        	<div class="jbxinxi_span1">*</div>
        </td>
        
        <td align="center" bgcolor="#f7f4f4">部门接口人</td>
        <td valign="center">
        	<div class="qr_input">
        	  <input type="text" name="interfacePersonName" id="interfacePerson_name" readonly class="jbxinxi_input validate[maxSize[50]]" style="width:204px;">
        	  <input type="hidden" name="interfacePerson" id="interfacePerson_id" />
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
        		<input type="text" name="superLeaderName" id="superLeader_name" readonly class="jbxinxi_input validate[maxSize[50]]" style="width:204px;">
        		<input type="hidden" name="superLeader" id="superLeader_id" />
       			<a href="javascript:;" class="fl per_baocun" onClick="selectUser('superLeader');">
       				选择
       			</a>
       			<br/>
       		</div>
       	</td>
        <td align="center" bgcolor="#f7f4f4">部门管理人</td>
        <td>
        	<div class="qr_input">
        		<input type="text" name="managerName" id="manager_name" readonly class="jbxinxi_input validate[maxSize[50]]" style="width:204px;">
        		<input type="hidden" name="manager" id="manager_id" />
        		<a href="javascript:;" class="fl per_baocun" onClick="selectUser('manager');">
        			选择
        		</a>
        		<br/>
        	</div>
        </td>
      </tr>
      <tr>
        <td height="100" align="center" valign="middle" bgcolor="#f7f4f4">部门描述</td>
        <td colspan="4"><div class="bjxinxi_beizhu" style="padding-right:0;"><textarea name="comments" id="comments" cols="" rows="" class="validate[maxSize[4000]] beizhu_text" style="width:97%;"></textarea></div></td>
      </tr>
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="departmentController:add">
        <a href="javascript:void(0);" class="per_baocun" id="submit">保存</a>
    </shiro:hasPermission>
    <a href="javascript:;" class="per_gbi" id="close">关闭</a>

</div>
	</form>
  <div id="selectDiv" style="display: none;overflow: hidden;">
		<iframe id="selectIframe" border="0" frameborder="0"></iframe>
	</div>
	
</body>
</html>