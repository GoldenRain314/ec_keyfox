<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>项目信息</title>
		<script type="text/javascript" src="${_resources}jq/jquery-1.8.3.min.js"></script>
		<script type="text/javascript" src="${_resources}datepicker/WdatePicker.js"></script>
		<script type="text/javascript">
			function check(){
				$("#project").submit();
			}
		</script>
	</head>
	<body>
		<form name ="project" id="project" action="${_baseUrl}/project/saveProjectBaseinfo" method="post">
			<div align="center" id="d1">
				研制单位：<input type="text" name="enterprise" id="enterprise"><br><br>
				软件开发模型：<input type="text" name="softwaremodel" id="softwaremodel"><br><br>
				文档类别：<input type="text" name="documenttype" id="documenttype"><br><br>
				项目密级：<select id="projectclassification" name="projectclassification">
							<option value="机密">机密</option>
							<option value="绝密">绝密</option>
						</select><br><br>
				开始时间： <input id="projectstarttime" name="projectstarttime" type="text" onClick="WdatePicker()"/><br><br> 
				软件关键等级：<input type="text" name="softwarecriticallevels" id="softwarecriticallevels"><br><br>
				软件规模：<input type="text" name="softwarescale" id="softwarescale"><br><br>
				用户：<input type="text" name="theuser" id="theuser"><br><br>
				完成时间：<input id="projectendtime" name="projectendtime" type="text" onClick="WdatePicker()"/><br><br>
				需方：<input type="text" name="thebuyer" id="thebuyer"><br><br>
				保障机构：<input type="text" name="guaranteesetup" id="guaranteesetup"><br><br>
				开发方：<input type="text" name="developingparty" id="developingparty"><br><br>
				测试方：<input type="text" name="testparty" id="testparty"><br><br>
				项目信息复用：复用<input name="isorreuse" type="radio" checked="checked" value="复用" />
							不复用<input name="isorreuse" type="radio" value="不复用" /><br><br>
				项目文档标准：<input type="text" name="documentstandard" id="documentstandard"><br><br>
				项目文档模板：<input type="text" name="documenttemplate" id="documenttemplate"><br><br>
				<input type="button" value="保存" onclick="check();">
			</div>
		</form>
	</body>
</html>
