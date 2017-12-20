<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>添加问题</title>
</head>
<%@ include file="/WEB-INF/jsp/common/inc.jsp" %>
<script type="text/javascript" charset="utf-8" src="${_resources}utf8-jsp/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="${_resources}utf8-jsp/ueditor.all.min.js"> </script>
<script type="text/javascript" charset="utf-8" src="${_resources}utf8-jsp/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript">
var ue;
$(function (){
	UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;

	UE.getEditor('editor',{
	    //这里可以选择自己需要的工具按钮名称,此处仅选择如下五个
	    //toolbars:[['FullScreen','simpleupload','Source', 'Undo', 'Redo','Bold','test']],
	    //focus时自动清空初始化时的内容
	    autoClearinitialContent:true,
	    //关闭字数统计
	    wordCount:false,
	    //关闭elementPath
	    elementPathEnabled:false,
	    //默认的编辑区域高度
	    initialFrameHeight:300
	    //更多其他参数，请参考ueditor.config.js中的配置项
	});
	UE.Editor.prototype.getActionUrl = function(action) {
	        //这里很重要，很重要，很重要，要和配置中的imageActionName值一样
	        if (action == 'fileUploadServlet') {
	        //这里调用后端我们写的图片上传接口
	        return '${_baseUrl}/fileUploadServlet';
	    }else{
	         return this._bkGetActionUrl.call(this, action);
	    }
	}
	
	//实例化编辑器
	//建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
	ue = UE.getEditor('editor');
	ue.ready(function() {
        if("${id}" != null && "${id}" != ""){
    		getValue("${id}");
    	}
    });
	
})


function isFocus(e){
    alert(UE.getEditor('editor').isFocus());
    UE.dom.domUtils.preventDefault(e)
}
function setblur(e){
    UE.getEditor('editor').blur();
    UE.dom.domUtils.preventDefault(e)
}
function insertHtml() {
    var value = prompt('插入html代码', '');
    UE.getEditor('editor').execCommand('insertHtml', value)
}
function createEditor() {
    enableBtn();
    UE.getEditor('editor');
}
function getAllHtml() {
    alert(UE.getEditor('editor').getAllHtml())
}
function getContent() {
    var arr = [];
    arr.push("使用editor.getContent()方法可以获得编辑器的内容");
    arr.push("内容为：");
    arr.push(UE.getEditor('editor').getContent());
    alert(arr.join("\n"));
}
function getPlainTxt() {
    var arr = [];
    arr.push("使用editor.getPlainTxt()方法可以获得编辑器的带格式的纯文本内容");
    arr.push("内容为：");
    arr.push(UE.getEditor('editor').getPlainTxt());
    alert(arr.join('\n'))
}
function setContent(isAppendTo) {
    var arr = [];
    arr.push("使用editor.setContent('欢迎使用ueditor')方法可以设置编辑器的内容");
    UE.getEditor('editor').setContent('欢迎使用ueditor', isAppendTo);
    alert(arr.join("\n"));
}
function setDisabled() {
    UE.getEditor('editor').setDisabled('fullscreen');
    disableBtn("enable");
}

function setEnabled() {
    UE.getEditor('editor').setEnabled();
    enableBtn();
}

function getText() {
    //当你点击按钮时编辑区域已经失去了焦点，如果直接用getText将不会得到内容，所以要在选回来，然后取得内容
    var range = UE.getEditor('editor').selection.getRange();
    range.select();
    var txt = UE.getEditor('editor').selection.getText();
    alert(txt)
}

