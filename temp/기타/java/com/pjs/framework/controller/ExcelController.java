package com.lxpantos.framework.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.Comment;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.lxpantos.forwarding.com.excel.service.ExcelRowHandler;
import com.lxpantos.forwarding.com.sample.service.EmployeeService;
import com.lxpantos.framework.dao.RedisDao;
import com.lxpantos.framework.exception.BizException;
import com.lxpantos.framework.exception.FrameworkException;
import com.lxpantos.framework.service.GCPUtilService;
import com.lxpantos.framework.service.MessageService;
import com.lxpantos.framework.service.MessagingService;
import com.lxpantos.framework.service.SystemAccessLogService;
import com.lxpantos.framework.threadLocal.SessionThreadLocal;
import com.lxpantos.framework.threadLocal.TransactionLogThreadLocal;
import com.lxpantos.framework.util.Constants;
import com.lxpantos.framework.util.ContextProvider;
import com.lxpantos.framework.util.Util;
import com.lxpantos.framework.vo.DataItem;
import com.lxpantos.framework.vo.DataItemRowHandler;
import com.lxpantos.framework.vo.MetaInfoItem;

@RestController
public class ExcelController {
    private static final Logger logger = LoggerFactory.getLogger(ExcelController.class);

    static final SimpleDateFormat DATE_MASK_1 = new SimpleDateFormat("yyyy-MM-dd");
    static final SimpleDateFormat DATE_MASK_2 = new SimpleDateFormat("yyyyMMdd");
    static final SimpleDateFormat DATE_MASK_3 = new SimpleDateFormat("MMdd-HHmmss");

    @Value("#{systemProperties['env']}")
    String env;

    @Value("${project.process-package}")
    String processPackage;

    @Value("${project.file.storage}")
    String fileStorage;
    
    @Value("${gcp.cloud-storage.download-temporary}")
    String downloadTemporary;    
    
    @Value("${project.context}")
    String projectContext;

    @Resource(name = "redisExcelTempDao")
    RedisDao redisExcelTempDao;

    @Resource(name = "redisMessageSource")
    private MessageSource messageSource;

    @Autowired
    SystemAccessLogService accessLogService;

    @Autowired
    MessagingService messagingService;

    @Autowired
    MessageService messageService;

    @Autowired
    EmployeeService employeeService;

    @Autowired
    GCPUtilService gCPUtilService;

    @PostMapping(value = "/excel/download/{fileName}")
    public String downlodStoredExcelFile(@PathVariable String fileName, HttpServletRequest request, HttpServletResponse response, @RequestBody String content) throws IOException {
        DataItem result = new DataItem();
        result.put("status", "success");

        DataItem param = DataItem.parse(content);
        if ("delete".equals(param.getString("action"))) {
            gCPUtilService.deleteFileInStorage(downloadTemporary, "EXCEL_DOWNLOAD" + "/" + fileName);
        } else {
            String url = gCPUtilService.downloadSignedUrl(downloadTemporary, "EXCEL_DOWNLOAD" + "/" + fileName, fileName);
            result.put("url", url);
            logger.debug(" resultresultresult : " + result.toJson());
        }

        return result.toJson();
    }

