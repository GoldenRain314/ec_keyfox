package com.keyware.utils;

import java.lang.reflect.Type;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * 
 * 此类描述的是：   json 工具类
 * @author: 赵亚舟   
 * @version: 2016年6月8日 下午1:49:59
 */
@SuppressWarnings("unchecked")
public class JsonUtils {
    private static final Log log = LogFactory.getLog(JsonUtils.class);    
    public static final String EMPTY = "";    
    /** 空的 {@code JSON} 数据 - <code>"{}"</code>。 */    
    public static final String EMPTY_JSON = "{}";    
    /** 空的 {@code JSON} 数组(集合)数据 - {@code "[]"}。 */    
    public static final String EMPTY_JSON_ARRAY = "[]";    
    /** 默认的 {@code JSON} 日期/时间字段的格式化模式。 */    
    public static final String DEFAULT_DATE_PATTERN = "yyyy-MM-dd HH:mm:ss";    
    /** {@code Google Gson} 的 {@literal @Since} 注解常用的版本号常量 - {@code 1.0}。 */    
    public static final Double SINCE_VERSION_10 = 1.0d;    
    /** {@code Google Gson} 的 {@literal @Since} 注解常用的版本号常量 - {@code 1.1}。 */    
    public static final Double SINCE_VERSION_11 = 1.1d;    
    /** {@code Google Gson} 的 {@literal @Since} 注解常用的版本号常量 - {@code 1.2}。 */    
    public static final Double SINCE_VERSION_12 = 1.2d;    
	/**
	 * List转换成json串
	 * @param menusParent
	 * @return
	 */
	public static String arrayListToJsonString(List menusParent){
		JSONArray jsonArray = new JSONArray(menusParent);
		return jsonArray.toJSONString();
	}
	
	/**
	 * 对象转换成json串
	 * @param menusParent
	 * @return
	 */
	public static String objectToJsonString(Object obj){
		return JSON.toJSON(obj).toString();
	}
	
	/**
	 * json串转换成对象
	 * @param jsonString
	 * @param obj
	 * @return
	 */
	public  static Object jsonStringToObject(String jsonString,Class clazz){
		
		return JSONObject.parseObject(jsonString,clazz);  
         
	}
	
	/**
	 * json串转换成List
	 * @param jsonString
	 * @param clazz
	 * @return
	 */
	public static List jsonStringToList(String jsonString,Class clazz){
		
		return JSON.parseArray(jsonString, clazz);
	}
    /**
     * list 转json
     * @param list
     * @return
     */
    public static <T> String listToJson(List<T> list){
    	Gson gson = new GsonBuilder()
    	.setDateFormat("yyyy-MM-dd HH:mm:ss")
    	.create();
    	return gson.toJson(list);
    }
    /**  
     * 将给定的目标对象转换成 {@code JSON} 格式的字符串。<strong>此方法只用来转换普通的 {@code JavaBean}  
     * 对象。</strong>  
     * <ul>  
     * <li>该方法只会转换标有 {@literal @Expose} 注解的字段；</li>  
     * <li>该方法不会转换 {@code null} 值字段；</li>  
     * <li>该方法会转换所有未标注或已标注 {@literal @Since} 的字段；</li>  
     * <li>该方法转换时使用默认的 日期/时间 格式化模式 - {@code yyyy-MM-dd HH:mm:ss SSS}；</li>  
     * </ul>  
     *   
     * @param target  
     *            要转换成 {@code JSON} 的目标对象。  
     * @return 目标对象的 {@code JSON} 格式的字符串。  
     */    
    public static String toJson(Object target) {    
        return toJson(target, null, false, null, null, false);    
    }   
    /**  
     * 将给定的目标对象根据指定的条件参数转换成 {@code JSON} 格式的字符串。  
     * <p />  
     * <strong>该方法转换发生错误时，不会抛出任何异常。若发生错误时，曾通对象返回 <code>"{}"</code>； 集合或数组对象返回  
     * <code>"[]"</code></strong>  
     *   
     * @param target  
     *            目标对象。  
     * @param targetType  
     *            目标对象的类型。  
     * @param isSerializeNulls  
     *            是否序列化 {@code null} 值字段。  
     * @param version  
     *            字段的版本号注解。  
     * @param datePattern  
     *            日期字段的格式化模式。  
     * @param excludesFieldsWithoutExpose  
     *            是否排除未标注 {@literal @Expose} 注解的字段。  
     * @return 目标对象的 {@code JSON} 格式的字符串。  
     */    
    public static String toJson(Object target, Type targetType,    
            boolean isSerializeNulls, Double version, String datePattern,    
            boolean excludesFieldsWithoutExpose) {    
        if (target == null)    
            return EMPTY_JSON;    
        GsonBuilder builder = new GsonBuilder();
        builder.disableHtmlEscaping();
        if (isSerializeNulls)    
            builder.serializeNulls();    
        if (version != null)    
            builder.setVersion(version.doubleValue());    
        if (StringUtils.isEmpty(datePattern))    
            datePattern = DEFAULT_DATE_PATTERN;    
        builder.setDateFormat(datePattern);
        if (excludesFieldsWithoutExpose)    
            builder.excludeFieldsWithoutExposeAnnotation();    
        String result = EMPTY;    
        Gson gson = builder.create();    
        try {    
            if (targetType != null) {    
                result = gson.toJson(target, targetType);    
            } else {    
                result = gson.toJson(target);    
            }    
        } catch (Exception ex) {    
            log.warn("目标对象 " + target.getClass().getName()    
                    + " 转换 JSON 字符串时，发生异常！", ex);    
            if (target instanceof Collection || target instanceof Iterator    
                    || target instanceof Enumeration    
                    || target.getClass().isArray()) {    
                result = EMPTY_JSON_ARRAY;    
            } else    
                result = EMPTY_JSON;    
        }    
        return result;    
    } 
    /**  
     * 将给定的 {@code JSON} 字符串转换成指定的类型对象。<strong>此方法通常用来转换普通的 {@code JavaBean}  
     * 对象。</strong>  
     *   
     * @param <T>  
     *            要转换的目标类型。  
     * @param json  
     *            给定的 {@code JSON} 字符串。  
     * @param clazz  
     *            要转换的目标类。  
     * @return 给定的 {@code JSON} 字符串表示的指定的类型对象。  
     */    
    public static <T> T fromJson(String json, Class<T> clazz) {    
        return fromJson(json, clazz, null);    
    }     
    
    /**  
     * 将给定的 {@code JSON} 字符串转换成指定的类型对象。<strong>此方法通常用来转换普通的 {@code JavaBean}  
     * 对象。</strong>  
     *   
     * @param <T>  
     *            要转换的目标类型。  
     * @param json  
     *            给定的 {@code JSON} 字符串。  
     * @param clazz  
     *            要转换的目标类。  
     * @param datePattern  
     *            日期格式模式。  
     * @return 给定的 {@code JSON} 字符串表示的指定的类型对象。  
     */    
    public static <T> T fromJson(String json, Class<T> clazz, String datePattern) {    
        if (StringUtils.isEmpty(json)) {    
            return null;    
        }    
        GsonBuilder builder = new GsonBuilder();    
        if (StringUtils.isEmpty(datePattern)) {    
            datePattern = DEFAULT_DATE_PATTERN;    
        }
        builder.setDateFormat(datePattern);
        Gson gson = builder.create();    
        try {    
            return gson.fromJson(json, clazz);    
        } catch (Exception ex) {    
            log.error(json + " 无法转换为 " + clazz.getName() + " 对象!", ex);    
            return null;    
        }    
    }    
}
