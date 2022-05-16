package com.lxpantos.system.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.lang.Nullable;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.lxpantos.framework.service.SystemAccessLogService;
import com.lxpantos.framework.vo.DataItem;

public class AccessLogInterceptor extends HandlerInterceptorAdapter {
    private static final Logger logger = LoggerFactory.getLogger(AccessLogInterceptor.class);

    @Value("#{systemProperties['env']}")
    String env;
    
    @Autowired
    SystemAccessLogService accessLogService;
	
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        logger.debug("[System] Access Logs Started !!");
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable ModelAndView modelAndView) throws Exception {
        if(!"local".equals(env)) {
            DataItem responseData = (DataItem) request.getAttribute("_access_log_data_");
            accessLogService.insertLog(responseData);
            logger.debug("[System] Access Logs Finished!!");
        } else {
            logger.debug("[System] Access Logs Ignored!!");
        }
    }
}
