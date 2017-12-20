<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>样式模板</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />

<script type="text/javascript">
var styleTemplate;
var userId ="${userId}";
var userName ="${userName}";
//样式文档数据分页展示
function getTableData(editer,source){	
	styleTemplate = $("#styleTemplate").bootstrapTable({
		url : '${_baseUrl}/styleTemplateController/getStyleTemplate',
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
             field: 'styleDocumentName',
             title: '样式文档名称',
             width: 100,
             formatter : function(value, row, index) {
            	var str="";
        		str +="<a onClick=\"documentDownload('"+row.id+"');\" title='"+value+"'  class=\"late_on_temp\">"+value+"</a>";  
				return str;
            }
             
         },{
            field: 'styleType',
            title: '样式类型',
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
            	
            	if(value=="outSet"){
            		str = "样式输出库";
            	}else{
            		if(value=="inSet"){
            			str = "样式定义库";
            		}
            	}
				return str;
			}
        },{
            field: 'editer',
            title: '编写人',
            visible:editer,
            width: 5,
             formatter : function(value, row, index) {
            	var str=value;
            	if(value=='sysadmin'){
            		str="初始化";
            	}
				return str;
            } 
        },{
            field: 'alertDate',
            title: '上传时间',
            width: 100
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    styleDocumentName:$("#docName").val()
	   }
	}
	
}
//判断登录人员是否是admin或者sysadmin
function getLoginInfo(){
	 var path="${_baseUrl}/documentTemplateController/returnLoginInfo";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,     
			dataType:"text",    
			success: function (data) {   
				
			    if(data=="true"||data==true){
			    	getTableData (true,false);
			    }else{
			    	getTableData (false,true);
			    }
			}   
		}); 
	
}

//判断当前登录时是否是文档编写人
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
	
});
//删除样式文档
function deleteFun(){
	var objects =  $("#styleTemplate").bootstrapTable('getSelections');
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
	 var path="${_baseUrl}/styleTemplateController/delStyleTemplate";
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
//下载样式文档
function documentDownload(id){
	window.location.href="${_baseUrl}/styleTemplateController/styleDownload?id="+id;
}

//设置样式文档为默认

function defaultStyle(id){
	var path="${_baseUrl}/styleTemplateController/styleTemplateDefault";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"id":id      
			},    
			dataType:"text",    
			success: function (data) {   
				layer.msg(data);
				refreshTable();			
			}   
	}); 
	
}
//上传样式文档
function addFun(){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'新增样式模板',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 380,
		width: 700  /* 修改弹框大小，便于提示框  */
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/styleTemplateController/styleTemplateDefine");
	
}

//取消样式文档的默认属性
function unDefaultStyle(id){
	var path="${_baseUrl}/styleTemplateController/cancelDefault";
	 $.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"id":id      
		},    
		dataType:"text",    
		success: function (data) {   	  
			layer.msg(data);
			refreshTable();			
		}   
	}); 
	
}
/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	styleTemplate.bootstrapTable('refresh');
}
//回车
$(document).keyup(function(event){
	  if(event.keyCode == 13){
		  selectStyleMessage();
	  }
});

function selectStyleMessage(){
	styleTemplate.bootstrapTable('refresh',{url:'${_baseUrl}/styleTemplateController/searchStyleTemplate'});
}
</script>

</head>
<body>
<div class="wdang_cont" style="display:block;">
       <div class="wdang_c" >
       		<div class="fl wdang_dy_l" >
                   <dl >
                     <dt><input name="docName" id="docName" type="text" class="input_text2" value="请输入样式文档名称..." onFocus="if(this.value=='请输入样式文档名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入样式文档名称...';}"></dt>
                      <dd><input name="" value="搜索" type="button" onclick="selectStyleMessage();" class="dyi_btna dyi_btnabox dyi_btna1"></dd>
                  </dl>
              </div>
       		<div class="glqxian_btn wendmban_btn" >
       			<shiro:hasPermission name="styleTemplateController:delStyleTemplate">
			       <a href="javascript:;" class="glqxian_btn1 fr" onclick="deleteFun();">删除</a>
			    </shiro:hasPermission>
       			<%-- <shiro:hasPermission name="styleTemplateController:styleTemplateDownload">
			       <a href="javascript:;" onclick="documentDownload();"   class="glqxian_btn1 mr18 fr">下载</a>
			    </shiro:hasPermission> --%>	           	
	            <shiro:hasPermission name="styleTemplateController:styleTemplateDefine">
			       <a href="javascript:;" onclick="addFun();" class="glqxian_btn1 mr18 fr">新增</a>
			    </shiro:hasPermission>
	            <div class="clear"></div>	            
            </div>	
            <div class="clear"></div>                    
           <div class="wdang_s mt30" >
              	<table id="styleTemplate" class="tab-w-01 tab-w-auto"></table>         	
           </div>      	
                
		</div>     	

         </div>
    <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>

</body>
</html>