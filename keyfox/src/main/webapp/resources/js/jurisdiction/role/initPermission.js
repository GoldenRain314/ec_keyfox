function initAllPermission(permissionString,userId){
	var permissionJson = eval('(' + permissionString + ')');
	var li = "";
	for(var parentMenu=0;parentMenu<permissionJson.length;parentMenu++){
		li += "<li>";
			li += "<div class=\"fl qxian_l qxian_l3 qxian_a_l\">";
				li += "<div class=\"qxian_xj\">";
					if(permissionJson[parentMenu].menuName == '安全管理' || permissionJson[parentMenu].menuName == '审计管理' || permissionJson[parentMenu].menuName == '授权管理'|| permissionJson[parentMenu].menuName == '组织管理'|| permissionJson[parentMenu].menuName == '用户管理'){
						if(userId == "sysadmin"){
							li += "<input onclick=\"selectAll(this.id)\" id=\""+permissionJson[parentMenu].menuId+"\" name=\"need_inv\" type=\"checkbox\" class=\"radioclass input\" value=\"1\"> "+permissionJson[parentMenu].menuName;
						}else{
							li += "<input onclick=\"selectAll(this.id)\" disabled=\"disabled\" id=\""+permissionJson[parentMenu].menuId+"\" name=\"need_inv\" type=\"checkbox\" class=\"radioclass input\" value=\"1\"> "+permissionJson[parentMenu].menuName;
						}
					}else{
						li += "<input onclick=\"selectAll(this.id)\" id=\""+permissionJson[parentMenu].menuId+"\" name=\"need_inv\" type=\"checkbox\" class=\"radioclass input\" value=\"1\"> "+permissionJson[parentMenu].menuName;
					}
				li += "</div>";
			li += "</div>";
			
			li += "<div class=\"fl qxian_r qxian_a_r\">";
			var parentPermission = permissionJson[parentMenu].permissions;
			if(parentPermission != undefined){
				for(var pp=0;pp<parentPermission.length;pp++){
					li += "<div class=\"qxian_xj\">";
						if(permissionJson[parentMenu].menuName == '安全管理' || permissionJson[parentMenu].menuName == '审计管理' || permissionJson[parentMenu].menuName == '授权管理'|| permissionJson[parentMenu].menuName == '组织管理'|| permissionJson[parentMenu].menuName == '用户管理'){
							if(userId == "sysadmin"){
								li += "<input onclick=\"checkFirst(this);\" name=\""+parentPermission[pp].menuId+"_chk\" id=\""+parentPermission[pp].permissionId+"\" type=\"checkbox\" value=\"2\"> "+parentPermission[pp].permissionName;
							}else{
								li += "<input onclick=\"checkFirst(this);\" disabled=\"disabled\" name=\""+parentPermission[pp].menuId+"_chk\" id=\""+parentPermission[pp].permissionId+"\" type=\"checkbox\" value=\"2\"> "+parentPermission[pp].permissionName;
							}
						}else{
							li += "<input onclick=\"checkFirst(this);\" name=\""+parentPermission[pp].menuId+"_chk\" id=\""+parentPermission[pp].permissionId+"\" type=\"checkbox\" value=\"2\"> "+parentPermission[pp].permissionName;
						}
					li += "</div>";
				}
			}
			li += "</div>";
			li += "<div class=\"clear\"></div>";
		li += "</li>";
		var childMenu = permissionJson[parentMenu].childMenu;
		if(childMenu != undefined){
			for(var cm=0;cm<childMenu.length;cm++){
				li += "<li>";
					li += "<div class=\"fl qxian_l qxian_l2 qxian_a2_l\">";
						li += "<div class=\"qxian_xj\">";
						if(permissionJson[parentMenu].menuName == '安全管理' || permissionJson[parentMenu].menuName == '审计管理' || permissionJson[parentMenu].menuName == '授权管理'|| permissionJson[parentMenu].menuName == '组织管理'|| permissionJson[parentMenu].menuName == '用户管理'){
							if(userId == "sysadmin"){
								li += "<input onclick=\"selectAll(this.id);checkFirst(this);\" name=\""+permissionJson[parentMenu].menuId+"_chk\" id=\""+childMenu[cm].menuId+"\" type=\"checkbox\" value=\"1\"> "+childMenu[cm].menuName;
							}else{
								li += "<input onclick=\"selectAll(this.id);checkFirst(this);\" disabled=\"disabled\" name=\""+permissionJson[parentMenu].menuId+"_chk\" id=\""+childMenu[cm].menuId+"\" type=\"checkbox\" value=\"1\"> "+childMenu[cm].menuName;
							}
						}else{
							li += "<input onclick=\"selectAll(this.id);checkFirst(this);\" name=\""+permissionJson[parentMenu].menuId+"_chk\" id=\""+childMenu[cm].menuId+"\" type=\"checkbox\" value=\"1\"> "+childMenu[cm].menuName;
						}
						li += "</div>";
					li += "</div>";
					li += "<div class=\"fl qxian_r qxian_a2_r\">";
					var permissionList = childMenu[cm].permissions;
					if(permissionList != undefined){
						for(var p=0;p<permissionList.length;p++){
							li += "<div class=\"qxian_xj\">";
							if(permissionJson[parentMenu].menuName == '安全管理' || permissionJson[parentMenu].menuName == '审计管理' || permissionJson[parentMenu].menuName == '授权管理'|| permissionJson[parentMenu].menuName == '组织管理'|| permissionJson[parentMenu].menuName == '用户管理'){
								if(userId == "sysadmin"){
									li += "<input onclick=\"selectAll(this.id);checkFirst(this);checkT(this);\" name=\""+childMenu[cm].menuId+"_chk\" id=\""+permissionList[p].permissionId+"\" type=\"checkbox\" value=\"2\"> "+permissionList[p].permissionName;
								}else{
									li += "<input onclick=\"selectAll(this.id);checkFirst(this);checkT(this);\" disabled=\"disabled\" name=\""+childMenu[cm].menuId+"_chk\" id=\""+permissionList[p].permissionId+"\" type=\"checkbox\" value=\"2\"> "+permissionList[p].permissionName;
								}
							}else{
								li += "<input onclick=\"selectAll(this.id);checkFirst(this);checkT(this);\" name=\""+childMenu[cm].menuId+"_chk\" id=\""+permissionList[p].permissionId+"\" type=\"checkbox\" value=\"2\"> "+permissionList[p].permissionName;
							}
							li += "</div>";
						}
					}
					li += "</div>";
					li += "<div class=\"clear\"></div>";
				li += "</li>";
				var threeChildMenu = childMenu[cm].childMenu;
				if(threeChildMenu != undefined){
					for(var tcm=0;tcm<threeChildMenu.length;tcm++){
						li += "<li>";
							li += "<div class=\"fl qxian_l qxian_l4 qxian_a3_l\">";
								li += "<div class=\"qxian_xj\" title=\""+threeChildMenu[tcm].menuName+"\">";
								if(permissionJson[parentMenu].menuName == '安全管理' || permissionJson[parentMenu].menuName == '审计管理' || permissionJson[parentMenu].menuName == '授权管理'|| permissionJson[parentMenu].menuName == '组织管理'|| permissionJson[parentMenu].menuName == '用户管理'){
									if(userId == "sysadmin"){
										li += "<input onclick=\"selectAll(this.id);checkFirst(this);checkT(this);\" name=\""+childMenu[cm].menuId+"_chk\" id=\""+threeChildMenu[tcm].menuId+"\" type=\"checkbox\" value=\"1\"> "+threeChildMenu[tcm].menuName;
									}else{
										li += "<input onclick=\"selectAll(this.id);checkFirst(this);checkT(this);\" disabled=\"disabled\" name=\""+childMenu[cm].menuId+"_chk\" id=\""+threeChildMenu[tcm].menuId+"\" type=\"checkbox\" value=\"1\"> "+threeChildMenu[tcm].menuName;
									}
								}else{
									li += "<input onclick=\"selectAll(this.id);checkFirst(this);checkT(this);\" name=\""+childMenu[cm].menuId+"_chk\" id=\""+threeChildMenu[tcm].menuId+"\" type=\"checkbox\" value=\"1\"> "+threeChildMenu[tcm].menuName;
								}
								li += "</div>";
							li += "</div>";
							li += "<div class=\"fl qxian_r qxian_a3_r\">";
							var threePermissionList = threeChildMenu[tcm].permissions;
							for(var tp=0;tp<threePermissionList.length;tp++){
								li += "<div class=\"qxian_xj\">";
								if(permissionJson[parentMenu].menuName == '安全管理' || permissionJson[parentMenu].menuName == '审计管理' || permissionJson[parentMenu].menuName == '授权管理'|| permissionJson[parentMenu].menuName == '组织管理'|| permissionJson[parentMenu].menuName == '用户管理'){
									if(userId == "sysadmin"){
										li += "<input onclick=\"checkFirst(this);checkT(this);checkThree(this);\" name=\""+threeChildMenu[tcm].menuId+"_chk\" id=\""+threePermissionList[tp].permissionId+"\" type=\"checkbox\" value=\"2\"> "+threePermissionList[tp].permissionName;
									}else{
										li += "<input onclick=\"checkFirst(this);checkT(this);checkThree(this);\" disabled=\"disabled\" name=\""+threeChildMenu[tcm].menuId+"_chk\" id=\""+threePermissionList[tp].permissionId+"\" type=\"checkbox\" value=\"2\"> "+threePermissionList[tp].permissionName;
									}
								}else{
									li += "<input onclick=\"checkFirst(this);checkT(this);checkThree(this);\" name=\""+threeChildMenu[tcm].menuId+"_chk\" id=\""+threePermissionList[tp].permissionId+"\" type=\"checkbox\" value=\"2\"> "+threePermissionList[tp].permissionName;
								}
								li += "</div>";
							}
							li += "</div>";
							li += "<div class=\"clear\"></div>";
						li += "</li>";
					}
				}
			}
		}
		
	}
	$("#menuUl").children("li").remove();
	$("#menuUl").append(li);
}

