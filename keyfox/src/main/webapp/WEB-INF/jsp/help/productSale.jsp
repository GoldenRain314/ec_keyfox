<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>产品购买</title>
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
   <div class="main_cont dingxwd_main" > <!-- style="margin-left:251px;" -->
       <div class="main_c">
           <div class="help_list pt50">
               <h2 class="help_cont_tit">产品购买</h2>
               <div class="help_cont_t mt10">
               		<p style="margin-bottom:20px;"><strong>（一）软件自动化编制平台基础版服务：</strong></p>
     <p>（1）用户数：5个用户（含系统管理员、安全审计员和安全保密员），可新建2个子账号。</p>
<p>（2）文档范本库： 40余份GJB438B的标准文档模板，以及标准样式定义模板、标准输出模板。</p>
<p>（3）功能列表</p>
	<div style="margin-top:20px;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tablebox">
  <tr>
    <td width="45" height="50" valign="middle" ><p align="center" ><strong>序号</strong></p></td>
    <td width="99" valign="middle" ><p align="center" ><strong>功能类型</strong><strong> </strong></p></td>
    <td width="75" valign="middle" ><p align="center" ><strong>菜单名称</strong><strong> </strong></p></td>
    <td width="320" valign="middle" ><p align="center" ><strong>功能要点</strong><strong> </strong></p></td>
  </tr>
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >1 </p></td>
    <td width="99" rowspan="5" align="center" valign="middle" ><p >基础模块 </p> </td>
    <td width="75" align="center" valign="middle" ><p >用户管理 </p></td>
    <td width="320" valign="middle" ><p style="padding:3px 10px 3px 10px; line-height:24px;">用户密码重置、用户增删改查、用户加锁/解锁、用户注销、用户禁用/启用。 </p></td>
  </tr>
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >2 </p></td>
    <td width="75" align="center" valign="middle" ><p >组织管理 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">部门的增删改查、部门人员的设置。 </p></td>
  </tr>
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >3 </p></td>
    <td width="75" align="center" valign="middle" ><p >授权管理 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">角色设置、权限设置。 </p></td>
  </tr>
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >4 </p></td>
    <td width="75" align="center" valign="middle" ><p >审计管理 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">三员管理、查询/导出/归档审计记录。 </p></td>
  </tr>
  <tr >
    <td width="45" height="50" align="center" valign="middle" ><p >5 </p></td>
    <td width="75" align="center" valign="middle" ><p >安全管理 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">三员管理机制，用于不同系统秘密级等级的安全措施设定。 </p></td>
  </tr>
  <tr >
    <td width="45" height="50" align="center" valign="middle" ><p >6 </p></td>
    <td width="99" rowspan="3" align="center" valign="middle" ><p style="line-height:24px;">模板库及<br>
      知识库 </p></td>
    <td width="75" align="center" valign="middle" ><p >组织资产 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">预设置目录和内容，可自行增删改查；<br>
      组织资产在文档编写过程的引用。 </p></td>
  </tr>
  <tr >
    <td width="45" height="50" align="center" valign="middle" ><p >7 </p></td>
    <td width="75" align="center" valign="middle" ><p >文档模板管理 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">文档模板的自定义；文档导入后的解析；文档标准库的管理（样式定义模板和样式输出模板）；文档模板分类的设置；项目文档模板的定义、增删改查及调用；基于GJB438B的标准文档库的管理。 </p></td>
  </tr>
  <tr >
    <td width="45" height="50" align="center" valign="middle" ><p >8</p></td>
    <td width="75" align="center" valign="middle" ><p >文档范本库 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">文档范本库电子化文档的浏览/调用/查询。 </p></td>
  </tr>
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >9 </p></td>
    <td width="99" rowspan="2" align="center" valign="middle" ><p style="line-height:24px;">项目文档管理与文档编制 </p> </td>
    <td width="75" align="center" valign="middle" ><p >项目定义 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">系统管理员：目录菜单的建立、项目负责人的设置、编制进度管理的设置； <br>
      项目负责人：项目信息的初始化、设置文档列表、设置文档的负责人、协同编辑的参与人、协同编制方式以及文档编辑/浏览权限、项目文档模板和信息的复用。 </p></td>
  </tr>
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >10 </p></td>
    <td width="75" align="center" valign="middle" ><p >文档编写 </p></td>
    <td width="320" valign="middle" ><p style="padding:3px 10px 3px 10px; line-height:24px;">基于word模式的文档编写（按照设定的模板或空白文档）、按照预先设置的文档样式库导出文档、文档的预览/发布、文档协同编制和权限控制、文档浏览/编辑权限的控制、设置文档章节名称的标识<!-- 、文档版本重复 -->的校验<!-- 、历史版本记录的查询和浏览 -->、文档修订和审阅、编制进度管理和监控、文档自动保存、自动加载文档模板的内容、文档提交时对文档章节内容是否编写进行遍历和提示。</p></td>
  </tr>
 <!--  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >11 </p></td>
    <td width="99" align="center" valign="middle" ><p >文档内容追踪 </p></td>
    <td width="75" align="center" valign="middle" ><p >需求追踪 </p></td>
    <td width="320" valign="middle" ><p style=" line-height:24px; padding:3px 10px 3px 10px;">
     可灵活选择文档并建立多文档（最新版本）内容间的关联关系（按文档章节结构逐个关联），也可预先自定义内容追踪关系； <br>
       实现当前文档与前置文档的内容追踪关系的建立（按文档章节结构选取，以追踪列表展示），并可按照设定的展示位置自动插入追踪列表的内容； <br>
       提供基于GJB438B的标准化需求追踪关系的内置初始化设置，GJB438B需求正逆向追踪列表按照预设定的默认追踪关系自动生成文档间章节追踪列表以及全景追踪矩阵；<br>
      可查看文档历史版本之间的内容追踪表。</p></td>
  </tr>
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >12 </p></td>
    <td width="99" align="center" valign="middle" ><p style="line-height:24px;">变更影响域<br>
      分析 </p></td>
    <td width="75" align="center" valign="middle" ><p >变更分析 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">基于文档间内容追踪关系和追踪类型的关联影响域分析及展示，可精确到具体章节； <br>
      项目文档的勘误错误的统一修改；<br>
      文档变更单、文档内容变更记录的填写与导出； <br>
      文档变更数量、变更次数历史变更记录的查询。</p></td>
  </tr> -->
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >11 </p></td>
    <td width="99" rowspan="3" align="center" valign="middle" ><p >其他功能 </p> </td>
    <td width="75" align="center" valign="middle" ><p >首页 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">我的工作台、各功能模板信息的综合展示、待办及待阅消息的推送。 </p></td>
  </tr>
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >12 </p></td>
    <td width="75" align="center" valign="middle" ><p >帮助中心 </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px; ">产品介绍、操作说明、FAQ 。 </p></td>
  </tr>
  <tr>
    <td width="45" height="50" align="center" valign="middle" ><p >13 </p></td>
    <td width="75" align="center" valign="middle" ><p >GJB438B项目文档模板  </p></td>
    <td width="320" valign="middle" ><p style="line-height:24px; padding:3px 10px 3px 10px;">包括项目信息初始化、文档内容追踪关系的默认模板、文档章节内容的自动复用。 </p></td>
  </tr>
