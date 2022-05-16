package com.lxpantos.framework.service;

import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.util.Locale;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import com.lxpantos.framework.dao.CachedDao;
import com.lxpantos.framework.dao.RedisDao;
import com.lxpantos.framework.exception.BizException;
import com.lxpantos.framework.exception.FrameworkException;
import com.lxpantos.framework.threadLocal.TransactionLogThreadLocal;
import com.lxpantos.framework.util.ContextProvider;
import com.lxpantos.framework.util.HttpUtil;
import com.lxpantos.framework.util.Util;
import com.lxpantos.framework.vo.DataItem;

@Service
public class KafkaConsumerService {
    @Value("#{systemProperties['env']}")
    String env;

    @Resource(name = "redisMessageSource")
    private MessageSource messageSource;

    @Resource(name = "redisMessageStoreDao")
    private RedisDao redisMessageStoreDao;

    @Autowired
    SystemAccessLogService systemAccessLogService;

    @Autowired
    ActionService actionService;

    @Value("${project.process-package}")
    String processPackage;

    @Resource(name = "mainDao")
    private CachedDao mainDao;

    private static final Logger logger = LoggerFactory.getLogger(KafkaConsumerService.class);

    @KafkaListener(topics = "${project.kafka.topic-name}", groupId = "${spring.kafka.consumer.group-id}", autoStartup = "${spring.kafka.consumer.auto-start:false}")
    public void consume(String messageText) throws IOException {
        logger.debug(String.format("Consumed message : %s", messageText)); // {"itemid":"202111081002-12cs55egAgcATcA","interfaceid":"eaiMD0230"}
        DataItem received = DataItem.parse("{\"message\":" + messageText + "}");
        received = received.getDataItem("message");

        String logId = Util.getId();

        DataItem message = new DataItem();
        message.put("logId", logId);
        message.put("groupId", InetAddress.getLocalHost().getHostName());
        message.put("itemId", received.getString("itemid"));
        message.put("interfaceId", received.getString("interfaceid"));

        // 수신한 메세지를 모두 이곳에 저장한다.
        mainDao.insert("com.system.insertKafkaNotifications", message);

        DataItem interfaceItem = (DataItem) redisMessageStoreDao.getCommand().get("interface_id_" + message.getString("interfaceId"));
        DataItem exeResult = internalCallProcess(interfaceItem.getString("reltClassNm"), interfaceItem.getString("reltMthdNm"), message);

        // 수행을 마친 후, 상태 정보를 업데이트 한다.
        if (exeResult != null) {
            DataItem header = exeResult.getDataItem("header");

            DataItem status = new DataItem();
            status.put("logId", logId);
            status.put("status", header.getString("type"));
            status.put("message", header.getString("message"));
            mainDao.update("com.system.updateKafkaNotificationStatus", status);
        }
    }

    private DataItem internalCallProcess(String className, String methodName, DataItem parameter) throws IOException {
        TransactionLogThreadLocal.clear();
        long timestamp = System.currentTimeMillis();

        if (parameter == null) {
            parameter = new DataItem();
        }

        String[] segs = className.split(".");
        String _class_name_ = "";
        if (segs.length == 3) {
            _class_name_ = segs[0] + "." + segs[1] + ".process." + segs[2];
        } else {
            _class_name_ = segs[0] + "." + segs[1] + "." + segs[2] + ".process." + segs[3];
        }

        DataItem logInfo = new DataItem();

        DataItem resHeader = new DataItem();
        resHeader.put("type", "SUCCESS");
        resHeader.put("message", "SUCCESS");
        resHeader.put("action", _class_name_);

        DataItem responseData = new DataItem();
        responseData.put("header", resHeader);

        /********* Log Info ***********/
        logInfo.put("viewUrl", "POST_BATCH");
        logInfo.put("actionUrl", _class_name_);
        logInfo.put("paramText", parameter.toJson());
        /********* Log Info ***********/

        // Service Layer 에 업무 파라미터를 제외한 값을 전달하기 위한 meta 정보 파라미터
        DataItem meta = new DataItem();
        meta.put("uri", _class_name_);
        meta.put("locale", new Locale("ko"));

        try {
            Class _class = Class.forName(processPackage + "." + _class_name_ + "Process");
            Annotation[] annotations = _class.getAnnotationsByType(com.lxpantos.framework.annotation.Process.class);

            if (annotations.length == 0) {
                throw new ClassNotFoundException();
            }

            Object instance = ContextProvider.getBean(_class);

            String paramlog = "\n######### Parameter ########\n";
            paramlog += " Action  : " + _class_name_ + "." + methodName + "\n";
            paramlog += " Request : " + parameter.toJson() + "\n";
            paramlog += "############################";
            logger.debug(paramlog);

            Method method = instance.getClass().getMethod(methodName, DataItem.class, DataItem.class);
            Object rtn = method.invoke(instance, parameter, meta);

            if (rtn == null) {
                responseData.put("body", new DataItem());
            } else {
                responseData.put("body", rtn);
            }
        } catch (ClassNotFoundException | NoSuchMethodException e) {
            resHeader.put("type", "ERROR");
            resHeader.put("message", messageSource.getMessage("SYS_001", null, new Locale("ko")));
        } catch (Exception e) {
            String message = null;
            String messageDetail = null;
            e.printStackTrace();

            if (e.getCause() instanceof BizException) {
                BizException be = (BizException) e.getCause();
                logger.error(be.getCode());
                if (be.getCode() == null || be.getCode().isEmpty()) {
                    message = be.getMessage();
                } else {
                    message = messageSource.getMessage(be.getCode(), be.getMessageParameters(), new Locale("ko"));
                    resHeader.put("messageCode", be.getCode());
                }

                logger.error(message);
            } else if (e.getCause() instanceof FrameworkException) {
                FrameworkException be = (FrameworkException) e.getCause();
                logger.error(be.getCode());
                if (be.getCode() == null || be.getCode().isEmpty()) {
                    message = be.getMessage();
                } else {
                    message = messageSource.getMessage(be.getCode(), be.getMessageParameters(), new Locale("ko"));
                    resHeader.put("messageCode", be.getCode());
                }
            } else if (e.getCause() instanceof DuplicateKeyException) {
                message = e.getMessage();
                if (e.getCause() != null) {
                    message = messageSource.getMessage("SYS_003", null, new Locale("ko"));
                    messageDetail = e.getCause().getMessage();
                }
            } else {
                message = e.getMessage();
                if (e.getCause() != null) {
                    message = messageSource.getMessage("SYS_002", null, new Locale("ko"));
                    messageDetail = e.getCause().getMessage();
                }
            }

            resHeader.put("type", "ERROR");
            resHeader.put("message", message);

            if (!"prod".equals(env)) {
                resHeader.put("messageDetail", messageDetail);
            }
        } finally {
            /********* Log Info ***********/
            TransactionLogThreadLocal.printDataSourceLog(logger);
            /********* Log Info ***********/
        }

        timestamp = System.currentTimeMillis() - timestamp;
        responseData.put("elapsed", timestamp);
        responseData.put("id", TransactionLogThreadLocal.getId());

        if (!"local".equals(env)) {
            systemAccessLogService.insertLog(responseData);
            logger.debug("[System] Access Logs Finished!!");
        } else {
            logger.debug("[System] Access Logs Ignored!!");
        }

        return responseData;
    }

}