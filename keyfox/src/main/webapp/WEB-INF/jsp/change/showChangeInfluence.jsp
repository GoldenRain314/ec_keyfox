<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>变更分析-影响域分析展示界面</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
$(function (){
	
	initTr();
	
	//变更文档当前行变红
	$("#${changeDocumentId}").children().each(function (i){
		$(this).attr("class","juh_color");
	});
	
	
	/* 是否有错误信息 */
	var message = "${message}";
	if(message != ""){
		layer.msg(message);
	}
	
	//控制不变更按钮
	var documentLists = eval('${documentListJson }');
	var flag = false;
	for(var i=0;i<documentLists.length;i++){
		var doc = documentLists[i];
		if(doc.documentName == '软件研制任务书' || doc.documentName == '软件设计说明' || doc.documentName == '软件需求规格说明' || doc.documentName == '软件需求规格说明书'){
			if("${changeDocumentId}" == doc.documentId){
				flag=true;
				$("#"+doc.documentId+"notChange").hide();
			}
		}
	}
	if(!flag){
		for(var i=0;i<documentLists.length;i++){
			var doc = documentLists[i];
			if(doc.documentName == '软件研制任务书' || doc.documentName == '软件设计说明' || doc.documentName == '软件需求规格说明' || doc.documentName == '软件需求规格说明书'){
				$("#"+doc.documentId+"notChange").hide();
			}
		}
	}
	
	
	// 缺省显示
	$("#docList").html(subProjectName("${documentLocalhost }"));
	
	// 设置iframe高度自适应 
	$("#indexIframe").load(function(){
		var mainheight = $(this).contents().find("body").height() + 30;
		$(this).height(mainheight);
	});
	 if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion .split(";")[1].replace(/[ ]/g,"")=="MSIE8.0") // 判断ie8浏览器啊
	{
		setIframeHeight("indexIframe");
	}
	
});

function setIframeHeight(id){
	try{
        var iframe = document.getElementById(id);
        if (iframe.Document){
        	newHeight = iframe.Document.body.scrollHeight + 20 + "px";
       	}else{
       		newHeight = iframe.contentDocument.body.scrollHeight+ 20 + "px";
       	}
        iframe.style.height = newHeight;
    }catch(e){
        throw new Error('error');
    } 
         
}

