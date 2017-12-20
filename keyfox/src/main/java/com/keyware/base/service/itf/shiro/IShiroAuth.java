package com.keyware.base.service.itf.shiro;


import com.keyware.base.repository.entity.user.User;

public interface IShiroAuth {
	User findSubject(String principals);
	
	User findSubjectByUser(String userId);
}
