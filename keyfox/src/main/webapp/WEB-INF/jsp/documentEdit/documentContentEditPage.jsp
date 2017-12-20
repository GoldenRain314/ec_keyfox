<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1"> 

<title></title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link type="text/css" rel="stylesheet" href="${_resources}ztree/zTreeStyle.css">
<script src="${_resources}js/jquery.ztree.all-3.5.min.js"></script>
<script src="${_resources}js/jquery.progressbar.min.js"></script>

<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<script type="text/javascript" src="${_resources}jquery-ui/jquery.ui.position.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<link rel="stylesheet" href="${_resources}css/jquery.jscrollpane1.css" />

<!--加载meta IE兼容文件-->  
<!--[if lt IE 9]>  
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>  
<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>  
<![endif]-->  

<script type="text/javascript">
	var ztree;
	var parentId;
	var documentId ="${documentId}";
	var projectId ="${projectId}";
	var templateId ="${templateId}";
	var operator =   eval('(${operator})');
	var userId ="${userId}";
	var muserId ="${muserId}";
	var beforeNodeId ="${nodeId}";
	var parentId ="${nodeId}";
	var beforeSrc ="";
	var sId = "";
	var sNumber = "";
	var seconds = 0;
	var isAdd = "yes";
	var status = "${status}";
	var isBlack = "${isBlack}";
	var sectionId = "";
	var sectionName = "";	
	var baseUrl ="${_baseUrl}";
	// 登陆人
	var landing = "${user_id}";
	// 项目负责人
	var paomid = "${promid}";
	// 文档负责人
	var documentManagerId = "${documentManagerId}";
	// 可变章节创建人
	var createdPeople = "";
	
	function ntko(){
		window.location.href="${_baseUrl}/officecontrol/NTKOINSTALL.exe";
	}
	
	if (!Array.prototype.indexOf)
	{
	  Array.prototype.indexOf = function(elt /*, from*/)
	  {
	    var len = this.length >>> 0;

	    var from = Number(arguments[1]) || 0;
	    from = (from < 0)
	         ? Math.ceil(from)
	         : Math.floor(from);
	    if (from < 0)
	      from += len;

	    for (; from < len; from++)
	    {
	      if (from in this &&
	          this[from] === elt)
	        return from;
	    }
	    return -1;
	  };
	}
	
	var setting = {	
		view: {
			fontCss: getFont,
			showLine: true,
			selectedMulti: false,
			addDiyDom: addDiyDom,
			dblClickExpand: false
			/*addHoverDom:addHoverDom  
            /*removeHoverDom:removeHoverDom */
           
		},
		 edit: {  
             enable: true,  
             editNameSelectAll:true, 
             removeTitle:'删除',
			renameTitle:'修改',
            showRemoveBtn: false,
			showRenameBtn: false  
         }, 
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			onNodeCreated: this.onNodeCreated,
			onClick: onClick,
			beforeDrag: beforeDrag,
			beforeEditName: beforeEditName,
			beforeRemove: beforeRemove,
			onRemove: onRemove
		}
	
	};
	
	
	
	var zNodes =eval('(${zNodes})');
	$(document).ready(function(){
		
		$("#lock").hide();
    	$("#unlock").hide();
    	$("#lockName").hide();
		getButton();
		ztree =$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		
		 if( "${nodePId}" != ""){
			ztree.expandNode(ztree.getNodeByParam("id","${nodePId}",null));  // 展开指定节点  
		}  
		 
		getId(); //得到标红字体ID值并展开所选则的子节点
		
		ztree.selectNode(ztree.getNodeByParam("id","${nodeId}",null)); //选中指定节点
		ztree.setting.callback.onClick(null, ztree.setting.treeId, ztree.getNodeByParam("id","${nodeId}",null));//触发函数
		getEditPercentage();
		replaceRefer();
	
		
	});
	
	/* 获取字体红色的id值并展开响应子节点开始  */
	function getId(){
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo"); 
		//treeObj.expandAll(true); 
		var node = treeObj.getNodes();
		nodeList = treeObj.transformToArray(node);
		for(var i=0; i<nodeList.length; i++){
			if( muserId!=userId && "${userId}"!="${proManager.userId}"&&"${SynergyType}"=='1'){
				if(judegEditStatus(nodeList[i].id)){
					treeObj.expandNode(ztree.getNodeByParam("id",nodeList[i].id,null));
					continue;
				}
			}else{
				break;
			}
		}
	}
	/* 获取字体红色的id值并展开响应子节点结束  */
	
	
	function  replaceRefer(){
		var ztree = $.fn.zTree.getZTreeObj("treeDemo");
		var	nodes =ztree.transformToArray(ztree.getNodes());
		for(var i=0;i<nodes.length;i++){
			var childNodes = nodes[i];//㊤㊥㊦㊧㊨㊐㊊
			var name = childNodes.name;
			var result = true;
			while(result){
				if(name.indexOf("▼▽㊤▲△")>0||name.indexOf("▼▽㊦▲△")>0||name.indexOf("▼▽㊧▲△")>0||name.indexOf("▼▽㊨▲△")>0||name.indexOf("▼▽㊐▲△")>0||name.indexOf("▼▽㊊▲△")>0){
					name = name.replace("▼▽㊤▲△","'");
					name = name.replace('▼▽㊦▲△','"');
					name = name.replace("▼▽㊧▲△","‘");
					name = name.replace('▼▽㊨▲△','’');
					name = name.replace('▼▽㊐▲△','“');
					name = name.replace('▼▽㊊▲△','”');
				}else{
					result = false;
				}
			}
			ztree.getNodeByParam("id",childNodes.id,null).name =name;
			ztree.updateNode(ztree.getNodeByParam("id",childNodes.id,null));
		}
	}
	function getEditPercentage(){
		$.ajax({
			url:'${_baseUrl}/documentList/getEditPercentage?documentId=${documentId}',
			type:'post', //数据发送方式 
			dataType:'text', //接受数据格式 
			async: false,
			success: function(data){
				$("#progress").progressBar(data, { barImage: '${_resources}images/progressbg_green.gif' });
	        },
			error:function(){
				layer.msg( "系统错误");
			}
		});
	}
	function getFont(treeId, node){
		if(muserId!=userId&&"${userId}"!="${proManager.userId}"&&"${SynergyType}"=='1'){
			if(judegEditStatus(node.id)){
				return {'color':'red'};
			}else{
				return {'color':'black'};
			}
		}else{
			return {'color':'black'};
		}
	}
	
	function updateTree(jsonTree,nodeId,operStr){
		status='3';
		operator =eval(operStr);
		zNodes = eval(jsonTree);
		ztree =$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		// ztree.expandNode(ztree.getNodeByParam("id",documentId,null)); //展开指定节点   
		ztree.selectNode(ztree.getNodeByParam("id",nodeId,null));//选中指定节点
		ztree.setting.callback.onClick(null, ztree.setting.treeId, ztree.getNodeByParam("id",nodeId,null));//触发函数
		replaceRefer();
	}
	
	function addNode(treeId, treeNode){
		if(treeNode.sectionNumber != undefined){
			sId = treeNode.id;
			sNumber = treeNode.sectionNumber;
		}
	  //在这里向后台发送请求保存一个新建的叶子节点，父id为treeNode.id,让后将下面的100+newCount换成返回的id  
        parentId = treeNode.id;
		var frame = $("#templatelist");
		var src  = $(frame).attr("src");
		tmpViewList.window.close();
		if(src.indexOf("documentSectionController")>0|| src.indexOf("docModel")>0){
			beforeSrc=src;
			$(frame).attr("src","");
		} 
		
		if(treeNode.id==documentId){
			addSection(parentId, parentId);
		}else{
			var pId = treeNode.pId;
			addSection(treeNode.id,pId);
		}
		
		isAdd = "yes";
	}
	
	
	
	function addDiyDom(treeId, treeNode) {
		var num = "";
		if(treeNode.sectionNumber != undefined){
			if(treeNode.sectionNumber.indexOf(".") >= 0){
				num = treeNode.sectionNumber.substring(0,treeNode.sectionNumber.indexOf("."));
			}else{
				num = treeNode.sectionNumber;
			}
		}
		if (treeNode.parentNode && treeNode.parentNode.id!=1) return;
		var liObj = $("#" + treeNode.tId);
		var aObj = $("#" + treeNode.tId + "_span");
		liObj.addClass("level_"+treeNode.level);
		aObj.addClass("le_"+treeNode.level);
		var sObj = $("#" + treeNode.tId + "_span");  

		if(judgeAddSection (treeId, treeNode)){
			if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
			//添加按钮
	       	var addStr = "<span class='button add' id='addBtn_" + treeNode.tId  
		       + "' title='添加节点'></span>";  
		 	  sObj.after(addStr);
			//修改按钮
			sObj = $("#addBtn_"+treeNode.tId);
			var alterStr = "<span class='button edit' id='editBtn_" + treeNode.tId  
	       		+ "' title='修改节点'></span>";  
	 	  	sObj.after(alterStr); 
	 	  	
	 	   	var editbtn = $("#editBtn_"+treeNode.tId);
			if (editbtn) editbtn.bind("click", function(){
				saveSectionContent();
		 		if("${editPlan}" == '0'){
		 			isAdd = "";
			 		if(sNumber != num){
			 			editPlan(null,treeId,treeNode,'editNode');
					}else{
						beforeEditName(treeId, treeNode);
					}
		 		 }else{
		 			beforeEditName(treeId, treeNode);
		 		 }
		 	 });
	 	  	//删除按钮
			sObj = $("#editBtn_"+treeNode.tId);
			var delStr = "<span class='button remove' id='delBtn_" + treeNode.tId  
		       + "' title='删除节点'></span>";  
		 	  
		       // 查询当前可变章节的创建人
		       $.ajax({
		    	   url:"${_baseUrl}/sectionController/getSectionCreatedPeople",
		    	   type:"POST",
		    	   async:false,
		    	   dataType:"json",
		    	   data:{
		    		   "sectionId":treeNode.id
		    	   },
		    	   success:function(data){
		    		   //alert(data.message);
		    		   createdPeople = data.message;
		    	   }
		       });
		       // 判断可变章节是否是由协同人员添加，非协同人员添加的可变章节，协同人员不具有删除权限，协同人员仅可以删除他自己添加的章节
		       if(landing == paomid || landing == documentManagerId || landing == createdPeople){
			       sObj.after(delStr); 
		       }
		       createdPeople = "";
	 	  	
		 	   var delbtn = $("#delBtn_"+treeNode.tId);
			 	 if (delbtn) delbtn.bind("click", function(){ 
			 		saveSectionContent();
			 		if("${editPlan}" == '0'){
			 			isAdd = "";
				 		if(sNumber != num){
				 			editPlan(null,treeId,treeNode,'removeNode');
						}else{
							onRemove(treeId,treeNode);
						}
			 		}else{
			 			onRemove(treeId,treeNode);
			 		}
			 		
			 	 }); 	
		 	  	
		 	 var btn = $("#addBtn_"+treeNode.tId);
		 	 if (btn) btn.bind("click", function(){
		 		//每点一次触发保存一次
		 		saveSectionContent();
		 		
		 		if("${editPlan}" == '0'){
		 			isAdd = "";
			 		if(sNumber != num){
			 			editPlan(null,treeId,treeNode,'addNode');
					}else{
						addNode(treeId, treeNode);
					}
		 		}else{
		 			addNode(treeId, treeNode);
		 		}
		 		
		     });
    	}else{
    		
    	   var width = $("#treeDemo").width();
    	   var obj = $("#" + treeNode.tId + "_span");
    	   if(obj.hasClass("le_8")) obj.css("max-width",width-260);  /* 文档编写左侧目录树缺省显示调整 170606  */
    	   if(obj.hasClass("le_7")) obj.css("max-width",width-220);
    	   if(obj.hasClass("le_6")) obj.css("max-width",width-180);
    	   if(obj.hasClass("le_5")) obj.css("max-width",width-160);
    	   if(obj.hasClass("le_4")) obj.css("max-width",width-140);
    	   if(obj.hasClass("le_3")) obj.css("max-width",width-120);
    	   if(obj.hasClass("le_2")) obj.css("max-width",width-100);
    	   if(obj.hasClass("le_1")) obj.css("max-width",width-100);  /* 调整显示宽度  */
    	   if(obj.hasClass("le_0")) obj.css("max-width",width-100);
    	   
    		//var status ="${status}";
    		if(treeNode.name.indexOf("附录-附")>=0 && treeNode.pId==documentId && status !="3"&&judegEditStatus(treeNode.id)&&treeNode.name.indexOf("附件")<0){
    			sObj = $("#" + treeNode.tId + "_span"); 
    			var delStr = "<span class='button remove' id='delBtn_" + treeNode.tId  
    		       + "' title='删除节点'></span>";  
    		 	  	sObj.after(delStr); 
    	 	  	
   		 	   	 var delbtn = $("#delBtn_"+treeNode.tId);
   			 	 if (delbtn) delbtn.bind("click", function(){  
   			 		isAdd = "";
			 		if(sNumber != num){
			 			editPlan(null,treeId,treeNode,'removeNode');
					}else{
						onRemove(treeId,treeNode);
					}
   			 	 }); 	
    		}
    		if(treeNode.name.indexOf("前言")>=0 && treeNode.pId==documentId && status !="3"&&judegEditStatus(treeNode.id)&&(muserId ==userId ||"${promid}" == "${user_id}")){
    			sObj = $("#" + treeNode.tId + "_span"); 
    			var delStr = "<span class='button remove' id='delBtn_" + treeNode.tId  
    		       + "' title='删除节点'></span>";  
    		 	  	sObj.after(delStr); 
    	 	  	
   		 	   	 var delbtn = $("#delBtn_"+treeNode.tId);
   			 	 if (delbtn) delbtn.bind("click", function(){  
   			 		isAdd = "";
			 		if(sNumber != num){
			 			editPlan(null,treeId,treeNode,'removeNode');
					}else{
						onRemove(treeId,treeNode);
					}
   			 	 }); 	
    		}

    	}
       
       if(treeNode.id == documentId){
    	   var uri = treeNode.uri;
    	   if((status !="3"&&(uri==null||uri==""))||((uri!=null&&uri!="")&&status=="3")){
	    	   sObj = $("#" + treeNode.tId + "_span"); 
	    	   //添加文档大标题
	    		var addStr = "<span class='button add' id='addBtn_" + treeNode.tId  
			       + "' title='设置正文标题或前言'></span>";  
			 	if(muserId ==userId ||"${promid}" == "${user_id}"){
			 	  sObj.after(addStr);
			 		//添加文档大标题
				 	var btn = $("#addBtn_"+treeNode.tId);
				 	if (btn) btn.bind("click", function(){ 	
				 		isAdd = "";
						if(sNumber != num){
				 			editPlan(null,treeId,treeNode,'alertTitleAndPer');
						}else{
							alertTitleAndPer();
						}		
						
			 	});	
				   
			 	} 
    	   }
       }
       
       if(treeNode.name != null){
    	    if(treeNode.name == "在线编写"){
	    	   sObj = $("#" + treeNode.tId + "_a"); 
	    	   //添加文档大标题
	    		var addStr = "<span class='xmuxx_b_xq1 button'  id = 'organize' style='padding:0; margin:0; display: inline-block; position:absolute; top:13px; left:135px;'>"+
	    						 "<span id='reuseAsset' onclick='openOrangize();' class='quoteOrganize' style='padding:0 0 0 15px; margin:0; font-size:12px; background:none; ' title='引用组织资产'>引用组织资产</span>"+
	    						// "<span onclick='importExcl();' class='importData' style='padding:0 0 0 15px; margin:0; font-size:12px; background:none; ' title='导入数据'>导入数据</span>"+
	    					"</span>";  
			 	if(muserId ==userId ||"${promid}" == "${user_id}"){
			 	  	sObj.after(addStr);
			 	} 
    	   } 
       }
       
      
       
   };

   function initWidth(){   // 未添加小按钮的子节点设置缺省显示 
		var width = $("#treeDemo").width();
		$("#treeDemo li .le_8").css("max-width",width-220);
		$("#treeDemo li .le_7").css("max-width",width-200);
		$("#treeDemo li .le_6").css("max-width",width-180);
		$("#treeDemo li .le_5").css("max-width",width-160);  /* 需求追踪页面四级及五级目录树缺省显示调整 170511  */
		$("#treeDemo li .le_4").css("max-width",width-140);
		$("#treeDemo li .le_3").css("max-width",width-120);  // width(width-100);
		$("#treeDemo li .le_2").css("max-width",width-100);   
		$("#treeDemo li .le_1").css("max-width",width-100);
		$("#treeDemo .le_0").css("max-width",width-100);
	}
   
   function alertTitleAndPer(){
	   saveSectionContent();
	   var frame = $("#templatelist");
		var src  = $(frame).attr("src");
		if(src.indexOf("documentSectionController")>0 || src.indexOf("docModel")>0){
			beforeSrc=src;
			$(frame).attr("src","");
			
		}
	   setTimeout(function(){
			saveReplace();
			layer.confirm("添加前言或正文标题", {
				title:'选择添加类型',
				cancel: function(){
					var zTree = $.fn.zTree.getZTreeObj("treeDemo");
	        		zTree.expandNode(ztree.getNodeByParam("id",parentId,null));//展开指定节点
	        		zTree.selectNode(zTree.getNodeByParam("id",parentId,null));//选中指定节点
				},
				btn: ['添加正文标题','添加前言'] //按钮
				},function(){
					layer.closeAll('dialog');
					addTitle(documentId);
				}, function(){
					addPreface(documentId,projectId);
				}); 
		},1000);
   }
	
	function addTitle(documentId){
		
		var frame = $("#templatelist");
		var src  = $(frame).attr("src");
		if(isBlack!='0'){
			if(src.indexOf("documentSectionController")>0 || src.indexOf("docModel")>0){
				tmpViewList.window.close();
				if(src.indexOf("documentSectionController")>0 || src.indexOf("docModel")>0){
					beforeSrc=src;
					$(frame).attr("src","");
				}
				setTimeout(function(){
					$("#popIframe").empty();	
					$("#popDiv").dialog({
						title:'设置正文标题',
						autoOpen: true,
						modal: true,
						postion:'center',
						height: 250,
						width: 600,
						close:function(event,uri){
							isAdd ="yes";
							showBeforeSection();
						}
					});	
					$("#popIframe").attr("width","100%");
					$("#popIframe").attr("height","95%");
					$("#popIframe").attr("src","${_baseUrl}/documentList/returnAddTitle?documentId="+documentId); 
					
				},1000);	
			}else{
				$("#popIframe").empty();	
				$("#popDiv").dialog({
					title:'设置正文标题',
					autoOpen: true,
					modal: true,
					postion:'center',
					height: 250,
					width: 600,
					close:function(event,uri){
						 isAdd ="yes";
						showBeforeSection();
					}
				});	
				$("#popIframe").attr("width","100%");
				$("#popIframe").attr("height","95%");
				$("#popIframe").attr("src","${_baseUrl}/documentList/returnAddTitle?documentId="+documentId); 
			}
		}else{
			if(src.indexOf("documentSectionController")>0|| src.indexOf("docModel")>0){
					tmpViewList.window.close();
				setTimeout(function(){
					if(src.indexOf("documentSectionController")>0|| src.indexOf("docModel")>0){
						beforeSrc=src;
						$(frame).attr("src","");
					}
					setTimeout(function(){
						$("#popIframe").empty();	
						$("#popDiv").dialog({
							title:'设置正文标题',
							autoOpen: true,
							modal: true,
							postion:'center',
							height: 250,
							width: 600,
							close:function(event,uri){
								 isAdd ="yes";
								showBeforeSection();
							}
						});	
						$("#popIframe").attr("width","100%");
						$("#popIframe").attr("height","95%");
						$("#popIframe").attr("src","${_baseUrl}/documentList/returnAddTitle?documentId="+documentId); 
						
					},1000);	
				},1000);	
			}else{
				$("#popIframe").empty();	
				$("#popDiv").dialog({
					title:'设置正文标题',
					autoOpen: true,
					modal: true,
					postion:'center',
					height: 250,
					width: 600,
					close:function(event,uri){
						 isAdd ="yes";
						showBeforeSection();
					}
				});	
				$("#popIframe").attr("width","100%");
				$("#popIframe").attr("height","95%");
				$("#popIframe").attr("src","${_baseUrl}/documentList/returnAddTitle?documentId="+documentId); 
			}
		}
		
	}	

	function operation_(e,treeId,treeNode,operation){
		/* if(operation != 'removeNode'){
			var frame = $("#templatelist");
			var src  = $(frame).attr("src");
			if(src.indexOf("documentSectionController/sectionEditPage") >= 0){
				if(tmpViewList.window.saveFile != undefined){
					tmpViewList.window.saveFile();
				}
			}
		} */
		
		if(operation == 'click_1'){
			click_(e,treeId,treeNode);
		}else if(operation == 'click_2'){
			click_(e,treeId,treeNode);
		}else if(operation == 'addNode'){
			addNode(treeId, treeNode);
		}else if(operation == 'removeNode'){
			onRemove(treeId,treeNode);
		}else if(operation == 'editNode'){
			beforeEditName(treeId, treeNode);
		}else if(operation=='alertTitleAndPer'){
			alertTitleAndPer();
			
		}
	}
	
	function editPlan(e,treeId,treeNode,operation){
		if(isAdd !="yes"){
			operation_(e,treeId,treeNode,operation);
			return;
		}
		if(sId != '' && sNumber != '' && status != '3'){
			if("${editPlan}"=='0'){
				$.ajax({
					url:'${_baseUrl}/document/checkIsSave?sectionId='+sId+'&documentId=${documentId}&sNumber='+sNumber,
					type:'post', //数据发送方式 
					dataType:'json', //接受数据格式 
					async: false,
					success: function(data){
						if(data.flag == "success"){
							var frame = $("#templatelist");
							var src  = $(frame).attr("src");
							tmpViewList.window.close();
							setTimeout(function(){
								if(src.indexOf("documentSectionController")>0 || src.indexOf("docModel")>0){
									beforeSrc=src;
									$(frame).attr("src","");
								}
							},1000);
							setTimeout(function(){
								layer.confirm("章节" +sNumber+ " " +data.sectionName+ " 是否已经编写完成?", {
									  btn: ['是','否'] //按钮
									}, function(){
										layer.closeAll('dialog');
										$.ajax({
											url:'${_baseUrl}/document/updateSectionStatus?sectionId='+sId+'&documentId=${documentId}&sNumber='+sNumber,
											type:'post', //数据发送方式 
											dataType:'text', //接受数据格式 
											async: false,
											success: function(data){
												if(operation == 'click_1'){
													sId = '';
													sNumber = '';
												}
												getEditPercentage();
												if(e != null){
													operation_(e,treeId,treeNode,operation);
												}else{
													operation_(null,treeId,treeNode,operation);
												}
												
									        },
											error:function(){
												layer.msg( "系统错误");
											}
										});
									}, function(){
										if(operation == 'click_1'){
											sId = '';
											sNumber = '';
										}
										operation_(e,treeId,treeNode,operation);
									});
								},1000);	
						}else{
							operation_(e,treeId,treeNode,operation);
						}
			        },
					error:function(){
						layer.msg( "系统错误");
					}
				});
			}else{
				operation_(e,treeId,treeNode,operation);
			}
		}else{
			operation_(e,treeId,treeNode,operation);
		}
	}
	function onClick(e,treeId, treeNode) {
		
		saveSectionContent();
		
		// 如果选择的是项目文档名称，则隐藏引用组织资产链接
		var id = treeNode.id;
		if(id == documentId){
			$("#reuseAsset").css('display','none');
		} else {
			$("#reuseAsset").css('display','');
		}
		
		if(parentId !=treeNode.id){
			beforeNodeId =parentId;
		}
		var num = "";
		if(treeNode.sectionNumber != undefined){
			num = treeNode.sectionNumber;
		}
		
		if("${editPlan}" == '0'){
			if(isAdd == "yes"){
				if(treeNode.sectionNumber == undefined){
					editPlan(e,treeId,treeNode,'click_1');
				}else{
					if(sNumber != num){
						editPlan(e,treeId,treeNode,'click_2');
					}else{
						click_(e,treeId,treeNode);
					}
					
				}	
			}
		}else{
			click_(e,treeId,treeNode);
		}
	}


	
	
	function click_(e,treeId, treeNode){		
		
		$("#lock").hide();
		$("#unlock").hide();
		$("#lockName").hide();
		var frame = $("#templatelist");
		var src  = $(frame).attr("src");
		
		if(treeNode.sectionNumber != undefined){
			sId = treeNode.id;
			sNumber = treeNode.sectionNumber;
		}
		sectionId = treeNode.id;
		
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		zTree.expandNode(treeNode);
		if(parentId !=treeNode.id){
			beforeNodeId =parentId;
		}
		parentId =treeNode.id;

		if(treeNode.name=="章节标识设置"){
			if(src.indexOf("documentSectionController")>0 || src.indexOf("docModel")>0){
				beforeSrc=src;
				$(frame).attr("src","");
			}	
			setTimeout(function(){
				$("#popIframe").empty();	
				$("#popDiv").dialog({
					title:'章节标识设置',
					autoOpen: true,
					modal: true,
					postion:'center',
					height: 450,
					width: 620,
					close:function(event,uri){
						showBeforeSection();
					}
				});	
				$("#popIframe").attr("width","100%");
				$("#popIframe").attr("height","95%");
				$("#popIframe").attr("src","${_baseUrl}/documentSectionController/setSectionMarkPage?documentId="+documentId+"&projectId="+projectId+"&pathMark=edit"); 
			},1000);
		}else{
			if(treeNode.name=="需求追踪"){
				
				parent.skipModule("需求追踪","${_baseUrl}"+treeNode.uri+"?documentId="+documentId+"&projectId="+projectId+"&status="+status+"&isOK=${isOk}");
			}else{
				if(treeNode.name=="${documentName}"){
					var uri= treeNode.uri;
					$("#lock").hide();
					$("#unlock").hide();
					$("#lockName").hide();
					if(uri!=null&&uri!=""){
						var path="";
						if(judegEditStatus(treeNode.id)){
							path="${_baseUrl}"+treeNode.uri;
							showOrHidde("open");
						}else{
							path="${_baseUrl}/documentSectionController/getSectionNoEditPage?sectionId="+treeNode.id;
							showOrHidde("close");
						}
						var frame=	$("#templatelist");
						$(frame).attr("src",path);
						
					}
				}else{
					if(treeNode.name=="编写指南"||(treeNode.name=="编写说明")){
					
						var path="";
						path="${_baseUrl}/docModel/editGuide?modelId="+treeNode.id;
						var frame=	$("#templatelist");
						$(frame).attr("src",path);
						showOrHidde("close");
					}else{
						if(treeNode.name=="在线编写"||(treeNode.name=="在线编写")){
							  showOrHidde("close"); 
						}else{
							if(treeNode.name=="历史版本查看"){
								var frame = $("#templatelist");
									path = "${_baseUrl}/document/loadDocumentHistoryVersions_edit?templateId="+templateId+"&projectId="+projectId+"&documentId="+documentId;
								$(frame).attr("src",path);
								showOrHidde("close");
							}else{
								if(treeNode.name=="添加附录"){
									addAppendix();
									showOrHidde("close");
								}else{
									if(treeNode.name=="文档变更记录"){
										var frame = $("#templatelist");
										//判断章节是否可以添加子章节
						    			//getSectionNoEditPage 不可编辑页面，非章节编写人，切换跳转路径
										var path="";							
										path="${_baseUrl}/documentController/checkDocumentChange?documentId="+documentId+"&projectId="+projectId;
										$(frame).attr("src",path);
										showOrHidde("close");
									}else{
										var frame = $("#templatelist");
										//判断章节是否可以添加子章节
						    			//getSectionNoEditPage 不可编辑页面，非章节编写人，切换跳转路径
										var path="";							
										if(judegEditStatus(treeNode.id)){
											//path="${_baseUrl}"+treeNode.uri;
											var locks = false;
											$.ajax({    
												type: "GET",    
												async: false,    
												url:"${_baseUrl}/documentController/getSectionLockPeople?number="+Math.random(),
												data:{
													"sectionId":treeNode.id,
													"documentId":documentId
												},
												dataType:"text",
												success: function (data) {
													if("0" == data){
														path="${_baseUrl}"+treeNode.uri;
														//留锁定按钮
														$("#lock").show();
														$("#unlock").hide();
														$("#lockName").hide();
													}else if("1" == data){
														path="${_baseUrl}"+treeNode.uri;
														$("#lock").hide();
														//留解锁按钮
														$("#unlock").show();
														$("#lockName").hide();
													}else if("2"== data){
														path="${_baseUrl}"+treeNode.uri;
														$("#lock").hide();
														$("#unlock").hide();
														$("#lockName").hide();
													}else{	
														locks = true;
														path="${_baseUrl}/documentSectionController/getSectionNoEditPage?sectionId="+treeNode.id;
														$("#lock").hide();
														$("#unlock").hide();
														$("#lockName").show();
														$("#lockName").html("<label style='font-weight: normal;'>已锁定 ，锁定人<label>:"+data);
														
													}
												},
												error:function(){
													layer.msg("网络异常,请稍后重试");
												}
											})
											
											if(locks){
											
												showOrHidde("close");
											}else{
										
												showOrHidde("open");
											}
											
										}else{
											showOrHidde("close");
											path="${_baseUrl}/documentSectionController/getSectionNoEditPage?sectionId="+treeNode.id;
										}
										$(frame).attr("src",path);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	/* 关闭弹出框 */
	function closeWin(){
		$("#popDiv").dialog('close');
	}
	function closeWins(){
		$("#popDivs").dialog('close');
	}

	//文档发布
	function releaseDoc(){
		//先判断文档在是否存在锁定章节
		var path = "${_baseUrl}/documentSectionController/selectLockSection";
		saveSectionContent();
		saveReplace();
		
		setTimeout(function(){
			$.ajax({
				type:"POST",
				async:false,
				url:path,
				dataType:"json",
				data:{
					"documentId":documentId
				},
				success:function(data){
					if(data.code=='0'){
						$("#popIframe").empty();	
						$("#popDiv").dialog({
							title:'文档发布',
							autoOpen: true,
							modal: true,
							postion:'center',
							height: 450,
							width: 650,      /* 调整弹框显示宽度  */
							close:function(event,uri){
								showBeforeSection();
							}
						});	
						$("#popIframe").attr("width","100%");
						$("#popIframe").attr("height","95%");
						$("#popIframe").attr("src","${_baseUrl}/documentController/documentRelease?documentId="+documentId+"&projectId="+projectId); 
					}else if(data.code=='1'){
						layer.msg("文档存在锁定状态的章节，请确认文档所有章节编写完成且无锁定状态后发布！",{time:2000},function(){
							showBeforeSection();
						});
						
					}else{
						layer.msg("系统错误",{time:2000},function(){
							showBeforeSection();
						});
					
					}
				},
				error:function (){
					layer.msg("系统错误",{time:2000},function(){
						showBeforeSection();
					});
				}
			});
		},1000);	
	}	
	//导出文档
	function exportDoc(){
		saveSectionContent();
		var path = "${_baseUrl}/exportController/exportDocument";
		saveReplace();
		var ifReturn="";
		layer.confirm("是否等待文档生成？ <br>点击  '是'：立即生成文档并查看； <br>   点击  '否'：请返回文档列表页面，点击'文档下载'。", {
			  btn: ['是','否'] //按钮
			}, function(){
				layer.load(2);	
				if(judgeExportSuccess()=='1'){
					window.location.href="${_baseUrl}/exportController/exportDocument?documentId="+documentId+"&projectId="+projectId+"&ifReturn=true";
					setTimeout(function(){
						layer.closeAll('loading');
						layer.closeAll('dialog');
						showBeforeSection();
					},seconds*1000);
				}else{
					layer.closeAll('loading');
					layer.msg("导出文档出错，请查看章节内容。",{offset:['10%','75%']},{shift:2,time:2000});
					showBeforeSection();
				}
				
			}, function(){
				showBeforeSection();
				$.ajax({    
					type: "GET",    
					async: true,    
					url:path,
					data:{
						"documentId":documentId,
						"projectId":projectId,
						"ifReturn":"false"
					},
					dataType:"text",
					success: function () {
						
					},
					error:function(){
						layer.msg("导出文档出错，请查看章节内容。",{offset:['10%','75%']},{shift:2,time:2000});
					}
				});
			});
	}
	//判断文档导出是否会出错
	function judgeExportSuccess(){
		var mins = 0;
		setTimeout(function(){
			mins +=1;
		},1000);
		
		
		var path = "${_baseUrl}/exportController/exportDocument";
		var	result ="";
		$.ajax({    
			type: "GET",    
			async: false,    
			url:path,
			data:{
				"documentId":documentId,
				"projectId":projectId,
				"ifReturn":"judge"
			},
			dataType:"text",
			success: function (data) {
				result =data;
			},
			error:function(data){
				result ="0";
			}
		});
		if(mins==0){
			mins =1;
		}
		seconds+=mins;
		return result;
	}
	
	
	
	//返回文档列表
	function returnProjectList(){
		saveSectionContent(); 
		
		window.location.href="${_baseUrl}/document/showDocumentProjectList";
	}
	//返回项目信息
	function projectInfo(){
		
		saveSectionContent();
		
		if("${isOk}" == 'yes'){
			window.location.href="${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId+"&projectsupervision=yes";
		}else{
			window.location.href="${_baseUrl}/documentList/showProjectAndDocument?projectId="+projectId;
		}
	}
	//文档预发布
	function preReleaseDoc(){
		saveSectionContent();
		
		var path="${_baseUrl}/documentController/preReleaseDoc";
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"documentId":documentId,
				"projectId":projectId
			},
			dataType:"json",    
			success: function (data) {
				if(data.code=='1'){
					setTimeout("getButton();relieve();",100);
					layer.msg(data.message,{offset:['10%','75%']},{shift:2,time:2000});
				}else{
					layer.msg(data.message,{shift:2,time:2000});
				}
			}
		});
		
	}
	// 解除事件绑定
	function relieve(){
		$("#listBox1").unbind("mouseenter",showBox);
		$("#docButton1").unbind("mouseleave",hiddenBox); 
	}
	
	function documentInfo(opeator){
		
		saveSectionContent();
		saveReplace();
		setTimeout(function(){
			$("#popIframe").empty();	
			$("#popDiv").dialog({
				title:'文档基本信息',
				autoOpen: true,
				modal: true,
				postion:'center',
				height: 380,    /* 弹框大小修改  */
				width: 800,
				close:function(event,uri){
					$("#popDiv").dialog("close");
					showBeforeSection();
				}
			});	
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/document/alterDocumentInformationDefinition?documentId="+documentId+"&projectId="+projectId+"&opeator="+opeator);
	
		},1000);
	}

	//跳转到变更申请单界面
	function skipChangeRequestNote(projectId){
		$("#popDiv").dialog("close");
		parent.skipModule("变更分析","${_baseUrl}/ca/showChangeRequestNote?projectId="+projectId+"&documentId="+documentId);
	}


	//打开勘误错误替换界面
	function openReplacePage(projectId){
		//先关闭当前正在弹出的矿口
		$("#popDiv").dialog("close");		
		//弹出替换界面
		setTimeout(function(){
			var frame = $("#templatelist");
			var src  = $(frame).attr("src");
			if(src.indexOf("documentSectionController")>0|| src.indexOf("docModel")>0){
				beforeSrc=src;
				$(frame).attr("src","");
				setTimeout(function(){
					$("#popIframe").empty();
					$("#popDiv").dialog({
						title:'勘误修改',
						autoOpen: true,
						modal: true,
						position:'center',
						height: 500,
						width: 800,
						close:function(event,uri){
							$("#popDiv").dialog("close");
							showBeforeSection();
						}
					});
					$("#popIframe").attr("width","100%");
					$("#popIframe").attr("height","95%");
					$("#popIframe").attr("src","${_baseUrl}/ca/openReplacePage?projectId="+projectId);
				},1000);	
			}else{
				$("#popIframe").empty();
				$("#popDiv").dialog({
					title:'勘误修改',
					autoOpen: true,
					modal: true,
					position:'center',
					height: 500,
					width: 800,
					close:function(event,uri){
						$("#popDiv").dialog("close");
						setTimeout(function(){
						showBeforeSection();
						},1000);
					}
				});
				$("#popIframe").attr("width","100%");
				$("#popIframe").attr("height","95%");
				$("#popIframe").attr("src","${_baseUrl}/ca/openReplacePage?projectId="+projectId);
			}	
		},1000);
	}	

	//勘误错误修改完毕后关闭弹出框并且提示消息
	function alertMessage(){		
		layer.msg("已完成对勾选的项目文档的勘误修改",{shift:5,time:1500});
		$("#popDiv").dialog("close");
	}
	
	/*验证是否可以发起变更  */
	function checkChange(){
		var path ="${_baseUrl}/documentController/checkProDocManager";
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"documentId":documentId,
				"projectId":projectId
			},
			dataType:"json",    
			success: function (data) {
				if(data.code=='1'){
					var frame = $("#templatelist");
					var src  = $(frame).attr("src");
					tmpViewList.window.close();
					if(src.indexOf("documentSectionController")>0 || src.indexOf("docModel")>0){
						beforeSrc=src;
						$(frame).attr("src","");
					}	
					setTimeout(function(){
						$.ajax({
					        type: "post",
					        dataType: "json",
					        url: '${_baseUrl}/ca/checkChangeNote',
					        data: {projectId:projectId},
					        success: function (data) {
					        	if(data.code == "0"){
						        	layer.msg(data.message);
					        	}else{
					        		//验证当前登录人是不是项目负责人
					        		$.ajax({
								        type: "post",
								        dataType: "json",
								        url: '${_baseUrl}/ca/checkisProjectManager',
								        data: {projectId:projectId},
								        success: function (result) {
								        	//非项目负责人
								        	if("1" == result.code){
								        		if("0" == result.message){
								        			layer.msg("无可发起变更的数据");
								        		}else
								        			parent.skipModule("变更分析","${_baseUrl}/ca/showChangeRequestNote?projectId="+projectId);
								        	}else{
								        		$("#popIframe").empty();
								        		$("#popDiv").dialog({
								        			title:'请选择变更内容类型:',
								        			autoOpen: true,
								        			modal: true,
								        			height: 300,
								        			width: 500,
								        			/* 取消弹框出现位置设置 ，默认弹框居中显示   */
								        			
								        		});
								        		$("#popIframe").attr("width","100%");
								        		$("#popIframe").attr("height","95%");
								        		$("#popIframe").attr("src","${_baseUrl}/ca/startChangeMessage?projectId="+projectId+"&documentId="+documentId);
								        	}
								        }
								        
					        		});
					        	}
					        }
					    });	
					},1000);
				}else{
					if(data.code=='2'){
						parent.skipModule("变更分析","${_baseUrl}/ca/showChangeRequestNote?projectId="+projectId+"&documentId="+documentId);
					}else{
						layer.msg(data.message,{shift:2,time:2000});
					}
				}
			}
		});
		
		
		
	}
	
	//文档编写按钮
	function getButton(){
		var path="${_baseUrl}/documentController/getDocEditButton";
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"documentId":documentId,
				"projectId":projectId
			},
			dataType:"json",    
			success: function (data) {
				var li="";
				var li1 = "";
				var li2 = "";
				var initwidth = document.documentElement.clientWidth;
				
				if("${editPlan}" == '0'){
					if(data.data=="changeInflunce"){
						 li+="<li><a href='javascript:;' onclick='changeInflunce(\""+data.token+"\");'>本轮变更影响域</a></li>";
						 li2+="<li><a href='javascript:;' onclick='changeInflunce(\""+data.token+"\");'>本轮变更影响域</a></li>";
					}
					if(data.message=="returnDocListAndPreRelease"){    /* 变更后返回页面  */
						if(initwidth >1280){
							$("#docButton").css("display","block");
							$("#listBox1").css("display","block"); 
							$("#docButton1").css("display","none");
						}else{
							$("#docButton").css("display","none");
							$("#listBox1").css("display","block");
							$("#docButton1").css("display","none");
						}
						li +='<li><a href="javascript:;" class="qxsz_on" onclick="promptPlan(\'exportDoc\');">导出文档</a></li>';
						li +='<li><a href="javascript:;" onclick="promptPlan(\'releaseDoc\');">发布</a></li>';
						li2 +='<li><a href="javascript:;" class="qxsz_on" onclick="promptPlan(\'exportDoc\');">导出文档</a></li>';
						li2 +='<li><a href="javascript:;" onclick="promptPlan(\'releaseDoc\');">发布</a></li>';
						li1 +='<li><a href="javascript:;" onclick="preReleaseDoc();">预发布</a></li>';
						li1 +='<li><a href="javascript:;" onclick="promptPlan(\'projectInfo\');">返回文档列表</a></li>';
	                    
					}
					if(data.message=="returnDocListAndrelease"){     /* 变更后返回页面-预发布后显示按钮  */
						if(initwidth >1280){ 
							$("#docButton").css("display","block");
							$("#listBox1").css("display","none"); 
							$("#listBox2").css("display","none");
							$("#docButton1").css("display","none");
						}else{
							$("#docButton").css("display","none");
							$("#listBox1").css("display","block"); 
							$("#listBox2").css("display","block");
							$("#docButton1").css("display","none");
						} 
						li +='<li><a href="javascript:;" class="qxsz_on" onclick="promptPlan(\'exportDoc\');">导出文档</a></li>';
						li +='<li><a href="javascript:;" onclick="promptPlan(\'releaseDoc\');">发布</a></li>';
						li +='<li><a href="javascript:;" onclick="promptPlan(\'projectInfo\');">返回文档列表</a></li>';
						li2 +='<li><a href="javascript:;" class="qxsz_on" onclick="promptPlan(\'exportDoc\');">导出文档</a></li>';
						li2 +='<li><a href="javascript:;" onclick="promptPlan(\'releaseDoc\');">发布</a></li>';
						li2 +='<li><a href="javascript:;" onclick="promptPlan(\'projectInfo\');">返回文档列表</a></li>';
					}
					if(data.message=="returnDocListAndChange"){
						li +='<li><a href="javascript:;" class="qxsz_on" onclick="promptPlan(\'exportDoc\');">导出文档</a></li>';
						li +='<li><a href="javascript:;" onclick="checkChange();">文档变更</a></li>';
						li +='<li><a href="javascript:;" onclick="promptPlan(\'projectInfo\');">返回文档列表</a></li>';
						li2 +='<li><a href="javascript:;" class="qxsz_on" onclick="promptPlan(\'exportDoc\');">导出文档</a></li>';
						li2 +='<li><a href="javascript:;" onclick="checkChange();">文档变更</a></li>';
						li2 +='<li><a href="javascript:;" onclick="promptPlan(\'projectInfo\');">返回文档列表</a></li>';
					}
					if(data.message=="returnDocList"){
						li +='<li><a href="javascript:;" class="qxsz_on" onclick="promptPlan(\'exportDoc\');">导出文档</a></li>';
						li +='<li><a href="javascript:;" onclick="promptPlan(\'projectInfo\');">返回文档列表</a></li>';
						li2 +='<li><a href="javascript:;" class="qxsz_on" onclick="promptPlan(\'exportDoc\');">导出文档</a></li>';
						li2 +='<li><a href="javascript:;" onclick="promptPlan(\'projectInfo\');">返回文档列表</a></li>';
					}
					li +='<div class="clear"></div>';
					$("#docButton").html(li);
					if(initwidth >1280){
						$("#docButton1").html(li1);
					}else{
						$("#docButton1").html(li2+li1);
					}
				}else{
					if(data.data=="changeInflunce"){
						 li +="<li><a href='javascript:;' onclick='changeInflunce(\""+data.token+"\");'>本轮变更影响域</a></li>";
						 li2 +="<li><a href='javascript:;' onclick='changeInflunce(\""+data.token+"\");'>本轮变更影响域</a></li>";
					}
					if(data.message=="returnDocListAndPreRelease"){   /* 变更后返回页面  */
						if(initwidth >1280){
							$("#docButton").css("display","block");
							$("#listBox1").css("display","block"); 
							$("#docButton1").css("display","none");
						}else{
							$("#docButton").css("display","none");
							$("#docButton1").css("display","none");
							$("#listBox1").css("display","block");
						}
						li +='<li><a href="javascript:;" class="qxsz_on" onclick="exportDoc();">导出文档</a></li>';
						li +='<li><a href="javascript:;" onclick="releaseDoc();">发布</a></li>';
						li2 +='<li><a href="javascript:;" class="qxsz_on" onclick="exportDoc();">导出文档</a></li>';
						li2 +='<li><a href="javascript:;" onclick="releaseDoc();">发布</a></li>';
						li1 +='<li><a href="javascript:;" onclick="preReleaseDoc();">预发布</a></li>';
						li1 +='<li><a href="javascript:;" onclick="projectInfo();">返回文档列表</a></li>';
	                    
					}
					if(data.message=="returnDocListAndrelease"){  /* 变更后返回页面-预发布后显示按钮  */
						if(initwidth >1280){ 
							$("#docButton").css("display","block");
							$("#listBox1").css("display","none"); 
							$("#listBox2").css("display","none");
							$("#docButton1").css("display","none");
						}else{
							$("#docButton").css("display","none");
							$("#listBox1").css("display","block"); 
							$("#listBox2").css("display","block");
							$("#docButton1").css("display","none");
						} 
						
						li+='<li><a href="javascript:;" class="qxsz_on" onclick="exportDoc();">导出文档</a></li>';
						li+='<li><a href="javascript:;" onclick="releaseDoc();">发布</a></li>';
						li+='<li><a href="javascript:;" onclick="projectInfo();">返回文档列表</a></li>';
						li2+='<li><a href="javascript:;" class="qxsz_on" onclick="exportDoc();">导出文档</a></li>';
						li2+='<li><a href="javascript:;" onclick="releaseDoc();">发布</a></li>';
						li2+='<li><a href="javascript:;" onclick="projectInfo();">返回文档列表</a></li>';
					}
					if(data.message=="returnDocListAndChange"){
						li+='<li><a href="javascript:;" class="qxsz_on" onclick="exportDoc();">导出文档</a></li>';
						li+='<li><a href="javascript:;" onclick="projectInfo();">返回文档列表</a></li>';
						li+='<li><a href="javascript:;" onclick="checkChange();">文档变更</a></li>';
						li2+='<li><a href="javascript:;" class="qxsz_on" onclick="exportDoc();">导出文档</a></li>';
						li2+='<li><a href="javascript:;" onclick="projectInfo();">返回文档列表</a></li>';
						li2+='<li><a href="javascript:;" onclick="checkChange();">文档变更</a></li>';
					}
					if(data.message=="returnDocList"){
						li+='<li><a href="javascript:;" class="qxsz_on" onclick="exportDoc();">导出文档</a></li>';
						li+='<li><a href="javascript:;" onclick="projectInfo();">返回文档列表</a></li>';
						li2+='<li><a href="javascript:;" class="qxsz_on" onclick="exportDoc();">导出文档</a></li>';
						li2+='<li><a href="javascript:;" onclick="projectInfo();">返回文档列表</a></li>';
					}
					li+='<div class="clear"></div>';
					$("#docButton").html(li);
					if(initwidth >1280){
						$("#docButton1").html(li1);
					}else{
						$("#docButton1").html(li2+li1);
					}
				}
				
			}   
		}); 	
	}
	
	
	//变更影响域分析查看
	function changeInflunce(changeId){
		/* 验证变更影响域分析 是否可以跳转 */
		
		saveSectionContent();
		saveReplace();
		
		setTimeout(function(){
			$("#popIframe").empty();
			$("#popDiv").dialog({
				title:'本轮变更影响域',
				autoOpen: true,
				modal: true,
				position:'center',
				height: 600,
				width: 1066,
				close:function(event,uri){
					showBeforeSection();
				}
			});
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/ci/showChangeInfluence?projectId="+projectId+"&changeId="+changeId+"&readOnly=1");
		},1000);	
	}
	
	
	//判断是否可以添加章节
	function judgeAddSection (treeId, treeNode){
		var result =false;
		if(operator.length>0){
			$.each(operator, function (i, item) {
				if(treeNode.id==item.id){
					if(item.ifadd =="true"||item.ifadd==true){
						result =true;
					}
				}
		 	});
		}		
		return result;
	}
	

	
	//添加章节
	function addSection(nodeId,pId){
		setTimeout(function(){
			saveReplace();
			
			var name = "";
			ztree =$.fn.zTree.init($("#treeDemo"), setting, zNodes);    
			if(ztree.getNodeByParam("id",nodeId,null) == null){
				name = sectionName;
			}else{
				 name  =ztree.getNodeByParam("id",nodeId,null).name;
			}
			if(name.indexOf("附录-附件")>=0){
				setTimeout(function(){
					$("#popDiv").dialog({
						title:'添加章节',
						autoOpen: true,
						modal: true,
						postion:'center',
						height: 300,
						width: 600,
						close:function(event,uri){
							showBeforeSection();
						}
					});	
					$("#popIframe").attr("width","100%");
					$("#popIframe").attr("height","95%");
					$("#popIframe").attr("src","${_baseUrl}/documentSectionController/addSectionInfo?documentId="+documentId+"&parentId="+parentId+"&projectId="+projectId+"&addType=sonNode&nodeId="+nodeId); 
				},1000);
			}else{
				setTimeout(function(){
					layer.open({
						content: '请选择您要添加的节点类型'
						,btn: ['同级节点', '子章节']
						,yes: function(index, layero){
						    //按钮【按钮一】的回调
							layer.closeAll('dialog');
			    			parentId =pId;
			    			$("#popIframe").empty();	
							$("#popDiv").dialog({
								title:'添加章节',
								autoOpen: true,
								modal: true,
								postion:'center',
								height: 300,
								width: 600,
								close:function(event,uri){
									showBeforeSection();
								}
							});	
							$("#popIframe").attr("width","100%");
							$("#popIframe").attr("height","95%");
							$("#popIframe").attr("src","${_baseUrl}/documentSectionController/addSectionInfo?documentId="+documentId+"&parentId="+parentId+"&projectId="+projectId+"&addType=visNode&nodeId="+nodeId);
						    
						}
						,btn2: function(index, layero){
							//按钮【按钮二】的回调
							$("#popIframe").empty();	
							$("#popDiv").dialog({
								title:'添加章节',
								autoOpen: true,
								modal: true,
								postion:'center',
								height: 300,
								width: 600,
								close:function(event,uri){
									showBeforeSection();
								}
							});	
							$("#popIframe").attr("width","100%");
							$("#popIframe").attr("height","95%");
							$("#popIframe").attr("src","${_baseUrl}/documentSectionController/addSectionInfo?documentId="+documentId+"&parentId="+parentId+"&projectId="+projectId+"&addType=sonNode&nodeId="+nodeId);
						}
						,cancel: function(){ 
							   //右上角关闭回调
							showBeforeSection();   
						}
					});
				},1000);
			}
		}, 1000);
	}
	
	//添加章节
	function addSonSection(nodeId,pId){
		setTimeout(function(){
			saveReplace();
			
			setTimeout(function(){
				$("#popDiv").dialog({
					title:'添加章节',
					autoOpen: true,
					modal: true,
					postion:'center',
					height: 300,
					width: 600,
					close:function(event,uri){
						showBeforeSection();
					}
				});	
				$("#popIframe").attr("width","100%");
				$("#popIframe").attr("height","95%");
				$("#popIframe").attr("src","${_baseUrl}/documentSectionController/addSectionInfo?documentId="+documentId+"&parentId="+parentId+"&projectId="+projectId+"&addType=visNode&nodeId="+nodeId); 
			},1000);
		}, 1000);
	}
	
	//添加附录
	function addAppendix(){
		setTimeout(function(){
			saveReplace();
			
			var path="${_baseUrl}/documentController/judgeAddAppendix";
			
			$.ajax({    
				type: "POST",    
				async: false,    
				url:path,
				data:{
					"documentId":documentId,
					"projectId":projectId
				},
				dataType:"json",    
				success: function (data) {				
					if(data.code=='1'){					
						setTimeout(function(){
							$("#popIframe").empty();	
							$("#popDiv").dialog({
								title:'添加附录',
								autoOpen: true,
								modal: true,
								postion:'center',
								height: 250,
								width: 314,
								close:function(event,uri){
									showBeforeSection();
								}
							});	
							$("#popIframe").attr("width","100%");
							$("#popIframe").attr("height","95%");
							$("#popIframe").attr("src","${_baseUrl}/documentSectionController/addAppendix?documentId="+documentId+"&parentId="+documentId+"&projectId="+projectId); 
						},1000);
					}else{
						layer.msg(data.message,{shift:2,time:2000},function(){
							showSection();
						});
					}
				}
			});
		}, 1000);
	}
	
	//添加树节点
	function addChildNode(data,jsonTree){
		getEditPercentage();
		operator =eval(data);
		var json = eval(jsonTree);
		var ztree = $.fn.zTree.getZTreeObj("treeDemo");
		ztree.expandNode(ztree.getNodeByParam("id",json[0].parentId,null));//展开指定节点
		for(var i =0;i<json.length;i++){
			if(json[i].sectionNumber!=null&&json[i].sectionNumber!=""&&json[i].sectionNumber!="null"){
				ztree.addNodes(ztree.getNodeByParam("id",(json[i].parentId=="-1"?documentId:json[i].parentId),null), {id:json[i].id, pId:(json[i].parentId=="-1"?documentId:json[i].parentId),sectionNumber:json[i].sectionNumber,name:json[i].sectionNumber+json[i].sectionName,uri:json[i].uri});
			}else{
				ztree.addNodes(ztree.getNodeByParam("id",(json[i].parentId=="-1"?documentId:json[i].parentId),null), {id:json[i].id, pId:(json[i].parentId=="-1"?documentId:json[i].parentId),sectionNumber:json[i].sectionNumber,name:json[i].sectionName,uri:json[i].uri});
			}
		}
		ztree.selectNode(ztree.getNodeByParam("id",json[0].id,null));//选中指定节点
		sectionName = json[0].sectionName;
		if(json[0].sectionNumber != undefined){
			sId = json[0].id;
			sNumber = json[0].sectionNumber;
		}
		
		$.ajax({    
			type: "GET",    
			async: false,    
			url:"${_baseUrl}/documentController/getSectionLockPeople?number="+Math.random(),
			data:{
				"sectionId":json[0].id,
				"documentId":documentId
			},
			dataType:"text",
			success: function (data) {
				if("0" == data){
					//留锁定按钮
					$("#lock").show();
					$("#unlock").hide();
					$("#lockName").hide();
				}else if("1" == data){
					$("#lock").hide();
					//留解锁按钮
					$("#unlock").show();
					$("#lockName").hide();
				}else if("2"== data){
					$("#lock").hide();
					$("#unlock").hide();
					$("#lockName").hide();
				}else{
					$("#lock").hide();
					$("#unlock").hide();
					$("#lockName").show();
					$("#lockName").html("<label style='font-weight: normal;'>已锁定 ，锁定人<label>:"+data);
					
				}
			},
			error:function(){
				layer.msg("网络异常,请稍后重试");
			}
		})
		
		parentId = json[0].id;
		path="${_baseUrl}"+json[0].uri;
		showOrHidde("open");
		replaceRefer();
		var frame = $("#templatelist");
		$(frame).attr("src",path);
	}
	
	
	function beforeDrag(treeId, treeNodes) {
		return false;
	}
	
	function beforeEditName(treeId, treeNode) {
		setTimeout(function(){
			saveReplace();
			var frame = $("#templatelist");
			setTimeout(function(){
				$("#popIframe").empty();	
				$("#popDiv").dialog({
					title:'修改章节信息',
					autoOpen: true,
					modal: true,
					postion:'center',
					height: 300,
					width: 600,
					close:function(event,uri){
						var path="${_baseUrl}"+treeNode.uri;
						$(frame).attr("src",path);
						isAdd ="yes";
					}
				});	
				$("#popIframe").attr("width","100%");
				$("#popIframe").attr("height","95%");
				$("#popIframe").attr("src","${_baseUrl}/sectionController/alterSection?sectionId="+treeNode.id);
			}, 1000);
		}, 1000);
		
	}		
	function beforeRemove(e,treeId,treeNode){  
        return  confirm("你确定要删除吗？");  
    }  
    function onRemove(treeId,treeNode){ 
    	setTimeout(function(){
    		saveReplace();
			
			setTimeout(function(){
	    	layer.confirm("你确定要删除当前节点吗？",{
	    		btn:['是','否']},
	    		function (){
	    			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
	    	        if(treeNode.isParent){  
	    	            var childNodes = zTree.removeChildNodes(treeNode);  
	    	            var paramsArray = new Array();  
	    	            for(var i = 0; i < childNodes.length; i++){  
	    	                paramsArray.push(childNodes[i].id);  
	    	            }  
	    	        } 
	    	        var path = "${_baseUrl}/documentSectionController/delSection" ;
	    	        $.ajax({    
	    				type: "POST",    
	    				async: false,    
	    				url:path,
	    				data:{
	    					"sectionId":treeNode.id,
	    					"documentId":documentId,
	    					"projectId":projectId
	    				},
	    				dataType:"json",    
	    				success: function (json) {
	    					if(json.code=='1'){
	    						isAdd ="yes";
	    						getEditPercentage();
	    						layer.msg(json.message,{shift:5,time:1500},function(){
	    							zNodes = eval(json.data);
	    							sId = '';
	    							sNumber = '';
		    						if(treeNode.pId==documentId){
		    							ztree =$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		    							ztree.selectNode(ztree.getNodeByParam("id",json.token,null));//选中指定节点
		    							ztree.setting.callback.onClick(null, ztree.setting.treeId, ztree.getNodeByParam("id",json.token,null));//触发函数
		    							replaceRefer();
		    						}else{
		    							ztree =$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		    							ztree.selectNode(ztree.getNodeByParam("id",treeNode.pId,null));//选中指定节点
		    							ztree.setting.callback.onClick(null, ztree.setting.treeId, ztree.getNodeByParam("id",treeNode.pId,null));//触发函数
		    							replaceRefer();	
		    						}
	    						});
	    						
	    					}else{
	    						layer.msg("系统错误");
	    					}
	    				}
	    			})
	    		},function(){
	    			layer.closeAll('dialog');
	    			isAdd ="yes";
	    			showBeforeSection();
	    		}	
	    	)},1000);
		},1000);
    	
    }  
    
    
    
    function refreshTree(znode,nodeId,opeator){
    
    	parentId = nodeId;
    	getEditPercentage();
    	operator =eval(opeator);
    	zNodes = eval(znode);
		ztree =$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		ztree.selectNode(ztree.getNodeByParam("id",nodeId,null));//选中指定节点
		var path="${_baseUrl}/documentSectionController/sectionEditPage?projectId="+projectId+"&documentId="+documentId+"&sectionId="+nodeId;
		showOrHidde("open");
		
		var nodeNumber  =ztree.getNodeByParam("id",nodeId,null).sectionNumber;
		if(nodeNumber != undefined){
			sId = nodeId;
			sNumber = nodeNumber;
		}
		
		$.ajax({    
			type: "GET",    
			async: false,    
			url:"${_baseUrl}/documentController/getSectionLockPeople?number="+Math.random(),
			data:{
				"sectionId":nodeId,
				"documentId":documentId
			},
			dataType:"text",
			success: function (data) {
				if("0" == data){
					//留锁定按钮
					$("#lock").show();
					$("#unlock").hide();
					$("#lockName").hide();
				}else if("1" == data){
					$("#lock").hide();
					//留解锁按钮
					$("#unlock").show();
					$("#lockName").hide();
				}else if("2"== data){
					$("#lock").hide();
					$("#unlock").hide();
					$("#lockName").hide();
				}else{
					$("#lock").hide();
					$("#unlock").hide();
					$("#lockName").show();
					$("#lockName").html("<label style='font-weight: normal;'>已锁定 ，锁定人<label>:"+data);
					
				}
			},
			error:function(){
				layer.msg("网络异常,请稍后重试");
			}
		})
		
		var frame = $("#templatelist");
		$(frame).attr("src",path);
		replaceRefer();
    }
    

    
	//判断是否可以删除章节
	function judgeDelSection (treeId, treeNode){
		var result =false;
		if(operator.length>0){
			$.each(operator, function (i, item) {
				if(treeNode.id==item.id){
					if(item.ifadd=="true"||item.ifadd==true){
						result =true;
					}
				}
		 	});
		}
		 if(judegEditStatus(treeNode.id)){
	       	if(treeNode.name.indexOf("附录")>0){
	       		result =true;
	       	}
	    }  
		return result;
	}
    
    
    function removeHoverDom(treeId,treeNode){  
        $("#addBtn_"+treeNode.tId).unbind().remove();  
    }   
    
	//判断是否可以编辑
    function judegEditStatus(sectionId){
    	 var tus =false;
    	 if(operator.length>0){
 			$.each(operator, function (i, item) {
 				if(sectionId==item.id){
 					if(item.ifEdit=="true"||item.ifEdit==true){
 						tus =true;
 					}
 				}
 		 	});
 		}	
 		return tus ;
    }
  //获取当前展示路径，判断是否为文档编辑控件
    function showBeforeSection(){
	 
    	var frame = $("#templatelist");
    	if($(frame).attr("src")==""){
    		if(beforeSrc!=""){
        		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        		zTree.expandNode(ztree.getNodeByParam("id",parentId,null));//展开指定节点
        		zTree.selectNode(zTree.getNodeByParam("id",parentId,null));//选中指定节点
        		$(frame).attr("src",beforeSrc);
        	}
    	}
    }
  
    //获取当前展示路径，判断是否为文档编辑控件
    function showSection(){
    	var frame = $("#templatelist");
    	if($(frame).attr("src")==""){
    		if(beforeSrc!=""){
        		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        		zTree.expandNode(zTree.getNodeByParam("id",beforeNodeId,null));//展开指定节点
        		zTree.selectNode(zTree.getNodeByParam("id",beforeNodeId,null));//选中指定节点
        		$(frame).attr("src",beforeSrc);
        	}
    	}
    }
    
    /*编制进度管理  */
    function loadEditPlan(id,projectId){
		saveSectionContent();
    	saveReplace();
		setTimeout(function(){
			$("#popIframe").empty();	
			$("#popDiv").dialog({
				title:'编写进度',
				autoOpen: true,
				modal: true,	
				height: 550,
				width: 800,
				close:function(event,uri){
					showBeforeSection();
				}
			});	
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/document/loadEditPlanPage?documentId="+id+"&projectId="+projectId);
		},1000);
	}
    
    function showAllDocument(id,projectId){
    	//var frame = $("#templatelist");
		//var src  = $(frame).attr("src");
		
    	saveReplace();
		setTimeout(function(){
			$("#popIframe").empty();	
			$("#popDiv").dialog({
				title:'全文预览',
				autoOpen: true,
				modal: true,	
				height: document.documentElement.clientHeight-100,  //兼容ie8浏览器
				width: document.documentElement.clientWidth-500,
				close:function(event,uri){
					showBeforeSection();
				}
			});	
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/document/showAllDocument?documentId="+id+"&projectId="+projectId);
		},1000);
	}
    
    /* 引用组织资产 */
    function openOrangize(){
    	saveSectionContent();
    	saveReplace();
		setTimeout(function(){
			$.ajax({
				url:'${_baseUrl}/jurisdiction/judgeOrganize',
				type:'post', //数据发送方式 
				dataType:'json', //接受数据格式 
				async: false,
				success: function(data){
					if(data.code=="1"){
						$("#popIframe").empty();	
						$("#popDiv").dialog({
							
							title:'引用组织资产',
							autoOpen: true,
							modal: true,	
							height: 570,
							width: 800,
							close:function(event,uri){
								showBeforeSection();
							}
						});	
						$("#popIframe").attr("width","100%");
						$("#popIframe").attr("height","95%");
						$("#popIframe").attr("src","${_baseUrl}/jurisdiction/organize?sectionId="+parentId+"&source=documentEdit&setPageSize=50");
					}else{
						layer.msg("您没有'组织资产'菜单的浏览权限，请联系系统管理员开通",{time:2000},function(){
							showBeforeSection();
						});
					}
		        },
				error:function(){
					layer.msg( "系统错误");
				}
			});
		},1000);
	}

    function operate(operation){
    	if(operation == 'projectInfo'){
			projectInfo();
		}else if(operation == 'returnProjectList'){
			returnProjectList();
		}else if(operation == 'releaseDoc'){
			releaseDoc();
		}else if(operation == 'exportDoc'){
			exportDoc();
		}else if(operation == 'check'){
			documentInfo('check');
		}else if(operation == 'alter'){
			documentInfo('alter');
		}
    }
    function promptPlan(operation){
    	
    	saveSectionContent();
		
    	if(sId != '' && sNumber != '' && status != '3'){
			$.ajax({
				url:'${_baseUrl}/document/checkIsSave?sectionId='+sId+'&documentId=${documentId}&sNumber='+sNumber,
				type:'post', //数据发送方式 
				dataType:'json', //接受数据格式 
				async: false,
				success: function(data){
					if(data.flag == "success"){
						var frame = $("#templatelist");
						var src  = $(frame).attr("src");
						if(src.indexOf("documentSectionController")>0 || src.indexOf("docModel")>0){
							beforeSrc=src;
							$(frame).attr("src","");
						}
						
						layer.confirm("章节" +sNumber+ " " +data.sectionName+ " 是否已经编写完成?", {
							  btn: ['是','否'] //按钮
							}, function(){
								layer.closeAll('dialog');
								$.ajax({
									url:'${_baseUrl}/document/updateSectionStatus?sectionId='+sId+'&documentId=${documentId}&sNumber='+sNumber,
									type:'post', //数据发送方式 
									dataType:'text', //接受数据格式 
									async: false,
									success: function(data){
										sId = '';
										sNumber = '';
										getEditPercentage();
										operate(operation);
							        },
									error:function(){
										layer.msg( "系统错误");
									}
								});
							}, function(){
								sId = '';
								sNumber = '';
								layer.closeAll('dialog');
								operate(operation);
							});
					}else{
						operate(operation);
					}
		        },
				error:function(){
					layer.msg( "系统错误");
				}
			});
		}else{
			operate(operation);
		}
    }

    
    function showOrHidde(mark){
    	if(mark=="open"){
    		
    		if(status!='3'){    		
    			$("#organize").css("display","block");
    			//$("#organizeBox").css("display","inline-block");
    		}
    	}else{
    		$("#organize").css("display","none");
    		//$("#organizeBox").css("display","none");
    	}
    }
    
  	//获取字符串长度
    var GetLength = function (str) {
        ///<summary>获得字符串实际长度，中文2，英文1</summary>
        ///<param name="str">要获得长度的字符串</param>
        var realLength = 0, len = str.length, charCode = -1;
        for (var i = 0; i < len; i++) {
            charCode = str.charCodeAt(i);
            if (charCode >= 0 && charCode <= 128) realLength += 1;
            else realLength += 2;
        }
        return realLength;
    };
    
    function cutstr(str, len) {
        var str_length = 0;
        var str_len = 0;
        str_cut = new String();
        str_len = str.length;
        for (var i = 0; i < str_len; i++) {
            a = str.charAt(i);
            str_length++;
            if (escape(a).length > 4) {
                //中文字符的长度经编码之后大于4  
                str_length++;
            }
            str_cut = str_cut.concat(a);
            if (str_length >= len) {
                str_cut = str_cut.concat("...");
                return str_cut;
            }
        }
        //如果给定字符串小于指定长度，则返回源字符串；  
        if (str_length < len) {
            return str;
        }
    }
    
    $(function (){
    	
    	//projectInfo_val  项目地址判断
    	var projectInfo_val = "";
    	if(GetLength("${projectInfo}") > 35){
    		projectInfo_val = cutstr("${projectInfo}",35);
    	}else{
    		projectInfo_val = "${projectInfo}";
    	}
    	$("#projectInfo_val").html(projectInfo_val);
    	
    	//锁定
    	$("#lock").click(function (){
    		$.ajax({
				url:'${_baseUrl}/documentController/lockSection?sectionId='+sectionId+"&number="+Math.random(),
				type:'post', //数据发送方式 
				dataType:'text', //接受数据格式 
				async: false,
				success: function(data){
					if("success" == data){
						$("#lock").hide();
			    		$("#unlock").show();
					}
		        },
				error:function(){
					layer.msg( "系统错误");
				}
			});
    	});
    	
    	//解锁
    	$("#unlock").click(function (){
    		$.ajax({
				url:'${_baseUrl}/documentController/unLockSection?sectionId='+sectionId,
				type:'post', //数据发送方式 
				dataType:'text', //接受数据格式 
				async: false,
				success: function(data){
					if("success" == data){
						$("#lock").show();
			    		$("#unlock").hide();
			    		$("#lockName").hide();
					}
		        },
				error:function(){
					layer.msg( "系统错误");
				}
			});
    	});
    });
    
    //导入excl数据
    function importExcl(){
    	saveSectionContent();
    	saveReplace();
    	setTimeout(function(){
			$("#popIframe").empty();	
			$("#popDiv").dialog({
				title:'导入数据',
				autoOpen: true,
				modal: true,	
				height: 320,    /* 修改导入数据弹框显示高度  */
				width:650 ,    /* 修改导入数据弹框显示宽度  */
				//关闭窗口回调
				close:function(event,uri){
					showBeforeSection();
				} 
			});	
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","95%");
			$("#popIframe").attr("src","${_baseUrl}/dic/showUploadExclPage?documentId="+documentId);
    	},1000);
    }
    

 
    function importDataRefruseTree(){
    
    	$.ajax({
			url:'${_baseUrl}/documentSectionController/importDataRefruseTree',
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			data:{"documentId":documentId,"projectId":projectId},
			success: function(data){
				parentId = data.token;
		    	getEditPercentage();
		    	operator =eval(data.data);
		    	zNodes = eval(data.message);
				ztree =$.fn.zTree.init($("#treeDemo"), setting, zNodes);
				ztree.selectNode(ztree.getNodeByParam("id",data.token,null));//选中指定节点
				var path="${_baseUrl}/documentSectionController/sectionEditPage?projectId="+projectId+"&documentId="+documentId+"&sectionId="+data.token;
				showOrHidde("open");
				var frame = $("#templatelist");
				$(frame).attr("src",path);
				replaceRefer();
	        },
			error:function(){
				layer.msg( "系统错误");
			}
		});
    }
    
    
    function saveReplace(){
    	var frame = $("#templatelist");
		var src  = $(frame).attr("src");
		tmpViewList.window.close();
		if(src.indexOf("documentSectionController")>0 || src.indexOf("docModel")>0){
			beforeSrc=src;
			$(frame).attr("src","");
		}	
    }
    function addPreface(documentId,projectId){
    	var path="${_baseUrl}/documentController/judgeAddPreface";
		
		$.ajax({    
			type: "POST",    
			async: false,    
			url:path,
			data:{
				"documentId":documentId,
				"projectId":projectId
			},
			dataType:"json",    
			success: function (data) {				
				if(data.code=='1'){			
    	      setTimeout(function(){
    	    	  $.ajax({    
    	  			type: "POST",    
    	  			async: false,    
    	  			url:"${_baseUrl}/documentSectionController/saveChangeSections",
    	  			data:{
    	  				"documentId":documentId,
    	  				"projectId":projectId,
    	  				"parentId":parentId,
    	  				"sectionName":"前言"
    	  			},
    	  			dataType:"json",    
    	  			success: function (json) {				
    	  					layer.msg( "添加成功");
    	  					refreshTree(json.message,json.token,json.data);
    	  				},
    	  			error:function (){
    	  				layer.msg( "添加失败");
    	  				}
    	  			});
    	    	  isAdd ="yes";
    	    	  showBeforeSection();
    	    	  
			/* $("#popIframe").empty();
			$("#popDiv").dialog({
				title:'添加前言',
				autoOpen: true,
				modal: true,
				position:'center',
				height: 260,
				width: 300,
				close:function(event,uri){
					
				}
			});
			$("#popIframe").attr("width","100%");
			$("#popIframe").attr("height","100%");
			$("#popIframe").attr("src","${_baseUrl}/documentSectionController/addPreface?documentId="+documentId+"&parentId="+documentId+"&projectId="+projectId+""); */
		},1000);
				}else{
					layer.msg(data.message,{shift:2,time:2000},function(){
						 isAdd ="yes";
						 showBeforeSection();
					});
				}
				}
			});
    //location.href="${_baseUrl}/documentSectionController/addPreface?documentId="+documentId+"&parentId="+documentId+"&projectId="+projectId;
    }
    
    
    /* 保存右侧章节内容 TODO */ 
    function saveSectionContent(){
    	var frame = $("#templatelist");
		var src  = $(frame).attr("src");
		//每点一次触发保存一次
		if(src.indexOf("documentSectionController/sectionEditPage") >= 0){
			if(tmpViewList.window.saveFile != undefined){
				tmpViewList.window.saveFile();
			}
		}
    }
    
