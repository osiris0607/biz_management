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
package com.anchordata.webframework.base.core.support;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Source;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.MethodParameter;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.HttpMessageNotWritableException;
import org.springframework.http.converter.ResourceHttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter;
import org.springframework.http.converter.xml.Jaxb2RootElementHttpMessageConverter;
import org.springframework.http.converter.xml.SourceHttpMessageConverter;
import org.springframework.util.ClassUtils;
import org.springframework.web.HttpMediaTypeNotAcceptableException;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.method.support.ModelAndViewContainer;
import org.springframework.web.servlet.mvc.method.annotation.RequestResponseBodyMethodProcessor;

public class MessageConverterHandler {
	
	protected transient Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private List<HttpMessageConverter<?>> messageConverters;
    
	private RequestResponseBodyMethodProcessor processor;
	

    private static final boolean JAXB2PRESENT = 
    	ClassUtils.isPresent("javax.xml.bind.Binder"						, MessageConverterHandler.class.getClassLoader());

    private static final boolean JACKSON2PRESENT =
        ClassUtils.isPresent("com.fasterxml.jackson.databind.ObjectMapper"	, MessageConverterHandler.class.getClassLoader()) &&
        ClassUtils.isPresent("com.fasterxml.jackson.core.JsonGenerator"		, MessageConverterHandler.class.getClassLoader());
   
    public MessageConverterHandler() {
    	init();
    }
    
    private void init() {
    	this.messageConverters =   new ArrayList<HttpMessageConverter<?>>();
        this.messageConverters.add(new ByteArrayHttpMessageConverter());
        this.messageConverters.add(new StringHttpMessageConverter());
        this.messageConverters.add(new ResourceHttpMessageConverter());
        this.messageConverters.add(new SourceHttpMessageConverter<Source>());
        this.messageConverters.add(new AllEncompassingFormHttpMessageConverter());

        if (JAXB2PRESENT) {
            this.messageConverters.add(new Jaxb2RootElementHttpMessageConverter());
        }
        
        if (JACKSON2PRESENT) {
            this.messageConverters.add(new MappingJackson2HttpMessageConverter());
        }
        
        processor = new RequestResponseBodyMethodProcessor(this.messageConverters);
    }

    public void handle(Object returnValue, HttpServletRequest request, HttpServletResponse response) {
        ServletWebRequest nativeRequest = new ServletWebRequest(request, response);
        MethodParameter returnType;
		try {
			returnType = new MethodParameter(this.getClass().getMethod("handle"), -1);
			processor.handleReturnValue(returnValue, returnType, new ModelAndViewContainer(), nativeRequest);
		} catch (NoSuchMethodException | SecurityException | HttpMessageNotWritableException | HttpMediaTypeNotAcceptableException | IOException e) {
			logger.error(e.getMessage());
		}
        
    }

    public List<HttpMessageConverter<?>> getMessageConverters() {
        return messageConverters;
    }
    
    public ResponseEntity<Object> handle() { 
    	return null; 
    }

}
