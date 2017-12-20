<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>勘误错误替换界面</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var contentTypeList;
$(function (){
	
	$("#replaceFrom").validationEngine({
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
	
	
	contentTypeList = $("#contentTypeList").bootstrapTable({
		url : '${_baseUrl}/ca/getReplacePageList',
		pagination: true,
		pageList: [200],
  		queryParams: queryParams,
        columns: [{
        	 field: 'checked',
             checkbox: true
         }, {
            title: '序号',
            width: 5,
            formatter: function(value, row, index){
            	return index+1;
            }
        }, {
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'templateName',
            title: '文档名称',
            width: 150
        },{
            field: 'documentVersion',
            title: '文档版本',
            width: 50
        }]
    });

	
	function queryParams(params){
		return {
		    pageSize: 200,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    projectId:"${projectId}"
	   }
	}
	
	//点击提交按钮时触发的函数
	$("#submit").click(function (){
		
		var formChecked = $('#replaceFrom').validationEngine('validate');
		if(formChecked){
			var selected = contentTypeList.bootstrapTable('getSelections');
			if(selected.length < 1){
				layer.msg("请选择需要替换的文档");
				return false;
			}
			var documentNames = [];
			var documentIds = [];
			for(i in selected){
				documentIds.push(selected[i].id);
				documentNames.push(selected[i].templateName);
			}
			layer.load(2);	
			$.ajax({
				url:'${_baseUrl}/ccc/replaceValue',
				type:'post', //数据发送方式 
				dataType:'json', //接受数据格式 
				data: {projectId:"${projectId}",oldContent:$("#oldContent").val(),newContent:$("#newContent").val(),documentNames:documentNames.join(","),
					documentIds:documentIds.join(",")},
				async: true,
				success: function(data){
					parent.alertMessage();
		        },
				error:function(){
					layer.msg( "系统错误");
				}
			});
		}
	});
	
})



function refreshTable(){
	contentTypeList.bootstrapTable('refresh');
}



</script>
<body>
    <div class="document_main">
    	<div class="kwxg_box">
    		<form action="" id="replaceFrom" method="get">
	    		<dl>
	    			<dt>查找内容（将以下内容）</dt>
	    			<dd>
	    				<span><input type="text" class="kwxg_input validate[required,maxSize[50]]" id="oldContent" value="" /></span>
	    				<p>50字以内，区分全/半角</p>
	    			</dd>
	    			<div class="clear"></div>
	    		</dl>
	    		<dl>
	    			<dt>替换内容（内容替换为）</dt>
	    			<dd>
	    				<span><input type="text" class="kwxg_input validate[maxSize[50]]" id="newContent" name="" value="" /></span>
	    				<p>50字以内，区分全/半角</p>
	    			</dd>
	    			<div class="clear"></div>
	    		</dl>
    		</form>
    	
    	</div>
    
    
        
    
            <div class="tablebox2 wdang_s bgenglist" style="margin-left:0">
                <table id="contentTypeList" width="100%" border="0" cellspacing="0" cellpadding="0">
            </table>
      </div>
		  
		<div class="nrlx_btn mt20">
		 	<input type="button" value="提交" id="submit" class="nrlx_btna" />  
		 
		 </div>
		
		
</div>
<div id="popDiv" style="display: none;">
	<iframe id="popIframe"></iframe>
</div>
</body>
</html>