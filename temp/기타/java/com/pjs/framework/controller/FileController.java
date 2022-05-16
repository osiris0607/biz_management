package com.lxpantos.framework.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.net.http.HttpResponse;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.json.JSONObject;
import org.json.XML;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.LocaleResolver;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.Storage.SignUrlOption;
import com.google.cloud.storage.StorageOptions;
import com.lxpantos.forwarding.com.file.service.FileService;
import com.lxpantos.forwarding.fwd.util.FwdConstants;
import com.lxpantos.framework.exception.BizException;
import com.lxpantos.framework.service.GCPUtilService;
import com.lxpantos.framework.service.MessageService;
import com.lxpantos.framework.util.HttpUtil;
import com.lxpantos.framework.util.Util;
import com.lxpantos.framework.vo.DataItem;

@RestController
public class FileController {
    private static final Logger logger = LoggerFactory.getLogger(FileController.class);

    @Value("#{systemProperties['env']}")
    String env;

    @Value("${project.file.storage}")
    String projecFileStorage;

    @Value("${gcp.project-id}")
    String gcpProjectId;

    @Value("${gcp.cloud-storage.bucket-name}")
    String gcpCloudBucketName;

    @Autowired
    ServletContext context;

    @Autowired
    HttpSession session;

    @Autowired
    LocaleResolver localeResolver;

    @Autowired
    MessageSource messageSource;

    @Autowired
    FileService fileService;

    @Autowired
    MessageService messageService;

    @Autowired
    GCPUtilService gCPUtilService;

