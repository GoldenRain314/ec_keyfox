<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>需求正逆向追踪表</title>
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
$(function(){
	var r=false;
	var result="${result}";
	if(result.indexOf("tableTr1")>0){
		$("#tableTr1").css("display","block");
		mc('trackTable1',0,0,0); 
	}
	if(result.indexOf("tableTr2")>0){
		$("#tableTr2").css("display","block");
		mc('trackTable2',0,0,0); 
	}
	r=true;
	if(r){
		parent.layer.closeAll('loading');
	}
});
	
</script>
<body>
    <div class="ma main">
    	<div class="wdang_main">
        	<div class="xuqiuzz_cont">
        	  <div class="xmugonj_curr xuqiuzz_curr">
                
              </div>
              <div id="tableTr1" style="display: none;">
	              <strong style="font-size: 20px;line-height: 70px;">需求正向追踪表</strong>
	                <div class="xmugonj_ta_j xuqiuzz_ta_j widthauto" id="tableDiv">
	                	<table width="100%" border="0" id ="trackTable1" cellspacing="0" cellpadding="0">
		                     <tr>
	                      		${tableTr1}                      	
	                    </table>
	              </div>
	          </div>    
	          <div id="tableTr2" style="display: none;">
	              <strong style="font-size: 20px;line-height: 70px">需求逆向追踪表</strong>
	                <div class="xmugonj_ta_j xuqiuzz_ta_j widthauto xmugonj_curr xuqiuzz_curr" id="tableDiv">
	                	<table width="100%" border="0" id ="trackTable2" cellspacing="0" cellpadding="0">                   	              
	                      		${tableTr2}
	                    </table>
	            	</div>
              </div>
              <span style="line-height: 20px;">&nbsp;</span>
          	</div>
          </div>
      </div>
    </div>
</body>
</html>