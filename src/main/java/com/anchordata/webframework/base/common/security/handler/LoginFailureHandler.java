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
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;


@Component
public class LoginFailureHandler extends SimpleUrlAuthenticationFailureHandler {
	
	@Value("${login.admin.default.url}")
	private String redirectUrl;
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {
//		String errormsg = null;
//		
//		if(exception instanceof BadCredentialsException) {
//            errormsg = "아이디나 비밀번호가 맞지 않습니다. 다시 확인해 주세요.";
//        } 
//		else {
//			errormsg = "로그인에 실패했습니다. 다시 확인해 주세요";
//        }
//        
//        request.setAttribute("ERROR_MSG", errormsg);
// 
//        request.getRequestDispatcher(redirectUrl).forward(request, response);
        
        response.sendRedirect("/user/fwd/login/loginError");

	}	
}