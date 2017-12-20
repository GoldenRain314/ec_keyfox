<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>需求追踪模板列表</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var demandList;
$(function (){
	
	var message = "${message}";
	if(message != ""){
		layer.msg(message);
	}
	
	demandList = $("#demandList").bootstrapTable({
		url : '${_baseUrl}/demand/getDemandTraceList',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,      /* 需求追踪页面删除复选框  */
        columns: [/* {         
        	 field: 'checked',
             checkbox: true	
        }, */ {
            field: 'demandId',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'demandName',
            title: '需求追踪模板名称',
            width: 150,
            formatter : function(value, row, index) {
            	var str="";
            	str +="<a href='${_baseUrl}/demand/showAddDemandTrace?damendId="+row.demandId+"&readFlag=true&isRead=false' title='"+value+"' class=\"titlea_mds\">"+value+"</a>";
				return str;
            }
        },{
            field: 'source',
            title: '来源',
            width: 100
        },{
            title: '操作',
            width: 100,
            formatter: function(value, row, index){
            	return "<a href='${_baseUrl}/demand/showAddDemandTrace?damendId="+row.demandId+"&readFlag=true&isRead=true'>查看</a>　　<a href='javascript:void(0)' onclick=\"deleteDemand('"+row.demandId+"')\">删除</a>";
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
})





/**
 * 	删除模板
 */
function deleteDemand(demandId){
	var allTableData = $("#demandList").bootstrapTable('getData');//获取表格的所有内容行
	for(var i=0;i<allTableData.length;i++){
		if(demandId == allTableData[i].demandId){
			if("初始化" == allTableData[i].source){
				if("sysadmin" != "${userId}"){
					layer.msg("无权限操作初始化数据");
					return false;
				}
			}
		}
	}
	
	$.ajax({
		url : "${_baseUrl}/demand/deleteDemand",
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {demandId : demandId},
		success : function(json) {
			layer.msg(json.message);
			if("0" != json.code){
				refreshTable();
			}
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
}




function refreshTable(){
	demandList.bootstrapTable('refresh');
}

/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

</script>
<body>
     <div class="zzsetup_popup">
	<div class="zzsetup_top mtmb20">
		<div class="fl popup_tit">选择文档模板分类</div>
        <div class="fr glqxian_btn zzsetup_btn">
        	<shiro:hasPermission name="demand:showAddDemandTrace">
		       <a href="${_baseUrl }/demand/showAddDemandTrace?isRead=false" class="glqxian_btn1" >新增需求追踪</a>   <!-- 传参  -->
		    </shiro:hasPermission>
        </div>
    	<div class="clear"></div>
    </div>

    <div class="chapter_tc_c zzsetup_c">
    	<table id="demandList" width="98%" border="0" cellspacing="0" cellpadding="0">
        </table>
    </div>
	</div>
<div id="popDiv" style="display: none;">
	<iframe id="popIframe" border="0" frameborder="0"></iframe>
</div>
</body>
</html>