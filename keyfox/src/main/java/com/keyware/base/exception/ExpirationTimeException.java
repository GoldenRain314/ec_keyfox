package com.keyware.base.exception;


import org.apache.shiro.authc.AccountException;

public class ExpirationTimeException extends AccountException
{
  private static final long serialVersionUID = 4931816562253082897L;

  public ExpirationTimeException()
  {
  }

  public ExpirationTimeException(String message)
  {
    super(message);
  }

  public ExpirationTimeException(Throwable cause) {
    super(cause);
  }

  public ExpirationTimeException(String message, Throwable cause) {
    super(message, cause);
  }
}