<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>待办事项</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>

<script type="text/javascript">

/* 让js支持indexof方法 */
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

var handMessage;
$(function (){
	handMessage = $("#handMessage").bootstrapTable({
		url : '${_baseUrl}/index/getHandMessageList',
		pagination: true,
		pageList: [5, 10, 20, 50,100],
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{
            field: 'messageId',
            title: 'messageId',
            visible:false,
            width: 5
        },{
            field: 'messageContent',
            title: '待办事项内容',
            width: 500,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"closeAndSkip('"+row.messageContent+"','"+row.projectId+"','"+row.parentModelName+"','"+row.messageUrl+"','"+row.messageId+"')\">"+value+"</a>";
            }
        },{
            field: 'createTime',
            title: '发送时间',
            width: 150
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
})

/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	handMessage.bootstrapTable('refresh');
}

/* 角色详细信息 */
function showDetail(roleId){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'详细信息',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 950
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/role/showDetail?roleId="+roleId);
}
function closeAndSkip(messageContent,projectId,parentModelName,messageUrl,messageId){
	if(messageContent.indexOf("项目") > 0 && messageContent.indexOf("构建") > 0){
		$.ajax({ 
			url:'${_baseUrl}/project/selectProjectStatusByProjectId?projectId='+projectId, 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: true,
			success: function(data){
				if(data.projectstatus != "1"){
					var url = "/KD/documentList/showProjectAndDocument?projectId="+projectId+"&id="+data.id+"&source=index";
					parent.closeAndSkip(parentModelName,url,messageId);
				}else{
					parent.closeAndSkip(parentModelName,messageUrl,messageId);
				}
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	}else if(parentModelName == "变更分析" && messageUrl.indexOf("/ci/showChangeInfluence?projectId=") >=0){
		$.ajax({
	        type: "post",
	        dataType: "text",
	        url: '${_baseUrl}/ca/checkChengStatus?messageId='+messageId,
	        success: function (data) {
	        	if("1" == data){
	        		layer.msg("本轮变更已结束",{shift:5,time:1500},function(){
	        			refreshTable();
					});
	        	}else if("0" == data){
	        		parent.closeAndSkip(parentModelName,messageUrl,messageId);
	        	}else{
	        		layer.msg(data,{shift:5,time:1500},function(){
	        			refreshTable();
					});
	        	}
        	}
        });
	}else{
		parent.closeAndSkip(parentModelName,messageUrl,messageId);
	}
}
</script>
</head>
<body>
  <table id="handMessage" class="tab-w-01 tab-w-auto"></table>         
     
</body>
</html>