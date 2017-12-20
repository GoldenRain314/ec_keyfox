<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登陆</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript">

</script>
</head>
<body>
	<div class="main_cont">
        	<div class="main_c">
                <div class="current_cont">
                    <div class="fl current_c">
                         当前位置 ： <a href="javascript:;">组织机构</a>  >  <a href="javascript:;">用户管理</a>  >  所有人员
                    </div>            
                    <div class="fr current_j">
                        <ul>
                            <li><a href="javascript:;" class="current_1">添加人员</a></li>
                            <li><a href="javascript:;" class="current_2">注销人员</a></li>
                            <li><a href="javascript:;" class="current_3">密码重置</a></li>
                            <li><a href="javascript:;" class="current_4">解锁</a></li>
                            <div class="clear"></div>
                        </ul>
                    </div>
                    <div class="fr current_s">
                        <div class="fl current_s_i"><input name="" type="text" class="input_text1" value="搜索您想寻找的..." onFocus="if(this.value=='搜索您想寻找的...'){this.value=''}" onBlur="if(this.value==''){this.value='搜索您想寻找的...';}"></div>
                        <div class="fl current_s_a"><input name="" type="button" value="高级搜索" class="input_btn1"></div>
                        <div class="clear"></div>
                    </div>
                    <div class="clear"></div>
                            
                </div>
                
                <div class="personnel_cont">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <thead>
                      <tr>
                        <td width="8%" align="center">姓名</td>
                        <td width="11%" align="center">用户账号</td>
                        <td width="11%" align="center">部门</td>
                        <td width="13%" align="center">职务</td>
                        <td width="17%" align="center">电子邮箱</td>
                        <td width="12%" align="center">办公电话</td>
                        <td width="17%" align="center">状态</td>
                        <td width="11%" align="center">上移</td>
                      </tr>
                      </thead>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#ffffff">沈鹏飞</td>
                        <td align="center" bgcolor="#ffffff">shenpengfei</td>
                        <td align="center" bgcolor="#ffffff">研发部</td>
                        <td align="center" bgcolor="#ffffff">技术员</td>
                        <td align="center" bgcolor="#ffffff">514889962@qq.com</td>
                        <td align="center" bgcolor="#ffffff">6589551</td>
                        <td align="center" bgcolor="#ffffff">启 用</td>
                        <td align="center" bgcolor="#ffffff"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                      <tr>
                        <td align="center" bgcolor="#f1f3f6">沈鹏飞</td>
                        <td align="center" bgcolor="#f1f3f6">shenpengfei</td>
                        <td align="center" bgcolor="#f1f3f6">研发部</td>
                        <td align="center" bgcolor="#f1f3f6">技术员</td>
                        <td align="center" bgcolor="#f1f3f6">514889962@qq.com</td>
                        <td align="center" bgcolor="#f1f3f6">6589551</td>
                        <td align="center" bgcolor="#f1f3f6">启 用</td>
                        <td align="center" bgcolor="#f1f3f6"><a href="javascript:;" class="sy_link">上 移</a></td>
                      </tr>
                    </table>
                
                </div>
            
     	 </div>
      </div>
</body>
</html>