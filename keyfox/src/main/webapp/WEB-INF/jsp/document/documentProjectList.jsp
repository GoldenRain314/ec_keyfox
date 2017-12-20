<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档编写</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var menuList;

$(function (){
	menuList = $("#menuList").bootstrapTable({
		url : '${_baseUrl}/document/getProjectList?number='+Math.random(),
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{         // 修改bug:取消表格显示复选框
        	 field: 'checked',
             checkbox: true,
             visible: false,
         },{
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'projectsupervision',
            title: 'projectsupervision',
            visible:false,
            width: 5
        },{
            field: 'projectid',
            title: 'projectid',
            visible:false,
            width: 5
        },{
            field: 'projectmanager',
            title: 'projectmanager',
            visible:false,
            width: 5
        },{
            field: 'serial',
            title: '序号',
            width: 5,
            formatter : function(value, row, index) {
            	var str;
            	if(status){
					str = value;
            	}else{
            		str = index+1;
            	}
				return str;
            }
        },{
            field: 'projectname',
            title: '项目名称',
            width: 20,
            formatter : function(value, row, index) {
            	var projectSuper = row.projectsupervision;
            	if(projectSuper == null){
            		projectSuper = "";
            	}
            	
            	if(row.projectstatus == "2" || row.projectstatus == "3"){
           			if(projectSuper.indexOf("${user_id}") >= 0){
           				return "<a onClick=\"checkProject('"+row.id+"','"+row.projectid+"','"+row.projectstatus+"');\" class='wdbx_tit' title='"+value+"'>"+subProjectName(value)+"</a>"
               		}else{
               			return "<a onClick=\"gotoProjectAndDocument('"+row.id+"','"+row.projectid+"','projectList');\" class='wdbx_tit' title='"+value+"'>"+subProjectName(value)+"</a>";
               		}
               		
               	}else if(row.projectstatus == "4"){
               		return "<a onClick=\"checkProject('"+row.id+"','"+row.projectid+"','"+row.projectstatus+"');\" class='wdbx_tit' title='"+value+"'>"+subProjectName(value)+"</a>"
               		
               	}else{
               		if("1" == row.projectstatus && row.projectmanager == "${user_id}"){
               			return "<a onClick=\"establishMent('"+row.id+"','"+row.projectid+"');\" title='"+value+"'>"+subProjectName(value)+"</a>";     /* 显示全称_chang_0604 */
               			//return "<a onClick=\"gotoProjectAndDocument('"+row.id+"','"+row.projectid+"','projectList');\" title=\""+value+"\">"+subProjectName(value)+"</a>";
               		}else if(projectSuper.indexOf("${user_id}") >= 0){
               			return "<span title='"+value+"'>"+subProjectName(value)+"</span>";
               			//return value;
               		}else{
               			return "<span title='"+value+"'>"+subProjectName(value)+"</span>";
               			//return value;
                   		//return "<a onClick=\"establishMent('"+row.id+"','"+row.projectid+"');\" class='wdbx_tit' title='"+value+"'>"+value+"</a>"
               		}
               	}

            	
            }
        },{
            field: 'applicationscope',
            title: '适用范围',
            width: 10
        },{
            field: 'documentCount',
            title: '文档总数',
            width: 10
        },{
            field: 'publishedDocumentCount',
            title: '已发布文档数',
            width: 10
        },{
            field: 'noPublishedDocumentCount',
            title: '未发布文档数',
            width: 10
        },{
            field: 'projectstarttime',
            title: '开始时间',
            width: 15,
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
            width: 15,
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
            formatter : function(value, row, index) {
            		var str ;
					if(value == "1"){
						str = "未构建";
					}else if(value == "2"){
						str = "编制中";
					}else if(value == "3"){
						str = "变更中";
					}else if(value == "4"){
						str = "已归档";
					}
					return str;
			}
        },{
            field: 'projectManagerName',
            title: '项目文档负责人',
            width: 10
        },{
            field: 'documenttemplateName',
            title: '模板名称',
            width: 15,
            formatter : function(value, row, index) {
            	if(value == null){
            		value = "-";
            	}
            	return "<div class='wdbx_tit' title='"+value+"'>"+value+"</div>";
            }
        },{
            field: 'operation',
            title: '操作',
            width: 10,
            formatter : function(value, row, index) {
            	var projectSuper = row.projectsupervision;
            	if(projectSuper == null){
            		projectSuper = "";
            	}
            	if(projectSuper.indexOf('${user.id}') >= 0 && row.projectstatus !="1"){
    				return "<a onClick=\"checkProject('"+row.id+"','"+row.projectid+"','"+row.projectstatus+"');\">查看</a>";
    			}else{
    				if(row.projectstatus == "1" && row.projectmanager == "${user.id}"){
            			return "<a onClick=\"establishMent('"+row.id+"','"+row.projectid+"');\">构建</a>";
            		}else if(row.projectstatus == "2"){
            			if(row.projectmanager == "${user.id}"){
            				return "<a onClick=\"gotoProjectAndDocument('"+row.id+"','"+row.projectid+"','projectList');\">编写</a>&nbsp;<a onClick=\"pigeonhole('"+row.id+"','"+row.projectid+"');\">归档</a>";
            			}else{
            				return "<a onClick=\"gotoProjectAndDocument('"+row.id+"','"+row.projectid+"','projectList');\">编写</a>";
            			}
            		}else if(row.projectstatus == "4"){
            			return "<a onClick=\"checkProject('"+row.id+"','"+row.projectid+"','"+row.projectstatus+"');\">查看</a>";
            		}else if(row.projectstatus == "3"){
            			return "<a onClick=\"gotoProjectAndDocument('"+row.id+"','"+row.projectid+"','projectList');\">编写</a>";
            		}
    			}
            		
					
			}
        }]
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
		    projectname:$("#projectname").val()
	   }
	}
	//回车
	$(document).keyup(function(event){
		  if(event.keyCode == 13){
			  selectProjectMessage();
		  }
	});
})



