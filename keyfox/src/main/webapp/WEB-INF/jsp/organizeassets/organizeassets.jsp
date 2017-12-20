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
	var menuId = "${menuId}";
	var threeLevelList;
	$(function(){
		$.ajax({ 
			url:'${_baseUrl}/menu/selectMeunNameByMenuId', 
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			data:{"menuId":menuId},
			async: false,
			success: function(data){
			   $("#menuName").html(data);
            },
			error:function(){
				layer.msg( "系统错误");
			}
	   });
		//初始化表格
		threeLevelList = $("#threeLevelList").bootstrapTable({
			url : '${_baseUrl}/jurisdiction/getThreeLevel?menuId='+menuId,
			pagination: true,
			pageList: [5, 10, 20, 50],
	  		queryParams: queryParams,
	        columns: [{
	        	 field : 'name',
	         	 title : '节点名称',
	             width: 100
	         },{
	            field: 'describse',
	            title: '描述',
	            width: 300,
	            formatter: function(value, row, index){
	            	if(row.name=="涉密等级"){
						return  "涉密等级的分类，以及对应的涉密类别、保密期限的说明";
					}else if(row.name=="技术文档目录"){
						return "技术文档列表，包括文档名称、文档标识、使用范围和用途说明等信息";
					}else if(row.name=="标准库（军标及引用文档）"){
						return "各类标准或引用文档的文档名称、标识、来源、发布日期等信息";
					}else if(row.name=="评审级别"){
						return "评审类型及其说明信息";
					}else if(row.name=="软件开发活动"){
						return "软件开发活动的阶段、内容以及生成的工作产品";
					}else if(row.name=="文档变更级别"){
						return "文档更改级别及更改范围的说明";
					}else if(row.name=="软件质量管理"){
						return "软件质量管理过程的检查对象、方法和依据等";
					}else if(row.name=="软件配置管理-配置项"){
						return "配置管理的配置项详细列表以及各自所属的基线名称";
					}else if(row.name=="软件配置管理-基线"){
						return "配置管理的基线分类、基线标识以及基线所包含的配置项";
					}else if(row.name=="软件配置管理-配置审核"){
						return "配置审核的分类及其审核内容描述";
					}else if(row.name=="文档类别"){
						return "根据文档用户和内容对文档进行分类";
					}else if(row.name=="文档范本的适用范围"){
						return "文档范本库的文档模板适用的领域和范围，即适用的文档编制要求的颁布机构";
					}else if(row.name=="测试级别"){
						return "测试等级划分和划分依据的说明";
					}else if(row.name=="测试类型"){
						return "测试过程中的测试类型及对应测试内容的说明";
					}else if(row.name=="测试终止条件"){
						return "说明测试正常终止和异常终止的条件";
					}else if(row.name=="测试用例设计方法"){
						return "测试用设计方法分类和详细描述";
					}else if(row.name=="测试用例通过准则"){
						return "说明测试用例执行通过的衡量标准和准则";
					}else if(row.name=="软件缺陷类别"){
						return "软件缺陷的分类和对应描述";
					}else if(row.name=="软件缺陷等级"){
						return "软件缺陷严重程度的等级分类及说明";
					}else if(row.name=="软件研制阶段"){
						return "研制阶段名称、标识及活动描述说明";
					}else if(row.name=="软件关键等级"){
						return "软件关键等级分类及对应的划分标准";
					}else if(row.name=="软件规模"){
						return "软件规模的度量分类和标准";
					}else if(row.name=="硬件和固件项"){
						return "常用硬件和固件项名称、设备编号、用途、保密处理、安全性问题等信息";
					}else if(row.name=="软件项"){
						return "常用软件项名称、版本、用途、保密处理、安全性问题等信息";
					}else if(row.name=="软件开发模型"){
						return "软件开发全部过程、活动和任务的结构框架";
					}else if(row.name=="优先级"){
						return "根据轻重缓急划分执行顺序和重要程度";
					}else if(row.name=="项目文档编制标准"){
						return "项目文档编制遵循的各类标准或规定";
					}else if(row.name=="文档模板适用范围"){
						return "自定义或标准文档模板适用的领域和范围";
					}else if(row.name=="活动类型"){
						return "项目管理的各类活动的概况分类";
					}else if(row.name=="活动名称"){
						return "项目实施过程中的各类活动";
					}
	            }
	        }]
	    });
		
		function queryParams(params){
			return {
			    pageSize: params.limit,
			    pageNo: params.pn,
			    sort : params.sort,
			    order : params.order
		   }
		}
	});
</script>
</head>
<body>
<div class="main_cont">
        	<div class="main_c">
                <div class="current_cont">
                    <div class="fl current_c">
                         当前位置 ： <a href="javascript:;">组织资产</a> >  <a href="javascript:;"><span id="menuName"></span></a>
                    </div>                
                    <div class="fr current_j">
                       
                    </div>
                    <div class="fr current_s">
                    	
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
</body>
</html>
