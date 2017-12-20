package com.keyware.base.repository.mybatis.itf.number;

import com.keyware.base.repository.entity.number.NumberBuilder;

public interface NumberBuilderMapper {
    int deleteByPrimaryKey(String numberId);

    int insert(NumberBuilder record);

    int insertSelective(NumberBuilder record);

    NumberBuilder selectByPrimaryKey(String numberId);

    int updateByPrimaryKeySelective(NumberBuilder record);

    int updateByPrimaryKey(NumberBuilder record);
}