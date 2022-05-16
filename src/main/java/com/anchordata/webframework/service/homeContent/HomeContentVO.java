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
package com.anchordata.webframework.service.homeContent;


import org.springframework.web.multipart.MultipartFile;

import com.anchordata.webframework.service.uploadFile.UploadFileVO;
import com.fasterxml.jackson.annotation.JsonIgnore;


public class HomeContentVO {

	private static final long serialVersionUID = 1L;
	
	private int content_id;
	private String content_title;
	private String content_type;
	private String content_description;
	private int image_file_id;
	
	
	@JsonIgnore
	private MultipartFile upload_image_file;
	private UploadFileVO return_upload_file_info;

	private int use_yn;
	private String reg_date;
	private int total_count;
	
	
	///////////////////////////////////////////////////
	// 검색 관련
	///////////////////////////////////////////////////
	// 키워드 검색
	private String keyword;
	// paging List Index
	private String pageIndex;
	// Paging List Order by
	private String orderby;
	
	
	
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getPageIndex() {
		return pageIndex;
	}
	public void setPageIndex(String pageIndex) {
		this.pageIndex = pageIndex;
	}
	public String getOrderby() {
		return orderby;
	}
	public void setOrderby(String orderby) {
		this.orderby = orderby;
	}
	public int getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(int use_yn) {
		this.use_yn = use_yn;
	}
	public int getImage_file_id() {
		return image_file_id;
	}
	public void setImage_file_id(int image_file_id) {
		this.image_file_id = image_file_id;
	}
	public int getContent_id() {
		return content_id;
	}
	public void setContent_id(int content_id) {
		this.content_id = content_id;
	}
	public String getContent_title() {
		return content_title;
	}
	public void setContent_title(String content_title) {
		this.content_title = content_title;
	}
	public String getContent_type() {
		return content_type;
	}
	public void setContent_type(String content_type) {
		this.content_type = content_type;
	}
	public String getContent_description() {
		return content_description;
	}
	public void setContent_description(String content_description) {
		this.content_description = content_description;
	}
	public MultipartFile getUpload_image_file() {
		return upload_image_file;
	}
	public void setUpload_image_file(MultipartFile upload_image_file) {
		this.upload_image_file = upload_image_file;
	}
	public UploadFileVO getReturn_upload_file_info() {
		return return_upload_file_info;
	}
	public void setReturn_upload_file_info(UploadFileVO return_upload_file_info) {
		this.return_upload_file_info = return_upload_file_info;
	}
	public int getTotal_count() {
		return total_count;
	}
	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
