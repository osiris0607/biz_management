package com.lxpantos.system.handler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.lxpantos.framework.dao.RedisDao;
import com.lxpantos.framework.dao.RedisSubscriptionDao;
import com.lxpantos.framework.util.Util;
import com.lxpantos.framework.vo.DataItem;

@Component
public class WebsocketMessagingHandler extends TextWebSocketHandler {
    private static final Logger logger = LoggerFactory.getLogger(WebsocketMessagingHandler.class);
    private static Map<String, List<WebSocketSession>> sessionMap = new HashMap<>();

    @Resource(name = "redisSessionDao")
    RedisDao redisSessionDao;

    @Resource(name = "redisSubscriptionDao")
    RedisSubscriptionDao redisSubscriptionDao;

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        removeSession(session);
        printMap();
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {

    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage messageText) throws Exception {
        DataItem message = DataItem.parse(messageText.getPayload());
        String action = message.getString("action");

        if ("ping".equals(action)) {
            return;
        }

        try {
            this.getClass().getMethod(action, WebSocketSession.class, DataItem.class).invoke(this, session, message);
        } catch (Exception e) {
            logger.error("Method : " + action + " is not defined in this class.");
        }
    }

    // 웹 소켓 일반 메시지의 처리
    public void message(WebSocketSession session, DataItem message) {
        sendToTarget( message.getString("_target_"), message);
    }

    // 웹 소켓 사용자가 접속 직후 처음으로 보낸 요청을 처리
    public void register(WebSocketSession session, DataItem message) {
        logger.debug("register : {}", message.toJson());
        DataItem userInfo = redisSessionDao.get(message.getString("sessionToken"));
        String userId = userInfo.getString("userId");
        addSession(userId, session);
        printMap();
    }

    //Redis Subscription 으로 부터 전달받은 메세지를 실제 WebSocket session 에 전송을 담당하는 메소드
    public static void subscriptionMessage(DataItem message) {
        String target = message.getString("_target_");

        if( "_all_".equals(target) ) {
            for (String key : sessionMap.keySet()) {
                List<WebSocketSession> list = sessionMap.get(key);
                for (WebSocketSession session : Util.emptyIfNull(list)) {
                    try {
                        session.sendMessage(new TextMessage(message.toJson()));
                    } catch (IOException e) {
                        logger.error(Util.getThrowableTrace(e));
                    }
                }
            }
        } else {
            List<WebSocketSession> list = sessionMap.get(target);
            for (WebSocketSession session : Util.emptyIfNull(list)) {
                try {
                    session.sendMessage(new TextMessage(message.toJson()));
                } catch (IOException e) {
                    logger.error(Util.getThrowableTrace(e));
                }
            }
        }
    }

    //Message 를 전송할 때는 Redis 에 Publish 하는 것으로 종료
    private void sendToTarget(String target, DataItem message) {
        message.put("_target_", target);
        redisSubscriptionDao.publish(message);
    }

    private void addSession(String key, WebSocketSession session) {
        List<WebSocketSession> list = sessionMap.get(key);
        if (list == null) {
            list = new ArrayList<>();
            sessionMap.put(key, list);
        }
        list.add(session);
    }

    private void removeSession(WebSocketSession session) {
        Set<String> set = new HashSet<>();

        for (String key : sessionMap.keySet()) {
            List<WebSocketSession> list = sessionMap.get(key);
            list.remove(session);

            if (list.size() == 0) {
                set.add(key);
            }
        }

        for (String key : set) {
            sessionMap.remove(key);
        }
    }

    private void printMap() {
        StringBuilder sb = new StringBuilder();
        sb.append("\n##### WebSocket Session Map #####\n");
        int sessions = 0;
        for (String key : sessionMap.keySet()) {
            List<WebSocketSession> list = sessionMap.get(key);
            sessions += list.size();
            sb.append(" key " + key + " holds " + list.size() + " sessions.\n");
        }
        sb.append(" key      total : " + sessionMap.keySet().size() + "\n");
        sb.append(" sessions total : " + sessions + "\n");
        sb.append("#################################\n");

        logger.debug(sb.toString());
    }
}