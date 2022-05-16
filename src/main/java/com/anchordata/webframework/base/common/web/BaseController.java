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
package com.anchordata.webframework.base.common.web;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.ServletContextAware;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.common.web.service.CommCodeService;

import lombok.extern.slf4j.Slf4j;

@Controller("baseController")
@Slf4j
public class BaseController implements ServletContextAware, ErrorController {

	@Autowired
	private CommCodeService commCodeSevice;
	
	private static final String ERROR_PATH = "/error";
	
	@RequestMapping("/error")
    public ModelAndView handleError(HttpServletRequest req, Exception exception, ModelAndView mav) { 
    	System.out.println("Request: " + req.getRequestURL() + " raised " + exception);
    	
    	mav.addObject("exception", exception); 
    	mav.addObject("url", req.getRequestURL()); 
    	mav.setViewName("error/error");
        
        return mav;
    }

	@Override
	public void setServletContext(ServletContext servletContext) {
		servletContext.setAttribute(Constants.COMM_CODES, commCodeSevice);
	}
	
	  
    @Override
    public String getErrorPath() {
        return ERROR_PATH;
    }
}
