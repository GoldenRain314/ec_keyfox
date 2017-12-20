package com.keyware.base.task.util;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

public class ClientUtil
{
  private static final String ie = "msie ([\\d.]+)";
  private static final String firefox = "firefox\\/([\\d.]+)";
  private static final String chrome = "chrome\\/([\\d.]+)";
  private static final String opera = "opera.([\\d.]+)/)";
  private static final String safari = "version\\/([\\d.]+).*safari";

  public static String getIP(HttpServletRequest request)
  {
    String ip = request.getHeader("x-forwarded-for");
    if ((ip == null) || (ip.length() == 0) || ("unknown".equalsIgnoreCase(ip))) {
      ip = request.getHeader("Proxy-Client-IP");
    }
    if ((ip == null) || (ip.length() == 0) || ("unknown".equalsIgnoreCase(ip))) {
      ip = request.getHeader("WL-Proxy-Client-IP");
    }
    if ((ip == null) || (ip.length() == 0) || ("unknown".equalsIgnoreCase(ip))) {
      ip = request.getRemoteAddr();
    }
    return ip;
  }

  public static Map<String, String> getUserAgent(HttpServletRequest request)
  {
    Map browser = new HashMap();
    String agent = request.getHeader("User-Agent").toLowerCase();
    String _tmp = null;
    Pattern pattern = Pattern.compile("msie ([\\d.]+)");
    Matcher matcher = pattern.matcher(agent);
    if (matcher.find()) {
      _tmp = matcher.group();
      browser.put("type", "ie");
      browser.put("version", _tmp.split(" ")[1]);
      return browser;
    }
    pattern = Pattern.compile("firefox\\/([\\d.]+)");
    matcher = pattern.matcher(agent);
    if (matcher.find()) {
      _tmp = matcher.group();
      browser.put("type", "firefox");
      browser.put("version", _tmp.split("/")[1]);
      return browser;
    }
    pattern = Pattern.compile("chrome\\/([\\d.]+)");
    matcher = pattern.matcher(agent);
    if (matcher.find()) {
      _tmp = matcher.group();
      browser.put("type", "chrome");
      browser.put("version", _tmp.split("/")[1]);
      return browser;
    }
    pattern = Pattern.compile("opera.([\\d.]+)/)");
    matcher = pattern.matcher(agent);
    if (matcher.find()) {
      _tmp = matcher.group();
      browser.put("type", "opera");
      browser.put("version", _tmp.split("\\.")[1]);
      return browser;
    }
    pattern = Pattern.compile("version\\/([\\d.]+).*safari");
    matcher = pattern.matcher(agent);
    if (matcher.find()) {
      _tmp = matcher.group();
      browser.put("type", "safari");
      browser.put("version", _tmp.split("/")[1].split(".")[0]);
      return browser;
    }
    browser.put("type", "other");
    browser.put("version", null);
    return browser;
  }
}

