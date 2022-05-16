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
package com.anchordata.webframework.service.login;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class LoginVO {

	private static final long serialVersionUID = 1L;

	
	public String kakao_redirect_url;
	
	
	public String getKakao_redirect_url() {
		return kakao_redirect_url;
	}
	public void setKakao_redirect_url(String kakao_redirect_url) {
		this.kakao_redirect_url = kakao_redirect_url;
	}
	
	
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}


}
