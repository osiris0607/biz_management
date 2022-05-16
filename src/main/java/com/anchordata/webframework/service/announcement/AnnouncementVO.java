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
package com.anchordata.webframework.service.announcement;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.anchordata.webframework.service.uploadFile.UploadFileVO;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;


public class AnnouncementVO {

	private static final long serialVersionUID = 1L;
	
	private int announcement_id;
	private String type = "";
	private String title = "";
	private String business_name = "";
	private String manager = "";
	private String manager_dept = "";
	private String manager_job_title = "";
	private String manager_phone = "";
	private String manager_mail = "";
	private String contents = "";
	private String register = "";
	private String reg_date = "";
	private String process_status = "";
	private String use_yn = "";
	private String hits = "";
	private String date = "";
	private String receipt_to = "";
	private String receipt_from = "";
	
	
	@JsonIgnore
	private MultipartFile[] upload_files;
	private List<UploadFileVO> return_upload_files;
	private List<Integer> delete_file_list;
	private int file_id;
	
	// CommonCode 이름
	private String type_name = "";
	private String status_name = "";
	
	// Extension
	private String ext_field_list_json;
	private List<AnnouncementExtVO> ext_field_list;
	
	
	// 체크리스트
	private String ext_check_list_json;
	private List<AnnouncementCheckListVO> ext_check_list;
	
	private int total_count;
	private int result;

	
	
	public List<Integer> getDelete_file_list() {
		return delete_file_list;
	}
	public void setDelete_file_list(List<Integer> delete_file_list) {
		this.delete_file_list = delete_file_list;
	}
	public String getBusiness_name() {
		return business_name;
	}
	public void setBusiness_name(String business_name) {
		this.business_name = business_name;
	}
	public List<AnnouncementCheckListVO> getExt_check_list() {
		return ext_check_list;
	}
	public void setExt_check_list(List<AnnouncementCheckListVO> ext_check_list) {
		this.ext_check_list = ext_check_list;
	}
	public String getExt_check_list_json() {
		return ext_check_list_json;
	}
	public void setExt_check_list_json(String ext_check_list_json) {
		String tempJsonData = ext_check_list_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			ext_check_list = Arrays.asList(mapper.readValue(tempJsonData, AnnouncementCheckListVO[].class));
		} catch (JsonParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		this.ext_check_list_json = ext_check_list_json;
	}
	public String getExt_field_list_json() {
		return ext_field_list_json;
	}
	public List<AnnouncementExtVO> getExt_field_list() {
		return ext_field_list;
	}
	public void setExt_field_list(List<AnnouncementExtVO> ext_field_list) {
		this.ext_field_list = ext_field_list;
	}
	public void setExt_field_list_json(String ext_field_list_json) {
		String tempJsonData = ext_field_list_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			ext_field_list = Arrays.asList(mapper.readValue(tempJsonData, AnnouncementExtVO[].class));
		} catch (JsonParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		this.ext_field_list_json = ext_field_list_json;
	}
	public int getFile_id() {
		return file_id;
	}
	public void setFile_id(int file_id) {
		this.file_id = file_id;
	}
	public String getType_name() {
		return type_name;
	}
	public void setType_name(String type_name) {
		this.type_name = type_name;
	}
	public String getStatus_name() {
		return status_name;
	}
	public void setStatus_name(String status_name) {
		this.status_name = status_name;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getProcess_status() {
		return process_status;
	}
	public void setProcess_status(String process_status) {
		this.process_status = process_status;
	}
	public String getReceipt_to() {
		return receipt_to;
	}
	public void setReceipt_to(String receipt_to) {
		this.receipt_to = receipt_to;
	}
	public String getReceipt_from() {
		return receipt_from;
	}
	public void setReceipt_from(String receipt_from) {
		this.receipt_from = receipt_from;
	}
	public MultipartFile[] getUpload_files() {
		return upload_files;
	}
	public void setUpload_files(MultipartFile[] upload_files) {
		this.upload_files = upload_files;
	}
	public List<UploadFileVO> getReturn_upload_files() {
		return return_upload_files;
	}
	public void setReturn_upload_files(List<UploadFileVO> return_upload_files) {
		this.return_upload_files = return_upload_files;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getAnnouncement_id() {
		return announcement_id;
	}
	public void setAnnouncement_id(int announcement_id) {
		this.announcement_id = announcement_id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getManager() {
		return manager;
	}
	public void setManager(String manager) {
		this.manager = manager;
	}
	public String getManager_dept() {
		return manager_dept;
	}
	public void setManager_dept(String manager_dept) {
		this.manager_dept = manager_dept;
	}
	public String getManager_job_title() {
		return manager_job_title;
	}
	public void setManager_job_title(String manager_job_title) {
		this.manager_job_title = manager_job_title;
	}
	public String getManager_phone() {
		return manager_phone;
	}
	public void setManager_phone(String manager_phone) {
		this.manager_phone = manager_phone;
	}
	public String getManager_mail() {
		return manager_mail;
	}
	public void setManager_mail(String manager_mail) {
		this.manager_mail = manager_mail;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getRegister() {
		return register;
	}
	public void setRegister(String register) {
		this.register = register;
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
	public String getHits() {
		return hits;
	}
	public void setHits(String hits) {
		this.hits = hits;
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
