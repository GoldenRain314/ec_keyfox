<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档新增</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var documentList;
var projectId = "${projectId}";
var userName = "${userName}";
var ids = "${ids}";
var i = ids.split(":");
$(function (){
	$("#projectId").val(projectId);
	$('input:radio[name=documentSelect]').click(function () { 
		  sel = $('input:radio[name=documentSelect]:checked').val();
		  if(sel == "new"){
			  $("#documentTemplate").hide();
			  $("#newDocument").show();
		  }else{
			  $("#documentTemplate").show();
			  $("#newDocument").hide();
			  selectByTemplateName();
			  
		  }
	});
	documentList = $("#documentList").bootstrapTable({
		url : '${_baseUrl}/documentList/getDocumentFormTemplate?ids='+i[0]+'&number='+Math.random(),
		pagination: true,
		pageList: [80],
  		queryParams: queryParams,
  		rowStyle: rowStyle,
  		columns: [{
       	 field: 'checked',
         checkbox: true,
         formatter:function(value, row, index) {
       		 if(i[0].indexOf(row.id) >= 0){
       			 return {
                        checked: true
                    }
       		 }
       		 if(row.templateStatus == '0'){
       			 return {
       				disabled: true
       			 }
       		 }
             return value;
          }
     	},{
           field: 'id',
           title: 'id',
           visible:false,
           width: 5
       },{
            field: 'documentTemplateName',
            title: '文档模板名称',
            width: 100
        },{
            field: 'documentType',
            title: '文档类型',
            width: 100,
            formatter : function(value, row, index) {
            	if(row.source == "文档范本库"){
            		return  value;
            	}
            	var str="";
            	var jsonObj=eval('${documentTemplateSorts}');
    			if(jsonObj.length>0){
    				$.each(jsonObj, function (i, item) {
    					if(value !=null){
	    					if(value.indexOf(item.id)>=0){
	    						if(str ==""){
		    						str+=item.sortName;
	    						}else{
	    							str+=";"+item.sortName;
	    						}
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
            field: 'applicationScope',
            title: '适用范围',
            width: 100,
            formatter : function(value, row, index) {
            	if(row.source == "文档范本库"){
            		return  value;
            	}
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
            field: 'source',
            title: '文档模板来源',
            width: 100,
            formatter:function(value, row, index) {
          		 if(value == '初始化'){
          			 return "标准文档模板";
          		 }else if(value == '自定义'){
          			 return "自定义文档模板";
          		 }else{
          			 return value;
          		 }
             }
        }]
    });
	function rowStyle(row, index) {
		if(row.templateStatus == 0){
			return {
			    //classes: 'text-nowrap another-class',
			    css: {"color": "#CACAC4"}
			  };
		}else{
			return {
			    
			  };
		}
			
	}
	function queryParams(params){
		return {
		    pageSize: 80,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    documentTemplateName:$("#selectByTemplateName").val(),
		    source:$("#document_source").val(),
	   }
	}
	
})
function deleteDocument(){
	var objects =  $("#documentList").bootstrapTable('getSelections');
	if(objects.length==0){
		layer.msg("您还没有选择一个要删除的文档");
		return;
	}
	var obj = JSON.stringify(objects);
	var jsonObj = eval("("+obj+")");
	var ids = new Array();
	for(var i=0;i<ids.length;i++){
		ids[i] = jsonObj[i].id;
	}
	$.ajax({
		url:'${_baseUrl}/documentList/deleteDocumentById?ids='+ids,
		type:'post', //数据发送方式 
		dataType:'text', //接受数据格式 
		async: false,
		success: function(data){
			if(data == "true"){
				layer.msg("删除成功");
				window.location.reload(true);
			}
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
}
function addDocument(){
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'文档列表',
		autoOpen: true,
		modal: true,	
		height: 550,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentList/addProjectDocument?projectId="+projectId);
}
function saveTemplateDocument(){
	$("#save_template").attr("onclick","");
	var objects =  $("#documentList").bootstrapTable('getSelections');
	if(objects.length==0){
		layer.msg("您必须选择一个文档");
		return;
	}
	var obj = JSON.stringify(objects);
	$.ajax({
		url:'${_baseUrl}/documentList/saveTemplateDocument',
		data:{"obj":obj,"projectId":projectId,"ids":ids},
		type:'post', //数据发送方式 
		dataType:'text', //接受数据格式 
		async: false,
		success: function(data){
			if(data == "true"){
				layer.msg("保存成功");
				parent.window.location.reload(true);
			}
        },
		error:function(){
			layer.msg( "系统错误");
		}
		
	});
}
function saveNewDocument(){
	$("#submit").attr("onclick","");
	if($("#newProjectDocument").validationEngine('validate')){
		var options = {
				dataType:"json",
				success:function(json){
					if(json.code == '1'){
						$("#submit").removeAttr('onclick');
						layer.msg(json.message,{shift:2},function(){
							parent.refreshWin();
							parent.closeWin();
						});
					}
					if(json.code == '0'){
						$("#submit").attr("onclick","saveNewDocument()");
						layer.msg(json.message);
					}
				},
				error:function(json){
					$("#submit").attr("onclick","saveNewDocument()");
					layer.msg("发生错误");
				}
			};
		$('#newProjectDocument').ajaxSubmit(options);
	}else{
		$("#submit").attr("onclick","saveNewDocument()");
	}
}
function selectByTemplateName(){
	documentList.bootstrapTable('refresh');
}
function isOrHaveTemplateName(){
	var templateName = $("#templateName").val();
	var projectId = "${projectId}";
	$.ajax({
		url:'${_baseUrl}/documentList/isOrHaveTemplateName',
		data:{"templateName":templateName,"projectId":projectId},
		type:'post', //数据发送方式 
		dataType:'text', //接受数据格式 
		async: false,
		success: function(data){
			if(data == "have"){
				$("#templateName").val("");
				layer.msg( "该文档名称已经存在！");
			}
        },
		error:function(){
			layer.msg( "系统错误");
		}
		
	});
}

/* 根据活动类型查询活动名称 */
function showActionName(){
	var actionTypeId = $("#activeType").val();
	$.ajax({
		url:'${_baseUrl}/documentList/getActiveNameByActiveId',
		data:{"actionTypeId":actionTypeId},
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		async: false,
		success: function(data){
			var activeNameList = data.selectByActiveName;
			var options = "<option value='choice'>---请选择---</option>";
			for(var i=0;i<activeNameList.length;i++){
				options += "<option value='"+activeNameList[i].id+"'>"+activeNameList[i].activeName+"</option>";
			}
			$("#activeName").empty();
			$("#activeName").append(options);
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
	
}

 document.onkeydown=function(event) 
{ 
	e = event ? event :(window.event ? window.event : null); 
	if(e.keyCode==13){ 
		return false;
	} 
}  

 
$(function(){
	 $("#selectByTemplateName").keydown(function(event){
	 	e = event ? event :(window.event ? window.event : null); 
		if(e.keyCode==13){ 
			selectByTemplateName();
		} 
	});
})
 

$(function(){
	var result = false;
	var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var isOpera = userAgent.indexOf("Opera") > -1;

	if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
		result =  true;
	}; 
	
	if(!result){
		$.each($("input"),function(){
			$(this).css("margin-top","-2px");			
		})
	}
})





</script>
</head>
<body>

    <div class="xmugonj_cont ma wdang_c0803" style="display:block;">
         <div class="xmugonj_t_x xmugonj_t_x2">
               文档模板：           
               <input type="radio" name="documentSelect" style=""  id="radio" value="template" checked="checked"> 从文档模板库选择  <input type="radio" name="documentSelect" id="radio" value="new"> 新建空白文档
          </div>
          
          <div class="xmugonj_ta_j wendlist_a widthauto mt20 mb20" id="documentTemplate">
          <div class="wdang_dy_l" >
           <dl class="xmugonj_dl">
           		 <dt style="width:75px; line-height:31px;">文档状态：</dt>
                  <dd>
                      <select class="xmugonj_selecta" id="document_source" onchange="selectByTemplateName();">
                     	<option value="choice">请选择文档模板来源</option>
                        <option value="1">标准文档模板</option>
                        <option value="2">自定义文档模板</option>
                        <option value="3">文档范本库</option>
                    </select>
                  </dd>
              </dl>
              <dl>
                 <dt><input name="" type="text" id="selectByTemplateName" class="input_text2" value="请输入文档模板名称..." onFocus="if(this.value=='请输入文档模板名称...'){this.value=''}"   onBlur="if(this.value==''){this.value='请输入文档模板名称...';}"></dt>
                 <dd><span><input name="" value="搜索" type="button" onclick="selectByTemplateName();" class="dyi_btna dyi_btnabox dyi_btna1"></span></dd>
              </dl>
             
          </div>
          		<div class="mt20" >
           	    	<table id="documentList" class="tab-w-01 tab-w-auto"></table>
           	    </div>
           	     <div class="permission_an xmugonj_bc ma">
           	     	<shiro:hasPermission name="documentList:saveTemplateDocument">
			            <a href="javascript:;" class="per_baocun" id="save_template" onclick="saveTemplateDocument();">保 存</a>
			        </shiro:hasPermission>	
                   
         		 </div>   
          </div>
          <div class="jbinformation roleshux mt20" id="newDocument" style="display:none;">
              <form name ="newProjectDocument" id="newProjectDocument" action="${_baseUrl}/documentList/saveNewDocument" method="post">
				<table width="723" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="150" height="50" align="center" bgcolor="#f7f4f4">工作产品名称</td>
					    <td width="187" valign="top"><div class="jbxinxi_s" style="width:289px;">
					    	<input type="text" name="templateName" id="templateName" class="jbxinxi_input validate[maxSize[50] required]"  onblur="isOrHaveTemplateName();" style="width:282px;"></div><div class="jbxinxi_span1">*</div>
					    </td>
					  </tr>
					  <tr>
						<td width="150" height="50" align="center" valign="middle" bgcolor="#f7f4f4">活动类型</td>
					    <td width="230" valign="top">
					    <div class="jbxinxi_s" style="width:289px;">
					    	<select class="xmugonj_select" id="activeType" name="activeType" style="width:289px;" onchange="showActionName()">
					    		<option value="choice">---请选择---</option>
					    		<c:forEach items="${actionTypeList }" var="obj">
						    		<option value="${obj.id }">${obj.activeType }</option>
					    		</c:forEach>
					    	</select>
			            </div>
			                    
			            </td>
					  </tr>
					  <tr>
					    <td height="50" align="center" bgcolor="#f7f4f4">活动名称</td>
					    <td valign="top">
					    <div class="jbxinxi_s" style="width:289px;">
					    	<select class="xmugonj_select" id="activeName" name="activeName" style="width:289px;">
					    		<option value="choice">---请选择---</option>
								<option value="质量管理活动">质量管理活动</option>
								<option value="配置管理轰动">配置管理轰动</option>
					    	</select>
					    </div>
					    </td>
					  </tr>
					  <input type="hidden" name = "projectId" id="projectId"/>
				</table>
			</form>
				<div class="permission_an xmugonj_bc ma">
					
          		</div>
				<div class="permission_an xmugonj_bc ma">
					<shiro:hasPermission name="documentList:saveNewDocument">
			            <a href="javascript:;" class="per_baocun" id="submit" onclick="saveNewDocument();">保 存</a>
			        </shiro:hasPermission>	
          		</div>
		  </div>
         
    </div>
	<div class="clear"></div>
</body>
</html>
