<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>展示需求追踪关系表格</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>

<script type="text/javascript">

function mc(tableId, startRow, endRow, col) { 
	var tb = document.getElementById(tableId); 
	if (col >= tb.rows[0].cells.length) { 
		return; 
	} 
	if (col == 0) { endRow = tb.rows.length-1; } 
	for (var i = startRow; i < endRow; i++) { 
		if (tb.rows[startRow].cells[col].innerHTML == tb.rows[i + 1].cells[0].innerHTML) { 
			tb.rows[i + 1].removeChild(tb.rows[i + 1].cells[0]); 
			tb.rows[startRow].cells[col].rowSpan = (tb.rows[startRow].cells[col].rowSpan | 0) + 1; 
			if (i == endRow - 1 && startRow != endRow) { 
				mc(tableId, startRow, endRow, col + 1); 
			} 
		} else { 
			mc(tableId, startRow, i + 0, col + 1); 
			startRow = i + 1; 
		} 
	} 
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

$(function(){
	//tableTrSoftware ,tableTrUnit,tableTrPart,tableTrConfig,tableTrSystem
	var result="${result}";
	var r=false;
	if(result.indexOf("tableTrSoftware")>0){
		$("#tableTrSoftware").css("display","block");
		 mc('software',0,0,0); 
	}
	if(result.indexOf("tableTrUnit")>0){
		$("#tableTrUnit").css("display","block");
		 mc('unit',0,0,0); 
	}
	if(result.indexOf("tableTrPart")>0){
		$("#tableTrPart").css("display","block");
		 mc('part',0,0,0); 
	}
	if(result.indexOf("tableTrConfig")>0){
		$("#tableTrConfig").css("display","block");
		 mc('config',0,0,0);  
	}
	if(result.indexOf("tableTrSystem")>0){
		$("#tableTrSystem").css("display","block");
		 mc('systemtest',0,0,0); 
	}
	r=true;
	if(r){
		parent.layer.closeAll('loading');
	}
	
})

</script>
<body>
    <div class="ma main">
    	<div class="wdang_main">
        	<div class="xuqiuzz_cont">
        	  <div class="xmugonj_curr xuqiuzz_curr">
                
              </div>
              <div id="tableTrSoftware" style="display: none;">
	              <strong style="font-size: 20px;line-height: 70px;"></strong>
	                <div class="xmugonj_ta_j xuqiuzz_ta_j widthauto" id="tableDiv">
	                	<table width="100%" border="0" id ="software" cellspacing="0" cellpadding="0">
	                   			<tr>
	                      		<td height="文档名称"  width="10%"  align="center" bgcolor="#f0f1f1"><strong>软件开发活动</strong></td>
		                        <td height="57" width="18%"   align="center" bgcolor="#f0f1f1"><strong>系统设计</strong></td>
		                        <td align="center" width="18%"  bgcolor="#f0f1f1"><strong>需求分析</strong></td>
		                        <td height="57"  width="18%" colspan="" align="center" bgcolor="#f0f1f1"><strong>软件设计</strong></td>
		                        <td align="center" width="36%"  colspan="2" bgcolor="#f0f1f1"><strong>软件测试</strong></td>
		                        </tr>
		                      	<tr>
		                      	<td height="57"  width="10%"  align="center" bgcolor="#f0f1f1"><strong>文档名称</strong></td>
		                        <td height="57"  width="18%"  align="center" bgcolor="#f0f1f1"><strong>软件研制任务书</strong></td>
		                        <td align="center" width="18%"  bgcolor="#f0f1f1"><strong>软件需求规格说明</strong></td>
		                        <td height="57"  width="18%" colspan="" align="center" bgcolor="#5A88A1"><strong style="color: black;">软件设计说明</strong></td>
		                        <td align="center" width="18%"  bgcolor="#5A88A1"><strong style="color: black;">软件测试计划</strong></td>
		                         <td align="center"  width="18%"  bgcolor="#5A88A1"><strong style="color: black;">软件测试说明</strong></td>
		                        </tr>
	                      	${tableTrSoftware} 
	                      	
	                    </table>
	              </div>
              </div>
               <div id="tableTrUnit" style="display: none;">
	               <strong style="font-size: 20px;line-height: 70px;">单元测试</strong>
	                <div class="xmugonj_ta_j xuqiuzz_ta_j widthauto" id="tableDiv">
	                	<table width="100%" border="0" id ="unit" cellspacing="0" cellpadding="0">
	                   			<tr>
	                      		<td height="文档名称"  width="10%"  align="center" bgcolor="#f0f1f1"><strong>软件开发活动</strong></td>
		                        <td height="57"   width="18%" align="center" bgcolor="#f0f1f1"><strong>系统设计</strong></td>
		                        <td align="center" width="18%"  bgcolor="#f0f1f1"><strong>需求分析</strong></td>
		                        <td height="57" width="18%"  colspan="" align="center" bgcolor="#f0f1f1"><strong>软件设计</strong></td>
		                        <td align="center" width="36%"  colspan="2" bgcolor="#f0f1f1"><strong>单元测试</strong></td>
		                        </tr>
		                      	<tr>
		                      	<td height="57"   width="10%" align="center" bgcolor="#f0f1f1"><strong>文档名称</strong></td>
		                        <td height="57"  width="18%"  align="center" bgcolor="#f0f1f1"><strong>软件研制任务书</strong></td>
		                        <td align="center" width="18%"  bgcolor="#f0f1f1"><strong>软件需求规格说明</strong></td>
		                        <td height="57"  width="18%" colspan="" align="center" bgcolor="#5A88A1"><strong style="color: black;">软件设计说明</strong></td>
		                        <td align="center" width="18%"  bgcolor="#5A88A1"><strong style="color: black;">软件单元测试计划</strong></td>
		                         <td align="center" width="18%"  bgcolor="#5A88A1"><strong style="color: black;">软件单元测试说明</strong></td>
		                        </tr>
	                      		${tableTrUnit}
	                      	
	                    </table>
	              </div>
              </div>
              
               <div id="tableTrPart" style="display: none;">
	                <strong style="font-size: 20px;line-height: 70px;">部件测试</strong>
	                <div class="xmugonj_ta_j xuqiuzz_ta_j widthauto" id="tableDiv">
	                	<table width="100%" border="0" id ="part" cellspacing="0" cellpadding="0">
	                   			<tr>
	                      		<td height="文档名称" width="10%"  align="center" bgcolor="#f0f1f1"><strong>软件开发活动</strong></td>
		                        <td height="57"  width="18%" align="center" bgcolor="#f0f1f1"><strong>系统设计</strong></td>
		                        <td align="center" width="18%" bgcolor="#f0f1f1"><strong>需求分析</strong></td>
		                        <td height="57"  width="18%" colspan="" align="center" bgcolor="#f0f1f1"><strong>软件设计</strong></td>
		                        <td align="center"  width="36%"  colspan="2" bgcolor="#f0f1f1"><strong>部件测试</strong></td>
		                        </tr>
		                      	<tr>
		                      	<td height="57"  width="10%" align="center" bgcolor="#f0f1f1"><strong>文档名称</strong></td>
		                        <td height="57"  width="18%"  align="center" bgcolor="#f0f1f1"><strong>软件研制任务书</strong></td>
		                        <td align="center"  width="18%" bgcolor="#f0f1f1"><strong>软件需求规格说明</strong></td>
		                        <td height="57"  width="18%" colspan="" align="center" bgcolor="#5A88A1"><strong style="color: black;">软件设计说明</strong></td>
		                        <td align="center" width="18%"  bgcolor="#5A88A1"><strong style="color: black;">软件部件测试计划</strong></td>
		                         <td align="center"  width="18%" bgcolor="#5A88A1"><strong style="color: black;">软件部件测试说明</strong></td>
		                        </tr>
	                      ${tableTrPart} 
	                      	
	                    </table>
	              </div>
              </div>
              <div id="tableTrConfig" style="display: none;">
	              <strong style="font-size: 20px;line-height: 70px;">配置项测试</strong>
	                <div class="xmugonj_ta_j xuqiuzz_ta_j widthauto" id="tableDiv">
	                	<table width="100%" border="0" id ="config" cellspacing="0" cellpadding="0">
	                   			<tr>
	                      		<td height="文档名称"  width="10%"  align="center" bgcolor="#f0f1f1"><strong>软件开发活动</strong></td>
		                        <td height="57"   width="18%" align="center" bgcolor="#f0f1f1"><strong>系统设计</strong></td>
		                        <td align="center" width="18%"  bgcolor="#f0f1f1"><strong>需求分析</strong></td>
		                        <td height="57" colspan="" width="18%" align="center" bgcolor="#f0f1f1"><strong>软件设计</strong></td>
		                        <td align="center" width="36%"  colspan="2" bgcolor="#f0f1f1"><strong>配置项测试</strong></td>
		                        </tr>
		                      	<tr>
		                      	<td height="57"  width="10%"  align="center" bgcolor="#f0f1f1"><strong>文档名称</strong></td>
		                        <td height="57"   width="18%" align="center" bgcolor="#f0f1f1"><strong>软件研制任务书</strong></td>
		                        <td align="center"  width="18%" bgcolor="#5A88A1"><strong style="color: black;">软件需求规格说明</strong></td>
		                        <td height="57"  width="18%" colspan="" align="center" bgcolor="#f0f1f1"><strong >软件设计说明</strong></td>
		                        <td align="center"  width="18%" bgcolor="#5A88A1"><strong style="color: black;">软件配置项测试计划</strong></td>
		                         <td align="center" width="18%"  bgcolor="#5A88A1"><strong style="color: black;">软件配置项测试说明</strong></td>
		                        </tr>
	                      	${tableTrConfig}
	                      	
	                    </table>
	              </div>
              </div>
               <div id="tableTrSystem" style="display: none;">
	              <strong style="font-size: 20px;line-height: 70px;">系统测试</strong>
	                <div class="xmugonj_ta_j xuqiuzz_ta_j widthauto" id="tableDiv">
	                	<table width="100%" border="0" id ="systemtest" cellspacing="0" cellpadding="0">
	                   			<tr>
	                      		<td height="文档名称"  width="10%"  align="center" bgcolor="#f0f1f1"><strong>软件开发活动</strong></td>
		                        <td height="57"  width="18%"  align="center" bgcolor="#f0f1f1"><strong>系统设计</strong></td>
		                        <td align="center" width="18%"  bgcolor="#f0f1f1"><strong>需求分析</strong></td>
		                        <td height="57"  width="18%" colspan="" align="center" bgcolor="#f0f1f1"><strong>软件设计</strong></td>
		                        <td align="center" width="36%"  colspan="2" bgcolor="#f0f1f1"><strong>系统测试</strong></td>
		                        </tr>
		                      	<tr>
		                      	<td height="57"   width="10%" align="center" bgcolor="#f0f1f1"><strong>文档名称</strong></td>
		                        <td height="57"   width="18%" align="center" bgcolor="#5A88A1"><strong style="color: black;">软件研制任务书</strong></td>
		                        <td align="center" width="18%"  bgcolor="#f0f1f1"><strong>软件需求规格说明</strong></td>
		                        <td height="57"  width="18%" colspan="" align="center" bgcolor="#f0f1f1"><strong>软件设计说明</strong></td>
		                        <td align="center" width="18%"  bgcolor="#5A88A1"><strong style="color: black;">软件系统测试计划</strong></td>
		                         <td align="center"  width="18%" bgcolor="#5A88A1"><strong style="color: black;">软件系统测试说明</strong></td>
		                        </tr>
	                      		${tableTrSystem}
	                    </table>
	              </div>
	           </div> 
	            <span style="line-height: 20px;">&nbsp;</span>
          </div>
      </div>
    </div>
</body>
</html>