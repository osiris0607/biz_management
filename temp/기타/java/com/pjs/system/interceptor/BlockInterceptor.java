package com.lxpantos.system.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class BlockInterceptor extends HandlerInterceptorAdapter {
	private static final Logger logger = LoggerFactory.getLogger(BlockInterceptor.class);
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
	    
	    if( request.getRequestURI().equals( request.getContextPath() + "/error") ) {
	        return true;
	    }
	    
	    logger.debug("[System] This url is blocked. : " + request.getRequestURI());
	    response.sendError(HttpServletResponse.SC_NOT_FOUND);
		return false;
	}
}
