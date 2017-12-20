<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>待阅事项</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />

<script type="text/javascript">
var readMessage;
$(function (){
	readMessage = $("#readMessage").bootstrapTable({
		url : '${_baseUrl}/index/getReadMessageList',
		pagination: true,
		pageList: [5, 10, 20, 50,100,500],
  		queryParams: queryParams,
        columns: [{
			field: 'checked',
			checkbox: true,
			formatter : function(value, row, index) {
				if(row.messageStatus == "1"){
					return {
						disabled: true
	                };
				}
			}
	     },{
            field: 'messageId',
            title: 'messageId',
            visible:false,
            width: 5
        },{
            field: 'messageContent',
            title: '待阅事项内容',
            width: 400,
            formatter : function(value, row, index) {
            	if(row.messageStatus == "1"){
            		return "<span style='color:#C0C0C0'>"+value+"<span>";
            	}else{
            		return value;
            	}
            }
        },{
            field: 'createTime',
            title: '发送时间',
            width: 150,
            formatter : function(value, row, index) {
            	if(row.messageStatus == "1"){
            		return "<span style='color:#C0C0C0'>"+value+"<span>";
            	}else{
            		return value;
            	}
            }
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order
	   }
	}
	
	/* 标记为已读 */
	$("#updateMessageStatus").click(function (){
		var selected = readMessage.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要批量操作的数据");
			return false;
		}
		var messageIds = [];
		for(i=0;i<selected.length;i++){
			messageIds.push(selected[i].messageId);
		}
		
		$.ajax({
			url : "${_baseUrl}/index/updateMessageStatus",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {messageId : messageIds.join(',')},
			success : function(json) {
				layer.msg(json.message);
				refreshTable();
				parent.skipModule("首页","");
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	});
	
	
})

/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	readMessage.bootstrapTable('refresh');
}


</script>
</head>
<body>
	<div class="glqxian_btn xmugonj_btn2 mtmb2010">
     	<a href="javascript:;" class="fr glqxian_btn2 " id="updateMessageStatus">标记为已阅</a>
  	</div>
  <table id="readMessage" class="tab-w-01 tab-w-auto"></table>         
     
</body>
</html>