<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html style="overflow:auto; width:814px;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>项目文档模板</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
</script>
</head>
<body>
<div class="dotted_line dotted_line1 widthauto">
            <div class="xmugonj_cont ma" style="display:block; padding:0 15px;">
              <div class="xmugonj_t_f">
              		<strong>适&nbsp;&nbsp;用&nbsp;&nbsp;&nbsp;范&nbsp;&nbsp;围&nbsp;:  </strong>${scope}<br>
                    <strong>样式输出模板&nbsp;: </strong>${styleOutTemplateName}<br>
                    <strong>样式定义模板&nbsp;: </strong>${styleSetTemplateName}
                </div>
                <div class="xmugonj_ta_j widthauto">
                	 <div class="xmugonj_ta_j widthauto">
				    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					        <thead>
					          <tr>
					         	<td width="10%" height="50" align="center" bgcolor="#f5f6f6"><strong>序号</strong></td>
		                        <td width="30%" height="50" align="center" bgcolor="#f5f6f6"><strong>文档模板名称</strong></td>
		                        <td width="20%" align="center" bgcolor="#f5f6f6"><strong>文档类型</strong></td>
		                        <td width="20%" align="center" bgcolor="#f5f6f6"><strong>适用范围</strong></td>
		                        <td align="center" bgcolor="#f5f6f6" width="20%" ><strong>来 源</strong></td>
					          </tr>
					         </thead>
					          <c:forEach items="${projectTemplateList}" var="projectDocument"  varStatus="status">
								<tr <c:if test="${projectDocument.templateStatus =='0' }">style="color: #CACAC4;" </c:if>>
									<td align="center" bgcolor="#f1f3f6">${ status.index + 1}</td>
									<td align="center" bgcolor="#f1f3f6"><div title="${projectDocument.documentTemplateName }" style=" width:150px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; ">${projectDocument.documentTemplateName }</div></td>
									<td align="center" bgcolor="#f1f3f6">${projectDocument.documentType }</td>
									<td align="center" bgcolor="#f1f3f6">${projectDocument.applicationScope }</td>
									<td align="center" bgcolor="#f1f3f6">
									<c:if test="${projectDocument.source=='初始化'}">标准文档模板</c:if>
									<c:if test="${projectDocument.source=='自定义'}">自定义文档模板</c:if>
									<c:if test="${projectDocument.source=='文档范本库'}">文档范本库</c:if>
								    </td>
								</tr>
							</c:forEach>
					    </table>    
				    </div>
					<div class="permission_an xmugonj_bc ma">
                        <a href="javascript:;" class="per_baocun" onclick="parent.closeWin();">关 闭</a>
                    </div>
               </div>
            </div>
	<div class="clear"></div>
</div>
</body>
</html>
