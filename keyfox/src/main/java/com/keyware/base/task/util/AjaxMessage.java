package com.keyware.base.task.util;

import java.io.Serializable;

import com.keyware.utils.JsonUtils;

public class AjaxMessage
  implements Serializable
{
  private static final long serialVersionUID = 1680802699076731536L;
  private String code;
  private String message;
  private String data;
  private String token;

  public AjaxMessage()
  {
  }

  public AjaxMessage(String code, String message, String data, String token)
  {
    this.code = code;
    this.message = message;
    this.data = data;
    this.token = token;
  }

  public String toJSON() {
    return JsonUtils.toJson(this);
  }

  public String getCode() {
    return this.code;
  }
  public void setCode(String code) {
    this.code = code;
  }
  public String getMessage() {
    return this.message;
  }
  public void setMessage(String message) {
    this.message = message;
  }
  public String getData() {
    return this.data;
  }
  public void setData(String data) {
    this.data = data;
  }

  public String getToken()
  {
    return this.token;
  }

  public void setToken(String token)
  {
    this.token = token;
  }
}