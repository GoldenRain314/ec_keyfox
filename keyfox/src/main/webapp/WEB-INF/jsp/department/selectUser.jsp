<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>树形结构</title>
		<script type="text/javascript" src="${_resources}jq/jquery-1.8.3.min.js"></script>
		<script type="text/javascript" src="${_resources}jq/dtree.js"></script>
		<link rel="stylesheet" href="${_resources}jq/dtree.css" type="text/css"></link>
		<script type="text/javascript">
			  tree = new dTree('tree');//创建一个对象.
			  function onClickTreeNode()  { 
				    //alert(tree.getSelected());
				    var node = tree.getSelected().split(",");
				    selectSonByNodeId(node[0]);
				    $("#cn").val(node[0]);
				    $("#updatename").val(node[1]);  
              } 
			  $.ajax({ 
					url:'${_baseUrl}/departmentController/selectDepartTree', 
					type:'post', //数据发送方式 
					dataType:'xml', //接受数据格式 
					error:function(json){
	 						 alert( "not lived!");
						  },
					async: false ,
					success: function(xml){
								alert(xml);
							    $(xml).find("node").each(function(){
									  var nodeId = $(this).attr("nodeId");  
	 								  var parentId = $(this).attr("parentId");
									  var nodeName=$(this).text(); 
								       tree.add(nodeId,parentId,nodeName,"","","javaScript:onClickTreeNode() ;","","","","",false,"");
		                        });
			                }
			  });
			 /*  alert(tree); */
			  document.write(tree);
          </script>
	</head>
	
</html>
