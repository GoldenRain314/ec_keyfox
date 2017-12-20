package com.keyware.base.repository.mybatis.itf.index;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.keyware.base.repository.entity.index.MessageTable;

public interface MessageTableMapper {
    int deleteByPrimaryKey(String messageId);

    int insert(MessageTable record);

    int insertSelective(MessageTable record);

    MessageTable selectByPrimaryKey(String messageId);

    int updateByPrimaryKeySelective(MessageTable record);

    int updateByPrimaryKey(MessageTable record);
    
    /**
     * 
     * @author: 赵亚舟
     * @Title: selectByInfo
     * @Description: 查询
     * @param record
     * @return
     * @return List<MessageTable>
     */
    List<MessageTable> selectByInfo(MessageTable record);
    /**
     * @author 代钢
     * @title：根据项目id删除数据
     * @param projectId,projectSource
     * @return
     */
    int deleteByProjectId(@Param("projectId")String projectId,@Param("projectSource")String projectSource);
}