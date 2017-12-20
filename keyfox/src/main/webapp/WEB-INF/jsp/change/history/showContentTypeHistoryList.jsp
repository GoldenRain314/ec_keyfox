<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>勘误错误历史记录</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var contentTypeList;
$(function (){
	
	contentTypeList = $("#contentTypeList").bootstrapTable({
		url : '${_baseUrl}/ccc/getReplacePageList',
		pagination: true,
		pageList: [5,10,20,50,],
  		queryParams: queryParams,
  		clickToSelect:false,
        columns: [{
            title: '序号',
            width: 5,
            formatter: function(value, row, index){
            	return index+1;
            }
        }, {
            field: 'cId',
            title: 'cId',
            visible:false,
            width: 5
        },{
            field: 'oldContent',
            title: '替换前内容',
            width: 100
        },{
            field: 'newContent',
            title: '替换后内容',
            width: 100
        },{
            field: 'documentNames',
            title: '替换文档',
            width: 100
        },{
            field: 'createTime',
            title: '操作时间',
            width: 130
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

function refreshTable(){
	contentTypeList.bootstrapTable('refresh');
}



</script>
<body>
    <div class="document_main">
            <div class="tablebox2 wdang_s bgenglist">
                <table id="contentTypeList" width="100%" border="0" cellspacing="0" cellpadding="0">
            </table>
      </div>
</div>
</body>
</html>