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
package com.anchordata.webframework;

import java.io.IOException;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.boot.env.YamlPropertySourceLoader;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.PropertySource;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;

@Order(Ordered.HIGHEST_PRECEDENCE)
public class ServiceEnvironmentPostProcessor implements EnvironmentPostProcessor {
	
	private static final String DEFAULT_THIRDPARTY_PROPERTIES_LOCATION 	= "classpath:/thirdpartyProperties.yml";
	private ResourceLoader loader = new DefaultResourceLoader();
	
    @Override
    public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
//    	 try {
//             Resource resource = loader.getResource(DEFAULT_THIRDPARTY_PROPERTIES_LOCATION);
//             PropertySource<?> propertySource = new YamlPropertySourceLoader().load("custom-config", resource).get(0);
//             environment.getPropertySources().addLast(propertySource);
//         } catch (IOException ex) {
//             throw new IllegalStateException(ex);
//         }
    }
}