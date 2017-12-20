<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>438b固定文档固定前项文档</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />

<script type="text/javascript">
var changeFixedList;
$(function (){
	changeFixedList = $("#changeFixedList").bootstrapTable({
		url : '${_baseUrl}/cfc/getChangeList',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{
             checkbox: true
         }, {
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'documentName',
            title: '文档名称',
            width: 200 ,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"showDetail('"+row.id+"')\">"+value+"</a>";
            }
        },{
            field: 'traceDocumentName',
            title: '前项文档名称',
            width: 200
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    documentName:$("#documentName").val()
	   }
	}
	
	/* 添加 */
	$("#add").click(function (){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'添加前项文档',
			autoOpen: true,
			modal: true,	
			height: 400,
			width: 600
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/cfc/showAddTraceDocument");
	});
	
	/* 删除*/
	$("#del").click(function (){
		var selected = changeFixedList.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要批量删除的数据");
			return false;
		}
		var ids = [];
		for(i in selected){
			ids.push(selected[i].id);
		}
		
		$.ajax({
			url : "${_baseUrl}/cfc/delFixed",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {ids : ids.join(',')},
			success : function(json) {
				layer.msg(json.message);
				refreshTable();
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
	changeFixedList.bootstrapTable('refresh');
}

/* 查看详细信息 */
function showDetail(id){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'详细信息',
		autoOpen: true,
		modal: true,	
		height: 400,
		width: 600
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/cfc/showAddTraceDocument?id="+id);
}

</script>
</head>
<body>
<div class="main_cont">
       	<div class="main_c">
               <div class="current_cont">
                   <div class="fl current_c">
                        当前位置 ： <a href="javascript:;">组织资产</a>  >  <a href="javascript:;">438B前项文档</a>  >  所有列表
                   </div>            
                   <div class="fr current_j">
                       <ul>
                           <li><a href="javascript:;" class="current_1" id="add">添加</a></li>
                           <li><a href="javascript:;" class="current_2" id="del">删除</a></li>
                           <div class="clear"></div>
                       </ul>
                   </div>
                   <div class="fr current_s">
                       <div class="fl current_s_i"><input name="" id="documentName" type="text" class="input_text1" value="搜索您想寻找的..." onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
                       <div class="fl current_s_a"><input name="" type="button" onclick="refreshTable()" value="高级搜索" class="input_btn1"></div>
                       <div class="clear"></div>
                   </div>
                   <div class="clear"></div>
                           
               </div>
               
               <div class="personnel_cont">
		        <!--tab-w-01----->
		        <table id="changeFixedList" class="tab-w-01 tab-w-auto"></table>         
               </div>
    	 </div>
     </div>
     
<div id="popDiv" style="display: none;">
	<iframe id="popIframe"></iframe>
</div>
</body>
</html>