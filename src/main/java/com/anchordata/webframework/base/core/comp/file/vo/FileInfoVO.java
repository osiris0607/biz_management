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
package com.anchordata.webframework.base.core.comp.file.vo;


public class FileInfoVO {
	
	private long fileSeq;
	
	private String fileGroupId;
	
	private String fileTypeCd;
	
	private String ognlFileNm;
	
	private String makeFileNm;
	
	private String thumFileNm;
	
	private String prprtyKey;
	
	private String prprtyVal;
	
	private String filePath;
	
	private long fileSize;
	
	private String fileHash;
	
	private String cretrId;
	
	private String delYn;
	
	private int ordr;
	
	private String mode;
	
	public FileInfoVO() {}
	
	public FileInfoVO(long fileSeq, String fileGroupId, int ordr, String delYn, String mode) {
		this.fileSeq = fileSeq;
		this.fileGroupId = fileGroupId;
		this.ordr = ordr;
		this.delYn = delYn;
		this.mode = mode;
	}

	public long getFileSeq() {
		return fileSeq;
	}

	public void setFileSeq(long fileSeq) {
		this.fileSeq = fileSeq;
	}

	public String getFileGroupId() {
		return fileGroupId;
	}

	public void setFileGroupId(String fileGroupId) {
		this.fileGroupId = fileGroupId;
	}

	public String getFileTypeCd() {
		return fileTypeCd;
	}

	public void setFileTypeCd(String fileTypeCd) {
		this.fileTypeCd = fileTypeCd;
	}

	public String getOgnlFileNm() {
		return ognlFileNm;
	}

	public void setOgnlFileNm(String ognlFileNm) {
		this.ognlFileNm = ognlFileNm;
	}

	public String getMakeFileNm() {
		return makeFileNm;
	}

	public void setMakeFileNm(String makeFileNm) {
		this.makeFileNm = makeFileNm;
	}

	public String getThumFileNm() {
		return thumFileNm;
	}

	public void setThumFileNm(String thumFileNm) {
		this.thumFileNm = thumFileNm;
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

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getFileHash() {
		return fileHash;
	}

	public void setFileHash(String fileHash) {
		this.fileHash = fileHash;
	}

	public String getCretrId() {
		return cretrId;
	}

	public void setCretrId(String cretrId) {
		this.cretrId = cretrId;
	}

	public String getDelYn() {
		return delYn;
	}

	public void setDelYn(String delYn) {
		this.delYn = delYn;
	}

	public int getOrdr() {
		return ordr;
	}

	public void setOrdr(int ordr) {
		this.ordr = ordr;
	}

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}
		
}
