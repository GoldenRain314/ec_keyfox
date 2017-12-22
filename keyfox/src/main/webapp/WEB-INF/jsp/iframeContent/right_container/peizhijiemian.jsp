<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title></title>
<link rel="stylesheet" href="${_resources}/TZ/layui/css/layui.css" media="all">
<script src='${_resources}/TZ/layui/layui.js' type='text/javascript'></script>
<%@ include file="/WEB-INF/jsp/common/tz.jsp"%>
<style type="text/css">
.layui-colla-icon {
	left: 98%
}

.layui-collapse {
	width: 99%;
	margin: auto;
	border: 0
}

.layui-colla-item {
	margin: 5px;
	border-radius: 5px
}

.layui-colla-content {
	border-top: 1px solid #ccc;
	background: #f2f2f2;
}

.layui-form-label {
	width: 140px;
	text-align: left;
	padding: 5px 15px;
}

.layui-input, .layui-textarea {
	width: 50%
}

.layui-input-block {
	line-height: 30px
}

input[type="checkbox"] {
	margin: 0px 0px 3px 1px
}

.layui-input-block input {
	margin:0 5px 0 20px;
}

.nwwd {
	overflow: hidden;
	margin: auto;
	width: 100%;
}

.nwwd_div1 {
	width: 49%;
	height: 100%;
	float: left
}

.nwwd_div1 span {
	margin-left: 20px
}

.nwwd_div_important {
	overflow: hidden;
	margin: auto;
	text-align: center
}

.nwwd_important_table1, .nwwd_important_table3 {
	width: 98%;
	height: 100%;
	float: left;
	margin-left: 0.5%
}

.nwwd_important_table1 thead th, .nwwd_important_table2 thead th {
	text-align: center;
	border: 1px solid #ccc;
	width: 45%;
	height: 40px
}

.nwwd_important_table3 thead th {
	text-align: center;
	border: 1px solid #ccc;
	height: 40px
}

.nwwd_important_table1 tbody tr td, .nwwd_important_table2 tbody tr td, .nwwd_important_table3 tbody tr td {
	text-align: center;
	border: 1px solid #ccc;
	width: 45%;
	height: 40px
}

.nwwd_important_table2 {
	width: 98%;
	height: 100%;
	border: 1px solid #ccc;
	float: left;
	margin-left: 2%
}

.nwwd_btn {
	text-align: center
}

.nwwd_btn a {
	display: inline-block;
	background: url("${_resources}/TZ/img/tianjia.png") no-repeat;
	width: 184px;
	height: 30px;
	line-height: 30px;
	color: #fff;
	margin-top: 20px
}

.btn_a a {
	display: inline-block;
	width: 200px;
	height: 40px;
	line-height: 40px;
	text-align: center;
	background: #007DDB;
	color: #fff;
	border-radius: 4px;
	margin-left: 20px
}

