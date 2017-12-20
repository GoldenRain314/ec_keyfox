<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>评审级别</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />

<script type="text/javascript" src="${_resources}bootstrap/bootstrap-table1.js"></script>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table1.min.css" />
<script type="text/javascript" src="${_resources}js/organizationValidatePosition.js"></script>

<script type="text/javascript">
var dtApplicationList;
var searchValue = null;
function getSelect(){
	var selectId="";
	var objects =  $("#dtApplicationList").bootstrapTable('getSelections');
	for(var i =0;i<objects.length;i++){
		if(selectId.length>0){
			selectId+=","+objects[i].id;
		}else{
			selectId=objects[i].id;
		}
	}
	return selectId;
}
$(function (){
	dtApplicationList = $("#dtApplicationList").bootstrapTable({
		url : '${_baseUrl}/dtApplication/selectdtApplicationMessage',
		pagination: true,
		pageList: getPageList(),
  		queryParams: queryParams,
  		clickToSelect: false,
        columns: [{
             checkbox: true
         }, {
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'serial',
            title: '序号',
            width: 50,
            formatter : function(value, row, index) {
            	if(status){
            		var str=value;
            	}else{
            		var str=index+1;
            	}
			return str;
            }
        },{
            field: 'application',
            title: '文档范本适用范围',    /* 修改显示标题名称  */
            width: 100,
            formatter: function(value, row, index){
            	return "<a href='javascript:void(0)' onclick=\"updatedtApplicationList('"+row.id+"')\">"+value+"</a>";
            }
        },{
            field: 'description',
            title: '说明',
            width: 300
        }]
    });
	
	function queryParams(params){
		if($("#searchValue").val() == "搜索您想寻找的..."){
			searchValue = null;
		}else{
			searchValue = $("#searchValue").val();
		}
		return {
		    pageSize: getpageSize(params),
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    searchValue : searchValue
	   }
	}
	
	$("#searchValue").keydown(function(event) {//给输入框绑定按键事件
	    if(event.keyCode == "13") {//判断如果按下的是回车键则执行下面的代码
	    	refreshTable();
	  	}
	})
	
	function getpageSize(params){
		if("${setPageSize}" != null && "${setPageSize}" != ""){
			return "${setPageSize}";
		}else{
			return params.limit;
		}
	}
	
	function getPageList(){
		var array;
		if("${setPageSize}" != null && "${setPageSize}" != ""){
			var size = "${setPageSize}";
			array = [size];
		}else{
			array = [5, 10, 20, 50];
		}
		return array;
	}
	
	/* 添加 */
	$("#add").click(function (){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'添加文档范本适用范围',
			autoOpen: true,
			modal: true,	
			height: 'auto',
			width: 700
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/dtApplication/adddtApplicationMessage");
	});
	
	/* 删除*/
	$("#del").click(function (){
		var selected = dtApplicationList.bootstrapTable('getSelections');
		if(selected.length < 1){
			layer.msg("请选择要批量删除的数据");
			return false;
		}
		var ids = [];
		for(i in selected){
			ids.push(selected[i].id);
		}
		var options = "确认删除吗?";
		layer.confirm(options,{
    		btn:['确定','取消']},
    		function (){
    			$.ajax({
    				url : "${_baseUrl}/dtApplication/deletedtApplicationMessage",
    				type : "post",
    				dataType : "json",
    				async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
    		  		data : {ids : ids.join(',')},
    				success : function(json) {
    					layer.msg(json.message);
    					refreshTable();
    				},
    				error:function(data){
    					layer.msg("网络忙，请稍后重试");
    				}
    			});
    		},
    		function(){
    			return;
    		}
	    );
	});
	init();
})
function updatedtApplicationList(id){
	var userId = '<shiro:hasPermission name="dtApplication:adddtApplicationMessage">1</shiro:hasPermission>';
	$("#popIframe").empty();
	$("#popDiv").dialog({
		title:(userId!='')?'修改文档范本的适用范围':'文档范本的适用范围',     /* 依据用户信息显示弹框标题   */
		autoOpen: true,
		modal: true,	
		height: 'auto',
		width: 700
	});
	$("#popIframe").attr("width","100%");
	$("#popIframe").attr("height","95%");
	$("#popIframe").attr("src","${_baseUrl}/dtApplication/updatedtApplicationMessage?id="+id);

}
/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	//window.location.reload();
	dtApplicationList.bootstrapTable('refresh');
}
function init(){
	var iframeH = $('#rightIframe', window.parent.document).height();
	$("body").height(iframeH);
	$("#popIframe").load(function () {   
	    var mainheight = $(this).contents().find("body").height() + 30;
	    $(this).height(mainheight);
	    var temp = '<shiro:hasPermission name="dtApplication:adddtApplicationMessage">1</shiro:hasPermission>';
	    var oInput = $(this).contents().find("input[type='text']");
	    var oSelect = $(this).contents().find("select");
	    
	    var oI = $(this).contents().find(".clearCross");
	    if(temp == ''){
	    	oInput.each(function(){
	    		$(this).attr('disabled',true);
	    	})
	    	oSelect.each(function(){
	    		$(this).attr('disabled',true);
	    	})
	    	if(oI != null){
				oI.each(function(){
					$(this).css("background","#F0F0F0");
				})
			}
	    }
	});
}

</script>
</head>
<body>
<div class="main_cont">
       	<div class="main_c">
               <div class="current_cont">
                   <div class="fl current_c">
                        当前位置 ： <a href="javascript:;">组织资产</a>  >  <a href="javascript:;">软件管理类</a>  >  文档范本的适用范围
                   </div>            
                   <div class="fr current_j">
                       <ul>
                           <li>
                           		<shiro:hasPermission name="dtApplication:adddtApplicationMessage">
							       <a href="javascript:;" class="current_1" id="add">添加</a>
							    </shiro:hasPermission>
                           </li>
                           <li>
                           		<shiro:hasPermission name="dtApplication:deletedtApplicationMessage">
							       <a href="javascript:;" class="current_2" id="del">删除</a>
							    </shiro:hasPermission>
                           	</li>
                           <div class="clear"></div>
                       </ul>
                   </div>
                   <div class="fr current_s">
                    <div class="fl current_s_i"><input id="searchValue" name="" type="text" class="input_text1" value="${searchValue}" onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
                       <div class="fl current_s_a"><input name="" type="button" value="搜索" class="input_btn1" onclick="refreshTable()"></div>
                       <div class="clear"></div>
                   </div>
                   <div class="clear"></div>
                           
               </div>
               
               <div class="personnel_cont">
		        <!--tab-w-01----->
		        <table id="dtApplicationList" class="tab-w-01 tab-w-auto"></table>         
               </div>
           
    	 </div>
     </div>
     
     <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>
</body>
</html>