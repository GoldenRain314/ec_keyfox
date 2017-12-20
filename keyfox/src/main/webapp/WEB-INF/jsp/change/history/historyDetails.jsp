<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>变更历史记录-影响域分析结果</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var history;
$(function (){
	history = $("#history").bootstrapTable({
		url : '${_baseUrl}/chc/getHistoryDetailsList',
		pagination: true,
		pageList: [5, 10, 20, 50,100],
  		queryParams: queryParams,
        columns: [{
        	 field: 'checked',
             checkbox: true,
             visible: false
         }, {
            title: '序号',
            width: 30,
            formatter: function(value, row, index){
            	return index+1;
            }
        }, {
            field: 'documentName',
            title: '工作产品',
            width: 150,
            formatter: function(value, row, index){
            	if(row.changeDocumentId == row.documentId){
            		return "<span class='juh_color'>"+value+"</span>";
            	}else{
            		return value;
            	}
            }
        },{
            field: 'newPublishTime',
            title: '变更时间',
            width: 100,
            formatter: function(value, row, index){
            	if(value == null || "" == value){
            		return "";
            	}else{
            		return value;
            	}
            }
        },{
            field: 'documentMangerName',
            title: '变更执行人员',
            width: 80,
            formatter: function(value, row, index){
            	if(row.newPublishTime == null || "" == row.newPublishTime){
            		return "";
            	}else{
	            	return value;
            	}
            }
        },{
            field: 'newVersion',
            title: '变更后文档版本',
            width: 60
        },{
            field: '',
            title: '内容变更单',
            width: 70,
            formatter: function(value, row, index){
            	if(row.newPublishTime == null || "" == row.newPublishTime){
            		return "";
            	}else{
	            	return "<a onclick=\"showContent('"+row.projectId+"','"+row.documentId+"','${changeId}')\">查看</a>";
            	}
            }
        },{
            field: '',
            title: '内容变更对比',
            width: 70,
            formatter: function(value, row, index){
            	if(row.newPublishTime == null || "" == row.newPublishTime){
            		return "";
            	}else{
	            	return "<a onclick=\"showDocumentComparison('"+row.projectId+"','"+row.documentId+"','${changeId}')\">查看</a>";
            	}
            }
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    projectId:"${projectId}",
		    changeId:"${changeId}"
	   }
	}
})

/*查看内容申请单  */
function showContent(projectId,documentId,changeId){
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
	$("#popIframe").attr("src","${_baseUrl}/cdc/showChangeContent?projectId="+projectId+"&documentId="+documentId+"&changeId="+changeId+"&readOnly=true");
}

/* 显示文档内容对比 */
function showDocumentComparison(projectId,documentId,changeId){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'内容变更对比',     /* 更改弹框标题  */
		autoOpen: true,
		modal: true,	
		height: 550,
		width: 850
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/cdc/showDocumentComparison?projectId="+projectId+"&documentId="+documentId+"&changeId="+changeId+"&readOnly=true");
}



</script>
<body>
    <div class="document_main">
    	<div class="page_tit_warp mtmb20"><div class="page_tit"><span>文档变更记录列表</span></div></div>
    	<div class="document_maina">
    		<div class="current_wz mtmb20"><strong>项目目录：</strong>${localhost }
    			<div class="fr glqxian_btn wendmban_btn">
	        		<a href="javascript:history.go(-1)" class="glqxian_btn1">返回</a>
	        	</div>
    		</div>
    	</div>
        <div class="tablebox2 wdang_s bgenglist">
           <table id="history" width="100%" border="0" cellspacing="0" cellpadding="0">
           </table>
  		</div>
    </div>
	<div class="clear"></div>
<div id="popDiv" style="display: none;">
	<iframe id="popIframe"></iframe>
</div>
</body>
</html>