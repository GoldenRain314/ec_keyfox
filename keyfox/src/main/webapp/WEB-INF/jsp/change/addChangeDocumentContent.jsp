<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>变更分析-内容申请单</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
$(function (){
	
	initTable();
	
	// 内容变更单，更改内容时若未选择“章节号”，而先写“章节内容”和“更改内容”则提示“请先选择需要变更的章节号”
	$(document).on('click', '#newsectionCou', function(){
			layer.msg("请先选择需要变更的章节号");
	});
	$(document).on('click', '#newchangeCou', function(){
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
	      	tr += '<td align="center" bgcolor="#f5f6f6"><input name="input2" type="text" class="validate[required,maxSize[100]] input_text nrbg_input nrbg_input_gray"></td>';
	       	tr += '<td align="center" bgcolor="#f5f6f6"><a href="javascript:void(0);" onclick="deleteTr(this)">删除</a></td>';
		}else{
			tr += '<td height="50" align="center">'+(childrenLength+1)+'</td>';
	      	tr += '<td align="center"><input name="input2" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
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
	      	tr += '<td align="center" bgcolor="#f5f6f6"><input name="sectionName" id="sectionNum"  onclick="selectSection();"  readonly="readonly"  type="text" class="validate[required] input_text nrbg_input"></td>';
	       	tr += '<td align="center" bgcolor="#f5f6f6"><input name="" type="text" id="newsectionCou" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
	       	tr += '<td align="center" bgcolor="#f5f6f6"><input name="" type="text" id="newchangeCou" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
	       	tr += '<td align="center" bgcolor="#f5f6f6"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>';
		}else{
			tr += '<td height="50" align="center">'+(childrenLength+1)+'</td>';
		 	tr+='<input type="hidden" name ="selectId"  />';
	      	tr += '<td align="center"><input name="sectionName" id="sectionNum" onclick="selectSection();"  readonly="readonly" type="text" class="validate[required] input_text nrbg_input"></td>';
	       	tr += '<td align="center"><input name="" id="newsectionCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
	       	tr += '<td align="center"><input name="" id="newchangeCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
	       	tr += '<td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>';
		}
       	tr += '</tr>';
       	$("#contentTr").append(tr);
       
	});
	
	//变更申请单提交按钮
	$("#save").click(function (){
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
		
		var formChecked = $('#addChangeNote').validationEngine('validate');
		if(formChecked){
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
					contentTr.push('{id:"'+$(this).find("input").eq(0).val()+'","sectionNumber":"'+replaceName1($(this).find("td").eq(1).find("input").val())+'","section":"'+replaceName1($(this).find("td").eq(2).find("input").val())+'","value":"'+replaceName1($(this).find("td").eq(3).find("input").val())+'"}');
				});
			}else{
				layer.msg("更改内容不能为空");
				return false;
			}
			
			$("#save").unbind("click");
			$.ajax({
				url : "${_baseUrl}/cdc/insertChangeDocumentContent",
				type : "post",
				dataType : "json",
				async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
		  		data : {
		  			contents:contentTr.join(","),
		  			reasons:reasonTr.join(","),
		  			projectId:"${projectId}",
		  			changeId:"${content.changeId}",
		  			documentId:"${documentId}"
		  			},
				success : function(json) {
					layer.msg(json.message);
					layer.msg(json.message,{shift:5,time:1000},function(){
						if(json.code == "1"){
							window.location.href = "${_baseUrl}/ci/showChangeInfluence?projectId=${projectId}&changeId=${content.changeId}";
						}
					});
				},
				error:function(data){
					layer.msg("网络忙，请稍后重试");
				}
			});
		}
	});
	
});


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
	if(selectId==""){
		$.each(docObj, function (i, item) {
			//var childrenLength = $("#contentTr").children().length;
			if((i+1)%2 == 0){
				contentTr += "<tr>";
				contentTr += '<td height="50" bgcolor="#f5f6f6" align="center">'+(i+1)+'</td>';
				contentTr += "<input type='hidden' name ='selectId' value='"+item.id+"'/>";
				contentTr += '<td align="center" bgcolor="#f5f6f6"><input name="sectionName" onclick="selectSection();"  readonly="readonly"  type="text" class="validate[required] input_text nrbg_input" value='+item.name+'></td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a>';
		       	contentTr += '</td>';
				contentTr += "</tr>";
			}else{
				contentTr += "<tr>";
				contentTr += '<td height="50" align="center">'+(i+1)+'</td>';
				contentTr += "<input type='hidden' name ='selectId' value='"+item.id+"'/>";
				contentTr += '<td align="center"><input name="sectionName" onclick="selectSection();" type="text"  readonly="readonly"  class="validate[required] input_text nrbg_input" value='+item.name+'></td>';
				contentTr += '<td align="center"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
				contentTr += '<td align="center"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
				contentTr += '<td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a>';
		       	contentTr += '</td>';
				contentTr += "</tr>";
			}
		});
	}else{
		var j=1;
		$.each(docObj, function (i, item) {
			if(selectId.indexOf(item.id)<0){
				var childrenLength = $("#contentTr").children().length;
				if((childrenLength+1)%2 == 0){
					contentTr += "<tr>";
					contentTr += '<td height="50" bgcolor="#f5f6f6" align="center">'+(childrenLength+(j++))+'</td>';
					contentTr += "<input type='hidden' name ='selectId' value='"+item.id+"'/>";
					contentTr += '<td align="center" bgcolor="#f5f6f6"><input name="sectionName"   readonly="readonly"  onclick="selectSection();"  type="text" class="validate[required] input_text nrbg_input" value='+item.name+'></td>';
					contentTr += '<td align="center" bgcolor="#f5f6f6"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
					contentTr += '<td align="center" bgcolor="#f5f6f6"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
					contentTr += '<td align="center" bgcolor="#f5f6f6"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>';
					contentTr += "</tr>";
				}else{
					contentTr += "<tr>";
					contentTr += '<td height="50" align="center">'+(childrenLength+(j++))+'</td>';
					contentTr += "<input type='hidden' name ='selectId' value='"+item.id+"'/>";
					contentTr += '<td align="center"><input name="sectionName" onclick="selectSection();"  readonly="readonly"  type="text" class="validate[required] input_text nrbg_input" value='+item.name+'></td>';
					contentTr += '<td align="center"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
					contentTr += '<td align="center"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
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
	var selectId="";
	var selectIds =$("input[name=selectId]");
	for(var i =0;i<selectIds.length;i++){
		if(selectId==""){
			selectId = $(selectIds[i]).val();
		}else{
			selectId +=","+ $(selectIds[i]).val();
		}
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
	$("#popIframe").attr("src","${_baseUrl}/documentController/selectSection?projectId=${projectId}&documentId=${documentId}&selectId="+selectId);
	
}

//"▼▽㊤▲△"替换为"'"
function replaceName(name){
	if(name.indexOf("▼▽㊤▲△") != -1 || name.indexOf("▼▽㊦▲△") != -1
	|| name.indexOf("▼▽㊧▲△") != -1 || name.indexOf("▼▽㊨▲△") != -1
	|| name.indexOf("▼▽㊐▲△") != -1 || name.indexOf("▼▽㊊▲△") != -1) {
			var reg1 = new RegExp("▼▽㊤▲△", "g");
			var reg2 = new RegExp("▼▽㊦▲△", "g");
			var reg3 = new RegExp("▼▽㊧▲△", "g");
			var reg4 = new RegExp("▼▽㊨▲△", "g");
			var reg5 = new RegExp("▼▽㊐▲△", "g");
			var reg6 = new RegExp("▼▽㊊▲△", "g");
			name = name.replace(reg1, "'");
			name = name.replace(reg2, '"');
			name = name.replace(reg3, "‘");
			name = name.replace(reg4, '’');
			name = name.replace(reg5, '“');
			name = name.replace(reg6, '”');
			return name;
		}
		return name;
	}

//"'"替换为"▼▽㊤▲△"
function replaceName1(name){
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

function englishChange(name){
	if(name.indexOf("'") != -1 || name.indexOf('"') != -1) {
		var reg1 = new RegExp("'", "g");
		var reg2 = new RegExp('"', "g");
		name = name.replace(reg1, "&apos;");
		name = name.replace(reg2, '&quot;');
		return name;
	}
	return name;
}

// 表格数据
function initTable(){
	var a = ${content1 };
	var contentTr = "";
	var num = "1";
	var del = "删除";
	if(a.changeReasons === undefined || a.changeReasons == null){
		contentTr += "<tr>";
		contentTr += '<td height="50" align="center">'+num+'</td>';
		contentTr += '<input type="hidden" name ="selectId" value=""/>';
		contentTr += '<td align="center"><input name="" id="sectionNum" type="text" onclick="selectSection();"   class="validate[required] input_text nrbg_input" value="" /></td>';
		contentTr += '<td align="center"><input name="" id="newsectionCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="" /></td>';
		contentTr += '<td align="center"><input name="" id="newchangeCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="" /></td>';
		contentTr += '<td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a></td>';
		contentTr += '</tr>';
		
		$("#contentTr").append(contentTr);
	} else {
		$.each(a.changeContents,function(i,item){
			var change = replaceName(item.changeSection);
			var newchangecontent = replaceName(item.changeContent);
			newchangecontent = englishChange(newchangecontent);
			var childrenLength = $("#contentTr").children().length;
			if((childrenLength+1)%2 == 0){
				contentTr += "<tr>";
				contentTr += '<td height="50" bgcolor="#f5f6f6" align="center">'+(i+1)+'</td>';
				contentTr += "<input type='hidden' name ='selectId' value='"+item.changeSectionId+"'/>";
				contentTr += '<td align="center" bgcolor="#f5f6f6"><input name="sectionName" onclick="selectSection();"  readonly="readonly"  type="text" class="validate[required] input_text nrbg_input" value='+change+'></td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value='+newchangecontent+'></td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a>';
				contentTr += "</td>";
				contentTr += "</tr>";
			}else{
				contentTr += "<tr>";
				contentTr += '<td height="50" align="center">'+(i+1)+'</td>';
				contentTr += "<input type='hidden' name ='selectId' value='"+item.changeSectionId+"'/>";
				contentTr += '<td align="center"><input name="sectionName" onclick="selectSection();" type="text"  readonly="readonly"  class="validate[required] input_text nrbg_input" value='+change+'></td>';
				contentTr += '<td align="center"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input"></td>';
				contentTr += '<td align="center"><input name="" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value='+newchangecontent+'></td>';
				contentTr += '<td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)" >删除</a>';
				contentTr += "</td>";
				contentTr += "</tr>";
			};
		});
		$("#contentTr").append(contentTr);
	};
}


</script>
<body>
<form action="cdc/insertChangeDocumentContent" method="POST" id="addChangeNote">
<div class="ma main">
   	<div class="wdang_main">
            <div class="bgeng_table1 mt20">
            	<em class="bgeng_table1_em" id="changeFlag">内容变更单</em>
            	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tablebox">
            	  <tr>
            	    <td height="50" align="center" bgcolor="#f4f4f4">文档名称</td>
            	    <td colspan="3" class="bgeng_table1_td2">
            	    	${content.documentName }
					</td>
          	      </tr>
          	      <tr>
            	    <td height="50" align="center" bgcolor="#f4f4f4">文档位置</td>
            	    <td colspan="3" class="bgeng_table1_td2">
            	    	${documentLocalhost }
					</td>
          	      </tr>
          	      <tr>
            	    <td height="50" align="center" bgcolor="#f4f4f4">更改级别</td>
            	    <td colspan="3" class="bgeng_table1_td2">
            	    	${content.changeLevelName }
					</td>
          	      </tr>
            	  <tr>
            	    <td height="50" align="center" bgcolor="#f4f4f4">申请人</td>
            	    <td class="bgeng_table1_td2"><span id="changePersion">${content.userName }</span></td>
            	    <td align="center" bgcolor="#f4f4f4">申请日期</td>
            	    <td class="bgeng_table1_td2">${content.createData}</td>
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
                  	<c:if test="${content.changeReasons != null }">
                  		<c:forEach items="${content.changeReasons}" var="reason" varStatus="index">
	                 		<tr>
			                    <td height="50" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center" >${index.index+1 }</td>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center"><input name="input" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="${reason.description }" /></td>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center"><a href="javascript:void(0);" onclick="deleteTr(this)">删除</a></td>
		                  	</tr>
                  		</c:forEach>
                  	</c:if>
                  	<c:if test="${content.changeReasons == null }">
                  		<tr>
		                    <td height="50" align="center">1</td>
		                    <td align="center"><input name="input" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="" /></td>
		                    <td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)">删除</a></td>
	                  	</tr>
                  	</c:if>
                  </tbody>
                </table>
          </div>
            <div class="bgeng_table2 bgeng_table3">
                <span><div class="fr glqxian_btn"> <a href="javascript:;" class="bgeng_tit_a glqxian_btn1" id="addContentTr">新增</a></div>更改内容</span> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <thead>
	                  <tr>
	                    <td width="12%" height="50" align="center" bgcolor="#f5f6f6"><strong>序号</strong></td>
	                    <td width="10%" align="center" bgcolor="#f5f6f6"><strong>章节号</strong></td>
	                    <td width="20%" align="center" bgcolor="#f5f6f6"><strong>章节内容</strong></td>
	                    <td width="46%" align="center" bgcolor="#f5f6f6"><strong>更改内容</strong></td>
	                    <td width="12%" align="center" bgcolor="#f5f6f6"><strong>操作</strong></td>
	                  </tr>
                  </thead>
                  <tbody id="contentTr">
                  	  <%-- <c:if test="${content.changeReasons != null }">
                  		<c:forEach items="${content.changeContents}" var="content" varStatus="index">
	                 		<tr>
			                    <td height="50" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center" >${index.index+1 }</td>
			                    <input type="hidden" name ="selectId" value="${content.changeSectionId }"/>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center"><input name="" id="sectionNum" type="text" onclick="selectSection();"   readonly="readonly"  class="validate[required] input_text nrbg_input" value="${content.changeSection }" /></td>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center"><input name="" id="sectionCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="" /></td>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center"><input name="" id="changeCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="${content.changeContent }" /></td>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center"><a href="javascript:void(0);" onclick="deleteTr(this)">删除</a></td>
		                  	</tr>
                  		</c:forEach>
                  	</c:if>
                  	<c:if test="${content.changeReasons == null }">
	                  <tr>
	                    <td height="50" align="center">1</td>
	                    <input type="hidden" name ="selectId" value=""/>
	                    <td align="center"><input name="" id="sectionNum" type="text" onclick="selectSection();"   class="validate[required] input_text nrbg_input" value="" /></td>
	                    <td align="center"><input name="" id="newsectionCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="" /></td>
	                    <td align="center"><input name="" id="newchangeCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="" /></td>
	                    <td align="center"><a href="javascript:void(0);" onclick="deleteTr(this)">删除</a></td>
	                  </tr>
                  	</c:if> --%>
                  </tbody>
                </table>
             <div class="permission_an ma mtmb20">
             	<shiro:hasPermission name="cdc:insertChangeDocumentContent">
			       <a href="javascript:;" class="per_baocun" id="save">提 交</a>
			    </shiro:hasPermission>
                <a href="${_baseUrl }/ci/showChangeInfluence?projectId=${projectId}&changeId=${content.changeId}" class="per_gbi">取 消</a>
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