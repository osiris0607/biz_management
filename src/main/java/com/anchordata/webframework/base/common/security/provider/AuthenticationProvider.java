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
package com.anchordata.webframework.base.common.security.provider;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;

import com.anchordata.webframework.base.common.auth.dao.AuthDao;
import com.anchordata.webframework.base.common.auth.service.AuthService;
import com.anchordata.webframework.base.common.auth.vo.UserVO;
import com.anchordata.webframework.base.common.security.encoder.SHA256PasswordEncoder;
import com.anchordata.webframework.base.core.comp.msg.StaticMessageSource;



public class AuthenticationProvider extends DaoAuthenticationProvider {
		
	@Autowired
	private AuthService authService;
	
	@Autowired
	private AuthDao authDao;
	
	@Autowired
	private SHA256PasswordEncoder passwordEncoder;
	
	
	@Override
	protected void additionalAuthenticationChecks(UserDetails userDetails,	UsernamePasswordAuthenticationToken token)	throws AuthenticationException {
		
		UserVO userVO = (UserVO) userDetails;
		
		try {
			
			//super.additionalAuthenticationChecks(userDetails, token);
			
			String presentedPassword = token.getCredentials().toString();

//			if (!passwordEncoder.matches(presentedPassword, userDetails.getPassword(), userVO.getMbrSalt())) {
//				logger.debug("Authentication failed: password does not match stored value");
//
//				throw new BadCredentialsException(messages.getMessage(
//						"AbstractUserDetailsAuthenticationProvider.badCredentials",
//						"Bad credentials"));
//			}
			
			getHierarchicalList(userVO);
			
		} catch (Exception e) {
			if (e instanceof BadCredentialsException) {
				throw new BadCredentialsException(StaticMessageSource.getMessage("login.user.not.found"));
			}
		}
		
	}	
	
	/**
	 * 사용자 권한 메뉴 
	 * 
	 * @param userVO
	 */
	private void getHierarchicalList(UserVO userVO) {		
		
//		final List<MenuVO> menus = authService.loadMenuByAuth(userVO.getMbrAuth());
		
//		Map<String, List<MenuVO>> menuMap = 
//				menus
//					.stream()
//					.filter(p -> p.getUpMenuId() != null)
//					.collect(Collectors.groupingBy(MenuVO::getUpMenuId));
//		
//		for (Iterator<MenuVO> menu = menus.iterator(); menu.hasNext();) {			
//			final MenuVO gnb = menu.next();
//			if (gnb.getUpMenuId() == null && gnb.getDept() == 1) {
//				List<MenuVO> lnbs = menuMap.get(gnb.getMenuId());				
//				for (MenuVO lnb : lnbs) {
//					List<MenuVO> lnbChilds = menuMap.get(lnb.getMenuId());
//					if (lnbChilds != null && !lnbChilds.isEmpty()) {
//						lnb.setSubMenus(lnbChilds);
//					}
//				}
//				gnb.setSubMenus(lnbs);
//			} else {
//				menu.remove();
//			}
//		}		
//		userVO.setMenus(menus);
	}
	
	 
}