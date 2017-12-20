package com.keyware.base.service.impl.shiro;

import java.text.ParseException;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.apache.shiro.authc.AccountException;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.SimpleAccountRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import com.keyware.base.exception.ExpirationTimeException;
import com.keyware.base.exception.LoginForbiddenException;
import com.keyware.base.exception.MaxSessionException;
import com.keyware.base.exception.NoRelatedRolesException;
import com.keyware.base.exception.PasscodeErrorException;
import com.keyware.base.exception.SecuritySetException;
import com.keyware.base.listener.SessionCounter;
import com.keyware.base.repository.entity.Permission;
import com.keyware.base.repository.entity.Role;
import com.keyware.base.repository.entity.safemanagement.SafeManagement;
import com.keyware.base.repository.entity.user.User;
import com.keyware.base.service.itf.auditlog.AuditLogService;
import com.keyware.base.service.itf.safemanagement.SafeManagementService;
import com.keyware.base.service.itf.shiro.IShiroAuth;
import com.keyware.base.service.itf.user.UserService;
import com.keyware.base.utils.Constant;
import com.keyware.utils.DateUtils;
import com.keyware.utils.EncryptUtil;


@Component("MyRealm")
public class MyRealm extends SimpleAccountRealm {

	@Autowired
	protected IShiroAuth shiroAuth;
	@Resource
	private UserService userService;
	@Resource
	private SafeManagementService safeManagementService;
	
	@Autowired
	private AuditLogService auditLogService;
	
	public MyRealm() {
		setName("MyRealm");
		/*PasswordService ps = new DefaultPasswordService();
		PasswordMatcherEx pme = new PasswordMatcherEx();
		pme.setPasswordService(ps);
		setCredentialsMatcher(pme);*/
	}

	@PostConstruct  
    public void initCredentialsMatcher() {  
		//该句作用是重写shiro的密码验证，让shiro用我自己的验证  
        setCredentialsMatcher(new CheckPassword());  
    }  
	
	
	
