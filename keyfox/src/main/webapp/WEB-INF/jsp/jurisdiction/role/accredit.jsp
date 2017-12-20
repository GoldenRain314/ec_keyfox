<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>授权管理</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}js/jurisdiction/role/initPermission.js"></script>

<script type="text/javascript">
$(function (){
	
	//先展示所有菜单和权限
	var permissionString = '${permissionString}';
	var userId = '${userId}';
	initAllPermission(permissionString,userId);
	//默认勾选上已经有的权限
	checkedPermission("${_baseUrl}/role/getMenuAndPermission","${roleId}");
	
	/* 行 居中显示 */
	(function(){
		$('.permission .qxian_c li').each(function(index, element) {
            var _this=$(this);
			var qxianliH=_this.height();
			_this.find('.qxian_l').css({
				'line-height':qxianliH+'px',
				'height':qxianliH+'px',
				'text-overflow':'ellipsis',
				'white-space':'nowrap',
				'overflow':'hidden',
			});
        });
	})();
	
	/* 关闭 */
	$("#close").click(function (){
		parent.closeWin();
	});
	
	$("#save").click(function (){
		var permissions = [];
		$("#menuUl :checkbox").each(function (i){
			//值需要选中
			if(this.checked){
				permissions.push("{\"id\":\""+this.id+"\",\"value\":\""+this.value+"\"}");
			}
		});
		
		$.ajax({
			url : "${_baseUrl}/role/updateMenuAndPermission",
			type : "post",
			dataType : "text",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		data : {permissions : permissions.join(","),roleId:"${roleId}"},
			success : function(json) {
				layer.msg(json);
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
	});
});

</script>

<style>
	.qxian_l .qxian_xj { overflow:hidden; text-overflow:ellipsis; white-space:nowrap; width:150px;}
</style>

</head>
<body>
<div class="permission" style="width:894px; padding-bottom:10px;">
    <div class="permission_c">
    	<div class="qxian_tit">
        	<span style="width:240px;">菜 单</span>
            <span class="qxian_spanend">权 限</span>
        </div>
        <div class="qxian_c">
        	<ul id="menuUl">
            	<li>
                	<div class="fl qxian_l qxian_l3" style="width:215px;">
                    	<div class="qxian_xj" style="width: 241px;">
                        	<input name="need_inv" type="checkbox" class="radioclass input" value="1"> 项目管理
                        </div>	
                    </div>
                    <div class="clear"></div>
                </li>
                <li>
                	<div class="fl qxian_l qxian_l2">
                    	<div class="qxian_xj">                            
                        	<input name="need_inv" type="checkbox" value="1"> 项目列表                        
                        </div>	
                    </div>
                    <div class="fl qxian_r" style="width:579px;">
                    	<div class="qxian_xj">                            
                        	<input name="need_inv" type="checkbox" value="1"> 查询                        
                        </div>
                    </div>
                    <div class="clear"></div>
                </li>
                <li>
                	<div class="fl qxian_l qxian_l2">
                    	<div class="qxian_xj">                            
                        	<input name="need_inv" type="checkbox" value="1"> 参考指南                        
                        </div>		
                    </div>
                    <div class="fl qxian_r qxian_a1_r"></div>
                    <div class="clear"></div>
                </li>
            </ul>
        </div>
    </div>
    <div class="permission_an mubanclass_an ma mt30">
    	<shiro:hasPermission name="role:updateMenuAndPermission">
	        <a href="javascript:;" class="per_baocun" id="save">保 存</a>
	    </shiro:hasPermission>
        <a href="javascript:;" class="per_gbi" id="close">关 闭</a>
    </div>
</div>

</body>
</html>