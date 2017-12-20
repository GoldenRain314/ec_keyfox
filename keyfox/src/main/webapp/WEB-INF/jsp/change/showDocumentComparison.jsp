<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档内容对比</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>

<link rel="stylesheet" href="/KD/resources/css/jquery.jscrollpane1.css" />
<script type="text/javascript">
$(function (){
	//关闭弹出框界面
	$("#close").click(function (){
		parent.closeWin();
	});
	subProjectName();
	
	// 列表样式调整
	var isClick = false;
	var obj = $("a[name='isClick']");
	var height = obj.outerHeight(true);
	$("#xiugaixq_text").css({'max-height':5*height});
	obj.first().trigger("focus");
	obj.each(function(){
		$(this).click(function(){
			isClick = true;
			if(isClick){
				$(this).css({'background':'none','color':'#017FED','font-weight':'bold'});
				obj.not($(this)).css({'background':'#F9F9F9','color':'#666','font-weight':'normal'});
			}
		})
	})
});

function showSectionContent(sectionId){
	$.ajax({
		url:'${_baseUrl}/dd/selectSectionContentBySectionId?rand='+Math.random(), 
		type:'post', //数据发送方式 
		dataType:'json', //接受数据格式 
		data:{"sectionId":sectionId},
		async: false,
		success: function(data){
			$("#left_content").html(data.content);
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
	
	$.ajax({
		url:'${_baseUrl}/cdc/getNewSectionId?rand='+Math.random(), 
		type:'post', //数据发送方式 
		dataType:'text', //接受数据格式 
		data:{"sectionId":sectionId,"newDocumentId":"${newDocumentBaseInfo.id}"},
		async: false,
		success: function(data){
			$.ajax({
				url:'${_baseUrl}/dd/selectSectionContentBySectionId?rand='+Math.random(), 
				type:'post', //数据发送方式 
				dataType:'json', //接受数据格式 
				data:{"sectionId":data},
				async: false,
				success: function(data){
					$("#right_content").html(data.content);
		        },
				error:function(){
					layer.msg( "系统错误");
				}
			});
        },
		error:function(){
			layer.msg( "系统错误");
		}
	});
}

// 字符缺省显示 13个字符
function subProjectName(){
	var obj = $(".glianwd_tc_l a");
	var obj1 = $(".glianwd_tc_l span")
	var str = "";
	obj.each(function(){
		if($(this).html().length > 13){
			$(this).attr("title",$(this).html());
			str = $(this).html().substring(0,13);
			str += "...";
			$(this).html(str);
		}else{
			return true;
		}
	})
	
	if(obj1.html().length > 12){
		obj1.attr("title",obj1.html());
		str = obj1.html().substring(0,12);
		str += "...";
		obj1.html(str);
	}
}
</script>
<style>
	.glianwd_tc_top { height:100%; padding:0; margin: 13px auto; width:750px;}
	.glianwd_tc_l { border-right:none; height:auto;  margin-right:20px;}
	.glianwd_tc_l .glianwd_tca1a { text-align:center; border:none; color:#666; background:#fff;}
	.glianwd_tc_l a { width:90%; width:88%\0; margin:0 auto; text-align:left; border:none; color: #666; padding: 8px 10px; background: #F9F9F9; border-bottom: 1px dotted gainsboro; }
	.glianwd_tc_l a:hover,.glianwd_tc_l a:focus{ color:#017FED; background:none;font-weight:bold;}
	.glianwd_tc_l_box { border:1px solid gainsboro; border-top:none; width:200px;}
	.glianwd_tc_l_title { border:1px solid gainsboro; text-align:center; height:55px; line-height:55px; width:200px;}
	.glianwd_tc_l { width:230px;}
	.xiugaixq_list { width:254px; height:360px;}
	.xiugaixq_text, .xiugaixq_text2 { height:360px;}
</style>
<body>
	<div class="glianwd_tc_top">
    	<div class="fl glianwd_tc_l" style=" position:fixed;">
    		<div class="glianwd_tc_l_title">
        		<span href="javascript:;" class="glianwd_tca1 glianwd_tca1a">${documentBaseInfo.templateName}</span>
        	</div>
        	<div id="xiugaixq_text" class="xiugaixq_text" style=" width:210px; overflow-y:auto; overflow-x:hidden;">
	        	<div class="glianwd_tc_l_box ">
	        		<c:forEach items="${changeContents }" var="cc">
		            	<a name='isClick' href="javascript:showSectionContent('${cc.changeSectionId }');" onfocus="showSectionContent('${cc.changeSectionId }')">${cc.changeSectionNumber }</a>
		            </c:forEach>
	            </div>
	         </div>
        </div>
        <div style=" position:relative; left:230px;">
	        <span style="position:absolute; left:0;"><span>变更前版本号：</span><strong>${documentBaseInfo.documentVersion }</strong></span>
	        <div class="fl xiugaixq_list xiugaixq_list3">
	        	<div class="xiugaixq_text">
	        		<div id="left_content" class="xiugaixq_texta"></div>
	        	</div>
	       	</div>
	       	<span style=" position:absolute; left:265px;"><span>变更后版本号：</span><strong>${newDocumentBaseInfo.documentVersion }</strong></span>
	       	<div class="fl xiugaixq_list xiugaixq_list3">
	        	<div class="xiugaixq_text">
	        		<div id="right_content" class="xiugaixq_texta"></div>
	        	</div>
	       	</div>
	        <div class="clear"></div>
        </div>
    </div>
</body>
</html>