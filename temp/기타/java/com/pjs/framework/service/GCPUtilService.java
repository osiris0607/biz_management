package com.lxpantos.framework.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.WriteChannel;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.Storage.SignUrlOption;
import com.google.cloud.storage.StorageOptions;
import com.google.common.collect.Lists;
import com.lxpantos.framework.util.HttpUtil;
import com.lxpantos.framework.util.Util;

@Service
public class GCPUtilService implements InitializingBean, DisposableBean {
    private static final Logger logger = LoggerFactory.getLogger(GCPUtilService.class);

    @Value("#{systemProperties['env']}")
    String env;

    @Value("${gcp.project-id}")
    String gcpProjectId;

    @Value("${gcp.credential}")
    String gcpCredential;

    @Autowired
    HttpServletRequest request;

    Storage storage;

    public boolean uploadFileToStorage(String gcpCloudBucketName, String objectName, File file) {
        boolean result = false;
        BlobId blobId = BlobId.of(gcpCloudBucketName, objectName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType("application/octet-stream").build();
        try {
       
            ByteBuffer buf = ByteBuffer.allocateDirect(1024);
            @SuppressWarnings("resource")
            FileInputStream fis = new FileInputStream(file);
            FileChannel cin = fis.getChannel();
            WriteChannel writer = storage.writer(blobInfo);

            while (cin.read(buf) != -1) {
                buf.flip();
                writer.write(buf);
                buf.clear();
            }
            writer.close();
            
            //storage.create(blobInfo, Files.readAllBytes(file.toPath()));
            result = true;
        } catch (IOException e) {
            result = false;
            logger.error(Util.getThrowableTrace(e));
        }

        return result;
    }

    public void downloadFileFromStorage(String gcpCloudBucketName, String objectName, File file) throws IOException {
        BlobId blobId = BlobId.of(gcpCloudBucketName, objectName);
        Blob blob = storage.get(blobId);
        blob.downloadTo(file.toPath());
    }

    /* GCP Cloud Storage 에서 직접 다운로드 받을 수 있는 URL 을 생성할 수 있는 메소드 */
    public String downloadSignedUrl(String gcpCloudBucketName, String objectName, String filenName) throws IOException {
        BlobId blobId = BlobId.of(gcpCloudBucketName, objectName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).build();
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("response-content-disposition", HttpUtil.getDisposition(filenName, request.getHeader("User-Agent")));
        return storage.signUrl(blobInfo, 5, TimeUnit.SECONDS, SignUrlOption.withQueryParams(queryParams)).toString();
    }

    public void deleteFileInStorage(String gcpCloudBucketName, String objectName) throws IOException {
        BlobId blobId = BlobId.of(gcpCloudBucketName, objectName);
        storage.delete(blobId);
    }

    @Override
    public void destroy() throws Exception {
        // TODO Auto-generated method stub

    }

    @Override
    public void afterPropertiesSet() throws Exception {
        InputStream is = this.getClass().getClassLoader().getResourceAsStream("gcp/" + gcpCredential);
        GoogleCredentials credentials = GoogleCredentials.fromStream(is).createScoped(Lists.newArrayList("https://www.googleapis.com/auth/cloud-platform"));

        // cloudStorage
        storage = StorageOptions.newBuilder().setCredentials(credentials).setProjectId(gcpProjectId).build().getService();
    }
}
