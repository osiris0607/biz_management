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
package com.anchordata.webframework.base.core.base;

public enum ResultCodes {
	
	/** 정상 처리 */
	SUCCESS("0000"		, "api.result.msg.0000"),
	
	/** 요청 오류 */
	ERROR_0400("0400"	, "api.result.msg.0400"),
	
	/** 인증 실패 (유효하지 않는 API Token, 비밀번호 다름) */
	ERROR_0401("0401"	, "api.result.msg.0401"),
	
	/** 인가 실패 (회원가입이 없는 경우) */
	ERROR_0403("0403"	, "api.result.msg.0403"),
	
	/** 존재하지 않는 오류 */
	ERROR_0404("0404"	, "api.result.msg.0404"),
	
	/** HttpMethod 오류 */
	ERROR_0405("0405"	, "api.result.msg.0405"),
	
	/** HttpMethod 오류 */
	ERROR_0408("0408"	, "api.result.msg.0408"),
	
	/** MediaType 오류 */
	ERROR_0415("0415"	, "api.result.msg.0415"),
	
	/** 서버 실패 */
	ERROR_0500("0500"	, "api.result.msg.0500"),
	
	/** 프로세스 오류 (공통) */
	ERROR_0900("0900"	, "api.result.msg.0900"),	
	;

	private String code;

	private String msgId;

	private ResultCodes(String code, String msgId) {
		this.code = code;
		this.msgId = msgId;
	}
	
	public String code() {
		return this.code;
	}
	
	public String msgId() {
		return this.msgId;
	}
}
