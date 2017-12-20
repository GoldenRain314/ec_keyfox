<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>需求追踪文档列表</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var ddocumentList;
var  projectStatus;
$(function (){
	ddocumentList = $("#ddocumentList").bootstrapTable({
		url : '${_baseUrl}/dd/getDdocumentList',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
        columns: [{
        	 field: 'checked',
             checkbox: true
         }, {
            title: '序号',
            width: 30,
            formatter: function(value, row, index){
            	return index+1;
            }
        }, {
            field: 'templateId',
            title: 'templateId',
            visible:false,
            width: 5
        },{
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'templateName',
            title: '工作产品',
            width: 130,
            formatter:function(value,row,index){
            	return "<a href='javascript:void(0)' title='"+value+"' >"+subProjectName(value)+"</a>";    /* 设置内容缺省显示   */
            }/* ,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"showDetail('"+row.menuId+"')\">"+value+"</a>";
            } */
        },{
            field: 'startTime',
            title: '开始时间',
            width: 100
        },{
            field: 'endTime',
            title: '完成时间',
            width: 100
        },{
            field: 'documentManagerName',
            title: '文档负责人',
            width: 100
        },{
            field: 'traceDocumentName',
            title: '追踪文档',
            width: 130
        },{
            field: 'documentVersion',
            title: '文档版本',
            width: 80
        },{
            field: 'documentStatus',
            title: '文档状态',
            width: 80,
            formatter: function(value, row, index){
            	if("1" == value)
            		return "未编写";
            	if("2" == value)
            		return "编写中";
            	if("3" == value)
            		return "已发布";
            }
        },{
            title: '内容追踪关系',
            width: 100,
            formatter: function(value, row, index){
            	if(documentTrack(row.id,row.projectId)==true){
            		if("${projectInfo.projectstatus}" == '4'){
            			return "<a href='javascript:showTraceDetailed(\""+row.id+"\",\""+row.projectId+"\")'>查看</a>";
            		}else{
	            		return "<a href='javascript:showTraceDetailed(\""+row.id+"\",\""+row.projectId+"\")'>查看</a>　<a href='javascript:showTraceRelation(\""+row.projectId+"\",\""+row.id+"\",\""+row.documentStatus+"\")'>建立追踪</a>";
            		}
            	}else{
            		return "<a href='javascript:showTraceDetailed(\""+row.id+"\",\""+row.projectId+"\")'>查看</a>";
            	}
            	
            }
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    projectId:"${projectId}",
		    traceSet:"${projectBaseInfo.traceset}",
		    templateName:$("#documentName").val()
	   }
	}
	
	function documentTrack(documentId,projectId){
		var result =false;
		$.ajax({
			url:'${_baseUrl}/dd/checkisProjectDocumentManager',
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			data:{documentId:documentId,projectId:projectId},
			async: false,
			success: function(data){
				if(data.code=='1'){
					result = true;
				}else{
					result = false;
				}
	        },
			error:function(){
				result = false;
			}
		});
		return result;
	}
	
	
	
	$("#setTrace").click(function (){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'需求追踪设置',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 900
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/demand/showDemandTrace");
	});
})

$(document).keyup(function(event){
  if(event.keyCode ==13){
	  refreshTable();
  }
});

/* 控制查看按钮 */
function showTraceDetailed(documentId,projectId){
	showDemandTraceTable(documentId,projectId);
}

/* 建立追踪 */
function showTraceRelation(projectId,documentId,status){
	if("4" == "${projectBaseInfo.projectstatus}"){
		layer.msg("已归档的项目不能修改追踪关系");
		return;
	}
	
	$.ajax({
		url:'${_baseUrl}/dd/checkDocument?documentId='+documentId,
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		async: false,
		success: function(data){
			if("0" == data.code)
				//parent.skipModule("需求追踪","${_baseUrl}/dd/showTraceRelation?projectId="+projectId+"&documentId="+documentId);
				window.location.href = "${_baseUrl}/dd/showTraceRelation?projectId="+projectId+"&documentId="+documentId+"";
			else
				layer.msg("请先编写并发布文档");
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
}

/* 展示表格的追踪关系 */
function showDemandTraceTable(documentId,projectId){
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'查看追踪关系',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 950
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/dd/showTraceDetailed?documentId="+documentId+"&projectId="+projectId+"&random="+Math.random());
}

function refreshTable(){
	ddocumentList.bootstrapTable('refresh');
}


function showAllTrack(){
	/* $("#track").attr("class","");
	$("#documentTrace").attr("src","${_baseUrl}/dd/checkAllTrack?projectId="+projectId);
	 */
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'全景追踪',
		autoOpen: true,
		modal: true,	
		height: window.screen.height+40,
		width: window.screen.width-40
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","100%");
	$("#popIframe").attr("src","${_baseUrl}/dd/checkAllTrack?projectId=${projectId}");
	
	
}
/* 项目名称缺省显示 15字符  */
function subProjectName(name){     /* 修改显示字符数量为15字符   */
	if( name.length > 13){
		name = name.substring (0,13);
		name += "...";
	}
	return name;
}

$(function(){
	var templateName = "${projectInfo.documenttemplateName}";
	if(templateName=="GJB438B项目文档模板"){
		$("#allTrack").css("display","block");
	}
	
	$("#docMenu").html(subProjectName("${location }"));

});

</script>
<body>
<div class="document_main">
    	<!-- <div class="page_tit_warp mtmb20"><div class="page_tit"><span>需求追踪</span></div></div> -->
    	<!-- 修改文档列表样式开始  -->
        <div class="wdang_tab xmulist_tab">   
        	<a href="javascript:;" class="wdtab_on">文档列表</a>
        </div>
         <!-- 修改文档列表样式结束 -->
        <div class="document_maina">
        <div class="current_wz mtmb20" style=" margin:0 0 20px 0;">
        	<div class="fl current_xmname"><strong>项目目录：</strong><span id="docMenu" title="${location }">${location }</span></div>    <!-- 内容过长时缺省显示35字符   -->
        	<!-- <input type="text" id="documentName" />
        	<a href="javascript:refreshTable()" class="glqxian_btn1">搜索</a> -->
        	
        	<div class="fl xmulist2_ss">
                	<p><input name="docName" id="documentName" type="text" class="input_text xmulist2_input" value="请输入文档名称..." onFocus="if(this.value=='请输入文档名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入文档名称...';}"></p>
                    <span><a name="" value="搜索" type="button" onclick="refreshTable();" class="dyi_btna dyi_btnabox dyi_btna1" style="width:60px; height:31px;">搜索</a>
                </div>
        	
        	
        	<div class="fr glqxian_btn wendmban_btn">
        		<shiro:hasPermission name="demand:showDemand">
			       <a href="${_baseUrl }/demand/showDemand" class="glqxian_btn1" style="height:31px; line-height:28px;">返回项目列表</a>
			    </shiro:hasPermission>
        	</div>
        </div>
        
   		<div class="current_wz mtmb20" >
        	<table id="ddocumentList" class="tab-w-01 tab-w-auto" width="98%" border="0" cellspacing="0" cellpadding="0">
    		</table>     	
       	</div>
       	
      <div class="current_wz mtmb20"><strong>文档总数：</strong>${documentCount }；   &nbsp;&nbsp;&nbsp;&nbsp; <strong>已发布文档数量：</strong>${documentPushCount }；    &nbsp;&nbsp;&nbsp;&nbsp;<strong>未发布文档数量：</strong>${documentNotPushCount }；    &nbsp;&nbsp;&nbsp;&nbsp;<strong>建立追踪文档数量：</strong>${documentTraceCount }；</div>
        <div class="wdang_tab xmulist_tab">   <!-- 修改显示样式  -->
            <a href="javascript:;" class="wdtab_on">需求追踪</a>
            <div class="fr quanjingzz_btn" id="allTrack" style="display:none;" >
            	<a href="javascript:;" onclick="showAllTrack();">全景追踪</a>
            </div>
        </div>
        <iframe id="documentTrace" frameborder="0" style="width:100%; height:100%;" class="iframe_cont" src="${_baseUrl}/dd/showDocumentTrace?projectId=${projectId}"></iframe>
     <!--  <div class="xqzzny_c1">
          <a href="javascript:;" class="xqzzny_a1">查看追踪关系</a>
          <a href="javascript:;" class="xqzzny_a2">查看追踪关系</a>
          <a href="javascript:;" class="xqzzny_a3">查看追踪关系</a>
          <a href="javascript:;" class="xqzzny_a4">查看追踪关系</a> 
          <a href="javascript:;" class="xqzzny_a5">查看追踪关系</a> 
          <a href="javascript:;" class="xqzzny_a6">查看追踪关系</a> 
          <a href="javascript:;" class="xqzzny_a7">查看追踪关系</a>  	
       </div> -->
      
      <!-- <div class="current_wz mtmb20"><strong>后期需求：</strong>需求追踪统计</div> -->
    
    </div>
<div id="popDiv" style="display: none;">
	<iframe id="popIframe" border="0" frameborder="0"></iframe>
</div>
</body>
</html>