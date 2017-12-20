<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>需求追踪</title>
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
		url : '${_baseUrl}/demand/getDemandlist',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{     //修改BUG: 删除表格显示复选框
        	 field: 'checked',
             checkbox: true,
             visible: false,
         }, {
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
            field: 'projectname',
            title: '项目名称',
            width: 50,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"skip('"+row.projectid+"','"+row.projectsupervision+"')\" class='wdbx_tit' title='"+value+"'>"+subProjectName(value)+"</a>";
            }
        },{
            field: 'documenttype',
            title: '适用范围',
            width: 20
        },{
            field: 'documentCount',
            title: '文档总数',
            width: 20,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"skip('"+row.projectid+"','"+row.projectsupervision+"')\">"+value+"</a>";
            }
        },{
            field: 'documentTraceCount',
            title: '建立追踪文档数量',
            width: 20
        },{
            field: 'projectstarttime',
            title: '开始时间',
            width: 130,
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
            width: 130,
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
            width: 50,
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
            width: 20
        },{
            field: 'documenttemplateName',
            title: '模板名称',
            width: 150,
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
	            width: 100,
	            formatter: function(value, row, index){
	            	var projectSuper = row.projectsupervision;
	            	if(projectSuper == null){
	            		projectSuper = "";
	            	}
	            	if(documentTrack(null,row.projectid)==true){
	            		if(row.projectstatus =='4'){
	            			return "<a href='${_baseUrl}/dd/showDemandDocumentList?projectId="+row.projectid+"'>查看</a>";
	            		}else{
		            		return "<a href='${_baseUrl}/dd/showDemandDocumentList?projectId="+row.projectid+"'>建立追踪</a>";
	            		}
	            	}else{
	            		return "--";
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
		    projectName:$("#projectName").val()
	   }
	}
	
	/* 项目名称缺省显示 */
	function subProjectName(name){
		if(name.length > 13){
			name = name.substring(0,13);
			name += "...";
		}
		return name;
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
	
	//回车 搜索
	$(document).keyup(function(event){
	  if(event.keyCode == 13){
		  refreshTable();
	  }
	});
	
	$("#setTrace").click(function (){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'需求追踪设置',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 1150
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/demand/showDemandTrace");
	});
})

/* 跳转到文档编写 */
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

function refreshTable(){
	demandList.bootstrapTable('refresh');
}

</script>
<style>
	.wdbx_tit { width: 220px;}   /* 内容显示不全  */
</style>
<body>
     <div class="ma main">
       	<!-- <div class="page_tit_warp mtmb20"><div class="page_tit"><span>需求追踪</span></div></div> -->
           <div class="wdang_cont" style="display:block;">
    		<div class="wdang_c mt20" >
	          	<div class="wdang_dy" >
		            <div class="fl wdang_dy_l" >
		                 <dl >
		                    <dt><input name="" type="text" id="projectName" class="input_text2" value="请输入项目名称..." onFocus="if(this.value=='请输入项目名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入项目名称...';}"></dt>
		                    <dd><input name="" value="搜索" type="button" onclick="refreshTable();" class="dyi_btna dyi_btnabox dyi_btna1"></dd>
		                </dl>
		            </div>
                 	<div class="fr glqxian_btn wendmban_btn">		
                 		<shiro:hasPermission name="demand:showDemandTrace">
					       <a href="javascript:;" class="glqxian_btn1  fl" id="setTrace">设置需求追踪</a>
					    </shiro:hasPermission>
                 	</div>
		            <div class="clear"></div>
	           	</div>
	           	<div class="wdang_s" >
	              	 <table id="demandList" class="tab-w-01 tab-w-auto" width="100%" border="0" cellspacing="0" cellpadding="0">
          			</table>     	
	          	</div>      	
			</div>     	
           </div>
    </div>
<div id="popDiv" style="display: none; overflow:hidden;">
	<iframe id="popIframe" border="0" frameborder="0"></iframe>
</div>
</body>
</html>