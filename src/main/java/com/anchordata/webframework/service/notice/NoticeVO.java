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
package com.anchordata.webframework.service.notice;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.anchordata.webframework.service.uploadFile.UploadFileVO;
import com.fasterxml.jackson.annotation.JsonIgnore;


public class NoticeVO {

	private static final long serialVersionUID = 1L;
	
	private int notice_id;
	private String title;
	private String writer;
	private String reg_date;
	private String use_yn;
	private String explanation;
	private String hits;
	
	@JsonIgnore
	private MultipartFile[] upload_files;
	private List<UploadFileVO> return_upload_files;
	private List<Integer> delete_file_list;
	private int file_id;
	
	private int total_count;
	private int result;
	
	
	
	public List<UploadFileVO> getReturn_upload_files() {
		return return_upload_files;
	}
	public void setReturn_upload_files(List<UploadFileVO> return_upload_files) {
		this.return_upload_files = return_upload_files;
	}
	public List<Integer> getDelete_file_list() {
		return delete_file_list;
	}
	public void setDelete_file_list(List<Integer> delete_file_list) {
		this.delete_file_list = delete_file_list;
	}
	public int getFile_id() {
		return file_id;
	}
	public void setFile_id(int file_id) {
		this.file_id = file_id;
	}
	public MultipartFile[] getUpload_files() {
		return upload_files;
	}
	public void setUpload_files(MultipartFile[] upload_files) {
		this.upload_files = upload_files;
	}
	public String getHits() {
		return hits;
	}
	public void setHits(String hits) {
		this.hits = hits;
	}
	public int getNotice_id() {
		return notice_id;
	}
	public void setNotice_id(int notice_id) {
		this.notice_id = notice_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getExplanation() {
		return explanation;
	}
	public void setExplanation(String explanation) {
		this.explanation = explanation;
	}
	public int getTotal_count() {
		return total_count;
	}
	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	public int getResult() {
		return result;
	}
	public void setResult(int result) {
		this.result = result;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
