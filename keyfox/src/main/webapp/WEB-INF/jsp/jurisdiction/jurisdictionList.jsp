<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>授权管理</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>

<script type="text/javascript">
$(function (){
	/* 角色管理 */
	$("#roleManage").click(function (){
		var div = document.getElementById("rightIframe");
		div.src ="${_baseUrl}/role/roleList";
	});
	
	$("#menuManage").click(function (){
		var div = document.getElementById("rightIframe");
		div.src ="${_baseUrl}/menu/getMenuList";
	});
	
})
	
	
</script>
</head>
<body>
	<div class="ma main">
	<!-------左侧菜单------>
        <div class="fl menu">
            <div class="menu_tit">授权管理</div>
            <div class="list">
                <ul>
                    <li><a href="javascript:;" class="inactive">菜单管理</a>
                        <ul style="display: none">
                            <li><a href="javascript:;" class="inactive">仪器</a>
                                <ul>
                                    <li><a href="javascript:;" class="inactive active">关键科技</a>
                                        <ul>
                                            <li><a href="javascript:;" id="roleManage">角色管理</a></li>
                                            <li><a href="javascript:;" id="menuManage">菜单管理</a></li>
                                            <li><a href="javascript:;">技术支持部</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="javascript:;">关键科技</a></li>
                                    <li><a href="javascript:;">关键科技</a></li>
                                </ul>
                            </li> 
                            <li><a href="javascript:;" class="inactive active">耗材</a>
                                <ul>
                                    <li><a href="javascript:;">组织解离试剂盒</a></li>
                                </ul>
                            </li> 
                            <li><a href="javascript:;" class="inactive active">试剂</a>
                                <ul>
                                    <li><a href="javascript:;">gentleMACS所用相关耗材</a></li>
                                </ul>
                            </li> 
                            
                        </ul>
                    </li>
                    <li><a href="javascript:;" class="inactive">所有人员</a>
                        <ul style="display: none">
                            <li><a href="javascript:;" class="inactive active">222222</a>
                                <ul>
                                    <li><a href="javascript:;">33333</a></li>
                                    <li><a href="javascript:;">33333</a></li>
                                    <li><a href="javascript:;">33333</a></li>
                                    <li><a href="javascript:;">33333</a></li>
                                    <li><a href="javascript:;">33333</a></li>
                                    <li><a href="javascript:;">33333</a></li>
                                </ul>
                            </li> 
                            <li><a href="javascript:;">22222</a></li> 
                        </ul>
                    </li>
                    <li><a href="javascript:;" class="inactive">所有人员</a>
                        <ul style="display: none">
                            <li><a href="javascript:;" class="inactive active">美协机关</a>
                                <ul>
                                    <li><a href="javascript:;">办公室</a></li>
                                    <li><a href="javascript:;">人事处</a></li>
                                    <li><a href="javascript:;">组联部</a></li>
                                    <li><a href="javascript:;">外联部</a></li>
                                    <li><a href="javascript:;">研究部</a></li>
                                    <li><a href="javascript:;">维权办</a></li>
                                </ul>
                            </li> 
                            <li><a href="javascript:;" class="inactive active">中国文联美术艺术中心</a>   
                                <ul>
                                    <li><a href="javascript:;">综合部</a></li>
                                    <li><a href="javascript:;">大型活动部</a></li>
                                    <li><a href="javascript:;">展览部</a></li>
                                    <li><a href="javascript:;">艺委会工作部</a></li>
                                    <li><a href="javascript:;">信息资源部</a></li>
                                    <li><a href="javascript:;">双年展办公室</a></li>
                                </ul>
                            </li> 
                            <li><a href="#">《美术》杂志社</a></li> 
                        </ul>
                    </li>
                </ul>
            </div>
        
        </div>
        <!-------中间内容------>
        <div class="iframe_ydhgl">
        	<iframe id="rightIframe" frameborder="0" style="width:100%; height:100%;" src="${_baseUrl}/userController/showUserList"></iframe>
        </div>
                  
    	<div class="clear"></div>
    </div>
</body>
</html>