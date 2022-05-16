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
package com.anchordata.webframework.base.common.web.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


@Component
public class CurrentMenuUrlInterceptor implements HandlerInterceptor {

	protected transient Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		
//		String url = new UrlPathHelper().getPathWithinApplication(request);
//		SecurityContext sc = (SecurityContextImpl) request.getSession().getAttribute("SPRING_SECURITY_CONTEXT");
//		if (sc != null) {
//			Authentication auth =  sc.getAuthentication();
			
//			if (auth != null && modelAndView != null) {
//				List<MenuVO> menus = ((UserVO) auth.getPrincipal()).getMenus();
//				
//				menus.forEach(e -> {
//					e.getSubMenus().forEach(l -> {
//						if (url.contains(l.getMenuPath())) {
//							modelAndView.getModel().put("cMenu", l);
//							if (l.getSubMenus() != null) {
//								l.getSubMenus().forEach(m -> {
//									if (url.contains(m.getMenuPath())) {
//										modelAndView.getModel().put("cMenu", m);
//									}
//								});
//							}
//						} else {
//							if (l.getSubMenus() != null) {
//								l.getSubMenus().forEach(m -> {
//									if (url.contains(m.getMenuPath())) {
//										modelAndView.getModel().put("cMenu", m);
//									}
//								});
//							}
//						}
//					});
//				});
//			}
//		}
		
//		if (modelAndView != null && modelAndView.getModel() != null) {
//			if (modelAndView.getModel().get("cMenu") != null) {
//				logger.info(modelAndView.getModel().get("cMenu").toString());
//			}
//		}
	}

	/**
	 * comment
	 * @param  HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex
	 */
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		
	}

}
