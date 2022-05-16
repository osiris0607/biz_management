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
package com.anchordata.webframework.service.reception;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;


public class ReceptionVO {

	private static final long serialVersionUID = 1L;
	
	
	private int reception_id;
	private String reception_reg_number = "";
	private String reception_status = "";
	private int announcement_id;
	private String announcement_title = "";
	private String announcement_type ="";
	private String announcement_type_name ="";
	private String announcement_business_name = "";
	private String member_id = "";
	private int expert_id;
	// 기관 정보
	private String institution_reg_number = "";
	private String institution_name = "";
	private String institution_address = "";
	private String institution_address_detail = "";
	private String institution_phone = "";
	private String institution_owner_name = "";
	private String institution_industry = "";
	private String institution_business = "";
	private String institution_foundataion_date = "";
	private String institution_foundataion_type = "";
	private String institution_classification = "";
	private String institution_type = "";
	private String institution_laboratory_yn = "";
	private String institution_employee_count = "";
	private String institution_total_sales = "";
	private String institution_capital_1 = "";
	private String institution_capital_2 = "";
	private String institution_capital_3 = "";
	// 연구책임자 정보
	private String researcher_name = "";
	private String researcher_mobile_phone = "";
	private String researcher_email = "";
	private String researcher_address = "";
	private String researcher_address_detail = "";
	private String researcher_institution_name = "";
	private String researcher_institution_department = "";
	private String researcher_institution_position = "";
	// 기술컨설팅 요청사항
	private String tech_consulting_type = "";
	private String tech_consulting_campus = "";
	private String tech_consulting_large = "";
	private String tech_consulting_middle = "";
	private String tech_consulting_small = "";
	private String tech_consulting_4th_industry = "";
	private String tech_consulting_4th_industry_name = "";
	private String tech_consulting_purpose = "";
	private String tech_consulting_purpose_etc = "";
	private String tech_consulting_take_yn = "";
	// 기술 정보
	private String tech_info_name = "";
	private String tech_info_description = "";
	private String tech_info_problems = "";
	private String tech_info_consulting_request = "";
	private String tech_info_rnd_description = "";
	private String tech_info_expert_request = "";
	private int tech_info_upload_file_id;
	private String tech_info_upload_file_name = "";
	private String tech_info_market_report = "";
	private String tech_info_large = "";
	private String tech_info_middle = "";
	private String tech_info_small = "";
	private String tech_info_feature = "";
	private String tech_info_effect = "";
	private String tech_info_area = "";
	private String tech_info_type = "";
	private String tech_info_4th_industry = "";
	private String tech_info_4th_industry_name = "";
	private String receipt_from = "";
	private String receipt_to = "";
	private String participation_name = "";
	
	
	@JsonIgnore
	private MultipartFile tech_info_upload_file;
	// 제출 서류
	private List<String> submit_file_ext_id_list;
	@JsonIgnore
	private MultipartFile[] submit_files;
	private List<ReceptionFileVO> submit_files_list;
	// EXPERT 처리
	private String choiced_expert_info_list_json;
	private List<ReceptionExpertVO> choiced_expert_list;
	// 체크 리스트 처리
	private String self_check_list_json;
	private List<ReceptionCheckListVO> self_check_list;
	
	private String use_yn = "";
	private String reg_date = "";
	private String mail_send_date = "";
	
	// 내부 사용
	private int submit_file_id;
	private int submit_file_ext_id;
	private String submit_file_name = "";
	
	// Detail 용 return Params
	private int total_count;
	private int result;
	
	
	
