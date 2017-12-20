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
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">

var selectDoc ;
var selectDocId ="";

$(function(){
	selectDoc = eval('(${proDocJson})');
	$.each(selectDoc, function (i, item) {
		if(selectDocId.length==0){
			selectDocId = item.id;
		}else{
			selectDocId +=","+item.id;
		}
	});
	
	$("#documentId").val(selectDocId);

})



//新增适用范围
function selectCreate(value){
	if(value=="newCreate"){
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'创建项目模板类型',
			autoOpen: true,
			modal: true,	
			height: 300,
			width: 430
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/applicableScopeController/newApplicableScope");		
	}
}

function getApplicationScope(){
	var path="${_baseUrl}/applicableScopeController/SelectAllApplicableScope";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,
		dataType:"json",    
		success: function (data) {   
			var jsonObj=eval("("+data.message+")");
			var options="";
			if(jsonObj.length>0){
				options+="<option>请选择</option>";
				$.each(jsonObj, function (i, item) {
					options+="<option value='"+item.scopeName+"'>"+item.scopeName+"</option>";
			 	});
			}
			$("#applicationScope").html(options);
			
		}   
	}); 		
	
}
//验证样式输出文档
function checkSelectOut(){	
	var select = $("select[name='styleOutTemplate']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			var value = $(options[i]).val();
			if(value=="请选择"){
				return "请选择样式输出模板";
			}else{
				return true;
			}
		}
	}
	
}
//验证样式定义文档
function checkSelectSet(){	
	var select = $("select[name='styleSetTemplate']");
	var options = $(select).find("option");
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			var value = $(options[i]).val();
			if(value=="请选择"){
				return "请选择样式定义模板";
			}else{
				return true;
			}
		}
	}
	
}
//验证适用范围的下拉框
function checkSelectScope(){	
	var select = $("select[name='applicationScope']");
	var options = $(select).find("option");
	var value="";
	for(var i =0;i<options.length;i++){
		if($(options[i]).prop("selected")=="selected"||$(options[i]).prop("selected")==true){
			value = $(options[i]).val();
			
		}
	}

	if(value=="请选择"){
		return "请选择适用范围";
	}else{
		return true;
	}
}


//选中复选框之后将文档id存储到input中，提交到后台去
function selectDocument(){	
	var inputs =$("input:checked");
	var documentId ="";
	for(var i =0;i<inputs.length;i++){
		if(documentId.length==0){
			documentId=$(inputs[i]).val();
		}else{
			documentId+=","+$(inputs[i]).val();
		}
	}	
	
	$("#documentId").val(documentId);
	
}

//取消和关闭调用的方法
function cancelAndClose(){
	parent.closeWin();
}

$(function(){
	$("#form").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomLeft',//提示信息的位置
		inlineValidation: true,//是否即时验证，false为提交表单时验证,默认true  
		failure : function() {
		    layer.message("验证失败，请检查");
			return false;  
		},//验证失败时调用的函数
		ajaxFormValidation: true,//开始AJAX验证
		success : function() {
		//	$("#addForm").submit();
		}//验证通过时调用的函数 
		//onAjaxFormComplete: ajaxValidationCallback
	});
})

function formSubmit(){
	var options = {
			dataType:"json",
			success:function(json){
				if(json.code=='1'){
					layer.msg(json.message,{shift:5,time:1500},function(){
						parent.closeWin();
						parent.refreshTable();
						if(typeof(parent.parent.AgainGetProjectTemplate) != "undefined"){
							parent.parent.AgainGetProjectTemplate();
						}
					});
				}else{
					layer.msg("发生错误");
					parent.closeWin();
				}
			},
			error:function(json){
				layer.msg("发生错误");
			}
		};
	var documentId=$("#documentId").val();
	
	if($("#form").validationEngine('validate')){
		if(documentId.length>0){
			$("#submit").attr("onclick","");
			$('#form').ajaxSubmit(options);
		}else{
			layer.msg("请至少选择一份文档");
		}
	}
}

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

