/*******************************************************************************
 *
 * Copyright ⓒ 2018 kth corp. All rights reserved.
 *
 * This is a proprietary software of kt corp, and you may not use this file except in
 * compliance with license agreement with kt corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of kt corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.base.core.support;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import com.anchordata.webframework.base.core.base.ResultCodes;
import com.anchordata.webframework.base.core.base.vo.JsonResult;
import com.anchordata.webframework.base.core.comp.msg.StaticMessageSource;


public class JsonResponseUtils {
		
	/**
	 * 성공 프로세스에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @return ResponseEntity<Object>
	 */
	public static <T> ResponseEntity<Object> success() {
		return success(null);
	}
	
	/**
	 * 성공 프로세스에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @param data
	 * @return
	 */
	public static <T> ResponseEntity<Object> success(T data) {
		final JsonResult<T> body = new JsonResult<T>(ResultCodes.SUCCESS.code(), StaticMessageSource.getMessage(ResultCodes.SUCCESS.msgId()), data);
		return new ResponseEntity<Object>(body, HttpStatus.OK);
	}
	
	/**
	 * 실패 프로세스에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @return ResponseEntity<Object>
	 */
	public static <T> ResponseEntity<Object> fail() {
		return fail(null);
	}
	
	/**
	 * 실패 프로세스에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @param data
	 * @return
	 */
	public static <T> ResponseEntity<Object> fail(T data) {
		final JsonResult<T> body = new JsonResult<T>(ResultCodes.ERROR_0900.code(), StaticMessageSource.getMessage(ResultCodes.ERROR_0900.msgId()), data);
		return new ResponseEntity<Object>(body, HttpStatus.OK);
	}
	
	/**
	 * 실패 프로세스에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @param data
	 * @return
	 */
	public static <T> ResponseEntity<Object> fail(String code, String message) {
		final JsonResult<T> body = new JsonResult<T>(code, message);
		return new ResponseEntity<Object>(body, HttpStatus.OK);
	}
	
	/**
	 * 실패 프로세스에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @param data
	 * @return
	 */
	public static <T> ResponseEntity<Object> fail(String errorCd) {
		final JsonResult<T> body = new JsonResult<T>(errorCd, null, null);
		return new ResponseEntity<Object>(body, HttpStatus.OK);
	}
	
	/**
	 * 에러에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @return ResponseEntity<Object>
	 */
	public static <T> ResponseEntity<Object> error() {
		return error(null);
	}
	
	/**
	 * 에러에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @param data
	 * @return
	 */
	public static <T> ResponseEntity<Object> error(T data) {
		final JsonResult<T> body = new JsonResult<T>(ResultCodes.ERROR_0500.code(), StaticMessageSource.getMessage(ResultCodes.ERROR_0500.msgId()), data);
		return new ResponseEntity<Object>(body, HttpStatus.OK);
	}
	
	/**
	 * 사용자 지정값에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @param code
	 * @param msgCd
	 * @param data
	 * @param httpStatus
	 * @return
	 */
	public static <T> ResponseEntity<Object> conf(String code, String msgCd, HttpStatus httpStatus) {
		final JsonResult<T> body = new JsonResult<T>(code, msgCd);
		return new ResponseEntity<Object>(body, httpStatus);
	}
	
	/**
	 * 사용자 지정값에 대하여 ResponseEntity<JsonResult<T>> 정보를 리턴
	 * 
	 * @param code
	 * @param msgCd
	 * @param data
	 * @param httpStatus
	 * @return
	 */
	public static <T> ResponseEntity<Object> confWithMsg(String code, String msgCd, T data, HttpStatus httpStatus) {
		final JsonResult<T> body = new JsonResult<T>(code, StaticMessageSource.getMessage(msgCd), data);
		return new ResponseEntity<Object>(body, httpStatus);
	}
}
