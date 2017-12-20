package com.keyware.base.service.impl.user;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.keyware.base.exception.ExpirationTimeException;
import com.keyware.base.exception.LoginForbiddenException;
import com.keyware.base.exception.MaxSessionException;
import com.keyware.base.exception.NoRelatedRolesException;
import com.keyware.base.exception.PasscodeErrorException;
import com.keyware.base.exception.SecuritySetException;
import com.keyware.base.repository.entity.Role;
import com.keyware.base.repository.entity.UserRole;
import com.keyware.base.repository.entity.department.Department;
import com.keyware.base.repository.entity.user.User;
import com.keyware.base.repository.mybatis.itf.UserRoleMapper;
import com.keyware.base.repository.mybatis.itf.user.UserMapper;
import com.keyware.base.service.itf.auditlog.AuditLogService;
import com.keyware.base.service.itf.department.DepartmentService;
import com.keyware.base.service.itf.number.NumberBuilderService;
import com.keyware.base.service.itf.user.UserService;
import com.keyware.base.task.util.AjaxMessage;
import com.keyware.base.utils.Constant;
import com.keyware.utils.DateUtils;
import com.keyware.utils.EncryptUtil;
import com.keyware.utils.IdGenerator;


@Service("userService")
public class UserServiceImpl implements UserService{

	@Autowired
	private UserMapper userMapper;
	
	@Autowired
	private UserRoleMapper userRoleMapper;
	
	@Autowired
	private NumberBuilderService numberBuilderService;
	
	@Autowired
	private DepartmentService departmentService;
	
	@Autowired
	private AuditLogService auditLogService; 
	
