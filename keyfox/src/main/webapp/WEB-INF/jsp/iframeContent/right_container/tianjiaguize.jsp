<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title></title>
    <link rel="stylesheet" href="${_resources}/TZ/layui/css/layui.css" media="all">
	<script src='${_resources}/TZ/layui/layui.js' type='text/javascript'></script>
    <%@ include file="/WEB-INF/jsp/common/tz.jsp" %>
    <style type="text/css">
       .main_conter .layui-form-item{width:520px;float: left;clear: none;margin-left:10px}
        .main_conter .layui-input-block{width:75%;margin-left:0px;float: left;line-height: 30px}
        .main_conter input{width:422px}
        .main_conter select{width:422px;height: 36px;font-size: 12px;line-height: 10px;padding-bottom:5px\9;border: solid 1px #d6d6d6;appearance:none;  -moz-appearance:none;  -webkit-appearance:none;background: url("${_resources}/TZ/img/input_xiala.png") no-repeat  400px center ;  border-radius: 4px;}
        .layui-colla-icon{left:98%}
        .layui-collapse{width: 99%;margin: auto;border: 0}
        .layui-colla-item{margin: 5px;border-radius: 5px}
        .layui-colla-content{border: 1px solid #ccc;background: #fff;}
        .layui-form-label{padding:5px;text-align: center;width: 95px}
        .layui-input, .layui-textarea{width:700px}
        input[type="radio"], input[type="checkbox"]{margin: 0px 0px 3px 1px}
        .dtk_span1,.zz_span1,.ym_span1,.tz_span1,.xy_span1,.ip_span1{width:40px;height:40px;display:inline-block;background: url("${_resources}/TZ/img/tianjia_a.png") no-repeat center;z-index: 99999}
        .dtk_span2,.zz_span2,.ym_span2,.tz_span2,.xy_span2,.ip_span2{right:40px;top:0px;width:40px;height:40px;display:inline-block;background: url("${_resources}/TZ/img/shanchu_a.png") no-repeat center;z-index: 99999}
        .adddtk,.addzz,.addym,.addtz,.addxy,.addip{border: 1px solid #ccc;margin: 10px;width:1000px;position: relative}
        .dtk_rule_right_label,.zz_rule_right_label,.ym_rule_right_label,.tz_rule_right_label,.xy_rule_right_label,.ip_rule_right_label{margin:10px auto}
        .adddtk_sc,.addzz_sc,.addym_sc,.addtz_sc,.addxy_sc,.addip_sc{position: absolute;right:100px;top:20px;}
        .shangchuan{position: absolute;right:202px;top:62px;}
        .shangchuan a{display: inline-block;width:100px;height:30px;line-height: 30px;text-align: center;border-radius: 4px;background: #007DDB;color: #fff}
        .xy_rule_right_dk input,.ip_rule_right_dk input{width:138px;display: inline-block}
        .footer{margin:20px auto;text-align: center;}
		.footer a{;display:inline-block;width: 200px;height: 40px;line-height: 40px;text-align: center;background: #007DDB;color: #fff;border-radius: 4px}
    </style>
</head>
<body>
<form name="rulePage" id= "rulePage" action="${_baseUrl}/ruleController/saveRuleAndCreateJsonFile" method="post">
	<div class="main">
	    <div class="main_conter" style="width: 98%; margin:10px auto;border: 1px solid #ccc">
	        <div style="overflow: hidden;margin-top: 20px;">
	            <div class="layui-form-item">
	                <label class="layui-form-label">APPID</label>
	                <div class="layui-input-block">
	                	<input type="hidden" name="appId" value="${app_id }">
	                    <input type="text" name="ruleId" disabled="disabled" lay-verify="title" autocomplete="off" placeholder="" value="${app_id }" class="layui-input">
	                </div>
	            </div>
	            <div class="layui-form-item">
	                <label class="layui-form-label">规则名称</label>
	                <div class="layui-input-block">
	                    <input type="text" name="name" lay-verify="title" autocomplete="off" value="${ruleObject.Name}" placeholder="" class="layui-input">
	                </div>
	            </div>
	            <div class="layui-form-item">
	                <label class="layui-form-label">Level</label>
	                <div class="layui-input-block">
	                    <input type="text" name="level" lay-verify="title" autocomplete="off" placeholder="" value="${ruleObject.Level}" class="layui-input">
	                </div>
	            </div>
	        </div>
	        <div style="overflow: hidden;">
	            <div class="layui-form-item">
	                <label class="layui-form-label">采集模式：</label>
	                <div class="layui-input-block">
	                    <select name="trance" >
	                        <option value ="0">不转化</option>
	                        <option value ="1">单包</option>
	                        <option value="2">当前连接</option>
	                        <option value="3">规则命中包-源IP</option>
	                        <option value ="4">规则命中包-目的IP</option>
	                        <option value ="5">规则命中包-源IP+Port</option>
	                        <option value ="6">规则命中包-目的IP+Port</option>
	                        <option value="7">规则命中包-源IP+目的IP</option>
	                        <option value="8">DNS协议--客户端IP</option>
	                        <option value ="9">DNS协议--A记录</option>
	                        <option value ="10">DNS协议--客户端IP+A记录</option>
	                    </select>
	                </div>
	            </div>
	            <div class="layui-form-item">
	                <label class="layui-form-label">保存数据量</label>
	                <div class="layui-input-block">
	                    <input type="text" name="saveBytes" lay-verify="title" autocomplete="off" value="${ruleObject.SaveBytes} " placeholder="" class="layui-input">
	                </div>
	            </div>
	            <div class="layui-form-item">
	                <label class="layui-form-label">备注</label>
	                <div class="layui-input-block">
	                    <input type="text"  name="reverse" lay-verify="title" autocomplete="off" value="${ruleObject.Reverse}" placeholder="" class="layui-input">
	                </div>
	            </div>
	        </div>
	    </div>
	    <div>
	        <div class="layui-collapse" lay-filter="test">
	            <div class="layui-colla-item" style="position: relative">
	                <h5 class="layui-colla-title">IP规则</h5>
	                <div style="position:absolute;right: 50px;top:0px">
	                    <span class="ip_span1"></span>
	                    <span class="ip_span2"></span>
	                </div>
	                <div class="layui-colla-content ip_rule" style="overflow: hidden">
	                    <div class="fl ip_rule_left">
	                        <div class="ip_rule_content">
	                        </div>
	                    </div>
	                </div>
	            </div>
	            <div class="layui-colla-item" style="position: relative">
	                <h5 class="layui-colla-title">协议规则</h5>
	                <div style="position:absolute;right: 50px;top:0px">
	                    <span class="xy_span1"></span>
	                    <span class="xy_span2"></span>
	                </div>
	                <div class="layui-colla-content xy_rule" style="overflow: hidden">
	                    <div class="fl xy_rule_left">
							<div class="xy_rule_content">
									
							</div>
	                    </div>
	                </div>
	            </div>
	            <div class="layui-colla-item" style="position: relative">
	                <h5 class="layui-colla-title">特征规则</h5>
	                <div style="position:absolute;right: 50px;top:0px">
	                    <span class="tz_span1"></span>
	                    <span class="tz_span2"></span>
	                </div>
	                <div class="layui-colla-content tz_rule" style="overflow: hidden">
	                    <div class="fl tz_rule_left">
	                        <div class="tz_rule_content">
	                        	<c:forEach items="${ruleObject.Key_Rule}" var="keyRule" varStatus="status" >
	                        		<div class="addtz"  >
										<div class="tz_rule_right_label">
											<label class="layui-form-label">协议名称：</label>
											<div>
												<input type="text" name="proId" lay-verify="title" value="${keyRule.ProID}" autocomplete="off" placeholder="" class="layui-input">
											</div>
										</div>
										<div class="tz_rule_right_label" style="margin: 10px auto">
											<label class="layui-form-label">特征字：</label>
											<div>
												<input type="text" name="keyword" lay-verify="title" value="${keyRule.Keyword}" autocomplete="off" placeholder="" class="layui-input">
											</div>
										</div>
										<div>	
											<input style="margin:6px 10px 10px 100px;" name="isCaseSensive_${status.index}"  <c:if test="${keyRule.IsCaseSensive==1}">checked=checked</c:if> type="radio"/>区分大小写
										</div>
										<div class="addtz_sc" onclick="sc(this)" name="key_${status.index}">
											<img  src="${_resources}/TZ/img/shanchu_a.png" alt=""/>
										</div>
									</div>
	                        	</c:forEach>
	                        </div>
	                    </div>
	                </div>
	            </div>
	            <div class="layui-colla-item" style="position: relative">
	                <h5 class="layui-colla-title">正则规则</h5>
	                <div style="position:absolute;right: 50px;top:0px">
	                    <span class="zz_span1"></span>
	                    <span class="zz_span2"></span>
	                </div>
	                <div class="layui-colla-content zz_rule" style="overflow: hidden">
	                    <div class="fl zz_rule_left">
	                        <div class="zz_rule_content">
	                        	
	                        </div>
	                    </div>
	                </div>
	            </div>
	            <div class="layui-colla-item" style="position: relative">
	                <h5 class="layui-colla-title">动态规则</h5>
	                <div style="position:absolute;right: 50px;top:0px">
	                    <span class="dtk_span1"></span>
	                    <span class="dtk_span2" ></span>
	                </div>
	                <div class="layui-colla-content dtk_rule" style="overflow: hidden;">
	                    <div class="dtk_rule_left"  >
	                        <div class="dtk_rule_content">
	                        </div>
	                    </div>
	                </div>
	            </div>
	            <div class="layui-colla-item" style="position: relative">
	                <h5 class="layui-colla-title">域名规则</h5>
	                <div style="position:absolute;right: 50px;top:0px">
	                    <span class="ym_span1"></span>
	                    <span class="ym_span2"></span>
	                </div>
	                <div class="layui-colla-content ym_rule" style="overflow: hidden;">
	                    <div class="ym_rule_left">
	                        <div class="ym_rule_content">
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	    <div style="display: none;">
	    	<input name="regex_rule" id="regex_rule"/>
	    	<input name="iP_rule" id="iP_rule"/>
	    	<input name="key_rule" id="key_rule"/>
	    	<input name="protocol_Rule" id="protocol_Rule"/>
	    	<input name="lib_rule" id="lib_rule"/>
	    	<input name="domain_rule" id="domain_rule"/>
	    </div>
	    <div class="footer">
	    	<a href="javascript:;" onclick="save();" >保存</a>
		</div> 
			
	</div>
</form>

</body>
<script type="text/javascript">
	function save(){
		getRuleParamData();
		$("#rulePage").submit();
	}
		

    layui.use(['element', 'layer'], function(){
        var element = layui.element;
        var layer = layui.layer;
        //监听折叠
        element.on('collapse(test)', function(data){
        });
    });
    $(function(){
		    	
        $(".ip_span1").click(function(){

    		var ipDivs = $("div .addip").length;
    		var html = "<div class=\"addip\"><div class=\"ip_rule_right_label\"><div class=\"layui-input-block\" style=\"margin:10px\"><input type=\"radio\" name=\"v4_v6_"+ipDivs+"\" value=\"IPV4\" title=\"IPV4\" checked=\"\">IPV4<input type=\"radio\" name=\"v4_v6_"+ipDivs+"\" value=\"IPV6\" title=\"IPV6\" style=\"margin-left: 50px\">IPV6</div><div><input style=\"margin-left:12px;width: 785px;\" type=\"text\" name=\"ipAddress\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div class=\"ip_rule_right_label\"><label class=\"layui-form-label\">端口范围：</label><div class=\"ip_rule_right_dk\"><div style=\"width:138px;height:38px;display:inline-block;line-height:38px;text-align: center;background: #007DDB;color: #fff;border-radius: 4px\">0</div><img src=\"${_resources}/TZ/img/duankou.png\" alt=\"\"/><input type=\"text\" name=\"port_high\" autocomplete=\"off\"  class=\"layui-input\"><img src=\"${_resources}/TZ/img/duankou.png\" alt=\"\"/><input type=\"text\" name=\"port_low\" autocomplete=\"off\"  class=\"layui-input\"><img src=\"${_resources}/TZ/img/duankou.png\" alt=\"\"/><div style=\"width:138px;height:38px;display:inline-block;line-height:38px;text-align: center;background: #007DDB;color: #fff;border-radius: 4px\">65535</div></div></div><div class=\"layui-input-block\" style=\"margin:10px\"><input type=\"checkbox\" name=\"service_port\" value=\"1\" checked=\"\"  title=\"客户端端口\" >客户端端口<input type=\"checkbox\" name=\"service_port\" value=\"2\" title=\"服务器端端口\" style=\"margin-left: 50px\">服务器端端口</div><div class=\"xy_rule_right_label\"><label class=\"layui-form-label\" style=\"width:120px\">IP-Protocol：</label><div><input style=\"width:680px\" type=\"text\" name=\"proId\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div><input style=\"margin:6px 10px 10px 120px;\" type=\"radio\"/>反选</div><div class=\"addtz_sc\" onclick=\"sc(this)\"><img  src=\"${_resources}/TZ/img/shanchu_a.png\" alt=\"\"/></div></div>";   //自己定义好要添加的信息
            $(".ip_rule_content").append(html);  //添加对应的内容到table
        });
        $(".xy_span1").click(function(){
        	var html = "<div class=\"addxy\"><div class=\"xy_rule_right_label\"><label class=\"layui-form-label\">协议名称：</label><div><input type=\"text\" name=\"proId\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div class=\"ip_rule_right_label\"><label class=\"layui-form-label\">端口范围：</label><div class=\"xy_rule_right_dk\"><div style=\"width:138px;height:38px;display:inline-block;line-height:38px;text-align: center;background: #007DDB;color: #fff;border-radius: 4px\">0</div><img src=\"${_resources}/TZ/img/duankou.png\" alt=\"\"/><input type=\"text\" name=\"title\" autocomplete=\"off\"  class=\"layui-input\"><img src=\"${_resources}/TZ/img/duankou.png\" alt=\"\"/><input type=\"text\" name=\"title\" autocomplete=\"off\"  class=\"layui-input\"><img src=\"${_resources}/TZ/img/duankou.png\" alt=\"\"/><div style=\"width:138px;height:38px;display:inline-block;line-height:38px;text-align: center;background: #007DDB;color: #fff;border-radius: 4px\">65535</div></div></div><div class=\"layui-input-block\" style=\"margin:10px\"><input type=\"checkbox\" name=\"service_port\" value=\"1\" title=\"客户端端口\" checked=\"\">客户端端口<input type=\"checkbox\" name=\"service_port\" value=\"2\" title=\"服务器端端口\" style=\"margin-left: 50px\">服务器端端口</div><div class=\"addtz_sc\" onclick=\"sc(this)\"><img  src=\"${_resources}/TZ/img/shanchu_a.png\" alt=\"\"/></div></div></div>";   //自己定义好要添加的信息
            $(".xy_rule_content").append(html);  //添加对应的内容到table
        });
        $(".tz_span1").click(function(){
			var keyDivs=$("div .addtz").length;
            var html = "<div class=\"addtz\"><div class=\"tz_rule_right_label\"><label class=\"layui-form-label\">协议名称：</label><div><input type=\"text\" name=\"proId\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div class=\"tz_rule_right_label\" style=\"margin: 10px auto\"><label class=\"layui-form-label\">特征字：</label><div><input type=\"text\" name=\"keyword\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div><input style=\"margin:6px 10px 10px 100px;\" name=\"isCaseSensive_"+keyDivs+"\"  type=\"radio\"/>区分大小写</div><div class=\"addtz_sc\" onclick=\"sc(this)\"><img  src=\"${_resources}/TZ/img/shanchu_a.png\" alt=\"\"/></div></div>";   //自己定义好要添加的信息
            $(".tz_rule_content").append(html);  //添加对应的内容到table
        });
        $(".zz_span1").click(function(){
			var regexDivs=$("div .addzz").length;
            var html = "<div class=\"addzz\"><div class=\"zz_rule_right_label\"><label class=\"layui-form-label\">协议名称：</label><div><input type=\"text\" name=\"proId\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div class=\"zz_rule_right_label\" style=\"margin: 10px auto\"><label class=\"layui-form-label\">正规规则：</label><div><input type=\"text\" name=\"regex\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div><input style=\"margin:6px 10px 10px 100px;\" name=\"globalMatch_"+regexDivs+"\" type=\"radio\"/>全局匹配</div><div class=\"addzz_sc\" onclick=\"sc(this)\"><img  src=\"${_resources}/TZ/img/shanchu_a.png\" alt=\"\"/></div></div>";   //自己定义好要添加的信息
            $(".zz_rule_content").append(html);  //添加对应的内容到table
        });
        $(".dtk_span1").click(function(){
            var html = "<div class=\"adddtk\"><div class=\"dtk_rule_right_label\"><label class=\"layui-form-label\">协议名称：</label><div><input type=\"text\" name=\"proId\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div class=\"dtk_rule_right_label\" style=\"margin: 10px auto\"><label class=\"layui-form-label\">动态库文件：</label><div><input style=\"width: 580px\" type=\"text\" name=\"lib\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div class=\"shangchuan\"><a href=\"javascript:;\">上传文件</a></div><div class=\"adddtk_sc\" onclick=\"sc(this)\"><img  src=\"${_resources}/TZ/img/shanchu_a.png\" alt=\"\"/></div></div>";   //自己定义好要添加的信息
            $(".dtk_rule_content").append(html);  //添加对应的内容到table
        });
        $(".ym_span1").click(function(){
        	var DomainDivs=$("div .addym").length;
            var html = "<div class=\"addym\"><div class=\"ym_rule_right_label\"><label class=\"layui-form-label\">域名：</label><div><input type=\"text\" name=\"domain\" lay-verify=\"title\" autocomplete=\"off\" placeholder=\"\" class=\"layui-input\"></div></div><div class=\"ym\" style=\"margin:6px 10px 10px 100px;\"><input type=\"radio\" checked=\"\" name=\"type_"+DomainDivs+"\" value=\"1\" />精准域名<input style=\"margin-left:30px;\" name=\"type_"+DomainDivs+"\" value=\"2\" type=\"radio\"/>N级域名</div><div class=\"addym_sc\" onclick=\"sc(this)\"><img  src=\"${_resources}/TZ/img/shanchu_a.png\" alt=\"\"/></div></div>";   //自己定义好要添加的信息
            $(".ym_rule_content").append(html);  //添加对应的内容到table
        });
    });
    function dj(o) {//添加选中事件
        var $this = $(o);
        $this.addClass("on");
        if($this.siblings(".on").length>0){
            $this.siblings(".on").removeClass("on");
        };
    }
    function sc(o) {//点击删除   删除当前元素
        var $this = $(o).parent();
        $this.remove();
    }
	function getRuleParamData(){
		//获取所有ip规则数据
		
		
		
		
		var regex_rule="{'Regex_Rule':[";
		var iP_rule="{'IP_Rule':[";
		var key_rule="{'Key_Rule':[";
		var protocol_Rule="{'Protocol_Rule':[";
		var lib_rule="{'Lib_Rule':[";
		var domain_rule="{'Domain_Rule':[";
		
	 	var ipDivs = $("div .addip");
	 	//获取协议规则数据
		var proDivs=$("div .addxy");
		//获取特征规则
		var keyDivs=$("div .addtz");
		//获取正则规则
		var regexDivs=$("div .addzz");
		//获取域名规则
		var DomainDivs=$("div .addym");
		//获取动态库规则
		var libDivs=$("div .adddtk");
	 	
		$.each(ipDivs,function(index,item){
			var v4_v6 =$(item).find("input[name=v4_v6_"+index+"]:checked").val();
			var ipAddress = $(item).find("input[name=ipAddress]").val();
			var port_high = $(item).find("input[name=port_high]").val();
			var port_low = $(item).find("input[name=port_low]").val();
			var proId = $(item).find("input[name=proId]").val();
			var service_port =$(item).find("input[name=service_port]:checked");
			if(service_port.length==2){
				service_port="3";
			}else{
				service_port=$(item).find("input[name=service_port]:checked").val();
			}
			iP_rule+="{";
			iP_rule+="'"+v4_v6+"':"+"'"+ipAddress+"',";
			iP_rule+="'"+"Port_Rule"+"':{";
			iP_rule+="'LowPort':"+"'"+port_low+"',";
			iP_rule+="'HightPort':"+"'"+port_high+"',";
			//未处理
			iP_rule+="'Property':"+"'"+2+"',";
			iP_rule+="'Sign':"+"'"+service_port+"'";
			iP_rule+="}}";
			if(index !=($(ipDivs).length-1)){
				iP_rule+=",";
			}
		})
		iP_rule+="]}";
		
		
		
		$.each(proDivs,function(index,item){
			var port_high = $(item).find("input[name=port_high]").val();
			var port_low = $(item).find("input[name=port_low]").val();
			var proId = $(item).find("input[name=proId]").val();
			var service_port =$(item).find("input[name=service_port]:checked");
			if(service_port.length==2){
				service_port="3";
			}else{
				service_port=$(item).find("input[name=service_port]:checked").val();
			}
			protocol_Rule
			protocol_Rule+="{";
			protocol_Rule+="'ProID':"+"'"+proId+"',";
			protocol_Rule+="'"+"Port_Rule"+"':{";
			protocol_Rule+="'LowPort':"+"'"+port_low+"',";
			protocol_Rule+="'HightPort':"+"'"+port_high+"',";
			//未处理
			protocol_Rule+="'Sign':"+"'"+service_port+"'";
			protocol_Rule+="}}";
			if(index !=($(proDivs).length-1)){
				protocol_Rule+=",";
			}
		})
		protocol_Rule+="]}";
		
		$.each(keyDivs,function(index,item){
			var proId = $(item).find("input[name=proId]").val();
			var keyword =$(item).find("input[name=keyword]").val();
			var isCaseSensive =$(item).find("input[name=isCaseSensive_"+index+"]").prop("checked");
			if(isCaseSensive == false){
				isCaseSensive="0";
			}else{
				isCaseSensive="1";
			}
			key_rule+="{";
			key_rule+="'IsCaseSensive':"+"'"+isCaseSensive+"',";
			key_rule+="'Keyword':"+"'"+keyword+"',";
			key_rule+="'ProID':"+"'"+proId+"'";
			key_rule+="}";
			if(index !=($(keyDivs).length-1)){
				key_rule+=",";
			}
		})
		key_rule+="]}";
		
		
		$.each(regexDivs,function(index,item){
			var proId = $(item).find("input[name=proId]").val();
			var keyword =$(item).find("input[name=regex]").val();
			//Property
			var globalMatch =$(item).find("input[name=globalMatch_"+index+"]").prop("checked");
			if(globalMatch == false){
				globalMatch="0";
			}else{
				globalMatch="1";
			}
			regex_rule+="{";
			regex_rule+="'Property':"+"'"+globalMatch+"',";
			regex_rule+="'Keyword':"+"'"+keyword+"',";
			regex_rule+="'ProID':"+"'"+proId+"'";
			regex_rule+="}";
			if(index !=($(regexDivs).length-1)){
				regex_rule+=",";
			}
		})
		regex_rule+="]}";
		
		$.each(DomainDivs,function(index,item){
			var domain = $(item).find("input[name=domain]").val();
			var type =$(item).find("input[name=type_"+index+"]:checked").val();
			domain_rule+="{";
			domain_rule+="'Domain':"+"'"+domain+"',";
			domain_rule+="'Type':"+"'"+type+"'";
			domain_rule+="}";
			if(index !=($(DomainDivs).length-1)){
				domain_rule+=",";
			}
		})
		domain_rule+="]}";
		
		$.each(libDivs,function(index,item){
			var lib = $(item).find("input[name=lib]").val();
			var proId = $(item).find("input[name=proId]").val();
			lib_rule+="{";
			lib_rule+="'Lib':"+"'"+lib+"',";
			lib_rule+="'ProID':"+"'"+proId+"'";
			lib_rule+="}";
			if(index !=($(libDivs).length-1)){
				lib_rule+=",";
			}
		})
		lib_rule+="]}";
		
		$("#regex_rule").val(regex_rule);
		$("#iP_rule").val(iP_rule);
		$("#key_rule").val(key_rule);
		$("#protocol_Rule").val(protocol_Rule);
		$("#lib_rule").val(lib_rule);
		$("#domain_rule").val(domain_rule);
		
	}
    
    
</script>
</html>