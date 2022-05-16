package com.lxpantos.system.interceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.lxpantos.framework.dao.RedisDao;

public class ReportDataInterceptor extends HandlerInterceptorAdapter {
    private static final Logger logger = LoggerFactory.getLogger(ReportDataInterceptor.class);

    @Resource(name = "redisSessionDao")
    private RedisDao redisSessionDao;

    @Value("#{systemProperties['env'] ?: 'local'}")
    private String env;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String token = request.getParameter("token");
        logger.debug("ReportDataInterceptor : " + token);

        boolean result = false;

        if (token != null) {
            logger.debug("is? : " + redisSessionDao.getCommand().exists(token));

            if ("local".equals(env)) {
                result = true;
            } else {
                if (redisSessionDao.getCommand().exists(token) > 0) {
                    //redisSessionDao.getCommand().del(token);
                    result = true;
                } 
            }
        }

        if (!result) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            logger.debug("[System] This url is blocked. : " + request.getRequestURI());
        }

        return result;
    }
}