	@Override
	public int deleteByPrimaryKey(List<String> id) {
		return userMapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(User record) {
		record.setProjectSource(Constant.projectName);
		record.setIsSys("0");
		return userMapper.insert(record);
	}

	@Override
	public User selectByPrimaryKey(String id) {
		return userMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKey(User record) {
		return userMapper.updateByPrimaryKey(record);
	}

	@Override
	public User getCurrentUser() {
		//禁止cookie登陆方式
		if(SecurityUtils.getSubject().isRemembered() && !SecurityUtils.getSubject().isAuthenticated()){
			 return null;
		}
		String temp = (String)SecurityUtils.getSubject().getPrincipal();
		
		if(!StringUtils.hasText(temp)){
			return null;
		}
		return userMapper.selectUserByUserId((String)SecurityUtils.getSubject().getPrincipal(),Constant.projectName);
	}

	@Override
	public void login(String userId, String password, boolean isRemember,
			String ip, String sessionId) {
		UsernamePasswordToken upt = new UsernamePasswordToken(userId,password,isRemember);
		try{
			SecurityUtils.getSubject().login(upt);
			//修改用户最后登陆时间
			//updateUserLoginInfo((String)SecurityUtils.getSubject().getPrincipal(),new Date(),IP,sessionId);
		}catch(SecuritySetException aaaa){
			throw new SecuritySetException("安全设置重复,请联系开发商!");
		}catch ( UnknownAccountException uae ) {
			throw new UnknownAccountException("用户不存在!");
		} catch ( IncorrectCredentialsException ice ) {
			throw new IncorrectCredentialsException("密码错误，请重试!");
		} catch ( LockedAccountException lae ) {
			throw new LockedAccountException("用户被锁定，请联系管理员!");
		} catch ( DisabledAccountException dae ) {
			throw new DisabledAccountException("用户未启用，请联系管理员!");
		} catch ( LoginForbiddenException dae ) {
			throw new LoginForbiddenException("该用户已注销!");
		} catch ( NoRelatedRolesException dae ) {
			throw new NoRelatedRolesException("用户无权限!");
		} catch ( ExpirationTimeException dae ) {
			throw new ExpirationTimeException("用户超出非活跃规定时间，锁定用户!");
		} /*catch ( ExcessiveAttemptsException eae ) {
			throw new ExcessiveAttemptsException("尝试次数太多，请联系管理员!");
		}*/ catch (PasscodeErrorException pserror) {
			throw new PasscodeErrorException("密码已失效，无法登陆，请联系管理员!");
		}catch (MaxSessionException mse) {
			throw new MaxSessionException("平台同时在线人数已达到上限!");
		}catch (AuthenticationException ae){
			Logger.getLogger(UserServiceImpl.class.getName()).log(Level.SEVERE, null, ae);
			throw new AuthenticationException("未知错误,请联系开发商!");
		}
	}

	@Override
	public User selectUserByUserId(String userId) {
		return userMapper.selectUserByUserId(userId,Constant.projectName);
	}

	@Override
	public void logout() {
		try{
			Subject subject = SecurityUtils.getSubject();
			if (subject.isAuthenticated()) {
				subject.logout(); // session 会销毁，在SessionListener监听session销毁，清理权限缓存
			}
		}catch ( UnknownAccountException uae ) {
			throw new UnknownAccountException("用户不存在!");
		} catch ( IncorrectCredentialsException ice ) {
			throw new IncorrectCredentialsException("密码不正确!");
		} catch ( LockedAccountException lae ) {
			throw new LockedAccountException("用户被锁定了,请联系管理员!");
		} catch ( ExcessiveAttemptsException eae ) {
			throw new ExcessiveAttemptsException("尝试次数太多,请联系管理员!");
		}catch(AuthenticationException ae){
			Logger.getLogger(UserServiceImpl.class.getName()).log(Level.SEVERE, null, ae);
			throw new AuthenticationException("未知错误,请联系管理员!");
		}
		
	}

	@Override
	public int insertSelective(User record) {
		record.setProjectSource(Constant.projectName);
		record.setIsSys("0");
		return userMapper.insertSelective(record);
	}

	@Override
	public int updateByPrimaryKeySelective(User record) {
		return userMapper.updateByPrimaryKeySelective(record);
	}
	@Override
	public List<User> selectAll(String userId) {
		return userMapper.selectAll(userId,Constant.projectName);
	}
	@Override
	public int updateStatus(User record) {
		return userMapper.updateStatus(record);
	}

	@Override
	public int updateLock(User record) {
		// 
		return userMapper.updateLock(record);
	}
	@Override
	public List getUserIdName() {
		// 
		return userMapper.getUserIdName(Constant.projectName);
	}
	@Override
	public int updateLogout(List record) {
		// 
		return userMapper.updateLogout(record);
	}
	@Override
	public int recovery(List record) {
		// 
		return userMapper.recovery(record);
	}
	@Override
	public int updateByPrimaryUserId(User record) {
		record.setProjectSource(Constant.projectName);
		return userMapper.updateByPrimaryUserId(record);
	}

	@Override
	public List<User> selectLogOutUser(String userName) {
		return userMapper.selectLogOutUser(userName,Constant.projectName);
	}

	@Override
	public int unlock(List<?> record) {
		return userMapper.unlock(record);
	}

	@Override
	public List<User> pwdResetList(String userName) {
		return userMapper.pwdResetList(userName,Constant.projectName);
	}



	@Override
	public int delPwdResetList(List listId) {
		return userMapper.delPwdResetList(listId);
	}

	@Override
	public int count() {
		// 
		return userMapper.count(Constant.projectName);
	}

	@Override
	public int updateSort(User record) {
		record.setProjectSource(Constant.projectName);
		return userMapper.updateSort(record);
	}

	@Override
	public List<User> getAddRoleUserList(Role role) {
		role.setProjectSource(Constant.projectName);
		return userMapper.getAddRoleUserList(role);
	}

	@Override
	public void insertUserRole(UserRole userRole) {
		userRoleMapper.insert(userRole);
	}

	@Override
	public void deletetUserRole(UserRole userRole) {
		userRoleMapper.deletetUserRole(userRole);
		
	}

	@Override
	public void deleteUserRoleByUserId(String id) {
		userRoleMapper.deleteByUserId(id);
	}

	@Override
	public List<User> selectDepartUser(String departId) {
		return userMapper.selectDepartUser(departId,Constant.projectName);
	}

	@Override
	public Integer selectUserCountByDeptId(String deptId) {
		return userMapper.selectUserCountByDeptId(deptId,Constant.projectName);
	}

	@Override
	public List<User> selectByUserNumber(String userNumber) {
		return userMapper.selectByUserNumber(userNumber,Constant.projectName);
	}

	@Override
	public List<User> selectBySearch(String userName) {
		return userMapper.selectBySearch(userName,Constant.projectName);
	}

	@Override
	public List<User> selectByUserInfo(User user) {
		user.setProjectSource(Constant.projectName);
		return userMapper.selectByUserInfo(user);
	}

	@Override
	public List<User> selectAllUser() {
		return userMapper.selectAllUser(Constant.projectName);
	}

	@Override
	public void checkFirstRowName(AjaxMessage ajaxMessage, Sheet sheet) {
		//获取第一行,验证列
		Row row = sheet.getRow(0);
		List<String> columnName = new ArrayList<String>();
		columnName.add("用户账号*");
		columnName.add("员工编号*");
		columnName.add("姓名*");
		columnName.add("身份证号码");
		columnName.add("所属部门");
		columnName.add("电子邮件");
		columnName.add("性别");
		columnName.add("手机");
		columnName.add("办公电话");
		columnName.add("家庭电话");
		columnName.add("职务");
		if(null == row){
			ajaxMessage.setCode("0");
			ajaxMessage.setMessage("上传文档与批量导入平台用户的标准模板不一致，请下载excel模板进行编辑。");
		}else {
			for(int i=0;i<columnName.size();i++){
				Cell cell = row.getCell(i);
				String cellValue = getCellValue(cell);
				cellValue = cellValue.replaceAll(" ", "");
				if(!columnName.get(i).equals(cellValue)){
					ajaxMessage.setCode("0");
					ajaxMessage.setMessage("上传文档与批量导入平台用户的标准模板不一致，请下载excel模板进行编辑。");
					break;
				}
			}
		}
		
		
	}

	@Override
	public String insertUser(Sheet sheet,String sUserName,HttpServletRequest request) {
		int inserted = 0;
		int skip = 0;
		String userNames="";
		//行数
		int rowNum = sheet.getPhysicalNumberOfRows();
		//i=1 跳过第一行
		for(int i = 1;i<rowNum;i++){
			Row row = sheet.getRow(i);
			//登陆账号
			String userId = getCellValue(row.getCell(0));
			//员工编号  如果有则判断唯一如果为空则生成默认
			String userNumber = getCellValue(row.getCell(1));
			//姓名,验证长度
			String userName = getCellValue(row.getCell(2));
			
			if("".equals(userId) && "".equals(userName) && "".equals(userNumber))
				continue;
			
			if(!StringUtils.hasText(userId)){
				skip ++;
				continue;
			}
			if("".equals(userNumber)){
				skip++;
				continue;
			}
			if("".equals(userName)){
				skip++;
				continue;
			}
			
			//身份证号
			String idCard = getCellValue(row.getCell(3));
			
			//部门名称
			String departName = getCellValue(row.getCell(4));
			String departId = null;
			//邮箱
			String email = getCellValue(row.getCell(5));
			//性别
			String sex = getCellValue(row.getCell(6));
			Long sexLong = null;
			//手机
			String mobilePhone = getCellValue(row.getCell(7));
			//办公电话
			String officeTelephone = getCellValue(row.getCell(8));
			//家庭电话
			String homePhone = getCellValue(row.getCell(9));
			//职务
			String post = getCellValue(row.getCell(10));
			
			//验证长度过长问题
			if(userId.length() > 25 || userNumber.length() > 20 || userName.length() > 25 || email.length() > 100 || officeTelephone.length() > 50 || homePhone.length() > 50 || post.length() > 50 ){
				skip ++;
				continue;
			}
			
			//验证家庭电话和办公电话最少两个字符验证
			if(StringUtils.hasText(officeTelephone) && officeTelephone.length() < 2){
				skip++;
				continue;
			}
			
			//验证家庭电话和办公电话最少两个字符验证
			if(StringUtils.hasText(homePhone) && homePhone.length() < 2){
				skip++;
				continue;
			}
			
			
			//正则验证 手机 不为空的情况下验证
			if(StringUtils.hasText(mobilePhone)){
				// 邮箱验证规则
				String regEx = "\\d{11}";
				// 编译正则表达式
				Pattern pattern = Pattern.compile(regEx);
				// 忽略大小写的写法
				// Pattern pat = Pattern.compile(regEx, Pattern.CASE_INSENSITIVE);
				Matcher matcher = pattern.matcher(mobilePhone);
				// 字符串是否与正则表达式相匹配
				boolean rs = matcher.matches();
				if(rs == false){
					skip ++;
					continue;
				}
			}
			
			//正则验证 办公电话 不为空的情况下验证
			if(StringUtils.hasText(officeTelephone)){
				// 邮箱验证规则
				String regEx = "[0-9a-zA-Z\\_\\-\\(\\)]+";
				// 编译正则表达式
				Pattern pattern = Pattern.compile(regEx);
				// 忽略大小写的写法
				// Pattern pat = Pattern.compile(regEx, Pattern.CASE_INSENSITIVE);
				Matcher matcher = pattern.matcher(officeTelephone);
				// 字符串是否与正则表达式相匹配
				boolean rs = matcher.matches();
				if(rs == false){
					skip ++;
					continue;
					
				}
			}
			
			//正则验证 账号 不为空的情况下验证
			if(StringUtils.hasText(userId)){
				// 邮箱验证规则
				String regEx = "[0-9a-zA-Z\\_\\-\\(\\)]+";
				// 编译正则表达式
				Pattern pattern = Pattern.compile(regEx);
				// 忽略大小写的写法
				// Pattern pat = Pattern.compile(regEx, Pattern.CASE_INSENSITIVE);
				Matcher matcher = pattern.matcher(userId);
				// 字符串是否与正则表达式相匹配
				boolean rs = matcher.matches();
				if(rs == false){
					skip ++;
					continue;
					
				}
			}
			
			//正则验证 家庭电话不为空的情况下验证
			if(StringUtils.hasText(homePhone)){
				// 邮箱验证规则
				String regEx = "[0-9a-zA-Z\\_\\-\\(\\)]+";
				// 编译正则表达式
				Pattern pattern = Pattern.compile(regEx);
				// 忽略大小写的写法
				// Pattern pat = Pattern.compile(regEx, Pattern.CASE_INSENSITIVE);
				Matcher matcher = pattern.matcher(homePhone);
				// 字符串是否与正则表达式相匹配
				boolean rs = matcher.matches();
				if(rs == false){
					skip ++;
					continue;
					
				}
			}
			
			
			//正则验证 邮箱 不为空的情况下验证
			if(StringUtils.hasText(email)){
				// 邮箱验证规则
				String regEx = "([a-zA-Z0-9_-])+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+";
				// 编译正则表达式
				Pattern pattern = Pattern.compile(regEx);
				// 忽略大小写的写法
				// Pattern pat = Pattern.compile(regEx, Pattern.CASE_INSENSITIVE);
				Matcher matcher = pattern.matcher(email);
				// 字符串是否与正则表达式相匹配
				boolean rs = matcher.matches();
				if(rs == false){
					skip ++;
					continue;
					
				}
			}
			//校验身份证号
			if(StringUtils.hasText(idCard)){
				// 身份证验证规则
				Pattern pattern = Pattern.compile("(\\d{14}[0-9a-zA-Z])|(\\d{17}[0-9a-zA-Z])");  
				Matcher matcher = pattern.matcher(idCard);
				// 字符串是否与正则表达式相匹配
				boolean rs = matcher.matches();
				if(rs == false){ 
					skip ++;
					continue;
				}
			}
			
			//验证性别
			if(!"男".equals(sex) && !"女".equals(sex))
				sexLong = null;
			
			if("男".equals(sex))
				sexLong = 0L;
			if("女".equals(sex))
				sexLong = 1L;
			
			//验证登陆账号
			User user = new User();
			user.setUserId(userId);
			List<User> selectByUserId = userMapper.selectByUserId(userId,Constant.projectName);
			if(selectByUserId != null && selectByUserId.size() > 0){
				skip ++;
				continue;
			}
			
			//部门
			List<Department> selectByDeparmentName = departmentService.selectByDeparmentName(departName);
			if(selectByDeparmentName != null && selectByDeparmentName.size() > 0){
				departId = selectByDeparmentName.get(0).getId();
			}
			
			//用户编号
			if(StringUtils.hasText(userNumber)){
				user.setUserId(null);
				user.setUserNumber(userNumber);
				List<User> users = this.selectByUserNumber(userNumber);
				if(users != null && users.size() > 0){
					skip ++;
					continue;
				}
			}else{
				userNumber = numberBuilderService.getUserNumber();
				numberBuilderService.updateNumber("user_code");
			}
			user.setId(IdGenerator.uuid32());
			user.setUserId(userId);
			user.setUserName(userName);
			user.setPassword(EncryptUtil.md5("11AAaa"));
			user.setDepartId(departId);
			user.setUserCreationTime(DateUtils.getDate());
			user.setUserPwdModifTime(DateUtils.getDate());
			user.setUserStatus(0L);
			user.setUserLock(0L);
			user.setUserPwdError(0L);
			user.setUserPwdErrorDate(DateUtils.getDate());
			user.setPost(post);
			user.setEmail(email);
			user.setOfficeTelephone(officeTelephone);
			user.setUserNumber(userNumber);
			user.setIdCard(idCard);
			user.setMobilePhone(mobilePhone);
			user.setSex(sexLong);
			user.setHomePhone(homePhone);
			user.setLogout(0L);
			userNames+=userName+",";
			//user.setInitPwdTime(DateUtils.getDate());
			//批量添加用户时速度特别快，可能在1s中添加好几个用户，sort值可能相同，如果这些值在每页的最后或最前，在按顺序显示时有问题
			user.setSort(String.valueOf(Long.parseLong(DateUtils.getDateTimeInt())+i));
			user.setIsSys("0");
			this.insert(user);
			inserted ++;
		}
		 if(!"".equals(userNames) &&null!=userNames){
			String comments = sUserName + "新增了用户" +userNames.substring(0,userNames.length()-1);
			auditLogService.insertLog("批量添加人员", "用户列表", comments, request);
		 }	
		return "操作成功,添加"+inserted+"条数据,"+skip+"条数据未添加成功";
	}
	
	public String getCellValue(Cell cell) {
		String cellValue = "";
		if(cell == null)
			return cellValue;
		switch (cell.getCellType()) {
			case Cell.CELL_TYPE_STRING:     // 文本  
	            cellValue = cell.getRichStringCellValue().getString();  
	            break;  
	        case Cell.CELL_TYPE_NUMERIC:    // 数字、日期  
	            if (DateUtil.isCellDateFormatted(cell)) {  
	                cellValue = DateUtils.formatDateTime(cell.getDateCellValue());  
	            } else {  
	                cell.setCellType(Cell.CELL_TYPE_STRING);  
	                cellValue = String.valueOf(cell.getRichStringCellValue().getString());  
	            }  
	            break;  
	        case Cell.CELL_TYPE_BOOLEAN:    // 布尔型  
	            cellValue = String.valueOf(cell.getBooleanCellValue());  
	            break;  
	        case Cell.CELL_TYPE_BLANK: // 空白  
	            cellValue = cell.getStringCellValue();  
	            break;  
	        case Cell.CELL_TYPE_ERROR: // 错误  
	            cellValue = "错误";  
	            break;  
	        case Cell.CELL_TYPE_FORMULA:    // 公式  
	            // 得到对应单元格的公式  
	            //cellValue = cell.getCellFormula();  
	            // 得到对应单元格的字符串  
	            cell.setCellType(Cell.CELL_TYPE_STRING);  
	            cellValue = String.valueOf(cell.getRichStringCellValue().getString());  
	            break;  
	        default:  
	            cellValue = ""; 
			}
		return cellValue;
	}
}