function checkedPermission(path,roleId){
	$.ajax({
		url : path,
		type : "post",
		dataType : "json",
		async : false,//** ！重要 同步请求。效果:ajax未进行则其他代码不运行
  		data : {roleId : roleId},
		success : function(json) {
			for(var i=0;i<json.length;i++){
				$("#"+json[i]).attr("checked","true")
			}
		},
		error:function(data){
			layer.msg("网络忙，请稍后重试");
		}
	});
}

function checkFirst(obj){
	var checkedCount = $("input[name='"+obj.name+"']:checked").length;
	/*$("input[name='"+obj.name+"']:checkbox").each(function (i){
		if($(this).is(":checked")){
			checkedCount ++;
		}
	});*/
	
	var string = obj.name;
	var split = string.split("_");
	if(checkedCount == 0){
		document.getElementById(split[0]).checked = 0;
		var checkedCountF = 0;
	}else if(checkedCount > 0){
		//$("#"+split[0]).attr("checked",true);
		document.getElementById(split[0]).checked = 1;
	}
}


function checkThree(obj){
	var threeName = obj.name;
	var threeSplit = threeName.split("_");
	if(threeSplit.length == 2){
		var twoId = threeSplit[0];
		var twoName = document.getElementById(threeSplit[0]).name;
		var firstSplit = twoName.split("_");
		if(firstSplit.length == 2){
			var fourName = document.getElementById(firstSplit[0]).name;
			var fourSplit = fourName.split("_");
			if(fourSplit.length == 2){
				var count = $("input[name="+fourName+"]:checked").length;
				/*$("input[name="+fourName+"]").each(function() {  
					if($(this).is(":checked")){
						count ++ ;
					}
				});*/
				
				if(count == 0){
					document.getElementById(fourSplit[0]).checked = 0;
				}else{
					document.getElementById(fourSplit[0]).checked = 1;
				}
			}
		}
	}
}

