<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>左侧树结构</title>
    <%@ include file="/WEB-INF/jsp/common/tz.jsp" %>
    <script type="text/javascript">
        var setting = {
            view: {
                /*fontCss : {border:"0",background:"none","text-decoration":"none"},*/
                dblClickExpand: false,
                showIcon: true
            },
            data: {
                simpleData: {
                    enable: true
                }
            },
            callback: {
                onNodeCreated: this.onNodeCreated,
                onClick:onClick
            }
        };
        var zNodes =[
            { id:1, pId:0, name:"配置界面","menuUrl":"right_container/peizhijiemian"},
            { id:2, pId:0, name:"规则管理","menuUrl":"right_container/guizeguanli"},
        ];
        $(document).ready(function(){
            $.fn.zTree.init($("#treeDemo"), setting, zNodes);
        });
        function onClick(e,treeId, treeNode) {
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.expandNode(treeNode);
            var div = document.getElementById("templatelist");
            div.src ="${_baseUrl}/tzController/"+treeNode.menuUrl;
        }
    </script>
    <style type="text/css">
        .main_center{
            position:fixed;
            top:0;
            bottom:0;
            left:0;
            z-index:1000;
            width:110px;
            height:100%;
            overflow:auto;
            background: #f6f6f6;
        }
        .writing_doc_tree .ztree li .curSelectedNode span.node_name{color: #3f83ff}
        .writing_doc_tree .ztree li a{width: 110px;height:60px;line-height:60px}
        .writing_doc_tree .ztree span.node_name{padding: 0px}
        .writing_doc_tree .ztree li.level0 a.level0 #treeDemo_2_ico{display: none}
    </style>
</head>
<body>
<div class="main">
    <div id="main-center" class="zTreeDemoBackground main_center">
        <div class="writing_doc_tree">
            <ul id="treeDemo" class="ztree"></ul>
        </div>
    </div>
    <div id="main-right" class="main_right">
        <iframe id="templatelist" width='100%' height='100%' src="${_baseUrl}/tzController/right_container/peizhijiemian" frameborder="0">
        </iframe>
    </div>
</div>
</body>
<script type="text/javascript">
    var  resizeTimer = null;
    window.onload = function(){
        initWidth();
        initHeight();
    }
    window.onresize = function(){
        if(resizeTimer) clearTimeout(resizeTimer);
        resizeTimer = setTimeout("initHeight();initWidth();",100);
    }
    function initHeight(){
        var topH = 0;
        if(navigator.userAgent.indexOf("MSIE")>0 || navigator.userAgent.indexOf("like Gecko")>0) {//IE浏览器
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
        $("#main-center").css( "height",initheight +15);
        $("#main-right").css( "height",initheight-5);

    }
    function initWidth(){
        var oMaBox = document.getElementById("main-center");
        var topW = oMaBox.getBoundingClientRect().width;

        if(navigator.userAgent.indexOf("MSIE")>0 || navigator.userAgent.indexOf("like Gecko")>0) {//IE浏览器
            topW = oMaBox.clientWidth;
            initwidth = document.documentElement.clientWidth-topW;
        }
        if(navigator.userAgent.indexOf("Firefox")>0){//Firefox浏览器
            initwidth = document.documentElement.clientWidth-topW;
        }
        if(navigator.userAgent.indexOf("Opera")>0){//Opera浏览器
            initwidth = document.body.clientWidth-topW;
        }
        if(navigator.userAgent.indexOf("Chrome")>0){//Chrome谷歌浏览器
            initwidth = document.documentElement.clientWidth-topW;
        }
        if(navigator.userAgent.indexOf("Safari")>0){//Safari浏览器
            initwidth = document.documentElement.clientWidth-topW;
        }
        $("#main-right").css( {"width":initwidth,"position":"absolute","left":topW});
    }

</script>
</html>