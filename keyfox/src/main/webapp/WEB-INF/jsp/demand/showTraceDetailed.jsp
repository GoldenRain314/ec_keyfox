<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
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
	var trJson = eval('(${trString})');
	var documentTraceList = eval('(${documentTraceList})');
	
	if("true" == "${showButton}"){
		$("#showEditTrace").show();
		$("#returnDocumentList").show();
	}
	
	if(trJson.length == 0){
		return false;
	}
	var documentTraceNumber = trJson[0].traceDocumentNumber;
	if(documentTraceNumber > 0){
		//table 表格
		var table = '<table width="100%" border="0" cellspacing="0" cellpadding="0">';
        var titletr = '<tr>';
        var firstTr = '<tr>';
		//表头
		for(var dd=0;dd<documentTraceList.length;dd++){
			titletr += '<td class="'+documentTraceList[dd].id+'" height="57" colspan="3" align="center" bgcolor="#e9f5ff"><strong></strong><strong>'+documentTraceList[dd].templateName+' ('+initVersion(documentTraceList[dd].documentVersion)+')</strong></td>';
			
			firstTr += '<td width="110" align="center">章节号</td>';
			firstTr += '<td width="180" align="center">章节名称</td>';
			firstTr += '<td width="137" align="center">章节标识</td>';
		}
		titletr += '<td colspan="3" align="center" bgcolor="#f0f1f1"><strong>${documentInfo.templateName } ('+initVersion("${documentInfo.documentVersion }")+')</strong></td>';
		titletr += '<td rowspan="2" width="100px;" align="center" bgcolor="#f0f1f1"><strong>内容追踪类型</strong></td>';
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
					var sectionNum = "--";
					if(!(json_data[0].sectionNumber==undefined)){
						sectionNum = json_data[0].sectionNumber;
					}
					valueTr += '<td align="center">'+sectionNum+'</td>';
					valueTr += '<td align="center">'+json_data[0].sectionName+'</td>';
					valueTr += '<td align="center">'+initValue(json_data[0].sectionMark)+'</td>';
					valueTr += '<td align="center">';
					if(json_data[0].traceRelation=='0'){
						valueTr +='强关联';	
					}else{
						if(json_data[0].traceRelation=='1'){
							valueTr +='弱关联';	
						}else{
							if(json_data[0].traceRelation=='2'){
								valueTr +='内容引用';		
							}else{
								valueTr +='&nbsp;';								
							}
						}
					}
					valueTr +='</td>';
				}else{
					valueTr += '<td align="center"></td>';
					valueTr += '<td align="center"></td>';
					valueTr += '<td align="center"></td>';
					valueTr += '<td align="center"></td>';
				}
				
				valueTr += '</tr>';
				table += valueTr;
			}
		}
		table += '</table>';
	}
	
	$("#tableDiv").children("table").remove();
	$("#tableDiv").append(table);
	
	
	/* 	var tr = '<tr>'
	tr += '<td width="100" align="center">章节号</td>';
	tr += '<td width="140" align="center"><a href="javascript:;">需求项名称</a></td>';
	tr += '<td width="136" align="center">需求标识</td>';
	tr += '<td width="111" align="center">章节号</td>';
	tr += '<td width="142" align="center">需求项名称</td>';
	tr += '<td width="139" align="center">需求项标识</td>';
tr += '</tr>'; */
	
/* 	for(var i in trJson){
		//章节ID
		var sectionId = trJson[i].sectionId;
		var trc = trJson[i].list;
		for(ii in trc){
			tr += '<tr class="'+trJson[i].sectionId+'">';
				tr += '<td align="center">'+trc[ii].traceSectionNumber+'</td>';
				tr += '<td align="center">'+trc[ii].traceSectionName+'</td>';
				var traceSectionMark = "";
				if(trc[ii].traceSectionMark != undefined){
					traceSectionMark = trc[ii].traceSectionMark;
				}
				tr += '<td align="center">'+traceSectionMark+'</td>';
				tr += '<td align="center">'+trc[ii].sectionNumber+'</td>';
				tr += '<td align="center">'+trc[ii].sectionName+'</td>';
				var sectionMark = "";
				if(trc[ii].sectionMark != undefined){
					sectionMark = trc[ii].sectionMark;
				}
				tr += '<td align="center">'+sectionMark+'</td>';
			tr += '</tr>';
		}
	} */
   /*  $("#showTrace").children("tr").remove();
    $("#showTrace").append(tr);
     */
       
     
})

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



</script>
<body>
    <div class="ma main">
    	<div class="wdang_main">
        	<div class="page_tit_warp mtmb20"><div class="page_tit"><span>需求追踪关系展示</span></div></div>
        	<div class="xuqiuzz_cont">
        	  <div class="xmugonj_curr xuqiuzz_curr" style="margin:0; padding-bottom:10px;">   <!-- 调整文本到表格框的距离 170511 -->
                <p><strong>文档名称：</strong>${documentInfo.templateName }</p>
                  <p><strong>文档位置：</strong>${location }</p>
                  <div class="glqxian_btn xuqiuzz_btn mb10" style=" height:auto;">    <!-- 调整文本到表格框的距离 170511 -->
                  	<%-- <a href="${_baseUrl }/dd/showDemandDocumentList?projectId=${projectId}" class="fr glqxian_btn2">返回文档列表</a> --%>
                  	<shiro:hasPermission name="dd:showProjectDocumentList">
				       <a id="returnDocumentList"  style="display: none;" href="javascript:history.go(-1)" class="fr glqxian_btn2">返回文档列表</a>
				    </shiro:hasPermission>
                  	<shiro:hasPermission name="dd:showTraceRelation">
				       <a id="showEditTrace" style="display: none;" href="${_baseUrl }/dd/showTraceRelation?projectId=${projectId }&documentId=${documentId}" class="fr mr18 glqxian_btn1">设置需求追踪</a>
				    </shiro:hasPermission>
                  </div>
              </div>
              <!-- <div class="xmugonj_bz xuqiuzz_bz">
                	<dl>
                    	<dt>显示方式：</dt>
                        <dd>
                        	<select class="xmugonj_select">
                              <option value="aa">aa</option>
                              <option value="aa">aaa</option>
                          </select>
                        </dd>
                        <div class="clear"></div>
                    </dl>
              </div> -->
                
                <div class="xmugonj_ta_j xuqiuzz_ta_j widthauto" id="tableDiv">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td height="57" colspan="3" align="center" bgcolor="#e9f5ff"><strong></strong><strong></strong></td>
                        <td colspan="3" align="center" bgcolor="#f0f1f1"><strong>该文档尚未建立内容追踪关系</strong></td>
                        <td rowspan="2" align="center" bgcolor="#f0f1f1"><strong>内容追踪类型</strong></td>
                        </tr>
                      	<tr>
	                        <td width="100" align="center">章节号</td>
	                        <td width="140" align="center"><a href="javascript:;">章节名称</a></td>
	                        <td width="136" align="center">章节项标识</td>
	                        <td width="111" align="center">章节号</td>
	                        <td width="142" align="center">章节名称</td>
	                        <td width="139" align="center">章节标识</td>
	                      </tr>
                    </table>
              </div>
          </div>
      </div>
    </div>
</body>
</html>