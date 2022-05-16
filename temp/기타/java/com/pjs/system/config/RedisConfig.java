package com.lxpantos.system.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.lxpantos.framework.dao.RedisDao;
import com.lxpantos.framework.dao.RedisSubscriptionDao;
import com.lxpantos.framework.vo.DataItem;
import com.lxpantos.system.handler.WebsocketMessagingHandler;

import io.lettuce.core.pubsub.RedisPubSubAdapter;

@Configuration
public class RedisConfig {
    private static final Logger logger = LoggerFactory.getLogger(RedisConfig.class);

    @Value("${redis.host}")
    String redisHost;

    @Value("${redis.port}")
    int port;

    /* 데이터 캐시 */
    @Bean
    public RedisDao redisCacheDao() {
        logger.debug("@@@@@ redis cache (0) : " + redisHost);
        return new RedisDao(redisHost, port, 0);
    }

    /* 사용자 세션 캐시 */
    @Bean
    public RedisDao redisSessionDao() {
        logger.debug("@@@@@ redis session (1) : " + redisHost);
        return new RedisDao(redisHost, port, 1);
    }

    /* 시스템 메시지 스토어 캐시 */
    @Bean(name = "redisMessageStoreDao")
    public RedisDao redisMessageStoreDao() {
        logger.debug("@@@@@ redis messageStore (2) : " + redisHost);
        return new RedisDao(redisHost, port, 2);
    }

    /* Excel Upload Data 캐시 */
    @Bean(name = "redisExcelTempDao")
    public RedisDao redisExcelTempDao() {
        logger.debug("@@@@@ redis messageStore (3) : " + redisHost);
        logger.debug("@@@@@ port : " + port);
        return new RedisDao(redisHost, port, 3);
    }
    
    /* Transaction Tracking 캐시 */
    @Bean(name = "redisTransactionTrackingDao")
    public RedisDao redisTransactionTrackingDao() {
        logger.debug("@@@@@ redis messageStore (4) : " + redisHost);
        logger.debug("@@@@@ port : " + port);
        return new RedisDao(redisHost, port, 4);
    }    

    @Bean(name = "redisSubscriptionDao")
    public RedisSubscriptionDao redisSubscriptionDao() {
        logger.debug("@@@@@ redis redisSubscriptionDao (1) : " + redisHost);
        logger.debug("@@@@@ port : " + port);

        RedisPubSubAdapter<String, String> listener = new RedisPubSubAdapter<String, String>() {
            @Override
            public void message(String channel, String message) {
                WebsocketMessagingHandler.subscriptionMessage(DataItem.parse(message));
            }
        };

        return new RedisSubscriptionDao(redisHost, port, 1, listener);
    }
}
