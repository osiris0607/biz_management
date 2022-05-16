package com.lxpantos.system.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.lxpantos.framework.dao.RedisDao;
import com.lxpantos.framework.message.RedisMessageSource;
import com.lxpantos.system.interceptor.APIInterceptor;
import com.lxpantos.system.interceptor.AccessLogInterceptor;
import com.lxpantos.system.interceptor.BatchCallInterceptor;
import com.lxpantos.system.interceptor.BlockInterceptor;
import com.lxpantos.system.interceptor.InternalCallInterceptor;
import com.lxpantos.system.interceptor.ReportDataInterceptor;
import com.lxpantos.system.interceptor.SessionCheckInterceptor;

@Configuration
public class MVCConfig implements WebMvcConfigurer {
  
    @Bean
    public AccessLogInterceptor accessLogInterceptor() {
        return new AccessLogInterceptor();
    }
    
    @Bean
    public APIInterceptor apiInterceptor() {
        return new APIInterceptor();
    }     
    
    @Bean
    public InternalCallInterceptor internalCallInterceptor() {
        return new InternalCallInterceptor();
    }    
    
    @Bean
    public BatchCallInterceptor batchCallInterceptor() {
        return new BatchCallInterceptor();
    }        
    
	@Bean
	public SessionCheckInterceptor sessionCheckInterceptor() {
		return new SessionCheckInterceptor();
	}
	
    @Bean
    public BlockInterceptor blockInterceptor() {
        return new BlockInterceptor();
    }	
    
    @Bean
    public ReportDataInterceptor reportDataInterceptor() {
        return new ReportDataInterceptor();
    }
    
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(blockInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns("/index.html")
                .excludePathPatterns("/action/**")
                .excludePathPatterns("/actionArray/**")
                .excludePathPatterns("/internal/**")
                .excludePathPatterns("/batch/**")
                .excludePathPatterns("/api/**")
                .excludePathPatterns("/report/**")
                .excludePathPatterns("/reportXML/**")
                .excludePathPatterns("/file/**")
                .excludePathPatterns("/excel/**")
                .excludePathPatterns("/messaging")
                //이후 내용은 임시 설정들
                .excludePathPatterns("/chatbot.html")
                .excludePathPatterns("/messaging.html")
                .excludePathPatterns("/excelUpload.html")
                .excludePathPatterns("/reportViewer.html")
                .excludePathPatterns("/accessLog.html")
                .excludePathPatterns("/fileUpload.html");
	          
        registry.addInterceptor(accessLogInterceptor())
                .addPathPatterns("/action/**")
                .addPathPatterns("/actionArray/**")                
                .addPathPatterns("/report/**")
                .addPathPatterns("/file/**")
                .addPathPatterns("/excel/**")
                .excludePathPatterns("/file/static/script/fwdConstants.js");
        
        registry.addInterceptor(apiInterceptor())
                .addPathPatterns("/api/**"); //  /internal 로 들어오는 요청을 여기에서 검증함.          
        
        registry.addInterceptor(internalCallInterceptor())
                .addPathPatterns("/internal/**") //  /internal 로 들어오는 요청을 여기에서 검증함.
                .addPathPatterns("/batch/**"); //  jjobs 에 의해 batch 로 호출되는 요청을 여기에서 검증함.      
        
        registry.addInterceptor(batchCallInterceptor())
                .addPathPatterns("/batch/**"); //  jjobs 에 의해 batch 로 호출되는 요청을 여기에서 검증함.        
        
		registry.addInterceptor(sessionCheckInterceptor())
		        .addPathPatterns("/action/**")
		        .addPathPatterns("/actionArray/**")
		        .addPathPatterns("/report/**")
		        .addPathPatterns("/file/**")
		        .addPathPatterns("/excel/**")
		        .excludePathPatterns("/internal/**")  //  /internal 로 들어오는 요청은 내부 호출인지 확인하고 session 체크를 하지 않는다.
		        .excludePathPatterns("/messaging")  // websocket URL 은 별도로 session 검증이 필요치 않음
		        .excludePathPatterns("/file/static/**")  //static 파일류로 인증이 필요치 않음
				.excludePathPatterns("/action/com.auth.Auth.*")  // 로그인 및 인증 관련 메소드의 모음으로, 인증 이전에 수행되므로 예외
				.excludePathPatterns("/action/com.sysmsg.SCCOM0042.reloadAllMessages") // 시스템 메시지를 로드하는 메소드로 인증이 필요치 않음으로 예외
				;
		
		  registry.addInterceptor(reportDataInterceptor())
		       .addPathPatterns("/reportXML/**"); // 리포트 데이터를 인출하기 위한 서비스 API 패턴으로, 원타임 패스워드 방식의 단순 인증을 지원한다.
	}
	
    @Bean(name = "redisMessageSource")
    @Qualifier("redisMessageSource")
	public MessageSource messageSource( @Qualifier("redisMessageStoreDao") RedisDao redisMessageStoreDao ) {
	    RedisMessageSource messageSource = new RedisMessageSource(redisMessageStoreDao);
	    return messageSource;
	}
}  