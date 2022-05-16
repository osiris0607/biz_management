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

import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.MethodInvokingFactoryBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;

import com.anchordata.webframework.base.core.comp.msg.StaticMessageSource;


@Configuration
public class MessageSourceConfig {

	@Value("${spring.messages.basename}")
	private String messagesBasename = null;
	   
	@Value("${spring.messages.encoding}")
	private String messagesEncoding = null;
	   
	@Value("${spring.messages.cache-duration}")
	private int messagesCacheSeconds;
		
	/**
	 * Configuraiton MessageSource;
	 * 
	 * @return
	 */
	@Bean
	public ReloadableResourceBundleMessageSource messageSource(){
		ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
		messageSource.setDefaultEncoding(messagesEncoding); 
		messageSource.setBasenames(messagesBasename);
		
		messageSource.setFallbackToSystemLocale(false);
		messageSource.setUseCodeAsDefaultMessage(false);
		messageSource.setCacheSeconds(messagesCacheSeconds);
		return messageSource;
   }

	/**
	 * Configuration MessageAccessor
	 * 
	 * @return
	 */
   @Bean
   public MessageSourceAccessor messageSourceAccessor() {
	   ReloadableResourceBundleMessageSource messageSource = messageSource();
	   return new MessageSourceAccessor(messageSource);
   }
   
   /**
    * Configuration StaticMessageSource
    * 
    * @return
    */
   @Bean
   public StaticMessageSource staticMessageSource() {
	   return new StaticMessageSource();
   }
   
   @Bean
   public MethodInvokingFactoryBean setStaticMessageSource() {
	   MethodInvokingFactoryBean methodInvokingFactoryBean = new MethodInvokingFactoryBean();
	   methodInvokingFactoryBean.setTargetClass(StaticMessageSource.class);
	   methodInvokingFactoryBean.setStaticMethod("com.anchordata.webframework.base.core.comp.msg.StaticMessageSource.setMsgSrcAcs");
	   
	   Object[] args = {messageSourceAccessor()};
	   methodInvokingFactoryBean.setArguments(args);
	   return methodInvokingFactoryBean;
   }
}