    @PostMapping(value = { "/file/upload/{fileType}/{groupId}", "/file/upload/{fileType}" })
    public @ResponseBody String uploadAttachment(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "fileType", required = true) String fileType,
            @PathVariable(value = "groupId", required = false) String groupId, @RequestParam(name = "upload") MultipartFile[] files) throws IOException {

        DataItem attachInfo = new DataItem();
        List<DataItem> fileList = new ArrayList<DataItem>();
        if (groupId == null) {
            groupId = Util.getId();
        }

        fileService.insertFileInfo(groupId, fileType, files);

        // 완료되면 리턴을 정리
        DataItem result = new DataItem();
        result.put("status", "SUCCESS");
        result.put("groupId", groupId);

        return result.toJson();
    }

    @GetMapping(value = "/file/download/{fileType}/{fileId}")
    public void downloadFile(HttpServletRequest request, HttpServletResponse response, @PathVariable(value = "fileType", required = true) String fileType,
            @PathVariable(value = "fileId", required = true) String fileId) throws IOException {
        DataItem fileInfo = fileService.selectFileInfo(fileId);

        if (fileInfo == null || !fileType.equals(fileInfo.getString("fileType"))) {
            throw new BizException("SYS_007");
        }

        try {
            String objectName = fileType + "/" + fileId;
            String url = gCPUtilService.downloadSignedUrl(gcpCloudBucketName, objectName, fileInfo.getString("clientFileName"));
            logger.debug("url : " + url );
            HttpUtil.redirect(request, response, url);
            response.setHeader("location", url);
            response.setStatus(HttpServletResponse.SC_SEE_OTHER);
        } catch (IOException e) {
            logger.error(e.getMessage(), e);
        }
    }

    @PostMapping(value = "/file/xmlUpload", headers = ("Content-Type= multipart/form-data"))
    public @ResponseBody DataItem upload(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "file", required = true) List<MultipartFile> file) {

        File destFile = new File(System.getProperty("java.io.tmpdir"), Util.getId());
        DataItem result = new DataItem();

        try {

            for (int i = 0; i < file.size(); i++) {
                FileUtils.copyInputStreamToFile(file.get(i).getInputStream(), destFile);
                String content = FileUtils.readFileToString(destFile);
                JSONObject jObject = XML.toJSONObject(content);
                ObjectMapper mapper = new ObjectMapper();
                mapper.enable(SerializationFeature.INDENT_OUTPUT);
                Object json = mapper.readValue(jObject.toString(), Object.class);
                String output = mapper.writeValueAsString(json);
                DataItem item = DataItem.parse(output);
                result.put("data" + (i + 1), item);
            }

            result.append("result", true);

        } catch (IOException ie) {
            FileUtils.deleteQuietly(destFile);
            // 업로드된 파일 삭제
            try {
                FileUtils.forceDelete(destFile);
            } catch (IOException e) {
            }

            DataItem error = new DataItem();
            error.append("type", "BIZ");
            if ("prod".equalsIgnoreCase(this.env)) {
                error.append("message", messageService.getMessage("RTIS.MSG_99999"));
            } else {
                error.append("message", Util.getThrowableTrace(ie));
            }
            result.put("error", error);
            return result;
        }
        return result;
    }

    @GetMapping(value = "/file/download/simpleContent/{fileId}")
    public void downloadSimpleContent(@PathVariable(value = "fileId", required = true) String fileId, HttpServletRequest request, HttpServletResponse response) throws IOException {
        DataItem fileInfo = fileService.downloadSimpleContent(fileId);

        if (fileInfo == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String content = fileInfo.getString("content");
        content = (content == null) ? "" : content;

        String disposition = getDisposition(fileInfo.getString("fileName"), request);

        response.setHeader("Set-Cookie", "fileDownload=true; path=/");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Content-Type", "application/octet-stream; charset=" + fileInfo.getString("encoding"));
        response.setHeader("Content-Transfer-Encoding", "binary");
        // response.setHeader("Content-Length", content.length() + "");
        response.setHeader("Content-Disposition", disposition);

        IOUtils.write(content, response.getOutputStream(), fileInfo.getString("encoding"));
    }

    /*
     * FwdConstats.java 파일의 Static 상수들을 javascript 파일로 변환하여 화면에서 사용할 수 있도록 하는 서비스
     * NFF_WebSquare 프로젝트의 resources/config_xx.xml 파일 내부에 이 설정이 첨부돼 있다.
     */
    @GetMapping(value = "/file/static/script/fwdConstants.js")
    public void fwdConstants(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Field[] fields = FwdConstants.class.getDeclaredFields();
        StringBuilder sb = new StringBuilder();
        sb.append("var FwdConstants = function(){}; \n");

        for (int inx = 0; fields != null && inx < fields.length; inx++) {
            Field field = fields[inx];
            try {
                if ("java.lang.String".equals(field.getType().getName())) {
                    sb.append("FwdConstants." + field.getName() + " = \"" + field.get(null) + "\";\n");
                } else {
                    if (field.get(null) != null) {
                        sb.append("FwdConstants." + field.getName() + " = " + field.get(null) + ";\n");
                    }
                }
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }

        IOUtils.write(sb.toString(), response.getOutputStream());
    }

    private String getDisposition(String title, HttpServletRequest request) {
        title = title.trim();
        String name = null;
        String disposition = null;
        String header = request.getHeader("User-Agent");
        logger.debug("header : " + header);
        try {
            if (header.contains("Edge")) {
                name = URLEncoder.encode(title, "UTF-8").replaceAll("\\+", "%20");
                disposition = "attachment;filename=\"" + name + "\";";
            } else if (header.contains("MSIE") || header.contains("Trident")) { // IE 11버전부터 Trident로 변경되었기때문에 추가해준다.
                name = URLEncoder.encode(title, "UTF-8").replaceAll("\\+", "%20");
                disposition = "attachment;filename=" + name + "\";";
            } else if (header.contains("Chrome")) {
                name = URLEncoder.encode(title, "UTF-8").replaceAll("\\+", "%20");
                disposition = "attachment; filename=" + name;
            } else if (header.contains("Opera")) {
                name = new String(title.getBytes("UTF-8"), "ISO-8859-1");
                disposition = "attachment; filename=\"" + name + "\"";
            } else if (header.contains("Firefox")) {
                name = new String(title.getBytes("UTF-8"), "ISO-8859-1");
                disposition = "attachment; filename=" + name;
            }
        } catch (Exception e) {
            disposition = "attachment;filename=\"" + name + "\";";
        }

        return disposition;
    }
}