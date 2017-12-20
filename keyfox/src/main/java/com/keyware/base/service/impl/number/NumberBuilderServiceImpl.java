package com.keyware.base.service.impl.number;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.keyware.base.repository.entity.number.NumberBuilder;
import com.keyware.base.repository.mybatis.itf.number.NumberBuilderMapper;
import com.keyware.base.service.itf.number.NumberBuilderService;
import com.keyware.base.utils.Constant;

@Service("numberBuilderService")
public class NumberBuilderServiceImpl implements NumberBuilderService{

	@Autowired
	private NumberBuilderMapper numberBuilderMapper;
	
	//userNumber需要返回一个字符串，需要在此处转换一下
	@Override
	public String getUserNumber() {
		Integer userNumber = getNumber("user_code");
		if(userNumber == 1){
			return Constant.RULE_NUMBER+"0001";
		}else{
			return Constant.RULE_NUMBER+getStringNumber(userNumber);
		}
	}
	
	//获取编号，如果确认业务增加之后，数据库的编码再增加1
	@Override
	public Integer updateNumber(String codeType) {
		NumberBuilder numberBuilder = numberBuilderMapper.selectByPrimaryKey(codeType);
		if(numberBuilder == null){
			NumberBuilder numberBuilder2 = new NumberBuilder();
			if("seq_code".equals(codeType)){      //项目管理默认是1，其他从2开始
				numberBuilder2.setNumber(2);
			}else{
				numberBuilder2.setNumber(1);
			}
			numberBuilder2.setNumberId(codeType);
			numberBuilderMapper.insertSelective(numberBuilder2);
			if("seq_code".equals(codeType)){
				return 2;
			}
			return 1;
		}else{
			numberBuilder.setNumber(numberBuilder.getNumber()+1);
			numberBuilderMapper.updateByPrimaryKeySelective(numberBuilder);
			return numberBuilder.getNumber();	
		}
	}

	@Override
	public Integer getNumber(String codeType) {
		NumberBuilder numberBuilder = numberBuilderMapper.selectByPrimaryKey(codeType);
		if(numberBuilder == null){
			if("seq_code".equals(codeType)){      //项目管理默认是1，其他从2开始
				return 2;
			}
			return 1;
		}else{
			return numberBuilder.getNumber()+1;
		}
	}
	
	private String getStringNumber(Integer number) {
		String strNumber = number.toString();
		while(strNumber.length() < 4){
			strNumber = "0" + strNumber;
		}
		return strNumber;
	}

	@Override
	public boolean saveOrUpdateCustomerId(String customerId) {
		NumberBuilder numberBuilder = numberBuilderMapper.selectByPrimaryKey("customer_id");
		if(null == numberBuilder){   //如果不存在直接新增
			NumberBuilder numberBuilder2 = new NumberBuilder();
			numberBuilder2.setNumberId("customer_id");
			numberBuilder2.setNumber(Integer.parseInt(customerId));
			numberBuilderMapper.insertSelective(numberBuilder2);
		}else{
			numberBuilder.setNumber(Integer.parseInt(customerId));
			numberBuilderMapper.updateByPrimaryKeySelective(numberBuilder);
		}
		return true;
	}

	@Override
	public String getCustomerId() {
		NumberBuilder numberBuilder = numberBuilderMapper.selectByPrimaryKey("customer_id");
		if(numberBuilder != null){
			Integer customerId = numberBuilder.getNumber();
			return String.valueOf(customerId);
		}else{
			return "0";
		}
	}

}
