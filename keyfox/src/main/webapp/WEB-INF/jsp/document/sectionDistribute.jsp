<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档协同编制</title>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0 minimal-ui"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<style type="text/css">
.s_glianwd_tc_r{
	width:500px;	
}
.glianwd_tc_l{
	width:171px;
	height:408px;
	border-right:1px solid #dcdcdc;
}

</style>
<script type="text/javascript">
var userId = "";
var sectionList;
$(function(){
	
	//如果文档已发布则 不能修改文档协同编制人员
	if("${documentStatus}" != "1" && "${documentStatus}" != "2"){
		$("#save").hide();
		$("#submit").hide();
	}
	
	sectionList = $("#sectionList").bootstrapTable({
	url : '${_baseUrl}/document/getFirstLevelSection',
	pagination: true,
	pageList: [100],
		queryParams: queryParams,
		clickToSelect: false,
		columns: [{
			       	 field: 'checked',
			         checkbox: true,
			         formatter:function(value, row, index) {
			       		 if(row.userId == userId){
			       			 return {
			                        checked: true
			                    }
			       		 }
			             return value;
			          }
			     	},{
				       field: 'id',
				       title: 'id',
				       visible:false,
				       width: 5
				   },{
				       field: 'userId',
				       title: 'userId',
				       visible:false,
				       width: 5
				   },{
				       field: 'sectionNumber',
				       title: '章节号',
				       width: 100
				   },{
				       field: 'sectionName',
				       title: '章节名称',
				       width: 100
				   },{
					   field: 'userName',
				       title: '编写人',
				       width: 100,
				   }]
			});

	function queryParams(params){
		return {
		    pageSize: 100,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order,
		    projectId:"${projectId}",
		    documentId:"${documentId}",
		    userId: $("#synergyPeople").val(),
		    teamPeople:"${teamPeople}",
		    documentManager:"${projectDocument.documentManager}"
	   }
	}
})
	function choicePeople(ovj,id){
		var arr = $("table a");
		for(var i=0;i<arr.length;i++){
			 $(arr[i]).attr("class","glianwd_tca1");
			 $(arr[i]).attr("style","color:#3E89ED");
		}
		
		$("#"+ovj).attr("style","color:black");
		$("#"+ovj).attr("class","glianwd_tca1 glianwd_active");
		userId = id;
		refresh(id);
	}
	function refresh(data){
		sectionList.bootstrapTable('refresh');
		userId = data;
	}
	function save(){
		if(userId == ""){
			layer.msg("您还没有选择编写人员");
			return;
		}
		var objects =  $("#sectionList").bootstrapTable('getSelections');
		if(objects.length==0){
			layer.msg("请至少选择一个章节");
			return;
		}
		var obj = JSON.stringify(objects);
		$.ajax({
			url:'${_baseUrl}/synergyWrite/saveSynergyWrite',
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"projectId":"${projectId}","documentId":"${documentId}","userId":userId,"obj":obj},
			async: false,
			success: function(data){
				refresh(data);
				var arr = $("table a");
				for(var i=0;i<arr.length;i++){
					 $(arr[i]).attr("class","glianwd_tca1");
				}
	        },
			error:function(){
				layer.msg( "系统错误");
			}
		});
		
	}
	function check(userIds){
		//parent.closeWin();
		$.ajax({
			url:'${_baseUrl}/document/checkFirstLevelSection?projectId=${projectId}&documentId=${documentId}',
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			async: false,
			data:{"userIds":userIds},
			success: function(data){
	        },
			error:function(){
				layer.msg( "系统错误");
			}
		}); 
	}
	function cancel(){
		parent.closeWin();
	}
	
	
	//协同编制弹出选择人员对话框
	function synergy(){
		var objects =  $("#sectionList").bootstrapTable('getSelections');
		if(objects.length==0){
			layer.msg("请至少选择一个章节");
			return;
		}
		//获取选中数据ID
		/* var obj = JSON.stringify(objects);
		var sectionIds = [];
		for(var i=0;i<objects.length;i++){
			sectionIds.push(objects[i].id);
		}
		alert(sectionIds.join(","));
		return; */
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'选择协同编制人员',
			autoOpen: true,
			modal: true,	
			height: 200,
			width: 400
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/synergyWrite/showSelectPeople?projectId=${projectId}&documentId=${documentId}");
	}
	
	/*保存协同编写人员 */
	function saveSynergyPeople(userIds){
		
		if(userIds == "" || userIds == null){
			layer.msg( "请选择人员");
			return;
		}
		
		//获取选中的列表
		var objects =  $("#sectionList").bootstrapTable('getSelections');
		var sectionIds = [];
		for(var i=0;i<objects.length;i++){
			sectionIds.push(objects[i].id);
		}
		
		$("#popDiv").dialog("close");
		$.ajax({
			url:'${_baseUrl}/synergyWrite/saveSynergyWrite',
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"projectId":"${projectId}","documentId":"${documentId}","userIds":userIds,"sectionIds":sectionIds.join(",")},
			async: false,
			success: function(data){
				refresh(data);
				check(userIds);
	        },
			error:function(){ 
				layer.msg( "系统错误");
			}
		});
		
	}
	/* 取消协同编写人员 */
     function cancelSynergyPeople(userIds){
		
		if(userIds == "" || userIds == null){
			layer.msg( "请选择人员");
			return;
		}
		
		//获取选中的列表
		var objects =  $("#sectionList").bootstrapTable('getSelections');
		var sectionIds = [];
		for(var i=0;i<objects.length;i++){
			sectionIds.push(objects[i].id);
		}
		
		$("#popDiv").dialog("close");
		$.ajax({
			url:'${_baseUrl}/synergyWrite/deleteSynergyWrite',
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"projectId":"${projectId}","documentId":"${documentId}","userIds":userIds,"sectionIds":sectionIds.join(",")},
			async: false,
			success: function(data){
				refresh(data);
				check(userIds);
	        },
			error:function(){
				layer.msg( "系统错误");
			}
		});
		
	}
	//选择人员时查询
	function change(){
		refresh("");
	}
