<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加日志信息</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}/JSON-js-master/json2.js" charset="utf-8"></script>
<script type="text/javascript">
$(function (){
	$("#submit").click(function (){
		var options = {
				dataType:"json",
				success:function(json){
					if(json.code == '1'){
						layer.msg(json.message,{shift:5},function(){
							parent.refreshTable();
							parent.closeWin();
						});
					}
					if(json.code == '0'){
						layer.msg(json.message);
					}
				},
				error:function(json){
					layer.msg("发生错误");
				}
			};
		$("#auditLog").ajaxSubmit(options);
	

	});
	$("#close").click(function (){
		parent.refreshTable();
		parent.closeWin();
	});
});
</script>
</head>
<body>
	<form name="auditLog" id="auditLog" action="${_baseUrl}/auditLogController/add" method="post">  
		<!-- <div class="permission_tit">
    <ul>
        <li><a href="javascript:;" class="qxsz_on">日志详情</a></li>
        <div class="clear"></div>
    </ul>
</div> -->
    	<div class="jbinformation">
    <table width="867" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="150" height="50" align="center" valign="middle" bgcolor="#f7f4f4"> 日志名称</td>
        <td width="187" valign="middle"><div class="jbxinxi_s"><input type="text" name="logName" id="logName"  class="jbxinxi_input"/></div></td>
        <td width="150" align="center" bgcolor="#f7f4f4">日志名称类型</td>
        <td width="185"><div class="jbxinxi_s"><input type="text" name="logNameType" id="logNameType" class="jbxinxi_input"></div></td>
      </tr>
      <tr>
      <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">用户账号</td>
        <td><div class="jbxinxi_s"><input type="text" name="userId" id="userId" class="jbxinxi_input"></div></td>
        <td align="center" bgcolor="#f7f4f4">用户名</td>
        <td valign="top"><div class="jbxinxi_s"><input type="text" name="userName" id="userName" class="jbxinxi_input"></div></td>
      </tr>
      <tr>
      	<td height="50" align="center" valign="middle" bgcolor="#f7f4f4">部门</td>
        <td valign="top"><div class="qr_input"><input type="text" name="deptName" id="deptName" class="jbxinxi_input"></div></td>
        <td align="center" bgcolor="#f7f4f4">IP</td>
        <td valign="top"><div class="jbxinxi_s"><input type="text" name="ipAddress" id="ipAddress" class="jbxinxi_input"/><br/></div></td>
      </tr>
      <tr>
       <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">操作时间</td>
        <td valign="top"><div class="qr_input"><input type="text" name="operTime" id="operTime" class="jbxinxi_input"></div></td>
      </tr>
      <tr>
         <td height="50" align="center" valign="middle" bgcolor="#f7f4f4">详情</td>
        <td colspan="4"><div class="bjxinxi_beizhu"><textarea name="comments" id="comments" cols="" rows="" class="beizhu_text"></textarea></div></td>
      </tr>
    </table>
</div>
<div class="permission_an mubanclass_an ma mt30">
    <a href="javascript:;" class="per_baocun" id="submit">保存</a>
    <a href="javascript:;" class="per_gbi" id="close">关闭</a>

</div>
	</form> 
</body>
</html>