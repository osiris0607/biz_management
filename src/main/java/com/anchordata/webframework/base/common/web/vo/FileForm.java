/*******************************************************************************
 *
 * Copyright ⓒ 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of namu C&D corp, and you may not use this file except in
 * compliance with license agreement with namu C&D corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of namu C&D corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.base.common.web.vo;

import org.springframework.web.multipart.MultipartFile;


public class FileForm {
	
	private Long fileSeq;
	
	private String fileGroupId;
		
	private MultipartFile file = null;
	
	private String prprtyKey;
	
	private String prprtyVal;
	
	private String delYn;
	
	private int sort;

	public Long getFileSeq() {
		return fileSeq;
	}

	public void setFileSeq(Long fileSeq) {
		this.fileSeq = fileSeq;
	}

	public String getFileGroupId() {
		return fileGroupId;
	}

	public void setFileGroupId(String fileGroupId) {
		this.fileGroupId = fileGroupId;
	}

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getPrprtyKey() {
		return prprtyKey;
	}

	public void setPrprtyKey(String prprtyKey) {
		this.prprtyKey = prprtyKey;
	}

	public String getPrprtyVal() {
		return prprtyVal;
	}

	public void setPrprtyVal(String prprtyVal) {
		this.prprtyVal = prprtyVal;
	}

	public String getDelYn() {
		return delYn;
	}

	public void setDelYn(String delYn) {
		this.delYn = delYn;
	}

	public int getSort() {
		return sort;
	}

	public void setSort(int sort) {
		this.sort = sort;
	}	
}
