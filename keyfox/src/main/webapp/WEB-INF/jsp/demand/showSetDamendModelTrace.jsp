<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>设置前项追踪文档</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>

<script type="text/javascript">
$(function (){
	//文档ID
	var documentId = "${documentId}";
	//文档模板ID
	var demandId = "${demandId}";
	
	var checkedListJson = '${checkedListJson}';
	if(checkedListJson != ""){
		var checkedListJsonObject = eval('('+checkedListJson+')');
		for(var i in checkedListJsonObject){
			
			$("#"+checkedListJsonObject[i].agoDocumentId).attr("checked",true);
			$("input[type=radio][name='"+checkedListJsonObject[i].agoDocumentId+"'][value="+checkedListJsonObject[i].documentRelation+"]").attr("checked",'checked')
		}
	}
	
	//关闭弹出框界面
	$("#close").click(function (){
		parent.closeWin();
	});
	
	/*保存按钮触发的方法  */
	$("#save").click(function (){
		var ago_document_id = [];
		$("input:checkbox").each(function (){
			if($(this).is(':checked')){
				//alert($("input[name='"+$(this).attr('id')+"']:checked").val());
				ago_document_id.push($(this).attr('id')+":"+$("input[name='"+$(this).attr('id')+"']:checked").val());
			}
		});
		$.ajax({
			url : "${_baseUrl}/demand/insertDemandModelTrace",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {demandId : "${demandId}",documentId:"${documentId}",ago_document_id:ago_document_id.join(",")},
			success : function(json) {
				layer.msg(json.message,{shift:5,time:1000},function(){
					parent.changeTableList();
					parent.closeWin();
				});
			},
			error:function(data){
				layer.msg("网络忙,请稍后重试");
			}
		});
		
		
	});
	
	
	
});

function judgeSelect(){
	$("input:checkbox").each(function (){
		if($(this).is(':checked')){
			
		}else{
			$(this).attr("checked",false);	
			
			$("input[name='"+$(this).attr("id")+"']").each(function (i,item){
				$(item).attr("checked",false);	
			});
		}
	});
}

function selectDocument(id){

	$("input[name='"+id+"']").each(function (){
		
		if($(this).is(':checked')){
			$("#"+id).prop("checked",true);	
		}
		if(this.checked){		
			$("#"+id).prop("checked",true);	
		}
	});
	
	
}

</script>
<body>

<div class="glianwd_popup">
	<div class="glianwd_tc_top">
    	<div class="fl glianwd_tc_l">
        	<a href="javascript:;" class="glianwd_tca1 glianwd_tca1a">内容追踪文档</a>
            <a href="javascript:;">前置关联文档</a>
        </div>
        <div class="fl glianwd_tc_r">
        	<span>关联文档名称：</span>
            <div class="glianwd_tc_cont">
            	<ul>
            		<c:forEach items="${allCheckList }" var="tep">
						<li><em class="glianwd_em1"><input type="checkbox"  onclick="judgeSelect();" name="check"   id="${tep.id }"/><i title="${tep.documentTemplateName }">${tep.documentTemplateName }</i></em><em><input name="${tep.id }" onclick="selectDocument('${tep.id }');"  type="radio" value="0"/>直接关联</em><em><input name="${tep.id }" onclick="selectDocument('${tep.id }');" type="radio" value="1"/>间接关联</em></li>
					</c:forEach>
                    <!-- <li><input name="" type="checkbox" value="">软件测试计划</li>
                    <li><input name="" type="checkbox" value="">软件测试计划</li>
                    <li><input name="" type="checkbox" value="">软件测试计划</li>
                    <li><input name="" type="checkbox" value="">软件测试计划</li>
                    <li><input name="" type="checkbox" value="">软件测试计划</li>
                    <li><input name="" type="checkbox" value="">软件测试计划</li>
                    <li><input name="" type="checkbox" value="">软件测试计划</li>
                    <li><input name="" type="checkbox" value="">软件测试计划</li> -->
            	</ul>
            </div>
        </div>
    </div>
    <div class="permission_an mubanclass_an ma" style="padding-left:279px; text-align:left; margin-top:27px;">
    	<a href="javascript:;" class="per_baocun" id="save">提 交</a>
        <a href="javascript:;" class="per_gbi" id="close">取 消</a>
    </div>
</div>

	<%-- <div id="checkboxDiv">
		<c:forEach items="${allCheckList }" var="tep">
			<input type="checkbox" name="check" id="${tep.id }"/>${tep.documentTemplateName }<br>
		</c:forEach>
	</div> --%>
	<!-- <input type="button" value="保存" id="save" /> -->
</body>
</html>