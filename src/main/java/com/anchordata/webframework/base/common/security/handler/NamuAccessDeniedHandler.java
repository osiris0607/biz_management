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

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

@Component
public class NamuAccessDeniedHandler implements AccessDeniedHandler {

	@Value("${access.denied.url}")
	private String redirectUrl;
  	
	@Override
	public void handle( HttpServletRequest request, 
						HttpServletResponse response, 
						AccessDeniedException accessDeniedException) throws IOException, ServletException {
		
		System.out.println("AccessDeniedHandler!!!");
		
		String contextPath = request.getContextPath();
		response.sendRedirect(contextPath.concat(redirectUrl));
	}
}
