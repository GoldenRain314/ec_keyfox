<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>文档协同编制-选择人员</title>
<meta name="viewport"
	content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0 minimal-ui" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<%@ include file="/WEB-INF/jsp/common/inc.jsp"%>

<script type="text/javascript">
	function save() {
		var userIds = "";
		$("input[name='people']:checked").each(function(i) {
			userIds += $(this).val() + ",";
		});
		parent.saveSynergyPeople(userIds);
	}

	function cancelAndClose() {
		var userIds = "";
		$("input[name='people']:checked").each(function(i) {
			userIds += $(this).val() + ",";
		});
		parent.cancelSynergyPeople(userIds);
	}
</script>
</head>
<body>
	<div>
		<div class="glianwd_tc_top glianwd_tc_xt">
			<table>
				<tr>
					<td align="center"><c:forEach items="${userList}" var="user"
							varStatus="s">
							<input type="checkbox" name="people" value="${user.id}" />&nbsp;&nbsp;${user.userName}&nbsp;&nbsp;
				</c:forEach></td>
				</tr>
			</table>
			<div class="fl per_baocun_btn"
				style="margin-top: 20px; margin-right: 10px;">
				<a href="javascript:;" class="fl per_baocun" id="save"
					onclick="save();">保存</a>
			</div>
			<div class="fl per_baocun_btn"
				style="margin-top: 20px; margin-right: 10px;">
				<a href="javascript:;" class="fl per_baocun_btn" id="cancelAndClose"
					onclick="cancelAndClose();">取 消</a>
			</div>
		</div>

	</div>
</body>
</html>
