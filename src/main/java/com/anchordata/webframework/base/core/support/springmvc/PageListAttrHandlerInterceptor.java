package com.anchordata.webframework.base.core.support.springmvc;
/*******************************************************************************
 *
 * Copyright ⓒ 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of namu C&D corp, and you may not use this
 * file except in compliance with license agreement with namu C&D corp. Any
 * redistribution or use of this software, with or without modification shall be
 * strictly prohibited without prior written approval of namu C&D corp, and the
 * copyright notice above does not evidence any actual or intended publication
 * of such software.
 *
 *******************************************************************************//*
																					 * package
																					 * com.anchordata.webframework.core.support.
																					 * springmvc;
																					 * 
																					 * import java.util.Enumeration;
																					 * import java.util.HashMap; import
																					 * java.util.Map;
																					 * 
																					 * import javax.servlet.http.
																					 * HttpServletRequest; import
																					 * javax.servlet.http.
																					 * HttpServletResponse;
																					 * 
																					 * import
																					 * org.springframework.stereotype.
																					 * Component; import
																					 * org.springframework.web.servlet.
																					 * ModelAndView; import
																					 * org.springframework.web.servlet.
																					 * handler.
																					 * HandlerInterceptorAdapter;
																					 * 
																					 * import
																					 * com.anchordata.webframework.core.support.
																					 * mybtis.vo.PageList;
																					 * 
																					 * 
																					 * @Component public class
																					 * PageListAttrHandlerInterceptor
																					 * extends HandlerInterceptorAdapter
																					 * {
																					 * 
																					 * @Override public boolean
																					 * preHandle(HttpServletRequest
																					 * request, HttpServletResponse
																					 * httpServletResponse, Object o) {
																					 * return true; }
																					 * 
																					 * @Override public void
																					 * postHandle(HttpServletRequest
																					 * request, HttpServletResponse
																					 * httpServletResponse, Object o,
																					 * ModelAndView modelAndView) {
																					 * Enumeration<String> enumeration =
																					 * request.getAttributeNames();
																					 * while
																					 * (enumeration.hasMoreElements()) {
																					 * Object element =
																					 * enumeration.nextElement(); if
																					 * (element instanceof String) {
																					 * String name = (String) element;
																					 * Object attr =
																					 * request.getAttribute(name); if
																					 * (attr instanceof PageList) {
																					 * PageList<?> pageList =
																					 * (PageList<?>) attr;
																					 * request.setAttribute(name +
																					 * "Paginator",
																					 * pageList.getPaginator()); } } }
																					 * 
																					 * if (modelAndView != null) {
																					 * Map<String, Object> model =
																					 * modelAndView.getModel();
																					 * Map<String, Object> newModel =
																					 * new HashMap<String, Object>();
																					 * for (Map.Entry<String, Object>
																					 * item : model.entrySet()) { Object
																					 * attr = item.getValue(); if (attr
																					 * instanceof PageList) {
																					 * PageList<?> pageList =
																					 * (PageList<?>) attr;
																					 * newModel.put(item.getKey() +
																					 * "Paginator",
																					 * pageList.getPaginator()); } }
																					 * modelAndView.addAllObjects(
																					 * newModel); } } }
																					 */