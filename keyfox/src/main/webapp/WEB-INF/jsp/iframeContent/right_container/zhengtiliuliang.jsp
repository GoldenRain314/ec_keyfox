<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title></title>
<%@ include file="/WEB-INF/jsp/common/tz.jsp"%>
<style type="text/css">
</style>
</head>
<body>
	<div class="main">
		<div class="a1">
			
		</div>
		<div style="overflow: hidden">
			<div class="a2 fl">
				<div id="packageNum" style="width: 1000px; height: 400px;"></div>
			</div>
			<div class="a3 fl">
				<div id="appScale" style="width: 1000px; height: 400px;"></div>
			</div>
		</div>
		<div style="overflow: hidden">
			<div class="a4 fl">
				<img src="${_resources}/TZ/img/a4.png" alt="" />
			</div>
			<div class="a5 fl">
				<img src="${_resources}/TZ/img/a5.png" alt="" />
			</div>
		</div>
		<div style="overflow: hidden">
			<div class="a6 fl">
				<img src="${_resources}/TZ/img/a6.png" alt="" />
			</div>
			<div class="a7 fl">
				<img src="${_resources}/TZ/img/a7.png" alt="" />
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var packageNum = echarts.init(document.getElementById('packageNum'));
	$.get('${_baseUrl}/drawing/packageNum', {
		"date" : "2017-12-10"
	}).done(function(data) {
		console.info(data);
		packageNum.setOption({
			title : {
				text : '流量状态'
			},
			tooltip : {
				trigger : 'axis',
				axisPointer : {
					type : 'cross',
					label : {
						backgroundColor : '#6a7985'
					}
				}
			},
			legend : {
				data : data
			},
			toolbox : {
				feature : {
					saveAsImage : {}
				}
			},
			grid : {
				left : '3%',
				right : '4%',
				bottom : '3%',
				containLabel : true
			},
			xAxis : [ {
				type : 'time'
			} ],
			yAxis : [ {
				type : 'value',
				name : '字节数单位'
			} ],
			series : data
		});
	});

	var appScale = echarts.init(document.getElementById('appScale'));
	$.get('${_baseUrl}/drawing/appScale', {
		"date" : "2017-12-10"
	}).done(function(data) {
		console.info(data);
		appScale.setOption({
			title : {
		        text: '某站点用户访问来源',
		        subtext: '纯属虚构',
		        x:'left'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'right',
		        data: ['直接访问','邮件营销','联盟广告','视频广告','搜索引擎']
		    },
		    series : [
		        {
		            name: '访问来源',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
		                {value:335, name:'直接访问'},
		                {value:310, name:'邮件营销'},
		                {value:234, name:'联盟广告'},
		                {value:135, name:'视频广告'},
		                {value:1548, name:'搜索引擎'}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
		});
	});
</script>
</html>