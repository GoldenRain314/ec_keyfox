$(function(){
	resizePosition();
	initH();
}) 

window.onresize = function(){
	setTimeout("initH()",200);
}

function initH(){
	var iframeH = $('#rightIframe', window.parent.document).height();
	$("body").height(iframeH);
	$("body").css("overflow-y","auto");
	$("html").css("overflow","hidden");
	
	$("#popIframe").load(function () {   
	    var mainheight = $(this).contents().find("body").height() + 30;
	    $(this).height(mainheight);
	});
}

function resizePosition(){
	$("#popIframe").load(function () { 
		var oObj = $(this).contents().find("input[type='text'],select");
		var oInput = $(this).contents().find("input[type='text']");
		var oTable = $(this).contents().find("table");
		
		if(oObj.length>3){
			oObj.each(function(){
		    	 $(this).attr("data-prompt-position","bottomLeft");
		    })
		}else{
			oObj.each(function(){
		    	 $(this).attr("data-prompt-position","bottomLeft");
		    	 $(this).css("width","460px");
		    })
		    oTable.each(function(){
				$(this).css("width","100%");
		    })
		}
		
		oInput.each(function(){
	    	var str = $(this).val();
	    	var size = 0;
	    	var width = 0;
	    	for(var i = 0; i<str.length; i++){
		    	size = textSize("14px", str[i]);
		    	width += size.width;
	    		if( width > $(this).width()-25){
		    		str = str.substring(0,i-1);
		    		$(this).attr('title',$(this).val());
		    		$(this).val(str + "...");
		    	}else{
		    		$(this).val(str);
		    	}
	    	}
	    })
	})
}
function textSize(fontSize, text) {
    var span = document.createElement("span");
    span.style.fontSize = fontSize; 
    span.style.visibility = "hidden";
    span.style.whiteSpace = "nowrap";
    var result = {};
    result.width = span.offsetWidth;
    result.height = span.offsetWidth; 
    
    document.body.appendChild(span);
    if (typeof span.textContent != "undefined")
        span.textContent = text;
    else span.innerText = text;
    
    result.width = span.offsetWidth - result.width;
    result.height = span.offsetHeight - result.height;
    span.parentNode.removeChild(span);
    return result;
}