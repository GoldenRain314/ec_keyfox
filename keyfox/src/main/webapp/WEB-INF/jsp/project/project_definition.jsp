<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title></title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script  type="text/javascript">

	var menuList;
	var ids;
	var nodeId = "${nodeId}";
	var directoryLevel = "${directoryLevel}";
	var projectManager;
	var menuNodeList;
	$(function (){
		
		var str = "${str}";
		if(str != ""){
			if(str.length > 50){
				str = str.substring(0,50);
				str += "...";
			}
		}
		$("#str").html(str);
		
		if(directoryLevel=='0'){
			$("#setDocument").attr({"disabled":"disabled"});
		}
		//初始化表格
		menuList = $("#menuList").bootstrapTable({
			url : '${_baseUrl}/project/selectSonByNodeId?nodeId='+nodeId,
			pagination: true,
			data:{"nodeId":nodeId},
			pageList: [5, 10, 20, 50],
			queryParams: queryParams,
	        columns: [{
	        	 field: 'checked',
	             checkbox: true
	         },{
	        	 field : 'name',
	         	 title : '${directoryName}',
	             width: 100,
	             formatter: function(value, row, index){
	             	 return "<a href='javascript:void(0)' onclick=\"updateMessage('"+row.nodeId+"')\">"+value+"</a>";
	             }
	         }, {
	            field: 'id',
	            title: 'id',
	            visible:false,
	            width: 5
	        },{
	            field: 'nodeCode',
	            title: '${directoryCode}',
	            width: 100
	        },{
	            field: 'parentNodeName',
	            title: '路径',
	            width: 100,
	           visible:false
	           
	        }]
	    });
		
		menuNodeList = $("#menuNodeList").bootstrapTable({
			url : '${_baseUrl}/project/searchNodeByName',
			pagination: true,
			data:{"nodeId":nodeId},
			pageList: [5, 10, 20, 50],
			queryParams: queryParams,
	        columns: [{
	        	 field: 'checked',
	             checkbox: true
	         },{
	        	 field : 'name',
	         	 title : '${directoryName}',
	             width: 100,
	             formatter: function(value, row, index){
	             	 return "<a href='javascript:void(0)' onclick=\"updateMessage('"+row.nodeId+"')\">"+value+"</a>";
	             }
	         }, {
	            field: 'id',
	            title: 'id',
	            visible:false,
	            width: 5
	        },{
	            field: 'nodeCode',
	            title: '${directoryCode}',
	            width: 100
	        },{
	            field: 'parentNodeName',
	            title: '路径',
	            width: 100
	           
	        }]
	    });
		
		function queryParams(params){
			return {
			    pageSize: params.limit,
			    pageNo: params.pn,
			    sort : params.sort,
			    order : params.order,
			    name:$("#proName").val()
		   }
		}
	})
	
	
	
	function deletemessage(){
		var selected =  $("#menuList").bootstrapTable('getSelections');
		if(selected == ""){
			layer.msg("没有选择可以删除的节点");
			return;
		}
		var ids = [];
		var isDel = false;
		if(selected.length > 0){
			for(i in selected){
				ids.push(selected[i].nodeId);
			}
		}
	    var options = "该节点下可能已设置文档或有子节点，请慎重删除?";
		layer.confirm(options,{
    		btn:['确定','取消']},
    		function (){
    			layer.load(2);
    			$.ajax({ 
    				url:'${_baseUrl}/project/deleteMessage', 
    				type:'post', //数据发送方式 
    				dataType:'text', //接受数据格式 
    				data:{"obj":ids.join(','),"nodeId":nodeId},
    				async: true,
    				success: function(data){
    					if(data == "success"){
    						parent.location.href="${_baseUrl}/project/showtree?nodeId="+nodeId;
    					}else{
    						layer.msg(data);
    					}
    	            },
    				error:function(){
    					layer.msg( "系统错误");
    				}
    		   });
    		},
    		function(){
    			return;
    		}
    	);

	}
	//添加子目录
	function addmessage(){
		var isAdd = false;
		$.ajax({ 
			url:'${_baseUrl}/project/isOrSetDocument', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"nodeId":nodeId},
			async: false,
			success: function(data){
				if(data == "false"){
					layer.msg("该节点已经设置了文档，不能添加子节点");
					return;
				}else{
					isAdd = true;
				}
            },
			error:function(){
				layer.msg( "系统错误");
			}
	    });
		if(isAdd == false){
			return;
		}
		if(directoryLevel >=5){
			layer.msg( "只能有5级菜单");
			return;
		}
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'项目定义',
			autoOpen: true,
			modal: true,	
			height: 400,
			width: 750
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/project/addpage?directoryLevel="+directoryLevel+"&nodeId="+nodeId);
		
	}
	
	
	function updateMessage(nodeId){
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'修改项目信息',
			autoOpen: true,
			modal: true,	
			height: 400,
			width: 750
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/project/showUpdateMessagePage?nodeId="+nodeId);
	}
	
	
	/* 关闭弹出框 */
	function closeWin(){
		$("#popDiv").dialog('close');
	}
	function refreshTable(){
		menuList.bootstrapTable('refresh');
	}
	//设置文档
	function setDocument(){
		var isSet = false;
		$.ajax({ 
			url:'${_baseUrl}/project/isOrHasSonNodeId', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"obj":nodeId},
			async: false,
			success: function(data){
			   if(data=='true'){
				   layer.msg("该节点下有子节点，无法设置文档");
			   }else if(data == 'false'){
				   isSet = true;
			   }else{
				   projectManager = data;
				   isSet = true;
			   }
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
	   if(isSet == false){
		   return;
	   }
		$("#popIframe").empty();	
		$("#popDiv").dialog({
			title:'设置文档',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 800
		});	
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","95%");
		$("#popIframe").attr("src","${_baseUrl}/project/addSetDocument?nodeId="+nodeId+"&projectManager="+projectManager);

	}
	function closeWin(){
		$("#popDiv").dialog('close');
	}
	
	function selectMessage(){
		var  name = $("#proName").val();
		if(name=="请输入项目名称或目录名称 ..."){
			$("#1").css("display","block");
			$("#2").css("display","none");
			menuList.bootstrapTable('refresh',{url:'${_baseUrl}/project/selectSonByNodeId?nodeId='+nodeId});
		}else{
			$("#2").css("display","block");
			$("#1").css("display","none");
			menuNodeList.bootstrapTable('refresh',{url:'${_baseUrl}/project/searchNodeByName'});
		}
		
	}
	

	document.onkeydown=function(event) 
	{ 
		e = event ? event :(window.event ? window.event : null); 
		if(e.keyCode==13){ 
			selectMessage(); 
		} 
	} 
</script>
</head>
<body>
<div class="main_cont">
        	<div class="main_c">
                <div class="current_cont">
                    <div class="fl current_c">
                         当前位置 ： <a href="javascript:;">项目管理</a>  <span id="str" title="项目管理${str }"></span>
                    </div>            
                    <div class="fr current_j">
                       
                    </div>
                    <div class="fr current_s">
                        <!-- <div class="fl current_s_i"><input name="" type="text" class="input_text1" value="搜索您想寻找的..." onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
                        <div class="fl current_s_a"><input name="" type="button" value="高级搜索" class="input_btn1"></div> -->
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                            
                </div>
                
                <div class="dyi_cont">
                	 <c:if test="${directoryLevel == '0'}">
                	 	<div class="fl wdang_dy_l" style="margin-top: 25px;margin-left: 10px;">
		                   <dl>
		                     <dt><input name="proName" id="proName" type="text" class="input_text2" style="width: 207px;" value="请输入项目名称或目录名称 ..." onFocus="if(this.value=='请输入项目名称或目录名称 ...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入项目名称或目录名称 ...';}"></dt>
		                      <dd><input name="" value="搜索" type="button" onclick="selectMessage();" style="margin-left:30px;" class="dyi_btna dyi_btnabox dyi_btna1"></dd>
		                  </dl>
		              </div>
                	 </c:if>
                	<div class="dyi_an">
                		<shiro:hasPermission name="project:addpage">
                           	<a href="javascript:;" onClick="addmessage();">新增子菜单</a>
				        </shiro:hasPermission>
                    	
                    	<c:choose>  
						   <c:when test="${directoryLevel == '0'}">
						   		
						   </c:when>  
						   <c:otherwise>
						   		<shiro:hasPermission name="project:addSetDocument">
		                           	<a href="javascript:;" id="setDocument" onClick="setDocument();">设置文档</a>
						        </shiro:hasPermission>
						   </c:otherwise>  
						</c:choose>  
						<shiro:hasPermission name="project:deleteMessage">
		                    <a href="javascript:;" onClick="deletemessage();">删除目录</a>
				        </shiro:hasPermission>
                    </div>
                    <div class="dyi_list" id="1" >
                   	  <table width="100%" border="0" cellspacing="0" cellpadding="0" id="menuList">
                    </table>
                   </div>
                    <div class="dyi_list" id="2" style="display: none;">
                   	  <table width="100%" border="0" cellspacing="0" cellpadding="0" id="menuNodeList">
                    </table>
                  </div>
              </div>
     	 </div>
      </div>
      <div id="popDiv" style="display: none;">
		<iframe id="popIframe" border="0" frameborder="no"></iframe>
	</div>
</body>
</html>
