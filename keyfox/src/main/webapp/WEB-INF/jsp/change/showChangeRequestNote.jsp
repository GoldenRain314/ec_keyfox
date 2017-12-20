<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>变更分析-填写变更申请</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
$(function (){
	
	//提示先选择章节号
	$(document).on('click', '#sectionvalue', function(){
		layer.msg("请先选择需要变更的章节号");
	});
	
	$("#addChangeNote").validationEngine({
		autoHidePrompt:true,//自动隐藏
		showOnMouseOver:true,//当鼠标移出时触发
		promptPosition:'bottomRight',//提示信息的位置
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
	
	
	//变更原因添加行
	$("#addReasonTr").click(function (){
		var childrenLength = $("#reasonTr").children().length;
      	var tr = '<tr>';
		if((childrenLength+1)%2 == 0){
	       	tr += '<td height="50" align="center" bgcolor="#f5f6f6">'+(childrenLength+1)+'</td>';
	      	tr += '<td align="center" bgcolor="#f5f6f6"><input name="input2" onclick="checkReasonValue(this)" type="text" class="input_text nrbg_input nrbg_input_gray validate[required,maxSize[200]] "></td>';
	       	tr += '<td align="center" bgcolor="#f5f6f6"><a href="javascript:void(0);" onclick="deleteTr(this)">删除</a></td>';
		}else{
			tr += '<td height="50" align="center">'+(childrenLength+1)+'</td>';
	      	tr += '<td align="center"><input name="input2"  type="text" onclick="checkReasonValue(this)" class="input_text nrbg_input validate[required,maxSize[200]] "></td>';
	       	tr += '<td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)">删除</a></td>';
		}
       	tr += '</tr>';
       	$("#reasonTr").append(tr);
	});
	
	//变更内容添加一行空行
	$("#addContentTr").click(function (){
		var childrenLength = $("#contentTr").children().length;
      	var tr = '<tr>';
		if((childrenLength+1)%2 == 0){
	       	tr += '<td height="50" bgcolor="#f5f6f6" align="center">'+(childrenLength+1)+'</td>';
	       	tr+='<input type="hidden" name ="selectId"  />';
	      	tr += '<td align="left" bgcolor="#f5f6f6"><input name="sectionName" onclick="selectSection();"  readonly="readonly" type="text" class="validate[maxSize[100],funcCall[judgmentPrompt],required] input_text input_text98 nrbg_input"></td>';
	       	tr += '<td align="right" bgcolor="#f5f6f6"><input id="sectionvalue" name="" type="text"  class="validate[required,maxSize[100]] input_text input_text98 nrbg_input" value="" /></td>';
	       	tr += '<td align="center" bgcolor="#f5f6f6"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a>';
	       	tr += '</td>';
		}else{
			tr += '<td height="50" align="center">'+(childrenLength+1)+'</td>';
			tr+='<input type="hidden" name ="selectId"  />';
	      	tr += '<td align="left"><input name="sectionName" type="text" onclick="selectSection();"  readonly="readonly" class="validate[maxSize[100],funcCall[judgmentPrompt],required] input_text input_text98 nrbg_input"></td>';
	       	tr += '<td align="right"><input id="sectionvalue" name="" type="text"  class="validate[required,maxSize[100]] input_text input_text98 nrbg_input" value="" /></td>';
	       	tr += '<td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a>';
	       	tr += '</td>';
		}
       	tr += '</tr>';
       	$("#contentTr").append(tr);
       
	});
	
	var flag = true;
	
	//变更申请单提交按钮
	$("#save").click(function (){
		var formChecked = $('#addChangeNote').validationEngine('validate');
		if(formChecked && flag){
			//验证更改等级是否选中
			var changeLevel = [];
			var changeLevels = $("input[type=radio][name=changelevel]:checked");
			
			for(var i =0;i<changeLevels.length;i++){
				changeLevel.push(changeLevels[i].value);
			}
			
			//更改原因
			var reasonTr = [];
			var reasonLength = $("#reasonTr").children().length;
			if(reasonLength > 0){
				$("#reasonTr").children().each(function (i){
					reasonTr.push($(this).find("td").eq(1).find("input").val());
				});
			}else{
				layer.msg("更改原因不能为空");
				return false;
			}
			
			var contentTr = [];
			var contentLength = $("#contentTr").children().length;
			if(contentLength > 0){
				$("#contentTr").children().each(function (i){
					contentTr.push('{id:"'+$(this).find("input").eq(0).val()+'","section":"'+replaceName($(this).find("td").eq(1).find("input").val())+'","value":"'+replaceName($(this).find("td").eq(2).find("input").val())+'"}');
				});
			}else{
				layer.msg("更改内容不能为空");
				return false;
			}
			flag = false;
			$.ajax({
				url : "${_baseUrl}/ca/insertChangeRequestNote",
				type : "post",
				dataType : "json",
				async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
		  		data : {
		  			changeFlag : $("#changeFlag").text(),
		  			changeDocumentId : $("#changeDocumentId").val(),
		  			documentFlag:$("#documentFlag").val(),
		  			changeLevel:changeLevel.join(","),
		  			contents:contentTr.join(","),
		  			reasons:reasonTr.join(","),
		  			projectId:"${projectId}"
		  			},
				success : function(json) {
					layer.msg(json.message);
					layer.msg(json.message,{shift:5,time:1000},function(){
						if(json.code == "1"){
							parent.skipModule("变更分析","${_baseUrl}/ci/showChangeInfluence?projectId=${projectId}&changeId="+json.data);
						}
					});
				},
				error:function(data){
					flag = true;
					layer.msg("网络忙，请稍后重试");
				}
			});
		}
	});
	
});

function replaceName(name){
	var reg1 = new RegExp("'","g");
	var reg2 = new RegExp("\"","g");
	var reg3 = new RegExp("‘","g");
	var reg4 = new RegExp("’","g");
	var reg5 = new RegExp("“","g");
	var reg6 = new RegExp("”","g");
	name = name.replace(reg1,"▼▽㊤▲△");
	name = name.replace(reg2,'▼▽㊦▲△');
	name = name.replace(reg3,"▼▽㊧▲△");
	name = name.replace(reg4,'▼▽㊨▲△');
	name = name.replace(reg5,'▼▽㊐▲△');
	name = name.replace(reg6,'▼▽㊊▲△');
	return name;
}


//删除指定行  并更新序号
function deleteTr(obj){
	//判断要删除的是第几行  然后更新序号
	var index = $(obj).parent().parent().children().first().html();
	$(obj).parent().parent().parent().children().each(function (i){
		if((i+1) > index){
			$(this).children().first().html(($(this).children().first().html()-1));
		}
	});
	//删除行
	$(obj).parent().parent().remove();
};



/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
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

function addSelectSection(sectionJson){
	var selectId="";
	var selectIds =$("input[name=selectId]");
	for(var i =0;i<selectIds.length;i++){
		if(selectId==""){
			selectId = $(selectIds[i]).val();
		}else{
			selectId +=","+ $(selectIds[i]).val();
		}
	}
	var docObj = eval(sectionJson);
	
	var contentTr ="";
	if(selectId == ""){
		$.each(docObj, function (i, item) {
			
			if((i+1)%2 == 0){
				contentTr += "<tr>";
				contentTr += '<td height="50" bgcolor="#f5f6f6" align="center">'+(i+1)+'</td>';
				contentTr += "<input type='hidden' name ='selectId' value='"+item.id+"'/>";
				contentTr += '<td align="left" bgcolor="#f5f6f6"><input name="sectionName" onclick="selectSection();"  readonly="readonly"  type="text" class="validate[maxSize[100],funcCall[judgmentPrompt],required] input_text input_text98 nrbg_input" value='+item.name+'></td>';
				contentTr += '<td align="right" bgcolor="#f5f6f6"><input name="" type="text"    class="validate[required,maxSize[100]] input_text input_text98 nrbg_input"></td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>';
				contentTr += "</tr>";
			}else{
				contentTr += "<tr>";
				contentTr += '<td height="50" align="center">'+(i+1)+'</td>';
				contentTr += "<input type='hidden' name ='selectId' value='"+item.id+"'/>";
				contentTr += '<td align="left"><input name="sectionName" onclick="selectSection();"  readonly="readonly"  type="text" class="validate[maxSize[100],funcCall[judgmentPrompt],required] input_text input_text98 nrbg_input" value='+item.name+'></td>';
				contentTr += '<td align="right"><input name="" type="text"   class="validate[required,maxSize[100]] input_text input_text98 nrbg_input"></td>';
				contentTr += '<td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>';
				contentTr += "</tr>";
			}
		});
	}else{
		var childrenLength = $("#contentTr").children().length;
		$.each(docObj, function (i, item) {
			if(selectId.indexOf(item.id)<0){
				childrenLength ++;
				if((i+1)%2 == 0){
					contentTr += "<tr>";
					contentTr += '<td height="50" bgcolor="#f5f6f6" align="center">'+childrenLength+'</td>';
					contentTr += "<input type='hidden' name ='selectId' value='"+item.id+"'/>";
					contentTr += '<td align="left" bgcolor="#f5f6f6"><input name="sectionName" onclick="selectSection();"  readonly="readonly"   type="text" class="validate[maxSize[100],funcCall[judgmentPrompt],required] input_text input_text98 nrbg_input" value='+item.name+'></td>';
					contentTr += '<td align="right" bgcolor="#f5f6f6"><input name="" type="text" class="validate[required,maxSize[100]] input_text input_text98 nrbg_input"></td>';
					contentTr += '<td align="center" bgcolor="#f5f6f6"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>';
					contentTr += "</tr>";
				}else{
					contentTr += "<tr>";
					contentTr += '<td height="50" align="center">'+childrenLength+'</td>';
					contentTr += "<input type='hidden' name ='selectId' value='"+item.id+"'/>";
					contentTr += '<td align="left"><input name="sectionName" onclick="selectSection();"  readonly="readonly"  type="text" class="validate[maxSize[100],funcCall[judgmentPrompt],required] input_text input_text98 nrbg_input" value='+item.name+'></td>';
					contentTr += '<td align="right"><input name="" type="text" class="validate[required,maxSize[100]] input_text input_text98 nrbg_input"></td>';
					contentTr += '<td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>';
					contentTr += "</tr>";
				}
				
			}
		});	
	}
	
	if(selectId==""){
		$("#contentTr").html(contentTr);
	}else{
		$("#contentTr").append(contentTr);
	}
	delInput();
}

function delInput(){
	var inputs =$("input[name=sectionName]");
	for(var i =0;i<inputs.length;i++){
		if($(inputs[i]).val() ==""){
			deleteTr(inputs[i]);
		}
	}
	
}

function selectSection (){
	
	if($("#changeDocumentId").val() == ""){
		$('#changeDocumentId').validationEngine('validate');
		layer.msg("请先选择文档名称");
		return false;
	}
	
	var id = $("#changeDocumentId").val();
	var selectId="";
	var selectIds =$("input[name=selectId]");
	for(var i =0;i<selectIds.length;i++){
		if(selectId==""){
			selectId = $(selectIds[i]).val();
		}else{
			selectId +=","+ $(selectIds[i]).val();
		}
	}
	
	
	if(id == ""){
		return;
	}
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'选择章节',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 500,
		width: 650
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentController/selectSection?projectId=${projectId}&documentId="+id+"&selectId="+selectId);
	
}

function judgmentPrompt(){
	if($("#changeDocumentId").val() == ""){
		return "请先选择文档名称";
	}else{
		return true;
	}
}

//判断项目模版是否是438B
function documentIdChange(){
	var option = $("#changeDocumentId option:selected");//获取选中的option对象
	var id = option.val();
	var name = option.text();
	if(id == ""){
		$("#documentFlag").val("");
	}
	//438B下文档标识自动写入
	var demandName = "${is438B}";
	if(demandName == "GJB438B项目文档需求追踪模板"){
		//查询438B工作产品标识
		$.ajax({
			url : "${_baseUrl}/technicalFileCatalog/selectWorkProductCodeByWorkProductName",
			type : "post",
			dataType : "json",
			data : {name : name},
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
			success : function(data) {
				//对比文档名称，自动写入产品标识
				if(data != null){
					$("#documentFlag").val(data.workProductCode);
				}
			}
		});
	}
	$("#contentTr > tr").remove();
	$("#addContentTr").click();
}

/* 检查是否已经选择了需要变更的文档 */
function checkReasonValue(obj){
	if($("#changeDocumentId").val() == ""){
		$('#changeDocumentId').validationEngine('validate');
		layer.msg("请先选择文档名称");
		$(obj).val("");
		return false;
	}
}

</script>

<style>
	.input_text { width:100%;}   /* 调整输入框显示宽度 */
	.input_text98 { width:98%;}
</style>

<body>
<form action="ca/insertChangeRequestNote" method="POST" id="addChangeNote">
<div class="ma main">
   	<div class="wdang_main">
            <div class="bgeng_table1 mt20">
            	<em class="bgeng_table1_em" id="changeFlag">变更申请单（BGSQ-${changeNumber }）</em>
            	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tablebox">
            	  <tr>
            	    <td width="120" height="50" align="center" bgcolor="#f4f4f4">文档名称</td>
            	    <td width="380" class="bgeng_table1_td2">
            	    	<select class="validate[required] xmugonj_select xmugonj_select97" id="changeDocumentId" onchange="documentIdChange()">
                              <option value="">请选择文档</option>
                              <c:forEach items="${documentList }" var="doc">
	                              <option value="${doc.id }" <c:if test="${doc.id == documentId }">selected="selected"</c:if>>${doc.templateName }</option>
                              </c:forEach>
                    	</select>
                    </td>
            	    <td width="120" align="center" bgcolor="#f4f4f4">文档标识</td>
            	    <td width="380" class="bgeng_table1_td2">
            	    	<input id="documentFlag" name="documentFlag" type="text" class="validate[required,maxSize[25]] input_text input_text98" value="${documentFlag }"  data-prompt-position="bottomLeft"/>
            	    </td>    <!-- 更改提示语位置显示   -->
          	    </tr>
            	  <tr>
            	    <td height="50" align="center" bgcolor="#f4f4f4">文档位置</td>
            	    <td colspan="3" class="bgeng_table1_td2">
            	    	${localhost }
            	    </td>
          	    </tr>
            	  <tr>
            	    <td height="50" align="center" bgcolor="#f4f4f4">更改级别</td>
            	    <td colspan="3" class="bgeng_table1_td2">
            	    	<c:forEach items="${changelevel }" var="cl">
	            	    	<input name="changelevel" class="validate[required] radio" type="radio" value="${cl.id }">&nbsp;${cl.changeLevel } &nbsp;&nbsp;
            	    	</c:forEach>
					</td>
          	    </tr>
            	  <tr>
            	    <td height="50" align="center" bgcolor="#f4f4f4">申请人</td>
            	    <td class="bgeng_table1_td2"><span id="changePersion">${userName }</span></td>
            	    <td align="center" bgcolor="#f4f4f4">变更申请时间</td>
            	    <td class="bgeng_table1_td2">${data }</td>
          	    </tr>
          	  </table>
            </div>
            
            <div class="bgeng_table2">
                <span><div class="fr glqxian_btn"><a href="javascript:;" class="bgeng_tit_a glqxian_btn1" id="addReasonTr">新增</a></div>更改原因</span> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                 <thead>
                  <tr>
                    <td width="12%" height="50" align="center" bgcolor="#f5f6f6"><strong>序号</strong></td>
                    <td width="76%" align="center" bgcolor="#f5f6f6"><strong>描述</strong></td>
                    <td width="12%" align="center" bgcolor="#f5f6f6"><strong>操作</strong></td>
                  </tr>
                  </thead>
                  <tbody id="reasonTr">
	                  <tr>
	                    <td height="50" align="center">1</td>
	                    <td align="left">   <!-- 表格对齐显示 -->
	                    	<input name="input" onclick="checkReasonValue(this)" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="" />
	                    </td>
	                    <td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>
	                  </tr>
                  </tbody>
                </table>
          </div>
            <div class="bgeng_table2 bgeng_table3">
                <span>
                	<div class="fr glqxian_btn">
                		<a href="javascript:;" class="bgeng_tit_a glqxian_btn1" id="addContentTr">新增</a> 
                	</div>
                	更改内容
                </span> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <thead>
	                  <tr>
	                    <td width="12%" height="50" align="center" bgcolor="#f5f6f6"><strong>序号</strong></td>
	                    <td width="20%" align="center" bgcolor="#f5f6f6"><strong>章节号</strong></td>
	                    <td width="56%" align="center" bgcolor="#f5f6f6"><strong>更改内容</strong></td>
	                    <td width="12%" align="center" bgcolor="#f5f6f6"><strong>操作</strong></td>
	                  </tr>
                  </thead>
                  <tbody id="contentTr">
	                  <tr>
	                    <td height="50" align="center">1</td>
	                    <input type="hidden" name ="selectId"  />
	                    <td align="left"><input id="sectionid" name="sectionName" onclick="selectSection();"  readonly="readonly" type="text" class="validate[maxSize[100],funcCall[judgmentPrompt],required] input_text input_text98 nrbg_input" value="" /></td>
	                    <td align="right"><input id="sectionvalue" name="" type="text"  class="validate[required,maxSize[100]] input_text input_text98 nrbg_input" value="" /></td>
	                    <td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>
	                  </tr>
                  </tbody>
                </table>
             <div class="permission_an ma mtmb20">
             	<shiro:hasPermission name="ci:showChangeInfluence">
			       <a href="javascript:;" class="per_baocun" id="save">提 交</a>
			    </shiro:hasPermission>
			    <shiro:hasPermission name="ca:getChangeList">
			       <a href="${_baseUrl }/ca/getChangeList" class="per_gbi">取 消</a>
			    </shiro:hasPermission>
            </div>
          </div>
        </div>
    </div>
	<div class="clear"></div>
	 <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>
</form>
</body>
</html>