.btn_a {
	margin-top: 10px
}
.layui-input-block select{width:50%;height: 36px;font-size: 12px;line-height: 10px;padding-bottom:5px\9;border: solid 1px #d6d6d6;appearance:none;  -moz-appearance:none;  -webkit-appearance:none;background: url("${_resources}/TZ/img/input_xiala.png") no-repeat  98% center ;  border-radius: 4px;}
</style>
<script type="text/javascript">
	//判断是否是数字
	function is_number(event,obj){
 		//IE 中 Event 对象使用 keyCode 获得键入字符的 Unicode 编码
		//DOM 中 Event 对象 使用 charCode 获得键入字符的 Unicode 编码
		//alert(event.keyCode+""+"-------------"+$(obj).val()+"-------------"+event.charCode)
		var char_code = "";
 		//火狐用event.charCode获取键值，IE用event.keyCode获取键值
		char_code = (undefined==event.charCode || 0==event.charCode) ? event.keyCode : event.charCode;
 		if($(obj).val()==0){
 			$(obj).val("");
 		}
		//(48-57[数字0-9])、(8[backspace])、(37\39[左右方向])、(46[del])
		if(!((char_code>=48&&char_code<=57)||char_code==8||char_code==46||char_code==37||char_code==39)){
			return false;
		} else {
			return true;
		}
	}
	var config = "";
	$(function (){

		$.ajax({
			url : "${_baseUrl}/tzController/getConfig",
			type : "post",
			dataType : "json",
			async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
	  		//data : {taskIds : taskIds.join(',')},
	  		data : $("#form1").serialize(),
			success : function(data) {
				config = data;
				var pfring = config.pfring;
				var connect = config.connect;
				var connectInfor = config.connectInfor;
				var lanProbe = config.lanProbe;
				var tileraFrame = config.tileraFrame;
				var extract = config.extract;
				var intraNet = config.intraNet;
				var keepOrder = config.keepOrder;
				var port53 = config.port53;
				var protocolAnalyse = config.protocolAnalyse;
				var extract_HTTP_Title = config.extract_HTTP_Title;
				
				var Interface = pfring.interface;
				//网卡
				for(var i=0; i<Interface.length; i++){
					var checkVal = Interface[i];
					//console.info(checkVal);
					$(":checkbox[name='PFRing.Interface'][value='"+checkVal+"']").attr('checked', 'checked');
				}
				//线程数量
				$(":text[name='PFRing.ThreadNum']").val(pfring.threadNum);
				//日志刷新率（timeInterval）
				$(":text[name='PFRing.RenewInterval_Sec']").val(pfring.renewInterval_Sec);
				//连接（isIP，isUDP，synsign）
				if(connect.isIP==1){
					$(":checkbox[name='Connect.IsIP']").attr('checked', 'checked');
				}
				if(connect.isUDP==1){
					$(":checkbox[name='Connect.IsUDP']").attr('checked', 'checked');
				}
				/* if(connect.synsign==1){
					$(":checkbox[name='Connect.SYNSign'][value='1']").attr('checked', 'checked');
				} */
				$("select[name='Connect.SYNSign']").val(connect.synsign);
				$(":text[name='ConnectInfor.ConnectNum_IPv4']").val(connectInfor.connectNum_IPv4);
				$(":text[name='ConnectInfor.ConnectNum_IPv6']").val(connectInfor.connectNum_IPv6);
				
				/* 
				网络设置IntraNet_Check
				采集参数KeepOrder_Check
				协议分析ProtocolAnalyse_Check
				协议分析Extract_Check
				*/
				//网络设置
				if(null!=intraNet){
					//启用
					$(":checkbox[name='IntraNet_Check']").attr('checked', 'checked');
					//主机数量
					$(":text[name='IntraNet.IntraIPNum']").val(intraNet.intraIPNum);
					//内网MAC数量
					$(":text[name='IntraNet.MacNum_Extra']").val(intraNet.macNum_Intra);
					//Network、VIP
					if(null!=intraNet.vip){
						var vip = intraNet.vip;
						for(var i=0; i<vip.length; i++){
							var html = "<tr><td><input type='text' value='"+vip[i].ip+"'/></td><td><input type='text' value='255.255.255.255'/></td><td><div class='addtz_sc' onclick='sc(this)'><img  src='${_resources}/TZ/img/shanchu_a.png' alt=''/></div></td></tr>";
							$(".tr111").before(html);
						}
					}
					if(null!=intraNet.network){
						var network = intraNet.network;
						for(var i=0; i<network.length; i++){
							var html = "<tr><td><input type='text' value='"+network[i].ip+"'/></td><td><input type='text' value='"+network[i].mask+"'/></td><td><div class='addtz_sc' onclick='sc(this)'><img  src='${_resources}/TZ/img/shanchu_a.png' alt=''/></div></td></tr>";
							$(".tr111").before(html);
						}
					}
					if(null!=intraNet.dmz){
						var dmz = intraNet.dmz;
						for(var i=0; i<dmz.length; i++){
							var html = "<tr><td><input type='text' value='"+dmz[i].ip+"'/></td><td><input type='text' value='"+dmz[i].mask+"'/></td><td><div class='addtz_sc' onclick='sc(this)'><img  src='${_resources}/TZ/img/shanchu_a.png' alt=''/></div></td></tr>";
							$(".tr222").before(html);
						}
					}
					//DMZ
				}
				//采集参数
				//TCP保序
				if(null!=keepOrder){
					//启用
					$(":checkbox[name='KeepOrder_Check']").attr('checked', 'checked');
					//单个连接缓存包数
					$(":text[name='KeepOrder.PacketNum']").val(keepOrder.packetNum);
				}
				//协议分析
				if(null!=protocolAnalyse){
					//启用
					$(":checkbox[name='ProtocolAnalyse_Check']").attr('checked', 'checked');
					//异常协议保留 
					$(":checkbox[name='ProtocolAnalyse.AbnormalPro'][value='"+protocolAnalyse.abnormalPro+"']").attr('checked', 'checked');
					//TLS握手 
					$(":checkbox[name='ProtocolAnalyse.TLS_HandShake'][value='"+protocolAnalyse.tls_HandShake+"']").attr('checked', 'checked');
					//异常TTL
					if(null!=protocolAnalyse.abnormalIPTTL){
						$(":checkbox[name='AbnormalIPTTL_Check']").attr('checked', 'checked');
						$(":text[name='ProtocolAnalyse.AbnormalIPTTL']").val(protocolAnalyse.abnormalIPTTL);
					}
				}
				//日志提取
				if(null!=extract){
					//启用
					$(":checkbox[name='Extract_Check']").attr('checked', 'checked');
					//连接记录 
					$(":checkbox[name='Extract.IsConnect'][value='"+extract.isConnect+"']").attr('checked', 'checked');
					//DNS
					$(":checkbox[name='Extract.IsDNS'][value='"+extract.isDNS+"']").attr('checked', 'checked');
					//SSL
					$(":checkbox[name='Extract.IsTSL'][value='"+extract.isTSL+"']").attr('checked', 'checked');
					//HTTP
					$(":checkbox[name='Extract.IsHTTP'][value='"+extract.isHTTP+"']").attr('checked', 'checked');
				}
				//HTTP Title
				if(null!=extract_HTTP_Title){
					for(var i=0; i<extract_HTTP_Title.length; i++){
						//var html = "<tr><td><input type='text'/></td><td><input type='text' value=''/></td><td><div class='addtz_sc' onclick='sc(this)'><img  src='${_resources}/TZ/img/shanchu_a.png' alt=''/></div></td></tr>";
						var html = "<tr><td><input type='text' value='"+extract_HTTP_Title[i]+"'/></td><td><div class='addtz_sc' onclick='sc(this)'><img  src='${_resources}/TZ/img/shanchu_a.png' alt=''/></div></td></tr>";
						$(".tr333").before(html);
					}
				}
			},
			error:function(data){
				layer.msg("网络忙，请稍后重试");
			}
		});
		
		$("#submit").click(function (){
			/* $("#tableinfos").val(tableInfoIdsAll.join(","));
			if(!$('#task').validationEngine('validate')){
				layer.msg("表单未通过验证！");
				return;
			} */
			console.info($("#form1").serialize());
			//JSON.stringify(jsonObj);
			var VIP = new Array(); 
			var Network = new Array(); 
			var DMZ = new Array(); 
			var Extract_HTTP_Title = new Array(); 
			
			//网络设置选中
			if($(":checkbox[name='IntraNet_Check']").is(':checked')){
				var trs = $("#b1").children("tr");
				if(trs.length>1){
					for(var i=0; i<trs.length-1;i++){
						var tr = trs.eq(i);
						var inputs = tr.find("input");
						var input1 = $(inputs[0]).val();
						var input2 = $(inputs[1]).val();
						//console.info(input1);
						if("255.255.255.255" == input2){
							var v = new Object();
							v.IP = input1;
							VIP.push(v);
						}else{
							var v = new Object();
							v.IP = input1;
							v.Mark = input2;
							Network.push(v);
						}
					}
				}
				var trs_b2 = $("#b2").children("tr");
				if(trs_b2.length>1){
					for(var i=0; i<trs_b2.length-1;i++){
						var tr = trs_b2.eq(i);
						var inputs = tr.find("input");
						var input1 = $(inputs[0]).val();
						var input2 = $(inputs[1]).val();
						var v = new Object();
						v.IP = input1;
						v.Mark = input2;
						DMZ.push(v);
					}
				}
			}
			//参数采集选中
			if($(":checkbox[name='KeepOrder_Check']").is(':checked')){
				var trs_b3 = $("#b3").children("tr");
				if(trs_b3.length>1){
					for(var i=0; i<trs_b3.length-1;i++){
						var tr = trs_b3.eq(i);
						var inputs = tr.find("input");
						var input1 = $(inputs[0]).val();
						Extract_HTTP_Title.push(input1);
					}
				}
			}
			
			//JSON.stringify(jsonObj);
			/* var VIP = new Array(); 
			var Network = new Array(); 
			var DMZ = new Array(); 
			var Extract_HTTP_Title = new Array();  */
			
			/* console.info(VIP);
			console.info(Network);
			console.info(DMZ);
			console.info(Extract_HTTP_Title); */
			
			//return;
			$.ajax({
				url : "${_baseUrl}/tzController/addConfig",
				type : "post",
				dataType : "json",
				async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
		  		//data : {taskIds : taskIds.join(',')},
		  		data : $("#form1").serialize()+"&VIP="+JSON.stringify(VIP)+"&Network="+JSON.stringify(Network)+"&DMZ="+JSON.stringify(DMZ)+"&Extract_HTTP_Title="+JSON.stringify(Extract_HTTP_Title),//+"&Network=[{\"IP\": \"192.168.1.0\",\"Mask\": \"255.255.255.0\"},{\"IP\": \"192.168.20.0\",\"Mask\": \"255.255.255.0\"}]"
				success : function(data) {
					console.info(data);
				},
				error:function(data){
					layer.msg("网络忙，请稍后重试");
				}
			});
		});
	})
</script>
</head>
<body>
<form action="" id="form1">
	<div class="main">
		<div class="btn_a">
			<a href="javascript:;">启动采集</a> <a href="javascript:;">关闭采集</a> <a href="javascript:;">自动开启</a>
			<!-- <div>
				<form action="" id="form1">
					<input type="text" name="PFRing.ThreadNum" value="123213" />
					<input type="text" name="Connect.IsIP" value="192.168" />
					<input type="text" name="Connect.IsUDP" value="xxxx" />
				</form>
			</div> -->
					<input type="button" id="submit" value="提交"/>
		</div>
		<div class="layui-collapse">
			<div class="layui-colla-item">
				<h5 class="layui-colla-title">流量采集</h5>
				<div class="layui-colla-content layui-show">
					<div class="layui-form-item">
						<label class="layui-form-label">网卡：</label>
						<div class="layui-input-block">
							<input type="checkbox" name="PFRing.Interface" value="wlp1s0" title="网卡1">网卡1 
							<input type="checkbox" name="PFRing.Interface" value="wlp2s0" title="网卡2">网卡2 
							<input type="checkbox" name="PFRing.Interface" value="wlp3s0" title="网卡3">网卡3 
							<input type="checkbox" name="PFRing.Interface" value="wlp4s0" title="网卡4">网卡4
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">线程数量：</label>
						<div class="layui-input-block">
							<input type="text" name="PFRing.ThreadNum" autocomplete="off" class="layui-input" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,''); if(this.value>2147483647)this.value=2147483647}).call(this)" onblur="this.v();"/>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-colla-item">
				<h5 class="layui-colla-title">基本参数</h5>
				<div class="layui-colla-content">
					<div class="layui-form-item">
						<label class="layui-form-label">日志刷新频率：</label>
						<div class="layui-input-block">
							<input type="text" name="PFRing.RenewInterval_Sec" autocomplete="off" placeholder="200" class="layui-input" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,''); if(this.value>2147483647)this.value=2147483647}).call(this)" onblur="this.v();">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">链接：</label>
						<div class="layui-input-block">
							<!-- isIP，isUDP，synsign -->
							<input type="checkbox" value="1" onclick="return false;" checked="checked" disabled/>TCP组链接 
							<input type="checkbox" name="Connect.IsUDP" value="1" />UDP组链接 
							<input type="checkbox" name="Connect.IsIP" value="1" />IP非TCP/UDP组链接
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">TCP-SYN相应模式：</label>
						<div class="layui-input-block">
							<select name="Connect.SYNSign">
								<option value="0">保留</option>
								<option value="1">丢弃SYN请求</option>
								<option value="2">丢弃SYN请求及相应</option>
							</select>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">IPV4链接数量：</label>
						<div class="layui-input-block">
							<input type="text" name="ConnectInfor.ConnectNum_IPv4" autocomplete="off" class="layui-input" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,''); if(this.value>2147483647)this.value=2147483647}).call(this)" onblur="this.v();"/>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">IPV6链接数量：</label>
						<div class="layui-input-block">
							<input type="text" name="ConnectInfor.ConnectNum_IPv6" autocomplete="off" class="layui-input" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,''); if(this.value>2147483647)this.value=2147483647}).call(this)" onblur="this.v();"/>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-colla-item" style="position: relative">
				<h5 class="layui-colla-title">网络设置</h5>
				<div style="position: absolute; top: 10px; left: 150px">
					<input type="checkbox" name="IntraNet_Check"/> <a href="">启用</a>
				</div>
				<div class="layui-colla-content">
					<div class="layui-form-item">
						<label class="layui-form-label">主机数量：</label>
						<div class="layui-input-block">
							<input type="text" name="IntraNet.IntraIPNum" autocomplete="off" class="layui-input" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,''); if(this.value>2147483647)this.value=2147483647}).call(this)" onblur="this.v();"/>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">内网MAC数量：</label>
						<div class="layui-input-block">
							<input type="text" name="IntraNet.MacNum_Extra" autocomplete="off" class="layui-input" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,''); if(this.value>2147483647)this.value=2147483647}).call(this)" onblur="this.v();"/>
						</div>
					</div>
					<div class="nwwd">
						<div class="nwwd_div1">
							<span>内网网段</span>
							<div class="nwwd_div_important">
								<table class="nwwd_important_table1">
									<thead>
										<tr>
											<th>IP</th>
											<th>Mask</th>
											<th>操作</th>
										</tr>
									</thead>
									<tbody id="b1">
										<tr class="tr111">
											<td colspan="3" class="btn1" style="background: url(${_resources}/TZ/img/tianjia_a.png) no-repeat 98%"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="nwwd_div1">
							<span>DMZ网段</span>
							<div class="nwwd_div_important">
								<table class="nwwd_important_table2">
									<thead>
										<tr>
											<th>IP</th>
											<th>Mask</th>
											<th>操作</th>
										</tr>
									</thead>
									<tbody id="b2">
										<tr class="tr222">
											<td colspan="3" class="btn2" style="background: url(${_resources}/TZ/img/tianjia_a.png) no-repeat 98%"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-colla-item">
				<h5 class="layui-colla-title">采集参数</h5>
				<div class="layui-colla-content">
					<div class="layui-form-item" style="position: relative">
						<label class="layui-form-label">TCP保序：</label>
						<div style="position: absolute; left: 100px; top: 5px;">
							<input type="checkbox" name="KeepOrder_Check"/> <a href="">启用</a>
						</div>
						<div class="layui-input-block" style="margin-left: 170px">
							<div class="fl" style="margin-left: 15px">单个连接缓存包数</div>
							<input type="text" name="KeepOrder.PacketNum" autocomplete="off" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,''); if(this.value>2147483647)this.value=2147483647}).call(this)" onblur="this.v();"/>
						</div>
					</div>
					<div class="layui-form-item" style="position: relative">
						<label class="layui-form-label">协议分析：</label>
						<div style="position: absolute; left: 100px; top: 5px;">
							<input type="checkbox" name="ProtocolAnalyse_Check" /> <a href="">启用</a>
						</div>
						<div class="layui-input-block" style="margin-left: 170px">
							<input type="checkbox" name="ProtocolAnalyse.AbnormalPro" value="1">异常协议保留 
							<input type="checkbox" name="ProtocolAnalyse.TLS_HandShake" value="1" >TLS握手 
							<input type="checkbox" name="AbnormalIPTTL_Check" value="1">异常TTL
							<input type="text" name="ProtocolAnalyse.AbnormalIPTTL" autocomplete="off"  onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9-]+/,''); if(this.value>2147483647)this.value=2147483647}).call(this)" onblur="this.v();"/>
							<div style="display: inline-block">IP:TTL小于该值的IP包认为异常</div>
						</div>
					</div>
					<div class="layui-form-item" style="position: relative">
						<label class="layui-form-label">日志提取：</label>
						<div style="position: absolute; left: 100px; top: 5px;">
							<input type="checkbox" name="Extract_Check" /> <a href="">启用</a>
						</div>
						<div class="layui-input-block" style="margin-left: 170px">
							<input type="checkbox" name="Extract.IsConnect" value="1" title="">连接记录 
							<input type="checkbox" name="Extract.IsDNS" value="1" title="">DNS 
							<input type="checkbox" name="Extract.IsTSL" value="1" title="">SSL 
							<input type="checkbox" name="Extract.IsHTTP" value="1" title="">HTTP
						</div>
					</div>
					<div class="layui-form-item">
						<div class="nwwd">
							<div class="nwwd_div1">
								<span>HTTP Title</span>
								<div class="nwwd_div_important">
									<table class="nwwd_important_table3">
										<thead>
											<tr>
												<th style="width: 90%">HTTP 列表</th>
												<th style="width: 10%">操作</th>
											</tr>
										</thead>
										<tbody id="b3">
											<tr class="tr333">
												<td colspan="3" class="btn3" style="background: url(${_resources}/TZ/img/tianjia_a.png) no-repeat 98%"></td>
											</tr>
									</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>
