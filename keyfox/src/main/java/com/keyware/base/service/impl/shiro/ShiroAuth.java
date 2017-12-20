package com.keyware.base.service.impl.shiro;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.keyware.base.repository.entity.user.User;
import com.keyware.base.repository.mybatis.itf.PermissionMapper;
import com.keyware.base.repository.mybatis.itf.user.UserMapper;
import com.keyware.base.service.itf.shiro.IShiroAuth;
import com.keyware.base.utils.Constant;


@Service("shiroAuth")
public class ShiroAuth implements IShiroAuth {
	
	@Autowired
	private UserMapper userMapper;
	
	@Autowired
	private PermissionMapper permissionMapper;
	
    @Override
    public User findSubject(String principals) {
    	User user = userMapper.selectUserExtByUserAccount(principals,Constant.projectName);
    	if(null != user && StringUtils.hasText(user.getUserId())){
    		//权限
    		user.setPermissions(this.permissionMapper.getPermissionByAccountId(user.getUserId(),Constant.projectName));
    	}
        return user;
    }
    
	@Override
	public User findSubjectByUser(String userId) {
		return userMapper.selectUserExtByUserIdForUser(userId,Constant.projectName);
	}
}