function selectAll(id,number){
	var checklist = document.getElementsByName (id+"_chk");
	if(document.getElementById(id).checked){
		for(var i=0;i<checklist.length;i++){
		   checklist[i].checked = 1;
		   var chkId = checklist[i].id;
		   var checklistChild = document.getElementsByName (chkId+"_chk");
		   for(var m=0 ; m<checklistChild.length; m++){    // 兼容ie浏览器_chang_0604
		  // for(var m in checklistChild){
			   checklistChild[m].checked = 1;
			   
			   //选中4级
			   var threeMenuId = checklistChild[m].id;
			   var threelistChild = document.getElementsByName (threeMenuId+"_chk");
			   for(var tm=0 ; tm<threelistChild.length; tm++){
			  // for(var tm in threelistChild){
				   threelistChild[tm].checked = 1;
			   }
			   
		   }
		}
	}else{
		for(var j=0;j<checklist.length;j++){
		   checklist[j].checked = 0;
		   var chkId = checklist[j].id;
		   //第三极菜单全部取消全选
		   var checklistChild = document.getElementsByName(chkId+"_chk");
		   for(var m=0; m<checklistChild.length; m++){
		   //for(var m in checklistChild){
			   checklistChild[m].checked = 0;
			   
			   //选中4级
			   var threeMenuId = checklistChild[m].id;
			   var threelistChild = document.getElementsByName (threeMenuId+"_chk");
			   for(var tm=0; tm<threelistChild.length; tm++){
			   //for(var tm in threelistChild){
				   threelistChild[tm].checked = 0;
			   }
			   
		   }
		}
	}
}

function checkT(obj){
	var threeName = obj.name;
	var threeSplit = threeName.split("_");
	if(threeSplit.length == 2){
		var twoId = threeSplit[0];
		var twoName = document.getElementById(threeSplit[0]).name;
		
		var firstSplit = twoName.split("_");
		if(firstSplit.length == 2){
			var count = $("input[name="+twoName+"]:checked").length;
			/* $("input[name="+twoName+"]").each(function() {  
				if($(this).is(":checked")){
					count ++ ;
				}
			}); */
			if(count == 0){
				document.getElementById(firstSplit[0]).checked = 0;
			}else{
				document.getElementById(firstSplit[0]).checked = 1;
			}
		}
	}
}