</script>

<script type="text/javascript">
	window.onload = function(){
		var obj = $("[style ^= 'color: rgb(255, 0, 0);']")||$("[style ^= 'color: red;']");
		if(navigator.userAgent.indexOf("MSIE")>0 ) { // IE浏览器
			getObj();
			for(var i = 0; i<$("a.curSelectedNode1 span").length; i++){
				$("a.curSelectedNode1 span")[i].style.color = "red";
			}
		}else{
			obj.addClass("curSelectedNode1");
			obj.removeClass("curSelectedNode"); 
			$(".ztree .level_0 a.curSelectedNode1 span").css("color","red"); 
		}
		
		$("a").click(function(){
			var obj = $("[style ^= 'color: rgb(255, 0, 0);']")||$("[style ^= 'color: red;']");
			if(navigator.userAgent.indexOf("MSIE")>0 ) { // IE浏览器
				getObj();
				for(var i = 0; i<$("a.curSelectedNode1 span").length; i++){
					$("a.curSelectedNode1 span")[i].style.color = "red";
				}
			}else{
				obj.addClass("curSelectedNode1");
				obj.removeClass("curSelectedNode"); 
				$(".ztree .level_0 a.curSelectedNode1 span").css("color","red"); 
			}
		});
		
		initHeight(); 
		getButton();  /* 文档变更  */
		pullDownMenu();
		
		$("#projectInfo_val").html(subProjectName("${projectInfo }"));
		$("#documentInfo_val").html(subProjectName("${proTempName}"));
	};
	var  resizeTimer = null;
	window.onresize = function(){
	    if(resizeTimer) clearTimeout(resizeTimer);
	    resizeTimer = setTimeout("initHeight(),pullDownMenu(),getButton()",100);
	 };
	function getObj(){
		var oA = document.getElementsByTagName("a");
		var aEle=[];
		for(var i=0; i< oA.length; i++){
			if(oA[i].style.color == "rgb(255,0,0)" || oA[i].style.color == "red" ){
				oA[i].className +=" "+"curSelectedNode1";
			}
		}
	}
	function initHeight(){
		var topH = 20; 
		if(navigator.userAgent.indexOf("MSIE")>0) {//IE浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("like Gecko")>0) {//IE11浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Firefox")>0){//Firefox浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Opera")>0){//Opera浏览器
			initheight = document.body.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Chrome")>0){//Chrome谷歌浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		if(navigator.userAgent.indexOf("Safari")>0){//Safari浏览器
			initheight = document.documentElement.clientHeight-topH;
		}
		document.getElementById("zTreeDemo").style.height = initheight+"px";
	}
	
	// 内容缺省显示
	function subProjectName(name){
		if(name.length > 13){
			name = name.substring(0,15);
			name += "...";
		}
		return name;
	}
	
	// 下拉菜单响应式布局
	 function pullDownMenu(){
		$("#listBox1").mouseenter(showBox);      // 移入事件
		$("#docButton1").mouseleave(hiddenBox);
	}
	//下拉菜单显示
	function showBox(){
		var oListBox1 = document.getElementById("listBox1");
		var oListBox2 = document.getElementById("listBox2");
		var oListButton1 = document.getElementById("docButton1");
		oListBox1.style.display = "none";
		oListBox2.style.display = "block";
		oListButton1.style.display = "block";
	}
	function hiddenBox(){
		var oListBox1 = document.getElementById("listBox1");
		var oListBox2 = document.getElementById("listBox2");
		var oListButton1 = document.getElementById("docButton1");
		oListBox1.style.display = "block";
		oListBox2.style.display = "none";
		oListButton1.style.display = "none";
	}
	