	public String getParticipation_name() {
		return participation_name;
	}
	public void setParticipation_name(String participation_name) {
		this.participation_name = participation_name;
	}
	public String getReceipt_from() {
		return receipt_from;
	}
	public void setReceipt_from(String receipt_from) {
		this.receipt_from = receipt_from;
	}
	public String getReceipt_to() {
		return receipt_to;
	}
	public void setReceipt_to(String receipt_to) {
		this.receipt_to = receipt_to;
	}
	public String getTech_info_area() {
		return tech_info_area;
	}
	public void setTech_info_area(String tech_info_area) {
		this.tech_info_area = tech_info_area;
	}
	public String getTech_info_type() {
		return tech_info_type;
	}
	public void setTech_info_type(String tech_info_type) {
		this.tech_info_type = tech_info_type;
	}
	public String getTech_info_4th_industry() {
		return tech_info_4th_industry;
	}
	public void setTech_info_4th_industry(String tech_info_4th_industry) {
		this.tech_info_4th_industry = tech_info_4th_industry;
	}
	public String getTech_info_4th_industry_name() {
		return tech_info_4th_industry_name;
	}
	public void setTech_info_4th_industry_name(String tech_info_4th_industry_name) {
		this.tech_info_4th_industry_name = tech_info_4th_industry_name;
	}
	public String getTech_info_large() {
		return tech_info_large;
	}
	public void setTech_info_large(String tech_info_large) {
		this.tech_info_large = tech_info_large;
	}
	public String getTech_info_middle() {
		return tech_info_middle;
	}
	public void setTech_info_middle(String tech_info_middle) {
		this.tech_info_middle = tech_info_middle;
	}
	public String getTech_info_small() {
		return tech_info_small;
	}
	public void setTech_info_small(String tech_info_small) {
		this.tech_info_small = tech_info_small;
	}
	public String getTech_info_feature() {
		return tech_info_feature;
	}
	public void setTech_info_feature(String tech_info_feature) {
		this.tech_info_feature = tech_info_feature;
	}
	public String getTech_info_effect() {
		return tech_info_effect;
	}
	public void setTech_info_effect(String tech_info_effect) {
		this.tech_info_effect = tech_info_effect;
	}
	public int getExpert_id() {
		return expert_id;
	}
	public void setExpert_id(int expert_id) {
		this.expert_id = expert_id;
	}
	public String getMail_send_date() {
		return mail_send_date;
	}
	public void setMail_send_date(String mail_send_date) {
		this.mail_send_date = mail_send_date;
	}
	public String getTech_consulting_4th_industry_name() {
		return tech_consulting_4th_industry_name;
	}
	public void setTech_consulting_4th_industry_name(String tech_consulting_4th_industry_name) {
		this.tech_consulting_4th_industry_name = tech_consulting_4th_industry_name;
	}
	public String getTech_consulting_take_yn() {
		return tech_consulting_take_yn;
	}
	public void setTech_consulting_take_yn(String tech_consulting_take_yn) {
		this.tech_consulting_take_yn = tech_consulting_take_yn;
	}
	public String getTech_info_market_report() {
		return tech_info_market_report;
	}
	public void setTech_info_market_report(String tech_info_market_report) {
		this.tech_info_market_report = tech_info_market_report;
	}
	public String getTech_info_upload_file_name() {
		return tech_info_upload_file_name;
	}
	public void setTech_info_upload_file_name(String tech_info_upload_file_name) {
		this.tech_info_upload_file_name = tech_info_upload_file_name;
	}
	public String getReception_status() {
		return reception_status;
	}
	public void setReception_status(String reception_status) {
		this.reception_status = reception_status;
	}
	public List<ReceptionFileVO> getSubmit_files_list() {
		return submit_files_list;
	}
	public void setSubmit_files_list(List<ReceptionFileVO> submit_files_list) {
		this.submit_files_list = submit_files_list;
	}
	public String getSubmit_file_name() {
		return submit_file_name;
	}
	public void setSubmit_file_name(String submit_file_name) {
		this.submit_file_name = submit_file_name;
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
	public String getAnnouncement_title() {
		return announcement_title;
	}
	public void setAnnouncement_title(String announcement_title) {
		this.announcement_title = announcement_title;
	}
	public String getAnnouncement_business_name() {
		return announcement_business_name;
	}
	public void setAnnouncement_business_name(String announcement_business_name) {
		this.announcement_business_name = announcement_business_name;
	}
	public String getAnnouncement_type_name() {
		return announcement_type_name;
	}
	public void setAnnouncement_type_name(String announcement_type_name) {
		this.announcement_type_name = announcement_type_name;
	}
	public List<ReceptionCheckListVO> getSelf_check_list() {
		return self_check_list;
	}
	public void setSelf_check_list(List<ReceptionCheckListVO> self_check_list) {
		this.self_check_list = self_check_list;
	}
	public List<ReceptionExpertVO> getChoiced_expert_list() {
		return choiced_expert_list;
	}
	public void setChoiced_expert_list(List<ReceptionExpertVO> choiced_expert_list) {
		this.choiced_expert_list = choiced_expert_list;
	}
	public int getSubmit_file_id() {
		return submit_file_id;
	}
	public void setSubmit_file_id(int submit_file_id) {
		this.submit_file_id = submit_file_id;
	}
	public int getSubmit_file_ext_id() {
		return submit_file_ext_id;
	}
	public void setSubmit_file_ext_id(int submit_file_ext_id) {
		this.submit_file_ext_id = submit_file_ext_id;
	}
	public int getReception_id() {
		return reception_id;
	}
	public void setReception_id(int reception_id) {
		this.reception_id = reception_id;
	}
	public String getReception_reg_number() {
		return reception_reg_number;
	}
	public void setReception_reg_number(String reception_reg_number) {
		this.reception_reg_number = reception_reg_number;
	}
	public String getAnnouncement_type() {
		return announcement_type;
	}
	public void setAnnouncement_type(String announcement_type) {
		this.announcement_type = announcement_type;
	}
	public int getTech_info_upload_file_id() {
		return tech_info_upload_file_id;
	}
	public void setTech_info_upload_file_id(int tech_info_upload_file_id) {
		this.tech_info_upload_file_id = tech_info_upload_file_id;
	}
	public String getInstitution_address_detail() {
		return institution_address_detail;
	}
	public void setInstitution_address_detail(String institution_address_detail) {
		this.institution_address_detail = institution_address_detail;
	}
	public int getAnnouncement_id() {
		return announcement_id;
	}
	public void setAnnouncement_id(int announcement_id) {
		this.announcement_id = announcement_id;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getInstitution_reg_number() {
		return institution_reg_number;
	}
	public void setInstitution_reg_number(String institution_reg_number) {
		this.institution_reg_number = institution_reg_number;
	}
	public String getInstitution_name() {
		return institution_name;
	}
	public void setInstitution_name(String institution_name) {
		this.institution_name = institution_name;
	}
	public String getInstitution_address() {
		return institution_address;
	}
	public void setInstitution_address(String institution_address) {
		this.institution_address = institution_address;
	}
	public String getInstitution_phone() {
		return institution_phone;
	}
	public void setInstitution_phone(String institution_phone) {
		this.institution_phone = institution_phone;
	}
	public String getInstitution_owner_name() {
		return institution_owner_name;
	}
	public void setInstitution_owner_name(String institution_owner_name) {
		this.institution_owner_name = institution_owner_name;
	}
	public String getInstitution_industry() {
		return institution_industry;
	}
	public void setInstitution_industry(String institution_industry) {
		this.institution_industry = institution_industry;
	}
	public String getInstitution_business() {
		return institution_business;
	}
	public void setInstitution_business(String institution_business) {
		this.institution_business = institution_business;
	}
	public String getInstitution_foundataion_date() {
		return institution_foundataion_date;
	}
	public void setInstitution_foundataion_date(String institution_foundataion_date) {
		this.institution_foundataion_date = institution_foundataion_date;
	}
	public String getInstitution_foundataion_type() {
		return institution_foundataion_type;
	}
	public void setInstitution_foundataion_type(String institution_foundataion_type) {
		this.institution_foundataion_type = institution_foundataion_type;
	}
	public String getInstitution_classification() {
		return institution_classification;
	}
	public void setInstitution_classification(String institution_classification) {
		this.institution_classification = institution_classification;
	}
	public String getInstitution_type() {
		return institution_type;
	}
	public void setInstitution_type(String institution_type) {
		this.institution_type = institution_type;
	}
	public String getInstitution_laboratory_yn() {
		return institution_laboratory_yn;
	}
	public void setInstitution_laboratory_yn(String institution_laboratory_yn) {
		this.institution_laboratory_yn = institution_laboratory_yn;
	}
	public String getInstitution_employee_count() {
		return institution_employee_count;
	}
	public void setInstitution_employee_count(String institution_employee_count) {
		this.institution_employee_count = institution_employee_count;
	}
	public String getInstitution_total_sales() {
		return institution_total_sales;
	}
	public void setInstitution_total_sales(String institution_total_sales) {
		this.institution_total_sales = institution_total_sales;
	}
	public String getInstitution_capital_1() {
		return institution_capital_1;
	}
	public void setInstitution_capital_1(String institution_capital_1) {
		this.institution_capital_1 = institution_capital_1;
	}
	public String getInstitution_capital_2() {
		return institution_capital_2;
	}
	public void setInstitution_capital_2(String institution_capital_2) {
		this.institution_capital_2 = institution_capital_2;
	}
	public String getInstitution_capital_3() {
		return institution_capital_3;
	}
	public void setInstitution_capital_3(String institution_capital_3) {
		this.institution_capital_3 = institution_capital_3;
	}
	public String getResearcher_name() {
		return researcher_name;
	}
	public void setResearcher_name(String researcher_name) {
		this.researcher_name = researcher_name;
	}
	public String getResearcher_mobile_phone() {
		return researcher_mobile_phone;
	}
	public void setResearcher_mobile_phone(String researcher_mobile_phone) {
		this.researcher_mobile_phone = researcher_mobile_phone;
	}
	public String getResearcher_email() {
		return researcher_email;
	}
	public void setResearcher_email(String researcher_email) {
		this.researcher_email = researcher_email;
	}
	public String getResearcher_address() {
		return researcher_address;
	}
	public void setResearcher_address(String researcher_address) {
		this.researcher_address = researcher_address;
	}
	public String getResearcher_address_detail() {
		return researcher_address_detail;
	}
	public void setResearcher_address_detail(String researcher_address_detail) {
		this.researcher_address_detail = researcher_address_detail;
	}
	public String getResearcher_institution_name() {
		return researcher_institution_name;
	}
	public void setResearcher_institution_name(String researcher_institution_name) {
		this.researcher_institution_name = researcher_institution_name;
	}
	public String getResearcher_institution_department() {
		return researcher_institution_department;
	}
	public void setResearcher_institution_department(String researcher_institution_department) {
		this.researcher_institution_department = researcher_institution_department;
	}
	public String getResearcher_institution_position() {
		return researcher_institution_position;
	}
	public void setResearcher_institution_position(String researcher_institution_position) {
		this.researcher_institution_position = researcher_institution_position;
	}
	public String getTech_consulting_type() {
		return tech_consulting_type;
	}
	public void setTech_consulting_type(String tech_consulting_type) {
		this.tech_consulting_type = tech_consulting_type;
	}
	public String getTech_consulting_campus() {
		return tech_consulting_campus;
	}
	public void setTech_consulting_campus(String tech_consulting_campus) {
		this.tech_consulting_campus = tech_consulting_campus;
	}
	public String getTech_consulting_large() {
		return tech_consulting_large;
	}
	public void setTech_consulting_large(String tech_consulting_large) {
		this.tech_consulting_large = tech_consulting_large;
	}
	public String getTech_consulting_middle() {
		return tech_consulting_middle;
	}
	public void setTech_consulting_middle(String tech_consulting_middle) {
		this.tech_consulting_middle = tech_consulting_middle;
	}
	public String getTech_consulting_small() {
		return tech_consulting_small;
	}
	public void setTech_consulting_small(String tech_consulting_small) {
		this.tech_consulting_small = tech_consulting_small;
	}
	public String getTech_consulting_4th_industry() {
		return tech_consulting_4th_industry;
	}
	public void setTech_consulting_4th_industry(String tech_consulting_4th_industry) {
		this.tech_consulting_4th_industry = tech_consulting_4th_industry;
	}
	public String getTech_consulting_purpose() {
		return tech_consulting_purpose;
	}
	public void setTech_consulting_purpose(String tech_consulting_purpose) {
		this.tech_consulting_purpose = tech_consulting_purpose;
	}
	public String getTech_consulting_purpose_etc() {
		return tech_consulting_purpose_etc;
	}
	public void setTech_consulting_purpose_etc(String tech_consulting_purpose_etc) {
		this.tech_consulting_purpose_etc = tech_consulting_purpose_etc;
	}
	public String getTech_info_name() {
		return tech_info_name;
	}
	public void setTech_info_name(String tech_info_name) {
		this.tech_info_name = tech_info_name;
	}
	public String getTech_info_description() {
		return tech_info_description;
	}
	public void setTech_info_description(String tech_info_description) {
		this.tech_info_description = tech_info_description;
	}
	public String getTech_info_problems() {
		return tech_info_problems;
	}
	public void setTech_info_problems(String tech_info_problems) {
		this.tech_info_problems = tech_info_problems;
	}
	public String getTech_info_consulting_request() {
		return tech_info_consulting_request;
	}
	public void setTech_info_consulting_request(String tech_info_consulting_request) {
		this.tech_info_consulting_request = tech_info_consulting_request;
	}
	public String getTech_info_rnd_description() {
		return tech_info_rnd_description;
	}
	public void setTech_info_rnd_description(String tech_info_rnd_description) {
		this.tech_info_rnd_description = tech_info_rnd_description;
	}
	public String getTech_info_expert_request() {
		return tech_info_expert_request;
	}
	public void setTech_info_expert_request(String tech_info_expert_request) {
		this.tech_info_expert_request = tech_info_expert_request;
	}
	public MultipartFile getTech_info_upload_file() {
		return tech_info_upload_file;
	}
	public void setTech_info_upload_file(MultipartFile tech_info_upload_file) {
		this.tech_info_upload_file = tech_info_upload_file;
	}
	public List<String> getSubmit_file_ext_id_list() {
		return submit_file_ext_id_list;
	}
	public void setSubmit_file_ext_id_list(List<String> submit_file_ext_id_list) {
		this.submit_file_ext_id_list = submit_file_ext_id_list;
	}
	public MultipartFile[] getSubmit_files() {
		return submit_files;
	}
	public void setSubmit_files(MultipartFile[] submit_files) {
		this.submit_files = submit_files;
	}
	public String getChoiced_expert_info_list_json() {
		return choiced_expert_info_list_json;
	}
	public void setChoiced_expert_info_list_json(String choiced_expert_info_list_json) {
		String tempJsonData = choiced_expert_info_list_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			choiced_expert_list = Arrays.asList(mapper.readValue(tempJsonData, ReceptionExpertVO[].class));
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
		this.choiced_expert_info_list_json = choiced_expert_info_list_json;
	}
	public String getSelf_check_list_json() {
		return self_check_list_json;
	}
	public void setSelf_check_list_json(String self_check_list_json) {
		String tempJsonData = self_check_list_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			self_check_list = Arrays.asList(mapper.readValue(tempJsonData, ReceptionCheckListVO[].class));
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
		
		this.self_check_list_json = self_check_list_json;
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
