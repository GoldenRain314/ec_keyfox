<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>项目和文档信息</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />

<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui.css" />

<%-- <script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />  --%> 

<script type="text/javascript">
	var projectId = "${projectId}";
	var id = "${id}";
	var projectBaseinfo = "${projectBaseinfo}";
	var documentList;
	var proManager = "${manager}";
	var documentChangeList;
	var docId = "";
	var projectsupervision="${projectsupervision}";
	var editeStatus =false;
	if("${editeStatus}"=='true'){
		editeStatus =true;
	}
	if (!Array.prototype.indexOf)
	{
	  Array.prototype.indexOf = function(elt /*, from*/)
	  {
	    var len = this.length >>> 0;

	    var from = Number(arguments[1]) || 0;
	    from = (from < 0)
	         ? Math.ceil(from)
	         : Math.floor(from);
	    if (from < 0)
	      from += len;

	    for (; from < len; from++)
	    {
	      if (from in this &&
	          this[from] === elt)
	        return from;
	    }
	    return -1;
	  };
	}
	
	
	$(function (){
	
		if("${showUpdate}" != "yes"){
			$("#updateButton").hide();
		}
		if(proManager =="${user.id}"){
			$("#cotentCopyButton").show();
		}
		$.ajax({
			url:'${_baseUrl}/documentList/checkTaskIsOrAssign',
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"projectId":projectId,"source":"projectMessage"},
			async: false,
			success: function(data){
				 if(data == "success"){
					 
				 }else if(data == "fail"){
					 layer.msg("该项目尚未构建完成",{shift:5,time:1000},function(){
						/*  var path="${_baseUrl}/document/projectInitialize?id="+id+"&projectId="+projectId+"&taskAssign=no";
						 window.location.href=path; */
					 });
					
				 }else if(data == "error"){
					 layer.msg("该项目尚未构建完成 ");
				 }
	        },
			error:function(){
				layer.msg("系统错误");
			}
		});
		$.ajax({
			url:'${_baseUrl}/project/selectFatherByNodeId', 
			data:{"nodeId":projectId},
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			async: false,
			success: function(data){
				var span = "<span title='"+data+"'>"+subProjectName(data)+"</span>";
			 	$("#projectMessage").append(span);
           },
			error:function(){
				layer.msg( "系统错误");
			}
		});
		$("input[type='radio'][value='${projectBaseinfo.isorreuse}']").attr("checked",true);
		$.ajax({ 
			url:'${_baseUrl}/softwareDevelopModel/selectAllModelMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
	 			jQuery("#softwaredevelopmodel").append("<option value=''>请选择</option>");
			 	$.each(jsonObj, function (i, item) {
			 		if("${projectBaseinfo.softwaremodel}"==item.developModelName){
			 			jQuery("#softwaredevelopmodel").append("<option value="+ item.developModelName+" selected='selected'>"+ item.developModelName+"</option>");
			 		}else{
			 			jQuery("#softwaredevelopmodel").append("<option value="+ item.developModelName+">"+ item.developModelName+"</option>");
			 		}
			 		
			 	}); 
           },
			error:function(){
				layer.msg( "系统错误");
			}
	    });	
	    $.ajax({ 
				url:'${_baseUrl}/secretsInvolvedLevel/selectAllSecretsMessage', 
				type:'post', //数据发送方式 
				dataType:'json', //接受数据格式 
				async: false,
				success: function(data){
				 	var jsonObj=eval("("+data.json+")");
				 	$.each(jsonObj, function (i, item) {
				 		if("${projectBaseinfo.projectclassification}" == item.secretsInvolvedLevel){
				 			jQuery("#secretsinvolvedlevel").append("<option value="+ item.secretsInvolvedLevel+" selected='selected'>"+ item.secretsInvolvedLevel+"</option>");
				 		}else{
				 			jQuery("#secretsinvolvedlevel").append("<option value="+ item.secretsInvolvedLevel+">"+ item.secretsInvolvedLevel+"</option>");
				 		}
				 		
				 	}); 
	            },
				error:function(){
					layer.msg( "系统错误");
				}
		});
	    $.ajax({ 
			url:'${_baseUrl}/documentType/selectAllDocumentTypeMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	$.each(jsonObj, function (i, item) {
			 		if("${projectBaseinfo.documenttype}" == item.documentType){
			 			jQuery("#documenttype").append("<option value="+ item.documentType+" selected='selected'>"+ item.documentType+"</option>");
			 		}else{
			 			jQuery("#documenttype").append("<option value="+ item.documentType+">"+ item.documentType+"</option>");
			 		}
			 		
			 	}); 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	    });
	    $.ajax({ 
			url:'${_baseUrl}/softwareKeyLevel/selectAllKeyLevelMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	jQuery("#softwarekeylevel").append("<option value=''>请选择</option>");
			 	$.each(jsonObj, function (i, item) {
			 		if("${projectBaseinfo.softwarecriticallevels}" == item.softwareKeyLevel){
			 			jQuery("#softwarekeylevel").append("<option value="+ item.softwareKeyLevel+" selected='selected'>"+ item.softwareKeyLevel+"</option>");
			 		}else{
			 			jQuery("#softwarekeylevel").append("<option value="+ item.softwareKeyLevel+">"+ item.softwareKeyLevel+"</option>");
			 		}
			 	}); 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	    });
	    $.ajax({ 
			url:'${_baseUrl}/softwareSize/selectAllSoftwareSizeMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	jQuery("#softwaresize").append("<option value=''>请选择</option>");
			 	$.each(jsonObj, function (i, item) {
			 		if("${projectBaseinfo.softwarescale}" == item.softwareSize){
			 			jQuery("#softwaresize").append("<option value="+ item.softwareSize+" selected='selected'>"+ item.softwareSize+"</option>");
			 		}else{
			 			jQuery("#softwaresize").append("<option value="+ item.softwareSize+">"+ item.softwareSize+"</option>");
			 		}
			 		
			 	}); 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	    });
	    $.ajax({
	    	url:'${_baseUrl}/documentList/selectAllPeople', 
			type:'post', //数据发送方式 
			data:{"projectId":projectId},
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
				var json = JSON.stringify(data);
				var jsonObj = eval("("+json+")");
			 	$.each(jsonObj, function (i, item) {
			 		jQuery("#teamPeople").append("<option value="+ i +">"+ item+"</option>");
			 	}); 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	    });
		documentList = $("#documentList").bootstrapTable({
			url : '${_baseUrl}/documentList/getProjectDocumetnList?projectId='+projectId+'&peopleId='+$("#teamPeople").val()+'&number='+Math.random(),
			pagination: true,
			pageList: [5, 10, 20, 50],
	  		queryParams: queryParams,
	  		clickToSelect: false,
	  		columns: [{
	  	       	 field: 'checked',
	  	         checkbox: true
	  	     	},{
	            field: 'serial',
	            title: '序号',
	            width: 50,
	            formatter : function(value, row, index) {
	            	if(status){
	            		var str=value;
	            	}else{
	            		var str=index+1;
	            	}
	 			return str;
	            }
	        },{
	           field: 'id',
	           title: 'id',
	           visible:false,
	           width: 5
	       },{
	           field: 'documentVersion',
	           title: 'documentVersion',
	           visible:false,
	           width: 5
	       },{
	           field: 'templateId',
	           title: 'templateId',
	           visible:false,
	           width: 5
	       },{
	           field: 'projectId',
	           title: 'projectId',
	           visible:false,
	           width: 5
	       },{
	           field: 'documentManager',
	           title: 'documentManager',
	           visible:false,
	           width: 5
	       },{
	           field: 'documentTeamPeople',
	           title: 'documentTeamPeople',
	           visible:false,
	           width: 5
	       },{
	            field: 'templateName',
	            title: '工作产品',
	            width: 120,
	            formatter : function(value, row, index) {
	            	if(row.documentStatus == "3"){
	            		return "<a onClick=\"documentPreview_1('"+row.id+"','"+row.projectId+"');\" class='wdbx_tit' title='"+value+"'>"+value+"</a>";
	            	}else{
	            		return "<div class='wdbx_tit' title='"+value+"'>"+value+"</div>";
	            	}
	            }
	        },{
	            field: 'startTime',
	            title: '开始时间',
	            width: 110,
	            formatter : function(value, row, index) {
	            	var v = value.substring(0,value.length-3);
	            	return v;
	            }
	        },{
	            field: 'endTime',
	            title: '完成时间',
	            width: 110,
	            formatter : function(value, row, index) {
	            	var v = value.substring(0,value.length-3);
	            	return v;
	            }
	        },{
	            field: 'documentManagerName',
	            title: '文档负责人',
	            width: 20
	        },{
	            field: 'documentTeamPeopleName',
	            title: '协同编制人员',
	            width: 150
	        },{
	            field: 'documentVersion',
	            title: '文档版本',
	            width: 20
	        },{
	            field: 'documentStatus',
	            title: '文档状态',
	            width: 20,
	            formatter : function(value, row, index) {
	            	var str ;
					if(value == "1"){
						str = "未编写";
					}else if(value == "2"){
						str = "编写中";
					}else if(value == "3"){
						str = "已发布";
					}
					return str;
				}
	        },{
	            field: '',
	            title: '历史版本',
	            width: 20,
	            formatter : function(value, row, index) {
	            	return "<a style=\"width:100%;\" onClick=\"loadDocumentHistoryVersions('"+row.id+"','"+row.templateId+"','"+row.projectId+"','"+row.documentStatus+"');\">查看</a>";
				}
	        },{
	            field: 'traceDocumentName',
	            title: '追踪文档',
	            width: 150,
	            formatter : function(value, row, index) {
	            	if(value=='-'){
	            		return "<div class='wdbx_tit' title='"+value+"'>"+value+"</div>";
	            	}
	            	var title = value;
	            	
	            	if(title.indexOf("<br/>")>0){
	            		for(var i = 0;;i++){
		            		title  = title.replace('<br/>','；');
		            		if(title.indexOf("<br/>")<0){
		            			return "<div class='wdbx_tit' title='"+title+"'>"+value+"</div>";
		            		}
		            	} 
            		}else{
            			return "<div class='wdbx_tit' title='"+value+"'>"+value+"</div>";
            		}
	            }
	        },{
	            field: 'editPlan',
	            title: '编写进度',
	            width: 20,
	            formatter : function(value, row, index) {
	            	
	            		return value;
	            },
	        	visible:editeStatus
	        
	        },{
	            field: '',
	            title: '操作',
	            width: 150,
	            formatter : function(value, row, index) {
	            	var documentTeamPeople = row.documentTeamPeople;
	            	var documentManager = row.documentManager;
	            	var result = false;
	            	if(row.documentTeamPeople !=null){
	            		if(row.documentTeamPeople.indexOf("${user.id}")>=0||documentManager == "${user.id}" ||proManager =="${user.id}"){
							result=true;
						}
	            	}else{
	            		if(documentManager == "${user.id}" ||proManager =="${user.id}"){
	            			result=true;
	            		}
	            	}
	            	
	            	if("${projectsupervision}" != '' && !result){
	            		if(judgeDown(row.id)){
            				return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','yes');\">查看文档</a>&nbsp;<a onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
            			}else{
            				return "<div class=\"controllerBox\"><a style=\"display:inline; float:none; padding-right:0;\"loat:none; padding-right:0;\" onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','yes');\">查看文档</a></div>";
            			}
	            	}else{
	            		if("${status}" == '4'){
	            			if(judgeDown(row.id)){
	            				return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','yes');\">查看文档</a>&nbsp;<a onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
	            			}else{
	            				return "<div class=\"controllerBox\"><a style=\"display:inline; float:none; padding-right:0;\" onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','yes');\">查看文档</a></div>";
	            			}
		            	}else if(documentManager == "${user.id}" ||proManager =="${user.id}"){
		            		if(judgeDown(row.id)){
	            				if(row.templateId == null || row.documentTeamPeopleName == null){
	            					if("${projectBaseinfo.documenttemplateName}" == "GJB438B项目文档模板"){
	            						return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a>&nbsp;<a onClick=\"documentInformationDefinition('"+row.id+"','"+row.projectId+"');\">文档信息定义</a><br><a onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
	            					}else{
	            						return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a>&nbsp;<a onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
	            					}
	            				}else{
	            					if("${projectBaseinfo.documenttemplateName}" == "GJB438B项目文档模板"){
	            						if(row.synergyType == "1"){
		                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"synergyWrite('"+row.id+"','"+row.projectId+"');\">协同编制</a>&nbsp;<a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a><br><a onClick=\"documentInformationDefinition('"+row.id+"','"+row.projectId+"');\">文档信息定义</a>&nbsp;<a onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
	            						}else{
		                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a>&nbsp;<a onClick=\"documentInformationDefinition('"+row.id+"','"+row.projectId+"');\">文档信息定义</a><br><a onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
	            						}
	            					}else{
	            						if(row.synergyType == "1"){
		                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"synergyWrite('"+row.id+"','"+row.projectId+"');\">协同编制</a>&nbsp;<a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a><br><a onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
	            						}else{
		                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a>&nbsp;<a onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
	            						}
	            					}
	            				}
	            			}else{
	            				if(row.templateId == null || row.documentTeamPeopleName == null){
	            					if("${projectBaseinfo.documenttemplateName}" == "GJB438B项目文档模板"){
	                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a>&nbsp;<a onClick=\"documentInformationDefinition('"+row.id+"','"+row.projectId+"');\">文档信息定义</a></div>";
	            					}else{
	                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a></div>";
	            					}
	            				}else{
	            					if("${projectBaseinfo.documenttemplateName}" == "GJB438B项目文档模板"){
	            						if(row.synergyType == "1"){
		                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"synergyWrite('"+row.id+"','"+row.projectId+"');\">协同编制</a>&nbsp;<a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a><br><a onClick=\"documentInformationDefinition('"+row.id+"','"+row.projectId+"');\">文档信息定义</a></div>";
	            						}else
		                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a>&nbsp;<a onClick=\"documentInformationDefinition('"+row.id+"','"+row.projectId+"');\">文档信息定义</a></div>";
	            							
	            					}else{
	            						if(row.synergyType == "1"){
		                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"synergyWrite('"+row.id+"','"+row.projectId+"');\">协同编制</a>&nbsp;<a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a></div>";
	            						}else{
		                					return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"demandTracking('"+row.id+"','"+row.projectId+"','"+row.templateName+"');\">文档追踪</a><br><a onClick=\"documentChange('"+row.id+"','"+row.projectId+"','"+row.documentStatus+"');\">发起变更</a></div>";
	            						}
	            					}
	            				}
	            				
	            			}
		            	}else if(documentManager != "${user.id}"){
		            		if(documentTeamPeople != null && documentTeamPeople.indexOf("${user.id}") <0){
		            			if(judgeDown(row.id)){
		            				return "<div class=\"controllerBox\"><a style=\"display:inline; float:none; padding-right:0;\" onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
		            			}else{
		            				return "---";
		            			}
		            			
		            		}else{
		            			if(judgeDown(row.id)){
		            				return "<div class=\"controllerBox\"><a onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a>&nbsp;<a onClick=\"downloadDoc('"+row.id+"');\">文档下载</a></div>";
		            			}else{
		            				return "<div class=\"controllerBox\"><a style=\"display:inline; float:none; padding-right:0;\" onClick=\"editDocument('"+row.id+"','"+row.projectId+"','"+row.templateName+"','"+row.templateName+"','"+row.documentStatus+"','no');\">编写文档</a></div>";
		            			}
		            		}
		            	}
	            	}
				}
	        }]
	    });
		
		//回车
		$(document).keyup(function(event){
			  e = event ? event :(window.event ? window.event : null);
			  if(e.keyCode == 13){
				  refreshTable();
			  }
		});
		
		documentChangeList = $("#documentChangeList").bootstrapTable({
			url : '${_baseUrl}/documentList/getProjectChangeDocumetnList?projectId='+projectId,
			pagination: true,
			pageList: [5, 10, 20, 50],
	  		queryParams: queryParams,
	  		rowStyle: rowStyle,
	  		clickToSelect: false,
	  		columns: [{
	            field: 'serial',
	            title: '序号',
	            width: 50,
	            formatter : function(value, row, index) {
	            	if(status){
	            		var str=value;
	            	}else{
	            		var str=index+1;
	            	}
	 			return str;
	            }
	        },{
	           field: 'changeDocumentId',
	           title: 'changeDocumentId',
	           visible:false,
	           width: 5
	       },{
	           field: 'changeId',
	           title: 'changeId',
	           visible:false,
	           width: 5
	       },{
	           field: 'oldDocumentId',
	           title: 'oldDocumentId',
	           visible:false,
	           width: 5
	       },{
	           field: 'activeType',
	           title: '活动类型',
	           visible:false,
	           width: 5
	       },{
	           field: 'activeName',
	           title: '活动名称',
	           visible:false,
	           width: 5
	       },{
	            field: 'changeDocumentName',
	            title: '工作产品',
	            width: 100
	        },{
	            field: 'changeDate',
	            title: '变更时间',
	            width: 100
	        },{
	            field: 'changePersionName',
	            title: '变更执行人员',
	            width: 100
	        },{
	            field: 'documentManagerName',
	            title: '文档负责人',
	            width: 100
	        },{
	        	field: 'changedDocumentCount',
	            title: '变更文档数量',
	            width: 70,
	            formatter: function(value, row, index){
	            	if(value > 0){	           		
		            	return "<a href='${_baseUrl}/chc/showChangeHistoryDetails?projectId=${projectId}&changeId="+row.changeId+"'>"+value+"</a>";
	            		//return "<a onClick=\"getChangeContent('"+row.changeId+"','"+row.ifExist+"');\">"+value+"</a>";
	            	}else{
	            		return value;
	            	}
	            }
	        },{
	            field: 'newVersion',
	            title: '变更后的文档版本',
	            width: 100
	        },{
	            field: '',
	            title: '变更申请单',
	            width: 100,
	            formatter : function(value, row, index) {
	            	return "<a onClick=\"getChangeRequestForm('"+row.changeId+"','"+projectId+"','"+row.ifExist+"');\">查看</a>";
				}
	        },{
	            field: '',
	            title: '影响域分析',
	            width: 100,
	            formatter : function(value, row, index) {
					return "<a style=\" display:inline; float:none; padding-right:0;\" onClick=\"influenceAnalyze('"+row.changeId+"','"+projectId+"','"+row.ifExist+"');\">查看</a>";
				}
	        }]
	    });
		function rowStyle(row, index) {
			if(row.ifExist == "false"){
				return {
				    //classes: 'text-nowrap another-class',
				    css: {"color": "#CACAC4"}
				  };
			}else{
				return {
				    
				  };
			}
				
		}
		function queryParams(params){
			return {
			    pageSize: params.limit,
			    pageNo: params.pn,
			    sort : params.sort,
			    order : params.order,
			    templateName : $("#document_name").val(),
			    documentStatus : $("#document_status").val()
		   }
		}
	})
	
	function judgeDown(id){
		var result =false;
		var path="${_baseUrl}/download/judgeDocumentExport";
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{"documentId":id},
			dataType:"json",    
			success: function (data) {   
				if(data.code=='1'){
					result =true;
				}else{
					result =false;	
				}
				
			}   
		}); 
		return result;
	}
	
	function downloadDoc(id){
		var path="${_baseUrl}/download/docDownload?documentId="+id;
		window.location.href=path;
		setTimeout(function(){
			refreshTable();
		},1500);	
	}
	
	
	function updateProjectMessage(){
	    var projectId = "${projectId}";
		var id = "${id}";
		var path="${_baseUrl}/document/projectInitialize?id="+id+"&projectId="+projectId+"&type=1&update=1";
		window.location.href=path;
	    
	}
	function saveProjectMessage(){
		if($("#project").validationEngine('validate')){
		    $("#project").attr("action", "${_baseUrl}/project/saveProjectMessage?projectId="+projectId);
			$('#project').submit();
			layer.msg( "保存成功");
			window.location.reload();
			
		}
	}
	function getProjectTemplateName(){
		var id = "${projectBaseinfo.documenttemplate}";
		var url = "${_baseUrl}/document/showTemplateList?id="+id;
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'项目文档模板',
			autoOpen: true,
			modal: true,	
			height: 550,
			width: 870
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src",url);
	}
	function closeWin(){
		$("#popDiv").dialog('close');
	}
	
	
	function editDocument(id,projectId,templateName,documentStatus,isOk){
		$.ajax({ 
			url:'${_baseUrl}/documentList/isOrInfluence', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"documentId":id,"projectId":projectId},
			async: false,
			success: function(data){
				if("changeDocumentNoChanged" == data){
					layer.msg("发起变更的文档没有完成变更");    /* 修改提示语：发起变更的文档没有完成变更 即可 后半句反而容易产生歧义   */
					return;
				}else if(data == "no"){
					//layer.msg("该项目处于变更中,不能发布新文档",{shift:1},function(){
						var path="${_baseUrl}/documentSectionController/sectionTree?projectId="+projectId+"&documentId="+id+"&status="+documentStatus+"&isOk="+isOk;
						window.location.href=path;
					//});
				}else if(data == "noMessage"){
					$("#popIframe").empty();	
					$("#popDiv").dialog({
						title:'文档基本信息定义',
						autoOpen: true,
						modal: true,	
						height: 400,
						width: 800
					});	
					$("#popIframe").attr("width","100%");
					$("#popIframe").attr("height","95%");
					$("#popIframe").attr("src","${_baseUrl}/document/documentInformationDefinition?documentId="+id+"&projectId="+projectId+"&templateName="+templateName);
				}else if(data == "suggest"){
					var options = "该文档有协同编制人员建议您先将文档的章节分配给协同编制人员";
					layer.confirm(options,{
			    		btn:['跳过','确定']},
			    		function (){
			    			var path="${_baseUrl}/documentSectionController/sectionTree?projectId="+projectId+"&documentId="+id+"&status="+documentStatus+"&isOk="+isOk;
							window.location.href=path;
			    		},
			    		function(){
			    			synergyWrite(id,projectId);
			    		}
			    	);

				}else if(data == "fail"){
					layer.msg("该文档尚未进行编写任务的分配，请稍后！");
					return;
				}else if(data == "noContains"){
					layer.msg("该文档没有您的编写任务");
					return;
				}else if(data == "yes"){
					var path="${_baseUrl}/documentSectionController/sectionTree?projectId="+projectId+"&documentId="+id+"&status="+documentStatus+"&isOk="+isOk;
					window.location.href=path;
				}else if(data == "wait"){
					layer.msg("该文档变更状态为等待变更，需等其他文档变更完之后才能变更");
					return;
				}else if(data=="check"){
					var path="${_baseUrl}/documentSectionController/sectionTree?projectId="+projectId+"&documentId="+id+"&status="+documentStatus+"&isOk="+isOk;
					window.location.href=path;
				}else{
					var path="${_baseUrl}/documentSectionController/sectionTree?projectId="+projectId+"&documentId="+data+"&status="+documentStatus+"&isOk="+isOk;
					window.location.href=path;
				} 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	    });
		
	}
	function selectByStatus(){
		window.location.reload();
	}
	
	
	function refreshTable(){
		documentList.bootstrapTable('refresh',{url:'${_baseUrl}/documentList/getProjectDocumetnList?projectId='+projectId+'&peopleId='+$("#teamPeople").val()+'&number='+Math.random()});
	}
	function demandTracking(id,projectId){
		$.ajax({
			url:'${_baseUrl}/dd/checkDocument?documentId='+id,
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
				if("0" == data.code)
					parent.skipModule("需求追踪","${_baseUrl}/dd/showTraceRelation?projectId="+projectId+"&documentId="+id);
					//window.location.href = "${_baseUrl}/dd/showTraceRelation?projectId="+projectId+"&documentId="+id;
				else
					layer.msg("请先编写并发布文档");
	        },
			error:function(){
				layer.msg( "系统错误");
			}
		});
		
	}
	function synergyWrite(id,projectId){
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'协同编制任务分配',
			autoOpen: true,
			modal: true,	
			height: 550,
			width: 800
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/document/synergyWrite?documentId="+id+"&projectId="+projectId);
	}
	
	function documentInformationDefinition(id,projectId,templateName){
		$.ajax({ 
			url:'${_baseUrl}/documentList/isOrInfluence', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"documentId":id,"projectId":projectId},
			async: false,
			success: function(data){
				if(data == "no"){
					//layer.msg("该项目处于变更中,不能再发起变更",{shift:1},function(){
						$("#popIframe").empty();	
						$("#popDiv").dialog({
							title:'文档基本信息定义',
							autoOpen: true,
							modal: true,	
							height: 400,
							width: 800
						});	
						$("#popIframe").attr("width","100%");
						$("#popIframe").attr("height","95%");
						$("#popIframe").attr("src","${_baseUrl}/document/documentInformationDefinition?documentId="+id+"&projectId="+projectId+"&templateName="+templateName);
					//});
				}else if(data == "fail"){
					layer.msg("该文档的章节还没有分配给编制人员,请重新分配");
					return;
				}else if(data == "noContains"){
					layer.msg("该文档没有您的编写任务");
					return;
				}else{
					$("#popIframe").empty();	
					$("#popDiv").dialog({
						title:'文档基本信息定义',
						autoOpen: true,
						modal: true,	
						height: 400,
						width: 800
					});	
					$("#popIframe").attr("width","100%");
					$("#popIframe").attr("height","95%");
					$("#popIframe").attr("src","${_baseUrl}/document/documentInformationDefinition?documentId="+id+"&projectId="+projectId+"&templateName="+templateName);
				}
            },
			error:function(){
				layer.msg( "系统错误");
			}
	    });
		
	}
	function loadDocumentHistoryVersions(id,templateId,projectId,status){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'文档版本信息',
			autoOpen: true,
			modal: true,	
			height: 550,
			width: 900
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/document/loadDocumentHistoryVersions?templateId="+templateId+"&projectId="+projectId+"&documentId="+id);
	
	}

	function getChangeRequestForm(changeId,projectId,ifExist){
		if(ifExist=="false"){
			layer.msg("该文档数据已删除!")
		}else{
			$("#popIframe").empty();	
			$("#popDiv").dialog({
				title:'变更申请单',
				autoOpen: true,
				modal: true,	
				height: 550,
				width: 900
			});	
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/ci/showChangeRequestNoteDetails?projectId="+projectId+"&changeId="+changeId);
			
		}
	}
	
	function getChangeContent(changeId,ifExist){
		if(ifExist=="false"){
			layer.msg("该文档数据已删除!");
		}else{
			$("#popIframe").empty();	
			$("#popDiv").dialog({
				title:'内容变更单',
				autoOpen: true,
				modal: true,	
				height: 550,
				width: 900
			});	
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			//$("#popIframe").attr("src","${_baseUrl}/cdc/showChangeContent?projectId="+projectId+"&documentId="+oldDocumentId+"&changeId="+changeId+"&readOnly=true");
			if(value > 0){
            	//return "<a href='${_baseUrl}/chc/showChangeHistoryDetails?projectId=${projectId}&changeId="+row.changeId+"'>"+value+"</a>";
				//$("#popIframe").attr("src","${_baseUrl}/chc/showChangeHistoryDetails?projectId=${projectId}&changeId="+changeId+"'>'");
        	}else{
        		return value;
        	}
				
		}
	}
	
	/* 展示表格的追踪关系 */
	function showDemandTraceTable(documentId,projectId){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'查看追踪关系',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 950
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/dd/showTraceDetailed?documentId="+documentId+"&projectId="+projectId+"&random="+Math.random());
	}
	function influenceAnalyze(changeId,projectId,ifExist){
		if(ifExist=="false"){
			layer.msg("该文档数据已删除!");
		}else{
			$("#popIframe").empty();
			$("#popDiv").dialog({
				title:'影响域分析',
				autoOpen: true,
				modal: true,	
				height: 600,
				width: 1086
			});
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/ci/showChangeInfluence?projectId="+projectId+"&changeId="+changeId+"&readOnly=true");
		}
	}
	function documentPreview(documentId,projectId){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'查看文档',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 950,
			close:function(event,uri){
				
			}
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/documentController/documentPreviewOne?documentId="+documentId+"&projectId="+projectId);
	}
	function documentPreview_1(documentId,projectId){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'查看文档',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 950,
			close:function(event,uri){
				
			}
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/documentController/documentPreview?documentId="+documentId+"&projectId="+projectId);
	}
	
	function alertMessage(){	
		layer.msg("已完成对勾选的项目文档的勘误修改",{shift:5,time:1500});
		$("#popDiv").dialog("close");
	}
	
	function documentChange(documentId,projectId,status){
		//alert(status);
		//if(status== "3"){
			$.ajax({
				url:'${_baseUrl}/documentList/judgeIfChange',
				type:'post', //数据发送方式 
				dataType:'json', //接受数据格式 
				async: false,
				data:{
					"documentId":documentId,
					"projectId":projectId
				},
				success: function(data){
					if(data.code=='0'){
						layer.msg("请等待本轮变更结束后，再发起变更。");
					}
					if(data.code=='1'){
						docId = documentId;
						if(status == "3"){
							if(proManager=="${user.id}" || data.message == "${user.id}"){
								parent.skipModule("变更分析","${_baseUrl}/ca/showChangeRequestNote?projectId="+projectId+"&documentId="+docId);
								/* $("#popIframe").empty();
								$("#popDiv").dialog({
									title:'请选择变更内容类型:',
									autoOpen: true,
									modal: true,
									height: 300,
									width: 500,  // 取消弹框设置位置，弹框出现默认位置  
								});//
								$("#popIframe").attr("width","100%");
								$("#popIframe").attr("height","95%");
								$("#popIframe").attr("src","${_baseUrl}/ca/startChangeMessage?projectId="+projectId+"&documentId="+documentId); */
							}
							
							/* if(data.message == "${user.id}"){
								parent.skipModule("变更分析","${_baseUrl}/ca/showChangeRequestNote?projectId="+projectId+"&documentId="+docId);
							} */
							
						}else{
							layer.msg( "请先编写并发布文档");
							//parent.skipModule("变更分析","${_baseUrl}/ca/showChangeRequestNote?projectId="+projectId+"&documentId="+docId);
						}
					}
					//if(data.code=='2'){
						//layer.msg("请等待前项文档变更完成后，再发起变更。");
					//}
					/* if(data.code=='3'){
						editDocument(documentId,projectId,data.data,status,"yes");
					} */
					/* if(data.code=='4'){
						editDocument(data.message,projectId,data.data,status,"yes");
					} */
		        },
				error:function(){
					layer.msg( "系统错误");
				}
			});
		//}else{
		//	layer.msg( "请先编写并发布文档");
		//}	
	}
	function skipChangeRequestNote(projectId){
		$("#popDiv").dialog("close");
		parent.skipModule("变更分析","${_baseUrl}/ca/showChangeRequestNote?projectId="+projectId+"&documentId="+docId);
	}
	function openReplacePage(projectId){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'勘误修改',
			autoOpen: true,
			modal: true,
			position:'center',
			height: 500,
			width: 800
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/ca/openReplacePage?projectId="+projectId);

	}
	function checkDocument(documentId,projectId){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'查看文档',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 950
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/documentController/previewDoc?projectId="+projectId+"&documentId="+documentId);
	}
	
	/*下载选择的文档并生成压缩包*/
	function  selectExportDoc(){
		var objects =  $("#documentList").bootstrapTable('getSelections');
		var id ="";
		for(var i =0;i<objects.length;i++){
			if(id.length>0){
				id+=","+objects[i].id;
			}else{
				id=objects[i].id;
			}
		}
		if(id.length==0){
			layer.msg("请先选择文档");
			return;
		}
		//提示是否等待文档生成
		var path = "${_baseUrl}/exportController/createSelect";
		var ifReturn="";
		var tip ="";
		if(id.length>32){
			tip="是否等待文档生成？ <br>点击  '是'：立即生成文档并查看； <br>   点击  '否'：请在文档页面点击'项目文档下载'将生成文档下载到本地。";
		}else{
			tip="是否等待文档生成？ <br>点击  '是'：立即生成文档并查看； <br>   点击  '否'：请在文档页面点击'文档下载'将生成文档下载到本地。";
		}
		layer.confirm(tip, {
			area:['500px'],
			btn: ['是','否'] //按钮
			}, function(){
				layer.load(2);	
				$.ajax({    
					type: "POST",    
					async: true,    
					url:path,
					data:{
						"documentId":id,
						"projectId":projectId,
						"ifReturn":"true"
					},
					dataType:"json",
					success: function (json) {
						judgeSelectExport();
						layer.closeAll('loading');
						layer.closeAll('dialog');
						if(json.code=='1'){
							judgeSelectExport();
							window.location.href="${_baseUrl}/exportController/downDoc?documentId="+id+"&projectId="+projectId+"&ifReturn=true";
						}else if(json.code =='2'){
							
						}else{
							layer.msg("导出文档出错，请查看文档中是否存在不支持的内容。");
						}
						
					},
					error:function(){
						layer.msg("导出文档出错，请查看文档中是否存在不支持的内容。");
						
					}
				});
			}, function(){
				$.ajax({    
					type: "POST",    
					async: true,    
					url:path,
					data:{
						"documentId":id,
						"projectId":projectId,
						"ifReturn":"false"
					},
					dataType:"json",
					success: function (json) {
						if(json.code=='0'){
							layer.msg("导出文档出错，请查看文档中是否存在不支持的内容。");
						}else{
							judgeSelectExport();
						}
					},
					error:function(){
						layer.msg("导出文档出错，请查看文档中是否存在不支持的内容。");
						
					}
				});
		});
		//修改高度
		var result = false;
		var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
	    var isOpera = userAgent.indexOf("Opera") > -1;
		if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
			result =  true;
		}; 
		if(!result){
			$(".layui-layer-content").attr("style","");			
		}
	}
	
	
	
	$(function(){
		judgeSelectExport();
	})
	
	function judgeSelectExport(){
		var path ="${_baseUrl}/download/judgeSelectExport";
		$.ajax({    
			type: "POST",    
			async: true,    
			url:path,
			data:{
				"projectId":projectId,
			},
			dataType:"json",
			success: function (json) {
				if(json.code=="1"){
					
					$("#prodown").css("display","block");
					$("#postion").val(json.message);
				}else{
					$("#prodown").css("display","none");  /* none */
					$("#postion").val(json.message);
				}
			},
			error:function(){
				
				
			}
		})
	}
	/* 内容复用 */
	function ContentCopy(projectId){
		var ids = "${projectBaseinfo.documenttemplate}";
	 	$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'内容复用',
			autoOpen: true,
			modal: true,	
			height: 750,
			width: 1100
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/demand/showContentReuse?projectId="+projectId+"&ids="+ids);
	
	}
	
	function checkSelectDocumenttype(){	
		var select = $("select[name='documenttype']");
		var options = $(select).find("option");
		for(var i =0;i<options.length;i++){
			if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
				var value = $(options[i]).val();
				if(value=="choice"){
					return "此处必须选择相应的选项";
				}else{
					return true;
				}
			}
		}
		
	}
	
	
	/*下载文档*/
	function downProDoc(){
		$("#postion").val("");
		$("#prodown").css("display","none");  /* none */
		path = "${_baseUrl}/exportController/projectDownDoc?projectId="+projectId;
		window.location.href=path;
	}
	/* 查看勘误错误历史记录 */
	function errataError(){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'勘误错误修改记录',
			autoOpen: true,
			modal: true,	
			height: 350,
			width: 700
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/ccc/showErrataError?projectId="+projectId);
	}
	function showAllTrack(){
		var winWidth = 0;
		if (window.innerWidth)
			winWidth = window.innerWidth;
		else if ((document.body) && (document.body.clientWidth))
		winWidth = document.body.clientWidth;
		
		/* $("#track").attr("class","");
		$("#documentTrace").attr("src","${_baseUrl}/dd/checkAllTrack?projectId="+projectId);
		 */
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'全景追踪',
			autoOpen: true,
			modal: true,	
			height: 800,
			width: window.screen.width-40
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","100%");
		$("#popIframe").attr("src","${_baseUrl}/dd/checkAllTrack?projectId="+projectId);
		
		
	}
	
	$(function(){
		if("${projectBaseinfo.documenttemplateName}" =="GJB438B项目文档模板"){
			$("#allTrack").css("display","block");
		}
	});
	
	/* 项目名称缺省显示 */
	function subProjectName(name){
		if(name.length > 50){
			name = name.substring(0,50);
			name += "...";
		}
		return name;
	}
	
	function controllerBox(){
		var oTd = $(".xmulist2_table table td");
		var oA = $(".xmulist2_table table a");
		oTd.each(function(){
			var oDiv = $(this).children();
			alert(oDiv.length);
		})
	}
	
	
