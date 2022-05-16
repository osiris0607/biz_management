package com.lxpantos.framework.controller;

import java.io.BufferedWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.lxpantos.framework.service.ActionService;
import com.lxpantos.framework.service.SystemCacheItemService;
import com.lxpantos.framework.threadLocal.SessionThreadLocal;
import com.lxpantos.framework.util.HttpUtil;
import com.lxpantos.framework.util.Util;
import com.lxpantos.framework.vo.DataItem;
import com.lxpantos.framework.vo.MetaInfoItem;
import com.lxpantos.system.handler.WebsocketMessagingHandler;

@RestController
public class ActionController {
    private static final Logger logger = LoggerFactory.getLogger(ActionController.class);

    @Autowired
    ActionService actionService;

    @Autowired
    SystemCacheItemService systemCacheItemService;

    /*
     * NGFF 프로젝트 외부 호출에 사용하는 주소 패턴
     * 
     * access-key 를 header 에 붙이고 들어와야 인정 이 키는 application_{env}.yml 파일의
     * project.api.access-key 에 지정된 값이다.
     */
    @PostMapping(value = { "/actionArray/{module}.{className}.{methodName}", "/actionArray/{module}.{subModule}.{className}.{methodName}" }, consumes = "application/json")
    public void apiArray(@PathVariable String module, @PathVariable(required = false) String subModule, @PathVariable String className, @PathVariable String methodName, @RequestBody String content,
            HttpServletRequest request, HttpServletResponse response) throws IOException {
        // return parseArrayForWebSquare(actionService.process(module, subModule,
        // className, methodName, content, request, response));
        actionService.processArray(module, subModule, className, methodName, content, request, response);
    }

    /*
     * NGFF 프로젝트 외부 호출에 사용하는 주소 패턴
     * 
     * access-key 를 header 에 붙이고 들어와야 인정 이 키는 application_{env}.yml 파일의
     * project.api.access-key 에 지정된 값이다.
     */
    @PostMapping(value = { "/api/{module}.{className}.{methodName}", "/api/{module}.{subModule}.{className}.{methodName}" }, consumes = "application/json")
    public @ResponseBody String api(@PathVariable String module, @PathVariable(required = false) String subModule, @PathVariable String className, @PathVariable String methodName,
            @RequestBody String content, HttpServletRequest request, HttpServletResponse response) throws IOException {
        return actionService.process(module, subModule, className, methodName, content, request, response).toJson();
    }

    /* NGFF 프로젝트 내부 호출에 사용하는 주소 패턴 */
    @PostMapping(value = { "/internal/{module}.{className}.{methodName}", 
                           "/internal/{module}.{subModule}.{className}.{methodName}",
                           "/batch/{module}.{className}.{methodName}", 
                           "/batch/{module}.{subModule}.{className}.{methodName}" }, consumes = "application/json")
    public @ResponseBody String internal2(@PathVariable String module, @PathVariable(required = false) String subModule, @PathVariable String className, @PathVariable String methodName,
            @RequestBody String content, HttpServletRequest request, HttpServletResponse response) throws IOException {

        DataItem parameter = DataItem.parse(content);
        DataItem sessionInfo = parameter.getDataItem("_session_");

        if (sessionInfo != null) {
            logger.debug("## InternalCallInterceptor Session Info Delivered !!" + sessionInfo.toJson());
            SessionThreadLocal.set(sessionInfo);
        } else {
            logger.debug("## InternalCallInterceptor No Session Info !!");
            SessionThreadLocal.set(new DataItem());
        }

        return actionService.process(module, subModule, className, methodName, content, request, response).toJson();
    }

    @PostMapping(value = { "/action/{module}.{className}.{methodName}", "/action/{module}.{subModule}.{className}.{methodName}" }, consumes = "application/json")
    public @ResponseBody String action2(@PathVariable String module, @PathVariable(required = false) String subModule, @PathVariable String className, @PathVariable String methodName,
            @RequestBody String content, HttpServletRequest request, HttpServletResponse response) throws IOException {
        return actionService.process(module, subModule, className, methodName, content, request, response).toJson();
    }

    // 기존 XML 기반 방식의 레포트를 처리하기 위한 데이터 조회용 서블릿
    @RequestMapping(value = { "/reportXML/{module}.{className}.{methodName}" })
    public void reportXML(@PathVariable String module, @PathVariable String className, @PathVariable String methodName, HttpServletRequest request, HttpServletResponse response) throws IOException {

        DataItem parameter = new DataItem();
        Enumeration<String> em = request.getParameterNames();
        while (em.hasMoreElements()) {
            String name = em.nextElement();
            parameter.put(name, request.getParameter(name));
        }

        DataItem result = actionService.process(module, null, className, methodName, parameter.toJson(), request, response);
        MetaInfoItem meta = null;
        List<DataItem> body = result.getList("body");
        if (body == null || body.size() == 0 ) {
            body = new ArrayList<>();
        } else {
            meta = new MetaInfoItem( body.get(0).getMeta() );
        }

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/xml; charset=UTF-8");
        BufferedWriter bw = new BufferedWriter(response.getWriter());
        bw.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        bw.write("<xsync>\n");
        
        for (DataItem item : Util.emptyIfNull(body)) {
            bw.write("<RECORD>\n"); 
            for( String key : meta.getColumnNames() ) {
                bw.write("<" + key +">");
                bw.write("<![CDATA[" + item.getString(key, "") + "]]>");
                bw.write("</" + key +">\n");
            }
            bw.write("</RECORD>\n");
        }
        
        if( body.size() == 0 ) {
            bw.write("<RECORD/>\n");
        }
        
        bw.write("</xsync>");
        bw.flush();
    }

    /*
     * 시스템 메시지, 화면 UI Words, 인터페이스 아이템 목록 등 Redis 에 캐시 해놓고 항상 사용해야 하는 항목들을 로딩하기 위한
     * 서비스 주소
     */
    @RequestMapping(value = { "/internal/reloadSystemCacheItems" })
    public void reloadSystemCacheItems(HttpServletRequest request, HttpServletResponse response) {
        systemCacheItemService.reloadCachedItems();
    }

    /*
     * Url 호출을 통해 웹 소켓 메세징을 특정 사용자에게 보내주는 주소
     */
    @PostMapping(value = { "/internal/messaging/{userId}" })
    public void websocketSendMessage(@PathVariable String userId, @RequestBody String content, HttpServletRequest request, HttpServletResponse response) {
        DataItem message = DataItem.parse(content);
        message.put("_target_", userId);
        WebsocketMessagingHandler.subscriptionMessage(message);
    }
}