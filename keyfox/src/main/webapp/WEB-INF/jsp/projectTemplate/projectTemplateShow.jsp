<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>项目模板类型定义</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var projectTemplate;
var userId ="${userId}";
var userName ="${userName}";
function getTableData (status){
	var  random= Math.random();
	projectTemplate = $("#projectTemplate").bootstrapTable({
		url : '${_baseUrl}/projectTemplateTypeController/getProjectTemplate?random='+random,
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
        columns: [{
        	 field: 'checked',
        	 checkbox:true,
        	 formatter : function(value, row, index) {
        		 if(userId=="sysadmin"||userId=="admin"){
               		 if(!(row.editer==userName||row.editerId==userId||row.editer==userId)){
                        		return {
                                    disabled: true
                                };
                        }else{
                        	return ;
                        }
               	 }else{
               		 if(row.editerId !=null){
               			if(!((row.editer==userName)&&row.editerId ==userId)){
    	                		return {
    	                            disabled: true
    	                        };
    	                	}else{
    	                		return;
    	                	}
               		 }else{
               			 if(!(row.editer==userName)){
     	                		return {
     	                            disabled: true
     	                        };
     	                	}else{
     	                		return;
     	                	}
               		 }
                   }
               }
         }, {
             field: 'editerId',
             title: 'editerId',
             visible:false,
             width: 5
         }, {
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'projectTemplateName',
            title: '项目模板类型名称',
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
            		str +="<a onClick=\"checkFun('"+row.id+"');\"  title='"+value+"' class=\"late_on_temp\">"+value+"</a>";  
				return str;
			}
        },{
            field: 'applicationScope',
            title: '适用范围',
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
            	var jsonObj=eval('${applicableScopes}');
    			if(jsonObj.length>0){
    				$.each(jsonObj, function (i, item) {
    					if(value !=null){
	    					if(value.indexOf(item.id)>=0){
	    						str+=item.scopeName;
	    					}
    					}
    			 	});
    			}
            	if(str.length==0){
            		return "未定义";
            	}else{
					return str;
            	}
            }
        },{
            field: 'editer',
            title: '编写人',
            width: 100,
            formatter : function(value, row, index) {
            	var str=value;
            	if(value=='sysadmin'){
            		str="初始化";
            	}
				return str;
            }
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    projectTemplateName:$("#docName").val()
	   }
	}
	
}
//回车
$(document).keyup(function(event){
	  if(event.keyCode == 13){
		  selectProMessage();
	  }
});

function selectProMessage(){
	projectTemplate.bootstrapTable('refresh',{url:'${_baseUrl}/projectTemplateTypeController/searchProTemplate'});
}


//判断登录人是否admin或sysadmin
function getLoginInfo(){
	 var path="${_baseUrl}/documentTemplateController/returnLoginInfo";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,     
			dataType:"text",    
			success: function (data) {   
				
			    if(data=="true"||data==true){
			    	getTableData (true);
			    }else{
			    	getTableData (false);
			    }
			}   
		}); 
	
}

function alterPro(){
	random= Math.random();
	var objects =  $("#projectTemplate").bootstrapTable('getSelections');
	var id ="";
	if(objects.length>1){
		layer.msg("只能修改一个模板",{time:1500});
		return;
	}else{
		for(var i =0;i<objects.length;i++){
			if(id.length>0){
				id+=","+objects[i].id;
			}else{
				id=objects[i].id;
			}
		}
		if(id.length==0){
			layer.msg("请先选择项目模板");
			return;
		}
		if(judgeIfAlter(id)){
			$("#popIframe").empty();	
			$("#popDiv").dialog({
				title:'修改项目模板信息',
				autoOpen: true,
				modal: true,
				position:'top',
				height: 500,
				width: 800
			});	
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/projectTemplateTypeController/returnAlter?projectTemplateId="+id+"&random"+random);
		}else{
			layer.msg("不能修改他人模板");
			return;			
		}
		
	}
	
}
//判断是否可以修改
function judgeIfAlter(id){
	var result =false;
	var  random= Math.random();
	 var path="${_baseUrl}/projectTemplateTypeController/judgeIfAlter?random="+random;
	 $.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"id":id      
		},    
		dataType:"json",    
		success: function (data) {   
			if(data.code=='1'){
				result = true;
			}else{
				result =false;
			}
		}   
	}); 
	
	return result;
}



//判断当前人员是否为编写人
function judgeCurrentUse(name){
	var  userName = "${userName}";
	if(userName==name){
		return true;
	}else{
		return false;
	}
}

$(function(){	
	getLoginInfo();
	
})
//删除项目模板类型
function deleteFun(){
	var objects =  $("#projectTemplate").bootstrapTable('getSelections');
	var id ="";
	for(var i =0;i<objects.length;i++){
		if(id.length>0){
			id+=","+objects[i].id;
		}else{
			id=objects[i].id;
		}
	}
	if(id.length==0){
		layer.msg("请先选择项目文档模板");
		return;
	}
	 var path="${_baseUrl}/projectTemplateTypeController/delProjectTemplate";
	 $.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"id":id      
		},    
		dataType:"json",    
		success: function (data) {   
			layer.msg(data.message,{shift:5,time:1500});
			refreshTable();		
		}   
	}); 
}
//新增项目模板类型
function addFun(){
	var  random= Math.random();
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'创建项目模板类型',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 500,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/projectTemplateTypeController/openCreateProjectTemplate?random="+random);
	
}
//查看项目模板类型信息
function checkFun(id){
	var  random= Math.random();
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'查看项目模板类型信息',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 500,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/projectTemplateTypeController/checkProjectTemplate?id="+id+"&random="+random);
}

//新建需求追踪关系
function addDemandTrace(id){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'新建需求追踪',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 500,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/demand/showAddDemandTrace?templateId="+id+"&random="+Math.random());
}

/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	projectTemplate.bootstrapTable('refresh');
}
</script>

</head>
<body>
<div class="wdang_cont" style="display:block;">
       <div class="wdang_c" >
       	<div class="fl wdang_dy_l" >
                   <dl >
                     <dt><input name="docName" id="docName" type="text" class="input_text2" value="请输入项目模板名称..." onFocus="if(this.value=='请输入项目模板名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入项目模板名称...';}"></dt>
                      <dd><input name="" value="搜索" type="button" onclick="selectProMessage();" class="dyi_btna dyi_btnabox dyi_btna1"></dd>
                  </dl>
          </div>
          <div class="glqxian_btn wendmban_btn" >
          	 <shiro:hasPermission name="projectTemplateTypeController:delProjectTemplate">
		        <a href="javascript:;" class="glqxian_btn1 fr" onclick="deleteFun();">删除</a>
		     </shiro:hasPermission>
         	 <shiro:hasPermission name="projectTemplateTypeController:openCreateProjectTemplate">
		        <a href="javascript:;" onclick="alterPro();"   class="glqxian_btn1 mr18 fr">修改</a>
		     </shiro:hasPermission>
		     <shiro:hasPermission name="projectTemplateTypeController:returnAlter">
		        <a href="javascript:;" onclick="addFun();"   class="glqxian_btn1 mr18 fr">新增</a>
		     </shiro:hasPermission>
             <div class="clear"></div>
          </div>
            
           <div class="wdang_s mt30 " >
              	<table id="projectTemplate" class="tab-w-01 tab-w-auto"></table>         	
           </div>      	
                
		</div>     	
         </div>
    <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>
</body>	
</html>