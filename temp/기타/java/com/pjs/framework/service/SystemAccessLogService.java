package com.lxpantos.framework.service;

import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.google.api.gax.paging.Page;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.Storage.BlobListOption;
import com.google.cloud.storage.StorageOptions;
import com.lxpantos.framework.dao.BigQueryDao;
import com.lxpantos.framework.dao.RedisDao;
import com.lxpantos.framework.threadLocal.SessionThreadLocal;
import com.lxpantos.framework.threadLocal.TransactionLogThreadLocal;
import com.lxpantos.framework.util.Util;
import com.lxpantos.framework.vo.DataItem;

@Service
public class SystemAccessLogService {
    private static final Logger logger = LoggerFactory.getLogger(SystemAccessLogService.class);

    private ArrayList<DataItem> logs = new ArrayList<DataItem>();

    @Value("#{systemProperties['env']}")
    String env;

    @Resource(name = "redisSessionDao")
    private RedisDao redisSessionDao;

    @Resource(name = "bigQueryDao")
    private BigQueryDao bigQueryDao;

    @Autowired
    private HttpServletRequest request;

    @Value("${gcp.project-id}")
    String gcpProjectId;

    public List<DataItem> retrieveLogFileList() {
        Storage storage = StorageOptions.newBuilder().setProjectId(gcpProjectId).build().getService();
        String bucketName = "bigquery-data-export-storage";
        Page<Blob> blobs = storage.list(bucketName, BlobListOption.currentDirectory());
        Iterator<Blob> blobIterator = blobs.iterateAll().iterator();

        List<DataItem> list = new ArrayList<>();

        while (blobIterator.hasNext()) {
            Blob blob = blobIterator.next();
            logger.debug(blob.getName());
            list.add(new DataItem().append("fileName", blob.getName()));
        }
        
        return list;
    }
    
    public DataItem retreiveSignedUrl( String fileId ) {
        Storage storage = StorageOptions.newBuilder().setProjectId(gcpProjectId).build().getService();
        String bucketName = "bigquery-data-export-storage";
        BlobId blobId = BlobId.of(bucketName, fileId);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).build();
        URL url = storage.signUrl(blobInfo, 10, TimeUnit.SECONDS);
        return new DataItem().append("signedUrl", url.toString());
    }

    /***
     * 사용자 접근 로그 저장
     */
    public void insertLog(DataItem responseData) {
        DataItem log = new DataItem();
        String accessToken = request.getHeader("x-session-token");
        String ipAddress = request.getHeader("X-Forwarded-For");

        if (ipAddress == null) {
            ipAddress = request.getRemoteAddr();
        } else {
            if (ipAddress.contains(",")) {
                ipAddress = (request.getHeader("X-Forwarded-For") + "").split(",")[0];
            }
        }

        log.put("ID", TransactionLogThreadLocal.getId());
        log.put("URL", request.getRequestURI());
        log.put("ACCESS_TOKEN", accessToken);
        log.put("IP_ADDRESS", ipAddress);
        log.put("PROGRAM_ID", request.getHeader("x-program-id"));

        if (log.getString("URL").contains("/action/")) {
            // logger.debug("responseData : " + responseData);
            if (responseData == null) {
                responseData = new DataItem().append("header", new DataItem()).append("body", new DataItem());
            }

            String status = responseData.getDataItem("header").getString("type");
            log.put("STATUS", status);
            if ("SUCCESS".equals(status)) {
                // 요청이 로그인인 경우, sessionToken 을 새로 발급하는 경우가 있기 때문에, 이에 대한 대응이 필요하다
                if ("com.auth.process.Auth".equals(responseData.getDataItem("header").getString("action"))) {
                    accessToken = responseData.getDataItem("body").getString("sessionToken");
                    log.put("ACCESS_TOKEN", accessToken);
                }
            } else if ("ERROR".equals(status)) {
                log.put("EXCEPTION_CODE", responseData.getDataItem("header").getString("messageCode"));
                log.put("EXCEPTION_MESSAGE", responseData.getDataItem("header").getString("message"));
                log.put("EXCEPTION_TRACE", responseData.getString("exceptionTrace"));
                log.put("REQ_CONTENT", responseData.getString("reqContent"));
            }

            // 로그인이 정상적으로 작동한 경우 && 정상적인 토큰을 통해 접근한 모든 API 의 경우 sessionUserInfo 를 얻을 수 있다.
            DataItem sessionUserInfo = SessionThreadLocal.get();
            if (sessionUserInfo != null) {
                log.put("USER_ID", sessionUserInfo.getString("userId"));
                log.put("EMAIL_ADDRESS", sessionUserInfo.getString("emailAddr"));
                log.put("EMP_NO", sessionUserInfo.getString("empNo"));
                log.put("DEPT_NM", sessionUserInfo.getString("deptNm"));
                log.put("USER_NM", sessionUserInfo.getString("userNm"));
                log.put("NATION_CD", sessionUserInfo.getString("nationCd"));
                log.put("SESSION_INFO", sessionUserInfo.toJson());
            }

            log.put("ELAPSED", responseData.getInt("elapsed"));
            log.put("TRANSACTIONAL_LOGS", TransactionLogThreadLocal.getDataSourceLog());

            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            sf.setTimeZone(TimeZone.getTimeZone("UTC"));
            log.put("REQ_TIMESTAMP", sf.format(new Date()));
        }

        log = DataItem.parse(log.toJson());
        logger.debug("log (" + logs.size() + ") :" + log.toJson());
        logs.add(log);

        if (logs.size() > 10) {
            synchronized (logs) {
                ArrayList<DataItem> logs_copy = (ArrayList<DataItem>) logs.clone();
                logger.debug("logs_copy (" + logs_copy.size() + ")");

                logs.clear();
                new InsertAllThread(bigQueryDao, logs_copy).start();
            }
        }
    }

    class InsertAllThread extends Thread {
        String datasetName = "LOGS";
        String tableName = "APPLICATION_ACCESS_LOGS";

        List<DataItem> list;
        BigQueryDao bigQueryDao;

        public InsertAllThread(BigQueryDao bigQueryDao, List<DataItem> list) {

            logger.debug("InsertAllThread IN !!");

            this.list = list;
            this.bigQueryDao = bigQueryDao;
        }

        public void run() {
            logger.debug("RUN !!");

            bigQueryDao.insertAll(gcpProjectId, datasetName, tableName, list);
            logger.debug("[SYSTEM] AccessLogs flushed : size(" + list.size() + ")");
        }
    }
}
