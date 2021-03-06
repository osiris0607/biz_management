package com.lxpantos.system.interceptor;

import java.time.Duration;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.lxpantos.framework.dao.RedisDao;
import com.lxpantos.framework.threadLocal.ArchiveSelectorThreadLocal;
import com.lxpantos.framework.threadLocal.SessionThreadLocal;
import com.lxpantos.framework.util.Constants;
import com.lxpantos.framework.util.HttpUtil;
import com.lxpantos.framework.vo.DataItem;

public class SessionCheckInterceptor extends HandlerInterceptorAdapter {
    private static final Logger logger = LoggerFactory.getLogger(SessionCheckInterceptor.class);

    @Resource(name = "redisSessionDao")
    private RedisDao redisSessionDao;

    @Resource(name = "redisMessageSource")
    private MessageSource messageSource;
    
    @Value("${project.use-archive}")
    boolean useArchive; 

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        boolean result = true;

        String sessionToken = request.getHeader(Constants.X_SESSION_TOKEN);
        if( sessionToken == null ) {
            
            Cookie[] cookies = request.getCookies();
            for (int inx = 0; cookies != null && inx < cookies.length; inx++) {
                logger.debug("######################");
                logger.debug(cookies[inx].getName());
                logger.debug(cookies[inx].getValue());
                logger.debug("######################");
            }
            
            
            sessionToken = HttpUtil.getCookie(request, Constants.X_SESSION_TOKEN);
        }
//        logger.debug("######################");
//        logger.debug("sessionToken        : " + sessionToken);
//        logger.debug("######################");

        // ????????? ????????? session Token ??? ???????????? ????????? ????????? ???????????? ????????? ????????????.
        if (sessionToken == null) {
            DataItem message = new DataItem();

            DataItem header = new DataItem();
            header.put("type", "ERROR");
            header.put("message", messageSource.getMessage("ngff.com.nosession", null, request.getLocale()));
            header.put("messageCode", "COM_AUTH_000");

            message.put("header", header);
            message.put("body", new DataItem());

            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            HttpUtil.jsonWriter(response, message);

            return false;
        }

        // ????????? Session Token ??? ???????????? Redis ??? ????????? ????????? ?????? ??????.
        String stored = (String) redisSessionDao.getCommand().get(sessionToken);

//        logger.debug("######################");
//        logger.debug("sessionToken        : " + sessionToken);
//        logger.debug("sessionToken stored : " + stored);
//        logger.debug("######################");

        if (stored == null) {
            // Redis ??? ??????????????? ?????? ??????, ????????? ???????????? ????????? ????????????.
            DataItem message = new DataItem();

            DataItem header = new DataItem();
            header.put("type", "ERROR");
            header.put("message", messageSource.getMessage("ngff.com.nosession", null, request.getLocale()));
            header.put("messageCode", "COM_AUTH_000");

            message.put("header", header);
            message.put("body", new DataItem());

            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            HttpUtil.jsonWriter(response, message);

            return false;
        } else {
            // Redis ??? ????????? ?????? ??????, Redis ??? ????????? ????????? Session ????????? ?????? ???????????? ????????? ThreadLocal ???
            // ???????????????.
            if( !"INIT".equals(stored) ) {
                SessionThreadLocal.set(DataItem.parse(stored));
                // ??? Session Token ??? ?????? Redis ?????? ????????? ??? ?????? ????????????.
                redisSessionDao.getCommand().expire(sessionToken, Duration.ofSeconds(3600));
            }
        }

        // ????????? ????????? ?????? ???????????? DB ?????? ????????? ???????????????. : ???????????? ???????????? ????????? false 
        if( useArchive ) {
            ArchiveSelectorThreadLocal.set(request.getHeader("x-archive-flag"));
        } 

        return result;
    }
}