function getContentTxt() {
    var arr = [];
    arr.push("使用editor.getContentTxt()方法可以获得编辑器的纯文本内容");
    arr.push("编辑器的纯文本内容为：");
    arr.push(UE.getEditor('editor').getContentTxt());
    alert(arr.join("\n"));
}
function hasContent() {
    var arr = [];
    arr.push("使用editor.hasContents()方法判断编辑器里是否有内容");
    arr.push("判断结果为：");
    arr.push(UE.getEditor('editor').hasContents());
    alert(arr.join("\n"));
}
function setFocus() {
    UE.getEditor('editor').focus();
}
function deleteEditor() {
    disableBtn();
    UE.getEditor('editor').destroy();
}
function disableBtn(str) {
    var div = document.getElementById('btns');
    var btns = UE.dom.domUtils.getElementsByTagName(div, "button");
    for (var i = 0, btn; btn = btns[i++];) {
        if (btn.id == str) {
            UE.dom.domUtils.removeAttributes(btn, ["disabled"]);
        } else {
            btn.setAttribute("disabled", "true");
        }
    }
}
function enableBtn() {
    var div = document.getElementById('btns');
    var btns = UE.dom.domUtils.getElementsByTagName(div, "button");
    for (var i = 0, btn; btn = btns[i++];) {
        UE.dom.domUtils.removeAttributes(btn, ["disabled"]);
    }
}

function getLocalData () {
    alert(UE.getEditor('editor').execCommand( "getlocaldata" ));
}

function clearLocalData () {
    UE.getEditor('editor').execCommand( "clearlocaldata" );
    alert("已清空草稿箱")
}

/* 提交问题 */
function submit(){
	var qName = $("#qName").val();
	
	$.ajax({
		url : "${_baseUrl}/hq/insertQuestion",
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {name:qName,value:UE.getEditor('editor').getContent(),menuId:$("#menuId").val(),id:$("#id").val()},
		success : function(json) {
			layer.msg(json.message,{shift:5,time:1000},function(){
				
			});
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
}

/* 获取答案的html */
function getValue(qId){
	$.ajax({
		url : "${_baseUrl}/hq/getQuestionValue",
		type : "get",
		dataType : "text",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {qId:qId},
		success : function(json) {
			ue.execCommand('insertHtml', json)
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
}



</script>
<style type="text/css">
div{
    width:100%;
}
</style>
<body>
<div class="main_cont">
<div>
	问题名称:<input type="text" name="qName" id="qName" value="${qName }" />
	菜单:<select id="menuId">
			<c:forEach items="${menuList }" var="menu">
				<option value="${menu.menuId }" <c:if test="${menuId == menu.menuId }">selected="selected"</c:if> >${menu.menuName }</option>
			</c:forEach>
		</select>
	<input type="hidden" id="id" value="${id}" />
    <script id="editor" type="text/plain" style="width:93%;height:100%;"></script>
</div>
<div id="btns">
    <div>
    	<input type="button" value="提交" onclick="submit()"/>
        <!-- <button onclick="getAllHtml()">获得整个html的内容</button>
        <button onclick="getContent()">获得内容</button>
        <button onclick="setContent()">写入内容</button>
        <button onclick="setContent(true)">追加内容</button>
        <button onclick="getContentTxt()">获得纯文本</button>
        <button onclick="getPlainTxt()">获得带格式的纯文本</button>
        <button onclick="hasContent()">判断是否有内容</button>
        <button onclick="setFocus()">使编辑器获得焦点</button>
        <button onmousedown="isFocus(event)">编辑器是否获得焦点</button>
        <button onmousedown="setblur(event)" >编辑器失去焦点</button> -->

    </div>
    <!-- <div>
        <button onclick="getText()">获得当前选中的文本</button>
        <button onclick="insertHtml()">插入给定的内容</button>
        <button id="enable" onclick="setEnabled()">可以编辑</button>
        <button onclick="setDisabled()">不可编辑</button>
        <button onclick=" UE.getEditor('editor').setHide()">隐藏编辑器</button>
        <button onclick=" UE.getEditor('editor').setShow()">显示编辑器</button>
        <button onclick=" UE.getEditor('editor').setHeight(300)">设置高度为300默认关闭了自动长高</button>
    </div>

    <div>
        <button onclick="getLocalData()" >获取草稿箱内容</button>
        <button onclick="clearLocalData()" >清空草稿箱</button>
    </div> -->

</div>
<!--  <div>
    <button onclick="createEditor()">
    创建编辑器</button>
    <button onclick="deleteEditor()">
    删除编辑器</button>
</div> -->
</div>
</body>
</html>