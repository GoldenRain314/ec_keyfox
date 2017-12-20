package com.keyware.base.service.itf;

import java.util.List;

public interface BaseService<T> {

	int deleteByPrimaryKey(String id);

    int insert(T record);

    int insertSelective(T record);

    T selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(T record);

    int updateByPrimaryKey(T record);
    
    List<T> selectByEntity(T record);

	void deleteBatch(String[] ids);
}