    @PostMapping(value = "/excel/download/async")
    public @ResponseBody DataItem downloadAsync(HttpServletRequest request, HttpServletResponse response, @RequestBody String content) {
        if (content == null) {
            content = "{}";
        }
        DataItem parameter = DataItem.parse(content);

        logger.debug("parameter :" + parameter.toJson());
        String action = parameter.getString("action");
        DataItem param = parameter.getDataItem("param");
        DataItem option = parameter.getDataItem("option");

        if (option.getString("fileName") == null) {
            option.put("fileName", "ExcelDownload");
        }

        if (option.getString("title") == null) {
            option.put("title", "Excel");
        }

        if (option.getInt("headerCount") == 0) {
            option.put("headerCount", 1);
        }

        String id = Util.getId();
        String fileName = option.getString("fileName") + "_" + DATE_MASK_3.format(new Date()) + ".xlsx";

        DataItem sessionUser = SessionThreadLocal.get();

        DataItem notification = new DataItem();
        notification.put("id", id);
        notification.put("action", "excelExportDownloadStart");
        notification.put("title", option.getString("title"));
        notification.put("fileName", fileName);
        notification.put("url", "/" + projectContext + "/excel/download/" + fileName);
        messagingService.sendToTarget(sessionUser.getString("userId"), notification);
        logger.debug("[Excel Async] WebSocket : excelExportDownloadStart");

        new Thread(() -> {
            logger.debug("[Excel Async] Thread In !!");
            // ThreadLocal 정보는 새 Thread 내부에서 연결되지 않으므로, 반드시 Thread 바깥에서 확인한 정보를 연결해 받아야 한다.
            SessionThreadLocal.set(sessionUser); // Session 정보 릴레이
            TransactionLogThreadLocal.clear(); // 트랜잭션 TransactionLogThreadLocal 의 시작점을 여기로

            // 엑셀 저장용 워크북 선언
            SXSSFWorkbook workbook = new SXSSFWorkbook(100);

            // 헤더 셀의 스타일 설정
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setFontHeightInPoints((short) 11);
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);// 얘를 꼭 해야함

            // 일반 셀의 스타일 설정
            CellStyle style = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setFontHeightInPoints((short) 11);
            style.setFont(font);
            
            workbook.setCompressTempFiles(true);
            SXSSFSheet sheet = (SXSSFSheet) workbook.createSheet("시트이름");
            sheet.trackAllColumnsForAutoSizing();
            sheet.setRandomAccessWindowSize(100);
            DataItem status = new DataItem();
            status.put("rowIdx", 0);
            status.put("headerCount", option.getInt("headerCount"));
           
            // 화면에서 특정 컬럼을 Numeric 으로 만들기 위해 보내는 정보가 numberCols 이므로, 이를 가공해 status 에 넣어주도록
            // 한다.
            String numberCols = option.getString("numberCols");
            Map<String, CellStyle> map = new HashMap<String, CellStyle>();
            status.put("numberCols", map);
            if (numberCols != null) {
                DataFormat dataFormat = workbook.createDataFormat();
                CellStyle numericStyle = workbook.createCellStyle();
                
                for( String colInfo : numberCols.split(",") ) { 
                    if( colInfo.contains("|") ) {
                        String key = colInfo.split("|")[0];
                        String format = colInfo.split("|")[1];
                        
                        logger.debug( key + " "  + format  );
                        
                        numericStyle.cloneStyleFrom(style);
                        numericStyle.setDataFormat(dataFormat.getFormat(format));                        
                        map.put(key, numericStyle);
                    } else {
                        numericStyle.cloneStyleFrom(style);
                        numericStyle.setDataFormat(dataFormat.getFormat("#.###############"));
                        map.put(colInfo, numericStyle);    
                    }
                }
            }

            // 실행 대상이 되는 process 를 얻는다.
            String[] segs = action.split("\\.");
            String methodName = segs[segs.length - 1];

            String _class_name_ = "";
            if (segs.length == 3) {
                _class_name_ = segs[0] + "." + segs[1] + ".process." + segs[2];
            } else {
                _class_name_ = segs[0] + "." + segs[1] + ".process." + segs[2];
            }

            // access log 를 저장할 데이터 선언
            DataItem resHeader = new DataItem();
            resHeader.put("type", "SUCCESS");
            resHeader.put("message", "SUCCESS");

            DataItem responseData = new DataItem();
            responseData.put("header", resHeader);

            // 서비스 클래스 실행부 : JDBC ResultSet 핸들러를 사용해 Record by Record 로 처리를 수행한다.
            try {
                Class _class = Class.forName(processPackage + "." + _class_name_ + "Process");
                logger.debug("[Excel Async] Service Ready " + _class);

                Object instance = ContextProvider.getBean(_class);
                Method method = instance.getClass().getMethod(methodName, DataItem.class, DataItem.class, DataItemRowHandler.class);

                ExcelDownloadResultHandler handeler = new ExcelDownloadResultHandler(status, sheet, headerStyle, style);
                Object rtn = method.invoke(instance, param, new DataItem(), handeler);

                logger.debug("[Excel Async] Service Invoked ");
            } catch (Exception e) {
                logger.error("[Excel Async] ERROR !!" + Util.getThrowableTrace(e));

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

                    responseData.put("reqContent", param.toJson());
                    responseData.put("exceptionTrace", messageDetail);
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }

                resHeader.put("type", "ERROR");
                resHeader.put("message", message);
            } finally {
                logger.debug("[Excel Async] Service finally ");
                /********* Log Info ***********/
                TransactionLogThreadLocal.printDataSourceLog(logger);
                /********* Log Info ***********/
            }

            FileOutputStream fos = null;
            File file = null;

            try {
                file = new File(System.getProperty("java.io.tmpdir") + "/" + fileName);
                fos = new FileOutputStream(file);
                workbook.write(fos);
                fos.flush();
                workbook.dispose();
                logger.debug("[Excel Async] GCP Cloud Upload Before. : " + "EXCEL_DOWNLOAD" + "/" + fileName);
                gCPUtilService.uploadFileToStorage(downloadTemporary, "EXCEL_DOWNLOAD" + "/" + fileName, file);
                logger.debug("[Excel Async] GCP Cloud Upload After. : " + "EXCEL_DOWNLOAD" + "/" + fileName);
            } catch (Exception e) {
                logger.error(Util.getThrowableTrace(e));
                e.printStackTrace();
            } finally {
                if (fos != null) {
                    try {
                        fos.close();
                        FileUtils.deleteQuietly(file);
                        logger.debug("[Excel Async] File Deleted.");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }

            notification.put("action", "excelExportDownloadFinish");
            messagingService.sendToTarget(sessionUser.getString("userId"), notification);
            logger.debug("[Excel Async] WebSocket : excelExportDownloadFinish");

            // 엑세스 로그 인터셉터를 벗어나서 Thread 가 종료되므로, 해당 내용을 여기에 적는다.
            if (!"local".equals(env)) {
                accessLogService.insertLog(responseData);
                logger.debug("[System] Access Logs Finished!!");
            } else {
                logger.debug("[System] Access Logs Ignored!!");
            }
        }).start();
        return new DataItem();
    }

