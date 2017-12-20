<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
    <title>文档</title>	
	<script type="text/javascript" src="${_resources}jq/jquery-1.8.3.min.js"></script>
	<script>
	var TANGER_OCX_OBJ;
	function init(){
		//getStatus();	
		 TANGER_OCX_OBJ=document.getElementById("TANGER_OCX");
		 TANGER_OCX_OBJ.activate(true);		
		  //允许或禁止文件－>新建菜单
		  TANGER_OCX_OBJ.FileNew = false;
		  //允许或禁止文件－>打开菜单
		  TANGER_OCX_OBJ. FileOpen  = true;
		  //允许或禁止文件－>关闭菜单
		  TANGER_OCX_OBJ.FileClose = false;
		  //允许或禁止文件－>保存菜单
		  //TANGER_OCX_OBJ.FileSave = false;
		  //允许或禁止文件－>另存为菜单
		  TANGER_OCX_OBJ.FileSaveAs = false;
		  //允许或禁止文件－>打印菜单
		  TANGER_OCX_OBJ.FilePrint = false;
		  //允许或禁止文件－>打印预览菜单
		  TANGER_OCX_OBJ.FilePrintPreview = false;
		  //允许或禁止文件－>页面设置
		  TANGER_OCX_OBJ.FilePageSetup = false;
		  //允许或禁止文件－>属性
		  TANGER_OCX_OBJ.FileProperties = false;
		 
		  //工具栏禁用
	      //IE 火狐都可以 	
		  //if(status=='new'){
		  TANGER_OCX_OBJ.Toolbars = false;
		  TANGER_OCX_OBJ.Menubar = false;
		  var url = "${_baseUrl}/documentTemplateController/openTemplateDocument?id=${documentId}";
		  TANGER_OCX_OBJ.BeginOpenFromURL(url); 	 
		  TANGER_OCX_OBJ.IsStrictNoCopy = false;  
	}
	
	
	
</script>
  </head>
  <body onload="init()">
  <div style="z-index:-1; position:relative;">
  
   <form action="" id="myFile" enctype="multipart/form-data" method="post" >
   <script type="text/javascript" src="${_officecontrol}ntkoofficecontrol.js"></script>
   <!-- <script type="text/javascript" for="TANGER_OCX" event="OnFileCommand(cmd,canceled)">saveFile();</script>  -->
   <script type="text/javascript" for="TANGER_OCX" event="OnDocumentOpened(a,b)"> 
	var ntkoobj = document.getElementById("TANGER_OCX");
	ntkoobj.SetRibbon("TabHome", false, false);
	ntkoobj.SetRibbon("TabDeveloper", false, false);
	ntkoobj.SetRibbon("TabPageLayoutWord", false, false);
	ntkoobj.SetRibbon("TabReferences", false, false);
	ntkoobj.SetRibbon("TabMailings", false, false);
	//ntkoobj.SetRibbon("TabView", false, false);
	ntkoobj.SetRibbon("TabReviewWord", false, false);
 </script>	
 </form> 
 </div>
  </body>
</html>
