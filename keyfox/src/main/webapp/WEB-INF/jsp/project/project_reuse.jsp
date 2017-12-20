<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>可复用项目</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var reuseProjectList;
var id = "${id}"
$(function (){
	reuseProjectList = $("#reuseProjectList").bootstrapTable({
		url : '${_baseUrl}/project/showReuseProject?projectId=${projectId}',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		singleSelect: true,//仅允许单选
  		columns: [{
       	 field: 'checked',
         checkbox: true
       },{
           field: 'id',
           title: 'id',
           visible:false,
           width: 5
       },{
            field: 'projectname',
            title: '项目名称',
            width: 90,
            formatter:function(value,row,index){
            	return "<span title="+'\"'+value+'\"'+">"+value+"</span>";
            }
        },{
            field: 'applicationscope',
            title: '适用范围',
            width: 50,
            formatter:function(value,row,index){
            	return "<span title="+'\"'+value+'\"'+">"+value+"</span>";
            }
        },{
            field: 'documentCount',
            title: '文档总数',
            width: 50,
            formatter:function(value,row,index){
            	return "<span title="+'\"'+value+'\"'+">"+value+"</span>";
            }
        },{
            field: 'projectManagerName',
            title: '项目文档负责人',
            width: 50,
            formatter:function(value,row,index){
            	return "<span title="+'\"'+value+'\"'+">"+value+"</span>";
            }
        },{
            field: 'documenttemplateName',
            title: '项目文档模板名称',
            width: 90,
            formatter:function(value,row,index){
            	return "<span title="+'\"'+value+'\"'+">"+value+"</span>";
            	
            }
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    projectname:$("#projectName").val()
		    
	   }
	}
})
function loadProject(){
	var objects =  $("#reuseProjectList").bootstrapTable('getSelections');
	if(objects.length != 1){
		layer.msg("请选择需要复用的项目！");    /* 提示信息改为“请选择需要复用的项目！ */
		return;
	}
	var obj = JSON.stringify(objects);
	var jsonObj  = eval("("+obj+")");
	var enterprise = $("#enterprise", window.parent.document);
	var projectstarttime = $("#projectstarttime", window.parent.document);
	var projectendtime = $("#projectendtime", window.parent.document);
	var theuser = $("#theuser", window.parent.document);
	var thebuyer = $("#thebuyer", window.parent.document);
	var guaranteesetup = $("#guaranteesetup", window.parent.document);
	var developingparty = $("#developingparty", window.parent.document);
	var testparty = $("#testparty", window.parent.document);
	var applicationscope = $("#applicationscope", window.parent.document);
	var demandName = $("#demandName", window.parent.document);
	var traceset = $("#traceset", window.parent.document);
	var copyProjectId = $("#copyProjectId", window.parent.document);
	var reuseProject = $("#reuseProject", window.parent.document);
	//var documentstandards = $("#documentstandards option",window.parent.document).map(function(){return $(this).val();}).get();
	$("#documentstandard option",window.parent.document).each(function () {
		 var txt = $(this).text();
		 if(txt == jsonObj[0].documentstandard){
			 $(this).prop("selected","selected");
		 }
	});
	$("#softwaredevelopmodel option",window.parent.document).each(function () {
		 var txt = $(this).text();
		 if(txt == jsonObj[0].softwaremodel){
			 $(this).prop("selected","selected");
		 }
	});
	$("#documenttype option",window.parent.document).each(function () {
		 var txt = $(this).text();
		 if(txt == jsonObj[0].documenttype){
			 $(this).prop("selected","selected");
		 }
	});
	$("#secretsinvolvedlevel option",window.parent.document).each(function () {
		 var txt = $(this).text();
		 if(txt == jsonObj[0].projectclassification){
			 $(this).prop("selected","selected");
		 }
	});
	$("#softwarekeylevel option",window.parent.document).each(function () {
		 var txt = $(this).text();
		 if(txt == jsonObj[0].softwarecriticallevels){
			 $(this).prop("selected","selected");
		 }
	});
	$("#softwaresize option",window.parent.document).each(function () {
		 var txt = $(this).text();
		 if(txt == jsonObj[0].softwarescale){
			 $(this).prop("selected","selected");
		 }
	});
	$("#documenttemplate option",window.parent.document).each(function () {
		 var txt = $(this).val();
		 if(txt == jsonObj[0].documenttemplate){
			 $(this).prop("selected","selected");
		 }
	});
	/* 复用的项目 项目模板不可修改 */
	$("#documenttemplate",window.parent.document).attr("disabled",true);
	if(jsonObj[0].documenttemplateName == "GJB438B项目文档模板"){
		/* 复用的项目文档编制标准为GJB438B的不可修改 */
		$("#documentstandard",window.parent.document).attr("disabled",true);
	}
	
	$(enterprise).val(jsonObj[0].enterprise);
	$(projectstarttime).val(jsonObj[0].projectstarttime);
	$(projectendtime).val(jsonObj[0].projectendtime);
	$(theuser).val(jsonObj[0].theuser);
	$(thebuyer).val(jsonObj[0].thebuyer);
	$(guaranteesetup).val(jsonObj[0].guaranteesetup);
	$(developingparty).val(jsonObj[0].developingparty);
	$(testparty).val(jsonObj[0].testparty);
	$(applicationscope).val(jsonObj[0].applicationscope);
	$(demandName).html(jsonObj[0].demandName);
	$(traceset).val(jsonObj[0].traceset);
	$(copyProjectId).val(jsonObj[0].projectid);
	$(reuseProject).html("<a href='javascript:;' class='glqxian_btn1' onclick='cancelReuseProject();' title=''“取消复用”取消项目复用所做的操作'>取消复用</a>");
	parent.closeWin();
}


function refreshTable(){
	reuseProjectList.bootstrapTable('refresh',{url:'${_baseUrl}/project/searchReuseProject?projectId=${projectId}&number='+Math.random()});
}

$(document).keyup(function(event){
	  if(event.keyCode == 13){
		  refreshTable();
	  }
});

</script>
</head>
<body>
    	<div class="wdang_main">
            <div class="xmugonj_cont ma wdang_c0803" style="display:block;">
                <div class="xmugonj_ta_j widthauto">
                	<div style="margin-bottom:10px;">
	                 	<strong>项目复用操作说明：</strong><span style="color:#666;">“项目复用”操作用于同类型或具有相似特征的项目数据的复用，可继承已选中的复用项目的基本信息、项目模板类型以及文档列表中文档最新版本内容。执行“项目复用”操作后将不可修改项目模板类型。</span>   <!-- 添加项目复用解释说明  -->
	                 </div>
	                 
                	 <div class="fl xmulist2_ss">
	                	<p><input name="" id="projectName" type="text" onkeypress="" class="input_text xmulist2_input" value="请输入项目名称..."  onFocus="if(this.value=='请输入项目名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入项目名称...';}"></p>
	                    <span><input name="" value="搜索" type="button" onclick="refreshTable();" class="dyi_btna dyi_btnabox dyi_btna1"></span>
	                    
	                 </div>
	                 <div style="clear: both;"></div>
	                 
                	 <div class="xmugonj_ta_j widthauto" style="padding-top: 10px;">
				    	<table id="reuseProjectList" class="tab-w-01 tab-w-auto"></table>   
				    </div>
					<div class="permission_an xmugonj_bc ma">
						<shiro:hasPermission name="project:reuseProject">
					        <a href="javascript:;" class="per_baocun" onclick="loadProject();">确定</a>
					    </shiro:hasPermission>
                        <a href="javascript:;" class="per_baocun" onclick="parent.closeWin();">关 闭</a>
                    </div>
              </div>
         
            </div>
        </div>
	<div class="clear"></div>
</body>
<style>
	table { table-layout:fixed;}
	tbody td { overflow:hidden; text-overflow:ellipsis; white-space:nowrap; width:50px;}
</style>

</html>
