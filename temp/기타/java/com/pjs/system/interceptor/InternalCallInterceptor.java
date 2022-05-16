package com.lxpantos.system.interceptor;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.lxpantos.framework.dao.RedisDao;
import com.lxpantos.framework.util.HttpUtil;

public class InternalCallInterceptor extends HandlerInterceptorAdapter {
    private static final Logger logger = LoggerFactory.getLogger(InternalCallInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String loadBalancers = "10.85.177.220,10.85.177.120,10.85.177.20";

        String ipAddress = HttpUtil.getClientIpAddress(request);
        logger.debug("## InternalCallInterceptor IN!! : " + ipAddress);

        List<String> list = new ArrayList<>();
        if (ipAddress.contains(",")) {
            list = Arrays.asList(ipAddress.split(","));
        } else {
            list.add(ipAddress);
        }

        boolean internalFlag = false;
        for (String ipAddr : list) {
            if (loadBalancers.contains(ipAddr)) {
                continue;
            }

            if (ipAddr.equals("127.0.0.1") || ipAddr.equals("localhost") // 내 컴퓨터의 로컬 호출  
                    || ipAddr.startsWith("10.85.177") // NGFF 서버 군 끼리의 호출 
                    || ipAddr.startsWith("10.65.88")  // NGFF 서버군에서 볼 때, 프로젝트 룸에서의 호출 
               ) {
                internalFlag = true;
            }
        }

        if (!internalFlag) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }

        return true;
    }
}
