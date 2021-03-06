package com.anchordata.webframework.base.common.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.anchordata.webframework.base.common.auth.service.AuthService;

public class OAuth2SuccessHandler implements AuthenticationSuccessHandler {
	
	final String type;
	final AuthService authService;

	public OAuth2SuccessHandler(String type, AuthService authService) {
		this.type = type;
		this.authService = authService;
	}

	@Override
	public void onAuthenticationSuccess(HttpServletRequest req, HttpServletResponse res, Authentication auth) throws IOException, ServletException {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		Object pricipal	= authentication.getPrincipal();
		//겟프린시펄... 떼문에 이렇게 함
		if (pricipal != null) {
			if (auth != null) {
				try {
					authService.setAccountInfoGoogle(auth);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				//auth가 없을 경우 리턴페이지 하나만들어서 넘겨줘야함
			}

		}
		
		res.sendRedirect("/");
    
		/*
		 * // 연결되어 있는 계정이 있는지 확인합니다. // 이전 강의 AccountService.getAccountByOAuthId 참고!!
		 * Account account = accountService.getAccountByOAuthId(type, auth.getName());
		 * 
		 * // 연결되어 있는 계정이 있는경우. if (account != null) { // 기존 인증을 바꿉니다. // 이전 강의의 일반 로그인과
		 * 동일한 방식으로 로그인한 것으로 간주하여 처리합니다. // 기존 인증이 날아가기 때문에 OAUTH ROLE은 증발하며, USER ROLE
		 * 이 적용됩니다. SecurityContextHolder.getContext().setAuthentication(new
		 * UsernamePasswordAuthenticationToken( new UserDetails(account), null,
		 * UserDetails.getAuthorities(account.getRoles()))); res.sendRedirect("/"); } //
		 * 연결된 계정이 없는경우 else { // 회원가입 페이지로 보냅니다. // ROLE 은 OAUTH 상태입니다.
		 * res.sendRedirect("/sign-up/oauth");
		 * 
		 * // 특별히 추가정보를 받아서 가입해야할 일이없다면, // 즉석으로 계정을 생성한 후 성공처리 해준다면 사용자 입장에서 좋을 것 같습니다.
		 * }
		 */
	}
}
