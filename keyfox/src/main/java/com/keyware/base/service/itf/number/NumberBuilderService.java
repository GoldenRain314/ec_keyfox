package com.keyware.base.service.itf.number;

/**
 * 
 * 此类描述的是：   	生成编号
 * @author: 赵亚舟   
 * @version: 2016年7月5日 上午9:35:46
 */
public interface NumberBuilderService {

	/**
	 * 
	 * @author: 巨李岗
	 * @Title: getUserNumber(
	 * @Description: 获取userNumber
	 * @return
	 * @return String
	 */
	public String getUserNumber();
	
	/**
	 *
	 * @author: 巨李岗
	 * @Title: updateNumber
	 * @param  codeType
	 * @Description: 编号+1
	 * @return
	 * @return String
	 */
	public Integer updateNumber(String codeType);
	
	/**
	 * 
	 * @author: 巨李岗
	 * @Title: getNumber
	 * @param  codeType
	 * @Description: 获取+1后的编号
	 * @return
	 * @return String
	 */
	public Integer getNumber(String codeType);
	
	/**
	 * 客户标识的改变方式不同于其他参数
	 * @Description: 获取客户标识
	 * @author 巨李岗
	 * @date 2017年8月22日 下午4:45:25
	 * @param codeType
	 * @return Integer
	 */
	public String getCustomerId();
	
	/**
	 * 
	 * @Description: 保存或更新客户标识
	 * @author 巨李岗
	 * @date 2017年8月22日 下午4:48:51
	 * @param codeType
	 * @return Integer
	 */
	public boolean saveOrUpdateCustomerId(String customerId);
}
