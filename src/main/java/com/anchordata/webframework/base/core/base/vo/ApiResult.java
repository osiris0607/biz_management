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
package com.anchordata.webframework.base.core.base.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(Include.NON_NULL)
public class ApiResult<T> {

	private String resltCd;
	
	private String resltMsg;
	
	private T resltData;
	
	private String ttsMsg;
	
	
	public ApiResult(String resltCd, String resltMsg) {
		this.resltCd = resltCd;
		this.resltMsg = resltMsg;
	}

	public ApiResult(String resltCd, String resltMsg, T resltData) {
		this.resltCd = resltCd;
		this.resltMsg = resltMsg;
		this.resltData = resltData;
	}	
	   
    public ApiResult(String resltCd, String resltMsg, T resltData, String ttsMsg) {
        this.resltCd = resltCd;
        this.resltMsg = resltMsg;
        this.resltData = resltData;
        this.ttsMsg = ttsMsg;
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

	public T getResltData() {
		return resltData;
	}

	public void setResltData(T resltData) {
		this.resltData = resltData;
	}

    public String getTtsMsg() {
        return ttsMsg;
    }

    public void setTtsMsg(String ttsMsg) {
        this.ttsMsg = ttsMsg;
    }

	

	
	
}