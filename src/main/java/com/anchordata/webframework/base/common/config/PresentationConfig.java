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


import java.io.IOException;
import java.net.MalformedURLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.annotation.MultipartConfig;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.multipart.support.MultipartFilter;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.ResourceUrlEncodingFilter;
import org.springframework.web.servlet.resource.VersionResourceResolver;
import org.springframework.web.servlet.view.UrlBasedViewResolver;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;

import com.fasterxml.jackson.core.JsonParser.Feature;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.navercorp.lucy.security.xss.servletfilter.XssEscapeServletFilter;

@Configuration
@EnableWebMvc
@MultipartConfig
@EnableAspectJAutoProxy
public class PresentationConfig implements WebMvcConfigurer {
	
	@Value("${anchorData.media.tiles}")
	private String tiles;
	
	@Value("${anchorData.media.upload-path}")
	private String defaultPath;
	
	
	@Value("${resources.location.video}")
	private String locationVideo;
	
	@Value("${resources.uri.video}")
	private String uriVideo;
	
	// Static Resource Cache 사용 여부
	@Value("${anchorData.chain.enabled}")
	private Boolean staticResouceEnalbed;
	
	
	// Version Number Auto Generation 여부
	@Value("${anchorData.chain.strategy.fixed.auto}")
	private Boolean strategyFixedAuto;
	
	// Version Number Generation이 수동일 경우 Version ?Number
	@Value("${anchorData.chain.strategy.fixed.version}")
	private String strategyFixedVersion;
	
	/*
	 * @Autowired private CurrentMenuUrlInterceptor currentMenuUrlInterceptor;
	 */
	
	/*
	 * @Autowired private DefaultPaginationRenderer defaultPaginationRenderer;
	 */
	
	// version Strategy시 사용
	@Bean
	public ResourceUrlEncodingFilter resourceUrlEncodingFilter() {
		return new ResourceUrlEncodingFilter();
    } 
	
	/**
	 * InterceptorRegistry Configuration
	 * 
	 */
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		
		/*
		 * registry.addInterceptor(currentMenuUrlInterceptor) .addPathPatterns("/**")
		 * .excludePathPatterns(new String[] {"/login/**", "/logout", "/static/**",
		 * "/loginProc" , "/login/google", "/authCallback"});
		 */
		
	}
	
	/**
	 * ObjectMapper Configuration
	 * 
	 * @return
	 */
	@Bean
	public ObjectMapper objectMapper() {
		ObjectMapper objectMapper = new ObjectMapper();
		objectMapper.configure(Feature.ALLOW_UNQUOTED_CONTROL_CHARS, true);
		objectMapper.enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY);
		return objectMapper;
	}
	
	
	/**
	 * Resource Configuration
	 * 
	 */
	@Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
		// Cache 사용 여부
		if (staticResouceEnalbed) {
			String version = "";
			// Fixed 방식 에서 version 생성 방식. 자동 생성 or Property에 있는 version 이용
			if (strategyFixedAuto) {
				SimpleDateFormat format1 = new SimpleDateFormat ( "yyyyMMddHHmmss");
				Date time = new Date();
				version = format1.format(time);
			}
			else {
				version = strategyFixedVersion;
			}
			
			registry.addResourceHandler("/assets/**")
					.addResourceLocations("/assets/")
					.setCachePeriod(0)
					.resourceChain(true)
					.addResolver(new VersionResourceResolver().addFixedVersionStrategy(version, "/**"));
		}
		else {
			registry.addResourceHandler("/assets/**")
			.addResourceLocations("/assets/")
			.setCachePeriod(0);
		}
		
//		registry.addResourceHandler(uriVideo +"/**").addResourceLocations("file:///" + locationVideo).setCachePeriod(0);
//		registry.addResourceHandler(uriVideo +"/**").addResourceLocations("file:///D:/RPA/").setCachePeriod(0);
    }
		
	/**
	 * Tiles Configuration
	 * 
	 * @return
	 */
	@Bean
	public TilesConfigurer tilesConfigurer() {
		final TilesConfigurer configurer = new TilesConfigurer();
		configurer.setDefinitions(new String[] { tiles });
		configurer.setCheckRefresh(true);
		return configurer;
	}
	
	/**
	 * ViewResolver Configuration
	 * 
	 * @return
	 */
	@Bean
	public UrlBasedViewResolver tilesViewResolver() {
		UrlBasedViewResolver resolver = new UrlBasedViewResolver();
		resolver.setViewClass(TilesView.class);
		resolver.setOrder(1);
		return resolver;
	} 
	
	/**
	 * PaginationManager Configuration
	 * 
	 * @return
	 */
	/*
	@Bean
	 * public DefaultPaginationManager paginationManager() { Map<String,
	 * PaginationRenderer> rendererType = new HashMap<String, PaginationRenderer>();
	 * rendererType.put("text",defaultPaginationRenderer);
	 * 
	 * DefaultPaginationManager paginationManager = new DefaultPaginationManager();
	 * paginationManager.setRendererType(rendererType); return paginationManager; }
	 */
	
	/**
	 * MultipartResolver Configuration
	 * 
	 * @return
	 * @throws MalformedURLException
	 * @throws IOException
	 */
	@Bean
    public CommonsMultipartResolver multipartResolver() throws MalformedURLException, IOException {
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
	    multipartResolver.setMaxInMemorySize(1048576);
	    return multipartResolver;
    }
	
	/**
	 * XSS Filter Configuration
	 * 
	 * @return
	 */
	@Bean
    public FilterRegistrationBean<MultipartFilter> getMultipartFilterRegistrationBean(){
        FilterRegistrationBean<MultipartFilter> registrationBean = new FilterRegistrationBean<MultipartFilter>();
        registrationBean.setFilter(new MultipartFilter());
        registrationBean.addInitParameter("multipartResolverBeanName", "multipartResolver");
        registrationBean.setOrder(1);
        registrationBean.addUrlPatterns("/*");    
        return registrationBean;
    }
	
	/**
	 * XSS Filter Configuration
	 * 
	 * @return
	 */
	@Bean
    public FilterRegistrationBean<XssEscapeServletFilter> getFilterRegistrationBean(){
        FilterRegistrationBean<XssEscapeServletFilter> registrationBean = new FilterRegistrationBean<XssEscapeServletFilter>();
        registrationBean.setFilter(new XssEscapeServletFilter());
        registrationBean.setOrder(2);
        registrationBean.addUrlPatterns("/*");    
        return registrationBean;
    }
	
	 @Bean
	 MappingJackson2JsonView jsonView(){
		 return new MappingJackson2JsonView();
	 }
}
	