</script>
<style>
	#project table td:first-child+td,#project table td:first-child+td+td+td,#project table td:first-child+td+td+td+td+td{ padding-left:20px;}
	/* #project table td input { margin-left:-7px\9;} */
	/* .wdbx_tit { width:95%;} */
	.xmulist2_table table td:last-child a { display:inline-block; padding-right:3px; float:left;}
	.controllerBox { width:124px; margin:0 auto;}
</style>
</head>
<body style="overflow-y:auto; ">
<div class="document_main">
        	<!-- <div class="page_tit_warp mtmb20"><div class="page_tit"><span>项目文档</span></div></div> -->
	        <div class="wdang_tab xmulist_tab">
	            <a href="javascript:;" class="wdtab_on">项目基本信息</a>
		            <span id="updateButton">
		            	<c:choose>
		            		<c:when test="${status == '4' or projectBaseinfo.projectstatus == '3' }">
							</c:when>
							<c:otherwise>
								<shiro:hasPermission name="document:projectInitialize">
							       <a href="javascript:;" onclick="updateProjectMessage();" style=" width:28px;">修改</a>
							    </shiro:hasPermission>	
							</c:otherwise>
		            	</c:choose>
		            	
		            </span>
		           <!--  <span id="saveButton" style="display:none">
		            	<a href="javascript:;" onclick="saveProjectMessage();">保存</a>
		            </span> -->
	        </div>
	        <div class="xmulist1">
	            <div class="xmugonj_curr" style=" height:20px;"><strong style=" display:block; width:84px; text-align:justify; text-justify:distribute-all-lines; text-align-last:justify; float:left; ">项目名称</strong><strong style="display:block; float:left; ">：</strong><span id="projectMessage" style="display:block; float:left;"></span></div>
	            <div class="xmugonj_p xmulist_p" style=" margin-bottom:5px;">
	            	<form id="project" method="post" action="">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
             <tr>
               <td width="9%" height="50" align="center" bgcolor="#f4f4f4">研制单位 </td>
               <td width="22%" align="left" valign="middle">
                <input name="enterprise" id="enterprise" type="text" disabled="disabled" value="${projectBaseinfo.enterprise}" class="input_text input_text90 validate[required]"> <i>*</i>
               </td>
               <td width="9%" align="center" bgcolor="#f4f4f4">软件开发模型</td>
               <td width="23%" align="left">
                <select name="softwaremodel" class="xmugonj_select" disabled="disabled" id="softwaredevelopmodel">
                </select>
               </td>
               <td width="10%" align="center" bgcolor="#f4f4f4">文档类别</td>
               <td width="27%" align="left">
                <select class="xmugonj_select validate[required,funcCall[checkSelectDocumenttype]]" id="documenttype" disabled="disabled" name="documenttype">
                </select><i>*</i>
               </td>
             </tr>
             <tr>
               <td width="9%" height="50" align="center" bgcolor="#f4f4f4">项目密级</td>
               <td align="left">
                <select class="xmugonj_select validate[required]" id="secretsinvolvedlevel" disabled="disabled" name="projectclassification">
                
                </select>
                <i> *</i>
               </td>
               <td width="9%" align="center" bgcolor="#f4f4f4">开始时间</td>
               <td align="left"><input id="projectstarttime" name="projectstarttime" disabled="disabled" type="text" value="${projectBaseinfo.projectstarttime}" class="input_text input_text90 validate[required]" onClick="WdatePicker()"/>
               <i> *</i></td>
               <td width="9%" align="center" bgcolor="#f4f4f4">完成时间</td>
               <td align="left">
                	<input id="projectendtime" name="projectendtime" type="text" class="input_text input_text90 validate[required]" disabled="disabled" value="${projectBaseinfo.projectendtime}" onClick="WdatePicker()"/> <i>*</i>
               </td>
             </tr>
             <tr>
               <td width="9%" height="50" align="center" bgcolor="#f4f4f4">软件规模</td>
               <td align="left">
                <select class="xmugonj_select" id="softwaresize" disabled="disabled" name="softwarescale">
                </select>
               </td>
               <td width="9%" align="center" bgcolor="#f4f4f4">软件关键等级</td>
               <td align="left">
               		<select class="xmugonj_select" id="softwarekeylevel" disabled="disabled" name="softwarecriticallevels">
                	</select>
               </td>
               <td width="9%" align="center" bgcolor="#f4f4f4">用户</td>
               <td align="left">
               		<input name="theuser" type="text" class="input_text input_text90" disabled="disabled" value="${projectBaseinfo.theuser}" id="theuser">
               </td>
             </tr>
             <tr>
               <td width="9%" height="50" align="center" bgcolor="#f4f4f4">需方</td>
               <td align="left"><input name="thebuyer" type="text" class="input_text input_text90" disabled="disabled" value="${projectBaseinfo.thebuyer}" id="thebuyer"></td>
               <td width="9%" align="center" bgcolor="#f4f4f4">保障机构</td>
               <td align="left"><input name="guaranteesetup" type="text" class="input_text input_text90" disabled="disabled" value="${projectBaseinfo.guaranteesetup}" id="guaranteesetup"></td>
               <td width="9%" align="center" bgcolor="#f4f4f4">开发方</td>
               <td align="left"><input name="developingparty" type="text" class="input_text input_text90 validate[required]" disabled="disabled" value="${projectBaseinfo.developingparty}" id="developingparty"></td>
             </tr>
             <tr>
               <td width="9%" height="50" align="center" bgcolor="#f4f4f4">测试方</td>
               <td align="left"><input name="testparty" type="text" id="testparty" disabled="disabled" class="input_text input_text90" value="${projectBaseinfo.testparty}"></td>
               <td align="center" bgcolor="#f4f4f4">
                	项目信息复用
               </td>
               <td style="padding:0;"><div class="xmugonj_t_x" style="position:relative;">
                     <input type="radio" disabled="disabled" name="isorreuse" id="isorreuse1" value="0" style="margin: 0 10px 0 20px;">可复用&nbsp;&nbsp;<input type="radio" id="isorreuse2" disabled="disabled" name="isorreuse" value="1" style="margin: 0 10px 0 20px;">不可复用
               		 <i style="color:red; position:absolute; right:25px;">*</i>
               </div></td>
               <td bgcolor="#f4f4f4">&nbsp;</td>
               <td>&nbsp;</td>
             </tr>
            </table>
            <input type="hidden" id="id"/>
  </form>
	            </div>
	            <div class="xmulist_t1">
		            <span><strong>项目模板类型：</strong>${projectBaseinfo.documenttemplateName}</span>
		            <span>
		            	<shiro:hasPermission name="document:showTemplateList">
					       <a href="javascript:;" onclick="getProjectTemplateName();">查看详情</a>
					    </shiro:hasPermission>	
		            </span>
		            <span><strong>项目文档追踪设置：</strong>${projectBaseinfo.demandName}</span>
		      
	            </div>
            </div>
            <div class="wdang_tab xmulist_tab">
            	<a href="javascript:;" class="wdtab_on">文档列表</a>
        	</div>
        	<div class="xmulist1 xmulist2">
	        	<div class="xmugonj_bz xmulist_bz">
	                <dl>
	                    <dt>文档状态：</dt>
	                    <dd>
	                        <select class="xmugonj_select" id="document_status" onchange="refreshTable();">
	                       	  <option value="">请选择</option>
	                          <option value="1">未编写</option>
	                          <option value="2">编写中</option>
	                          <option value="3">已发布</option>
	                      </select>
	                    </dd>
	                </dl>
	                <dl>
	                    <dt>人员：</dt>
	                    <dd>
	                        <select class="xmugonj_select" id="teamPeople" onchange="refreshTable();">
	                        	<option value="">请选择</option>
	                        </select>
	                    </dd>
	                </dl>
 	                <div class="fl xmulist2_ss">
	                	<p><input name="" id="document_name" type="text" class="input_text xmulist2_input" value="请输入文档名称..."  onFocus="if(this.value=='请输入文档名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入文档名称...';}"></p>
	                    <span><input name="" value="搜索" type="button" onclick="refreshTable();" class="dyi_btna dyi_btnabox dyi_btna1"></span>
	                </div>

	              	<div class="fr xmulist2_ss xmulist2_ssa" style="left:  0px; width:330px;">
	              		<a  id = "prodown"  style="display: none; float:right; margin-left:5px;" href="javascript:;" onclick="downProDoc();" >项目文档下载</a>
	                	<input value ="" id="postion" type="hidden" />
	                    <input name="" value="批量导出" type="button" onclick="selectExportDoc();" class="dyi_btna dyi_btnabox dyi_btna1 fr"/>
	                    
	                    <shiro:hasPermission name="document:cotentCopy">
	                  		<span id="cotentCopyButton" style="display:none; float:right;">
	                  			<input name="" value="内容复用"  type="button" onclick="ContentCopy('${projectId}');" class="dyi_btna dyi_btnabox dyi_btna1 fr"/>  
	                  		</span>	
	                  	</shiro:hasPermission>
	                </div>  
	                <div class="clear"></div>
	            </div>
	        	<div class="wdang_s xmulist2_table">
	        		 <table id="documentList" class="tab-w-01 tab-w-auto"></table> 
	            </div>
	            <div class="current_wz mtmb20"><strong>文档总数：</strong>${documentCount }；   &nbsp;&nbsp;&nbsp;&nbsp; <strong>已发布文档数量：</strong>${documentPushCount }；    &nbsp;&nbsp;&nbsp;&nbsp;<strong>未发布文档数量：</strong>${documentNotPushCount }；    &nbsp;&nbsp;&nbsp;&nbsp;<strong>建立追踪文档数量：</strong>${documentTraceCount }；</div>
            </div>    <!-- 修改显示样式  -->
            <c:if test="${not empty showChangeForm }">
            	 <div class="wdang_tab">
		            <a href="javascript:;" class="wdtab_on">文档变更记录</a>
		         
		           <div class="fr xmulist2_ss xmulist2_ssa" style="left: 0px; margin-top:22px;">
	                    <input name="" value="勘误错误修订记录" type="button" onclick="errataError();" class="dyi_btna dyi_btnabox dyi_btna1 fr"/>
	                </div>  
		        </div>
		        
		        <div class="xmulist1 xmulist2">
		           <div class="wdang_s xmulist2_table">
		    			<table id="documentChangeList" class="tab-w-01 tab-w-auto"></table> 
				   </div>
		        </div>
            </c:if>
       
		 <div class="wdang_tab xmulist_tab">
            	<a href="javascript:;"  id="track" class="wdtab_on">需求追踪</a>
            	
            	<div class="fr quanjingzz_btn" id="allTrack" style="display: none;" >
            		<a id="showAllTrack" href="javascript:;" onclick="showAllTrack();">全景追踪</a>
            	</div>
            	
         </div>
	         <iframe id="documentTrace" frameborder="0" style="width:100%; height:1357px;" src="${_baseUrl}/dd/showDocumentTrace?projectId=${projectId}"></iframe>
		 </div>
	<div id="popDiv" style="display: none;overflow: hidden;">
		<iframe id="popIframe" border="0" frameborder="no">
		</iframe>
	</div>
</body>

<script>
$(function(){
	$('#showAllTrack').bind('click',function(){
		var _this=$(this),_index=_this.index(),_datanavid=_this.data('navid');
		_this.removeClass('wdtab_on');
		_this.css("color","#fff");
	});
})
</script>
</html>
