<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>变更历史记录</title>
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
		url : '${_baseUrl}/chc/getHistoryList',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		
        columns: [{
        	 field: 'checked',
             checkbox: true, 
             visible:false   /* 取消复选框  */
         }, {
            title: '序号',
            width: 30,
            formatter: function(value, row, index){
            	return index+1;
            }
        }, {
            field: 'changeDocumentName',
            title: '变更申请的工作产品',
            width: 150
        },{
            field: 'changeDate',
            title: '变更申请时间',
            width: 100
        },{
            field: 'changePersionName',
            title: '申请人',
            width: 80
        },{
            field: 'changedDocumentCount',
            title: '变更文档数量',
            width: 70,
            formatter: function(value, row, index){
            	if(value > 0){
	            	return "<a href='${_baseUrl}/chc/showChangeHistoryDetails?projectId=${projectId}&changeId="+row.changeId+"'>"+value+"</a>";
            	}else{
            		return value;
            	}
            }
        },{
            field: '',
            title: '变更申请单',
            width: 60,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"showChangeRequestNoteDetails('"+row.changeId+"')\">查看</a>";
            }
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    projectId:"${projectId}"
	   }
	}
})

/* 查看变更申请单 */
function showChangeRequestNoteDetails(chengeId){
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
	$("#popIframe").attr("src","${_baseUrl}/ci/showChangeRequestNoteDetails?projectId=${projectId}&changeId="+chengeId);
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
	$("#popIframe").attr("src","${_baseUrl}/ccc/showErrataError?projectId=${projectId}");
}

</script>
<body>
    <div class="document_main">
    	<div class="page_tit_warp mtmb20"><div class="page_tit"><span>文档变更记录列表</span></div></div>
    	<div class="document_maina">
    		<div class="current_wz mtmb20"><strong>项目目录：</strong>${localhost }
    			
    			<div class="fr glqxian_btn wendmban_btn">
	        		<a href="javascript:history.go(-1)" class="fr glqxian_btn1">返回</a>
	        		<a href="javascript:void(0)" class="fr glqxian_btn1 mr18" onclick="errataError()">勘误错误修改记录</a>
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
		<iframe id="popIframe" border="0" frameborder="0"></iframe>
	</div>
</body>
</html>