function selectSearch(){
	//var docObj  = "${listDocumentTemplate }";
	var name  = $("#selectByTemplateName").val();
	var source =$("#document_source").val();
	var path ="${_baseUrl}/projectTemplateTypeController/searchByNameSource";
	var options="";
	$.ajax({    
		type: "POST",    
		async: false,    
		url:path,
		data:{
			"name":name,
			"source":source
		},
		dataType:"json",    
		success: function (json) {   
			if(json.code=="1"){
				var docObj = eval(json.message);
				$.each(docObj, function (i, item){
					if(judgeSelect(item.id)){
						options +="<tr> <td><input name ='document' value="+item.id+" onclick='judgeSelectDoc(this);'  type ='checkbox' checked='checked' /></td>";
					}else{
						options +="<tr> <td><input name ='document' value="+item.id+" onclick='judgeSelectDoc(this);'  type ='checkbox' /></td>";
					}
					options +="<td>"+(i+1)+"</td>"
					options +="<td>"+item.documentTemplateName+"</td>"
					options +="<td>"+item.documentType+"</td>"
					options +="<td>"+item.applicationScope+"</td>"
					var docSource = item.source;
					if(docSource =="初始化"){
						options +="<td>标准文档模板</td>"
					}
					if(docSource =="自定义"){
						options +="<td>自定义文档模板</td>"
					}
					if(docSource =="文档范本库"){
						options +="<td>文档范本库</td>"
					}
					options +="</tr>";
				})
				var size = $(".tablebox thead tr:first-child>td").length;
				if(options == ''){
					options += "<tr><td colspan="+size+">没有符合条件的记录</td></tr>";    /* 当搜索条件为空时给出提示  */
				}
				$("#docList").html(options);
			}
		} 
		
	});
}

function judgeSelect(id){
	selectDoc = eval('(${proDocJson})');
	var result =false;
	$.each(selectDoc, function (i, item) {
		if(item.id==id){
			result=true;
		}
	});
	if($("#documentId").val().indexOf(id)>=0){
		result = true;
	}
	return result;
	
}

function judgeSelectDoc(obj){
	var documentId = $("#documentId").val();
	var inputId = $(obj).val();
	if($(obj).prop("checked")==true){
		if(documentId.indexOf(inputId)>=0){
			return;
		}else{
			$("#documentId").val(documentId+","+inputId);
		}
	}else{
		if(documentId.indexOf(inputId)>=0){
			$("#documentId").val(documentId.replace(inputId,""));
		}else{
			return;
		}
	}
}

</script>

</head>
<body>
<form action="${_baseUrl}/projectTemplateTypeController/saveAlter" method="post" name="form" id="form">  
 <input type="hidden" name="documentId" id="documentId" value="" />
 <input type="hidden" name="id" id="id" value="${projectTemplate.id}" />
 <div class="popup_tit mtmb20">修改项目模板</div>
 <div class="jbinformation roleshux">
	<table width="743" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	 <td width="138" height="50" align="center" bgcolor="#f7f4f4">模板名称</td>
    <td width="246" valign="middle"><div class="jbxinxi_s" style=" width: 210px">
    <input type="text" name="projectTemplateName" value="${projectTemplate.projectTemplateName} " disabled="disabled" style="width:200px; height:30px;" id="projectTemplateName"  class="jbxinxi_input validate[required]"></div><div class="jbxinxi_span1">*</div></td>
    <td width="113" align="center" valign="middle" bgcolor="#f7f4f4">样式定义模板</td>
    <td width="246"><div class="jbxinxi_s" style=" width: 210px">
    <select class="qr_select qr_select2 validate[required,funcCall[checkSelectSet]]" name="styleSetTemplate"  style="width:210px; padding:5px 0;">
        <option>请选择</option>
         <c:forEach items="${listStyleTemplateDefine }" var="styleSetTemplate">
			<c:if test="${styleSetTemplate.styleType=='inSet'}">
				<option value="${styleSetTemplate.id}" title="${styleSetTemplate.styleDocumentName}" <c:if test="${styleSetTemplate.id ==projectTemplate.styleSetTemplate}">selected="selected"</c:if>  >${styleSetTemplate.styleDocumentName} </option>
			</c:if>
		</c:forEach>
      </select></div><div class="jbxinxi_span1">*</div></td>
  </tr>
  <tr>
    <td height="50" align="center" bgcolor="#f7f4f4">适用范围</td>
    <td valign="middle"><div class="jbxinxi_s" style=" width: 210px">
    <select class="qr_select qr_select2  validate[required,funcCall[checkSelectScope]] "  name="applicationScope" id="applicationScope"  style="width:210px; padding:5px 0;" onchange="selectCreate(this.options[this.options.selectedIndex].value)">
          <option>请选择</option>
         <c:forEach items="${listApplicableScope}" var="applicableScope">
			 <option value="${applicableScope.id}"  <c:if test="${applicableScope.id ==projectTemplate.applicationScope}">selected="selected"</c:if>>${applicableScope.scopeName} </option>
		</c:forEach> 
      </select></div><div class="jbxinxi_span1">*</div></td>
    <td align="center" valign="middle" bgcolor="#f7f4f4">样式输出模板</td>
    <td><div class="jbxinxi_s" style=" width: 210px">
    <select class="qr_select qr_select2  validate[required,funcCall[checkSelectOut]]"   name="styleOutTemplate" style="width:210px; padding:5px 0;">
           <option>请选择</option>
          <c:forEach items="${listStyleTemplateDefine }" var="styleOutTemplate">
			<c:if test="${styleOutTemplate.styleType=='outSet'}">
				<option title="${styleOutTemplate.styleDocumentName}" value="${styleOutTemplate.id}" <c:if test="${styleOutTemplate.id ==projectTemplate.styleOutTemplate}">selected="true"</c:if> >${styleOutTemplate.styleDocumentName}</option>
			</c:if>
		</c:forEach>
      </select></div><div class="jbxinxi_span1">*</div></td>
  </tr>
