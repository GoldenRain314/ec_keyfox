<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>菜单管理</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />

</head>

<script type="text/javascript">
	var menuList;
	$(function (){
		//初始化表格
		menuList = $("#menuList").bootstrapTable({
			url : '${_baseUrl}/menu/getMenuListData',
			pagination: true,
			pageList: [5, 10, 20, 50],
	  		queryParams: queryParams,
	        columns: [{
	        	 field: 'checked',
	             checkbox: true
	         }, {
	            field: 'menuId',
	            title: 'id',
	            visible:false,
	            width: 5
	        },{
	            field: 'menuName',
	            title: '菜单名称',
	            width: 100,
	            formatter: function(value, row, index){
	            	return "<a href='javascript:void(0)' onclick=\"showDetail('"+row.menuId+"')\">"+value+"</a>";
	            }
	        },{
	            field: 'menuUrl',
	            title: '菜单请求地址',
	            width: 100
	        },{
	            field: 'menuLevel',
	            title: '菜单等级',
	            width: 100
	        },{
	            field: 'parentName',
	            title: '父模块名称',
	            width: 100
	        }]
	    });
		
		function queryParams(params){
			return {
			    pageSize: params.limit,
			    pageNo: params.pn,
			    sort : params.sort,
			    order : params.order,
			    menuName:$("#menuName").val()
		   }
		}
		
		/* 添加菜单 */
		$("#addMenu").click(function (){
			$("#popIframe").empty();
			$("#popDiv").dialog({
				title:'添加菜单',
				autoOpen: true,
				modal: true,	
				height: 500,
				width: 800
			});
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/menu/showAddMenu");
		});
		
		/*删除菜单 */
		$("#delMenu").click(function (){
			var selected = menuList.bootstrapTable('getSelections');
			if(selected.length < 1){
				layer.msg("请选择要批量删除的数据");
				return false;
			}
			var menuIds = [];
			for(i in selected){
				menuIds.push(selected[i].menuId);
			}
			
			$.ajax({
				url : "${_baseUrl}/menu/delMenu",
				type : "post",
				dataType : "json",
				async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
		  		data : {menuIds : menuIds.join(',')},
				success : function(json) {
					layer.msg(json.message);
					refreshTable();
				},
				error:function(data){
					layer.msg("网络忙，请稍后重试");
				}
			});
		});
	})
	
	/* 关闭弹出框 */
	function closeWin(){
		$("#popDiv").dialog('close');
	}
	
	function refreshTable(){
		menuList.bootstrapTable('refresh');
	}
	
	/* 详情界面 */
	function showDetail(menuId){
		$("#popIframe").empty();
		$("#popDiv").dialog({
			title:'详细信息',
			autoOpen: true,
			modal: true,	
			height: 500,
			width: 800
		});
		$("#popIframe").attr("width","100%");
		$("#popIframe").attr("height","98%");
		$("#popIframe").attr("src","${_baseUrl}/menu/showAddMenu?menuId="+menuId);
	}

</script>
<body>
<div class="main_cont">
	<div class="main_c">
	   <div class="current_cont">
	       <div class="fl current_c">
	             当前位置 ： <a href="javascript:;">授权管理</a>  >  <a href="javascript:;">菜单管理</a>  >  所有菜单
	       </div>            
	       <div class="fr current_j">
	           <ul>
	               <li>
					        <a href="javascript:;" class="current_1" id="addMenu">添加菜单</a>
	               </li>
                   <li><a href="javascript:;" class="current_3" id="updateMenu">修改菜单</a></li>
                   <li>
					        <a href="javascript:;" class="current_2" id="delMenu">删除菜单</a>
                   </li>
	               <div class="clear"></div>
	           </ul>
	       </div>
	       <div class="fr current_s">
	           <div class="fl current_s_i"><input name="" type="text" class="input_text1" id="menuName" value="搜索您想寻找的..." onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
	              <div class="fl current_s_a"><input name="" type="button" value="高级搜索" class="input_btn1" onclick="refreshTable()"></div>
	              <div class="clear"></div>
	          </div>
	          <div class="clear"></div>
	      </div>
	      
	      <div class="personnel_cont">
	          <table id="menuList" class="tab-w-01 tab-w-auto" width="100%" border="0" cellspacing="0" cellpadding="0">
	          </table>
	      </div>
	 </div>
</div>
     
<div id="popDiv" style="display: none;">
	<iframe id="popIframe" style="width:100%; height:100%;" frameborder="0" border="0"></iframe>
</div>
     
</body>
</html>