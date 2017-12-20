<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <%@ include file="/WEB-INF/jsp/common/tz.jsp" %>
    <style type="text/css">
        .iden_top{width: 100%;border-bottom: 1px solid #ccc;height: 37px; line-height: 35px;}
        .iden_top ul li{height: 37px; line-height: 35px; cursor: pointer;width: auto;padding: 0px 10px; background-color: #eee;float: left;border-radius: 5px 5px 0px 0px;border: 1px solid #ccc;margin-bottom: -1px; }
        .iden_add{float: left;margin-top: -9px;cursor: pointer; display: inline-block;text-align: center;font-size: 25px;width: 40px; height:36px;color: #2B98FC; font-weight: bold; background-color: #eee; border: 1px solid #ccc;border-radius: 5px 5px 0px 0px;}
        .iden_top_button{ display: inline-block;width: 20px; height: 20px; background-image: url(../img/xiug.png);background-repeat: no-repeat;background-size: 100%;margin: 7px 0px 0px 5px;float: left;}
        .iden_top_dete{float: right; width: 20px; height: 20px; background-image: url(../img/close.png);background-repeat: no-repeat;background-size: 100%;margin: 7px 0px 0px 5px;float: right;}
        .iden_add_name{float: left; }
        .data_z_create_box{display: none; width: 600px; min-height: 200px; background-color: #fff; border: 1px solid #ccc; border-radius: 5px; position: absolute;z-index:44; top: 10%;left: 50%;margin-left: -300px;box-shadow: 0px 5px 10px #666}
        .data_z_create_box_center_quxiao{background-color: #ea5d5b;color: #fff;margin-right:10px; width: auto!important;padding: 0px 10px;}
        .data_z_create_box_center_quxiao:hover{background-color: #d2322d;}
        .data_tips{padding: 10px; width: 90%; margin: 0px auto; color: #a94442;background-color: #f2dede;border:1px solid #ebccd1;border-radius: 5px;}
        .data_input{height: auto;padding:0px 30px;}
        .data_input ul li{height: 50px; line-height: 50px;}
        .data_input_input input{text-indent: 10px; width:70%; height: 40px; line-height: 40px; border-radius: 5px; border: 1px solid #ccc;}
        .data_input_tips{margin-left: 5%;display: none;}
        .data_z_create_box_top_title{margin-left: 20px;font-weight: bold;}
        .shua{margin-top: 20px;float: left;}
        .shua span{display: inline-block;width: 95%; float: right;}
        .data_state_buttonl_tips{color: #4CAE4C;font-weight: bold;display: none;}
    </style>
</head>
<body>
<div class="container iden_top">
    <ul>
        <li>
            <p class='iden_add_name'>应用标识1</p>
            <span class="iden_top_button"></span>
            <div class="iden_top_dete"></div>
        </li>
    </ul>
    <span class="iden_add">+</span>
</div>
　　　　<div class="data_z_create_box">
    <div class="create_z_create_box_top">
        <span class="data_z_create_box_top_title"></span>
        <div class="create_z_create_box_top_close">X</div>
    </div>
    <div class="create_z_create_box_center">
        <!--<div class="data_tips">
        </div>-->
        <div class="data_input">
            <ul>
                <li>
                    <!--<span class="data_input_title">应用标识：</span>
                    <span class="data_input_input"><input type="text" placeholder="应用标识1"></span>-->
                </li>
            </ul>
        </div>
    </div>
    <div class="create_z_create_box_button">
        <button class="create_z_create_box_center_quxiao">取消</button>
        <button class="create_z_create_box_center_baocun">保存</button>
        <button class="create_z_create_box_center_queding">确定</button>
    </div>
</div>
</body>
<script type="text/javascript">
    $(document).ready(function(e) {
        var $_div = $("<div class='_id_tips'>确认要删除此应用标识吗？</div>")
        var $_span1 = $("<span class='data_input_title'>应用标识：</span><span class='data_input_input'><input type='text' placeholder=''></span>")
        $(".iden_top ul li:eq(0)").css({
            "background-color": "#fff",
            "border-bottom": "1px solid #fff"
        }).children().removeClass("iden_top_dete");
        $(".iden_top ul li:eq(0)").children(".iden_add_name").addClass("ll")
        $(".iden_top_button").click(function() {
            $("#create_z").show()
            $(".data_z_create_box").show(300)
            $(".data_z_create_box_top_title").html("修改应用标识")
            $(".create_z_create_box_center_baocun").show();
            $(".create_z_create_box_center_queding").hide();
            $(".data_input ul li div").remove();
            $(".data_input ul li").append($_span1)
            $(".data_input_input input").val($(this).siblings(".iden_add_name").text())
            $(".create_z_create_box_center_quxiao").click(function() {
                $("#create_z").hide()
                $(".data_z_create_box").hide(300)
                $_span1.remove()
            })
            $(".create_z_create_box_center_baocun").click(function() {
                $("#create_z").hide()
                $(".data_z_create_box").hide(300)
                $(".ll").text($(this).parent().siblings().children().find("input").val())
                $_span1.remove()
            })
        })
        $(".create_z_create_box_top_close").click(function() {
            $("#create_z").hide()
            $(".data_z_create_box").hide(300)
            $_span1.remove()
        })
        var a = 2;
        $(".iden_add").click(function() {
            var clis = $(".iden_top ul li").length;
            if(clis <= 4) {
                var $_li = $("<li><p class='iden_add_name'>应用标识<span>" + a + "</span></p><span></span><div></div></li>");
                $(".iden_top ul").append($_li);
                $_li.css({
                    "background-color": "#fff",
                    "border-bottom": "1px solid #fff"
                }).children("div").addClass("iden_top_dete");
                $_li.children("span").addClass("iden_top_button")
                $_li.siblings().css({
                    "background-color": "#eee",
                    "border-bottom": "1px solid #ccc"
                }).children("div").removeClass("iden_top_dete");
                $_li.siblings().children("span").removeClass("iden_top_button");
                $_li.children(".iden_add_name").addClass("ll");
                $_li.siblings().children(".iden_add_name").removeClass("ll");
                $(".iden_top_dete").click(function() {
                    $(this).parent($_li).addClass("qq")
                    $("#create_z").show()
                    $(".data_z_create_box").show(300)
                    $(".data_z_create_box_top_title").html("提示")
                    $(".create_z_create_box_center_baocun").hide();
                    $(".create_z_create_box_center_queding").show();
                    $(".data_input ul li span").remove();
                    $(".data_input ul li").append($_div)
                })
                $(".create_z_create_box_center_quxiao").click(function() {
                    $("#create_z").hide()
                    $(".data_z_create_box").hide(300)
                    $_div.remove()
                    $(".iden_top ul li").removeClass("qq")
                })
                $(".create_z_create_box_center_queding").click(function() {
                    $(".qq").remove()
                    $("#create_z").hide()
                    $(".data_z_create_box").hide(300)
                    $_div.remove()
                    $(".iden_top ul li:eq(0)").css({
                        "background-color": "#fff",
                        "border-bottom": "1px solid #fff"
                    }).children("span").addClass("iden_top_button")
                })
                $(".iden_top_button").click(function() {
                    $("#create_z").show()
                    $(".data_z_create_box").show(300)
                    $(".data_z_create_box_top_title").html("修改应用标识")
                    $(".create_z_create_box_center_baocun").show();
                    $(".create_z_create_box_center_queding").hide();
                    $(".data_input ul li div").remove();
                    $(".data_input ul li").append($_span1)
                    $(".data_input_input input").val($(this).siblings(".iden_add_name").text())
                    $(".create_z_create_box_center_quxiao").click(function() {
                        $("#create_z").hide()
                        $(".data_z_create_box").hide(300)
                        $_span1.remove()
                    })
                    $(".create_z_create_box_center_baocun").click(function() {
                        $("#create_z").hide()
                        $(".data_z_create_box").hide(300)
                        $(".ll").text($(this).parent().siblings().children().find("input").val())
                        $_span1.remove()
                    })
                })
                $(".create_z_create_box_top_close").click(function() {
                    $("#create_z").hide()
                    $(".data_z_create_box").hide(300)
                    $_span1.remove()
                })
                clis++;
                a++;
            }
            $(".iden_top ul li").click(function() {
                $(this).css({
                    "background-color": "#fff",
                    "border-bottom": "1px solid #fff"
                }).children("div").addClass("iden_top_dete");
                $(this).children("span").addClass("iden_top_button")
                $(this).siblings().css({
                    "background-color": "#eee",
                    "border-bottom": "1px solid #ccc"
                }).children("div").removeClass("iden_top_dete");
                $(this).siblings().children("span").removeClass("iden_top_button");
                $(".iden_top ul li:eq(0)").children("div").removeClass("iden_top_dete");
                $(this).children(".iden_add_name").addClass("ll");
                $(this).siblings().children(".iden_add_name").removeClass("ll");
            })
        })
    })
</script>
</html>