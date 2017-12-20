<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>变更分析展示项目列表界面</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
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

var demandList;
$(function (){
	demandList = $("#demandList").bootstrapTable({
		url : '${_baseUrl}/ca/getDemandlist',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{    // 修改BUG:删除表格显示复选框
        	 field: 'checked',
             checkbox: true,
             visible: false,
         },{
            title: '序号',
            width: 5,
            formatter: function(value, row, index){
            	return index+1;
            }
        }, {
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'projectname',
            title: '项目名称',
            width: 30,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"skip('"+row.projectid+"','"+row.projectsupervision+"')\" class='wdbx_tit' title='"+value+"'>"+subProjectName(value)+"</a>";
            }
        },{
            field: 'documenttype',
            title: '适用范围',
            width: 10
        },{
            field: 'documentCount',
            title: '文档总数',
            width: 10,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"skip('"+row.projectid+"','"+row.projectsupervision+"')\">"+value+"</a>";
            }
        },{
            field: 'changeCount',
            title: '变更申请次数',
            width: 10
        },{
            field: 'changeDocumentCount',
            title: '变更文档数量',
            width: 10
        },{
            field: 'projectstarttime',
            title: '开始时间',
            width: 20,
            formatter:function(value,row,index){
            	if(value == "" || value == null){
            		return value;
            	}else{
            		return value.substring(0,value.length - 3);
            	}
            }
        },{
            field: 'projectendtime',
            title: '结束时间',
            width: 20,
            formatter:function(value,row,index){
            	if(value == "" || value == null){
            		return value;
            	}else{
            		return value.substring(0,value.length - 3);
            	}
            }
        },{
            field: 'projectstatus',
            title: '进展',
            width: 10,
            formatter: function(value, row, index){
            	if("1" == value)
            		return "未构建";
            	if("2" == value)
            		return "编制中";
            	if("3" == value)
            		return "变更中";
            	if("4" == value)
            		return "已归档";
            }
        },{
            field: 'projectManagerName',
            title: '项目文档负责人',
            width: 10
        },{
            field: 'documenttemplateName',
            title: '模板名称',
            width: 25,
            formatter : function(value, row, index) {
            	if(value == null){
            		value = "-";
            	}
            	return "<div class='wdbx_tit' title='"+value+"'>"+value+"</div>";
            }
        },{
	           field: 'projectsupervision',
	           title: 'projectsupervision',
	           visible:false,
	           width: 5
	    },{
            title: '操作',
            width: 20,
            formatter: function(value, row, index){
            	/* var projectSuper = row.projectsupervision;
            	if(projectSuper == null){
            		projectSuper = "";
            	}
            	if(projectSuper.indexOf("${user_id}") >= 0){
            		return "--";
            	}else{
		           	var a = "<a href='${_baseUrl}/chc/showChangeHistoryList?projectId="+row.projectid+"'>历史变更</a>";
		           	a += "　<a href='javascript:' onclick='checkChange(\""+row.projectid+"\")'>发起变更</a><br>";
		           	a += "　<a href='javascript:' onclick='checkChangeInfluence(\""+row.projectid+"\")'>变更影响域分析</a>";
		           	return a;
            	} */
            	
            	
            	//监管人员  项目总负责人  项目文档的文档负责人
            	if((row.projectsupervision != null && row.projectsupervision.indexOf("${user_id}") >= 0) || 
            			(row.projectmanager != null && row.projectmanager.indexOf("${user_id}") >= 0) ||
            			(row.documentManagers != null && row.documentManagers.indexOf("${user_id}") >= 0)){
            		
            		if("4"==row.projectstatus){
            			var a = "<a href='${_baseUrl}/chc/showChangeHistoryList?projectId="+row.projectid+"'>历史变更</a>";
            		 	return a;
            		}else{
            			if((row.projectsupervision != null && row.projectsupervision.indexOf("${user_id}") >= 0) && (row.projectmanager != null && !(row.projectmanager.indexOf("${user_id}") >= 0)) &&
            			(row.documentManagers != null && !(row.documentManagers.indexOf("${user_id}") >= 0))){
            				var a = "<a href='${_baseUrl}/chc/showChangeHistoryList?projectId="+row.projectid+"'>历史变更</a>";
    			           	a += "　<a href='javascript:' onclick='checkChangeInfluence(\""+row.projectid+"\")'>变更影响域分析</a>";
    			           	return a;
            			}else{
            				var a = "<a href='${_baseUrl}/chc/showChangeHistoryList?projectId="+row.projectid+"'>历史变更</a>";
    			           	a += "　<a href='javascript:' onclick='checkChange(\""+row.projectid+"\")'>发起变更</a>";   /* <br> */
    			           	a += "　<a href='javascript:' onclick='checkChangeInfluence(\""+row.projectid+"\")'>变更影响域分析</a>";
    			           	return a;
            			}
            		}
            	}else
            		return "--";
            	
            }
        }]
    });
	
	//回车
	$(document).keyup(function(event){
	  if(event.keyCode == 13){
		  refreshTable();
	  }
	});
	
	/* 项目名称缺省显示 */
	function subProjectName(name){
		if(name.length > 13){
			name = name.substring(0,13);
			name += "...";
		}
		return name;
	}
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    projectName:$("#projectName").val()
	   }
	}
})

