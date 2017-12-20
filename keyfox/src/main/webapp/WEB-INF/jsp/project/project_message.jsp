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
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<script type="text/javascript" src="${_resources}js/setUserIdAndName.js"></script>
<script type="text/javascript">
$(function (){
	var str = "${str}";
	if(str != ""){
		if(str.length > 50){
			str = str.substring(0,50);
			str += "...";
		}
	}
	$("#str").html(str);
	
	 $("#departmentId").attr("disabled","disabled");
	 getDepartment();
	 var nodeId = "${vo.projectid}";
	 var nodeName = "${vo.projectname}";
	 $('#projectid').val(nodeId);
	 $('#projectname').val(nodeName);
	 $("#submit").click(function (){
		if($("#projectBaseinfo").validationEngine('validate')){
			var projectManager = $("#project_manager_id").val();
			if(projectManager.indexOf(",") > 0){
				layer.msg("项目文档负责人只能是一个");
				return;
			}
			var options = {
					dataType:"json",
					data : {"pmanager":"${vo.projectManagerName}"},
					success:function(json){
						if(json.code == '1'){
							$("#projectBaseinfo").attr("action","");
							layer.msg(json.message,{shift:2},function(){
								parent.location.href="${_baseUrl}/project/showtree?nodeId="+nodeId;
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
				$('#projectBaseinfo').ajaxSubmit(options);
				
		}
			
	});
})
	//弹出选择软件文档负责人选择框
	function choiceManager(inputId){
		var path = "";
		var managerId = "${vo.projectmanager}"
		var projectsupervision = "${vo.projectsupervision}";
		if(inputId == 'projectsupervision'){
			if($("#department").val() == 'choice'){
				layer.msg("请先选择项目文档负责人");
				return;
			}else{
				path = "${_baseUrl}/departmentController/selectDepartUser?inputId="+inputId+"&managerId="+projectsupervision+"&departId="+$("#department").val();
			}
		}else{
			path = "${_baseUrl}/departmentController/selectManagerUser?inputId="+inputId+"&managerId="+managerId;
		}
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'选择人员',
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
	function getDepartment(){
 		$.ajax({ 
			url:'${_baseUrl}/departmentController/selectAllDepartment?userId='+$("#project_manager_id").val(), 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	$.each(jsonObj, function (i, item) {
			 		if(data.departId == item.id){
			 			$("#departmentId").attr("disabled","false");
			 			$("#departmentId").val(item.deptName);
			 			$("#departmentId").attr("disabled","disabled");
			 			$("#department").val(item.id);
			 		}
			 	}); 
         },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
 	}
</script>
</head>
<body>
<div class="main_cont">
        	<div class="main_c">
                <div class="current_cont">
                    <div class="fl current_c">
                         当前位置 ： <a href="javascript:;">项目管理</a> <span id="str" title="项目管理${str }"></span>
                    </div>            
                    <div class="fr current_j">
                       
                    </div>
                    <div class="fr current_s">
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                            
                </div>
                
                <div class="dyi_cont dyi_conta">

                    <div class="jbinformation roleshux">
                   	  <form name="projectBaseinfo" id="projectBaseinfo" action="${_baseUrl}/project/setDocument?pmanagerId=${vo.projectmanager}" method="post">
                   	  	<div class="jbinformation roleshux">
					     <table width="100%" border="0" cellspacing="0" cellpadding="0">
							  <tr>
							    <td width="15%" height="50" align="center" id="l1" bgcolor="#f7f4f4">项目名称</td>
							    <td width="85%" valign="middle"><div class="jbxinxi_s" style="margin-top:0;">${vo.projectname}</div></td>
							  </tr>
							  <tr>
							  	<td width="15%" height="50" align="center" valign="middle" id="l2" bgcolor="#f7f4f4">项目标识</td>
							    <td width="85%"><div class="jbxinxi_s" style="margin-top:0;">${nodeCode}</div></td>
							  </tr>
							  <tr>
							  	<td width="15%" height="50" align="center" valign="middle" id="l3" bgcolor="#f7f4f4">项目文档负责人</td>
							    <td width="85%"><div class="jbxinxi_s fl" style="margin-top:11px;">
							    	<c:choose>
								    	<c:when test="${vo.projectManagerName != '' }">
								    		<input type="text" name="project_manager" id="project_manager_name" value="${vo.projectManagerName }" readonly class="jbxinxi_input" >
								    		<input type="hidden" name="projectmanager" id="project_manager_id" value="${vo.projectmanager }"/>
								    	</c:when>
								    	<c:otherwise>
								    		<input type="text" name="project_manager" id="project_manager_name" value="${department.managerName }" readonly class="jbxinxi_input validate[required]">
								    		<input type="hidden" name="projectmanager" id="project_manager_id" value="${department.manager }"/>
								    	</c:otherwise>
							    	</c:choose>
							    	</div>
						    		<div class="dyi_btnabox fl" style="margin-top:11px;">
						    			<shiro:hasPermission name="project:select">
								            <input readonly="readonly" onClick="choiceManager('project_manager');" type="button" id="manager" value="选择" class="dyi_btna"/>
								        </shiro:hasPermission>
						    		</div>
						    		<div class="jbxinxi_span1">*</div>
							    </td>
							  </tr>
							   <tr>
							  	<td width="20%" height="50" align="center" valign="middle" id="l2" bgcolor="#f7f4f4">项目所属部门</td>
							    <td width="80%">
								    <div class="jbxinxi_s" style="margin-top:0;">
								    	 <input  type="text" id="departmentId" name="departmentId" value="${departmentName}" class="jbxinxi_input"/>
			            				 <input type="hidden"  id="department" id ="department" value="${department}"/>
								    </div>
							    </td>
							  </tr>
							  <tr>
							  	<td width="20%" height="50" align="center" valign="middle" id="l3" bgcolor="#f7f4f4">项目监管人员</td>
							    <td width="80%"><div class="jbxinxi_s fl" style="margin-top:11px;">
							    	<c:choose>
								    	<c:when test="${vo.projectSupervisionName != '' }">
								    		 <input type="text" name="projectsupervision_name" id="projectsupervision_name" value="${vo.projectSupervisionName }" readonly class="jbxinxi_input">
							    			 <input type="hidden" name="projectsupervision" id="projectsupervision_id" value="${vo.projectsupervision }"/>
								    	</c:when>
								    	<c:otherwise>
								    		<input type="text" name="project_manager" id="project_manager_name" readonly class="jbxinxi_input">
								    		<input type="hidden" name="projectmanager" id="project_manager_id"/>
								    	</c:otherwise>
							    	</c:choose>
							    	</div>
								   <div class="dyi_btnabox fl" style="margin-top:11px;"><input readonly="readonly" onClick="choiceManager('projectsupervision');" type="button" id="supervision" value="选择" class="dyi_btna"/></div>
							    </td>
							  </tr>
							   <tr>
							  	<td width="20%" height="50" align="center" valign="middle" id="l2" bgcolor="#f7f4f4">编制进度管理</td>
							    <td width="80%">
								    <div class="jbxinxi_s jbxinxi_s1027" style="margin-top:0;">
						        		 <input type="radio" name="isoreditplan" value="0" <c:if test="${vo.isoreditplan == '0'}">checked="checked"</c:if>>开启&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="isoreditplan" value="1" <c:if test="${vo.isoreditplan == '1'}">checked="checked"</c:if>>关闭
								    </div>
							    </td>
							  </tr>
						</table>
						</div>
						<input type = "hidden" name = "projectid" id ="projectid" />
						<input type = "hidden" name = "projectname" id ="projectname"/>
					</form>
					<div class="permission_an mubanclass_an ma mt20">
						<shiro:hasPermission name="project:setDocument1">
				            <a href="javascript:;" id="submit" class="per_baocun">保 存</a>
				        </shiro:hasPermission>
				    </div>
                  </div>
				  <div id="popDiv" style="display: none;">
					<iframe id="popIframe" border="0" frameborder="no"></iframe>
				  </div>
              </div>
     	 </div>
      </div>
</body>
</html>
