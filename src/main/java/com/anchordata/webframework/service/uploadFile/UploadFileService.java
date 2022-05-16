/*******************************************************************************
 *
 * Copyright �뱬 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of namu C&D corp, and you may not use this file except in
 * compliance with license agreement with namu C&D corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of namu C&D corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.service.uploadFile;


import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service("UploadFileService")
public class UploadFileService {
	
	@Autowired
	private uploadFileDao uploadFileDao;
	
	/**
	 * upload 파일 Content를 DB에 등록
	 */
	@Transactional
	public int registration(UploadFileVO vo) throws Exception {
		return uploadFileDao.insertUploadFileInfo(vo);
	}
	/**
	 * upload 파일 Content를 DB에 등록
	 */
	@Transactional
	public int modification(UploadFileVO vo) throws Exception {
		return uploadFileDao.updateInfo(vo);
	}
	/**
	 * 삭제
	 */
	@Transactional
	public int withdrawal(UploadFileVO vo) throws Exception {
		return uploadFileDao.deleteInfo(vo);
	}
	/**
	 * DB에 있는 upload 파일 Content 검색
	 */
	public UploadFileVO selectUploadFileContent(UploadFileVO vo) throws Exception {
		return uploadFileDao.selectUploadFileContent(vo);
	}
	/**
	 * upload 파일 Local Storage Upload
	 */
	@Transactional
	public int registrationLocalStorage(UploadFileVO vo) throws Exception {
		
        String originalFileName = vo.getUpload_multipart_file().getOriginalFilename();
        String filePath = vo.getPath() + originalFileName;
        long fileSize = vo.getUpload_multipart_file().getSize();
            
        // 파일 Upload
        try {
        	
        	File f = new File(vo.getPath());
        	
        	if (!f.exists()) {
        		f.mkdirs();
        	}
        	 
        	vo.getUpload_multipart_file().transferTo(new File(filePath));
    	} 
        catch (IllegalStateException e) {
        	return 500;
	    } 
	    catch (IOException e) {
            return 500;
	    }
        
        // DB Insert 를 위해 '\' 를 '\\'로 변경 
        String OsFilePath = filePath.replaceAll("/", Matcher.quoteReplacement(File.separator));
        String reverseSlashPath = OsFilePath.replaceAll(Matcher.quoteReplacement(File.separator), "/");
        
        vo.setName(originalFileName);
        return uploadFileDao.insertUploadFileInfo(vo);
	}
	/**
	 * DB에 있는 upload 파일 Content List 검색
	 */
	public List<UploadFileVO> selectSearchList(UploadFileVO param) throws Exception {
		return uploadFileDao.selectSearchList(param);
	}
}
