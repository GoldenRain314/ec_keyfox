package com.keyware.utils;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

/**
 * 
 * 此类描述的是：   	
 * @author: 赵亚舟   
 * @version: 2016年6月11日 下午5:12:00
 */
public class BeanUtils {
	public static Map<String, Object> objectToClassFormMap(Object obj) {
		Map dataMap = new HashMap();
		try {
			String className = obj.getClass().getSimpleName();
			BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());
			for (PropertyDescriptor p : beanInfo.getPropertyDescriptors()) {
				String propertyName = p.getName();
				Method method = p.getReadMethod();
				Object propertyValue = method.invoke(obj, new Object[0]);
				dataMap.put(className + "_" + propertyName, propertyValue);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dataMap;
	}

	public static Map<String, Object> objectToMap(Object obj) {
		Map dataMap = new HashMap();
		try {
			BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());
			for (PropertyDescriptor p : beanInfo.getPropertyDescriptors()) {
				String propertyName = p.getName();
				Method method = p.getReadMethod();
				Object propertyValue = method.invoke(obj, new Object[0]);
				dataMap.put(propertyName, propertyValue);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dataMap;
	}

	public static Map<String, Object> objectToJsonMap(Object obj) {
		if ((obj instanceof Map)) {
			return (Map) obj;
		}
		Map hashMap = new HashMap();
		hashMap.put("success", Boolean.valueOf(true));
		try {
			Class c = obj.getClass();
			Method[] m = c.getDeclaredMethods();
			for (int i = 0; i < m.length; i++)
				if (m[i].getName().indexOf("get") == 0) {
					String propertyName = Character.toLowerCase(m[i].getName()
							.charAt(3)) + m[i].getName().substring(4);
					Object propertyVlaue = m[i].invoke(obj, new Object[0]);

					if ((propertyVlaue instanceof Date))
						hashMap.put(propertyName,
								DateUtils.getDateStr((Date) propertyVlaue));
					else if ((propertyVlaue instanceof Timestamp))
						hashMap.put(propertyName,
								DateUtils.getTimeStr((Date) propertyVlaue));
					else
						hashMap.put(propertyName, propertyVlaue);
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return hashMap;
	}

	public static <T> T mapToObject(Map<String, Object> map, Class<T> T) {
		BeanWrapper bw = new BeanWrapperImpl(T);
		try {
			PropertyDescriptor[] descriptors = bw.getPropertyDescriptors();
			for (int i = 0; i < descriptors.length; i++) {
				PropertyDescriptor descriptor = descriptors[i];
				String propertyName = descriptor.getName();
				Object propertyValue = map.get(propertyName);
				if ((propertyValue == null) || ("".equals(propertyValue))) {
					continue;
				}
				String propertyValueStr = "";
				if (((propertyValue instanceof Integer))
						|| ((propertyValue instanceof Long))
						|| ((propertyValue instanceof Boolean))
						|| ((propertyValue instanceof Float))
						|| ((propertyValue instanceof Double))
						|| ((propertyValue instanceof String))
						|| ((propertyValue instanceof Date))) {
					propertyValueStr = propertyValue.toString();
				}
				Class propertyTypeClass = descriptor.getPropertyType();
				String typeClassName = propertyTypeClass.getName();
				if (typeClassName.equals("java.lang.String")) {
					bw.setPropertyValue(propertyName, propertyValueStr);
				} else if ((typeClassName.equals("int"))
						|| (typeClassName.equals("java.lang.Integer"))) {
					Integer intValue = Integer.valueOf(propertyValueStr);
					bw.setPropertyValue(propertyName, intValue);
				} else if ((typeClassName.equals("long"))
						|| (typeClassName.equals("java.lang.Long"))) {
					Long longValue = Long.valueOf(propertyValueStr);
					bw.setPropertyValue(propertyName, longValue);
				} else if ((typeClassName.equals("boolean"))
						|| (typeClassName.equals("java.lang.Boolean"))) {
					Boolean boolValue = Boolean.valueOf(propertyValueStr);
					bw.setPropertyValue(propertyName, boolValue);
				} else if ((typeClassName.equals("float"))
						|| (typeClassName.equals("java.lang.Float"))) {
					Float floatValue = Float.valueOf(propertyValueStr);
					bw.setPropertyValue(propertyName, floatValue);
				} else if ((typeClassName.equals("double"))
						|| (typeClassName.equals("java.lang.Double"))) {
					Double doubleValue = Double.valueOf(propertyValueStr);
					bw.setPropertyValue(propertyName, doubleValue);
				} else if (typeClassName.equals("java.util.Date")) {
					Date dateValue = DateUtils
							.convertStringToDate(propertyValueStr);
					bw.setPropertyValue(propertyName, dateValue);
				} else if (!"0".equals(propertyValueStr)) {
					BeanWrapper propertybw = new BeanWrapperImpl(
							propertyTypeClass);
					if ((propertybw.isWritableProperty("id"))
							&& (!"0".equals(propertyValueStr)))
						propertybw.setPropertyValue("id",
								Long.valueOf(propertyValueStr));
					try {
						bw.setPropertyValue(propertyName,
								propertybw.getWrappedInstance());
					} catch (RuntimeException e) {
						bw.setPropertyValue(propertyName, null);
						e.printStackTrace();
					}
				} else {
					bw.setPropertyValue(propertyName, null);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return (T) bw.getWrappedInstance();
	}
	
	
}
