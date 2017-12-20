<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>首页</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript">
var documentList;
var docModel;
$(function (){
	documentList = $("#documentList").bootstrapTable({
		url : '${_baseUrl}/document/getProjectList?number='+Math.random(),
		pagination: true,
		pageList: [5, 10, 20, 50],
		clickToSelect:false,
		cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
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
        }, {
            field: 'projectsupervision',
            title: 'projectsupervision',
            visible:false,
            width: 5
        },{
            field: 'projectname',
            title: '项目名称',
            width: 100,
            formatter: function(value, row, index){
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
               			return "<a onClick=\"establishMent('"+row.id+"','"+row.projectid+"');\">"+subProjectName(value)+"</a>";
               			//return "<a onClick=\"gotoProjectAndDocument('"+row.id+"','"+row.projectid+"','projectList');\" title=\""+value+"\">"+subProjectName(value)+"</a>";
               		}else if(projectSuper.indexOf("${user_id}") >= 0){
               			return value;
               		}else{
               			return value;
                   		//return "<a onClick=\"establishMent('"+row.id+"','"+row.projectid+"');\" class='wdbx_tit' title='"+value+"'>"+value+"</a>"
               		}
               	}
            }
        },{
            field: 'documenttype',
            title: '适用范围',
            width: 100
        },{
            field: 'documentCount',
            title: '文档总数',
            width: 100
            /* ,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"skip('"+row.projectid+"')\">"+value+"</a>";
            } */
        },{
            field: 'projectstarttime',
            title: '开始时间',
            width: 100,
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
            width: 100,
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
            width: 100,
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
            width: 100
        },{
            field: 'documenttemplateName',
            title: '模板名称',
            width: 100,
            formatter : function(value, row, index) {
            	if(value == null){
            		value = "-";
            	}
            	return "<div class='wdbx_tit' title='"+value+"'>"+value+"</div>";
            }
        }]
    });
	
	/* 项目名称缺省显示 */
	function subProjectName(name){
		if(name.length > 15){
			name = name.substring(0,15);
			name += "...";
		}
		return name;
	}
	
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order
	   }
	}
	
	docModel = $("#docModel").bootstrapTable({
		url : '${_baseUrl}/docModel/selectModel',
		pagination: true,
		pageList: [5],
		clickToSelect:false,
  		queryParams: queryDocModelParams,
        columns: [{
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'serial',
            title: '序号',
            width: 80,
            formatter : function(value, row, index) {
            	var str=index+1;
				return str;
            }
        },{
            field: 'modelType',
            title: '范本类型',
            width: 50,
            formatter : function(value, row, index) {
            	var str="";
            	if(value=="guide"){
            		str="编写指南";
            	}
            	if(value=="explain"){
            		str="编写说明";
            	}
            	if(value=="example"){
            		str="编写示例";
            	}
				return str;
            }
        },{
            field: 'modelName',
            title: '文档名称',
            width: 250,
            formatter : function(value, row, index) {
            	var str="";
        		str +="<a onClick=\"checkFun('"+row.id+"');\" class=\"titlea_sym\"  title="+value+">"+value+"</a>";  
				return str;
            }
        },{
            field: 'applicableScope',
            title: '适用范围',
            width: 200,
            visible:false
        },{
            field: 'applicableStandrad',
            title: '适用标准',
            width: 150,
            formatter : function(value, row, index) {
            	return "<div class=\"titlea_sy1\" title="+value+">"+value+"</div>"
            }
        }]
        
       
    });
	
	function queryDocModelParams(params){
		return {
		    pageSize: 5,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order
	   }
	}
	
	/* 待办事项 */
	$("#handMessage").click(function (){
		parent.showHandMessage();
	});
	
	//待阅事项
	$("#readMessage").click(function (){
		parent.showReadMessage();
	});
	
});
//跳转到构建项目页面
function establishMent(id,projectId){
	var path="${_baseUrl}/document/projectInitialize?id="+id+"&projectId="+projectId;
	parent.skipModule("文档编写",path);
	//window.location.href=path;
}
function checkProject(id,projectId){
	var path="${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&id="+id;
	parent.skipModule("文档编写",path);
	//window.location.href=path;
}
function gotoProjectAndDocument(id,projectId){
	var path="${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&id="+id;
	parent.skipModule("文档编写",path);
	//window.location.href=path;
}
/* 跳转到文档编写 */
function skip(projectId){
	parent.skipModule("文档编写","${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId);
}
/* 下载文档模板 */
function checkFun(id){
	window.location.href="${_baseUrl}/docModel/checkDownload?id="+id;
}
</script>
</head>
<body>
<div class="delu_main home_main">
    	<div class="delu_list1">
        	<div class="fl workbench">
            	<div class="page_tit_warp wendfbku_tit mtmb20"><div class="page_tit mtmb20"><span>我的工作台</span></div></div>
            	<div class="workbench_cont">
                	<ul>
                		<li class="fl">
                        	<div class="workbench_li1">待办事项</div>
                            <div class="workbench_li3"><img src="${_resources}images/workbench_img1.png" alt="" ></div>
                            <span>${handleMessage }<i>件</i></span>
                            <div class="handle_btn ma"><a href="javascript:;" id="handMessage">立即处理</a></div>
                        </li>
                        <li class="fr">
                        	<div class="workbench_li1 workbench_li2">待阅事项</div>
                            <div class="workbench_li3"><img src="${_resources}images/workbench_img2.png" alt="" ></div>
                            <span>${readMessage }<i>件</i></span>
                            <div class="handle_btn ma"><a href="javascript:;" id="readMessage">立即处理</a></div>
                        </li>
                        <div class="clear"></div>
                	</ul>
                
                </div>
            
            </div>
            
            <div class="wendfbku">
            	<div class="wendfbku_c">
	            	<div class="page_tit_warp wendfbku_tit mtmb20"><a href="javascript:;"></a><div class="page_tit mtmb20"><span>文档范本库</span></div></div>
	                <div class="tablebox2 wdang_s">
	                    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="docModel">
	                    </table>
	          	    </div>
          		</div>
            </div>
        
        	<div class="clear"></div>
        </div>
    
    
    	<div class="delu_list2">
        	<div class="page_tit_warp mtmb20"><a href="javascript:;"></a><div class="page_tit mtmb20"><span>我的项目文档列表</span></div></div>
        	<div class="tablebox2 wdang_s bgenglist">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="documentList">
                        
                    </table>
          </div>
      </div>	
    </div>
	<div class="clear"></div>
</body>
</html>