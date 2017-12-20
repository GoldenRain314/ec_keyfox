<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
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
		
		  //允许或禁止文件－>新建菜单
		  TANGER_OCX_OBJ.FileNew = true;
		  //允许或禁止文件－>打开菜单
		  TANGER_OCX_OBJ. FileOpen  = true;
		  //允许或禁止文件－>关闭菜单
		  TANGER_OCX_OBJ.FileClose = true;
		  //允许或禁止文件－>保存菜单
		  TANGER_OCX_OBJ.FileSave = true;
		  //允许或禁止文件－>另存为菜单
		  TANGER_OCX_OBJ.FileSaveAs = false;
		  //允许或禁止文件－>打印菜单
		  TANGER_OCX_OBJ.FilePrint = false;
		  //允许或禁止文件－>打印预览菜单
		  TANGER_OCX_OBJ.FilePrintPreview = false;
		  //允许或禁止文件－>页面设置
		  TANGER_OCX_OBJ.FilePageSetup = true;
		  //允许或禁止文件－>属性
		  TANGER_OCX_OBJ.FileProperties = true;
		  //TANGER_OCX_OBJ.OpenLocalFile("G:\\1.docx", true,"Word.Document")
		  //工具栏禁用
	      //IE 火狐都可以 		
	     TANGER_OCX_OBJ.Toolbars = true;
			 // alert(TANGER_OCX_OBJ.Toolbars);
			  //菜单栏禁用
		 TANGER_OCX_OBJ.Menubar = true;
		 if(getStatus()==true||getStatus()=='true'){
			 var url = "${_baseUrl}/sectioNtkoContentController/openSectionContent.do?projectId="+projectId+"&documentId="+documentId+"&sectionId="+id;
		    	TANGER_OCX_OBJ.BeginOpenFromURL(url);    
		 }else{
			 var url = "${_baseUrl}/documentTemplateController/previewTemplateDocument.do?id=3d542c1d1ed94b568969c7db0e801a0e";
		    	TANGER_OCX_OBJ.BeginOpenFromURL(url); 
		 }
	      //标题栏禁用
	 	  TANGER_OCX_OBJ.Titlebar =false;
	 	  //禁止拷贝
		 TANGER_OCX_OBJ.IsStrictNoCopy = false;
		  //TANGER_OCX_OBJ.isnocopy = false;
	}
	
	/* 定是保存编辑框 */
	$(function(){
		window.setInterval(saveFile, 60000);
	});

	
	function saveFile(){
		var strRtn= TANGER_OCX_OBJ.SaveToURL("${_baseUrl}/servlet/saveSectionContent?sectionId="+id,"NTKOFILE","pp=0","1.docx","myFile");	
		document.getElementById("TANGER_OCX").CancelLastCommand=true;
		return strRtn;
		
	}
	
	function  close(){
		 TANGER_OCX_OBJ.activate(false);
	}
	function getStatus(){		
		var path="${_baseUrl}/sectioNtkoContentController/judgeSectionContent.do?sectionId="+id;
		$.ajax({
			cache:false,//是否缓存
			type:"POST",//提交方式
			url:path,
			//data:$("form").serialize(),
			async:false,//是否异步
			dataType:"json",
			error:function(request){//错误时
			 	
			},
			success:function(data){	
				if(data.message=="1"){
					status =true;
				}else{
					status=false;
				}
			}
	 	});
	 	return status;
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
