package com.keyware.base.service.impl.shiro;

import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authc.credential.SimpleCredentialsMatcher;

import com.keyware.utils.EncryptUtil;

/**
 * 
 * 此类描述的是：   	验证密码
 * @author: 赵亚舟   
 * @version: 2016年6月14日 下午3:36:31
 */
public class CheckPassword extends SimpleCredentialsMatcher{
	 @Override  
     public boolean doCredentialsMatch(AuthenticationToken authcToken, AuthenticationInfo info) {  
         UsernamePasswordToken token = (UsernamePasswordToken) authcToken;  

         Object tokenCredentials = encrypt(String.valueOf(token.getPassword()));
         
         Object accountCredentials = getCredentials(info);  
         //将密码加密与系统加密后的密码校验，内容一致就返回true,不一致就返回false  
         return equals(tokenCredentials, accountCredentials);  
     } 
	 
	//将传进来密码加密方法  
     private String encrypt(String data) {  
         return EncryptUtil.md5(data);  
     }  
}
