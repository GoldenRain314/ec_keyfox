<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html style="overflow:auto; width:1060px;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>设置项目文档的内容复用</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var contentReuseList;
var projectId = "${projectId}";
var contentCopyTemplateId= "${contentCopyTemplateId}";
var ids = "${ids}";
$(function (){	
	contentReuseList = $("#contentReuseList").bootstrapTable({
		url : '${_baseUrl}/demand/getContentReuseList?projectId='+projectId,
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
        columns: [{
            title: '序号',
            width: 30,
            formatter: function(value, row, index){
            	return index+1;
            }
        }, {
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'reuseDocumentName',
            title: '引用文档',
            width: 50,
            formatter: function(value, row, index){
            	return "<a onclick=\"updateReuseDocument('"+row.id+"');\">"+value+"</a>";
            }
        },{
            field: 'reuseSectionName',
            title: '引用文档章节',
            width: 50,
        },{
            field: 'applyDocumentName',
            title: '适用文档',
            width: 50,
            formatter: function(value, row, index){
            	return "<a onclick=\"updateApplyDocument('"+row.id+"');\">"+value+"</a>";
            }
        },{
            field: 'applySectionName',
            title: '适用文档章节',
            width: 50,
            formatter: function(value, row, index){
            	if(row.applySectionName!=null){
            		var applySectionName=row.applySectionName.substring(1);
                	return applySectionName;
            	}
            	return applySectionName;
            }
        },{
	            title: '操作',
	            width: 100,
	            formatter: function(value, row, index){
	            	return "<a onclick=\"deleteContentReuse('"+row.id+"');\">删除</a>";
	            }
        }]
    });
	

	/*新增*/
	/* $("#addContentReuse").click(function (){
		window.location.href = "${_baseUrl}/demand/addContentReuse";
	}); */

	/*选择引用文档内容和适用文档章节"*/
	$("#documentReference").click(function (){
		window.location.href = "${_baseUrl}/demand/showDocumentReference?contentCopyTemplateId="+contentCopyTemplateId+"&projectId="+projectId+"&ids="+ids;
		/* $("#popIframe").empty();
		$("#popDiv").dialog({
			
			autoOpen: true,
			modal: true,	
			height: 700,
			width: 1000
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/demand/showDocumentReference?contentCopyTemplateId="+contentCopyTemplateId+"&projectId="+projectId);	 */
	});
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    projectName:$("#projectName").val()
	   }
	}
});
function deleteContentReuse(id){
	
	  $.ajax({
			url:'${_baseUrl}/demand/deleteContentReuse', 
			data:{"id":id},
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(json){
				layer.msg(json.message);
				refreshTable();	
				
        },
			error:function(){
				layer.msg(json.message);
			}
		});  
}
function updateReuseDocument(id){
	var s= testApplyDocumentIssue(id);
	if("3"==s){
		layer.msg("适用文档已发布，不能修改引用文档章节");//[#3353] 提示语规范，内容复用，适用文档已发布时，提示语修改
		return false;
	}
	 $("#popIframe").empty();
	$("#popDiv").dialog({
		title:'修改引用文档章节',
		autoOpen: true,
		modal: true,	
		height: 600,    /* 弹出框高度合理显示高度  650-600 */
		width: 600,
	//	resizable:false  /* 弹出框大小不可变   */
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/demand/updateReuseDocument?id="+id); 
}
function updateApplyDocument(id){
	var s= testApplyDocumentIssue(id);
	if("3"==s){
		layer.msg("适用文档已发布，不能修改适用文档章节");//[#3353] 提示语规范，内容复用，适用文档已发布时，提示语修改
		return false;
	}
	 $("#popIframe").empty();
		$("#popDiv").dialog({
			title:'修改适用文档章节',
			autoOpen: true,
			modal: true,	
			height: 600,    /* 弹出框高度合理显示高度  650-600 */
			width: 600,
			
		//	resizable:false   /* 弹出框大小不可变   */
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/demand/updateApplyDocument?id="+id); 
	//window.location.href='${_baseUrl}/demand/updateApplyDocument?id='+id;
}
function closewin(){
	$("#popDiv").dialog("close");
}

function refreshTable(){
	contentReuseList.bootstrapTable('refresh');
}
function testApplyDocumentIssue(id){
	 var status=0;
	 $.ajax({
			url:'${_baseUrl}/demand/testApplyDocumentIssue', 
			data:{"id":id},
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(json){
			status=json.message;
		    
		   
				
     },
			error:function(){
				layer.msg(json.message);
			}
		});  
	 return status;
};
$(function(){
	$("#popDiv").on( "dialogclose", function( event, ui ) {
		contentReuseList.bootstrapTable('refresh');
	} );
});
</script>

<style>
	.fixed-table-body{ overflow:hidden;}
</style>

<body  >
    <div  class="wdang_c mt20" >
         	<div class="wdang_dy" style="position:relative;" >
         		<div class="fl wdang_dy_l" >
	                 <dl >
	                    <dd style="position:absolute; right:0;"><input id="documentReference" value="新增" type="button" class="dyi_btna dyi_btnabox dyi_btna1"></dd>
	                </dl>
		        </div>
               	<%-- <div class="fr glqxian_btn wendmban_btn">		
               		<shiro:hasPermission name="demand:showDemandTrace">
				       <a href="javascript:;" class="glqxian_btn1  fl" id="addContentReuse">新增</a>
				    </shiro:hasPermission>
               	</div> --%>
            <div class="clear"></div>
          	</div>
          	<div class="wdang_s" >
             	 <table id="contentReuseList" style="overflow:hidden;" class="tab-w-01 tab-w-auto" width="100%" border="0" cellspacing="0" cellpadding="0">
        			</table>     	
         	</div>      	
	</div> 
	<div id="popDiv" style="display: none; overflow:hidden;">
	<iframe id="popIframe" border="0" frameborder="0"></iframe>
</div>    	
</body>
</html>