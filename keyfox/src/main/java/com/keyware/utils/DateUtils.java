package com.keyware.utils;


import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * 此类描述的是：   	时间处理工具类
 * @author: 赵亚舟   
 * @version: 2016年6月11日 下午5:12:15
 */
public class DateUtils extends org.apache.commons.lang.time.DateUtils {
	private static Logger logger = LoggerFactory.getLogger(DateUtils.class);

	private static GregorianCalendar gc = new GregorianCalendar(Locale.CHINA);
	private static String[] parsePatterns;
	/**
	 * 格式化后 日期形式
	 */
	public static String DEFAULT_DATE_FORMAT = "yyyy-MM-dd";
	public static String getDate() {
		return getDate("yyyy-MM-dd");
	}

	public static String getDate(String pattern) {
		return DateFormatUtils.format(new Date(), pattern);
	}

	public static String formatDate(Date date, Object[] pattern) {
		String formatDate = null;
		if ((pattern != null) && (pattern.length > 0))
			formatDate = DateFormatUtils.format(date, pattern[0].toString());
		else {
			formatDate = DateFormatUtils.format(date, "yyyy-MM-dd");
		}
		return formatDate;
	}

	public static String formatDateTime(Date date) {
		return formatDate(date, new Object[] { "yyyy-MM-dd HH:mm:ss" });
	}

	public static String getTime() {
		return formatDate(new Date(), new Object[] { "HH:mm:ss" });
	}

	public static String getDateTime() {
		return formatDate(new Date(), new Object[] { "yyyy-MM-dd HH:mm:ss" });
	}

	public static String getYear() {
		return formatDate(new Date(), new Object[] { "yyyy" });
	}

	public static String getMonth() {
		return formatDate(new Date(), new Object[] { "MM" });
	}

	public static String getDay() {
		return formatDate(new Date(), new Object[] { "dd" });
	}

	public static String getWeek() {
		return formatDate(new Date(), new Object[] { "E" });
	}

	public static Date parseDate(Object str) {
		if (str == null)
			return null;
		try {
			return parseDate(str.toString(), parsePatterns);
		} catch (ParseException e) {
		}
		return null;
	}

	public static long pastDays(Date date) {
		long t = new Date().getTime() - date.getTime();
		return t / 86400000L;
	}

