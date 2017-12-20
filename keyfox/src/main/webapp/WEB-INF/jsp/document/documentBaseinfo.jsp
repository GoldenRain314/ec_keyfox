<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>项目初始化</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0 minimal-ui"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<script type="text/javascript" src="${_resources}datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
	
	var projectId = "${projectId}";
	var docTemplate;
	var type="${type}";
	$(function(){
	  
	   if("${type}" != ""){
		   $("#documenttemplate").attr("disabled","disabled");
		   $("#documentstandard").attr("disabled","disabled");
	   }
	   //获取项目名称
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
	   
	   /* 项目名称缺省显示 */
		function subProjectName(name){
			if(name.length > 50){
				name = name.substring(0,50);
				name += "...";
			}
			return name;
		}
	   
	   //获取项目文档研制标准
	   $.ajax({ 
			url:'${_baseUrl}/projectDocumentStandards/selectAllStandardsMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	$.each(jsonObj, function (i, item) {
			 		jQuery("#documentstandard").append("<option value="+ item.standardName+" title="+ item.standardName+">"+ item.standardName+"</option>");
			 	}); 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	   
	   //获取文档类别
	   $.ajax({ 
			url:'${_baseUrl}/documentType/selectAllDocumentTypeMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	$.each(jsonObj, function (i, item) {
			 		jQuery("#documenttype").append("<option value="+ item.documentType+">"+ item.documentType+"</option>");
			 	}); 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	   
	   //获取所有项目密级
	   $.ajax({ 
			url:'${_baseUrl}/secretsInvolvedLevel/selectAllSecretsMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	$.each(jsonObj, function (i, item) {
			 		jQuery("#secretsinvolvedlevel").append("<option value="+ item.secretsInvolvedLevel+">"+ item.secretsInvolvedLevel+"</option>");
			 	}); 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	   
	   //软件关键等级
	   $.ajax({ 
			url:'${_baseUrl}/softwareKeyLevel/selectAllKeyLevelMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	$.each(jsonObj, function (i, item) {
			 		jQuery("#softwarekeylevel").append("<option value="+ item.softwareKeyLevel+">"+ item.softwareKeyLevel+"</option>");
			 	}); 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	   
	   //软件规模
	   $.ajax({ 
			url:'${_baseUrl}/softwareSize/selectAllSoftwareSizeMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	$.each(jsonObj, function (i, item) {
			 		jQuery("#softwaresize").append("<option value="+ item.softwareSize+">"+ item.softwareSize+"</option>");
			 	}); 
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	   
	   //软件开发模型
	   $.ajax({ 
			url:'${_baseUrl}/softwareDevelopModel/selectAllModelMessage', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
			 	var jsonObj=eval("("+data.json+")");
			 	$.each(jsonObj, function (i, item) {
			 		jQuery("#softwaredevelopmodel").append("<option value="+ item.developModelName+">"+ item.developModelName+"</option>");
			 	}); 
           },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	   //获取所有项目文档模板
		getProjectTemplate();
	   
		//初始化项目的基本信息
		$.ajax({
			url:'${_baseUrl}/project/selectProjectByProjectId', 
			data:{"projectId":projectId},
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
				$("#id").val(data.id);
				$("#enterprise").val(data.enterprise);
				if(data.projectstarttime !=undefined){
					$("#projectstarttime").val(data.projectstarttime);
				}
				if(data.projectendtime !=undefined){
					$("#projectendtime").val(data.projectendtime);
				}
				
				$("#theuser").val(data.theuser);
				$("#thebuyer").val(data.thebuyer);
				$("#guaranteesetup").val(data.guaranteesetup);
				$("#developingparty").val(data.developingparty);
				$("#testparty").val(data.testparty);
				$("#applicationscope").val(data.applicationscope);
				$("#copyProjectId").val(data.copyProjectId);
				//alert(data.copyProjectId);
				
				$("#documentstandard option").each(function () {
					 var txt = $(this).text();
					 if(txt == data.documentstandard){
						 $(this).prop("selected","selected");
					 }
				});
				
				$("#softwaredevelopmodel option").each(function () {
					 var txt = $(this).text();
					 if(txt == data.softwaremodel){
						 $(this).prop("selected","selected");
					 }
				});
				
				$("#documenttype option").each(function () {
					 var txt = $(this).text();
					 if(txt == data.documenttype){
						 $(this).prop("selected","selected");
					 }
				});				
				$("#secretsinvolvedlevel option").each(function () {
					 var txt = $(this).text();
					 if(txt == data.projectclassification){
						 $(this).prop("selected","selected");
					 }
				});
				$("#softwarekeylevel option").each(function () {
					 var txt = $(this).text();
					 if(txt == data.softwarecriticallevels){
						 $(this).prop("selected","selected");
					 }
				});
				$("#softwaresize option").each(function () {
					 var txt = $(this).text();
					 if(txt == data.softwarescale){
						 $(this).prop("selected","selected");
					 }
				});
				
				//根据项目文档模板查询项目内容追踪设置
				$("#documenttemplate option").each(function () {
					 var txt = $(this).val();
					 docTemplate = data.documenttemplate;
					 
					 if(txt == data.documenttemplate){
						 $(this).prop("selected","selected");
						 $.ajax({
							 url:'${_baseUrl}/project/getDemandName?id='+docTemplate, 
								type:'post', //数据发送方式 
								dataType:'text', //接受数据格式 
								async: false,
								success: function(data){
									var split = data.split(",");
									$("#demandName").html("");
									$("#demandName").html(split[0]);
									$("#traceset").val(split[1]);
					            },
								error:function(){
									layer.msg( "系统错误");
							    }
						 });
						 
					 }
				});
				
				if(data.copyProjectId != "" && data.copyProjectId != undefined){
					$("#documenttemplate").attr("disabled",true);
					$("#reuseProject").html("<a href='javascript:;' class='glqxian_btn1' onclick='cancelReuseProject();' title=''“取消复用”取消项目复用所做的操作'>取消复用</a>");
				}else{
					$("#reuseProject").html("<a href='javascript:;' class='glqxian_btn1' onclick='reuseProject();' title='“项目复用”操作用于同类型或具有相似特征的项目数据的复用，可继承已选中的复用项目的基本信息、项目模板类型以及文档列表中文档最新版本内容。执行“项目复用”操作后将不可修改项目模板类型。'>项目复用</a>")
				}
				
				var checkedName = jQuery("#documenttemplate  option:selected").html();
				if(checkedName == 'GJB438B项目文档模板')
					$("#documentstandard").attr("disabled",true);
				
				//是否可复用
				$("input[type=radio][name=isorreuse][value="+data.isorreuse+"]").attr("checked",'checked');
            },
			error:function(){
				layer.msg( "系统错误");
			}
	});
		
});
	$(function(){
		$("#project").validationEngine({
			autoHidePrompt:true,//自动隐藏
			showOnMouseOver:true,//当鼠标移出时触发
			promptPosition:'bottomLeft',//提示信息的位置
			inlineValidation: false,//是否即时验证，false为提交表单时验证,默认true  
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
		
	});
	
	function check(){
		$("#documentList", window.parent.document).attr("disabled","disabled"); 
		$("#taskAssign", window.parent.document).attr("disabled","disabled");
		$("#documentstandard").removeAttr("disabled"); 
		
		var copyProjectId = $("#copyProjectId").val();
		var checkedId = jQuery("#documenttemplate  option:selected").val();
		var formChecked = $('#project').validationEngine('validate');
		if(formChecked){
			$("#save").attr("onClick","");
			layer.load(2);
			var options = {
				dataType:"json",
				data:{"checkedId":checkedId,"projectId":projectId,"docTemplate":docTemplate,"type":type},
				success:function(json){
					if(json.code == '1'){
						layer.msg(json.message,{shift:5,time:1000},function(){
							if("保存成功"==json.message)
								parent.click("documentList");
						});
					}
					if(json.code == '0'){
						layer.msg(json.message);
						
					}
				},
				error:function(json){
					layer.msg("系统错误,请联系管理员");
				}
			};
			$('#project').ajaxSubmit(options);
			
			/* $.ajax({ 
				url:'${_baseUrl}/project/saveProjectBaseinfo?random='+Math.random(), 
				type:'post', //数据发送方式 
				data:{
					"copyProjectId":copyProjectId,
					"id":$("#id").val(),
					"checkedId":checkedId,
					"projectId":projectId,
					"docTemplate":docTemplate,
					"type":type,
					"enterprise":$("#enterprise").val(),
					"softwaremodel":$("#softwaredevelopmodel").val(),
					"documenttype":$("#documenttype").val(),
					"projectclassification":$("#secretsinvolvedlevel").val(),
					"projectstarttime":$("#projectstarttime").val(),
					"projectendtime":$("#projectendtime").val(),
					"softwarescale":$("#softwaresize").val(),
					"theuser":$("#theuser").val(),
					"softwarecriticallevels":$("#softwarekeylevel").val(),
					"thebuyer":$("#thebuyer").val(),
					"guaranteesetup":$("#guaranteesetup").val(),
					"developingparty":$("#developingparty").val(),
					"testparty":$("#testparty").val(),
					"isorreuse":$("input[name='isorreuse']:checked").val(),
					"documenttemplate":$("#documenttemplate").val(),
					"applicationscope":$("#applicationscope").val(),
					"traceset":$("#traceset").val(),
					"copyProjectId":$("#copyProjectId").val(),
					"documentstandard":$("#documentstandard").val()
				},
				dataType:'json', //接受数据格式 
				async: false,
				success: function(json){
					if(json.code == '1'){
						layer.msg(json.message,{shift:5,time:1000},function(){
							if("保存成功"==json.message)
								parent.click("documentList");
						});
					}
					if(json.code == '0'){
						layer.msg(json.message);
						
					}
		        },
				error:function(){
					layer.msg( "系统错误");
				}
		    }); */
		}else{
			$("#save").attr("onClick","check()");
		}
	}
	function getTemplateDocumentList(){
		$("#documentstandard").removeAttr("disabled");
		var id = jQuery("#documenttemplate  option:selected").val();
		var templateName = $("#documenttemplate option:selected").text();
		if(templateName == "GJB438B项目文档模板"){
			$("#documentstandard option").each(function () {
				 var txt = $(this).text();
				 if(txt == "GJB438B-2009"){
					 $(this).prop("selected","selected");
				 }
			});
			$("#documentstandard").attr("disabled","disabled");
		}
		if(id != 'choice'){
			$.ajax({ 
				url:'${_baseUrl}/documentType/getTemplateMessage', 
				type:'post', //数据发送方式 
				data:{"id":id},
				dataType:'json', //接受数据格式 
				async: false,
				success: function(data){
					$("#demandName").html("");
					$("#demandName").html(data.demandName);
					$("#traceset").val(data.demandId);
		        },
				error:function(){
					layer.msg( "系统错误");
				}
		    });
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
		
	}
	
	/* 关闭弹出框 */
	function closeWin(){
		$("#popDiv").dialog('close');
	}
	function refreshWin(){
		//$("#softwaredevelopmodel").val(json.name);
		layer.msg("加载成功");
		window.location.reload(true);
	}
	function reuseProject(){
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'可复用的项目',
			autoOpen: true,
			modal: true,	
			height: 550,
			width: 900
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/project/reuseProjectPage?projectId=${projectId}");
	}
	function cancelReuseProject(){
		 $.ajax({ 
				url:'${_baseUrl}/project/cancelReuseProjectPage', 
				type:'post', //数据发送方式 
				data:{"projectId":projectId},
				async: false,
				success: function(){
					layer.msg( "项目复用取消成功！");
					location.reload();
		        },
				error:function(){
					layer.msg( "项目复用取消失败！");
				}
	      });
	}
	function projectDocumentTemplateManage(){
		//parent.parent.skipModule("文档模板管理","${_baseUrl}/projectTemplateTypeController/showDocumentTemplateBank?source=1");
		/* var path="${_baseUrl}/documentList/projectDocumentTemplateManage";
		window.parent.location.href=path; */
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'项目文档模板管理',
			autoOpen: true,
			modal: true,	
			height: 550,
			width: 900
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/projectTemplateTypeController/showAllProjectTemplate");
		
	}
	function checkSelectDocumenttemplate(){	
		var select = $("select[name='documenttemplate']");
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
	function checkSelectProjectclassification(){	
		var select = $("select[name='projectclassification']");
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
/* 	function checkSelectSoftwarecriticallevels(){	
		var select = $("select[name='softwarecriticallevels']");
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
		
	} */
	function checkSelectDocumentstandard(){	
		var select = $("select[name='documentstandard']");
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
/* 	function checkSelectSoftwaremodel(){	
		var select = $("select[name='softwaremodel']");
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
	} */
/* 	function checkSelectSoftwareSize(){	
		var select = $("select[name='softwarescale']");
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
	} */
	function validateStartTime(){
		var startTime = $("#projectstarttime").val();
		var endTime = $("#projectendtime").val();
		if(endTime != "" && startTime != ""){
			if(startTime > endTime){
				layer.msg( "开始时间不能晚于结束时间");
				$("#projectstarttime").val("");
			}
		}
	}
	function validateEndTime(){
		var startTime = $("#projectstarttime").val();
		var endTime = $("#projectendtime").val();
		if(startTime != "" && endTime != ""){
			if(endTime < startTime){
				layer.msg( "结束时间不能早于开始时间");
				$("#projectendtime").val("");
			}
		}
	}
	function getProjectTemplate(){
		jQuery("#documenttemplate").empty();
		 $.ajax({ 
				url:'${_baseUrl}/documentType/selectAllDocTemplateMessage', 
				type:'post', //数据发送方式 
				dataType:'json', //接受数据格式 
				async: false,
				success: function(data){
				 	var jsonObj=eval("("+data.json+")");
				 	jQuery("#documenttemplate").append("<option value='choice'>请选择</option>");				 	
				 	$.each(jsonObj, function (i, item) {
				 		jQuery("#documenttemplate").append("<option value="+ item.id+" title="+item.projectTemplateName+" >"+ item.projectTemplateName+"</option>");				 		
				 	}); 
		        },
				error:function(){
					layer.msg( "系统错误");
				}
	      });
	}
	
	function AgainGetProjectTemplate(){
		if("${type}"== ""){
			jQuery("#documenttemplate").empty();
			 $.ajax({ 
					url:'${_baseUrl}/documentType/selectAllDocTemplateMessage', 
					type:'post', //数据发送方式 
					dataType:'json', //接受数据格式 
					async: false,
					success: function(data){
					 	var jsonObj=eval("("+data.json+")");
					 	jQuery("#documenttemplate").append("<option value='choice'>请选择</option>");
					 	$.each(jsonObj, function (i, item) {
					 		jQuery("#documenttemplate").append("<option value="+ item.id+" title="+item.projectTemplateName+" >"+ item.projectTemplateName+"</option>");
					 	}); 
			        },
					error:function(){
						layer.msg( "系统错误");
					}
		      });
		}
		
	}
	
	
</script>
<style>
	.xmugonj_t_p2{ padding-left:0px;}
	.xmugonj_bz_pl{ padding-left:0px;}
	.xmugonj_select { width:89%;}
	.xmugonj_p table td:first-child+td,.xmugonj_p table td:first-child+td+td+td,.xmugonj_p table td:first-child+td+td+td+td+td { padding-left:20px;}
	.xmugonj_p table td input { margin-left:-7px\9;}    /* 兼容ie浏览器  */
	.xmugonj_p table td select { margin-left:3px;}
	.xmugonj_t_x input[type='radio'] { margin:0 10px 0 0; display:inline;}
	
</style>
</head>
<body>
      <div class="xmugonj_cont ma" style="display:block;">
        <div class="glqxian_btn xmugonj_btn1 mtmb2010">
        	<div class="fl xmugonj_curr xmugonj_t_p2" style="width:900px;">
        		<strong style=" display:block; width:112px; text-align:justify; text-justify:distribute-all-lines; text-align-last:justify; float:left; ">项目名称</strong><strong style="display:block; float:left;">：</strong>
        		<span id="projectMessage" style="display:block; float:left;"></span>
        	</div>
        	<shiro:hasPermission name="project:reuseProjectPage">
        		<c:if test="${update != '1' }">
				        <div id="reuseProject"></div>
        		</c:if>   <!-- 添加项目复用说明  -->
		    </shiro:hasPermission>
        </div>
     	  
	     	  <form name ="project" id="project" action="${_baseUrl}/project/saveProjectBaseinfo" method="post">
		          <div class="xmugonj_bz xmugonj_bz_pl">
		           	<dl style="position:relative;">
		               	<dt>项目文档编制标准：</dt>
		                   <dd>
		                   	<select class="xmugonj_select validate[required,funcCall[checkSelectDocumentstandard]]" id="documentstandard" name="documentstandard">
		                   		<option value="choice">请选择</option>  
		                   	</select>
		                   </dd>
		                   	<dd style="color: red; position:absolute; left:305px; ">*</dd>
		                   <div class="clear"></div>
		               </dl>
		          </div>
		          <div class="xmugonj_p">
			           	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			                 <tr>
			                   <td width="10%" height="50" align="center" bgcolor="#f4f4f4">研制单位</td>
			                   <td width="23%" align="left" valign="middle">
			                   	<input name="enterprise" id="enterprise" type="text" class="input_text validate[maxSize[50] required]"> <i>*</i>
			                   </td>
			                   <td width="10%" align="center" bgcolor="#f4f4f4">软件开发模型</td>
			                   <td width="23%" align="left">
			                    <select name="softwaremodel" class="xmugonj_select" id="softwaredevelopmodel">
			                    	<option value="choice">请选择</option>  
			                    </select>
			                   </td>
			                   <td width="10%" align="center" bgcolor="#f4f4f4">文档类别</td>
			                   <td width="23%" align="left">
			                    <select class="xmugonj_select validate[required,funcCall[checkSelectDocumenttype]]" id="documenttype" name="documenttype">
									<option value="choice">请选择</option>  
			                    </select> <i>*</i>
			                   </td>
			                 </tr>
			                 <tr>
			                   <td width="9%" height="50" align="center" bgcolor="#f4f4f4">项目密级</td>
			                   <td align="left">
			                    <select class="xmugonj_select validate[required,funcCall[checkSelectProjectclassification]]" id="secretsinvolvedlevel" name="projectclassification">
			                    	<option value="choice">请选择</option>  
			                    </select> <i>*</i>
			                   </td>
			                   <td width="9%" align="center" bgcolor="#f4f4f4">开始时间</td>
			                   <td align="left"><input id="projectstarttime" name="projectstarttime" type="text" value="${startDate }" readonly onblur="validateStartTime();" class="input_text validate[required]" onfocus="WdatePicker({startDate:'%y-%M-01 00:00:00',dateFmt:'yyyy-MM-dd HH:mm:ss',alwaysUseStartDate:true})"/> <i>*</i></td>
			                   <td width="9%" align="center" bgcolor="#f4f4f4">完成时间</td>
			                   <td align="left"><input id="projectendtime" name="projectendtime" type="text" value="${endDate }" readonly onblur="validateEndTime();" class="input_text validate[required]" onfocus="WdatePicker({startDate:'%y-%M-01 00:00:00',dateFmt:'yyyy-MM-dd HH:mm:ss',alwaysUseStartDate:true})"/> <i>*</i></td>
			                   
			                 </tr>
			                 <tr>
			                   <td width="9%" height="50" align="center" bgcolor="#f4f4f4">软件规模</td>
			                   <td align="left">
			                    <select class="xmugonj_select" id="softwaresize" name="softwarescale">
			                    	<option value="choice">请选择</option>  
			                    </select>
			                   </td>
			                   <td width="9%" align="center" bgcolor="#f4f4f4">软件关键等级</td>
			                   <td align="left">
			                    <select class="xmugonj_select" id="softwarekeylevel" name="softwarecriticallevels">
			                    	<option value="choice">请选择</option>  
			                    </select>
			                   </td>
			                   <td width="9%" align="center" bgcolor="#f4f4f4">用户</td>
			                   <td align="left">
				                   	<input name="theuser" type="text" class="input_text validate[maxSize[50]]" id="theuser">
			                   </td>
			                 </tr>
			                 <tr>
			                   <td width="9%" height="50" align="center" bgcolor="#f4f4f4">需方</td>
			                   <td align="left"><input name="thebuyer" type="text" class="input_text validate[maxSize[50]]" id="thebuyer"></td>
			                   <td width="9%" align="center" bgcolor="#f4f4f4">保障机构</td>
			                   <td align="left"><input name="guaranteesetup" type="text" class="input_text validate[maxSize[50]]" id="guaranteesetup"></td>
			                   <td width="9%" align="center" bgcolor="#f4f4f4">开发方</td>
			                   <td align="left"><input name="developingparty" type="text" class="input_text validate[maxSize[50]]" id="developingparty"></td>
			                 </tr>
			                 <tr>
			                   <td width="9%" height="50" align="center" bgcolor="#f4f4f4">测试方</td>
			                   <td align="left"><input name="testparty" type="text" id="testparty" class="input_text validate[maxSize[50]]" ></td>
			                   <td align="center" bgcolor="#f4f4f4">项目信息复用</td>
			                   <td>
			                   		<div class="xmugonj_t_x" style="display:inline-block; width:88%; padding-left:3px;">    <!-- 调整显示距离  -->
			                         	<input type="radio" name="isorreuse" value="0" checked="checked">可复用
			                         	<input type="radio" name="isorreuse" value="1" style="margin-left:10%">不可复用
		                       		</div>
		                       		<i>*</i>
		                       </td>
			                   <td bgcolor="#f4f4f4">&nbsp;</td>
			                   <td>&nbsp;</td>
			                 </tr>
			             </table>
		           </div>
		           <div class="xmugonj_bz xmugonj_bz2 xmugonj_bz_pl">
		           	   <dl>
		               	   <dt style="display:inline-block; width:112px; text-align:justify; text-justify:distribute-all-lines; text-align-last:justify; ">项目模板类型</dt><dt>：</dt>
		                   <dd style="position:relative;">
		                   	<select class="xmugonj_select validate[required,funcCall[checkSelectDocumenttemplate]]" name="documenttemplate" id="documenttemplate" onchange="getTemplateDocumentList();">
		                    	<option value="choice">请选择</option>  
		                    </select>
		                    <span style="color: red; position:absolute; right:-15px; top:2px;">*</span> 
		                   </dd>
		                   <dd>
		                   		<shiro:hasPermission name="projectTemplateTypeController:showAllProjectTemplate">
							        <a href="javascript:;" onclick="projectDocumentTemplateManage();">项目文档模板管理</a>
							    </shiro:hasPermission>
		                   </dd>
		               </dl>
		               <dl >
		               	   <dt>项目文档追踪设置：</dt>   
		                   <dd>
		                   		<nobr><span id="demandName"></span></nobr>
		                   </dd>
		               </dl> 
		              		              
		               <div class="clear"></div>
		           </div>
		           <input name="id" id="id" type="hidden" value=""/>
		           <input name="applicationscope" id="applicationscope" type="hidden"/>
		           <input name="traceset" id="traceset" type="hidden"/>
		           <input name="copyProjectId" id="copyProjectId" type="hidden" value="" />
	          </form>
	          <div class="permission_an xmugonj_bc ma">
	          		<shiro:hasPermission name="project:saveProjectBaseinfo">
				        <a href="javascript:;" id="save" class="per_baocun" onclick="check();">保 存</a>
				    </shiro:hasPermission>
	          		
	          </div>
      </div>
      
	<div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>
</body>
</html>
