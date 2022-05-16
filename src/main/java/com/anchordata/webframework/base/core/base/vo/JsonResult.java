/*******************************************************************************
 *

 * Copyright ⓒ 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of namu C&D corp, and you may not use this file except in
 * compliance with license agreement with namu C&D corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of namu C&D corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.base.core.base.vo;

public class JsonResult<T> {

	private String resltCd;
	
	private String resltMsg;
	
	private T data;
	
	public JsonResult(String resltCd, String resltMsg) {
		this.resltCd 	= resltCd;
		this.resltMsg 	= resltMsg;
	}

	public JsonResult(String resltCd, String resltMsg, T data) {
		this.resltCd 	= resltCd;
		this.resltMsg 	= resltMsg;
		this.data 		= data;
	}	
	
	public String getResltCd() {
		return resltCd;
	}

	public void setResltCd(String resltCd) {
		this.resltCd = resltCd;
	}

	public String getResltMsg() {
		return resltMsg;
	}

	public void setResltMsg(String resltMsg) {
		this.resltMsg = resltMsg;
	}

	public T getData() {
		return data;
	}

	public void setData(T data) {
		this.data = data;
	}

}
