<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>问题列表</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var demandList;
$(function (){
	demandList = $("#demandList").bootstrapTable({
		url : '${_baseUrl}/hq/getList',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
        columns: [{
        	 field: 'checked',
             checkbox: true
         }, {
            field: 'qId',
            title: 'qId',
            visible:false,
            width: 5
        },{
            field: 'qName',
            title: '问题名称',
            width: 300,
            formatter: function(value, row, index){
            	return "<a href='${_baseUrl}/hq/showAdd?menuId=${menuId}&qId="+row.qId+"' >"+value+"</a>";
            }
        },{
            field: 'createTime',
            title: '创建时间',
            width: 130
        }]
    });
	
	/* 删除问题 */
	$("#del").click(function (){
		var selected = demandList.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要批量删除的数据");
			return false;
		}
		var qIds = [];
		for(i in selected){
			qIds.push(selected[i].qId);
		}
		
		$.ajax({
			url : "${_baseUrl}/hq/deleQuestion",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {qIds : qIds.join(',')},
			success : function(json) {
				layer.msg(json.message);
				refreshTable();
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	});
	
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    qName:$("#documentNameForSerach").val()
	   }
	}
})

function refreshTable(){
	demandList.bootstrapTable('refresh');
}
</script>
<body>
<div class="main_cont">
       	<div class="main_c">
               <div class="current_cont">
                   <div class="fl current_c">
                        当前位置 ： <a href="javascript:;">组织资产</a>  >  <a href="javascript:;">问题列表</a>  >  所有数据
                   </div>            
                   <div class="fr current_j">
                       <ul>
                           <li><a href="${_baseUrl}/hq/showAdd?menuId=${menuId}" class="current_1" id="add">添加</a></li>
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
		        <table id="demandList" class="tab-w-01 tab-w-auto"></table>         
               </div>
           
    	 </div>
     </div>
     
     <div id="popDiv" style="display: none;">
		<iframe id="popIframe"></iframe>
	</div>
</body>
</html>