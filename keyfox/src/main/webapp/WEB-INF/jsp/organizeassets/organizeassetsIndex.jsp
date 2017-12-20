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
<script type="text/javascript" src="${_resources}JSON-js-master/json2.js"></script>

<script type="text/javascript" src="${_resources}bootstrap/bootstrap-table1.js"></script>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table1.min.css" />

<script type="text/javascript">
    var searchValue = null;
	$(function(){
		getOrUpdateTable();
		
		$("#searchValue").keydown(function(event) {//给输入框绑定按键事件
		    if(event.keyCode == "13") {//判断如果按下的是回车键则执行下面的代码
		    	getOrUpdateTable();
		  	}
		})
	});
	function gotoNodeUrl(url){
		window.location.href="${_baseUrl}"+url+"?searchValue="+searchValue;
		//alert("请告诉我URL！"+url)
	}
	
	function getOrUpdateTable(){
		searchValue = $("#searchValue").val();
		if("请输入搜索内容..." == $("#searchValue").val()){
			searchValue = '';
		}
		
		$.ajax({ 
			url:'${_baseUrl}/organizeassets/getOrganizeassetsIndexData', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"searchValue":searchValue},
			async: false,
			success: function(data){
				var orgIndex = eval(data);
				$("#threeLevelList").empty();
				$("#threeLevelList").append("<tr><th>序号</th><th>组织资产类别</th><th>菜单名称</th><th>搜索结果</th></tr>");
				for(var i = 0; i<orgIndex.length;i++){					
					$("#threeLevelList").append("<tr><td>"+(i+1)+"</td><td>"+orgIndex[i].organizeassetsType+"</td><td>"+orgIndex[i].nodeName+"</td><td><a href='javascript:void(0)' onclick=\"gotoNodeUrl('"+orgIndex[i].nodeUrl+"')\">"+orgIndex[i].nodeSingleData+"</a>&nbsp&nbsp<a href='javascript:void(0)' onclick=\"gotoNodeUrl('"+orgIndex[i].nodeUrl+"')\">查看</a></td></tr>");																
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
<div class="main_cont">
        	<div class="main_c">
                <div class="current_cont">
                    <div class="fl current_c">
                         当前位置 ： <a href="javascript:;">组织资产</a>
                    </div>                
                    <div class="fr current_j">
                       
                    </div>
                    <div class="fr current_s">
                    	<div class="fl current_s_i"><input id="searchValue" name="" type="text" class="input_text1" value="请输入搜索内容..." onFocus="if(this.value=='请输入搜索内容...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入搜索内容...';}"></div>
                        <div class="fl current_s_a"><input name="" type="button" value="搜索" class="input_btn1" onclick="getOrUpdateTable()"></div>   <!-- 修改信息与内容一致  -->
                        <div class="clear"></div>
                    </div>   
                </div>
                      
                <div class="dyi_cont">
                    <div class="dyi_list">
                    
                   	  <table width="100%" border="0" cellspacing="0" cellpadding="0" id="threeLevelList">
                      </table>
                    </div>
               </div>
     	 </div>
      </div>
      <div center="bottom">
	       “组织资产”菜单包含“软件管理类”、“软件测试类”、“软件设计类”三个子菜单，各个子菜单下有对应的组织资产项。平台支持组织资产项内容的自定义，且“组织资产”菜单下的组织资产项内容可在文档在线编写时进行查阅和引用。
	      	  <table width="100%" border="2" cellspacing="0" cellpadding="0" >
		      	  <tr><th>序号</th><th>子菜单名称</th><th>组织资产项</th></tr>
		      	  <tr><td>1</td><td>软件管理类</td><td>涉密等级、标准库（军标及引用文档）、技术文档目录、评审级别、软件开发活动、文档变更级别、软件质量管理、软件配置管理-配置项、软件配置管理-基线、软件配置管理-配置审核、文档类别、文档范本的适用范围、项目文档编制标准、活动类型、活动名称、文档模板适用范围</td></tr>
		      	  <tr><td>2</td><td>软件测试类</td><td>测试级别、测试类型、测试终止条件、测试用例设计方法、测试用例通过准则、软件缺陷类别、软件缺陷等级</td></tr>
		      	  <tr><td>3</td><td>软件设计类</td><td>软件研制阶段、软件关键等级、软件规模、软件开发模型、硬件和固件项、软件项、优先级</td></tr>
	         </table> 
      </div>
</body>
</html>