/* 不变更 */
function donotChange(projectId,documentId,documentChangeStatus){
	
	if("${changeDocumentId}" == documentId){
		layer.msg("申请变更的文档不能不变更");
		return false;
	}
	$.ajax({
		url:'${_baseUrl}/ci/checkWriteDocument?projectId='+projectId+'&documentId='+documentId,
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		async: false,
		success: function(data){
			if(data.code == '1'){
				layer.msg("发起变更的文档没有完成变更");     /* 修改提示语：发起变更的文档没有完成变更 即可 后半句反而容易产生歧义   */
				return false;
			}else{
				if("4" == documentChangeStatus){
					layer.msg("已确定不变更");
				}else if("2" == documentChangeStatus){
					layer.msg("该文档已变更");
				}else{
					window.location.href = "${_baseUrl}/ci/doNotChange?projectId=${projectId}&documentId="+documentId+"&changeId=${changeId}";
				}
			}
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
}

/* 跳转到文档编写 */
function writeChange(projectId,documentId,documentChangeStatus,documentManger){
	
	/* 2017-06-26添加任务 发起文档需要先结束变更其他文档才能继续操作*/
	$.ajax({
		url:'${_baseUrl}/ci/checkWriteDocument?projectId='+projectId+'&documentId='+documentId,
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		async: false,
		success: function(data){
			if(data.code == '1'){
				layer.msg("发起变更的文档没有完成变更");     /* 修改提示语：发起变更的文档没有完成变更 即可 后半句反而容易产生歧义   */
				return false;
			}else{
				if("5" == documentChangeStatus){
					layer.msg("请等待相关文档变更完成");
					return false;
				}else if("2" == documentChangeStatus){
					layer.msg("文档已变更完成");
				}else{
					if("4" == documentChangeStatus){
						layer.msg("已执行文档不变更");
					}else{
						if("${user_id}" == documentManger||"${user_id}" == "${proId}"){
							var isHas = "";
							$.ajax({
								url:'${_baseUrl}/document/selectSonIdByDocumentId?documentId='+documentId,
								type:'post', //数据发送方式 
								dataType:'text', //接受数据格式 
								async: false,
								success: function(data){
									isHas = data;
						        },
								error:function(){
									layer.msg( "系统错误");
								}
							});
							if(isHas == "false"){
								$.ajax({
									url:'${_baseUrl}/document/createNewDocument?documentId='+documentId,
									type:'post', //数据发送方式 
									dataType:'text', //接受数据格式 
									async: false,
									success: function(data){
										parent.skipModule("文档编写","${_baseUrl}/documentSectionController/sectionTree?projectId="+projectId+"&documentId="+data);
							        },
									error:function(){
										layer.msg( "系统错误");
									}
								});
							}else{
								$.ajax({
									url:'${_baseUrl}/document/getNewDocumentId?documentId='+documentId,
									type:'post', //数据发送方式 
									dataType:'text', //接受数据格式 
									async: false,
									success: function(data){
										parent.skipModule("文档编写","${_baseUrl}/documentSectionController/sectionTree?projectId="+projectId+"&documentId="+data);
							        },
									error:function(){
										layer.msg( "系统错误");
									}
								});
								
							}
						}else{
							layer.msg("文档负责人才可进行文档变更");
						}
					}
					
				}
			}
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
	
	
}


function changeDocumentContent(projectId,documentId,changeId,documentManagerId,documentChangeStatus){
	if("4" == documentChangeStatus){
		layer.msg("文档已确定不变更！");
		return false;
	}
	if("2" != documentChangeStatus){
		layer.msg("变更完成后查看内容变更单");
		return false;
	}
	window.location.href = "${_baseUrl}/cdc/showChangeContent?projectId="+projectId+"&documentId="+documentId+"&changeId="+changeId;
	//检查申请单
	/* $.ajax({
		url:'${_baseUrl}/cdc/checkChangeDocumentContent',
		type:'get', //数据发送方式 
		dataType:'json', //接受数据格式 
		data:{documentManagerId:documentManagerId},
		async: false,
		success: function(data){
			//新增
			if("0" == data.code){
			}
        },
		error:function(){
			layer.msg( "网络繁忙,请稍后重试");
		}
	}); */
}

/* 结束变更 */
function endChange(projectId){
	//验证是否可以结束变更
	$.ajax({
		url:'${_baseUrl}/ci/isEndChange?rand='+Math.random(),
		type:'get', //数据发送方式 
		dataType:'json', //接受数据格式 
		data:{projectId:projectId},
		async: false,
		success: function(data){
			if("0" == data.code){
				if("skip" == data.message){
					layer.confirm('变更影响域的文档中存在“预发布”状态的文档,建议先对其进行发布!', {
			            btn: ['确定','忽略']
			        }, function(index){
			        	layer.close(index);
			        }, function(){
			        	ajaxEndChange(projectId);
			        });
				}else if("no" == data.message){
					layer.msg("非变更发起人不能结束变更");
				}else{
					ajaxEndChange(projectId);
				}
			}else{
				layer.msg(data.message);
			}
        },
		error:function(){
			layer.msg( "系统错误,请联系管理员");
		}
	});
}

function ajaxEndChange(projectId){
	$.ajax({
		url:'${_baseUrl}/ci/endHistory?rand='+Math.random(),
		type:'get', //数据发送方式 
		dataType:'json', //接受数据格式 
		data:{projectId:projectId},
		async: false,
		success: function(data){
			if("0" == data.code){
				layer.msg(data.message,{shift:5,time:1000},function(){
					parent.skipModule("文档编写","${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&id="+data.data+"&source=projectList");
				})
			}else{
				layer.msg(data.message,{shift:5,time:1000},function (){});
			}
        },
		error:function(){
			layer.msg( "系统错误,请联系管理员");
		}
	});
	
}

function chechNewDocument(projectId,documentId,documentStatus){
	if("4" == documentStatus){
		layer.msg("文档已确定不变更！");
		return false;
	}
	if("2" != documentStatus){
		layer.msg("文档还未进行变更！");
		return false;
	}
	//添加模板分类数据
	$("#popIframe").empty();	
	$("#popDiv").dialog({
		title:'变更后文档',
		autoOpen: true,
		modal: true,
		position:'top',
		height: 600,
		width: 800
	});	
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/documentController/documentChangePreview?documentId="+documentId+"&projectId="+projectId);
}


function initTr(){
/* 	<c:forEach var="doc" items="${documentList }" varStatus="index">
  	<tr id="${doc.documentId }" <c:if test="${(index.index+1) %2 == 0 }">bgcolor="#f1f3f6"</c:if> >
  		<td align="center">${index.index+1 }</td>
        <td align="center">${doc.documentName }</td>
        <td align="center">${doc.documentVersion }</td>
        <td align="center">${doc.documentManagerName }</td>
        <td align="center">
        	<c:if test="${doc.documentChangeStatus == '1' }">未变更</c:if> 
        	<c:if test="${doc.documentChangeStatus == '2' }">已变更</c:if> 
        	<c:if test="${doc.documentChangeStatus == '3' }">预发布</c:if> 
        	<c:if test="${doc.documentChangeStatus == '4' }">不变更</c:if> 
        	<c:if test="${doc.documentChangeStatus == '5' }">等待变更</c:if> 
        </td>
        <td align="center">${doc.traceDocumentName }</td>
        <td align="left">replaceName(${doc.traceSectionNames })</td>
        <td align="center">
        	<a href="javascript:void(0);" onclick="chechNewDocument('${doc.projectId}','${doc.documentId}','${doc.documentChangeStatus}');">查看</a>
        <td align="left">${doc.changeSectioNames}</td>
        <td align="center"><a href="javascript:void(0);" onclick="changeDocumentContent('${doc.projectId}','${doc.documentId }','${doc.changeId }','${doc.documentManagerId }','${doc.documentChangeStatus}')">查看</a></td>
        <td align="center">
        	<c:if test="${doc.documentChangeDate== null}">
        		-
        	</c:if>
        	<c:if test="${doc.documentChangeDate != null}">
        		${doc.documentChangeDate}
        	</c:if>
        </td>
        <td align="center">
        	<a href="javascript:void(0);" onclick="writeChange('${doc.projectId}','${doc.documentId }','${doc.documentChangeStatus}','${doc.documentManagerId }')">文档变更</a>
        	<c:if test="${doc.documentName == '软件研制任务书' || doc.documentName == '软件设计说明' || doc.documentName == '软件需求规格说明' || doc.documentName == '软件需求规格说明书'}">
        		<c:if test="${demandModel.source == '初始化' }">
                	<a href="javascript:void(0);" id="${doc.documentId }notChange" onclick="donotChange('${doc.documentId}','${doc.documentChangeStatus}')">不变更</a>
        		</c:if>
        	</c:if>
        </td>
  	</tr>
	</c:forEach> */
	
	var tr = '<c:forEach var="doc" items="${documentList }" varStatus="index">';
	tr += '<tr id="${doc.documentId }" <c:if test="${(index.index+1) %2 == 0 }">bgcolor="#f1f3f6"</c:if> >';
	tr += '<td align="center">${index.index+1 }</td>';
	tr += '<td align="center">${doc.documentName }</td>';
	tr += '<td align="center">${doc.documentVersion }</td>';
	tr += '<td align="center">${doc.documentManagerName }</td>';
	tr += '<td align="center">';
	tr += '<c:if test="${doc.documentChangeStatus == \'1\' }">未变更</c:if>';
	tr += '<c:if test="${doc.documentChangeStatus == \'2\' }">已变更</c:if>';
	tr += '<c:if test="${doc.documentChangeStatus == \'3\' }">预发布</c:if>';
	tr += '<c:if test="${doc.documentChangeStatus == \'4\' }">不变更</c:if>';
	tr += '<c:if test="${doc.documentChangeStatus == \'5\' }">等待变更</c:if>';
	tr += '</td>';
	tr += ' <td align="center">${doc.traceDocumentName }</td>';
	tr += '<td align="left">'+replaceNameValue('${doc.traceSectionNames }')+'</td>';
	tr += '<td align="center">';
	tr += '<a href="javascript:void(0);" onclick="chechNewDocument(\'${doc.projectId}\',\'${doc.documentId}\',\'${doc.documentChangeStatus}\');">查看</a>';
	tr += '</td>';
	tr += '<td align="left">'+replaceNameValue('${doc.changeSectioNames}')+'</td>';
	tr += '<td align="center"><a href="javascript:void(0);" onclick="changeDocumentContent(\'${doc.projectId}\',\'${doc.documentId }\',\'${doc.changeId }\',\'${doc.documentManagerId }\',\'${doc.documentChangeStatus}\')">查看</a></td>';
	tr += '<td align="center">';
	tr += '<c:if test="${doc.documentChangeDate== null}">-</c:if>';
	tr += '<c:if test="${doc.documentChangeDate != null}">${doc.documentChangeDate}</c:if>';
	tr += '</td>';
	tr += '<td align="center">';
	tr += '<a href="javascript:void(0);" onclick="writeChange(\'${doc.projectId}\',\'${doc.documentId }\',\'${doc.documentChangeStatus}\',\'${doc.documentManagerId }\')">文档变更</a>';
	tr += '<c:if test="${doc.documentName == \'软件研制任务书\' || doc.documentName == \'软件设计说明\' || doc.documentName == \'软件需求规格说明\' || doc.documentName == \'软件需求规格说明书\'}">';
	tr += '<c:if test="${demandModel.source == \'初始化\' }">';
	tr += '</br><a href="javascript:void(0);" id="${doc.documentId }notChange" onclick="donotChange(\'${doc.projectId}\',\'${doc.documentId}\',\'${doc.documentChangeStatus}\')">不变更</a>';
	tr += '</c:if></c:if>';
	tr += '</td></tr></c:forEach>';
	$("#tr").append(tr);
}


// 省缺显示50字符
function subProjectName(name){
	if(name.length>50){
		name = name.substring(0,50);
		name += "...";
	}
	return name;
}

function replaceNameValue(name){
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


function checkWriteDocument(projectId,documentId){
	$.ajax({
		url:'${_baseUrl}/ci/checkWriteDocument?projectId='+projectId+'&documentId='+documentId,
		type:'post', //数据发送方式 
		dataType:'text', //接受数据格式 
		async: false,
		success: function(data){
			if(data.code != '0'){
				layer.msg("发起文档操作后才能操作");
				return false;
			}
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
}
</script>
</head>
<body>
<div class="ma main">
    	<div class="wdang_main">
        	<div class="page_tit_warp mtmb20"><div class="page_tit"><span>影响域分析</span></div></div>
        	<div class="document_maina">
            <div class="current_wz mtmb20" style="height:27px; line-height:27px;">
            	<strong>项目目录：</strong><span id="docList" title="${documentLocalhost }">${documentLocalhost }</span>
	            <div class="fr glqxian_btn">
	            	<shiro:hasPermission name="ci:endHistory">
				       <a href="javascript:endChange('${projectId }')" class="glqxian_btn1">结束变更</a>
				    </shiro:hasPermission>
	            </div>
            </div>
            </div>
            <div class="tablebox2 wdang_s bgenglist">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" id="changeInfluence">
                    <thead>
                      <tr>
                       <td width="3%" height="50" align="center" bgcolor="#f5f6f6">序 号</td>
                        <td width="10%" align="center" bgcolor="#f5f6f6">工作产品</td>
                        <td width="5%" align="center" bgcolor="#f5f6f6">当前版本</td>
                        <td width="7%" align="center" bgcolor="#f5f6f6">文档负责人</td>
                        <td width="5%" align="center" bgcolor="#f5f6f6">变更状态</td>
                        <td width="13%" align="center" bgcolor="#f5f6f6">追踪关系详情</td>
                        <td width="9%" align="center" bgcolor="#f5f6f6">影响章节</td>
                        <td width="5%" align="center" bgcolor="#f5f6f6">变更后文档</td>
                        <td width="11%" align="center" bgcolor="#f5f6f6">变更章节</td>
                        <td width="8%" align="center" bgcolor="#f5f6f6">内容变更单</td>
                        <td width="10%" align="center" bgcolor="#f5f6f6">文档变更发布时间</td>
                        <td width="5%" align="center" bgcolor="#f5f6f6">变更操作</td>
                      </tr>
                  </thead>
                  <tbody id="tr">
                  
                  </tbody>
                </table>
              </div>
            <iframe id="indexIframe" frameborder="0" style="width:100%; height:100%; " src="${_baseUrl}/ci/showChangeRequestNoteDetails?projectId=${projectId}&changeId=${changeId}"></iframe>
    </div>
    <div id="popDiv" style="display: none;">
	<iframe id="popIframe" border="0" frameborder="no"></iframe>
</div>
	<div class="clear"></div>
</body>
</html>