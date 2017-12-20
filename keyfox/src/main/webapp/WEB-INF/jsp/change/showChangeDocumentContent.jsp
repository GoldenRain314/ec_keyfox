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

<script type="text/javascript">
$(function (){
	
	initTable();
	
	
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
	
	if("true" != "${hideClose}"){
		$("#close").show();
	}
})
function exportDoc(projectId,documentId,changeId){
	window.location.href="${_baseUrl}/exportController/exportChangeContent?projectId="+projectId+"&documentId="+documentId+"&changeId="+changeId;
	
}


function initTable(){
	var a = ${content1 };
	var contentTr = "";
	if(a.changeReasons == null){
		/* contentTr += "<tr>";
		contentTr += '<td height="50" align="center">'+1+'</td>';
		contentTr += '<td align="center"><input name="" id="sectionNum" type="text" onclick="selectSection();"   class="validate[required] input_text nrbg_input" value="" /></td>';
		contentTr += '<td align="center"><input name="" id="newsectionCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="" /></td>';
		contentTr += '<td align="center"><input name="" id="newchangeCou" type="text" class="validate[required,maxSize[100]] input_text nrbg_input" value="" /></td>';
		contentTr += '</tr>';
		$("#contentTr").append(contentTr); */
	} else {
		var childrenLength = 0;
		$.each(a.changeContents,function(i,item){
			var changesectionnumber = replaceName(item.changeSectionNumber);
			var changesection = replaceName(item.changeSection);
			changesection = replaceName1(changesection);
			var changecontent = replaceName(item.changeContent);
			changecontent = replaceName1(changecontent); 
			if((childrenLength+1)%2 == 0){
				contentTr += "<tr>";
				contentTr += '<td height="50" bgcolor="#f5f6f6" align="center">'+(i+1)+'</td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6">'+changesectionnumber+'</td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6">'+changesection+'</td>';
				contentTr += '<td align="center" bgcolor="#f5f6f6">'+changecontent+'</td>';
				contentTr += "</tr>";
				childrenLength++;
			}else{
				contentTr += "<tr>";
				contentTr += '<td height="50" align="center">'+(i+1)+'</td>';
				contentTr += '<td align="center">'+changesectionnumber+'</td>';
				contentTr += '<td align="center">'+changesection+'</td>';
				contentTr += '<td align="center">'+changecontent+'</td>';
				contentTr += "</tr>";
				childrenLength++;
			};
		});
		$("#contentTr").append(contentTr);
	};
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
	
// 英文引号转义
function replaceName1(name){
	if(name.indexOf("'") != -1 || name.indexOf('"') != -1) {
			var reg1 = new RegExp("'", "g");
			var reg2 = new RegExp('"', "g");
			name = name.replace(reg1, "&apos;");
			name = name.replace(reg2, '&quot;');
			return name;
		}
		return name;
	}
</script>
<body>
<form action="cdc/insertChangeDocumentContent" method="POST" id="addChangeNote">


<div class="ma main">
   	<div class="wdang_main">
            <div class="bgeng_table1 mt20">
            	<em class="bgeng_table1_em" id="changeFlag">内容变更单</em>
            	<div class="fr glqxian_btn wendmban_btn glqxian_btn mb20">
            	<a href="javascript:;" class="glqxian_btn1" onclick="exportDoc('${projectId}','${documentId}','${content.changeId}');">导出</a>
            	</div>
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
            	    <td align="center" bgcolor="#f4f4f4">变更申请时间</td>
            	    <td class="bgeng_table1_td2">${content.createData}</td>
          	    </tr>
          	  </table>
            </div>
            
            <div class="bgeng_table2">
                <span><a href="javascript:;" class="bgeng_tit_a" id="addReasonTr"></a>更改原因</span> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                 <thead>
                  <tr>
                    <td width="12%" height="50" align="center" bgcolor="#f5f6f6"><strong>序号</strong></td>
                    <td width="76%" align="center" bgcolor="#f5f6f6"><strong>描述</strong></td>
                  </tr>
                  </thead>
                  <tbody id="reasonTr">
                  	<c:if test="${content.changeReasons != null }">
                  		<c:forEach items="${content.changeReasons}" var="reason" varStatus="index">
	                 		<tr>
			                    <td height="50" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center" >${index.index+1 }</td>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center">${reason.description }</td>
		                  	</tr>
                  		</c:forEach>
                  	</c:if>
                  </tbody>
                </table>
          </div>
            <div class="bgeng_table2 bgeng_table3">
                <span><a href="javascript:;" class="bgeng_tit_a" id="addContentTr"></a>更改内容</span> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <thead>
	                  <tr>
	                    <td width="12%" height="50" align="center" bgcolor="#f5f6f6"><strong>序号</strong></td>
	                    <td width="10%" align="center" bgcolor="#f5f6f6"><strong>章节号</strong></td>
	                    <td width="20%" align="center" bgcolor="#f5f6f6"><strong>章节内容</strong></td>
	                    <td width="46%" align="center" bgcolor="#f5f6f6"><strong>更改内容</strong></td>
	                  </tr>
                  </thead>
                  <tbody id="contentTr">
	                  <%-- <c:if test="${content.changeReasons != null }">
                  		<c:forEach items="${content.changeContents}" var="content" varStatus="index">
	                 		<tr>
			                    <td height="50" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center" >${index.index+1 }</td>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center">${content.changeSectionNumber }</td>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center">${content.changeSection }</td>
			                    <td <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> align="center">${content.changeContent }</td>
			                  
		                  	</tr>
                  		</c:forEach>
                  	</c:if> --%>
                  </tbody>
                </table>
               <div class="permission_an ma mtmb20">
                <a id="close" style="display: none;" href="${_baseUrl }/ci/showChangeInfluence?projectId=${projectId}&changeId=${content.changeId}" class="per_gbi">取 消</a>
            </div>
          </div>
        </div>
    </div>
	<div class="clear"></div>
</form>
</body>
</html>