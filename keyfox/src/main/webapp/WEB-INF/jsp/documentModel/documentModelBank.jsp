<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>文档模板库</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var docModel=null;
var modelType=null;
var docScope=null;
var docType=null;
var applicableStandrad=null;
var jsonObj=eval('(${listDtApplication})');
var jsonType = eval('(${listDocumentType})');
var jsonStand = eval('(${listStandardLibrary})');
$(function(){	
	var  random= Math.random();
	var  judeUser = ${userId == 'sysadmin'};    /* 判断用户是否为sysadmin显示复选框   */
	
	docModel = $("#docModel").bootstrapTable({
		url : '${_baseUrl}/docModel/selectModel?random='+random,
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
        columns: [{
        	field: 'checked',
        	width: 5,
        	visible: (judeUser)?true:false,
            checkbox: true,
            
        },{
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'modelType',
            title: '范本类型',
            width:150,
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
            width: 100,
            formatter : function(value, row, index) {
            	var str="";
            	str +="<a onClick=\"checkFun('"+row.id+"');\"  title='"+value+"' class=\"titlea_md\">"+value+"</a>";
				return str;
            }
        },{
            field: 'documentType',
            title: '文档类型',
            width: 100,
        },{
            field: 'applicableScope',
            title: '适用范围',
            width: 100,
            visible:false
            
        },{
            field: 'applicableStandrad',
            title: '适用标准',
            width: 200,
            formatter : function(value, row, index) {
            	var str="";
            	str +="<label  title='"+value+"' class=\"titlea_md_asp\">"+value+"</label>";
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
		    modelName:$("#docName").val(),
		    applicableStandrad:$("#applicableStandrad").val()
	   }
	}
})

function checkFun(id){
	window.location.href="${_baseUrl}/docModel/checkDownload?id="+id;
}
//添加文档范本
function addFun(){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'新增文档范本',
		autoOpen: true,
		modal: true,	
		height: 500,
		width: 700
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/docModel/addModelPage");			
}
//获取下拉框的值
function paramValue(i,value){
	if(value !="请选择"){
		if(i=="1"){                      //范本类型
			modelType =value;
		}else if(i=="2"){                //使用范围
			docScope = value;
		}else if(i=="3"){                //文档类型
			docType = value;
		}else{                           //使用标准
			applicableStandrad = value;
		}
		refreshTable();
	}else{
		if(i=="1"){
			modelType =null;
		}else if(i=="2"){
			docScope = null;
		}else if(i=="3"){
			docType =null;
		}else{
			applicableStandrad = null;
		}
		refreshTable();
	}
}
//删除
function deleteFun(){
	var objects =  $("#docModel").bootstrapTable('getSelections');
	var id ="";
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
	 var path="${_baseUrl}/docModel/delModel";
	 $.ajax({    
		type: "POST",    
		async: false,    
		url:path,   
		data:{
			"id":id      
		},    
		dataType:"json",    
		success: function (json) {   
			layer.msg(json.message,{shift:5,time:1500});
			refreshTable();		
		}   
	}); 
	
}
/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}
function refreshTable(){
	docModel.bootstrapTable('refresh',{url:"${_baseUrl}/docModel/selectModel?modelType="+modelType+"&docType="+docType+"&docScope="+docScope+"&applicableStandrad="+applicableStandrad});
}

$(function(){
	
	var options="";
	if(jsonObj.length>0){
		options+="<option>请选择</option>";
		$.each(jsonObj, function (i, item) {
			options+="<option value='"+item.id+"'>"+item.application+"</option>";
	 	});
	}
	$("#documentScope").html(options);
	var optionsType="";
	if(jsonObj.length>0){
		optionsType+="<option>请选择</option>";
		$.each(jsonType, function (i, item) {
			optionsType+="<option value='"+item.id+"'>"+item.documentType+"</option>";
	 	});
	}
	$("#documentType").html(optionsType);
	var optionsStand="";
	if(jsonStand.length>0){
		optionsStand+="<option>请选择</option>";
		$.each(jsonStand, function (i, item) {
			optionsStand+="<option value='"+item.id+"'>"+item.documentName+"</option>";
	 	});
	}
	$("#applicableStandrad").html(optionsStand);
}) 

document.onkeydown=function(event) 
{ 
	e = event ? event :(window.event ? window.event : null); 
	if(e.keyCode==13){ 
		selectDocMessage(); 
	} 
} 


function selectDocMessage(){
	refreshTable();
}


</script>
<body>
     <div class="ma main">
    	<div class="wdang_main"  >
        	<!-- <div class="page_tit_warp mtmb20"><div class="page_tit"><span>文档范本库</span></div></div> -->
        	<div class="xmugonj_bz xmulist_bz plpr37 wdfbkbox">
                <dl>
                    <dt>范本类型：</dt>
                    <dd>
                      <select class="xmugonj_select" id="modelType" onchange="paramValue(1,this.options[this.options.selectedIndex].value)">
                      	<option >请选择</option>	
						<option value="guide">编写指南</option>
						<option value="explain">编写说明</option>
						<option value="example">编写示例</option>    
                      </select>
                    </dd>
                    <div class="clear"></div>
                </dl>
                <dl style="display: none;">
                    <dt>适用范围：</dt>
                    <dd>
                        <select class="xmugonj_select"  id="documentScope" onchange="paramValue(2,this.options[this.options.selectedIndex].value)">
							
                      </select>
                    </dd>
                    <div class="clear"></div>
                </dl>
                <dl style="display：inline;">
                    <dt>文档类型：</dt>
                    <dd>
                        <select class="xmugonj_select"  id="documentType" onchange="paramValue(3,this.options[this.options.selectedIndex].value)">
							
                      </select>
                    </dd>
                    <div class="clear"></div>
                </dl>
                 <dl style="display：inline;">
                    <dt>适用标准：</dt>
                    <dd>
                        <select class="xmugonj_select"  id="applicableStandrad" onchange="paramValue(4,this.options[this.options.selectedIndex].value)">
							
                      </select>
                    </dd>
                    <div class="clear"></div>
                </dl>  
                <div class="fl xmulist2_ss">
                	<p><input name="docName" id="docName" type="text" class="input_text xmulist2_input" value="请输入文档名称..." onFocus="if(this.value=='请输入文档名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入文档名称...';}"></p>
                    <span><input name="" value="搜索" type="button" onclick="selectDocMessage();" class="dyi_btna dyi_btnabox dyi_btna1"></span>
                </div>
                <c:if test="${userId == 'sysadmin'}">
                	<div class=" fr glqxian_btn wendmban_btn">
			            <a href="javascript:;" onclick="addFun();"   class="glqxian_btn1 mr18 fl">新增</a>
			            <a href="javascript:;" class="glqxian_btn1 fl" onclick="deleteFun();">删除</a>
			        </div> 
                </c:if>
                
                <div class="clear"></div>
            </div>         
           <div class="tablebox2 wdang_s bgenglist">
          	<table id="docModel" class="tab-w-01 tab-w-auto"></table>  
            </div>
        </div>
    </div>
     <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>   
</body>
</html>