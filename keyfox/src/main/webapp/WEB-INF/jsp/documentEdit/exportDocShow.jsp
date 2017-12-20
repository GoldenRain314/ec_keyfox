<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>       
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="shortcut icon" href="${_resources}/logo.png"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">                                            
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />  
<title>自定义文档模板</title>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap.min.css" />
<link rel="stylesheet" href="${_resources}bootstrap/bootstrap-table.min.css" />
<script type="text/javascript" src="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.js"></script>
<link rel="stylesheet" href="${_resources}jquery-ui/jquery-ui-1.10.4.custom.min.css" />
<script type="text/javascript">
var exportDoc;

function getTableData (){

	exportDoc = $("#defineTemplate").bootstrapTable({
		url : '${_baseUrl}/download/getexportDoc',
		pagination: true,
		pageList: [5, 10, 20, 50],
  		queryParams: queryParams,
  		
        columns: [{
        	 field: 'checked',
             checkbox: true,
         }, {
            field: 'id',
            title: 'id',
            visible:false,
            width: 5
        },{
            field: 'documentName',
            title: '文档名称',
            width: 100
        },{
            field: 'exportDate',
            title: '导出时间',
            width: 100
        },{
            field: 'projectName',
            title: '所属项目',
            width: 100
        },{
            field: 'operation',
            title: '操作',
            width: 90,
            formatter : function(value, row, index) {
            	
            		var str ="";
            		if(row.projectstatus=="1" && row.projectmanager == "${user.id}"){
            			return "<a onClick=\"establishMent('"+row.id+"','"+row.projectid+"');\">构建</a>";
            		}else if(row.projectstatus == "2"){
            			if(row.projectmanager == "${user.id}"){
            				return "<a onClick=\"gotoProjectAndDocument('"+row.id+"','"+row.projectid+"','projectList');\">编写</a>&nbsp;<a onClick=\"pigeonhole('"+row.id+"','"+row.projectid+"');\">归档</a>";
            			}else{
            				return "<a onClick=\"gotoProjectAndDocument('"+row.id+"','"+row.projectid+"','projectList');\">编写</a>";
            			}
            			
            		}else if(row.projectstatus == "4"){
            			return "<a onClick=\"checkProject('"+row.id+"','"+row.projectid+"');\">查看</a>";
            		}else if(row.projectstatus == "3"){
            			return "<a onClick=\"gotoProjectAndDocument('"+row.id+"','"+row.projectid+"','projectList');\">编写</a>";
            		}
					
			}
        }]
    });
	
	function queryParams(params){
		return {
		    pageSize: params.limit,
		    pageNo: params.pn,
		    sort : params.sort,
		    order : params.order
	   }
	}
	
}



$(function(){	
	getTableData();
})


function deleteFun(){
	var objects =  $("#exportDoc").bootstrapTable('getSelections');
	var id ="";
	for(var i =0;i<objects.length;i++){
		if(id.length>0){
			id+=","+objects[i].id;
		}else{
			id=objects[i].id;
		}
	}
	if(id.length==0){
		layer.msg("请先选择文档");
		return;
	}
	 var path="${_baseUrl}/documentTemplateController/delDocumentTemplate";
	 $.ajax({    
			type: "POST",    
			async: false,    
			url:path,   
			data:{
				"id":id      
			},    
			dataType:"json",    
			success: function (data) {  
				
				layer.msg(data.message,{shift:5,time:1500});
				refreshTable();		
			}   
		}); 
}


/* 关闭弹出框 */
function closeWin(){
	$("#popDiv").dialog('close');
}

function refreshTable(){
	defineTemplate.bootstrapTable('refresh');
}

</script>
</head>
<body>
	<div class="wdang_cont" style="display:block;">
       <div class="wdang_c" >
          <div class="wdang_dy" >
              <div class="fl wdang_dy_l" >
                   <dl >
                     <dt><input name="" type="text" class="input_text2" value="请输入文档名称..." onFocus="if(this.value=='请输入文档名称...'){this.value=''}" onBlur="if(this.value==''){this.value='请输入文档名称...';}"></dt>
                      <dd><input name="" type="button" class="input_btn2"></dd>
                  </dl>
              </div>
           </div> 
           <div class="wdang_s" >
              	<table id="exportDoc" class="tab-w-01 tab-w-auto"></table>         	
           </div>      	
                
		</div>     	
     </div>
</body>
</html>