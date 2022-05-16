package com.lxpantos.system.listener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationStartedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import com.lxpantos.framework.service.SystemCacheItemService;

@Component
public class SystemDefaultListener implements ApplicationListener<ApplicationStartedEvent> {
    private static final Logger logger = LoggerFactory.getLogger(SystemDefaultListener.class);
    
    @Value("#{systemProperties['env']}")
    String env;
    
    @Autowired
    SystemCacheItemService systemCacheItemService;
    
    @Override
    public void onApplicationEvent(ApplicationStartedEvent applicationStartedEvent) {
        if( !"local".equals(env) ) {
            systemCacheItemService.reloadCachedItems();
            logger.debug("#### System Cache Info reloaded : messages, uiWords, interfaceItems ##### ");
        }
        logger.debug("#### Application Started ##### ");
    }
}
