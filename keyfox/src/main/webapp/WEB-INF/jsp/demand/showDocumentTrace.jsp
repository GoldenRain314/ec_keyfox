<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>项目文档追踪关系展示</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" src="${_resources}js/demand/initHideDocument.js"></script>
<script type="text/javascript">

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

$(function (){
	var b438 = "${b438}";
	if("true" == b438){
		$("#showDiv").hide();
		hideDocument();
		$("#b438").show();
		var showObj = eval('(${show})');
		for(var i=0;i<showObj.length;i++){
			var obj = showObj[i];
			var str = obj.documentjspId;
			if(str != undefined){
				var split = str.split(",");
				for(var id=0;id<split.length;id++){
					if(id == 0){
						$("#"+split[id]+"_name").show();
						$("#"+split[id]+"_version").show();
						$("#"+split[id]+"_version").html(obj.version);
						if($("#"+split[id]+"_relate") !=undefined){
							if(obj.trackRelate !=""){
								$("#"+split[id]+"_relate").html(obj.trackRelate); 
							}
						} 
					}
					$("#"+split[id]).show();
					
					if(split[id].indexOf("_xia") > 0 || split[id].indexOf("_zuo") > 0 || split[id].indexOf("_shang") > 0 || split[id].indexOf("_you") > 0){
						
						/* $("#"+split[id]+"_trace").bind("click",function (){
							parent.showDemandTraceTable(obj.documentId,"${projectId}");
						}); */
						
						/* document.getElementById(split[id]+"_trace").onclick= function(){
							parent.showDemandTraceTable(obj.documentId,"${projectId}");
						}; */
						
						$("#"+split[id]+"_trace_hidden").val(obj.documentId);
						
						
					}
					
				}
			}
		}
	}else{
		$("#b438").hide();
		$("#showDiv").show();
		var ul;
		var li;
		$("#showDiv").children("div").remove();
		
		$.ajax({
			url:'${_baseUrl}/dd/getDocumentTraceTable?projectId=${projectId}',
			type:'post', //数据发送方式 
			dataType:'json', //接受数据格式 
			async: false,
			success: function(data){
				if("0" == data.message){
					$("#showDiv").append("<span class='xqzzny_c1_a'>未建立追踪关系或追踪关系出现异常</span>");
				}else{
					$("#showDiv").append(data.message);
					
				}
	        },
			error:function(){
				layer.msg( "系统错误");
			}
		});
	}
});

/* 438B固定追踪关系展示 */
function showDemandTrace(id){
	var documentId = $("#"+id+"_hidden").val();
	parent.showDemandTraceTable(documentId,"${projectId}");
}

</script>