    /* 엑셀 다운로드에서 쿼리의 레코드가 한 줄씩 인출 될 때 해당 레코드의 처리를 담당하는 핸들러 */
    class ExcelDownloadResultHandler extends DataItemRowHandler {
        DataItem status;
        SXSSFSheet sheet;
        CellStyle headerStyle;
        CellStyle style;
        Set<String> colNames;
        Map<String, CellStyle> numberCols;
        MetaInfoItem meta;
        
        public ExcelDownloadResultHandler(DataItem status, SXSSFSheet sheet, CellStyle headerStyle, CellStyle style) {
            this.status = status;
            this.sheet = sheet;
            this.headerStyle = headerStyle;
            this.style = style;
            this.numberCols = (Map<String, CellStyle>)this.status.get("numberCols");
        }

        @Override
        public void processDataItemRow( DataItem item) {
            if( meta == null ) {
                meta = new MetaInfoItem();
                meta.parse( item.getMeta() );
            }

            int rowIdx = status.getInt("rowIdx");
            SXSSFCell cell = null;
            int colIndex = 0;

            SXSSFRow row = sheet.createRow(rowIdx);

            if (rowIdx < status.getInt("headerCount")) {
                for (String key : meta.getColumnNames() ) {
                    cell = row.createCell(colIndex);

                    if (rowIdx == 0 && !"prod".equals(env)) {
                        setCellComment(cell, key);
                    }

                    cell.setCellStyle(headerStyle);
                    cell.setCellValue(item.getString(key, ""));

                    colIndex++;
                }
            } else {
                for (String key : meta.getColumnNames() ) {
                    cell = row.createCell(colIndex);
                    
                    if (numberCols != null && numberCols.containsKey(key)) {
                        CellStyle numberStyle = numberCols.get(key);
                        cell.setCellStyle(numberStyle);
                        cell.setCellValue(item.getLong(key));
                    } else {
                        cell.setCellStyle(style);
                        cell.setCellValue(item.getString(key, ""));
                    }                    

                    colIndex++;
                }
            }
            colIndex = 0;
            status.put("rowIdx", rowIdx + 1);
        }
    }

    protected void setCellComment(Cell cell, String message) {
        Drawing drawing = cell.getSheet().createDrawingPatriarch();
        CreationHelper factory = cell.getSheet().getWorkbook().getCreationHelper();
        // When the comment box is visible, have it show in a 1x3 space
        ClientAnchor anchor = factory.createClientAnchor();
        anchor.setCol1(cell.getColumnIndex());
        anchor.setCol2(cell.getColumnIndex() + 1);
        anchor.setRow1(cell.getRowIndex());
        anchor.setRow2(cell.getRowIndex() + 1);
        anchor.setDx1(100);
        anchor.setDx2(100);
        anchor.setDy1(100);
        anchor.setDy2(100);

        // Create the comment and set the text+author
        Comment comment = drawing.createCellComment(anchor);
        RichTextString str = factory.createRichTextString(message);
        comment.setString(str);
        comment.setAuthor("Apache POI");
        cell.setCellComment(comment);
    }

