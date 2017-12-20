// JavaScript Document
$(function($){
	// 帮助左边目录树菜单
	(function(){
		$('.inactive').click(function(){
		if($(this).siblings('ul').css('display')=='none'){
			$(this).parent('li').siblings('li').removeClass('inactives');
			$(this).addClass('inactives');
			$(this).siblings('ul').slideDown(100).children('li');
			if($(this).parents('li').siblings('li').children('ul').css('display')=='block'){
				$(this).parents('li').siblings('li').children('ul').parent('li').children('a').removeClass('inactives');
				$(this).parents('li').siblings('li').children('ul').slideUp(100);

			}
			}else{
				//控制自身变成+号
				$(this).removeClass('inactives');
				//控制自身菜单下子菜单隐藏
				$(this).siblings('ul').slideUp(100);
				//控制自身子菜单变成+号
				$(this).siblings('ul').children('li').children('ul').parent('li').children('a').addClass('inactives');
				//控制自身菜单下子菜单隐藏
				$(this).siblings('ul').children('li').children('ul').slideUp(100);
	
				//控制同级菜单只保持一个是展开的（-号显示）
				$(this).siblings('ul').children('li').children('a').removeClass('inactives');
			}
		})
	})();
	
	// tab切换
	(function(){
		$('.wdang_tab a').bind('click',function(){
			var _this=$(this),_index=_this.index(),_datanavid=_this.data('navid');
			_this.addClass('wdtab_on').siblings('a').removeClass('wdtab_on');
			$('.wdang_cont').eq(_index).show().siblings('.wdang_cont').hide();
		});
	})();
	
	// iframe自适应高度
	(function(){
		var iframe_conta=$(window).height();
		$('.iframe_conta').height(iframe_conta-150)
		setSidebarHeight();
		$(window).resize(function(){
			setSidebarHeight();
        });
		
	})();
	
	//checkbox点击事件
	(function(){
		$(".piaochecked").on("click",function(){
			$(this).hasClass("on_check")? $(this).removeClass("on_check"):$(this).addClass("on_check");
		})

	})();
	
	// tab切换
	(function(){
		$('.xmugouj_tab a').bind('click',function(){
			var _this=$(this),_index=_this.index(),_datanavid=_this.data('navid');
			_this.addClass('xmugouj_tab_on').siblings('a').removeClass('xmugouj_tab_on');
			$('.xmugonj_cont').eq(_index).show().siblings('.xmugonj_cont').hide();
		});
	})();
	
	//登录页滚动条效果
	//if($(".land_scroll").size()>0){
	//$('.land_scroll').jScrollPane();
	//}
	
	
	if($(".list_roll").size()>0){
		$('.list_roll').jScrollPane();
	}
	if($(".list_rolla").size()>0){
		$('.list_rolla').jScrollPane();
	}
	if($(".list_rolla1").size()>0){
		$('.list_rolla1').jScrollPane();
	}
	if($(".list_rolla1a").size()>0){
		$('.list_rolla1a').jScrollPane();
	}
	if($(".list_rolla2").size()>0){
		$('.list_rolla2').jScrollPane();
	}
	if($(".list_rolla2a").size()>0){
		$('.list_rolla2a').jScrollPane();
	}
	if($(".zzjgs_sorll").size()>0){
		$('.zzjgs_sorll').jScrollPane();
	}
	if($(".mulu_jieg").size()>0){
		$('.mulu_jieg').jScrollPane();
	}
	if($(".treedemo_xqzz1").size()>0){
		$('.treedemo_xqzz1').jScrollPane();
	}
	if($(".treedemo_xqzz2").size()>0){
		$('.treedemo_xqzz2').jScrollPane();
	}
	if($(".xiugaixq_text").size()>0){
		$('.xiugaixq_text').jScrollPane();
	}
	if($(".section_t1").size()>0){
		$('.section_t1').jScrollPane();
	}
	if($(".xiugaixq_text2").size()>0){
		$('.xiugaixq_text2').jScrollPane();
	}
	
	
	
	
	
	var listWindowH=$(window).height();
	$('.list_roll').height(listWindowH-260);
	$('.list_rolla2').height(listWindowH-80);
	
	$('.help_list li:nth-child(2n)').css({
		'float':'right'
	})
	
	
	
	//响应式执行
	resizeWinPage();
	$(window).resize(function() {
		resizeWinPage();
	});
	
	
	

	
	
	
	
	
	
	
});

function resizeWinPage() {
    var w = $(window).width();
    if (w <= 1200) {
        $('body').attr('class', '').addClass('page_1200');
    }else{
			$('body').attr('class','');
		}

}
function setSidebarHeight(){
	var windwowH=$(window).height();
	var windwowW=$(window).width();
	$('.iframe_cont').height(windwowH-187);
	$('.iframe_yhgl').height(windwowH);
	$('.iframe_aa').height(windwowH-128);
	$('.iframe_aa1').height(windwowH-78);
}