<body>
<div class="xqzzny_c1" id="showDiv">
</div>
<div id="b438">
 <div class="zhuiztu_cont_top">
	<div class="zhuiztu_list zhuiztu_list1">
	   	<ul>
	       	<li>
	           	<div class="zhuiztu_a">
	               	<span id="shujukushejishuoming"><img title="数据库设计说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="shujukushejishuoming_name" title="数据库设计说明">数据库设计说明</em><br><em id="shujukushejishuoming_version"></em></p>
	               </div>
	               <div class="zhuiztu_b" id="shujukushejishuoming_xia"><a id="shujukushejishuoming_xia_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="shujukushejishuoming_xia_trace_hidden" value="">查看追踪关系</a></div>
	          		<div  class="zhuiztu_xz" id="shujukushejishuoming_relate" ></div>
	           </li>
	           <li>
	           	<div class="zhuiztu_a">
	               	<span id="ruanjianchanpinguigeshuoming"><img title="软件产品规格说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianchanpinguigeshuoming_name" title="软件产品规格说明">软件产品规格说明</em><br><em id="ruanjianchanpinguigeshuoming_version"></em></p>
	               </div>
	               <div class="zhuiztu_b" id="ruanjianchanpinguigeshuoming_xia"><a id="ruanjianchanpinguigeshuoming_xia_trace" onclick="showDemandTrace(this.id)" href="javascript:;"><input type="hidden" id="ruanjianchanpinguigeshuoming_xia_trace_hidden" value="">查看追踪关系</a></div>
	           		<div  class="zhuiztu_xz" id="ruanjianchanpinguigeshuoming_relate" ></div> 
	           </li>
	           <div class="clear"></div>
	       </ul>
	   </div>
       <div class="zhuiztu_list zhuiztu_list2">
       	<ul>
           	<li>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianyanzhirenwushu"><img title="软件研制任务书" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianyanzhirenwushu_name" title="软件研制任务书">软件研制任务书</em><br><em id="ruanjianyanzhirenwushu_version"></em></p>
                   </div>
               </li>
               <li>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianxuqiuguogeshuoming"><img title="软件需求规格说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianxuqiuguogeshuoming_name" title="软件需求规格说明">软件需求规格说明</em><br><em id="ruanjianxuqiuguogeshuoming_version"></em></p>
                   </div>
                   <div class="zhuiztu_c" id="ruanjianxuqiuguogeshuoming_zuo"><a id="ruanjianxuqiuguogeshuoming_zuo_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjianxuqiuguogeshuoming_zuo_trace_hidden" value="">查看追踪关系</a></div>
               	   <div  class="zhuiztu_zx" id="ruanjianxuqiuguogeshuoming_relate" ></div>
               </li>
               <li>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianshejishuoming"><img title="软件设计说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianshejishuoming_name" title="软件设计说明">软件设计说明</em><br><em id="ruanjianshejishuoming_version"></em></p>
                   </div>
                   <div class="zhuiztu_c" id="ruanjianshejishuoming_zuo"><a id="ruanjianshejishuoming_zuo_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjianshejishuoming_zuo_trace_hidden" value="">查看追踪关系</a></div>
               	   <div  class="zhuiztu_zx" id="ruanjianshejishuoming_relate" ></div>
               </li>
               <li>
               	<div class="zhuiztu_a">
                   	<span id="ruanjiandanyuanceshijihua"><img title="软件单元测试计划" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjiandanyuanceshijihua_name" title="软件单元测试计划">软件单元测试计划</em><br><em id="ruanjiandanyuanceshijihua_version"></em></p>
                   </div>
                   <div class="zhuiztu_c" id="ruanjiandanyuanceshijihua_zuo"><a id="ruanjiandanyuanceshijihua_zuo_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjiandanyuanceshijihua_zuo_trace_hidden" value="">查看追踪关系</a></div>
               		<div  class="zhuiztu_zx" id="ruanjiandanyuanceshijihua_relate" ></div>
               </li>
               <li>
               	<div class="zhuiztu_a">
                   	<span id="ruanjiandanyuanceshishuoming"><img title="软件单元测试说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjiandanyuanceshishuoming_name" title="软件单元测试说明">软件单元测试说明</em><br><em id="ruanjiandanyuanceshishuoming_version"></em></p>
                   </div>
                   <div class="zhuiztu_c" id="ruanjiandanyuanceshishuoming_zuo"><a id="ruanjiandanyuanceshishuoming_zuo_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjiandanyuanceshishuoming_zuo_trace_hidden" value="">查看追踪关系</a></div>
              		<div  class="zhuiztu_zx"  id="ruanjiandanyuanceshishuoming_relate" ></div>
               </li>
               <div class="clear"></div>
           </ul>
       </div>

       <div class="zhuiztu_list zhuiztu_list3">
       	<ul>
           	<li>
           		<div  class="zhuiztu_sz" id="ruanjianxitongceshijihua_relate"  ></div>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianxitongceshijihua"><img title="软件系统测试计划" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianxitongceshijihua_name" title="软件系统测试计划">软件系统测试计划</em><br><em id="ruanjianxitongceshijihua_version"></em></p>
                   </div>
                   <div class="zhuiztu_d" id="ruanjianxitongceshijihua_shang"><a id="ruanjianxitongceshijihua_shang_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjianxitongceshijihua_shang_trace_hidden" value="">查看追踪关系</a></div>
               </li>
               <li>
               <div  class="zhuiztu_sz" id="ruanjianpeizhixiangceshijihua_relate"  ></div>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianpeizhixiangceshijihua"><img title="软件配置项测试计划" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianpeizhixiangceshijihua_name" title="软件配置项测试计划">软件配置项测试计划</em><br><em id="ruanjianpeizhixiangceshijihua_version"></em></p>
                   </div>
                   <div class="zhuiztu_d" id="ruanjianpeizhixiangceshijihua_shang"><a id="ruanjianpeizhixiangceshijihua_shang_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjianpeizhixiangceshijihua_shang_trace_hidden" value="">查看追踪关系</a></div>
               </li>
               <li>
               <div  class="zhuiztu_sz" id="ruanjianbujianceshijihua_relate"   ></div>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianbujianceshijihua"><img title="软件部件测试计划" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianbujianceshijihua_name" title="软件部件测试计划">软件部件测试计划</em><br><em id="ruanjianbujianceshijihua_version"></em></p>
                   </div>
                   <div class="zhuiztu_d" id="ruanjianbujianceshijihua_shang"><a id="ruanjianbujianceshijihua_shang_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjianbujianceshijihua_shang_trace_hidden" value="">查看追踪关系</a></div>
               </li>
               <li>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianbujianceshishuoming"><img title="软件部件测试说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianbujianceshishuoming_name" title="软件部件测试说明">软件部件测试说明</em><br><em id="ruanjianbujianceshishuoming_version"></em></p>
                   </div>
                   <div class="zhuiztu_c" id="ruanjianbujianceshishuoming_zuo"><a id="ruanjianbujianceshishuoming_zuo_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjianbujianceshishuoming_zuo_trace_hidden" value="">查看追踪关系</a></div>
              		<div  class="zhuiztu_zx" id="ruanjianbujianceshishuoming_relate"  ></div>
               </li>
               
               <div class="clear"></div>
           </ul>
       </div>
            
       <div class="zhuiztu_list zhuiztu_list4">
       	<ul>
           	<li>
           		<div  class="zhuiztu_sz" id="ruanjianxitongceshishuoming_relate" ></div>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianxitongceshishuoming"><img title="软件系统测试说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianxitongceshishuoming_name" title="软件系统测试说明">软件系统测试说明</em><br><em id="ruanjianxitongceshishuoming_version"></em></p>
                   </div>
                   <div class="zhuiztu_d" id="ruanjianxitongceshishuoming_shang"><a id="ruanjianxitongceshishuoming_shang_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjianxitongceshishuoming_shang_trace_hidden" value="">查看追踪关系</a></div>
               </li>
               <li>
               		<div  class="zhuiztu_sz" id="ruanjianpeizhixiangceshishuoming_relate"  ></div>
               		<div class="zhuiztu_a">
                   	<span id="ruanjianpeizhixiangceshishuoming"><img title="软件配置项测试说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="ruanjianpeizhixiangceshishuoming_name" title="软件配置项测试说明">软件配置项测试说明</em><br><em id="ruanjianpeizhixiangceshishuoming_version"></em></p>
                   </div>
                   <div class="zhuiztu_d" id="ruanjianpeizhixiangceshishuoming_shang"><a id="ruanjianpeizhixiangceshishuoming_shang_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjianpeizhixiangceshishuoming_shang_trace_hidden" value="">查看追踪关系</a></div>
                   
               </li>
               <div class="clear"></div>
           </ul>
       </div>
    </div>
   <div class="zhuiztu_cont_botm">
   	<div class="zhuiztu_list zhuiztu_list2">
       	<ul>
           	<li>
               	<div class="zhuiztu_a">
                   	<span id="jiekouxuqiuguigeshuoming"><img title="接口需求规格说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="jiekouxuqiuguigeshuoming_name" title="接口需求规格说明">接口需求规格说明</em><br><em id="jiekouxuqiuguigeshuoming_version"></em></p>
                   </div>
               </li>
               <li>
               	<div class="zhuiztu_a">
                   	<span id="jiekoushejishuoming"><img title="接口设计说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="jiekoushejishuoming_name" title="接口设计说明">接口设计说明</em><br><em id="jiekoushejishuoming_version"></em></p>
                   </div>
                   <div class="zhuiztu_c" id="jiekoushejishuoming_zuo"><a id="jiekoushejishuoming_zuo_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="jiekoushejishuoming_zuo_trace_hidden" value="">查看追踪关系</a></div>
              		<div  class="zhuiztu_zx" id="jiekoushejishuoming_relate"  ></div>
               </li>
               <div class="clear"></div>
           </ul>
       </div>
       <div class="zhuiztu_list zhuiztu_list2">
       	<ul>
           	<li>
               	<div class="zhuiztu_a">
                   	<span id="xitongzixitongxuqiuguigeshuoming"><img title="系统（子系统）规格说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="xitongzixitongxuqiuguigeshuoming_name" title="系统（子系统）规格说明">系统（子系统）规格说明</em><br><em id="xitongzixitongxuqiuguigeshuoming_version"></em></p>
                   </div>
               </li>
               <li>
               	<div class="zhuiztu_a">
                   	<span id="xitongzixitongshejishuoming"><img title="系统（子系统）设计说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p><em id="xitongzixitongshejishuoming_name" title="系统（子系统）设计说明">系统（子系统）设计说明</em><br><em id="xitongzixitongshejishuoming_version"></em></p>
                   </div>
                   <div class="zhuiztu_c" id="xitongzixitongshejishuoming_zuo"><a id="xitongzixitongshejishuoming_zuo_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="xitongzixitongshejishuoming_zuo_trace_hidden" value="">查看追踪关系</a></div>
              		<div  class="zhuiztu_zx" id="xitongzixitongshejishuoming_relate" ></div>
               </li>
               <div class="clear"></div>
           </ul>
       </div>
       <div class="zhuiztu_list zhuiztu_list2">
       	<ul>
           	<li>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianceshijihua"><img title="软件测试计划" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p title="软件测试计划"><em id="ruanjianceshijihua_name" title="软件测试计划">软件测试计划</em><br><em id="ruanjianceshijihua_version"></em></p>
                   </div>
               </li>
               <li>
               	<div class="zhuiztu_a">
                   	<span id="ruanjianceshishuoming"><img title="软件测试说明" src="${_resources}images/xqzzny_c1_img1.png" alt="" ></span><p title="软件测试说明"><em id="ruanjianceshishuoming_name" title="软件测试说明">软件测试说明</em><br><em id="ruanjianceshishuoming_version"></em></p>    <!-- 修改文字显示位置 -->
                   </div>
                   <div class="zhuiztu_c" id="ruanjianceshishuoming_zuo"><a id="ruanjianceshishuoming_zuo_trace" href="javascript:;" onclick="showDemandTrace(this.id)"><input type="hidden" id="ruanjianceshishuoming_zuo_trace_hidden" value="">查看追踪关系</a></div>
               		<div  class="zhuiztu_zx" id="ruanjianceshishuoming_relate" ></div>
               </li>
               <div class="clear"></div>
           </ul>
       </div>
   </div>
</div>
</body>
</html>