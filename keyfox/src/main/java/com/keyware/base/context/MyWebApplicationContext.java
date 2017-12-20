package com.keyware.base.context;

import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.web.context.support.XmlWebApplicationContext;

/**
 * 
 * 此类描述的是：   
 * @author: 赵亚舟   
 * @version: 2016年6月8日 上午11:34:39
 */
public class MyWebApplicationContext extends XmlWebApplicationContext{

	@Override  
    protected DefaultListableBeanFactory createBeanFactory() {  
        DefaultListableBeanFactory beanFactory =  super.createBeanFactory();  
        beanFactory.setAllowRawInjectionDespiteWrapping(true);  
        return beanFactory;  
    }  
}
