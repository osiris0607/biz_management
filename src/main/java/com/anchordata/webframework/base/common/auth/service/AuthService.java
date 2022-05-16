/*******************************************************************************
 *
 * Copyright �뱬 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of namu C&D corp, and you may not use this file except in
 * compliance with license agreement with namu C&D corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of namu C&D corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.base.common.auth.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.security.oauth2.provider.authentication.OAuth2AuthenticationDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.common.auth.dao.AuthDao;
import com.anchordata.webframework.base.common.auth.vo.UserVO;


import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.base.util.JsonStringParse;
import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;


@Service("authService")
public class AuthService implements UserDetailsService {
	
	@Autowired
	private AuthDao authDao;
	
	@Autowired
	private  MemberService memberService;
	
	@Autowired
    @Qualifier("authenticationManager")
    protected static AuthenticationManager authenticationManager;
	
	private JsonStringParse jsonparse = new JsonStringParse();
	
	@Autowired
	private RequestMappingHandlerMapping requestMappingHandlerMapping;


	
	@Override
	public UserDetails loadUserByUsername(String mbrId) throws UsernameNotFoundException {
		MemberVO memberVO = new MemberVO();
		try {
			memberVO.setMember_id(mbrId);
			memberVO = memberService.findLoginInfo(memberVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		if (memberVO == null) {
//			throw new UsernameNotFoundException(StaticMessageSource.getMessage("login.user.not.found", new Object[] {mbrId}));
			throw new UsernameNotFoundException("사용자 아이디가 존재하지 않습니다. 다시 시도해 주십시요.");
		}
		
//		return memberVO;
		List<GrantedAuthority> authorities = new ArrayList<>();
		
		if (memberVO.getAuth_level_super_admin().equals("Y")) {
			authorities.add(new SimpleGrantedAuthority("ROLE_SUPER_ADMIN"));
		}
		else if (memberVO.getAuth_level_admin().equals("Y")) {
			authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
		}
		else if (memberVO.getAuth_level_manager().equals("Y")) {
			authorities.add(new SimpleGrantedAuthority("ROLE_MANAGER"));
		}
		else if (memberVO.getAuth_level_expert().equals("Y")) {
			authorities.add(new SimpleGrantedAuthority("ROLE_EXPERT"));
		} 
		else if (memberVO.getAuth_level_commissioner().equals("Y")) {
			authorities.add(new SimpleGrantedAuthority("ROLE_COMMISSIONER"));
			authorities.add(new SimpleGrantedAuthority("ROLE_MEMBER"));
		}
		else {
			authorities.add(new SimpleGrantedAuthority("ROLE_MEMBER"));
		} 
		
		return new User(memberVO.getMember_id(), memberVO.getPwd(), authorities);
	}
	

	public ResponseEntity<?> chgTeam(){
		return null;
	}
	
	/**
	 * 援ш� 濡쒓렇�씤
	 * @param auth
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Transactional
	public void setAccountInfoGoogle(Authentication auth) throws Exception {
		OAuth2Authentication oAuth2Authentication = (OAuth2Authentication) auth;
		HashMap<String, Object> map = (HashMap) oAuth2Authentication.getUserAuthentication().getDetails();
		
		String email 		= map.get("email").toString();
		String name			= map.get("name").toString();
		String tokenValue 	= (OAuth2AuthenticationDetails.class.cast(auth.getDetails())).getTokenValue().toString();
		String tokenType 	= (OAuth2AuthenticationDetails.class.cast(auth.getDetails())).getTokenType().toString();
		
		DataMap dtMap = new DataMap();
		
		dtMap.put("email", email);
		dtMap.put("name", name);
		dtMap.put("userKey", tokenValue);
		dtMap.put("tokenType", tokenType);
		dtMap.put("snsDivi", Constants.GOOGLE);
		
		mergeMember(dtMap, email, name, tokenType, tokenValue);
	}
	
	/**
	 * 네이버 로그인
	 * @param auth
	 */
	@Transactional
	public void setAccountInfoNaver(JSONObject jsonobj) throws Exception {

		String name = jsonparse.JsonToString(jsonobj, "name");
        String email = jsonparse.JsonToString(jsonobj, "email");
        String id = jsonparse.JsonToString(jsonobj, "id");
		
		DataMap dtMap = new DataMap();
		
		dtMap.put("email", email);
		dtMap.put("name", name);
		dtMap.put("userKey", id);
		dtMap.put("snsDivi", Constants.NAVER);
		
		mergeMember(dtMap, email, name, null, null);
	}
	
	/**
	 * 카카오로그인
	 * @param auth
	 */
	@Transactional
	public void setAccountInfoKakao(UserVO vo) throws Exception {
		
		DataMap dtMap = new DataMap();
		dtMap.put("userKey", vo.getUserKey());
		dtMap.put("email", vo.getEmail());
		dtMap.put("name", vo.getName());
		dtMap.put("snsDivi", Constants.KAKAO);
		
		mergeMember(dtMap, vo.getEmail(), vo.getName(), null, vo.getUserKey());
	}
	
	/*
	 * �쉶�썝媛��엯
	 * */
	public void mergeMember(DataMap dtMap, String email, String name, String tokenType, String tokenValue) {
		UserVO vo = authDao.findUserInfo(dtMap);
		
		if (vo == null) {
			vo = new UserVO();
			dtMap.put("emailAuthYn", "Y");
			int seq = authDao.insertUserInfo(dtMap);
			
			vo.setSeq(seq);
			vo.setEmail(email);
			vo.setName(name);
			vo.setUserKey(tokenType);
			vo.setUserTokkenType(tokenValue);
		}
		
		setForceLogin(vo);
	}
	
	/**
	 * 소셜강제 로그인
	 * @param vo
	 */
	public static void setForceLogin(UserVO vo) {
		// Authenticate the user
		Authentication authentication = new UsernamePasswordAuthenticationToken(vo, null, vo.getAuthorities());
		SecurityContext securityContext = SecurityContextHolder.getContext();
	    securityContext.setAuthentication(authentication);
	}
	
}
