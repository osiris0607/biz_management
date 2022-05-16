package com.lxpantos.framework.service;

import java.io.BufferedWriter;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.LocaleResolver;

import com.lxpantos.framework.exception.BizException;
import com.lxpantos.framework.exception.FrameworkException;
import com.lxpantos.framework.threadLocal.TransactionLogThreadLocal;
import com.lxpantos.framework.util.Constants;
import com.lxpantos.framework.util.ContextProvider;
import com.lxpantos.framework.util.Util;
import com.lxpantos.framework.vo.DataItem;
import com.lxpantos.framework.vo.DataItemRowHandler;
import com.lxpantos.framework.vo.MetaInfoItem;
import com.lxpantos.framework.vo.PagingResult;

@Service
public class ActionService {
    private static final Logger logger = LoggerFactory.getLogger(ActionService.class);

    @Value("#{systemProperties['env']}")
    String env;

    @Autowired
    LocaleResolver localeResolver;

    @Autowired
    ServletContext context;

    @Autowired
    HttpSession session;

    @Resource(name = "redisMessageSource")
    private MessageSource messageSource;

    @Value("${project.process-package}")
    String processPackage;

    public DataItem process(String module, String subModule, String className, String methodName, String content, HttpServletRequest request, HttpServletResponse response) throws IOException {
        TransactionLogThreadLocal.clear();

        response.setStatus(HttpServletResponse.SC_OK);
        long timestamp = System.currentTimeMillis();

        String _class_name_ = module + "." + subModule + ".process." + className;
        if (subModule == null) {
            _class_name_ = module + ".process." + className;
        }

        if (content == null || content.length() == 0) {
            content = "{}";
        }

        DataItem logInfo = new DataItem();

        DataItem resHeader = new DataItem();
        resHeader.put("type", "SUCCESS");
        resHeader.put("message", "SUCCESS");
        resHeader.put("action", _class_name_ + "." + methodName);

        DataItem responseData = new DataItem();
        responseData.put("header", resHeader);

        // Service Layer 에 업무 파라미터를 제외한 값을 전달하기 위한 meta 정보 파라미터
        DataItem meta = new DataItem();
        meta.put("uri", request.getRequestURI());
        meta.put("remoteHost", request.getRemoteHost());
        meta.put("locale", this.localeResolver.resolveLocale(request));

        try {
            Class _class = Class.forName(processPackage + "." + _class_name_ + "Process");
            Annotation[] annotations = _class.getAnnotationsByType(com.lxpantos.framework.annotation.Process.class);

            if (annotations.length == 0) {
                throw new ClassNotFoundException();
            }

            Object instance = ContextProvider.getBean(_class);
            DataItem parameter = DataItem.parse(content);

            String paramlog = "\n######### Parameter ########\n";
            paramlog += " Action  : " + module + "." + ((subModule != null) ? subModule + "." : "") + className + "." + methodName + "\n";
            paramlog += " Request : " + parameter.toJson() + "\n";
            paramlog += "############################";
            logger.debug(paramlog);

            if (parameter.containsKey(Constants.PAGING_INFO)) {
                meta.put(Constants.PAGING_INFO, parameter.getDataItem(Constants.PAGING_INFO));

                Method method = instance.getClass().getMethod(methodName, DataItem.class, DataItem.class);
                Object rtn = method.invoke(instance, parameter, meta);

                if (rtn == null) {
                    responseData.put("body", new DataItem());
                } else {

                    if (!(rtn instanceof PagingResult)) {
                        throw new FrameworkException("SYS_005");
                    }

                    PagingResult pagingResult = (PagingResult) rtn;
                    responseData.put("body", pagingResult.getList());

                    DataItem paging = new DataItem();
                    paging.put("rows", pagingResult.getRows());
                    paging.put("pages", pagingResult.getPages());
                    paging.put("pageSize", pagingResult.getPageSize());
                    paging.put("rowSize", pagingResult.getRowSize());
                    paging.put("targetRow", pagingResult.getTargetRow());
                    paging.put("orderBy", pagingResult.getOrderBy());
                    paging.put("defaultRowSize", pagingResult.getDefaultRowSize());
                    paging.put("customRowSize", pagingResult.getCustomRowSize());

                    responseData.put("_paging_", paging);
                }
            } else {
                Method method = instance.getClass().getMethod(methodName, DataItem.class, DataItem.class);
                Object rtn = method.invoke(instance, parameter, meta);

                if (rtn == null) {
                    responseData.put("body", new DataItem());
                } else {
                    responseData.put("body", rtn);
                }
            }
        } catch (ClassNotFoundException | NoSuchMethodException e) {
            resHeader.put("type", "ERROR");
            resHeader.put("message", messageSource.getMessage("ngff.com.notfound", null, request.getLocale()));
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
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
                    message = messageSource.getMessage(be.getCode(), be.getMessageParameters(), request.getLocale());
                    resHeader.put("messageCode", be.getCode());
                }

                logger.error(message);
            } else if (e.getCause() instanceof FrameworkException) {
                FrameworkException be = (FrameworkException) e.getCause();
                logger.error(be.getCode());
                if (be.getCode() == null || be.getCode().isEmpty()) {
                    message = be.getMessage();
                } else {
                    message = messageSource.getMessage(be.getCode(), be.getMessageParameters(), request.getLocale());
                    resHeader.put("messageCode", be.getCode());
                }
                response.setStatus(Constants.HTTP_ERROR_SYS_004);
            } else if (e.getCause() instanceof DuplicateKeyException) {
                message = e.getMessage();
                if (e.getCause() != null) {
                    message = messageSource.getMessage("SYS_003", null, request.getLocale());
                    messageDetail = e.getCause().getMessage();
                }
                response.setStatus(Constants.HTTP_ERROR_SYS_003);
            } else {
                message = e.getMessage();
                if (e.getCause() != null) {
                    message = messageSource.getMessage("SYS_002", null, request.getLocale());
                    messageDetail = Util.getThrowableTrace(e.getCause());
                }

                responseData.put("reqContent", content);
                responseData.put("exceptionTrace", messageDetail);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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

        response.setContentType("application/json;charset=UTF-8");
        responseData.put("requestIpAddress", request.getHeader("X-Forwarded-For"));

        request.setAttribute("_access_log_data_", responseData);

        return responseData;
    }

