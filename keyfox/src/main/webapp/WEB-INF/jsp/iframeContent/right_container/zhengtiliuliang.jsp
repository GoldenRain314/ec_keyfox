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
				<div id="connectionInfor" style="width: 1000px; height: 400px;"></div>
			</div>
			<div class="a5 fl">
				<div id="boundFlowPackageNum" style="width: 1000px; height: 400px;"></div>
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
	$.get('${_baseUrl}/drawing/packageNum', {"date" : "2017-12-10"}).done(function(data) {$(function () {
			    $('#packageNum').highcharts({
			      credits:{
			        enabled:false // 禁用版权信息
			      },
			      xAxis: {
			        type: 'datetime',
			        dateTimeLabelFormats: {
			          minute: '%H:%M',
			          day: '%e. %b'
			        }
			      },

			      chart: {
			        type: 'area',
			        zoomType: 'x'
			      },
			      title: {
			        text: '包数河流图'
			      },
			      subtitle: {
			        text: ''
			      },
			      yAxis: {
			        title: {
			          text: '个'
			        },
			        labels: {
			          formatter: function () {
			            return this.value;
			          }
			        }
			      },
			      tooltip: {
			        pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.percentage:.1f}%</b> ({point.y:,.0f} )<br/>',
			        shared: true
			      },
			      plotOptions: {
			        area: {
			          stacking: 'percent',
			          lineColor: '#ffffff',
			          lineWidth: 1,
			          marker: {
			            lineWidth: 1,
			            lineColor: '#ffffff'
			          }
			        }
			      },
			      series:data
			    });
			  });
	});

	<!--
	var appScale = echarts.init(document.getElementById('appScale'));
	$.get('${_baseUrl}/drawing/appScale', {
		"date" : "2017-12-10"
	}).done(function(data) {
		appScale.setOption({
			title : {
		        text: '应用比例',
		        x:'left'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'right',
		        data: ['APP_MAIL_SMTP','APP_RDP','APP_MAIL_POP','APP_NDPI_BITBORRENT','APP_MYSQL','APP_SSH','APP_SSL','APP_HTTP','APP_VOIP','APP_NDPI_EDONKEY']
		    },
		    series : data
		});
	});
	-->
	$.get('${_baseUrl}/drawing/connectionInfor', {
		"date" : "2017-12-10"
	}).done(function(data) {
		$('#connectionInfor').highcharts({
		      credits:{
		        enabled:false // 禁用版权信息
		      },
		      xAxis: {
		        type: 'datetime',
		        dateTimeLabelFormats: {
		          minute: '%H:%M',
		          day: '%e. %b'
		        }
		      },

		      chart: {
		        type: 'area',
		        zoomType: 'x'
		      },
		      title: {
		        text: '包数河流图'
		      },
		      subtitle: {
		        text: ''
		      },
		      yAxis: {
		        title: {
		          text: '个'
		        },
		        labels: {
		          formatter: function () {
		            return this.value;
		          }
		        }
		      },
		      tooltip: {
		        pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.percentage:.1f}%</b> ({point.y:,.0f} )<br/>',
		        shared: true
		      },
		      plotOptions: {
		        area: {
		          stacking: 'percent',
		          lineColor: '#ffffff',
		          lineWidth: 1,
		          marker: {
		            lineWidth: 1,
		            lineColor: '#ffffff'
		          }
		        }
		      },
		      series:data
		    });
	});
	
	
	
	$.get('${_baseUrl}/drawing/boundFlowPackageNum', {
		"date" : "2017-12-10"
	}).done(function(data) {
		console.info(data);
		$('#boundFlowPackageNum').highcharts({
		      credits:{
		        enabled:false // 禁用版权信息
		      },
		      xAxis: {
		        type: 'datetime',
		        dateTimeLabelFormats: {
		          minute: '%H:%M',
		          day: '%e. %b'
		        }
		      },

		      chart: {
		        type: 'area',
		        zoomType: 'x'
		      },
		      title: {
		        text: '边界流量-包数'
		      },
		      subtitle: {
		        text: ''
		      },
		      yAxis: {
		        title: {
		          text: '个'
		        },
		        labels: {
		          formatter: function () {
		            return this.value;
		          }
		        }
		      },
		      tooltip: {
		        pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.percentage:.1f}%</b> ({point.y:,.0f} )<br/>',
		        shared: true
		      },
		      plotOptions: {
		        area: {
		          stacking: 'percent',
		          lineColor: '#ffffff',
		          lineWidth: 1,
		          marker: {
		            lineWidth: 1,
		            lineColor: '#ffffff'
		          }
		        }
		      },
		      series:data
		    });
	});
</script>
</html>