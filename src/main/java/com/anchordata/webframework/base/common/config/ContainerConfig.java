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
package com.anchordata.webframework.base.common.config;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;

import javax.servlet.descriptor.JspConfigDescriptor;
import javax.servlet.descriptor.JspPropertyGroupDescriptor;
import javax.servlet.descriptor.TaglibDescriptor;

import org.apache.catalina.Context;
import org.apache.catalina.connector.Connector;
import org.apache.tomcat.util.descriptor.web.JspPropertyGroup;
import org.apache.tomcat.util.descriptor.web.JspPropertyGroupDescriptorImpl;
import org.apache.tomcat.util.descriptor.web.SecurityCollection;
import org.apache.tomcat.util.descriptor.web.SecurityConstraint;
import org.apache.tomcat.util.descriptor.web.TaglibDescriptorImpl;
import org.apache.tomcat.util.scan.StandardJarScanner;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.embedded.tomcat.TomcatContextCustomizer;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.ErrorPage;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.boot.web.servlet.server.ConfigurableServletWebServerFactory;
import org.springframework.boot.web.servlet.server.ServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;

@Configuration
public class ContainerConfig implements WebServerFactoryCustomizer<ConfigurableServletWebServerFactory> {

	@Value("${tomcat.ajp.protocol}")
	String ajpProtocol;
	 
	@Value("${tomcat.ajp.port}")
	int ajpPort;
	 
	@Value("${tomcat.ajp.enabled}")
	boolean tomcatAjpEnabled;
	
	
	@Bean
	public ServletWebServerFactory servletContainer() {
		TomcatServletWebServerFactory tomcat = new TomcatServletWebServerFactory();
		tomcat.addAdditionalTomcatConnectors(createAjpConnector());
		return tomcat;
	}
	
	private Connector createAjpConnector() {
		Connector ajpConnector = new Connector(ajpProtocol);
		ajpConnector.setPort(ajpPort);
		ajpConnector.setSecure(false);
		ajpConnector.setAllowTrace(false);
		ajpConnector.setScheme("http");
		return ajpConnector;
	}

	
	@Override
	public void customize(ConfigurableServletWebServerFactory factory) {
				
		((TomcatServletWebServerFactory) factory).addContextCustomizers(new TomcatContextCustomizer(){
            JspConfigDescriptor jspConfigDescriptor = new JspConfigDescriptor() {
                @Override
                public Collection<TaglibDescriptor> getTaglibs() {
                    TaglibDescriptor descriptor1 = new TaglibDescriptorImpl("/WEB-INF/tlds/c.tld"		, "http://java.sun.com/jsp/jstl/core");
					TaglibDescriptor descriptor2 = new TaglibDescriptorImpl("/WEB-INF/tlds/fmt.tld"		, "http://java.sun.com/jsp/jstl/fmt");
					TaglibDescriptor descriptor3 = new TaglibDescriptorImpl("/WEB-INF/tlds/fn.tld"		, "http://java.sun.com/jsp/jstl/functions");
					TaglibDescriptor descriptor4 = new TaglibDescriptorImpl("/WEB-INF/tlds/taglib.tld"	, "/WEB-INF/tlds/taglib.tld");
                    return new ArrayList<>(Arrays.asList(descriptor1,descriptor2,descriptor3,descriptor4));
                }
                @Override
                public Collection<JspPropertyGroupDescriptor> getJspPropertyGroups() {                   
                    JspPropertyGroup group = new JspPropertyGroup();
                    group.addUrlPattern("*.jsp");
                    group.setPageEncoding("UTF-8");
                    JspPropertyGroupDescriptor descriptor = new JspPropertyGroupDescriptorImpl(group);
                    return Collections.singletonList(descriptor);
                }
            };
            
            @Override
            public void customize(Context context) {
                context.setJspConfigDescriptor(jspConfigDescriptor);
                ((StandardJarScanner) context.getJarScanner()).setScanManifest(false);
                
                SecurityConstraint constraint = new SecurityConstraint();
                SecurityCollection securityCollection = new SecurityCollection();
                securityCollection.setName("restricted_methods");
                securityCollection.addPattern("/*");
                securityCollection.addOmittedMethod(HttpMethod.POST.toString());
                securityCollection.addOmittedMethod(HttpMethod.GET.toString());
                constraint.addCollection(securityCollection);
                constraint.setAuthConstraint(true);
                context.addConstraint(constraint);
            }
        });
		
		
		ErrorPage[] errorPages = {
			new ErrorPage(HttpStatus.NOT_FOUND, "/error"), 
			new ErrorPage(HttpStatus.FORBIDDEN, "/error"), 
			new ErrorPage(HttpStatus.INTERNAL_SERVER_ERROR, "/error"), 
			new ErrorPage("/error")
		};
			
		factory.addErrorPages(errorPages);
		
	}
}