	@Override
	/**
	 * 权限验证
	 */
	public AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token)
			throws AuthenticationException {
		UsernamePasswordToken upt = (UsernamePasswordToken) token;
		String username = upt.getUsername();
		char[] pwd=upt.getPassword();
		String password=String.valueOf(pwd); 
		
		Integer sessionCount = Constant.sessionCount;
		if(0 != sessionCount){
			if(SessionCounter.getActiveSessions() >= sessionCount){
				throw new MaxSessionException("平台同时在线人数已达到上限");
			}
		}
		
		if (username == null) {
			throw new AccountException("用户名不能为空!");
		}
		
		User user = shiroAuth.findSubject(username);// 带角色权限菜单的
		if (user == null) {
			throw new UnknownAccountException("用户名不存在!");
		}
		
		//1.验证用户状态
		User userInfo=userService.selectUserByUserId(username);
		List<SafeManagement> safeManagements = safeManagementService.selectInfo();
		
		if(safeManagements.size() != 1){
			throw new SecuritySetException("安全设置重复,请联系开发商");
		}
		
		SafeManagement safeManagement = safeManagements.get(0);
		
		if (!username.equals("admin")&&userInfo!=null&&null != userInfo.getUserStatus() && 1==userInfo.getUserStatus()) {
			throw new DisabledAccountException("用户 [" + username + "] 未启用.");
		}
		
		//2.验证用户是否被锁定
		if (!username.equals("admin")&&userInfo!=null&&null != userInfo.getUserLock() && (1==userInfo.getUserLock()||"1".equals(userInfo.getUserLock()))) {
			throw new LockedAccountException("用户 [" + username + "] 已被锁定.");
		}
		
		if(1 == userInfo.getLogout()){
			throw new LoginForbiddenException("该用户已注销！");
		}
		
		if(!"admin".equals(user.getUserId()) && !"safesecret".equals(user.getUserId()) && !"safeaudit".equals(user.getUserId()) && !"sysadmin".equals(user.getUserId())){
			//验证密码是否失效
			Long pwdExpirationTime = safeManagement.getPwdExpirationTime();
			String userPwdModifTime = user.getUserPwdModifTime();
			try {
				long betweenDays = DateUtils.betweenDays(userPwdModifTime, DateUtils.getDate());
				if(betweenDays > pwdExpirationTime){
					throw new PasscodeErrorException("密码已失效");
				}
			} catch (ParseException e1) {
				e1.printStackTrace();
			}
		}
		
		
		//3.判断密码输入是否错误，错误后是否锁定用户
		if (!"sysadmin".equals(username) && !username.equals("admin")&&userInfo!=null&&(!EncryptUtil.md5(password).equals(userInfo.getPassword())&&userInfo.getPassword()!=EncryptUtil.md5(password))) {
			Long errorTime=userInfo.getUserPwdError();
			String errorDate=userInfo.getUserPwdErrorDate();
			if(errorDate!=null){
				//3.1当天有连续错误记录
				if(errorDate.equals(DateUtils.getDate())){
					errorTime+=1;
					long pwd_lockTimes=0;
					if(safeManagement!=null&&safeManagement.getPwdLocktimes()!=null&&!"".equals(safeManagement.getPwdLocktimes())){
						pwd_lockTimes=safeManagement.getPwdLocktimes();
					}
					if(pwd_lockTimes!=0){
						if(errorTime>=pwd_lockTimes){
							userInfo.setUserLock((long) 1);
							userService.updateByPrimaryKey(userInfo);
							throw new LockedAccountException("密码错误次数达到限定值"+pwd_lockTimes+",用户 [" + username + "] 已经被锁定.");
						}else{
							userInfo.setUserPwdError(errorTime);
							userInfo.setUserPwdErrorDate(DateUtils.getDate());
							userService.updateByPrimaryKey(userInfo);
							throw new IncorrectCredentialsException("用户 [" + username + "]密码不正确.");
						}
					}
				}else{
					//3.2当天第一次错误记录
					errorTime=(long) 1;
					errorDate=DateUtils.getDate();
					userInfo.setUserPwdError(errorTime);
					userInfo.setUserPwdErrorDate(errorDate);
					userService.updateByPrimaryKey(userInfo);
				}
			}else{
				//3.3当天第一次错误记录
				errorTime=(long) 1;
				errorDate=DateUtils.getDate();
				userInfo.setUserPwdError(errorTime);
				userInfo.setUserPwdErrorDate(errorDate);
				userService.updateByPrimaryKey(userInfo);
			}
		}
		
		//4.如果密码正确,清空错误记录
		if (userInfo!=null&&(EncryptUtil.md5(password).equals(userInfo.getPassword())||userInfo.getPassword()==EncryptUtil.md5(password))) {
			userInfo.setUserPwdError((long) 0);
			userInfo.setUserPwdErrorDate(null);
			userService.updateByPrimaryKey(userInfo);
		}
		
		//三员账号不做活跃时间判断
		if(!"admin".equals(user.getUserId()) && !"safesecret".equals(user.getUserId()) && !"safeaudit".equals(user.getUserId()) && !"sysadmin".equals(user.getUserId())){
			//5.验证用户是否超出非活跃时间
			if (!username.equals("admin")&&userInfo!=null&&safeManagement!=null&&safeManagement.getUserInactiveTime()!=null&&!"".equals(safeManagement.getUserInactiveTime())) {
				//5.1、获取非活跃时间限定值
				long userInactiveTime=safeManagement.getUserInactiveTime();
				//5.2获取上一次退出的时间
				String exitTime=user.getExitTime();
				//5.3本次登录的时间-上一次退出时间=非活动时间范围是否大于限定值
				//5.4判断是否锁定该用户
				if(userInactiveTime!=0&&!"".equals(exitTime)&&null!=exitTime){
					long between_days = 0;
					try {
						between_days = DateUtils.betweenDays(exitTime, DateUtils.getDate());
					} catch (ParseException e) {
						e.printStackTrace();
					}
					//5.6判断非活动时间范围是否大于限定值
					if(between_days>userInactiveTime){
						//5.7更新退出时间为当前时间，并锁定用户
						userInfo.setUserLock((long) 1);
						userService.updateByPrimaryKey(userInfo);
						throw new ExpirationTimeException("用户超出非活跃规定时间,锁定用户.");
					}
				}
				//5.7更新退出时间
				userInfo.setExitTime(DateUtils.getDate());
				userService.updateByPrimaryKey(userInfo);
			}
		}
		
		//6.验证是否有登陆权限 
		if (CollectionUtils.isEmpty(user.getRoles()) || !StringUtils.hasText(user.getRoles().get(0).getRoleId())) {
			throw new NoRelatedRolesException("用户 [" + username + "] 无权限");
		}
		
		SimpleAuthenticationInfo saInfo = new SimpleAuthenticationInfo(username, user.getPassword(), getName());
		
		return saInfo;
	}

	/**
	 * 授权
	 */
	@Override
	public AuthorizationInfo doGetAuthorizationInfo(
			PrincipalCollection principals) {
		User user = shiroAuth.findSubject(getUsername(principals));
		if (user instanceof User) {
			SimpleAuthorizationInfo sarpinfo = new SimpleAuthorizationInfo();
			//角色
			for (Role role : user.getRoles()) {
				sarpinfo.addRole(role.getRoleCode());
			}
			
			//权限
			if(!CollectionUtils.isEmpty(user.getPermissions())){
				for(Permission permission : user.getPermissions()){
					if(StringUtils.hasText(permission.getPermission())){
						sarpinfo.addStringPermission(permission.getPermission());
					}
				}
			}
			return sarpinfo;
		} else {
			return null;
		}
	}
}