<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">  
<title>自定义文档模板</title>
<%@include file="/WEB-INF/jsp/common/inc.jsp"%>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css">
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css">
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css">

<script type="text/javascript">
var defineTemplate;
var userId ="${userId}";
var userName ="${userName}";
var documentTemplateSorts = '${documentTemplateSorts}';
var applicableScopes = '${applicableScopes}' ;
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
			getProData();
			refreshTable();	
		}
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentTemplateController/returnAlterProperty?documentId="+id);
	
}




function getTableData (status){
	
	defineTemplate = $("#defineTemplate").bootstrapTable({
		url : '${_baseUrl}/documentTemplateController/getDocumentTemplate',
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
            width: 10
        },{
            field: 'documentTemplateName',
            title: '文档模板名称',
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
            	var jsonObj=eval(applicableScopes);
  				if(value !=null){
	    			if(jsonObj.length>0){
	    				$.each(jsonObj, function (i, item) {
    						if(value.indexOf(item.id)>=0){
        						str+=item.scopeName;
        					}
	    			 	});
	    			}
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
        },{
            field: 'documentType',
            title: '文档类型',
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
            	var jsonObj=eval(documentTemplateSorts);
    			if(value !=null){
	    			if(jsonObj.length>0){
	    				$.each(jsonObj, function (i, item) {
	    					if(value.indexOf(item.id)>=0){
	    						if(str == ""){
        							str+=item.sortName;
        						}else{
        							str+=";"+item.sortName;
        						}
	    					}
	    					
	    			 	});
	    			}
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
        },
        {
            field: 'templateStatus',
            title: '模板状态',
            width: 100,
            formatter : function(value, row, index) {
				if ("1"== value) {
					return "启用";
				}else{
					return "禁用";
				}
			}
        },	
        {
            field: 'editer',
            title: '编写人',
            width: 100,
            visible:status
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

function getProData(){
	var path="${_baseUrl}/documentTemplateController/getProData";
	$.ajax({
		type: "POST",    
		async: false,    
		url:path,     
		dataType:"json",    
		success: function (json) {   
			documentTemplateSorts = json.data;
        	applicableScopes = json.message ;
		}   
	})
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


function deleteFun(){
	var objects =  $("#defineTemplate").bootstrapTable('getSelections');
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
				layer.msg(data.message,{shift:5,time:3000});
				refreshTable();		
			}   
		}); 
}
function addFun(){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'上传文档模板',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 340,
		width: 1100,    /* 此弹框大小同后续操作有关联  */
		close:function(event,uri){
			getProData();
			refreshTable();	
		}
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentTemplateController/openCreateDocumentTemplate?source=define");
	
}

function completeFun(id){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'新增文档模板',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 300,
		width: 1050,
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentTemplateController/completeDocumentTemplate?id="+id);
	
}

function delBlankDocument(){
	var path="${_baseUrl}/documentTemplateController/delBlankDocument";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"type":"define"
			},    
			dataType:"json",    
			success: function (data) {   
				if(data.code=='1'){
					refreshTable();
				}else{return;}
			}   
	}); 
}

function checkFun(id){
	window.location.href="${_baseUrl}/documentTemplateController/previewTemplateDocument?id="+id;
}

function useStatus(status){
	var objects =  $("#defineTemplate").bootstrapTable('getSelections');
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
	var path="${_baseUrl}/documentTemplateController/useDocumentTemplate";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"id":id,
				"status":status
			},    
			dataType:"json",    
			success: function (data) {   
				layer.msg(data.message);
				refreshTable();	
			}   
	}); 
}
//判断文档模板是否已经被项目模板禁用
function judgeProjectDocument(){
	var objects =  $("#defineTemplate").bootstrapTable('getSelections');
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
	var path="${_baseUrl}/documentTemplateController/judgeDocumentUseStatus";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"id":id,
		},    
		dataType:"json",    
		success: function (json) { 
			if(json.code=='1'){
				var jsonObj=eval("("+json.message+")");
				var options="";
				if(jsonObj.length>0){
					$.each(jsonObj, function (i, item) {
						if(options.length>0){
							options+=",《"+item.documentTemplateName+"》";
						}else{
							options = "《"+item.documentTemplateName+"》";
						}
						
				 	});
				}
				options+="已在项目中使用，不能禁用 ";
				layer.msg(options,{shift:5,time:2000},function(){
					return;
				});
				
			}
			if(json.code=='2'){
				var jsonObj=eval("("+json.message+")");
				var options="";
				if(jsonObj.length>0){
					$.each(jsonObj, function (i, item) {
						if(options.length>0){
							options+=",《"+item.documentTemplateName+"》";
						}else{
							options = "《"+item.documentTemplateName+"》";
						}
						
				 	});
				}
				options+="已在项目中使用，不能禁用 ";
				layer.msg(options,{shift:5,time:2000},function(){
					return;
				});
				
			}else{
				useStatus("0");
			}
		}   
	}); 
	
}



