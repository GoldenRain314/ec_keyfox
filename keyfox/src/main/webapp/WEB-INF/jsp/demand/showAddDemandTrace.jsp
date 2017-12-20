<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>新增需求追踪</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var projectTemplateListNoSet;
var projectTemplateList;
var templateListJson = '${templateListJson}';
var templateListJsonObject = eval('('+templateListJson+')');
//是否有新增需求设置的权限
var addTrace="${addTrace}";
var projectTemplateSetId;

//需求追踪关系ID
var demandId = "${demandInfo.demandId}";
$(function (){
	
	$("#save").mouseleave(function(){  /* 修改火狐及ie浏览器按钮点击后效果样式  */
		$("#save").css("color","#fff");
	})
	
	$("#goback").mouseleave(function(){
		$("#goback").css("color","#fff");
	})
	
	//数据验证
	$("#demandNameForm").validationEngine({
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
	//设置项目文档模板
	if(demandId != ""){
		$("#projectTemplate").val("${demandInfo.projectTemplateId}");
		$("#projectTemplateListNoSetDiv").hide();
	}else{
		$("#projectTemplateListDiv").hide();
	}
	
	//刷新数据
	initNoSet();
	if("初始化" == "${demandInfo.source}"){
		if("sysadmin" != "${userId}"){
			$("#projectTemplateListDiv").hide();
			$("#projectTemplateListNoSetDiv").show();
		}
	}

	//是否有新增需求设置的权限
	if(addTrace == "no"){
		$("#projectTemplateListDiv").hide();
		$("#projectTemplateListNoSetDiv").show();
	}
	
	setValue($("#projectTemplate").val());
		

	//保存模板信息
	$("#save").click(function (){
		
		if($("#demandNameForm").validationEngine('validate')){     /* 重新设置validate插件显示样式   */
			var projectTemplateId = $("#projectTemplate").val();
			var demandName = $("#demandName").val();
			/* if(demandName == ""){
				layer.msg("请输入模版名称");
				return false;
			}  */
			
			$.ajax({
				url : "${_baseUrl}/demand/judgeName",
				type : "post",
				dataType : "json",
				async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
		  		data : {"trackModelName":$("#demandName").val(),"demandId":demandId},
				success : function(json) {
					if("1" == json.code){
						layer.msg("模版名称已存在");
						return false;
					}else{
						$.ajax({
							url : "${_baseUrl}/demand/insertDemandModel",
							type : "post",
							dataType : "json",
							async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
					  		data : {projectTemplateId : projectTemplateId,demandName:demandName,demandId:demandId},
							success : function(json) {
								layer.msg(json.message);
								if("0" == json.code){
									demandId = json.data;
									projectTemplateSetId = projectTemplateId;
									refreshTable();
								}
								
							},
							error:function(data){
								layer.msg("网络忙，请稍后重试");
							}
						});
					}
				},
				error:function(data){
					layer.msg("网络忙，请稍后重试");
					return false;
				}
			});	
		}else{
			/* layer.msg("最多50个字符！"); */
			return false;
		} 
	});
	
	/*内容复用*/
	$("#contentReuse").click(function (){
		window.location.href = "${_baseUrl}/demand/showContentReuse?projectTemplate="+$("#projectTemplate").val()+"";
	});
	
});


		
//设置文档的追踪关系
function setDemandModelTrace(id){
	if(demandId == null){
		layer.msg("请选保存模板名称");
		return false;
	}else{
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'选择前项文档',
			autoOpen: true,
			modal: true,	
			height: 380,
			width: 685
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/demand/setDemandModelTrace?demandId="+demandId+"&documentId="+id);
	}
}

/* 修改模板联动修改 */
function changeTableList(){
	//刷新下面的表格
	refreshTable();
	
	setValue($("#projectTemplate").val());
}

/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function setValue(id){
	for(var i in templateListJsonObject){
		if(id == templateListJsonObject[i].id){
			$("#applicationScope").html(templateListJsonObject[i].applicationScope);
			$("#styleOutTemplate").html(templateListJsonObject[i].styleOutTemplateName);
			$("#styleSetTemplate").html(templateListJsonObject[i].styleSetTemplateName);
		}
	}
}

function refreshTable(){
	if(demandId == null || demandId == ""){
		projectTemplateListNoSet.bootstrapTable('refresh');
		projectTemplateList.bootstrapTable('refresh');
		$("#projectTemplateListDiv").hide();
		$("#projectTemplateListNoSetDiv").show();
	}else{
		projectTemplateListNoSet.bootstrapTable('refresh');
		projectTemplateList.bootstrapTable('refresh');
		$("#projectTemplateListDiv").show();
		$("#projectTemplateListNoSetDiv").hide();
		var projectTemId = $("#projectTemplate").val();
		
		if("${demandInfo.projectTemplateId}" == projectTemId || projectTemplateSetId == projectTemId){
			$("#projectTemplateListDiv").show();
			$("#projectTemplateListNoSetDiv").hide();
		}else{
			$("#projectTemplateListDiv").hide();
			$("#projectTemplateListNoSetDiv").show();
		}
	}
	
	
	if("初始化" == "${demandInfo.source}"){
		if("sysadmin" != "${userId}"){
			$("#projectTemplateListDiv").hide();
			$("#projectTemplateListNoSetDiv").show();
		}
	}
	
	if(addTrace == 'no'){
		projectTemplateListNoSet.bootstrapTable('refresh');
		projectTemplateList.bootstrapTable('refresh');
		$("#projectTemplateListDiv").hide();
		$("#projectTemplateListNoSetDiv").show();
	}
}


function initNoSet(){
	projectTemplateList = $("#projectTemplateList").bootstrapTable({
		url : '${_baseUrl}/demand/getAddDemandTraceList?random='+Math.random(),
		pagination: true,
		pageList: [5, 10, 20, 50],
		clickToSelect: false,
  		queryParams: queryParams,
  		rowStyle: rowStyle,
        columns: [{
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'templateStatus',
            title: 'templateStatus',
            visible:false,
            width: 5
        },{
            field: 'documentTemplateName',
            title: '文档模板名称',
            width: 20
        },{
            field: 'documentType',
            title: '文档类型',
            width: 20
        },{
            field: 'applicationScope',
            title: '适用范围',
            width: 20
        },{
            field: 'source',
            title: '文档模板来源',
            width: 20,
            formatter: function(value, row, index){
            	if(value=="初始化"){
            		return "标准文档模板";
            	}else{
            		if(value=="自定义"){
            			return "自定义文档模板";
            		}else{
            			return value;
            		}
            	}
            }
        },{
            field: 'agoDocumentNames',
            title: '前置关联文档名称',    /* 修改显示标题 为：前置关联文档名称   */ 
            width: 150,
           	formatter: function(value, row, index){
        	   	if(value == "" || value == null){
        	   		return "-";
        	   	}
	           	if(value.length > 1){
	           		return value;
	           	}else{
	           		return "-";
	           	} 
            } 
        } ,{
            title: '操作',
            width: 20,
            formatter: function(value, row, index){
            	var isRead = ${isRead};
            	if(row.templateStatus == 0 || isRead == true){  /* 当为查看进入页面时仅为浏览不显示设置按钮   */
            		return "-"
            	}else{
            		return "<a href='javascript:void(0)' onclick=\"setDemandModelTrace('"+row.id+"')\">设置</a>";
            	}
            	
            }
        }]
    });
	
	projectTemplateListNoSet = $("#projectTemplateListNoSet").bootstrapTable({
		url : '${_baseUrl}/demand/getAddDemandTraceList?random='+Math.random(),
		pagination: true,
		pageList: [5, 10, 20, 50],
		clickToSelect: false,
  		queryParams: queryParams,
        columns: [{
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'documentTemplateName',
            title: '文档模板名称',
            width: 150
        },{
            field: 'documentType',
            title: '文档类型',
            width: 100
        },{
            field: 'applicationScope',
            title: '适用范围',
            width: 100
        },{
            field: 'source',
            title: '文档模板来源',
            width: 100,
            formatter: function(value, row, index){
            	if(value=="初始化"){
            		return "标准文档模板";
            	}else{
            		if(value=="自定义"){
            			return "自定义文档模板";
            		}else{
            			return value;
            		}
            	}
            }
        },{
            field: 'agoDocumentNames',
            title: '前置关联文档名称',      /* 前置文档关联名称修改为’前置管理文档名称‘ */   /* 修改为前置关联文档名称 */
            width: 100,
            formatter: function(value, row, index){
            	if(value == "" || value == null){
        	   		return "-";
        	   	}
            	if(value.length > 1){
            		if(value.length == 0)
            			return "-";
            		
            		var split = value.split(",");
            		var name = "";
            		for(var i=0;i<split.length;i++){
            			name = name  + split[i]+"<br>"
            		}
            		return name;
            	}else{
            		return "-";
            	} 
            }
        }]
    });
}
function rowStyle(row, index) {
	if(row.templateStatus == 0){
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
	    id:$("#projectTemplate").val(),
	    demandId:demandId
   }
}


function checkSelect(){
	var demandName = $("#demandName").val();
	if(demandName == ""){
		return "请输入模板名称";
	}else{
		return true;
	}
}

function judgeName(){
	$.ajax({
		url : "${_baseUrl}/demand/judgeName",
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {"trackModelName":$("#demandName").val()},
		success : function(json) {
			if("1" == json.code){
				layer.msg("模版名称已存在");
			}
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
}

</script>
<style>
	.xmugonj_bz2 dl { margin:20px 0;}
	.xmugonj_bz2 dl dt { padding-left:17px;}
	.xmugonj_t_b1 { padding:0;}
	.xmugonj_t_f dl dd { width:auto;}
	.xmugonj_t_f dl dt { display:inline-block; width:113px; text-align:justify; justify:inter-ideograph; text-justify: distribute-all-lines; text-align-last: justify; clear:both;}
	.xmugonj_t_f dl dt span { display:inline-block; width:100%;}
</style>
<body>
<div class="xzxuqiu_popup">
	<div class="zzsetup_top mtmb20">
        <div class="fl popup_tit">新增需求追踪</div>
         <!-- <div class="permission_an mubanclass_an ma mt30 mtmb20" style="margin-left: 85%">
	       <a if="goback" href="javascript:history.go(-1);" class="per_gbi">返回</a>
        </div>
    	<div class="clear"></div> -->
    </div>
	
 <form id="demandNameForm">
    <div class="chapter_tc_c xzxuqiu_tc_c">
    	<!-- <div class="fr glqxian_btn wendmban_btn">		
			<a href="javascript:;" class="glqxian_btn1  fl" id="contentReuse">内容复用</a>
        </div> -->
    	<div class="xmugonj_bz xmugonj_bz2" style="margin-bottom:20px;">
            <dl>
                <dt>需求追踪模板名称 &nbsp;:&nbsp;</dt>                
                <dd style="width:200px;">
                	<input type="text"  value="${demandInfo.demandName}"  name="demandName" onblur="judgeName();" id="demandName" class="validate[required,maxSize[50]] jbxinxi_input" style="width:197px; height:27px; padding-left:3px; margin-left:5px; color:##7b7b7b; line-height:27px; border:1px solid #dcdcdc; color:#7b7b7b;" 
                	<c:if test="${!empty demandInfo  }">disabled="disabled"</c:if>
                	>
                </dd>
            </dl>
            <br />
            <dl>
               <dt>项目模板类型名称 &nbsp;:&nbsp;</dt>
               <dd style="width:200px;">
                   <select class="xmugonj_select" id="projectTemplate" 
                    <c:if test="${!empty demandInfo  }">onmousedown="return false;" style="width:200px; padding:1px 0; margin-left:5px;background-color: #dcdcdc;"</c:if>
                    <c:if test="${empty demandInfo  }">onchange="changeTableList()" style="width:200px; padding:1px 0; margin-left:5px;"</c:if> 
                        >
                      <c:forEach items="${templateList }" var="tem">
                     	 <option value="${tem.id }">${tem.projectTemplateName }</option>
                      </c:forEach>
                 </select>
               </dd>
              </dl>
              <div class="clear"></div>
        </div>
     <div class="dotted_line">
      	<div class="xmugonj_t_f xmugonj_bz">
      		<dl><dt>适用范围<span></span></dt><dd>&nbsp;:&nbsp;</dd><dd id="applicationScope"></dd></dl>
      		<br/>
      		<dl><dt>样式输出模板<span></span></dt><dd>&nbsp;:&nbsp;</dd><dd id="styleOutTemplate"></dd></dl>
      		<br/>
      		<dl><dt>样式定义模板<span></span></dt><dd>&nbsp;:&nbsp;</dd><dd id="styleSetTemplate"></dd></dl>
      		<br/>
           <!--  <strong class="xmugonj_t_b1">适用范围 </strong>&nbsp;:<span id="applicationScope"></span><br>
            <strong>样式输出模板</strong>&nbsp;:<span id="styleOutTemplate"></span><br><strong>样式定义模板 </strong>&nbsp;:<span id="styleSetTemplate"></span> -->
        </div>
        
        <div id="projectTemplateListDiv">
	    	<table id="projectTemplateList" width="98%" border="0" cellspacing="0" cellpadding="0">
	        </table>
        </div>
           
        <div id="projectTemplateListNoSetDiv">
	        <table id="projectTemplateListNoSet" width="98%" border="0" cellspacing="0" cellpadding="0">
	        </table>
        </div>
        
        </div>
        <div class="permission_an mubanclass_an ma mt30 mtmb20" style="line-height:27px; text-align:center;">   <!-- 查看按钮仅为浏览页面  -->
	       <c:if test="${!isRead}"> <a href="javascript:;" class="per_baocun" id="save">提 交</a></c:if>
	       <a if="goback" href="javascript:history.go(-1);" class="per_gbi">返回</a>
        </div> 
        <div class="clear"></div>
    </div>
   </form>
</div>

<div id="popDiv" style="display: none;">
	<iframe id="popIframe" border="0" frameborder="0"></iframe>
</div>
</body>
</html>