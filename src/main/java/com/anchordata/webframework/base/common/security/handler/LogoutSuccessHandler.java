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

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.stereotype.Component;

/**
 * 로그아웃 성공 핸들러
 * 
 * @author aki2re
 *
 */
@Component
public class LogoutSuccessHandler extends SimpleUrlLogoutSuccessHandler {
	
	protected transient Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Value("${login.admin.default.url}")
	private String redirectUrl;
	
	@Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		try {
			setDefaultTargetUrl(redirectUrl);
			request.getSession().invalidate();
//			authentication = null;
//			super.onLogoutSuccess(request, response, authentication);
			
			super.onLogoutSuccess(request, response, null);
		} catch (IOException | ServletException e) {
			logger.error(e.getMessage());
		}       
    }
	
}