	public static Date getDateStart(Date date) {
		if (date == null) {
			return null;
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			date = sdf.parse(formatDate(date, new Object[] { "yyyy-MM-dd" })
					+ " 00:00:00");
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	public static Date getDateEnd(Date date) {
		if (date == null) {
			return null;
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			date = sdf.parse(formatDate(date, new Object[] { "yyyy-MM-dd" })
					+ " 23:59:59");
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	public static Date getCurrentDate() {
		Date date = new Date(System.currentTimeMillis());
		return date;
	}

	public static int getCurrentTime(TimeFormatType timeFormatType) {
		return getTime(getCurrentDate(), timeFormatType);
	}

	public static int getTime(Date date, TimeFormatType timeFormatType) {
		try {
			Calendar c = Calendar.getInstance();
			c.setTime(date);
			int type = timeFormatType.getValue();
			int i = c.get(type);
			return type == 2 ? i + 1 : i;
		} catch (Exception e) {
			throw new RuntimeException("获取失败", e);
		}
		
	}

	public static long getMillis(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.getTimeInMillis();
	}

	public static int operationDate(Date date, Date diffDate,
			DateOperationType dateOperationType) {
		long add = getMillis(date) + getMillis(diffDate);
		long diff = getMillis(date) - getMillis(diffDate);
		return (int) ((dateOperationType.getValue() ? add : diff) / 86400000L);
	}

	public static Date operationDateOfMonth(Date date, int month,
			DateOperationType dateOperationType) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(2, dateOperationType.getValue() ? month : month - month * 2);
		return c.getTime();
	}

	public static Date operationDateOfDay(Date date, int day,
			DateOperationType dateOperationType) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		long millis = c.getTimeInMillis();
		long millisOfday = day * 24 * 3600 * 1000;
		long sumMillis = dateOperationType.getValue() ? millis + millisOfday
				: millis - millisOfday;
		c.setTimeInMillis(sumMillis);
		return c.getTime();
	}

	private static Object OpearationDate(Object object, String formatStr) {
		if ((object == null) || (null == formatStr) || ("".equals(formatStr))) {
			throw new RuntimeException("参数不能为空");
		}
		SimpleDateFormat format = new SimpleDateFormat(formatStr);
		try {
			if ((object instanceof Date)) {
				return format.format(object);
			}
			return format.parse(object.toString());
		} catch (Exception e) {
			throw new RuntimeException("操作失败", e);
		}
		
	}

	public static Date getLastWorkDay(Date curDate, int n) {
		Date beginDate = curDate;
		Date endDate = curDate;
		for (int i = 0; i < n; i++) {
			endDate = new Date(endDate.getTime() - 86400000L);
			int day_of_week = getDayOfWeek(endDate).intValue();
			if (day_of_week == 1) {
				beginDate = endDate;
				endDate = new Date(endDate.getTime() - 172800000L);
			} else if (day_of_week == 7) {
				beginDate = endDate;
				endDate = new Date(endDate.getTime() - 86400000L);
			}
		}
		return endDate;
	}

	public static Integer getDayOfWeek(Date date) {
		Calendar cal = new GregorianCalendar();
		cal.setTime(date);
		return Integer.valueOf(cal.get(7));
	}

	private static void initCalendar(Date date) {
		if (date == null) {
			throw new IllegalArgumentException("argument date must be not null");
		}
		gc.clear();
		gc.setTime(date);
	}

	public static Date getAfterDate(Date date, int days) {
		initCalendar(date);
		gc.set(6, gc.get(6) + days);
		return gc.getTime();
	}

	public static boolean before(String first, String second) {
		SimpleDateFormat dfs = new SimpleDateFormat("yyyy-MM-dd");

		Date a = null;
		Date b = null;
		try {
			a = dfs.parse(first);
			b = dfs.parse(second);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return a.before(b);
	}

	public static final String getDateStr(Date aDate) {
		SimpleDateFormat df = null;
		String returnValue = "";

		if (aDate != null) {
			df = new SimpleDateFormat(parsePatterns[0]);
			returnValue = df.format(aDate);
		}
		return returnValue;
	}

	public static final String getTimeStr(Date aDate) {
		SimpleDateFormat df = null;
		String returnValue = "";

		if (aDate != null) {
			df = new SimpleDateFormat(parsePatterns[1]);
			returnValue = df.format(aDate);
		}

		return returnValue;
	}

	public static Date convertStringToDate(String strDate) {
		Date aDate = null;
		try {
			String pattern = "\\d{4}[-|/]\\d{2}[-|/]\\d{2}[ ]\\d{2}[:]\\d{2}[:]\\d{2}";
			if (strDate.matches(pattern)) {
				if (strDate.contains("/"))
					aDate = convertStringToDate("yyyy/MM/dd HH:mm:ss", strDate);
				else {
					aDate = convertStringToDate(parsePatterns[1], strDate);
				}
			} else if (strDate.contains("/"))
				aDate = convertStringToDate("yyyy/MM/dd", strDate);
			else
				aDate = convertStringToDate(parsePatterns[0], strDate);
		} catch (ParseException pe) {
			logger.error("Could not convert '" + strDate
					+ "' to a date, throwing exception");

			pe.printStackTrace();
		}

		return aDate;
	}

	public static final Date convertStringToDate(String aMask, String strDate)
			throws ParseException {
		SimpleDateFormat df = null;
		Date date = null;
		df = new SimpleDateFormat(aMask);
		try {
			date = df.parse(strDate);
		} catch (ParseException pe) {
			throw new ParseException(pe.getMessage(), pe.getErrorOffset());
		}

		return date;
	}

	public static final String getTimeStr(String format, Date aDate) {
		SimpleDateFormat df = null;
		String returnValue = "";

		if (aDate != null) {
			df = new SimpleDateFormat(format);
			returnValue = df.format(aDate);
		}

		return returnValue;
	}

	static {
		gc.setLenient(true);
		gc.setFirstDayOfWeek(2);

		parsePatterns = new String[] { "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss",
				"yyyy-MM-dd HH:mm", "yyyy/MM/dd", "yyyy/MM/dd HH:mm:ss",
				"yyyy/MM/dd HH:mm" };
	}

	public static enum DateFormatType {
		DATE_FORMAT_STR("yyyy-MM-dd HH:mm:ss"),

		SIMPLE_DATE_TIME_FORMAT_STR("yyyyMMddHHmmss"),

		SIMPLE_DATE_FORMAT_STR("yyyy-MM-dd"),

		SIMPLE_DATE_FORMAT_VIRGULE_STR("yyyy/MM/dd"),

		HOUR_MINUTE_SECOND("HH:mm:ss"),

		HOUR_MINUTE("HH:mm");

		private final String value;

		private DateFormatType(String formatStr) {
			this.value = formatStr;
		}

		public String getValue() {
			return this.value;
		}
	}

	public static enum TimeFormatType {
		YEAR(1), MONTH(2), DAY(5), HOUR(11), MINUTE(12), SECOND(13);

		private final int value;

		private TimeFormatType(int formatStr) {
			this.value = formatStr;
		}

		public int getValue() {
			return this.value;
		}
	}

	public static enum DateOperationType {
		ADD(true),

		DIFF(false);

		private final boolean value;

		private DateOperationType(boolean operation) {
			this.value = operation;
		}

		public boolean getValue() {
			return this.value;
		}
	}
	
	
	/**
    *
    * 查询当前日期前(后)x天的日期
    *
    * @param date 当前日期
    * @param day 天数（如果day数为负数,说明是此日期前的天数）
    * @return yyyy-MM-dd
    */
   public static String beforNumDay(Date date, int day) {
       Calendar c = Calendar.getInstance();
       c.setTime(date);
       c.add(Calendar.DAY_OF_YEAR, day);
       return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(c.getTime());
   }
	
   /**
    * 
    * 时间戳转当前时间
    * @param strDate
    * @return
    */
   public static String strToDate(String strDate){
	   SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	   return sdf.format(new Date(Long.parseLong(strDate)));
   }
	/**
	 * 格式化时间
	 * @param date 要格式化的时间
	 * @param formats 格式化格式：如"yyyy-MM-dd","yyyy-MM-dd HH:mm:ss"
	 * @return
	 */
	public static String formatTime(Date date, String formats) {
		if(StringUtils.isEmpty(formats))
			formats="yyyy-MM-dd HH:mm:ss";
		String time = "";
		DateFormat format = new SimpleDateFormat(formats);
		if (date != null) {
			time = format.format(date);
		} else throw new RuntimeException("Empty date！");
		return time;
	}	
	/**
	 * 获取2个日期之间的天数差
	 * @author 申鹏飞
	 * @param startDate,endDate
	 * @param formats 格式化格式：如"yyyy-MM-dd",
	 * @return
	 * @throws ParseException 
	 */
	public static long betweenDays(String startDate,String endDate) throws ParseException{
		SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd");
		Date enddate=simpleDateFormat.parse(endDate);  
		Date startdate=simpleDateFormat.parse(startDate);  
	    Calendar cal = Calendar.getInstance();    
	    cal.setTime(enddate);    
	    long endTime = cal.getTimeInMillis();                 
	    cal.setTime(startdate);    
	    long startTime = cal.getTimeInMillis();         
	    long between_days=(endTime-startTime)/(1000*3600*24); 
	    return between_days;
	}
	
	/**
	 * 
	 * @Title: betweenSecond
	 * @Description: 查询两时间之隔，秒
	 * @param startDate
	 * @param endDate
	 * @return
	 * @throws ParseException
	 * @author 赵亚舟
	 * @return long
	 */
	public static long betweenSecond(String startDate,String endDate)throws ParseException{
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date enddate=simpleDateFormat.parse(endDate);  
		Date startdate=simpleDateFormat.parse(startDate);  
	    Calendar cal = Calendar.getInstance();    
	    cal.setTime(enddate);    
	    long endTime = cal.getTimeInMillis();                 
	    cal.setTime(startdate);    
	    long startTime = cal.getTimeInMillis(); 
	    long between_second = (endTime-startTime)/(1000);
	    return between_second;
	}
	
	
	public static String getDateTimeInt() {
		SimpleDateFormat simpleDateFormat= new SimpleDateFormat("yyyyMMddHHmmss");
		String dateTime=simpleDateFormat.format(new Date()).trim();
		return dateTime;
	}
}
