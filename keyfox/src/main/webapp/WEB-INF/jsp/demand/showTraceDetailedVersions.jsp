<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>展示需求追踪关系表格</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>

<script type="text/javascript">
$(function (){
	if("true" == "${showButton}"){
		$("#showEditTrace").show();
		$("#returnDocumentList").show();
	}
	
	getAgoDocumentVersions("${projectId}");
	getDocumentHistoryTrace();
	
	/* if("${documentInfo.templateName }".length>8){
		if("${documentInfo.templateName }".length<16){
			var i=128-("${documentInfo.templateName }".length-8)*16.875;
			$("#firstVersion").css("padding-left",i+"px");
		}else{
			$("#firstVersion").css("padding-left","5px");
		}
	}else{
		$("#firstVersion").css("padding-left","115px");
	}	 */
});

function bubbleSort(array){
	var i = 0, len = array.length, 
    j, d; 
	for(; i<len; i++){ 
	    for(j=0; j<len; j++){ 
	        if(array[i] > array[j]){ 
	            d = array[j]; 
	            array[j] = array[i]; 
	            array[i] = d; 
	        } 
	    } 
	} 
	return array[0];
}
function loadDocumentTraceMessage(trJsonJson,documentTraceListJson){
	
	var trJson = eval('('+trJsonJson+')');
	var documentTraceList = eval('('+documentTraceListJson+')');
	if(trJson.length == 0){
		//table 表格
		var table = '<table width="100%" border="0" cellspacing="0" cellpadding="0">';
		var valueTr = '<tr>';
		valueTr += '<td align="center" bgcolor="#f0f1f1"><strong>该版本的文档还没有建立追踪关系</strong></td>';     /* 火狐浏览器-查看追踪关系弹框中表格没有下边现 17-05-08 rowspan="4" colspan="7" */
		valueTr += '</tr>';
		table += valueTr;
		table += '</table>';
	}else{
		var documentTraceNumber = trJson[0].traceDocumentNumber;
		if(documentTraceNumber > 0){
			//table 表格
			var table = '<table width="100%" border="0" cellspacing="0" cellpadding="0">';
	        var titletr = '<tr>';
	        var firstTr = '<tr>';
	        var secondTr = '<tr>';
			//表头
			for(var dd=0;dd<documentTraceList.length;dd++){
				
				titletr += '<td class="'+documentTraceList[dd].id+'" height="57" colspan="3" align="center" bgcolor="#e9f5ff"><strong></strong><strong>'+documentTraceList[dd].templateName+' ('+initVersion(documentTraceList[dd].documentVersion)+')</strong></td>';
				
				firstTr += '<td width="110" align="center">章节号</td>';
				firstTr += '<td width="180" align="center">章节名称</td>';
				firstTr += '<td width="137" align="center">章节标识</td>';
			}
			titletr += '<td colspan="3" align="center" bgcolor="#f0f1f1"><strong>${documentInfo.templateName } ('+getDocumentVersion()+')</strong></td>';
			titletr += '<td rowspan="2" width="110" align="center" bgcolor="#f0f1f1"><strong>内容追踪类型</strong></td>';
			titletr += "</tr>";
			table += titletr;
			
			firstTr += '<td width="111" align="center">章节号</td>';
			firstTr += '<td width="142" align="center">章节名称</td>';
			firstTr += '<td width="139" align="center">章节标识</td>';
			
			table += firstTr;
			for(var i=0;i<trJson.length;i++){
				//每一个章节
				var obj = trJson[i];
				
				//章节个数
				var section_number_s = [];
				
				for(var dd=0;dd<documentTraceList.length;dd++){
					var documentTrace = eval('obj.left'+documentTraceList[dd].id);
					if(documentTrace != null)
						section_number_s.push(documentTrace.length);
				}
				
				var forNumber = bubbleSort(section_number_s);
				var json_data;
				var relation;
				for(var num=0;num<forNumber;num++){
					var valueTr = '<tr>';
					for(var dd=0;dd<documentTraceList.length;dd++){
						var documentTrace = eval('obj.left'+documentTraceList[dd].id);
						/* //if() */
						if(documentTrace != null && num < documentTrace.length){
							json_data = documentTrace;
							valueTr += '<td align="center">'+documentTrace[num].traceSectionNumber+'</td>';
							valueTr += '<td align="center">'+documentTrace[num].traceSectionName+'</td>';
							valueTr += '<td align="center">'+initValue(documentTrace[num].traceSectionMark)+'</td>';
						}else{
							valueTr += '<td align="center"></td>';
							valueTr += '<td align="center"></td>';
							valueTr += '<td align="center"></td>';
						}
					}
					if(json_data != null){
						valueTr += '<td align="center">'+json_data[0].sectionNumber+'</td>';
						valueTr += '<td align="center">'+json_data[0].sectionName+'</td>';
						valueTr += '<td align="center">'+initValue(json_data[0].sectionMark)+'</td>';
					}else{
						valueTr += '<td align="center"></td>';
						valueTr += '<td align="center"></td>';
						valueTr += '<td align="center"></td>';
					}
					if(json_data != null){
						if(documentTrace[num].traceRelation == '0'){
							relation = '强关联';
						}else if(documentTrace[num].traceRelation == '1'){
							relation = '弱关联';
						}else if(documentTrace[num].traceRelation == '2'){
							relation = '内容引用';
						}else {
							relation = "";
						}
						valueTr += '<td align="center">'+relation+'</td>';
					}else{
						valueTr += '<td align="center"></td>';
					}
					valueTr += '</tr>';
					table += valueTr;
				}
			}
			table += '</table>';
		}
		
		
	} 
	$("#tableDiv").children("table").remove();
	$("#tableDiv").append(table);
}
function initValue(val){
	if(val == undefined){
		return "";
	}else
		return val;
}

