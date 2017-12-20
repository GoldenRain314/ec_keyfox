package com.keyware.base.service.itf.department;

import java.util.HashSet;
import java.util.List;

import com.keyware.base.repository.entity.department.Department;
import com.keyware.base.vo.user.DepartmentVo;

public interface DepartmentService {
 	int deleteByPrimaryKey(List listId);

    int insert(Department record);
    
	int insertSelective(Department record);

    Department selectByPrimaryKey(String id);

    List<DepartmentVo> selectByDept();
    List<Department> selectAll();
    int updateByPrimaryKey(Department record);
    /**
     * 
     *@author 申鹏飞
     *@title 查询所有的部门信息id,名称，上级部门
     *@param
     * @param id
     * @return
     *@date
     */
    List<Department> getParentId(String parentId,String isSys,String projectSource);
    /**
     * 
     *@author 申鹏飞
     *@title 查询所有的子部门信息
     *@param
     * @param parentId
     * @return
     *@date
     */

	List<Department> getChildId(String nodeId);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: setUserName
	 * @Description: 设置用户名
	 * @param department
	 * @return
	 * @return Department
	 */
	public Department setUserName(Department department);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectByDeparmentName
	 * @Description: 根据部门名称查询是否存在
	 * @param name
	 * @return
	 * @return List<Department>
	 */
	public List<Department> selectByDeparmentName(String deptName);
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectByparentId
	 * @Description: 查询部门下所有的子部门
	 * @param parentId
	 * @return
	 * @return List<Department>
	 */
	HashSet<String> selectByparentId(String parentId);
	
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectByDeparmentInfo
	 * @Description: 根据字段属性查询信息
	 * @param department
	 * @return  
	 * @return List<Department>
	 */
	List<Department> selectByDeparmentInfo(Department department);

	/**
	 *	@Title
	 *  @author 李涛
	 *  @param 
	 *  @date   2017年1月18日
	 *  @return List<Department>
	 */
	List<Department> selectByDeparmentInfoSelect(Department departmentSelect);



	int updateByPrimaryKeySelective(Department record);	
		

}
