package com.keyware.base.repository.mybatis.itf.help;

import com.keyware.base.repository.entity.help.HelpImages;

public interface HelpImagesMapper {
    int deleteByPrimaryKey(String id);

    int insert(HelpImages record);

    int insertSelective(HelpImages record);

    HelpImages selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(HelpImages record);

    int updateByPrimaryKeyWithBLOBs(HelpImages record);
}