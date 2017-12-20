<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html style="overflow-y:hidden;">
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>文档</title>	
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script>
	var id = "${sectionId}";
	var status=false;
	var TANGER_OCX_OBJ;
	var projectId="${projectId}";
	var documentId= "${documentId}";
	function init(){
		//getStatus();	
		 TANGER_OCX_OBJ=document.getElementById("TANGER_OCX");
		 TANGER_OCX_OBJ.activate(true);
		 //只读
		
		  //允许或禁止文件－>新建菜单
		  TANGER_OCX_OBJ.FileNew = false;
		  //允许或禁止文件－>打开菜单
		  TANGER_OCX_OBJ. FileOpen  = false;
		  //允许或禁止文件－>关闭菜单
		  TANGER_OCX_OBJ.FileClose = false;
		  //允许或禁止文件－>保存菜单
		  TANGER_OCX_OBJ.FileSave = false;
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
		  //TANGER_OCX_OBJ.OpenLocalFile("G:\\1.docx", true,"Word.Document")
		  //工具栏禁用
	      //IE 火狐都可以 		
	     //TANGER_OCX_OBJ.Navigation = true;
		 TANGER_OCX_OBJ.IsShowToolMenu = true;
	     TANGER_OCX_OBJ.Toolbars = true;

			  //alert(TANGER_OCX_OBJ.Toolbars);
		 //菜单栏显示全屏控件  170512
		 TANGER_OCX_OBJ.Menubar = true;
			  
		 var url = "${_baseUrl}/exportController/documentPreview?projectId="+projectId+"&documentId="+documentId+"&ifReturn=true";  
		 TANGER_OCX_OBJ.BeginOpenFromURL(url); 
		
	      //标题栏禁用
	 	  TANGER_OCX_OBJ.Titlebar =false;
	 	  //禁止拷贝
		 TANGER_OCX_OBJ.IsStrictNoCopy = false;
		  //TANGER_OCX_OBJ.isnocopy = false;
		 TANGER_OCX_OBJ.SetReadOnly(true); 
	}
	
	
	$(function(){
		initHeight();
		window.setInterval(saveFile, 30000);
		//window.setTimeout(setTimeSave, 300000);
	})
	window.onresize = function(){
		var resizeTimer = null;
		if(resizeTimer) cleatTimeout(resizeTimer);
		resizeTimer = setTimeout("initHeight()",100);
	}
	function  close(){
		 TANGER_OCX_OBJ.activate(false);
	}
	function initHeight(){    // 文档插件高度自适应显示 170512
		var topH = 0;
		var initheight = document.documentElement.clientHeight - topH;
		document.getElementById("TANGER_OCX").style.height = initheight +"px";
	}
	
	
</script>
</head>

<body onload="init();">
<div>
 <form action="" id="myFile" enctype="multipart/form-data" method="post">
	 <script type="text/javascript" src="${_officecontrol}ntkoofficecontrol.js"></script>
	 <script type="text/javascript" for="TANGER_OCX" event="OnFileCommand(cmd,canceled)">saveFile();</script> 
</form> 
</div>
 </body>
</html>