    public void processArray(String module, String subModule, String className, String methodName, String content, HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        TransactionLogThreadLocal.clear();

        response.setStatus(HttpServletResponse.SC_OK);
        long timestamp = System.currentTimeMillis();

        String _class_name_ = module + "." + subModule + ".process." + className;
        if (subModule == null) {
            _class_name_ = module + ".process." + className;
        }

        if (content == null || content.length() == 0) {
            content = "{}";
        }

        DataItem resHeader = new DataItem();
        resHeader.put("type", "SUCCESS");
        resHeader.put("message", "SUCCESS");
        resHeader.put("action", _class_name_ + "." + methodName);

        DataItem responseData = new DataItem();
        responseData.put("header", resHeader);

        // Service Layer 에 업무 파라미터를 제외한 값을 전달하기 위한 meta 정보 파라미터
        DataItem meta = new DataItem();
        meta.put("uri", request.getRequestURI());
        meta.put("remoteHost", request.getRemoteHost());
        meta.put("locale", this.localeResolver.resolveLocale(request));

        try {
            Class _class = Class.forName(processPackage + "." + _class_name_ + "Process");
            Annotation[] annotations = _class.getAnnotationsByType(com.lxpantos.framework.annotation.Process.class);

            if (annotations.length == 0) {
                throw new ClassNotFoundException();
            }

            Object instance = ContextProvider.getBean(_class);
            DataItem parameter = DataItem.parse(content);

            String paramlog = "\n######### Parameter ########\n";
            paramlog += " Action  : " + module + "." + ((subModule != null) ? subModule + "." : "") + className + "." + methodName + "\n";
            paramlog += " Request : " + parameter.toJson() + "\n";
            paramlog += "############################";
            logger.debug(paramlog);

            // 핸들러 처리 메소드가 찾아지지 않으면, 정상처리 메소드를 찾아서 확인하고 이것도 없으면 404 에러를 유도한다.
            boolean handlerProcess = false;
            Method method = null;

            try {
                method = instance.getClass().getMethod(methodName, DataItem.class, DataItem.class, DataItemRowHandler.class);
                handlerProcess = true;
            } catch (NoSuchMethodException e) {
                try {
                    method = instance.getClass().getMethod(methodName, DataItem.class, DataItem.class);
                } catch (NoSuchMethodException e1) {
                    throw e1;
                }
            }

            // 메소드가 DataItemRowHandler 를 구현했을 경우에 실행되는 영역 : 스트리밍을 지원한다.
            if (handlerProcess) {
                DataItem status = new DataItem();
                status.put("rowIdx", 0);
                status.put("dataArrayLength", 0);
                status.put("firstFlag", true);
                MetaInfoItem columnMeta = new MetaInfoItem();

                BufferedWriter bw = new BufferedWriter(response.getWriter());
                bw.write("{ \n");
                bw.write("\"body\": { ");

                DataItemRowHandler handeler = new DataItemRowHandler() {
                    @Override
                    protected void processDataItemRow(DataItem item) {
                        try {
                            int rowIdx = status.getInt("rowIdx");

                            if (rowIdx == 0) {
                                columnMeta.parse(item.getMeta());

                                bw.write("\"columnInfo\": [\"" + String.join("\",\"", columnMeta.getColumnNames()) + "\"], \n");
                                bw.write(" \"data\": [");
                            }

                            for (int inx = 0; inx < columnMeta.getColumnNames().size(); inx++) {
                                String key = columnMeta.getColumnNames().get(inx);
                                bw.write((status.getBoolean("firstFlag")? "" : ",") + "\"" + escape( item.getString(key, "") ) + "\"");
                                status.put("firstFlag", false);
                                status.put("dataArrayLength", status.getLong("dataArrayLength") + 1 );
                            }

                            status.put("rowIdx", rowIdx + 1);
                        } catch (IOException e) {
                        }
                    }
                };
                method.invoke(instance, parameter, meta, handeler);
                
                //데이터 조회가 하나도 되지 않아서, 핸들러를 들어가지도 않았다. 
                if( status.getInt("rowIdx") == 0 ) {
                    bw.write(" \"columnInfo\": [],\n");                    
                    bw.write(" \"data\": [],\n");
                } else {
                    bw.write("],\n"); 
                }
                bw.write(" \"colCount\":\"" + columnMeta.getColumnNames().size() + "\",\n");
                bw.write(" \"rowCount\":\"" + status.getInt("rowIdx") + "\"\n");
                bw.write(" },\n");

                //이 데이터 처리의 결과 최종 데이터 항목 숫자와 Row * Col 을 체크해서 확인 
                if( status.getLong("dataArrayLength") != columnMeta.getColumnNames().size() * status.getInt("rowIdx") ) {
                    resHeader.put("type", "ERROR");
                    resHeader.put("message", "[SYS] Data formatting in Server framework has been failed.");
                }
                
                bw.write("\"header\":" + resHeader.toJson() + ", \n");
                
                timestamp = System.currentTimeMillis() - timestamp;
                bw.write(" \"elapsed\":\"" + timestamp + "\",\n");
                bw.write(" \"id\":\"" + TransactionLogThreadLocal.getId() + "\"\n");
                bw.write(" }");
                bw.flush();
                return;
            } else {
                // 메소드가 DataItemRowHandler 를 구현하지 않은 일반 버전일 경우 실행되는 영역
                Object rtn = method.invoke(instance, parameter, meta);
                List<DataItem> list = null;
                if (rtn instanceof DataItem) {
                    list = new ArrayList<>();
                    list.add((DataItem) rtn);
                } else if (rtn instanceof ArrayList) {
                    list = (ArrayList) rtn;
                }

                int rowIdx = 0;
                long dataArrayLength = 0L;
                MetaInfoItem columnMeta = new MetaInfoItem();

                BufferedWriter bw = new BufferedWriter(response.getWriter());
                bw.write("{ \n");
                bw.write("\"header\":" + resHeader.toJson() + ", \n");
                bw.write("\"body\": { ");
    
                for (DataItem item : Util.emptyIfNull(list)) {
                    if (rowIdx == 0) {
                        columnMeta.parse(item.getMeta());
                        bw.write("\"columnInfo\": [\"" + String.join("\",\"", columnMeta.getColumnNames()) + "\"], \n");
                        bw.write(" \"data\": [");
                    }
                    
                    for (int inx = 0; inx < columnMeta.getColumnNames().size(); inx++) {
                        String key = columnMeta.getColumnNames().get(inx);
                        bw.write((( rowIdx == 0 && inx == 0) ? "" : ",") + "\"" + escape( item.getString(key, "") ) + "\"");
                        dataArrayLength++;
                    }

                    rowIdx++;
                }

                //데이터 조회가 하나도 되지 않아서, 핸들러를 들어가지도 않았다. 
                if( list.size() == 0 ) {
                    bw.write(" \"columnInfo\": [],\n");                    
                    bw.write(" \"data\": [],\n");
                } else {
                    bw.write("],\n"); 
                }                
                
                bw.write(" \"colCount\":\"" + columnMeta.getColumnNames().size() + "\",\n");
                bw.write(" \"rowCount\":\"" + rowIdx + "\"\n");
                bw.write(" },\n");
                
                //이 데이터 처리의 결과 최종 데이터 항목 숫자와 Row * Col 을 체크해서 확인 
                if( dataArrayLength != columnMeta.getColumnNames().size() * rowIdx ) {
                    resHeader.put("type", "ERROR");
                    resHeader.put("message", "[SYS] Data formatting in Server framework has been failed.");
                }
                
                timestamp = System.currentTimeMillis() - timestamp;
                bw.write(" \"elapsed\":\"" + timestamp + "\",\n");
                bw.write(" \"id\":\"" + TransactionLogThreadLocal.getId() + "\"\n");
                bw.write(" }");
                bw.flush();
                return;
            }
        } catch (ClassNotFoundException | NoSuchMethodException e) {
            resHeader.put("type", "ERROR");
            resHeader.put("message", messageSource.getMessage("ngff.com.notfound", null, request.getLocale()));
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
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
                    message = messageSource.getMessage(be.getCode(), be.getMessageParameters(), request.getLocale());
                    resHeader.put("messageCode", be.getCode());
                }

                logger.error(message);
            } else if (e.getCause() instanceof FrameworkException) {
                FrameworkException be = (FrameworkException) e.getCause();
                logger.error(be.getCode());
                if (be.getCode() == null || be.getCode().isEmpty()) {
                    message = be.getMessage();
                } else {
                    message = messageSource.getMessage(be.getCode(), be.getMessageParameters(), request.getLocale());
                    resHeader.put("messageCode", be.getCode());
                }
                response.setStatus(Constants.HTTP_ERROR_SYS_004);
            } else if (e.getCause() instanceof DuplicateKeyException) {
                message = e.getMessage();
                if (e.getCause() != null) {
                    message = messageSource.getMessage("SYS_003", null, request.getLocale());
                    messageDetail = e.getCause().getMessage();
                }
                response.setStatus(Constants.HTTP_ERROR_SYS_003);
            } else {
                message = e.getMessage();
                if (e.getCause() != null) {
                    message = messageSource.getMessage("SYS_002", null, request.getLocale());
                    messageDetail = Util.getThrowableTrace(e.getCause());
                }

                responseData.put("reqContent", content);
                responseData.put("exceptionTrace", messageDetail);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

            resHeader.put("type", "ERROR");
            resHeader.put("message", message);

            if (!"prod".equals(env)) {
                resHeader.put("messageDetail", messageDetail);
            }

            response.getWriter().write(responseData.toJson());
        } finally {
            /********* Log Info ***********/
            TransactionLogThreadLocal.printDataSourceLog(logger);
            /********* Log Info ***********/
        }

        timestamp = System.currentTimeMillis() - timestamp;
        responseData.put("elapsed", timestamp);
        responseData.put("id", TransactionLogThreadLocal.getId());

        response.setContentType("application/json;charset=UTF-8");
        responseData.put("requestIpAddress", request.getHeader("X-Forwarded-For"));
        request.setAttribute("_access_log_data_", responseData);
        response.getWriter().write(responseData.toJson());
    }
    
    private String escape( String input ) {
        input = input.replaceAll("(\\r|\\n|\\r\\n)+", "\\\\n");
        input = input.replaceAll("\"", "\\\\\"");
        input = input.replaceAll("\t", "\\\\t");
        return input;
    }
}