</script>

<!-- 文字样式调整 -->
<style>
    .quoteOrganize:hover { text-decoration:underline;}
	.importData:hover { text-decoration:underline;} 
	
	#listBox1,#listBox2 { float:left; width:114px; padding-left:10px; height:31px; border:2px solid #017fed; border-radius:20px; line-height:31px; text-align:center; font-size:14px; font-weight: bold; color: #0080ed; background:#fff url(../resources/img/listBox_1.png) no-repeat 8px 2px;} 
	#listBox2 { border:none; height:30px; margin-left:4px; background:none;}
	#listBox1:hover { color:#fff; background:#017fed url(../resources/img/listBox_2.png) no-repeat 8px 2px;}
	#docButton1 { position:absolute; z-index:999; right:0; top:20px; width:124px; height:auto; border-radius: 20px; border: 2px solid #017fed; color:#555; text-align:left; background:#fff; }
	#docButton1 li { height:25px;}
	#docButton1 a { border:none; width:124px; border-radius:20px; height:25px; line-height:25px;} 
	#docButton1 a:hover { border:none; width:124px; border-radius:20px; overflow:hidden; height:25px; line-height:25px;} 
	
</style> 

</head>
<body>  
<%--  <div class="ma main"  style="display: none;">
<div class="chapter_popup">
     <div class="permission_an mubanclass_an ma mt20"> 
       <div id="popDivs" style="display: none; position:relative; z-index:5000;">
			<a href="javascript:;" class="per_baocun"  onclick="addTitle('${documentId}');">设置正文</a>
			&nbsp;&nbsp;
            <a href="javascript:;" class="per_baocun" onclick="addPreface('${documentId}','${projectId}')">设置前言</a>
		</div>
