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
package com.anchordata.webframework.service.uploadFile;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class UploadFileVO {
	
	private static final long serialVersionUID = 1L;
	
	private int file_id;
	private String name;
	private String path;
	private String type;
	private String description;
	private byte[] binary_content;
	private MultipartFile upload_multipart_file;
	private List<Integer> serach_file_ids;
	
	

	
	public List<Integer> getSerach_file_ids() {
		return serach_file_ids;
	}
	public void setSerach_file_ids(List<Integer> serach_file_ids) {
		this.serach_file_ids = serach_file_ids;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public MultipartFile getUpload_multipart_file() {
		return upload_multipart_file;
	}
	public void setUpload_multipart_file(MultipartFile upload_multipart_file) {
		this.upload_multipart_file = upload_multipart_file;
	}
	public int getFile_id() {
		return file_id;
	}
	public void setFile_id(int file_id) {
		this.file_id = file_id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public byte[] getBinary_content() {
		return binary_content;
	}
	public void setBinary_content(byte[] binary_content) {
		this.binary_content = binary_content;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
}