</script>
</head>
<body>
   <div>
	<div class="glianwd_tc_top glianwd_tc_xt">
    	<div class="fl glianwd_tc_l" style="position: fixed; ">
            <table>
            	<tr><td align="center" class="glianwd_tca1 glianwd_tca1_t">文档协同编制<td><tr>
				<tr>
					<td align="center">
						<select id="synergyPeople" onchange="change()">
							<option value="">请选择</option>
							<c:forEach items="${userList}" var="user" varStatus="s">
								<option value="${user.id}">${user.userName}</option>
							</c:forEach>
						</select>
					<%-- <a href="javascript:;" id="${s.count}" onclick="choicePeople(${s.count},'${user.userId}');" class="glianwd_tca1">${user.userName}</a></td> --%>
				</tr>
				<tr>
					<td align="center">
					<div class="fl per_baocun_btn" style="margin-top: 20px;width: 100px;">
		        		<a href="javascript:;" class="fl per_baocun" style="width: 100px;" id="synergy" onclick="synergy();">协同任务分配</a>
		        	</div>
					<td>
				<tr>
            </table>
        </div>
        <div class="fl s_glianwd_tc_r" style="margin-left:230px;">    <!-- 右侧表格显示固定  -->
        	<div class="s_glianwd_c">
        		<!-- <div class="fl per_baocun_btn">
	        		<a href="javascript:;" class="fl per_baocun" id="save" onclick="save();">保存</a>
	        	</div>
        		<div class="fr permission_an mubanclass_an">
			    	<a href="javascript:;" class="per_baocun" id="submit" onclick="check();">提 交</a>
			        <a href="javascript:;" class="per_gbi" onclick="cancel();">取 消</a>
			    </div> -->
			    <div class="clear"></div>
        	</div>
        	
        	
            <div class="glianwd_tc_cont mt20">
            	<table id="sectionList" class="tab-w-01 tab-w-auto"></table> 
            </div>
        </div>
        <div class="clear"></div>
    </div>
    
 </div>
<div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no">
		</iframe>
	</div>
</body>
</html>