</div>	 	
 </div>  
</div>	 --%>	
	<div class="ma main">
		<iframe id="fileDownFrame" src="" style="display:none; visibility:hidden;"></iframe>
		
		<div id="popDiv" style="display: none; position:relative; z-index:5000; overflow:hidden;">
			<iframe id="popIframe" style="width: 100%; z-index:5000;" border="0" frameborder="0" ></iframe>
		</div>
	<!-------左侧菜单------>
    <div class="fl menu dingxwd_menu">
        <div id="organizeBox" class="xmuxx_b" style=" width:315px; height:76px; display:none; /*display:inline-block;*/ line-height:78px; padding-top:0;">
            <%-- <div class="xmuxx_b_c1">  
            	<div class="fl xmuxx_b_t">项目信息  </div>
            	<c:choose>
               		<c:when test="${editPlan == '0' }">
               			<div class="fl xmuxx_b_xq"><a href="javascript:;" onclick="promptPlan('returnProjectList');">返回项目列表</a></div>
               		</c:when>
               		<c:otherwise>
               			<div class="fl xmuxx_b_xq"><a href="javascript:;" onclick="returnProjectList();">返回项目列表</a></div>
               		</c:otherwise>
               	</c:choose>
            	
            </div>   --%>          
            <input type="hidden" class="xmuxx_b_txt" id="projectInfo_val" title="${projectInfo }" />   <!-- 隐藏文档标题  -->
        </div>
        
        <div class="list dingxwd_list" style="padding:20px 0;">
            <div id="zTreeDemo" class="zTreeDemoBackground list_roll left" >
                <ul id="treeDemo" class="ztree ztreexmgli ztreexmgli2 ztreeb"></ul>
            </div>              
        </div>
        
    </div>
    <div class="main_cont dingxwd_main">
        <div class="main_c">
            <div class="dingx_c_top" style="height:80px;">
                <div class="fl dingx_top_t" style="padding:20px 0 20px 0;">
                    
                    <!-- 添加项目信息开始  -->
                    <div id="projectInfo" style=" width:400px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"> <!-- overflow:hidden; text-overflow:ellipsis; white-space:nowrap; -->
                    	<strong style="letter-spacing:9px;">项目信</strong><strong>息：</strong>    <!-- 显示字体加粗  -->
                    	<span id="projectInfo_val" title="${projectInfo }">${projectInfo}</span>
                    </div>
                    <!-- 添加项目信息结束  -->
                    
                    <c:if test="${proTempName =='GJB438B项目文档模板'}">
                    	<div id="documentInfo" style="float:left; padding-right:10px; width:250px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;" >   <!-- 项目文档模版及文档基本信息位置调整  -->
                    		<strong>项目文档模板：</strong>
                    		<span id="documentInfo_val" title="${proTempName}">${proTempName}</span>
                    	</div>
	                    <div style="float:left; overflow:hidden;" >
	                    	<strong>文档基本信息：</strong>
	                    	<c:choose>
	                    		<c:when test="${editPlan == '0' }">
	                    			<c:if test="${documentBaseinfoMessage == 'no' }">
	                    				<a href="javascript:;" onclick="promptPlan('check');"> 查看</a>
	                    			</c:if>
	                    			<!-- <a href="javascript:;" onclick="promptPlan('check');"> 查看</a>  -->
				                    	<c:if test="${documentBaseinfoMessage == 'yes' }">
				                    	 	<a href="javascript:;" onclick="promptPlan('alter');" >修改</a> 
	                    				</c:if>
	                    		</c:when>
	                    		<c:otherwise>
	                    			<c:if test="${documentBaseinfoMessage == 'no' }">
	                    				<a href="javascript:;" onclick="documentInfo('check');"> 查看</a>
	                    			</c:if>
	                    			<!-- <a href="javascript:;" onclick="documentInfo('check');"> 查看</a>  -->
			                    	<c:if test="${documentBaseinfoMessage == 'yes' }">
			                    	 	<a href="javascript:;" onclick="documentInfo('alter');" >修改</a> 
			                    	</c:if>
	                    		</c:otherwise>
	                    	</c:choose>
	                   </div>
                    </c:if>
                    <c:if test="${proTempName !='GJB438B项目文档模板'}">
                    	<div title="${proTempName}" style=" width:250px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><strong>项目文档模板：</strong>${proTempName}</div>
                    </c:if>
                </div>
                
                <!-- 添加下拉菜单开始  -->
                <div class="fr permission_tit">
                	<a id="listBox1" style=" float:right; display:none;">更多操作 </a>
                	<a id="listBox2" style=" float:right; display:none;"></a>
                	<ul id="docButton1" style=" float:right; display:none;"></ul>
                    <ul id="docButton" style="float:right;"></ul>
                    
                </div>
     			<!-- 添加下拉菜单结束  -->
     			
            </div>
            
            <div class="dingxwd_cont">
                <div class="dingxwd_c_tit">文档名称：${documentName}  
            	<a  href="javascript:;" onclick="showAllDocument('${documentId}','${projectId }');" style="color:#026abb;font-size: 15px;">全文预览</a> 
	                    <input type="button" class="dyi_btna dyi_btnabox dyi_btna1 fr"  style="margin-top:-5px; height:31px;" id = "lock" value="锁定"/>
	                     <input type="button" class="dyi_btna dyi_btnabox dyi_btna1 fr" style="margin-top:-5px; height:31px;"  id = "unlock" value="解锁"/>
	                    <!--  -->
	                    &nbsp;&nbsp;<span style="display:block;float: right; margin-top:-5px;" id="lockName"></span>
	                    <c:if test="${editPlan == '0' }">
	                        <div class="fr dingxwd_jdt" ><em>文档编制进度:</em><div id="progress" class="fl progress"></div>
	                    	<c:if test="${status != '4' }">
		                		<div class="fr glqxian_btn wendmban_btn" style="margin-top:-5px; height:32px; ">
				                	<a class="glqxian_btn1" style=" " href="javascript:;" onclick="loadEditPlan('${documentId}','${projectId }');">编制进度管理</a>
				                </div>   
	                		</c:if>
	                    </c:if>
	                  <!--   <a href="javascript:;"  id="lock" >锁定</a>
	                    <a href="javascript:;"  id="unlock">解锁</a> -->
	                </div>
	                <div class="clear"></div>
                </div>
                <div style="width:100%;  z-index:500; position: relative; top:10px; ">
                	<iframe name="tmpViewList" style="width: 100%; height:850px;" id="templatelist" src="" border="0" frameborder="0" ;scrolling="auto">
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
