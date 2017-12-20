<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档协同编制</title>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0 minimal-ui"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<style type="text/css">
</style>
<script type="text/javascript">
var userId = "";
var sectionList;

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


$(function(){
	sectionList = $("#sectionList").bootstrapTable({
	url : '${_baseUrl}/document/loadEditPlan?projectId=${projectId}&documentId=${documentId}',
	pagination: true,
	pageList: [5,10,20],
		queryParams: queryParams,
		clickToSelect: false,
		columns: [{
				       field: 'checked',
				       checkbox: true,
			           formatter:function(value, row, index) {
			        	   if(row.isOk == '1'){
			        		   return {
			         				disabled: true
			                      }
			         		}else{
			        		   if(row.lockPeople !=null){
			        			   if("${user_id}" !=row.lockPeople){
			        				   return {
					         				disabled: true
					                      }
				        		   }
			        		   }else{
			        			   if("2" == "${synegyType}"){
			        				   if(!("${user_id}" =="${proManagerId}" ||"${user_id}" =="${docManagerId}"||"${documentTeamer}".indexOf("${user_id}")>=0)){
				        				   return {
						         				disabled: true
						                      }
				        			   }
			        			   }else{
			        				   if(!("${user_id}" =="${proManagerId}" ||"${user_id}" =="${docManagerId}"||row.userId.indexOf("${user_id}")>=0)){
				        				   return {
						         				disabled: true
						                      }
				        			   }
			        			   }
			        			   
			        		   }
			         			
			         		}
			               return value;
			           }
				   },{
			            field: 'id',
			            title: 'id',
			            visible:false,
			            width: 5
			        },{
				       field: 'sectionNumber',
				       title: '章节号',
				       width: 50
				   },{
				       field: 'sectionName',
				       title: '章节名称',
				       width: 150
				   },{
					   field: 'editerName',
				       title: '编写人',
				       width: 150
				   },{
					   field: 'isOk',
				       title: '编制进度',
				       width: 50,
				       formatter:function(value, row, index) {
				       		if(value == '' || value == '0' || value == null){
				       			return '未完成';
				       		}else{
				       			return '已完成';
				       		}
				       }
				   }]
			});

	function queryParams(params){
		return {
		    pageSize: 20,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order
	   }
	}
})
	function cancel(){
		parent.closeWin();
	}
	
	$(function(){
		//"setComp"
		$.ajax({ 
			url:'${_baseUrl}/document/judgeSetComp', 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			data:{
				projectId:"${projectId}"
			},
			success: function(data){
            	if(data.code=='0'){
            		$("#setComp").css("display","none");
            	}
			},
			error:function(){
				layer.msg( "系统错误");
			}
	   });
		
	})
	
	
	
	
	function editFinish(){
		var selected =  $("#sectionList").bootstrapTable('getSelections');
		if(selected == ""){
			layer.msg("没有选择章节");
			return;
		}
		var ids = [];
		if(selected.length > 0){
			for(i in selected){
				ids.push(selected[i].id);
			}
		}
		$.ajax({ 
			url:'${_baseUrl}/document/finishEdit', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"ids":ids.join(',')},
			async: true,
			success: function(data){
				if(data == "success"){
					layer.msg( "所选章节已经完成编制");
					refreshWin();
					parent.getEditPercentage();
				}
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	}
	function refreshWin(){
		sectionList.bootstrapTable('refresh');
	}
</script>
</head>
<body>
   <div>
	<div class="glianwd_tc_top glianwd_tc_xt">
	<div class="s_glianwd_c">
       		<div  id="setComp" class="fr permission_an mubanclass_an">
		    	<a href="javascript:;" class="per_baocun" onclick="editFinish();">编制完成</a>
		    </div>
		    <div class="clear"></div>
        	</div>
            <div class="glianwd_tc_cont mt20">
            	<table id="sectionList" class="tab-w-01 tab-w-auto"></table> 
            </div>
        <div class="clear"></div>
    </div>
    
 </div>

</body>
</html>