//文档分类管理
function defineTemplateSort(){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'文档模板分类管理',
		autoOpen: true,
		modal: true,
		position:'top',
		height:450,
		width: 500,
		close:function(event,uri){
			getProData();
			refreshTable();	
		}
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","100%");
	$("#popIframe").attr("src","${_baseUrl}/templateSortController/showTemplateSort");
	
}
//设置文档分类
function setTemplateSort(){
	var objects =  $("#defineTemplate").bootstrapTable('getSelections');
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
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'选择文档模板分类',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 400,
		width: 400,
		close:function(event,uri){
			refreshTable();	
		}
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","100%");
	$("#popIframe").attr("src","${_baseUrl}/templateSortController/setTemplateSort?id="+id);
	
	
}
$(document).keyup(function(event){
	  if(event.keyCode == 13){
		  defineTemplate.bootstrapTable('refresh',{url:'${_baseUrl}/documentTemplateController/searchDocumentTemplate?type=define'});
	  }
});

function selectDocMessage(){
	defineTemplate.bootstrapTable('refresh',{url:'${_baseUrl}/documentTemplateController/searchDocumentTemplate?type=define'});
}


/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	defineTemplate.bootstrapTable('refresh');
}

</script>
</head>
<body>
	<div class="wdang_cont" style="display:block;">
       <div class="wdang_c">
          <div class="wdang_dy">
              <div class="fl wdang_dy_l">
                   <dl>
                     <dt><input name="docName" id="docName" type="text" class="input_text2" value="请输入文档名称..." onFocus="if(this.value=='请输入文档名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入文档名称...';}"></dt>
                      <dd><input name="" value="搜索" type="button" onclick="selectDocMessage();" class="dyi_btna dyi_btnabox dyi_btna1"></dd>
                  </dl>
              </div>
              <div class="fl wdang_dy_t">
	              <shiro:hasPermission name="templateSortController:showTemplateSort">
			         <a href="javascript:;" onclick="defineTemplateSort();">文档模板分类定义</a>
			      </shiro:hasPermission>
              </div>
               
               
          
	           <div class="fr glqxian_btn wendmban_btn">
	           		<shiro:hasPermission name="documentTemplateController:openCreateDocumentTemplate">
				        <a href="javascript:;" class="glqxian_btn1 mr18 fl" onclick="addFun();">文档模板输入</a>
				    </shiro:hasPermission>
	           		<shiro:hasPermission name="documentTemplateController:useDocumentTemplate">
				        <a href="javascript:;" class="glqxian_btn1 mr18 fl" onclick="useStatus('1');">启用</a>
				    </shiro:hasPermission>
	            	<shiro:hasPermission name="documentTemplateController:judgeDocumentUseStatus">
				        <a href="javascript:;" class="glqxian_btn1 mr18 fl" onclick="judgeProjectDocument()">禁用</a>
				    </shiro:hasPermission>
	            	<shiro:hasPermission name="templateSortController:setTemplateSort">
				        <a href="javascript:;" class="glqxian_btn1 mr18 fl" onclick="setTemplateSort();">分类</a>
				    </shiro:hasPermission>
	            	<shiro:hasPermission name="documentTemplateController:delDocumentTemplate">
				        <a href="javascript:;" class="glqxian_btn1 fl" onclick="deleteFun();">删除</a>
				    </shiro:hasPermission>
				</div>
	            <div class="clear"></div>
           </div> 
           <div class="wdang_s">
              	<table id="defineTemplate" class="tab-w-01 tab-w-auto"></table>         	
           </div>      	
                
		</div>     	

         </div>
    <div id="popDiv" style="display: none;overflow: hidden; ">
		<iframe id="popIframe" border="0" frameborder="no" ></iframe>
	</div>
         
</body>
</html>