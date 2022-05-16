package com.anchordata.webframework.base.common.config;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;
@Component
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {
 
    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authEx)
            throws IOException, ServletException {
        // status를 401 에러로 지정
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        // json 리턴 및 한글깨짐 수정.
        response.setContentType("application/json;charset=utf-8");
		/*
		 * JSONObject json = new JSONObject(); String message = "잘못된 접근입니다";
		 * json.put("code", "9999"); json.put("message", message);
		 * 
		 * PrintWriter out = response.getWriter(); out.print(json);
		 */
        
        response.sendRedirect("/error");
    }
}