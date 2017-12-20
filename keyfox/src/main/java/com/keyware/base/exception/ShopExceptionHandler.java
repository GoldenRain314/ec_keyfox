package com.keyware.base.exception;

import java.io.EOFException;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authz.UnauthenticatedException;
import org.apache.shiro.authz.UnauthorizedException;
import org.springframework.beans.ConversionNotSupportedException;
import org.springframework.beans.TypeMismatchException;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.http.converter.HttpMessageNotWritableException;
import org.springframework.messaging.handler.annotation.support.MethodArgumentNotValidException;
import org.springframework.validation.BindException;
import org.springframework.web.HttpMediaTypeNotAcceptableException;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.support.MissingServletRequestPartException;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.mvc.multiaction.NoSuchRequestHandlingMethodException;

public class ShopExceptionHandler extends Throwable
{
  private static final long serialVersionUID = -5211024175456208425L;
  private Map<String, String> map = new HashMap();

  @ExceptionHandler({IOException.class})
  public Map<String, String> doIOException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) {
    try {
      if ((exception instanceof FileNotFoundException)) {
        this.map.put("code", "filenotfound");
        this.map.put("message", "文件未发现");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "FileNotFoundException"));
      }
      if ((exception instanceof EOFException)) {
        this.map.put("code", "eof");
        this.map.put("message", "文件传输异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "EOFException"));
      }
      if ((exception instanceof MalformedURLException)) {
        this.map.put("code", "malformed");
        this.map.put("message", "URL解析出错");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "MalformedURLException"));
      }
      if ((exception instanceof UnknownHostException)) {
        this.map.put("code", "unknownhost");
        this.map.put("message", "指定主机未找到");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "UnknownHostException"));
      } else {
        this.map.put("code", "io");
        this.map.put("message", "其他文件操作异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "IOException"));
      }
      this.map.put("message", exception.getLocalizedMessage());
    } catch (Exception handlerException) {
      this.map.put("code", "other");
      this.map.put("message", handlerException.getLocalizedMessage());
      Logger.getLogger(handlerException.getClass().getName()).log(
        Level.SEVERE, 
        makeErrorMessage(handlerException, "Exception"));
    }
    return this.map;
  }

  @ExceptionHandler({RuntimeException.class})
  public Map<String, String> doRuntimeException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) {
    try {
      if ((exception instanceof UnauthenticatedException)) {
        this.map.put("code", "unauthenticated");
        this.map.put("message", "未登录");
        Logger.getLogger(exception.getClass().getName())
          .log(Level.SEVERE, 
          makeErrorMessage(exception, 
          "UnauthenticatedException"));
      } else if ((exception instanceof UnauthorizedException)) {
        this.map.put("code", "unauthorized");
        this.map.put("message", "对不起没有想过权限");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "UnauthorizedException"));
      } else if ((exception instanceof UnknownAccountException)) {
        this.map.put("code", "unknownaccount");
        this.map.put("message", "对不起用户不存在");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "UnknownAccountException"));
      } else if ((exception instanceof LockedAccountException)) {
        this.map.put("code", "lockedaccount");
        this.map.put("message", "用户被锁定");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "LockedAccountException"));
      } else if ((exception instanceof IncorrectCredentialsException)) {
        this.map.put("code", "incorrectcredentials");
        this.map.put("message", "密码不正确");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "IncorrectCredentialsException"));
      } else if ((exception instanceof ExcessiveAttemptsException)) {
        this.map.put("code", "excessiveattempts");
        this.map.put("message", "尝试次数太多,请联系管理员");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "ExcessiveAttemptsException"));
      } else if ((exception instanceof DisabledAccountException)) {
        this.map.put("code", "disabledAccount");
        this.map.put("message", "用户未启用");
        Logger.getLogger(exception.getClass().getName())
          .log(Level.SEVERE, 
          makeErrorMessage(exception, 
          "DisabledAccountException"));
      } else if ((exception instanceof ExpirationTimeException)) {
        this.map.put("code", "expirationTimelimit");
        this.map.put("message", "账号已过期");
        Logger.getLogger(exception.getClass().getName())
          .log(Level.SEVERE, 
          makeErrorMessage(exception, 
          "ExpirationTimeException"));
      } else if ((exception instanceof AuthenticationException)) {
        this.map.put("code", "authentication");
        this.map.put("message", "验证出错,请联系管理员");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "AuthenticationException"));
      } else if ((exception instanceof NullPointerException)) {
        this.map.put("code", "nullpointer");
        this.map.put("message", "空指针异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "NullPointerException"));
      } else if ((exception instanceof ClassCastException)) {
        this.map.put("code", "classcast");
        this.map.put("message", "类型转换异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "ClassCastException"));
      } else if ((exception instanceof ArithmeticException)) {
        this.map.put("code", "arithmetic");
        this.map.put("message", "算术运算异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "ArithmeticException"));
      } else if ((exception instanceof ArrayStoreException)) {
        this.map.put("code", "arraystore");
        this.map.put("message", "向数组中存放与声明类型不兼容对象异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "ArrayStoreException"));
      } else if ((exception instanceof IndexOutOfBoundsException)) {
        this.map.put("code", "indexoutofbounds");
        this.map.put("message", "下标越界异常");
        Logger.getLogger(exception.getClass().getName())
          .log(Level.SEVERE, 
          makeErrorMessage(exception, 
          "IndexOutOfBoundsException"));
      } else if ((exception instanceof NegativeArraySizeException)) {
        this.map.put("code", "negativearraysize");
        this.map.put("message", "创建一个大小为负数的数组错误异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "NegativeArraySizeException"));
      } else if ((exception instanceof NumberFormatException)) {
        this.map.put("code", "numberformat");
        this.map.put("message", "数字格式异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "NumberFormatException"));
      } else if ((exception instanceof SecurityException)) {
        this.map.put("code", "security");
        this.map.put("message", "安全异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "SecurityException"));
      } else if ((exception instanceof UnsupportedOperationException)) {
        this.map.put("code", "unsupportedoperation");
        this.map.put("message", "不支持的操作异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "UnsupportedOperationException"));
      } else if ((exception instanceof ArrayIndexOutOfBoundsException)) {
        this.map.put("code", "arrayindexoutofbounds");
        this.map.put("message", "访问数组元素的下标越界异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "ArrayIndexOutOfBoundsException"));
      } else if ((exception instanceof StringIndexOutOfBoundsException)) {
        this.map.put("code", "stringindexoutofbounds");
        this.map.put("message", "字符串下标越界异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "StringIndexOutOfBoundsException"));
      } else if ((exception instanceof IllegalArgumentException)) {
        this.map.put("code", "illegalargument");
        this.map.put("message", "传递非法参数异常");
        Logger.getLogger(exception.getClass().getName())
          .log(Level.SEVERE, 
          makeErrorMessage(exception, 
          "IllegalArgumentException"));
      } else if ((exception instanceof IllegalStateException)) {
        this.map.put("code", "illegalstate");
        this.map.put("message", "客户端的响应已经结束");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "IllegalStateException"));
      } else if ((exception instanceof IllegalAccessException)) {
        this.map.put("code", "illegalaccess");
        this.map.put("message", "非法访问异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "IllegalAccessException"));
      } else if ((exception instanceof MaxUploadSizeExceededException)) {
        this.map.put("code", "maxuploadsizeexceeded");
        this.map.put("message", "最大上传限制");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "MaxUploadSizeExceededException"));
      } else if ((exception instanceof EnumConstantNotPresentException)) {
        this.map.put("code", "enumconstantnotpresent");
        this.map.put("message", 
          "当应用程序试图通过名称和枚举类型访问那些不包含具有指定名称的常量的枚举常量时，抛出该异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "EnumConstantNotPresentException"));
      } else if ((exception instanceof InstantiationException)) {
        this.map.put("code", "instantiation");
        this.map.put("message", "new 结构来实例化一个抽象类或一个接口时，抛出该异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "InstantiationException"));
      } else if ((exception instanceof InterruptedException)) {
        this.map.put("code", "interrupted");
        this.map.put("message", 
          "当线程在活动之前或活动期间处于正在等待、休眠或占用状态且该线程被中断时，抛出该异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "InterruptedException"));
      } else if ((exception instanceof NoSuchFieldException)) {
        this.map.put("code", "nosuchfield");
        this.map.put("message", "类不包含指定名称的字段");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "NoSuchFieldException"));
      } else if ((exception instanceof NoSuchMethodException)) {
        this.map.put("code", "nosuchmethod");
        this.map.put("message", "无法找到某一特定方法时，抛出该异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "NoSuchMethodException"));
      } else if ((exception instanceof TypeNotPresentException)) {
        this.map.put("code", "typenotpresent");
        this.map.put("message", 
          "当应用程序试图使用表示类型名称的字符串对类型进行访问，但无法找到带有指定名称的类型定义时，抛出该异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "TypeNotPresentException"));
      } else if ((exception instanceof BindException)) {
        this.map.put("code", "bind");
        this.map.put("message", "Bean绑定异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "BindException"));
      } else if ((exception instanceof ConversionNotSupportedException)) {
        this.map.put("code", "conversionnotsupported");
        this.map.put("message", "转换不支持异常");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "ConversionNotSupportedException"));
      } else if ((exception instanceof HttpMediaTypeNotAcceptableException)) {
        this.map.put("code", "httpmediatypenotacceptable");
        this.map.put("message", "HttpMedia类型接受");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "HttpMediaTypeNotAcceptableException"));
      } else if ((exception instanceof HttpMediaTypeNotSupportedException)) {
        this.map.put("code", "httpmediatypenotsupported");
        this.map.put("message", "HttpMedia类型不支持");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "HttpMediaTypeNotSupportedException"));
      } else if ((exception instanceof HttpMessageNotReadableException)) {
        this.map.put("code", "httpmessagenotreadable");
        this.map.put("message", "Http消息不可读");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "HttpMessageNotReadableException"));
      } else if ((exception instanceof HttpMessageNotWritableException)) {
        this.map.put("code", "httpmessagenotwritable");
        this.map.put("message", "Http消息不可写");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "HttpMessageNotWritableException"));
      } else if ((exception instanceof HttpRequestMethodNotSupportedException)) {
        this.map.put("code", "httprequestmethodnotsupported");
        this.map.put("message", "Http请求方法不支持");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "HttpRequestMethodNotSupportedException"));
      } else if ((exception instanceof MethodArgumentNotValidException)) {
        this.map.put("code", "methodargumentnotvalid");
        this.map.put("message", "方法参数不正确");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "MethodArgumentNotValidException"));
      } else if ((exception instanceof MissingServletRequestParameterException)) {
        this.map.put("code", "missingservletrequestparameter");
        this.map.put("message", "丢失请求参数");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "MissingServletRequestParameterException"));
      } else if ((exception instanceof MissingServletRequestPartException)) {
        this.map.put("code", "missingservletrequestpart");
        this.map.put("message", "丢失请求部分");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "MissingServletRequestPartException"));
      } else if ((exception instanceof NoHandlerFoundException)) {
        this.map.put("code", "nohandlerfound");
        this.map.put("message", "没有找到处理方法");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "NoHandlerFoundException"));
      } else if ((exception instanceof NoSuchRequestHandlingMethodException)) {
        this.map.put("code", "nosuchrequesthandlingmethod");
        this.map.put("message", "没有请求找到处理方法");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, 
          "NoSuchRequestHandlingMethodException"));
      } else if ((exception instanceof TypeMismatchException)) {
        this.map.put("code", "typemismatch");
        this.map.put("message", "请求错误");
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "TypeMismatchException"));
      } else {
        this.map.put("code", "business");
        this.map.put("message", exception.getMessage());
        Logger.getLogger(exception.getClass().getName()).log(
          Level.SEVERE, 
          makeErrorMessage(exception, "RuntimeException"));
      }
    } catch (Exception handlerException) {
      this.map.put("code", "other");
      this.map.put("message", handlerException.getLocalizedMessage());
      Logger.getLogger(handlerException.getClass().getName()).log(
        Level.SEVERE, 
        makeErrorMessage(handlerException, "Exception"));
    }
    return this.map;
  }

  @ExceptionHandler({ClassNotFoundException.class})
  public Map<String, String> doClassNotFoundException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception)
  {
    this.map.put("code", "classnotfound");
    this.map.put("message", exception.getLocalizedMessage());
    Logger.getLogger(exception.getClass().getName()).log(Level.SEVERE, 
      makeErrorMessage(exception, "ClassNotFoundException"));
    return this.map;
  }

  @ExceptionHandler({CloneNotSupportedException.class})
  public Map<String, String> doCloneNotSupportedException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception)
  {
    this.map.put("code", "clonenotsupported");
    this.map.put("message", exception.getLocalizedMessage());
    Logger.getLogger(exception.getClass().getName()).log(Level.SEVERE, 
      makeErrorMessage(exception, "CloneNotSupportedException"));
    return this.map;
  }

  private String makeErrorMessage(Exception ex, String type) {
    StringBuffer sb = new StringBuffer("file:[");
    StackTraceElement[] element = ex.getStackTrace();
    sb.append(element[0].getFileName());
    sb.append("],class:[");
    sb.append(element[0].getClassName());
    sb.append("],method:[");
    sb.append(element[0].getMethodName());
    sb.append("],line:[");
    sb.append(element[0].getLineNumber());
    sb.append("],type:[");
    sb.append(type);
    sb.append("],message:[");
    sb.append(ex.getLocalizedMessage());
    sb.append("]");
    return sb.toString();
  }
}