</table>

</div>
<div class="wdang_dy_l" style="margin-top: 15px;">
           <dl class="xmugonj_dl">
                  <dd>
                      <select class="xmugonj_selecta" id="document_source" onchange="selectSearch();">
                     	<option value="choice">请选择文档模板来源</option>
                        <option value="1">标准文档模板</option>
                        <option value="2">自定义文档模板</option>
                        <option value="3">文档范本库</option>
                    </select>
                  </dd>
              </dl>
              <dl>
                 <dt><input name="" type="text" id="selectByTemplateName" class="input_text2" value="请输入文档模板名称..." onFocus="if(this.value=='请输入文档模板名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入文档模板名称...';}"></dt>
                 <dd  style="padding-left: 15px;"><span><input name="" value="搜索" type="button" onclick="selectSearch();" class="dyi_btna dyi_btnabox dyi_btna1"></span></dd>
              </dl>
             
          </div>	
	

</div>


<div class="wdang_s newz_popup newz_popup23" style="text-align: center;">
    <table width="100%" border="1" cellspacing="0" cellpadding="0" class="tablebox">
        <thead>
          <tr style="height: 30px;">
            <td width="14%">选择</td>
            <td width="14%">序号</td>
            <td width="16%">文档模板名称</td>
            <td width="15%"><span >文档类型</span></td>
            <td width="15%"><span >适用范围</span></td>
            <td width="17%">文档模板来源</td>
          </tr>
         </thead>
           <tbody id = "docList">
          <c:forEach items="${listDocumentTemplate }" var="documentTemplate" varStatus="status">
			<tr>
				<td><input name="document" value="${documentTemplate.id}"  onclick="judgeSelectDoc(this);"  type="checkbox"  
				<c:forEach  items="${list }" var="docTemplate">
				<c:if  test="${documentTemplate.id ==docTemplate.id }" > checked="checked" </c:if>
				</c:forEach> />
				</td>
				<td>${status.count}</td>
				<td>${documentTemplate.documentTemplateName}</td>
				<td>${documentTemplate.documentType}</td>
				<td>${documentTemplate.applicationScope}</td>
				<td><c:if test="${documentTemplate.source=='初始化'}">标准文档模板</c:if>
				<c:if test="${documentTemplate.source=='自定义'}">自定义文档模板</c:if>
				<c:if test="${documentTemplate.source=='文档范本库'}">文档范本库</c:if></td>
			</tr>		
		</c:forEach>
		</tbody>
    </table>
    
    
</div>
<div class="permission_an mubanclass_an ma mt30">
	<shiro:hasPermission name="projectTemplateTypeController:saveAlter">
       <a href="javascript:;"  id="submit"  onclick="formSubmit();" class=" per_baocun">确 定</a>
    </shiro:hasPermission>
    
    <a href="javascript:;" class=" per_gbi" onclick="cancelAndClose();">取 消</a>

</div>
 <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>                             	  	
</form>
</body>
</html>