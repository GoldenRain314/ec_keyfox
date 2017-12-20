<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档列表</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var documentList;
var projectId = "${projectId}";
var id = "${id}";
$(function (){
	var  random= Math.random();
	$("#documentList", window.parent.document).removeAttr("disabled"); 
	$.ajax({
		url:'${_baseUrl}/demand/getProjectTrackMode',
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		async: false,
		success: function(data){
			var jsonObj=eval("("+data.json+")");
		 	$.each(jsonObj, function (i, item) {
		 		if(item.source == "初始化"){
		 			$("#438b").html(item.demandName);
		 			$("#demandId").val(item.demandId);
		 		}else if(item.source == "自定义"){
		 			jQuery("#userdefined").append("<option value="+ item.demandId+">"+ item.demandName+"</option>");
		 		}
		 	}); 
			
        },
		error:function(){
			layer.msg( "系统错误");
		}

	});
	documentList = $("#documentList").bootstrapTable({
		url : '${_baseUrl}/documentList/getProjectDocumentList?projectId='+projectId+'&type=${type}&number='+random,
		pagination: true,
		pageList: [5, 10, 20, 50],
		cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
  		queryParams: queryParams,
  		columns: [{
       	 field: 'checked',
         checkbox: true
     	},{
           field: 'id',
           title: 'id',
           visible:false,
           width: 5
       },{
           field: 'serial',
           title: '序号',
           width: 50,
           formatter : function(value, row, index) {
           	if(status){
           		var str=value;
           	}else{
           		var str=index+1;
           	}
			return str;
           }
       },{
            field: 'templateName',
            title: '工作产品',
            width: 100
        },{
            field: 'source',
            title: '文档模板来源',
            width: 100,
            formatter:function(value, row, index) {
         		 if(value == '初始化'){
         			 return "标准文档模板";
         		 }else if(value == '自定义'){
         			 return "自定义文档模板";
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
})
function deleteDocument(){
	var objects =  $("#documentList").bootstrapTable('getSelections');
	if(objects.length==0){
		layer.msg("您还没有选择一个要删除的文档");
		return;
	}
	var options ="确认删除这些文档?";
	layer.confirm(options,{
		btn:['确定','取消']},
		function (){
			var obj = JSON.stringify(objects);
			var jsonObj = eval("("+obj+")");
			var ids = new Array();
			for(var i in jsonObj){
				ids[i] = jsonObj[i].id;
			}
			$.ajax({
				url:'${_baseUrl}/documentList/deleteDocumentById?ids='+ids+'&projectId=${projectId}',
				type:'post', //数据发送方式 
				dataType:'text', //接受数据格式 
				async: false,
				success: function(data){
					if(data == "true"){
						layer.msg("删除成功");
						window.location.reload(true);
					}
		        },
				error:function(){
					layer.msg( "系统错误");
				}
			});
		},
		function(){
			return;
		}
	);

}
function addDocument(){
	var ids;
	$.ajax({
		url:'${_baseUrl}/documentList/getAllDocumentList',
		type:'post', //数据发送方式 
		dataType:'text', //接受数据格式 
		data:{"projectId":projectId},
		async: false,
		success: function(data){
			ids = data;
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'项目文档编辑',
		autoOpen: true,
		modal: true,	
		height: 550,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentList/addProjectDocument?projectId="+projectId+"&ids="+ids);
}
/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}
function refreshWin(){
	documentList.bootstrapTable('refresh');
}

function save(){
	$.ajax({
		url:'${_baseUrl}/documentList/getProjectDocumentListCount',
		type:'post', //数据发送方式 
		dataType:'text', //接受数据格式 
		data:{"projectId":projectId},
		async: false,
		success: function(data){
			 if(data == "success"){
				/* var set = $('input[name="traceset"]:checked').val();
				var tracesetId;
				if(set == "438"){
					tracesetId = $("#demandId").val()
				}else{
					tracesetId = $('#userdefined option:selected').val();
				} */
				var path="${_baseUrl}/documentList/saveDocumentTraceset?projectId="+projectId+"&id="+id;
				window.location.href=path;
				parent.click("taskAssign");
			 }else{
				 layer.msg("该项目文档不能为空，请添加。"); // [#3714] 提示语规范明确,提示：该项目文档不能为空，请添加。
			 }
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
	
}
</script>
</head>
<body>

    <div class="xmugonj_cont ma" style="display:block;">
          <div class="glqxian_btn xmugonj_btn2 mtmb2010">
              <shiro:hasPermission name="documentList:deleteDocumentById">
		          <a href="javascript:;" class="fr glqxian_btn1" onclick="deleteDocument();">删除</a>
		      </shiro:hasPermission>
	          <shiro:hasPermission name="documentList:addProjectDocument">
		          <a href="javascript:;" class="fr glqxian_btn1 mr18" onclick="addDocument();">新增</a>
		      </shiro:hasPermission>
	          
          </div>
          <div class="xmugonj_ta_j wendlist_a widthauto">
           	    <table id="documentList" class="tab-w-01 tab-w-auto"></table>  
           	    <input type="hidden" id="demandId"/> 
				<div class="permission_an xmugonj_bc ma">
				   <shiro:hasPermission name="documentList:saveDocumentTraceset">
			          <a href="javascript:;" class="per_baocun" onclick="save();">保 存</a>
			       </shiro:hasPermission>	
               </div>
          </div>
    </div>
	<div class="clear"></div>
	<div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>
</body>
</html>