    @PostMapping(value = "/excel/upload", headers = ("Content-Type= multipart/form-data"))
    public @ResponseBody DataItem upload(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "file", required = true) MultipartFile file,
            @RequestParam(value = "columnInfo") String columnInfo_, @RequestParam(value = "userId") String userId_, @RequestParam(value = "titleCount") int titleCount) {
        String token = request.getHeader("x-session-token");
        logger.debug("original name = " + file.getOriginalFilename());
        logger.debug("columnInfo= " + columnInfo_);
        logger.debug("userId = " + userId_);
        logger.debug("token = " + token);
        logger.debug("titleCount = " + titleCount);
        // logger.debug("titleCount = " + titleCount);
        // logger.debug("dataCount = " + dataCount);

        /* 세션 정보를 얻는다. */
        // DataItem sessionData = XSSUtil.strip(SessionThreadLocal.get());
        // logger.debug("sessionData = " + sessionData);

        String str = request.getParameter("columnInfo");
        String[] results = str.split(",");

        String userId = request.getParameter("userId");
        DataItem result = new DataItem();

        /* 엑셀 Sheet를 받기 위한 변수 */
        String groupId = Util.getId();
        int uploadSeqNo = 1;
        List<DataItem> sheetData = null;
        DataItem rowData = null;
        int cellCount = 0;

        /* 업로드 된 Excel File을 읽어서 템프 테이블에 저장한다. */
        Workbook workbook = null;
        Sheet worksheet = null;
        Row workrow = null;
        Cell workcell = null;

        /*
         * <처리순서> 1. 업로드된 파일을 특정 경로에 쓴다. 2. 업로드된 파일이 암호화된 문서인지 체크한다. 3. 암호화된 문서일 경우 암호화를
         * 해제한다. 4. 암호화 되지 않은 문서일 경우 동일하게 파일로 생성한다.
         */
        // 1. 파일을 특정 경로에 쓴다.
        File destFile = new File(System.getProperty("java.io.tmpdir"), Util.getId());
        try {
            FileUtils.copyInputStreamToFile(file.getInputStream(), destFile);
        } catch (IOException ie) {
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

        /*
         * // 2. DRM 암호화된 문서인지 확인한다. WorkPackager packager = null; try { packager = new
         * WorkPackager(); } catch(Error err) { logger.error(err.getMessage(), err); //
         * 업로드된 파일 삭제 try { FileUtils.forceDelete(destFile); } catch(IOException e) {
         * logger.error(e.getMessage(), e); }
         *
         * DataItem error = new DataItem(); error.append("type", "BIZ");
         * if("prod".equalsIgnoreCase(this.env)) { error.append("message",
         * this.messageSourceAccessor.getMessage("RTIS.MSG_99999",
         * "System error has occurred.\n\nContact your system administrator.")); } else
         * { error.append("message", Util.getThrowableTrace(err)); } result.put("error",
         * error); return result; }
         *
         *
         * if(packager.IsPackageFile(destFile.getAbsolutePath())) { String extractFile =
         * destFile.getParentFile().getAbsolutePath() + "/" + Util.getUUID(); boolean
         * rslt = packager.DoExtract(this.fsdInitPath, this.fsdCpKey,
         * destFile.getAbsolutePath(), extractFile); // 파일 복호화를 실패하면 에러 출력후 종료 if(!rslt)
         * { // 업로드된 파일 삭제 try { FileUtils.forceDelete(destFile); } catch(IOException e)
         * { logger.error(e.getMessage(), e); } result.append("result", false); String
         * errorMessage = "[ " + packager.getLastErrorNum() + " ] " +
         * packager.getLastErrorStr(); if(!Util.isNull(errorMessage)) { errorMessage =
         * errorMessage.replaceAll("\\\\n", "<br/>"); } result.append("message",
         * errorMessage); return result; } // 기존파일을 삭제하고 대상 파일을 교체한다. try {
         * FileUtils.forceDelete(destFile); } catch(IOException e) {
         * logger.error(e.getMessage(), e); } destFile = new File(extractFile); }
         */
        logger.debug("destFile = " + destFile);

        try {
            workbook = WorkbookFactory.create(destFile);

            int colIdx = 0;
            boolean isNullRow = true;

            worksheet = workbook.getSheetAt(0);

            int rowCount = 0;

            uploadSeqNo = 1;
            sheetData = new ArrayList<DataItem>();

            rowLoop: for (int r = 0; r < worksheet.getPhysicalNumberOfRows(); r++) {
                /* 100 row별로 읽은 Data를 저장한다. */
                if ((r > 1) && ((r % 100) == 1)) {
                    insertExcelRowData(groupId, sheetData);
                    sheetData = new ArrayList<DataItem>();
                }

                workrow = worksheet.getRow(r);
                if (workrow == null) {
                    logger.debug("workrow is null");
                    break rowLoop;
                }

                colIdx = 2;
                if (r == 0) {
                    cellCount = workrow.getPhysicalNumberOfCells();
                }
                // logger.debug("cellCount = " + cellCount);

                /* 제목 행이면 */
                rowData = new DataItem();
                if (r < titleCount) {
                    rowData.append("_type_", "TITLE");
                    for (int c = 0; c < cellCount; c++) {
                        workcell = workrow.getCell(c);
                        if (workcell != null) {
                            if (isNullRow) {
                                isNullRow = this.isNullValue(workcell);
                            }
                            // rowData.append("tmpCts" + Util.lpad(colIdx, 3, '0'),
                            // this.getCellValue(workcell));
                            rowData.append(results[colIdx - 2], this.getCellValue(workcell));
                        }
                        colIdx++;
                    }
                    rowData.append("userId", userId);
                } else {
                    rowData.append("_type_", "DATA");
                    for (int c = 0; c < cellCount; c++) {
                        workcell = workrow.getCell(c);
                        if (workcell != null) {
                            if (isNullRow) {
                                isNullRow = this.isNullValue(workcell);
                            }
                            // rowData.append("tmpCts" + Util.lpad(colIdx, 3, '0'),
                            // this.getCellValue(workcell));
                            rowData.append(results[colIdx - 2], this.getCellValue(workcell));
                        }
                        colIdx++;
                    }
                    rowData.append("userId", userId);
                }
                // logger.debug("isNullRow = " + isNullRow);
                if (isNullRow) {
                    break rowLoop;
                } else {
                    sheetData.add(rowData);
                }
                uploadSeqNo++;
                ++rowCount;
            }

            if (sheetData.size() > 0) {
                insertExcelRowData(groupId, sheetData);
            }
            // logger.debug("row count = " + rowCount);

            result.append("groupId", groupId);
            result.append("rowCount", rowCount);
            result.append("result", true);
            result.append("message", "");
        } catch (Exception ex) {
            result.append("result", false);
            if ("prod".equalsIgnoreCase(this.env)) {
                result.append("message", messageService.getMessage("RTIS.MSG_99999"));
            } else {
                result.append("message", Util.getThrowableTrace(ex));
            }
            return result;
        } finally {
            try {
                if (workbook != null)
                    workbook.close();
            } catch (IOException ex) {
            }
            // 업로드된 파일 삭제
            FileUtils.deleteQuietly(destFile);
        }
        return result;
    }

    private void insertExcelRowData(String groupId, List<DataItem> list) {
        for (DataItem item : Util.emptyIfNull(list)) {
            redisExcelTempDao.getCommand().lpush(groupId, item.toJson());
        }
    }

    /**
     * <p>
     * Cell의 내용이 있는지 판단한다.
     * </p>
     *
     * @param cell XSSFCell
     * @return boolean
     */
    private boolean isNullValue(Cell cell) {
        if (cell != null) {
            if (cell.getCellType() == CellType.STRING) {
                return Util.isNull(cell.getStringCellValue());
            } else if (cell.getCellType() == CellType.NUMERIC) {
                if (DateUtil.isCellDateFormatted(cell)) {
                    return Util.isNull(DATE_MASK_2.format(cell.getDateCellValue()));
                }
                return false;
            } else if (cell.getCellType() == CellType.FORMULA) {
                return Util.isNull(cell.getCellFormula());
            } else if (cell.getCellType() == CellType.BLANK) {
                return true;
            }
        }
        return true;
    }

    /**
     * <p>
     * XSSFCell의 Value값을 추출한다.
     * </p>
     *
     * @param cell
     * @return Object
     */
    private Object getCellValue(Cell cell) {
        Object cellValue = null;
        if (cell != null) {
            if (cell.getCellType() == CellType.STRING) {
                cellValue = cell.getStringCellValue();
            } else if (cell.getCellType() == CellType.NUMERIC) {
                if (DateUtil.isCellDateFormatted(cell)) {
                    cellValue = DATE_MASK_1.format(cell.getDateCellValue());
                } else {
                    cellValue = cell.getNumericCellValue();
                }
            } else if (cell.getCellType() == CellType.BOOLEAN) {
                cellValue = cell.getBooleanCellValue();
            } else if (cell.getCellType() == CellType.FORMULA) {
                cellValue = cell.getCellFormula();
            } else if (cell.getCellType() == CellType.BLANK) {
                cellValue = "";
            }
        }
        return cellValue;
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