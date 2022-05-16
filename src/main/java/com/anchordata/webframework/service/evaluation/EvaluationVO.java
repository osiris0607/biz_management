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
package com.anchordata.webframework.service.evaluation;


import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class EvaluationVO {

	private static final long serialVersionUID = 1L;

	private int evaluation_id;
	private int reception_id;
	private String evaluation_reg_number = "";
	private String reception_reg_number = "";
	private String agreement_reg_number = "";
	private String announcement_business_name = "";
	private String announcement_title = "";
	private String announcement_type = "";
	private String announcement_type_name = "";
	private String tech_info_name = "";
	private String institution_name = "";
	private String steward_department = "";
	private String steward = "";
	private String classification = "";
	private String classification_name = "";
	private String type = "";
	private String type_name = "";
	private String evaluation_date = "";
	private String result = "";
	private String result_name = "";
	private String status = "";
	private String status_name = "";
	private String send_email_yn = "";
	private String send_sms_yn = "";
	private String commissioner_yn = "";
	private String item_complete_yn = "";
	private String submit_yn = "";
	private int guide_file_id;
	private String guide_file_name = "";
	private int result_file_id;
	private String result_file_name = "";
	private int complete_file_id;
	private String complete_file_name = "";
	private String member_name = "";
	private String chairman_yn = "";
	private int manager_point;
	
	
	// 평가번호 생성되어야 할  평가 리스트
	private List<String> craete_evaluation_number_list;
	// 업데이트 되어야 할  평가 리스트
	private List<String> update_evaluation_number_list;
	// 업데이트 되어야 할  평가 번호 리스트
	private List<String> update_evaluation_reg_number_list;
	// 평가 번호 리스트
	private List<String> evaluation_id_list;
	// 평가위원 ID 리스트
	private List<String> commissioner_list;
	// 평가위원 EAMIL 리스트
	private List<String> commissioner_mail_list;
	private String evaluation_status = "";
	
	
	@JsonIgnore
	private MultipartFile upload_guide_file;
	@JsonIgnore
	private MultipartFile upload_result_file;
	@JsonIgnore
	private MultipartFile upload_complete_file;
	
	
	private String use_yn = "";
	private String reg_date = "";
	
	private String total_count = "";
	
	// mail 관려
	private String mail_title = "";
	private String mail_content = "";
	private String mail_link = "";
	private String mail_sender = "";
	private String member_id = "";
	
	
	
	public String getAnnouncement_business_name() {
		return announcement_business_name;
	}
	public void setAnnouncement_business_name(String announcement_business_name) {
		this.announcement_business_name = announcement_business_name;
	}
	public String getSubmit_yn() {
		return submit_yn;
	}
	public void setSubmit_yn(String submit_yn) {
		this.submit_yn = submit_yn;
	}
	public String getAnnouncement_type_name() {
		return announcement_type_name;
	}
	public void setAnnouncement_type_name(String announcement_type_name) {
		this.announcement_type_name = announcement_type_name;
	}
	public int getManager_point() {
		return manager_point;
	}
	public void setManager_point(int manager_point) {
		this.manager_point = manager_point;
	}
	public MultipartFile getUpload_guide_file() {
		return upload_guide_file;
	}
	public void setUpload_guide_file(MultipartFile upload_guide_file) {
		this.upload_guide_file = upload_guide_file;
	}
	public MultipartFile getUpload_result_file() {
		return upload_result_file;
	}
	public void setUpload_result_file(MultipartFile upload_result_file) {
		this.upload_result_file = upload_result_file;
	}
	public MultipartFile getUpload_complete_file() {
		return upload_complete_file;
	}
	public void setUpload_complete_file(MultipartFile upload_complete_file) {
		this.upload_complete_file = upload_complete_file;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getChairman_yn() {
		return chairman_yn;
	}
	public void setChairman_yn(String chairman_yn) {
		this.chairman_yn = chairman_yn;
	}
	public List<String> getEvaluation_id_list() {
		return evaluation_id_list;
	}
	public void setEvaluation_id_list(List<String> evaluation_id_list) {
		this.evaluation_id_list = evaluation_id_list;
	}
	public String getEvaluation_status() {
		return evaluation_status;
	}
	public void setEvaluation_status(String evaluation_status) {
		this.status = evaluation_status;
		this.evaluation_status = evaluation_status;
	}
	public List<String> getUpdate_evaluation_reg_number_list() {
		return update_evaluation_reg_number_list;
	}
	public void setUpdate_evaluation_reg_number_list(List<String> update_evaluation_reg_number_list) {
		this.update_evaluation_reg_number_list = update_evaluation_reg_number_list;
	}
	public String getSend_email_yn() {
		return send_email_yn;
	}
	public void setSend_email_yn(String send_email_yn) {
		this.send_email_yn = send_email_yn;
	}
	public String getSend_sms_yn() {
		return send_sms_yn;
	}
	public void setSend_sms_yn(String send_sms_yn) {
		this.send_sms_yn = send_sms_yn;
	}
	public String getCommissioner_yn() {
		return commissioner_yn;
	}
	public void setCommissioner_yn(String commissioner_yn) {
		this.commissioner_yn = commissioner_yn;
	}
	public String getItem_complete_yn() {
		return item_complete_yn;
	}
	public void setItem_complete_yn(String item_complete_yn) {
		this.item_complete_yn = item_complete_yn;
	}
	public int getGuide_file_id() {
		return guide_file_id;
	}
	public void setGuide_file_id(int guide_file_id) {
		this.guide_file_id = guide_file_id;
	}
	public String getGuide_file_name() {
		return guide_file_name;
	}
	public void setGuide_file_name(String guide_file_name) {
		this.guide_file_name = guide_file_name;
	}
	public int getResult_file_id() {
		return result_file_id;
	}
	public void setResult_file_id(int result_file_id) {
		this.result_file_id = result_file_id;
	}
	public String getResult_file_name() {
		return result_file_name;
	}
	public void setResult_file_name(String result_file_name) {
		this.result_file_name = result_file_name;
	}
	public int getComplete_file_id() {
		return complete_file_id;
	}
	public void setComplete_file_id(int complete_file_id) {
		this.complete_file_id = complete_file_id;
	}
	public String getComplete_file_name() {
		return complete_file_name;
	}
	public void setComplete_file_name(String complete_file_name) {
		this.complete_file_name = complete_file_name;
	}
	public String getMember_name() {
		return member_name;
	}
	public void setMember_name(String member_name) {
		this.member_name = member_name;
	}
	public List<String> getCommissioner_mail_list() {
		return commissioner_mail_list;
	}
	public void setCommissioner_mail_list(List<String> commissioner_mail_list) {
		this.commissioner_mail_list = commissioner_mail_list;
	}
	public String getMail_title() {
		return mail_title;
	}
	public void setMail_title(String mail_title) {
		this.mail_title = mail_title;
	}
	public String getMail_content() {
		return mail_content;
	}
	public void setMail_content(String mail_content) {
		this.mail_content = mail_content;
	}
	public String getMail_link() {
		return mail_link;
	}
	public void setMail_link(String mail_link) {
		this.mail_link = mail_link;
	}
	public String getMail_sender() {
		return mail_sender;
	}
	public void setMail_sender(String mail_sender) {
		this.mail_sender = mail_sender;
	}
	public List<String> getCommissioner_list() {
		return commissioner_list;
	}
	public void setCommissioner_list(List<String> commissioner_list) {
		this.commissioner_list = commissioner_list;
	}
	public List<String> getUpdate_evaluation_number_list() {
		return update_evaluation_number_list;
	}
	public void setUpdate_evaluation_number_list(List<String> update_evaluation_number_list) {
		this.update_evaluation_number_list = update_evaluation_number_list;
	}
	public String getAnnouncement_type() {
		return announcement_type;
	}
	public void setAnnouncement_type(String announcement_type) {
		this.announcement_type = announcement_type;
	}
	public List<String> getCraete_evaluation_number_list() {
		return craete_evaluation_number_list;
	}
	public void setCraete_evaluation_number_list(List<String> craete_evaluation_number_list) {
		this.craete_evaluation_number_list = craete_evaluation_number_list;
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
	public String getSteward_department() {
		return steward_department;
	}
	public void setSteward_department(String steward_department) {
		this.steward_department = steward_department;
	}
	public String getSteward() {
		return steward;
	}
	public void setSteward(String steward) {
		this.steward = steward;
	}
	public String getClassification_name() {
		return classification_name;
	}
	public void setClassification_name(String classification_name) {
		this.classification_name = classification_name;
	}
	public String getType_name() {
		return type_name;
	}
	public void setType_name(String type_name) {
		this.type_name = type_name;
	}
	public String getEvaluation_date() {
		return evaluation_date;
	}
	public void setEvaluation_date(String evaluation_date) {
		this.evaluation_date = evaluation_date;
	}
	public String getResult_name() {
		return result_name;
	}
	public void setResult_name(String result_name) {
		this.result_name = result_name;
	}
	public String getStatus_name() {
		return status_name;
	}
	public void setStatus_name(String status_name) {
		this.status_name = status_name;
	}
	public String getTotal_count() {
		return total_count;
	}
	public void setTotal_count(String total_count) {
		this.total_count = total_count;
	}
	public String getEvaluation_reg_number() {
		return evaluation_reg_number;
	}
	public void setEvaluation_reg_number(String evaluation_reg_number) {
		this.evaluation_reg_number = evaluation_reg_number;
	}
	public int getEvaluation_id() {
		return evaluation_id;
	}
	public void setEvaluation_id(int evaluation_id) {
		this.evaluation_id = evaluation_id;
	}
	public int getReception_id() {
		return reception_id;
	}
	public void setReception_id(int reception_id) {
		this.reception_id = reception_id;
	}
	public String getClassification() {
		return classification;
	}
	public void setClassification(String classification) {
		this.classification = classification;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
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
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