function establishMent(id,projectId){
	var path="${_baseUrl}/document/projectInitialize?id="+id+"&projectId="+projectId;
	window.location.href=path;
}
function gotoProjectAndDocument(id,projectId,source){
	var path="${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&id="+id+"&source="+source;
	window.location.href=path;
}
function pigeonhole(id,projectId){
	$.ajax({
		url:'${_baseUrl}/document/getIsOrPigeonhole?projectId='+projectId,
		type:'post', //数据发送方式 
		dataType:'text', //接受数据格式 
		async: false,
		success: function(data){
			if(data == "success"){
				layer.msg("归档成功",{time:2000},function(){
					var path="${_baseUrl}/documentList/pigeonholeProjectDocument?projectId="+projectId+"&id="+id;
					window.location.href=path;
				});
			}else if(data == "fail"){
				layer.msg("该项目下的文档还没有编写完成，不能归档");
				return;
			}
        },
		error:function(){
			layer.msg( "系统错误");
		}

	});
	
}
function checkProject(id,projectId,projectStatus){
	if(projectStatus == '4'){
		var path="${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&id="+id+"&status="+projectStatus;
	}else{
		var path="${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&id="+id+"&projectsupervision=yes";
	}
	
	window.location.href=path;
}
function selectProjectMessage(){
/* 	var projectName = $("#projectName").val();
	if(projectName == "请输入项目名称..."){
		projectName = "";
	} */
	menuList.bootstrapTable('refresh');
}

function paramValue(value){
		
	menuList.bootstrapTable('refresh',{url:"${_baseUrl}/document/selectByStatus?projectStatus="+value});
}

</script>
<style>
	/* .wdbx_tit { width: 240px;} */   /* 内容显示不全  */
	#menuList { table-layout:fixed;}
	#menuList td a { display:inline-block;}
	.wdbx_tit { width:auto;}
	.fixed-table-container thead th .th-inner,.titlea_sy, .titlea_sy1, .wdbx_tit { white-space:normal; overflow:visible; text-overflow:none;}
</style>
<body>
     <div class="ma main">
    	<div class="wdang_main"  >
        	<!-- <div class="page_tit_warp mtmb20"><div class="page_tit"><span>文档编写</span></div></div> -->
            <div class="wdang_cont mt20" style="display:block;">
            	<div class="wdang_c" >
			         <div class="wdang_dy" >
		            	<div class="xmugonj_bz xmulist_bz wdfbkbox">
			                <dl >
			                    <dt>项目进展：</dt>
			                    <dd>
			                      <select  class="xmugonj_select" id="proStatus" onchange="paramValue(this.options[this.options.selectedIndex].value)">
			                      	<option value="0">请选择项目进展</option>	
									<option value="1">未构建</option>
									<option value="2">编制中</option>
									<option value="3">变更中</option>  <!-- 增加变更中 chang_0707 -->  
									<option value="4">已归档</option>   
			                      </select>
			                    </dd>
			                    <div class="clear"></div>
			                </dl>
			                <div class="fl xmulist2_ss">
			                	<p><input name="" type="text" id="projectname" class="input_text xmulist2_input" value="请输入项目名称..." onFocus="if(this.value=='请输入项目名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入项目名称...';}"></p>
			                    <span><input name="" value="搜索" type="button" onclick="selectProjectMessage();" class="dyi_btna dyi_btnabox dyi_btna1"></span>
			                </div>
			                <div class="clear"></div>
			            </div>         
			           <div class="wdang_s" >
			              	<table id="menuList" class="tab-w-01 tab-w-auto"></table>         	
			           </div>      	
				</div>     	
            </div>
        </div>
    </div>   
</body>
</html>