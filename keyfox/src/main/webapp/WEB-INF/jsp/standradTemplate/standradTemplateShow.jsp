<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>自定义文档模板</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var standradTemplate;
var userId ="${userId}";
var userName ="${userName}";

function alterproperty(id){
	//returnAlterProperty
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'修改模板数据',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 500,
		width: 500,
		close:function(event,uri){
			refreshTable();	
		}
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentTemplateController/returnAlterProperty?documentId="+id);
	
}


function getTableData (status){
	
	standradTemplate = $("#standradTemplate").bootstrapTable({
		url : '${_baseUrl}/documentTemplateController/getstandradDocumentTemplate',
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
        },{
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
           
        },{
            field: 'documentTemplateName',
            title: '文档模板名称',
            width: 150,
            formatter : function(value, row, index) {
            	var str="";
        		str +="<a onClick=\"checkFun('"+row.id+"');\" title='"+value+"'  class=\"late_on_temp\">"+value+"</a>";  
			return str;
			}
            
        },{
            field: 'editer',
            title: '编写人',
            width: 100,
            visible:false
        	
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
            		if(row.editer==userName||row.editerId==userId||row.editer==userId){
	            		str +="<a onClick=\"alterproperty('"+row.id+"');\"  title='' class=\"late_on_temp\">未定义</a>"; 
            		}else{
            			str ="未定义";
            		}
            	}
            	return str;
            }
        },{
            field: 'documentType',
            title: '文档类型',
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
            	var jsonObj=eval('${documentTemplateSorts}');
    			if(jsonObj.length>0){
    				$.each(jsonObj, function (i, item) {
    					if(value != null){
        					if(value.indexOf(item.id)>=0){
        						if(str == ""){
        							str+=item.sortName;
        						}else{
        							str+=";"+item.sortName;
        						}
        						
        					}
    					}
    					
    			 	});
    			}
    			if(str.length==0){
            		if(row.editer==userName||row.editerId==userId||row.editer==userId){
	            		str +="<a onClick=\"alterproperty('"+row.id+"');\"  class=\"late_on_temp\">未定义</a>"; 
            		}else{
            			str ="未定义";
            		}
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
		    documentTemplateName:$("#docName").val()
	   }
	}
	
}

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

//添加模板分类数据
function addFun(){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'上传文档模板',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 340,
		width: 1100,   /* 此弹框大小同后续操作有关联   */
		close:function(event,uri){
			refreshTable();	
		}
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentTemplateController/openCreateDocumentTemplate?source=standrad");
	
}

//删除不符合规定的数据
function delBlankDocument(){
	var path="${_baseUrl}/documentTemplateController/delBlankDocument";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"type":"standrad"
			},    
			dataType:"json",    
			success: function (data) {   
				if(data.code=='1'){
					refreshTable();
				}else{return;}
			}   
	}); 
}


//删除模板分类数据
function deleteFun(){
	var objects =  $("#standradTemplate").bootstrapTable('getSelections');
	var id ="";
	for(var i =0;i<objects.length;i++){
		if(id.length>0){
			id+=","+objects[i].id;
		}else{
			id=objects[i].id;
		}
	}
	if(id.length==0){
		layer.msg("请先选择文档模板");
		return;
	}
	 var path="${_baseUrl}/documentTemplateController/delDocumentTemplate";
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
//查看文档模板信息
function checkFun(id){
	window.location.href="${_baseUrl}/documentTemplateController/previewTemplateDocument?id="+id;
}

function alterDoc(){
	var objects =  $("#standradTemplate").bootstrapTable('getSelections');
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
			layer.msg("请先选择文档");
			return;
		}
		if(judgeIfAlter(id)){
			$("#popIframe").empty();	
			$("#popDiv").dialog({
				title:'修改文档模板',
				autoOpen: true,
				modal: true,
				position:'top',
				height: 400,
				width: 600
			});	
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/documentTemplateController/returnAlter?documentId="+id);
		}else{
			layer.msg("不能修改他人模板");
			return;
		}
		
		
	}
	
}


function judgeIfAlter(id){
	var result =false;
	 var path="${_baseUrl}/documentTemplateController/judgeIfAlter";
	 $.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"documentId":id      
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
//回车
$(document).keyup(function(event){
	  if(event.keyCode == 13){
		  selectDocMessage();
	  }
});


function selectDocMessage(){
	standradTemplate.bootstrapTable('refresh',{url:'${_baseUrl}/documentTemplateController/searchDocumentTemplate?type=standrad'});
}


/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	standradTemplate.bootstrapTable('refresh');
}

</script>
</head>
<body>
     <div class="wdang_cont" style="display:block;">
       <div class="wdang_c" >
          <div class="wdang_dy" >
              <div class="fl wdang_dy_l" >
                   <dl >
                      <dt><input name="docName" id="docName" type="text" class="input_text2" value="请输入文档名称..." onFocus="if(this.value=='请输入文档名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入文档名称...';}"></dt>
                      <dd><input name="" value="搜索" type="button" onclick="selectDocMessage();" class="dyi_btna dyi_btnabox dyi_btna1"></dd>
                  </dl>
              </div>
               <div class="fr glqxian_btn wendmban_btn" >
               		<shiro:hasPermission name="documentTemplateController:openCreateDocumentTemplate_1">
				       <a href="javascript:;" class="glqxian_btn1 mr18 fl" onclick="addFun();">文档模板输入</a>
				    </shiro:hasPermission>
		           	<shiro:hasPermission name="documentTemplateController:delDocumentTemplate_1">
				       <a href="javascript:;" class="glqxian_btn1 mr18 fl" onclick="alterDoc();">修改</a>
				    </shiro:hasPermission>
				    <shiro:hasPermission name="documentTemplateController:returnAlter_1">
				       <a href="javascript:;" class="glqxian_btn1 fl" onclick="deleteFun();">删除</a>
				    </shiro:hasPermission>
				    
			   </div>
               <div class="clear"></div>
           </div>
          
           <div class="wdang_s" >
              	<table id="standradTemplate" class="tab-w-01 tab-w-auto"></table>         	
           </div>      	
                
		</div>     	
     
         <div id="popDiv" style="display: none; z-index: 2000;" >
			<iframe id="popIframe" border="0" frameborder="no"></iframe>
		</div> 
</body>
