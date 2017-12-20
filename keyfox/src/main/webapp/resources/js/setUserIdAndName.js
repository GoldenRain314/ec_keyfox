function setUserIdAndName(stringJson,inputId){
	var obj = JSON.parse(stringJson);
	var userName = [];
	var userId = [];
	for(var i=0;i<obj.length;i++){
		userName.push(obj[i].userName);
		userId.push(obj[i].id);
	}
	$("#"+inputId+"_name").val(userName.join(","));
	$("#"+inputId+"_id").val(userId.join(","));
	if(inputId == 'project_manager'){
		getDepartment();
	}
}