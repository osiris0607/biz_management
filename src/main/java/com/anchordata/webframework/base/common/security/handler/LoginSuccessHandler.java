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
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.anchordata.webframework.service.member.MemberService;

@Component
public class LoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
		
	@Value("${login.admin.success.url}")
	private String redirectUrl;
	
	@Autowired
	private  MemberService memberService;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {		
		try {
			// 최종 로그인 시간 저장
			String memberId = authentication.getName();
			memberService.updateLoginTime(memberId);
			memberService.insertMemberHistroy(memberId);
			
			List<GrantedAuthority> updatedAuthorities = new ArrayList<>(authentication.getAuthorities());
			for (GrantedAuthority auth : updatedAuthorities) {
				if (auth.getAuthority().compareTo("ROLE_SUPER_ADMIN") == 0 ) {
					response.sendRedirect("/admin/fwd/home/main");
					return;
				}
				
				if (auth.getAuthority().compareTo("ROLE_ADMIN") == 0 ) {
					response.sendRedirect("/admin/fwd/home/main");
					return;
				}
				
				if (auth.getAuthority().compareTo("ROLE_MANAGER") == 0 ) {
					response.sendRedirect("/admin/fwd/home/main");
					return;
				}
				
				if (auth.getAuthority().compareTo("ROLE_EXPERT") == 0 ) {
					response.sendRedirect("/member/fwd/home/main");
					return;
				}
				
				if (auth.getAuthority().compareTo("ROLE_COMMISSIONER") == 0 ) {
					response.sendRedirect("/member/fwd/home/main");
					return;
				}
				
				if (auth.getAuthority().compareTo("ROLE_MEMBER") == 0 ) {
					response.sendRedirect("/member/fwd/home/main");
					return;
				}
			}
			
			response.sendRedirect("/user/fwd/login/success");
			
		} catch (Exception e) {
			throw new ServletException();
		}
	}
}
