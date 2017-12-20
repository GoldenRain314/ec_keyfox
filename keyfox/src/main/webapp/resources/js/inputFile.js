
$(function ()
{	
	inputFile();
});

function inputFile(){
	var oInput = $("input[type='file']");
	var str="<a class='file'>浏览</a>";
	var str1="<input type='text' class='jbxinxi_input' style=' overflow:hidden; white-space:norwap; text-overflow:ellipsis;' />";
	var str2="<div class='clear'></div>";
	var str3="<div class='jbxinxi_span1' style=' height:40px; line-height:27px;'>*</div>";
	
	for(var i=0; i<oInput.length; i++){
		oInput.eq(i).wrap(str);
		oInput.eq(i).parent().before(str1); 
		oInput.eq(i).parent().after(str2); 
		
		oInput.eq(i).parent().parent().width('auto');
		if(oInput.eq(i).parent().parent().next().html() == '*'){
			oInput.eq(i).parent().parent().next().hide();
			oInput.eq(i).parent().before(str3);
		}
	}
	
	oInput.each(function(){
		$(this).change(function(){
			var path = $(this).val();
			var pos1 = path.lastIndexOf('/');
			var pos2 = path.lastIndexOf('\\');
			var pos = Math.max(pos1, pos2);
			var fileName;
			if( pos<0 )
				fileName = path;
			else
				fileName = path.substring(pos+1); 
			if($(this).parent().parent().next().html() == "*"){
				$(this).parent().prev().prev('input').val(path);
				$(this).parent().prev().prev('input').attr('title',path);
			}else{
				$(this).parent().prev('input').val(path);
				$(this).parent().prev('input').attr('title',path);
			}
			
		})
	});
}
