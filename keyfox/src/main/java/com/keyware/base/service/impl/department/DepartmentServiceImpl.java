package com.keyware.base.service.impl.department;

import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.keyware.base.repository.entity.department.Department;
import com.keyware.base.repository.entity.user.User;
import com.keyware.base.repository.mybatis.itf.department.DepartmentMapper;
import com.keyware.base.service.itf.department.DepartmentService;
import com.keyware.base.service.itf.user.UserService;
import com.keyware.base.utils.Constant;
import com.keyware.base.vo.user.DepartmentVo;

@Service("departmentService")
public class DepartmentServiceImpl implements DepartmentService {

	@Autowired
	private DepartmentMapper departmentMapper;
	
	@Autowired
	private UserService userService;
	
	@Override
	public int deleteByPrimaryKey(List listId) {
		// 
		return departmentMapper.deleteByPrimaryKey(listId);
	}

	@Override
	public int insert(Department record) {
		record.setIsSys("0");
		record.setProjectSource(Constant.projectName);
		return departmentMapper.insert(record);
	}
    
	@Override
	public int insertSelective(Department record){
		record.setIsSys("0");
		record.setProjectSource(Constant.projectName);
		return departmentMapper.insertSelective(record);
	}
	
	@Override
	public Department selectByPrimaryKey(String id) {
		return departmentMapper.selectByPrimaryKey(id);
	}

	@Override
	public List<DepartmentVo> selectByDept() {
		Department department = new Department();
		return departmentMapper.selectByDept(department);
	}

	@Override
	public int updateByPrimaryKey(Department record) {
		// 
		return departmentMapper.updateByPrimaryKey(record);
	}

	@Override
	public List<Department> getParentId(String parentId,String isSys,String projectRsource) {
		// 
		return departmentMapper.getParentId(parentId, isSys, projectRsource);
	}

	@Override
	public List<Department> getChildId(String nodeId) {
		// 
		return departmentMapper.getChildId(nodeId);
	}

	@Transactional
	@Override
	public Department setUserName(Department department) {
		//部门负责人
		if(StringUtils.hasText(department.getCharge())){
			String chargeIds = department.getCharge();
			String[] split = chargeIds.split(",");
			String userName = "";
			for(String userId : split){
				User user = userService.selectByPrimaryKey(userId);
				if(user != null){
					userName += user.getUserName()+",";
				}
			}
			
			if(userName.length() > 1){
				userName = userName.substring(0, userName.length()-1);
				department.setChargeName(userName);
			}
		}
		
		//部门接口人
		if(StringUtils.hasText(department.getInterfacePerson())){
			String interfacePersonIds = department.getInterfacePerson();
			String[] split = interfacePersonIds.split(",");
			String userName = "";
			for(String userId : split){
				User user = userService.selectByPrimaryKey(userId);
				if(user != null){
					userName += user.getUserName()+",";
				}
			}
			
			if(userName.length() > 1){
				userName = userName.substring(0, userName.length()-1);
				department.setInterfacePersonName(userName);
			}
		}
		
		//上级主管领导
		if(StringUtils.hasText(department.getSuperLeader())){
			String superLeaderIds = department.getSuperLeader();
			String[] split = superLeaderIds.split(",");
			String userName = "";
			for(String userId : split){
				User user = userService.selectByPrimaryKey(userId);
				if(user != null){
					userName += user.getUserName()+",";
				}
			}
			
			if(userName.length() > 1){
				userName = userName.substring(0, userName.length()-1);
				department.setSuperLeaderName(userName);
			}
		}
		
		//部门管理人
		if(StringUtils.hasText(department.getManager())){
			String managerIds = department.getManager();
			String[] split = managerIds.split(",");
			String userName = "";
			for(String userId : split){
				User user = userService.selectByPrimaryKey(userId);
				if(user != null){
					userName += user.getUserName()+",";
				}
			}
			
			if(userName.length() > 1){
				userName = userName.substring(0, userName.length()-1);
				department.setManagerName(userName);
			}
		}
		return department;
	}

	@Override
	public List<Department> selectByDeparmentName(String deptName) {
		return departmentMapper.selectByDeparmentName(deptName,Constant.projectName);
	}

	@Override
	public HashSet<String> selectByparentId(String parentId) {
		HashSet<String> hashSet = new HashSet<String>();
		return this.recursionDeptId(hashSet, parentId);
	}
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: recursionDeptId
	 * @Description: 递归查询出所有子部门及子子部门
	 * @param hashSet
	 * @param parentId
	 * @return
	 * @return HashSet<String>
	 */
	private HashSet<String> recursionDeptId(HashSet<String> hashSet,String parentId){
		List<Department> selectByparentId = departmentMapper.selectByparentId(parentId,Constant.projectName);
		if(selectByparentId.size() == 0){
			hashSet.add(parentId);
			return hashSet;
		}else{
			for(Department department: selectByparentId){
				hashSet.add(department.getId());
				hashSet = this.recursionDeptId(hashSet, department.getId());
			}
		}
		return hashSet;
	}

	@Override
	public List<Department> selectByDeparmentInfo(Department department) {
		department.setProjectSource(Constant.projectName);
		return departmentMapper.selectByDeparmentInfo(department);
	}

	@Override
	public List<Department> selectAll() {
		return departmentMapper.selectAll();
	}

	@Override
	public List<Department> selectByDeparmentInfoSelect(
			Department departmentSelect) {
		return departmentMapper.selectByDeparmentInfoSelect(departmentSelect);
	}

	@Override
	public int updateByPrimaryKeySelective(Department record) {
		
		return departmentMapper.updateByPrimaryKeySelective(record);
	}
	
	
}
