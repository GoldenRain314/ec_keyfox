$(function(){
	BrowserType();
})

function BrowserType()  
  {  
      var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串  
      var isOpera = userAgent.indexOf("Opera") > -1; //判断是否Opera浏览器  
      var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera; //判断是否IE浏览器  
 
      if (isIE)   
      {  
           var reIE = new RegExp("MSIE (\\d+\\.\\d+);");  
           reIE.test(userAgent);  
           var fIEVersion = parseFloat(RegExp["$1"]);  
           if(fIEVersion == 8 || fIEVersion == 9 )  {    //兼容ie9浏览器
        	   clearCross();
           }  
       } 
}

function clearCross(){
	var str="<i class='clearCross'></i>"; 
	var str1="<i></i>";
	var obj = $("input[type='text']:enabled,input[type='password']:enabled");
	
	for( var i=0; i<obj.length; i++){
		if(obj.eq(i).prop('disabled') == false || obj.eq(i).prop('readonly') == false){
			obj.eq(i).wrap(str1);
			obj.eq(i).after(str);
			obj.eq(i).next().height(obj.eq(i).innerHeight()-6);
			obj.eq(i).next().width(obj.eq(i).innerWidth()/10+2);
			
			if(obj.eq(i).parent().parent().is("td")){
				obj.eq(i).parent().css({'display':'inline','position':'relative','width':'auto','height':'auto'});
			} else {
				obj.eq(i).parent().css({'display':'inline-block','position':'relative','width':'auto','height':'auto','float':'left'});
			} 
			
			if(obj.eq(i).hasClass('input_text1')){
				obj.eq(i).next().css({"background":"#fff","position":"absolute","right":"0","top":"0","margin-top":"3px","margin-right":"9px"});
			}else{
				obj.eq(i).next().css({"background":"#fff","position":"absolute","right":"0","top":"0","margin-top":"3px","margin-right":"5px"});
			}
		}
	}
	
}