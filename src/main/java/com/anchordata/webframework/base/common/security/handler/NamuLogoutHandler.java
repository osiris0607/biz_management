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
package com.anchordata.webframework.base.common.security.handler;


import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.stereotype.Component;


/**
 * 로그아웃 성공 핸들러
 * 
 * @author aki2re
 *
 */
@Component
public class NamuLogoutHandler implements LogoutHandler {
	

	@Override
	public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
//		String clientIp = request.getHeader("X-FORWARDED-FOR");
		
		// 사용자 정보 취득

		Cookie setCookie = new Cookie("remember_me", "");
		setCookie.setMaxAge(0);  
		response.addCookie(setCookie);	
		
		//history 넣을 경우 여기에
	}
	
}