function initVersion(val){
	if(val == undefined || "" == val){
		return "暂未发布";
	}else
		return val;
}
function getAgoDocumentVersions(projectId){
	 var agoDocumentId = $("#documentList").val();
	 var documentId = $("#documentVersion").val();
	 $.ajax({ 
			url:'${_baseUrl}/documentList/getAgoDocumentVersions?documentId='+documentId+'&projectId='+projectId+'&agoDocumentId='+agoDocumentId, 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
				jQuery("#agoDocumentVersions").empty();
			 	var jsonObj=eval("("+data.json+")");
			 	if(jsonObj == null || jsonObj == ""){
			 		jQuery("#agoDocumentVersions").append("<option value=''>暂未发布</option>");
			 	}
			 	$.each(jsonObj, function (i, item) {
			 		jQuery("#agoDocumentVersions").append("<option value="+ item.id+">"+ item.documentVersion+"</option>");
			 		if(data.documentRelation == '0'){
			 			$("#documentRelation").html("直接关联");
			 		}else if(data.documentRelation == '1'){
			 			$("#documentRelation").html("间接关联");
			 		}else{
			 			$("#documentRelation").html("");
			 		}
			 	}); 
			 	getDocumentHistoryTrace();
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
}
function getDocumentHistoryTrace(){
	var documentId = $("#documentVersion").val();
	var agoDocumentId = $("#agoDocumentVersions").val();
	 $.ajax({ 
			url:'${_baseUrl}/dd/getDocumentHistoryTrace?documentId='+documentId+'&projectId=${projectId}&agoDocumentId='+agoDocumentId, 
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
				if(data.success == 'true'){
					loadDocumentTraceMessage(data.trString,data.documentTraceList);
				}else{
					var table = '<table width="100%" border="0" cellspacing="0" cellpadding="0">';
					var valueTr = '<tr>';
					valueTr += '<td align="center" bgcolor="#f0f1f1"><strong>该版本的文档还没有建立追踪关系</strong></td>';     /* 火狐浏览器-查看追踪关系弹框中表格没有下边现 17-05-08 rowspan="4" colspan="7" */
					valueTr += '</tr>';
					table += valueTr;
					table += '</table>';
					$("#tableDiv").children("table").remove();
					$("#tableDiv").append(table);
				}
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
}

function getDocumentVersion(){
	var documentId = $("#documentVersion").val();
	var version = "";
	 $.ajax({ 
			url:'${_baseUrl}/dd/returnDocumentVersion?documentId='+documentId, 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			async: false,
			success: function(data){
				version =data;
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	 return  version;
};
$(function (){
	if($("#documentList > option").length == 0){
		$("#documentList").append("<option value=''>暂无</option>");
	}
})
</script>
<style>
	.xuqiuzz_box { width:300px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; padding:5px 0;}
	.xuqiuzz_curr { width:auto; }
</style>
<body>
    <div class="ma main">
    	<div class="wdang_main">
        	<div class="page_tit_warp mtmb20"><div class="page_tit"><span>需求追踪关系展示</span></div></div>
        	<div class="xuqiuzz_cont">
        	  <div class="xmugonj_curr xuqiuzz_curr xuqiuzz_cuaa">
        	  
               	<div>    <!-- 格式调整，以块状元素排列布局  -->
               		<div class="fl xuqiuzz_box">
               			<strong>文档名称：</strong>${documentInfo.templateName }
               		</div>
               		<div class="fl xuqiuzz_box">
               			<strong id="firstVersion">版本号：</strong>
	                    <select id="documentVersion" onchange="getDocumentHistoryTrace();" style="width:87px;">
	                    	<c:if test="${historyVersionsNull == '1' }">
	                    		<option value="">暂未发布</option>
	                    	</c:if>
	                    	<c:forEach items="${historyVersions }" var="d">
	                    		<option value="${d.id }">${d.documentVersion }</option>
	                    	</c:forEach>
	                    </select>
               		</div>
               		<div class="clear"></div>
               		<div class="fl xuqiuzz_box">
               			<strong>前项文档名称：</strong>
	                    <select id="documentList" onchange="getAgoDocumentVersions('${projectId }')" style="width:135px;">
	                    	<c:forEach items="${documentLists }" var="doc">
	                    		<c:if test="${fn:contains(traceDocumentIds,doc.id) }">
		                   			<option title="${doc.templateName }" value="${doc.id }" <c:if test="${defaultTraceDocumentId == doc.id }">selected="selected"</c:if> >${doc.templateName }</option>
	                    		</c:if>
	                    	</c:forEach> 
	                   </select>
               		</div>
               		<div class="fl xuqiuzz_box">
               			<strong>版本号：</strong>
	                   <select id="agoDocumentVersions" onchange="getDocumentHistoryTrace();" style="width:87px;">
			           </select>
               		</div>
               		<div class="clear"></div>
               	</div>
               
               <%--  <p>
                	<strong>文档名称：</strong>${documentInfo.templateName }
                    <strong id="firstVersion" style="padding-left:88px;">版本号：</strong>
                    <select id="documentVersion" onchange="getDocumentHistoryTrace();" style="width:87px;">
                    	<c:if test="${historyVersionsNull == '1' }">
                    		<option value="">暂未发布</option>
                    	</c:if>
                    	<c:forEach items="${historyVersions }" var="d">
                    		<option value="${d.id }">${d.documentVersion }</option>
                    	</c:forEach>
                    </select>
                </p>
                <p>
                	<strong>前项文档名称：</strong>
                    <select id="documentList" onchange="getAgoDocumentVersions('${projectId }')" style="width:135px;">
                    	<c:forEach items="${documentLists }" var="doc">
                    		<c:if test="${fn:contains(traceDocumentIds,doc.id) }">
	                   			<option title="${doc.templateName }" value="${doc.id }" <c:if test="${defaultTraceDocumentId == doc.id }">selected="selected"</c:if> >${doc.templateName }</option>
                    		</c:if>
                    	</c:forEach> 
                   </select>
                   <strong style="padding-left:32px;">版本号：</strong>
                   <select id="agoDocumentVersions" onchange="getDocumentHistoryTrace();" style="width:87px;">
		           </select>
                </p> --%>
                <p>
                	<strong>文档关联关系：</strong>
                    <span id="documentRelation"></span>
                </p>
              </div>
                <div class="xmugonj_ta_j xuqiuzz_ta_j widthauto" id="tableDiv">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                   		<thead>
                      <tr>
                        <td height="57" colspan="3" align="center" bgcolor="#e9f5ff"><strong></strong><strong></strong></td>
                        <td colspan="3" align="center" bgcolor="#f0f1f1"><strong>该文档尚未建立内容追踪关系</strong></td>
                        </tr>
                      </thead>
                      <tbody id="showTrace">
                      	<tr>
	                        <td width="100" align="center">章节号</td>
	                        <td width="140" align="center"><a href="javascript:;">章节名称</a></td>
	                        <td width="136" align="center">章节标识</td>
	                        <td width="111" align="center">章节号</td>
	                        <td width="142" align="center">章节名称</td>
	                        <td width="139" align="center">章节标识</td>
	                      </tr>
                      </tbody>
                    </table>
              </div>
          </div>
      </div>
    </div>
</body>
</html>