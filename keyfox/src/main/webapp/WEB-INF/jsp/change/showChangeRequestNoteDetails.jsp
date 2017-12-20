<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>变更分析-变更申请单详细信息</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript">
/* $(function (){
	//选中变更级别
	var changeLevel = "${changevo.changeLevel}";
	var split = changeLevel.split(",");
	for(var i=0;i<split.length;i++){
		$("#"+split[i]).attr("checked",true);
	}
}) */
function exportDoc(changeId){
	window.location.href="${_baseUrl}/exportController/exportChangeApply?changeId="+changeId;
}

$(function (){
	var trs = "<c:forEach items='${changevo.changeContents }' var='con' varStatus='index'>";
	trs += "<tr>";
	trs += '<td height="50" align="center" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> >${index.index+1 }</td>';
	trs += '<td align="center" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if>>'+replaceName('${con.changeSection }')+'</td>';
	trs += '<td align="center" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if>>'+replaceName('${con.changeContent }')+'</td>';
	trs += '</tr>';
	trs += "</c:forEach>";
	
	$("#contentTr").append(trs);
});

function replaceName(name){
	var reg1 = new RegExp("▼▽㊤▲△","g");
	var reg2 = new RegExp("▼▽㊦▲△","g");
	var reg3 = new RegExp("▼▽㊧▲△","g");
	var reg4 = new RegExp("▼▽㊨▲△","g");
	var reg5 = new RegExp("▼▽㊐▲△","g");
	var reg6 = new RegExp("▼▽㊊▲△","g");
	name = name.replace(reg1,"'");
	name = name.replace(reg2,'\"');
	name = name.replace(reg3,"‘");
	name = name.replace(reg4,'’');
	name = name.replace(reg5,'“');
	name = name.replace(reg6,'”');
	return name;
}


</script>
</head>
<body>
	<div class="ma main">
    	<div class="wdang_main">
            <div class="bgeng_table1 mt20">
            	<em class="bgeng_table1_em" id="changeFlag">${changevo.changeFlag }</em>
            	<div class="fr glqxian_btn wendmban_btn glqxian_btn mb20" >
            	<a href="javascript:;" class="glqxian_btn1" onclick="exportDoc('${changeId}');">导出</a>
            		<div class="clear"></div>
            	</div>
            	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tablebox mt20">
            	  <tr>
                        <td width="12%" height="50" align="center" bgcolor="#f4f4f4">文档名称</td>
                        <td width="35%" class="bgeng_table1_td2">${changevo.documentName }</td>
                        <td width="14%" align="center" bgcolor="#f4f4f4">文档标识</td>
                        <td width="39%" class="bgeng_table1_td2">${changevo.documentFlag }</td>
                  </tr>
            	   <tr>
                        <td height="50" align="center" bgcolor="#f4f4f4">文档位置</td>
                        <td colspan="3" class="bgeng_table1_td2">${documentLocalhost }</td>
                  </tr>
            	  <tr>
            	    <td height="50" align="center" bgcolor="#f4f4f4">更改级别</td>
            	    <td colspan="3" class="bgeng_table1_td2">
            	    	<c:forEach items="${changelevel }" var="cl">
            	    		<c:if test="${changevo.changeLevel == cl.id }">${cl.changeLevel }</c:if>
	            	    	<%-- <input name="changelevel" id="${cl.id }" type="checkbox" value="${cl.id }">&nbsp;${cl.changeLevel } &nbsp;&nbsp; --%>
            	    	</c:forEach>
					</td>
          	    </tr>
            	  <tr>
            	    <td height="50" align="center" bgcolor="#f4f4f4">申请人</td>
            	    <td class="bgeng_table1_td2"><span id="changePersion">${changevo.changePersionName }</span></td>
            	    <td align="center" bgcolor="#f4f4f4">变更申请时间</td>
            	    <td class="bgeng_table1_td2">${changevo.changeDate }</td>
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
                  	<c:forEach items="${changevo.changeReasons }" var="rea" varStatus="index">
	                  	<tr>
	                  		<td height="50" align="center" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> >${index.index+1 }</td>
	                  		<td align="center" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if>>${rea.description }</td>
	                  	</tr>
                  	</c:forEach>
                  </tbody>
                </table>
          </div>
          <div class="bgeng_table2 bgeng_table3">
                <span><a href="javascript:;" class="bgeng_tit_a" id="addContentTr"></a>更改内容</span> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <thead>
	                  <tr>
	                    <td width="12%" height="50" align="center" bgcolor="#f5f6f6"><strong>序号</strong></td>
	                    <td width="20%" align="center" bgcolor="#f5f6f6"><strong>章节号</strong></td>
	                    <td width="56%" align="center" bgcolor="#f5f6f6"><strong>更改内容</strong></td>
	                  </tr>
                  </thead>
                  <tbody id="contentTr">
                 	<%-- <c:forEach items="${changevo.changeContents }" var="con" varStatus="index">
	                  	<tr>
	                  		<td height="50" align="center" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if> >${index.index+1 }</td>
	                  		<td align="center" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if>>${con.changeSection }</td>
	                  		<td align="center" <c:if test="${(index.index+1) % 2 == 0 }"> bgcolor="#f5f6f6"</c:if>>${con.changeContent }</td>
	                  	</tr>
                  	</c:forEach> --%>
                  </tbody>
                </table>
          </div>
       </div>
    </div>
	<div class="clear"></div>
</body>
</html>