</form>
</body>
<script type="text/javascript">
   layui.use(['element', 'layer'], function(){
        var element = layui.element;
        var layer = layui.layer;
        //监听折叠
        element.on('collapse(test)', function(data){
        });
    });
   $(function(){
       $(".btn1").click(function(){
           var html = "<tr><td><input type=\"text\"/></td><td><input type=\"text\" value=\"\"/></td><td><div class=\"addtz_sc\" onclick=\"sc(this)\"><img  src=\"${_resources}/TZ/img/shanchu_a.png\" alt=\"\"/></div></td></tr>";   //自己定义好要添加的信息
           
           var tr = $(".tr111").prev("tr");
           if(tr.length>0){
        	   var inputs = tr.find("input");
        	   if(""==$(inputs[0]).val() || ""==$(inputs[1]).val() ){
        		   return;
        	   }
           }
           $(".tr111").before(html);  //添加对应的内容到table
       });
   });
   $(function(){
       $(".btn2").click(function(){
           var html = "<tr><td><input type=\"text\"/></td><td><input type=\"text\" value=\"\"/></td><td><div class=\"addtz_sc\" onclick=\"sc(this)\"><img  src=\"${_resources}/TZ/img/shanchu_a.png\" alt=\"\"/></div></td></tr>";   //自己定义好要添加的信息
           
           var tr = $(".tr222").prev("tr");
           if(tr.length>0){
        	   var inputs = tr.find("input");
        	   if(""==$(inputs[0]).val() || ""==$(inputs[1]).val() ){
        		   return;
        	   }
           }
           $(".tr222").before(html);  //添加对应的内容到table
       });
   });
   $(function(){
       $(".btn3").click(function(){
           var html = "<tr><td><input type=\"text\"/></td><td><div class=\"addtz_sc\" onclick=\"sc(this)\"><img  src=\"${_resources}/TZ/img/shanchu_a.png\" alt=\"\"/></div></td></tr>";   //自己定义好要添加的信息
           
           var tr = $(".tr333").prev("tr");
           if(tr.length>0){
        	   var inputs = tr.find("input");
        	   if(""==$(inputs[0]).val()){
        		   return;
        	   }
           }
           $(".tr333").before(html);  //添加对应的内容到table
       });
   });
   function sc(o) {//点击删除   删除当前元素
       var $this = $(o).parent().parent();
       $this.remove();
   }

</script>
</html>