<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>需求追踪关系</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />

<script type="text/javascript">
var roleList;
$(function (){
	roleList = $("#roleList").bootstrapTable({
		url : '${_baseUrl}/fixed/getDemandList',
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
            width: 100 ,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"showDetail('"+row.id+"')\">"+value+"</a>";
            }
        },{
            field: 'sectionName',
            title: '章节名称',
            width: 100
        },{
            field: 'sectionNumber',
            title: '章节号',
            width: 100
        },{
            field: 'traceDocumentName',
            title: '被追踪文档名称',
            width: 100
        },{
            field: 'traceSectionName',
            title: '被追踪文档名称',
            width: 100
        },{
            field: 'traceSectionNumber',
            title: '被追踪文档章节号',
            width: 100
        },{
            field: 'showTraceSectionId',
            title: '展示文档追踪关系的章节名称',
            width: 100
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    documentNameForSerach:$("#documentNameForSerach").val()
	   }
	}
	
	/* 添加 */
	$("#add").click(function (){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'添加追踪关系',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 720
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/fixed/addDemandFixed");
	});
	
	/* 删除*/
	$("#del").click(function (){
		var selected = roleList.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要批量删除的数据");
			return false;
		}
		var roleIds = [];
		for(i in selected){
			roleIds.push(selected[i].id);
		}
		
		$.ajax({
			url : "${_baseUrl}/fixed/delFixed",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {ids : roleIds.join(',')},
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
	roleList.bootstrapTable('refresh');
}

/* 角色详细信息 */
function showDetail(id){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'详细信息',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 720
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/fixed/addDemandFixed?id="+id);
}

</script>
</head>
<body>
<div class="main_cont">
       	<div class="main_c">
               <div class="current_cont">
                   <div class="fl current_c">
                        当前位置 ： <a href="javascript:;">组织资产</a>  >  <a href="javascript:;">需求追踪关系</a>  >  所有追踪关系
                   </div>            
                   <div class="fr current_j">
                       <ul>
                           <li><a href="javascript:;" class="current_1" id="add">添加</a></li>
                           <li><a href="javascript:;" class="current_2" id="del">删除</a></li>
                           <div class="clear"></div>
                       </ul>
                   </div>
                   <div class="fr current_s">
                       <div class="fl current_s_i"><input name="" id="documentNameForSerach" type="text" class="input_text1" value="搜索您想寻找的..." onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
                       <div class="fl current_s_a"><input name="" onclick="refreshTable()" type="button" value="高级搜索" class="input_btn1"></div>
                       <div class="clear"></div>
                   </div>
                   <div class="clear"></div>
                           
               </div>
               
               <div class="personnel_cont">
		        <!--tab-w-01----->
		        <table id="roleList" class="tab-w-01 tab-w-auto"></table>         
               </div>
           
    	 </div>
     </div>
     
     <div id="popDiv" style="display: none;">
		<iframe id="popIframe"></iframe>
	</div>
</body>
</html>