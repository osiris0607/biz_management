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
package com.anchordata.webframework.service.execution;

import java.util.List;
import java.util.Map;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;

import com.anchordata.webframework.service.uploadFile.UploadFileVO;
import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class ExecutionVO {
	private static final long serialVersionUID = 1L;

	private int execution_id;
	private int reception_id;
	private int agreement_id;
	private String execution_status = "";
	private int middle_report_file_id;
	private String middle_report_file_name;
	private String middle_report_date;
	private int final_report_file_id;
	private String final_report_file_name;
	private String final_report_date;
	private String reception_reg_number = "";
	private String agreement_reg_number = "";
	private String research_date = "";
	private String research_funds = "";
	private String announcement_type = "";
	private String announcement_business_name = "";
	private String announcement_title = "";
	private String tech_info_name = "";
	private String institution_name = "";
	private String researcher_name = "";
	private String member_id = "";
	private String changes_count = "";
	
	
	private String use_yn = "";
	private String reg_date = "";
	
	private String total_count = "";
	
	
	List<Map<String, Object>> changes_list;					//과제 변경 이력 조회 결과
	
	@JsonIgnore
	private MultipartFile middle_report_file;
	@JsonIgnore
	private MultipartFile final_report_file;
	@JsonIgnore
	private MultipartFile[] upload_files;					//기타자료 업로드
	private List<UploadFileVO> return_upload_files;
	private List<Integer> delete_file_list;
	private int file_id;
	
	@JsonIgnore
	private MultipartFile[] upload_change_files;			//과제 변경 이력 첨부 파일
	private List<UploadFileVO> return_upload_change_files;	//과제 변경 이력 조회시 파일 정보
	List<String> change_contents_list;						//과제 변경 내용 List
	private String changes;
	
	
	
	public String getChanges() {
		return changes;
	}
	public void setChanges(String changes) {
		this.changes = changes;
	}
	public List<String> getChange_contents_list() {
		return change_contents_list;
	}
	public void setChange_contents_list(List<String> change_contents_list) {
		this.change_contents_list = change_contents_list;
	}
	public MultipartFile[] getUpload_change_files() {
		return upload_change_files;
	}
	public void setUpload_change_files(MultipartFile[] upload_change_files) {
		this.upload_change_files = upload_change_files;
	}
	public List<UploadFileVO> getReturn_upload_change_files() {
		return return_upload_change_files;
	}
	public void setReturn_upload_change_files(List<UploadFileVO> return_upload_change_files) {
		this.return_upload_change_files = return_upload_change_files;
	}
	public String getTotal_count() {
		return total_count;
	}
	public void setTotal_count(String total_count) {
		this.total_count = total_count;
	}
	public String getMiddle_report_file_name() {
		return middle_report_file_name;
	}
	public void setMiddle_report_file_name(String middle_report_file_name) {
		this.middle_report_file_name = middle_report_file_name;
	}
	public String getFinal_report_file_name() {
		return final_report_file_name;
	}
	public void setFinal_report_file_name(String final_report_file_name) {
		this.final_report_file_name = final_report_file_name;
	}
	public List<Map<String, Object>> getChanges_list() {
		return changes_list;
	}
	public void setChanges_list(List<Map<String, Object>> changes_list) {
		this.changes_list = changes_list;
	}
	public MultipartFile getMiddle_report_file() {
		return middle_report_file;
	}
	public void setMiddle_report_file(MultipartFile middle_report_file) {
		this.middle_report_file = middle_report_file;
	}
	public MultipartFile getFinal_report_file() {
		return final_report_file;
	}
	public void setFinal_report_file(MultipartFile final_report_file) {
		this.final_report_file = final_report_file;
	}
	public String getChanges_count() {
		return changes_count;
	}
	public void setChanges_count(String changes_count) {
		this.changes_count = changes_count;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getMiddle_report_date() {
		return middle_report_date;
	}
	public void setMiddle_report_date(String middle_report_date) {
		this.middle_report_date = middle_report_date;
	}
	public String getFinal_report_date() {
		return final_report_date;
	}
	public void setFinal_report_date(String final_report_date) {
		this.final_report_date = final_report_date;
	}
	public String getResearch_funds() {
		return research_funds;
	}
	public void setResearch_funds(String research_funds) {
		this.research_funds = research_funds;
	}
	public String getReception_reg_number() {
		return reception_reg_number;
	}
	public void setReception_reg_number(String reception_reg_number) {
		this.reception_reg_number = reception_reg_number;
	}
	public String getAgreement_reg_number() {
		return agreement_reg_number;
	}
	public void setAgreement_reg_number(String agreement_reg_number) {
		this.agreement_reg_number = agreement_reg_number;
	}
	public String getResearch_date() {
		return research_date;
	}
	public void setResearch_date(String research_date) {
		this.research_date = research_date;
	}
	public String getAnnouncement_type() {
		return announcement_type;
	}
	public void setAnnouncement_type(String announcement_type) {
		this.announcement_type = announcement_type;
	}
	public String getAnnouncement_business_name() {
		return announcement_business_name;
	}
	public void setAnnouncement_business_name(String announcement_business_name) {
		this.announcement_business_name = announcement_business_name;
	}
	public String getAnnouncement_title() {
		return announcement_title;
	}
	public void setAnnouncement_title(String announcement_title) {
		this.announcement_title = announcement_title;
	}
	public String getTech_info_name() {
		return tech_info_name;
	}
	public void setTech_info_name(String tech_info_name) {
		this.tech_info_name = tech_info_name;
	}
	public String getInstitution_name() {
		return institution_name;
	}
	public void setInstitution_name(String institution_name) {
		this.institution_name = institution_name;
	}
	public String getResearcher_name() {
		return researcher_name;
	}
	public void setResearcher_name(String researcher_name) {
		this.researcher_name = researcher_name;
	}
	public int getExecution_id() {
		return execution_id;
	}
	public void setExecution_id(int execution_id) {
		this.execution_id = execution_id;
	}
	public int getFinal_report_file_id() {
		return final_report_file_id;
	}
	public void setFinal_report_file_id(int final_report_file_id) {
		this.final_report_file_id = final_report_file_id;
	}
	public String getExecution_status() {
		return execution_status;
	}
	public void setExecution_status(String execution_status) {
		this.execution_status = execution_status;
	}
	public int getReception_id() {
		return reception_id;
	}
	public void setReception_id(int reception_id) {
		this.reception_id = reception_id;
	}
	public int getAgreement_id() {
		return agreement_id;
	}
	public void setAgreement_id(int agreement_id) {
		this.agreement_id = agreement_id;
	}
	public int getMiddle_report_file_id() {
		return middle_report_file_id;
	}
	public void setMiddle_report_file_id(int middle_report_file_id) {
		this.middle_report_file_id = middle_report_file_id;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public MultipartFile[] getUpload_files() {
		return upload_files;
	}
	public void setUpload_files(MultipartFile[] upload_files) {
		this.upload_files = upload_files;
	}
	public int getFile_id() {
		return file_id;
	}
	public void setFile_id(int file_id) {
		this.file_id = file_id;
	}
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
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
