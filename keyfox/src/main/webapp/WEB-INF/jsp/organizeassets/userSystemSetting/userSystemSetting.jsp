<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>评审类型</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
$(function (){
	$("input[type=radio][name='changeCommon'][value=${changeCommon}]").attr("checked",'checked')
	$("input[type=radio][name='change438B'][value=${change438B}]").attr("checked",'checked')
});

function save(){
	var changeCommon = $('input[name="changeCommon"]:checked').val();
	var change438B = $('input[name="change438B"]:checked').val();
	 $.ajax({ 
			url:'${_baseUrl}/userSystemSettings/saveSystemSetting', 
			data:{"changeCommon":changeCommon,
				  "change438B":change438B
			      },
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			async: false,
			success: function(data){
			 	if(data == "success"){
			 		layer.msg("保存成功");
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
                   <div class="current_c">
                        当前位置 ： <a href="javascript:;">组织资产</a>  >  <a href="javascript:;">用户系统设置</a>
                   </div>                
               </div>
               
               <div class="bgcli_c">
		      		 <span>变更处理流程控制（通用文档）</span>
					 <p><input type="radio" name="changeCommon" value="0" checked>简易流程</p>
					 <p><input type="radio" name="changeCommon" value="1">自顶向下流程</p><br>
					 <span>变更处理流程控制（GJB438B项目文档）</span>
					 <p><input type="radio" name="change438B" value="0" checked>简易流程</p>
					 <p><input type="radio" name="change438B" value="1">自顶向下流 </p>
               </div>
               <div class="permission_an xmugonj_bc ma">
				      <a href="javascript:;" class="per_baocun" onclick="save();">保 存</a>
	           </div>
    	 </div>
     </div>
</body>
</html>