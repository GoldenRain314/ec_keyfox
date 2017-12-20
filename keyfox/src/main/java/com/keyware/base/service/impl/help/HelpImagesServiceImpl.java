package com.keyware.base.service.impl.help;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.keyware.base.repository.entity.help.HelpImages;
import com.keyware.base.repository.mybatis.itf.help.HelpImagesMapper;
import com.keyware.base.service.itf.help.HelpImagesService;

@Service("helpImagesService")
public class HelpImagesServiceImpl implements HelpImagesService {

	@Autowired
	private HelpImagesMapper helpImagesMapper;
	
	@Override
	public int deleteByPrimaryKey(String id) {
		return helpImagesMapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(HelpImages record) {
		return helpImagesMapper.insert(record);
	}

	@Override
	public int insertSelective(HelpImages record) {
		return helpImagesMapper.insertSelective(record);
	}

	@Override
	public HelpImages selectByPrimaryKey(String id) {
		return helpImagesMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(HelpImages record) {
		return helpImagesMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKeyWithBLOBs(HelpImages record) {
		return helpImagesMapper.updateByPrimaryKeyWithBLOBs(record);
	}

}
