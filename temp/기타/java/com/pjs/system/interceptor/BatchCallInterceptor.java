package com.lxpantos.system.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.lxpantos.framework.util.HttpUtil;
import com.lxpantos.framework.vo.DataItem;

public class BatchCallInterceptor extends HandlerInterceptorAdapter {
    private static final Logger logger = LoggerFactory.getLogger(BatchCallInterceptor.class);

    @Value("${project.batch.server-url}")
    String batchServerUrl;

    @Value("${project.batch.private-token}")
    String privateToken;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String batchJobId = request.getHeader("x-batch-jobid");
        
        if( batchJobId == null ) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }
        
        DataItem header = new DataItem();
        header.put("Content-Type", "application/json");
        header.put("private-token", privateToken);

        DataItem result = HttpUtil.get(batchServerUrl + "/api/v1/job/list?filter:jobId=" + batchJobId, new DataItem(), header);
        if ( result == null || result.getList("list").size() == 0 ) { 
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return false;
        }

        return true;
    }
}
