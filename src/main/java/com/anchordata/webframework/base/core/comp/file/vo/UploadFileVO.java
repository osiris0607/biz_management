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

import java.util.List;

public class UploadFileVO {
	
	private String fileGroupId;

	private List<FileInfoVO> newFiles;
	
	private List<FileInfoVO> retFiles;
	
	private List<FileInfoVO> modFiles;
	
	private List<FileInfoVO> delFiles;
	
	public UploadFileVO() { }
	
	public UploadFileVO(String fileGroupId, List<FileInfoVO> newFiles, List<FileInfoVO> retFiles, List<FileInfoVO> modFiles, List<FileInfoVO> delFiles) {
		this.fileGroupId = fileGroupId;
		this.newFiles = newFiles;
		this.retFiles = retFiles;
		this.modFiles = modFiles;
		this.delFiles = delFiles;
	}

	public String getFileGroupId() {
		return fileGroupId;
	}

	public void setFileGroupId(String fileGroupId) {
		this.fileGroupId = fileGroupId;
	}

	public List<FileInfoVO> getNewFiles() {
		return newFiles;
	}

	public void setNewFiles(List<FileInfoVO> newFiles) {
		this.newFiles = newFiles;
	}

	public List<FileInfoVO> getRetFiles() {
		return retFiles;
	}

	public void setRetFiles(List<FileInfoVO> retFiles) {
		this.retFiles = retFiles;
	}

	public List<FileInfoVO> getModFiles() {
		return modFiles;
	}

	public void setModFiles(List<FileInfoVO> modFiles) {
		this.modFiles = modFiles;
	}

	public List<FileInfoVO> getDelFiles() {
		return delFiles;
	}

	public void setDelFiles(List<FileInfoVO> delFiles) {
		this.delFiles = delFiles;
	}
	
	
}