</table>
	
	
	</div>
	
	<p style="margin-top:20px; margin-bottom:20px;"><strong>（二）软件自动化编制平台增值版服务：</strong></p>
	<p style="text-indent:2em;">在软件自动化编制平台基础版服务的功能列表基础上，升级如下服务：</p>
	<p style="text-indent:2em;">（1）用户数：10个用户（含系统管理员、安全审计员和安全保密员），可新建7个子账号。</p>
<p style="height:47px; text-indent:2em; margin-bottom:20px; border-bottom:1px dashed #666;	">（2）文档范本库：更多的军工产品研制的技术文档的编写范例、编写说明和编写指南、定型文档模板等参考文献资料。</p>
<p style="margin-bottom:20px;"><strong>产品购买事宜请咨询各办事处，联络方式如下：</strong></p>
<div>
	<div style="float:left; width:50%; height:105px;">
		<strong>北京总部</strong><br>
地址：北京市昌平区回龙观龙城花园龙邸2号楼2单元4-6层<br>
联系电话：010-80750488<br>
邮编：102208
	</div>
	
	<div style="float:left; width:50%; height:105px;">
	<strong>西北办事处</strong><br>
地址：陕西省西安市雁塔区电子西街二号<br>
联系电话：029-88898473<br>
</div>
<div style="float:left; width:50%; height:84px;">
<strong>华中办事处</strong><br>
地址：湖北省武汉市武昌区民主路737<br>
联系电话：15927008221<br>
</div>
<div style="float:left; width:50%; height:84px;">
<strong>华东办事处</strong><br>
地址：上海市普陀区中山北路2911号中关村科技大厦<br>
联系电话：021-61079702<br>
</div>
<div style="float:left; width:50%; height:105px;">
<strong>西南办事处</strong><br>
地址：成都市武侯区长益路13号蓝海office <br>
联系电话：028-66502089
</div>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	
	
	


</div>
	
	
	
	
	
	
                </div>
           </div>
           
       </div>
   </div>
</body>
</html>