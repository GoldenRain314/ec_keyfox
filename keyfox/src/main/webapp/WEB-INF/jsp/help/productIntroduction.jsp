<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>产品简介</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">

</script>

<style>
	.main_cont { margin:0;}
	.dingxwd_main { margin:0;}
	.help_cont_t { padding-bottom:20px;}
</style>

<body>
  <div class="main_cont dingxwd_main">
       <div class="main_c">
           <div class="help_list pt50">
               <h2 class="help_cont_tit">文档自动化管理平台（KeyDoc）产品简介</h2>
               <div class="help_cont_t mt10">
               		<p style="text-indent:2em;">文档自动化编制平台是一个通用性强、适用范围广的文档协同编制平台。该平台由文档模板定制、文档在线协同编制、<!-- 文档内容追踪、文档变更影响域分析、 -->文档模板库等功能模块组成，操作简单便捷，实现多人协同编制文档，提高文档编写的效率。</p><br>
				    <p style="text-indent:2em;">文档自动化编制平台提供智能化的文档模板和内容复用，减轻文档编制的工作量。该产品通用性广，适用于多个领域；并具有可移植性强的特点，可轻松实现本地化文档编制标准的执行，<!-- 通过提供全面的文档内容变更影响域分析， -->可减少文档内容间的差异，提高文档编写的质量。</p><br>
					<p style="text-indent:2em;">与此同时，通过深耕军工产品研制技术文档编制领域，该平台提供军工产品研制各类标准化的技术文档模板和知识库，符合GJB438B-2009、GJBZ170.1等多种军用软件开发文档编制的专业需求，为军用软件文档编写提供参考。</p>
					<div style="max-width:1129px; margin:0 auto; margin-top:50px; text-align:center; ">
						<img src="${_resources}images/jianjie_img.jpg" alt="" style="display:inline; width:100%;" />
					</div>
                </div>
           </div>
           
       </div>
   </div>
</body>
</html>