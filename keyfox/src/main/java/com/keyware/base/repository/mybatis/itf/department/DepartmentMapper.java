package com.keyware.base.repository.mybatis.itf.department;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.keyware.base.repository.entity.department.Department;
import com.keyware.base.vo.user.DepartmentVo;

public interface DepartmentMapper {
    int deleteByPrimaryKey(List listId);

    int insert(Department record);

    int insertSelective(Department record);

    Department selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Department record);

    int updateByPrimaryKey(Department record);
    
    List<Department> selectAll();
    
    List<Department> getParentId(@Param("parentId")String parentId,@Param("isSys")String isSys,@Param("projectSource")String projectSource);

	List<Department> getChildId(String nodeId);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectByDept
	 * @Description: 统计数据
	 * @param record
	 * @return
	 * @return List<Department>
	 */
	List<DepartmentVo> selectByDept(Department record);

	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectByDeparmentName
	 * @Description: 根据部门名称查询是否存在
	 * @param name
	 * @return
	 * @return List<Department>
	 */
	List<Department> selectByDeparmentName(@Param("deptName")String name,@Param("projectSource")String projectSource);
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: selectByparentId
	 * @Description: 查询部门下所有的子部门
	 * @param parentId
	 * @return
	 * @return List<Department>
	 */
	List<Department> selectByparentId(String parentId,String projectSource);
	
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
	
	
	
	
}