/*验证是否可以发起变更  */
function checkChange(projectId){
	$.ajax({
        type: "post",
        dataType: "json",
        url: '${_baseUrl}/ca/checkChangeNote',
        data: {projectId:projectId},
        success: function (data) {
        	if(data.code == "0"){
	        	layer.msg(data.message);
        	}else{
        		//验证当前登录人是不是项目负责人
        		$.ajax({
			        type: "post",
			        dataType: "json",
			        url: '${_baseUrl}/ca/checkisProjectManager',
			        data: {projectId:projectId},
			        success: function (result) {
			        	if("0" == result.message){
			        		layer.msg("无可发起变更的数据");
			        	}else{
			        		//非项目负责人
				        	if("1" == result.code){
				        		if("0" == result.message){
				        			layer.msg("无可发起变更的数据");
				        		}else{
				        			window.location.href = "${_baseUrl}/ca/showChangeRequestNote?projectId="+projectId;
				        		}
				        	}else  if("2" == result.code){
				        		layer.msg("监管人员无变更权限");
				        	}else{
				        		$("#popIframe").empty();
				        		$("#popDiv").dialog({
				        			title:'请选择变更内容类型:',
				        			autoOpen: true,
				        			modal: true,
				        			position:'center',
				        			height: 300,
				        			width: 500
				        		});
				        		$("#popIframe").attr("width","100%");
				        		$("#popIframe").attr("height","95%");
				        		$("#popIframe").attr("src","${_baseUrl}/ca/startChangeMessage?projectId="+projectId);
				        	}
			        	}
			        	
			        }
        		});
        	}
        }
    });		
}

/* 跳转到文档编写界面 */
function skip(projectId,projectsupervision){
	if(projectsupervision == null){
		parent.skipModule("文档编写","${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId);
	}else{
		if(projectsupervision.indexOf("${user_id}") >= 0){
			parent.skipModule("文档编写","${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&projectsupervision=yes");
		}else{
			parent.skipModule("文档编写","${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId);
		}
		
	}
	
}


/* 验证变更影响域分析 是否可以跳转 */
function checkChangeInfluence(projectId){
	$.ajax({
        type: "post",
        dataType: "json",
        url: '${_baseUrl}/ci/checkChangeInfluence',
        data: {projectId:projectId},
        success: function (data) {
        	if(data.code == "0"){
	        	layer.msg(data.message);
        	}else{
        		window.location.href = "${_baseUrl}/ci/showChangeInfluence?projectId="+projectId+"&changeId="+data.data;
        	}
        }
    });	
}
function refreshTable(){
	demandList.bootstrapTable('refresh');
}

//跳转到变更申请单界面
function skipChangeRequestNote(projectId){
	$("#popDiv").dialog("close");
	window.location.href = "${_baseUrl}/ca/showChangeRequestNote?projectId="+projectId;
}


//打开勘误错误替换界面
function openReplacePage(projectId){
	//先关闭当前正在弹出的矿口
	$("#popDiv").dialog("close");
	
	//弹出替换界面
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:'勘误修改',
		autoOpen: true,
		modal: true,
		position:'center',
		height: 500,
		width: 800
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/ca/openReplacePage?projectId="+projectId);
	
}

//勘误错误修改完毕后关闭弹出框并且提示消息
function alertMessage(){
	$("#popDiv").dialog("close");
	layer.msg("已完成对勾选的项目文档的勘误修改",{shift:5,time:1500});
	refreshTable();
}

</script>
<style>
	.wdbx_tit { width:100%; overflow:visible; text-overflow:none; white-space:normal; }    /* 修改表格显示内容优化    */
	.bgenglist table { table-layout:fixed;}
	.bgenglist table td a { display:inline-block;}
	.fixed-table-container thead th .th-inner { overflow:visible; text-overflow:none; white-space:normal;} 
</style>
<body>
    <div class="document_main">
    	<!-- <div class="page_tit_warp mtmb20"><div class="page_tit"><span>变更影响域分析</span></div></div> -->
        <div class="wdang_dy_l bgengyx_ss mt20">
            <dl>
                <dt><input name="" type="text" class="input_text2" id="projectName" value="请输入项目名称..." onFocus="if(this.value=='请输入项目名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入项目名称...';}"></dt>
                <dd><input name="" value="搜索" type="button" onclick="refreshTable();" class="dyi_btna dyi_btnabox dyi_btna1"></dd>
            </dl>
        </div>
    
            <div class="tablebox2 wdang_s bgenglist">
                <table id="demandList" width="100%" border="0" cellspacing="0" cellpadding="0">
            </table>
      </div>
      
      <!-- <div class="explain_t mt30"><strong>说明：</strong>如已提出变更申请，针对影响域分析，控制在本次变更未结束前，不可再次提交变更申请。</div> -->
    
</div>
<div id="popDiv" style="display: none;">
	<iframe id="popIframe" frameborder="0" border="0"></iframe>
</div>
</body>
</html>