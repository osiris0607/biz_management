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
package com.anchordata.webframework.service.member;

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
public class CommissionerVO {

	private static final long serialVersionUID = 1L;

	private String commissioner_id = "";
	private String member_id = "";
	private String private_info_yn = "";
	private String info_terms_yn = "";
	private String security_yn = "";
	private String commissioner_status = "";
	private String bank_name = "";
	private String bank_account = "";
	private String national_skill_large = "";
	private String national_skill_middle = "";
	private String national_skill_small = "";
	private String four_industry = "";
	private String rnd_class = "";
	// 학력
	private String degree_01 = "";
	private String degree_school_01 = "";
	private String degree_major_01 = "";
	private String degree_date_01 = "";
	@JsonIgnore
	private MultipartFile degree_certi_file_01;
	private int degree_certificate_file_id_01;
	private String degree_certificate_file_name_01;
	private String degree_02 = "";
	private String degree_school_02 = "";
	private String degree_major_02 = "";
	private String degree_date_02 = "";
	@JsonIgnore
	private MultipartFile degree_certi_file_02;
	private int degree_certificate_file_id_02;
	private String degree_certificate_file_name_02;
	// 경력
	private String career_company_01 = "";
	private String career_depart_01 = "";
	private String career_position_01 = "";
	private String career_start_date_01 = "";
	private String career_retire_date_01 = "";
	private String career_description_01 = "";
	private String career_company_02 = "";
	private String career_depart_02 = "";
	private String career_position_02 = "";
	private String career_start_date_02 = "";
	private String career_retire_date_02 = "";
	private String career_description_02 = "";
	private String career_company_03 = "";
	private String career_depart_03 = "";
	private String career_position_03 = "";
	private String career_start_date_03 = "";
	private String career_retire_date_03 = "";
	private String career_description_03 = "";
	private String career_company_04 = "";
	private String career_depart_04 = "";
	private String career_position_04 = "";
	private String career_start_date_04 = "";
	private String career_retire_date_04 = "";
	private String career_description_04 = "";
	// 논문
	private String thesis_sci_yn_01 = "";
	private String thesis_title_01 = "";
	private String thesis_writer_01 = "";
	private String thesis_journal_01 = "";
	private String thesis_nationality_01 = "";
	private String thesis_date_01 = "";
	private String thesis_sci_yn_02 = "";
	private String thesis_title_02 = "";
	private String thesis_writer_02 = "";
	private String thesis_journal_02 = "";
	private String thesis_nationality_02 = "";
	private String thesis_date_02 = "";
	private String thesis_sci_yn_03 = "";
	private String thesis_title_03 = "";
	private String thesis_writer_03 = "";
	private String thesis_journal_03 = "";
	private String thesis_nationality_03 = "";
	private String thesis_date_03 = "";
	// 지적재산권
	private String iprs_name_01 = "";
	private String iprs_enroll_01 = "";
	private String iprs_reg_no_01 = "";
	private String iprs_date_01 = "";
	private String iprs_nationality_01 = "";
	private String iprs_writer_01 = "";
	private String iprs_name_02 = "";
	private String iprs_enroll_02 = "";
	private String iprs_reg_no_02 = "";
	private String iprs_date_02 = "";
	private String iprs_nationality_02 = "";
	private String iprs_writer_02 = "";
	private String iprs_name_03 = "";
	private String iprs_enroll_03 = "";
	private String iprs_reg_no_03 = "";
	private String iprs_date_03 = "";
	private String iprs_nationality_03 = "";
	private String iprs_writer_03 = "";
		
	private String self_description = "";
	private String remark = "";
	private String reg_date = "";
	private String update_date = "";
	
	// 조회 결과 
	private String name = "";
	private String mobile_phone = "";
	private String email = "";
	private String address = "";
	private String institution_type = "";
	private String institution_type_name = "";
	private String institution_name = "";
	private String commissioner_status_name = "";
	private String four_industry_name = "";
	
	private int total_count;
	
	// 소속 기관 유형별 평가위원 수 (개인/기업/학교/연구원/공공기관/기타(협/단체 등)/내부평가위원)
	private int institution_type_personal_count = 0;
	private int institution_type_company_count = 0;
	private int institution_type_school_count = 0;
	private int institution_type_commissioner_count = 0;
	private int institution_type_department_count = 0;
	private int institution_type_etc_count = 0;
	private int institution_type_manager_count = 0;
	private int institution_type_count_limit = 0;
	
	
	
	public String getCommissioner_id() {
		return commissioner_id;
	}
	public void setCommissioner_id(String commissioner_id) {
		this.commissioner_id = commissioner_id;
	}
	public int getInstitution_type_count_limit() {
		return institution_type_count_limit;
	}
	public void setInstitution_type_count_limit(int institution_type_count_limit) {
		this.institution_type_count_limit = institution_type_count_limit;
	}
	public int getInstitution_type_manager_count() {
		return institution_type_manager_count;
	}
	public void setInstitution_type_manager_count(int institution_type_manager_count) {
		this.institution_type_manager_count = institution_type_manager_count;
	}
	public int getInstitution_type_personal_count() {
		return institution_type_personal_count;
	}
	public void setInstitution_type_personal_count(int institution_type_personal_count) {
		this.institution_type_personal_count = institution_type_personal_count;
	}
	public int getInstitution_type_company_count() {
		return institution_type_company_count;
	}
	public void setInstitution_type_company_count(int institution_type_company_count) {
		this.institution_type_company_count = institution_type_company_count;
	}
	public int getInstitution_type_school_count() {
		return institution_type_school_count;
	}
	public void setInstitution_type_school_count(int institution_type_school_count) {
		this.institution_type_school_count = institution_type_school_count;
	}
	public int getInstitution_type_commissioner_count() {
		return institution_type_commissioner_count;
	}
	public void setInstitution_type_commissioner_count(int institution_type_commissioner_count) {
		this.institution_type_commissioner_count = institution_type_commissioner_count;
	}
	public int getInstitution_type_department_count() {
		return institution_type_department_count;
	}
	public void setInstitution_type_department_count(int institution_type_department_count) {
		this.institution_type_department_count = institution_type_department_count;
	}
	public int getInstitution_type_etc_count() {
		return institution_type_etc_count;
	}
	public void setInstitution_type_etc_count(int institution_type_etc_count) {
		this.institution_type_etc_count = institution_type_etc_count;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getDegree_certificate_file_name_01() {
		return degree_certificate_file_name_01;
	}
	public void setDegree_certificate_file_name_01(String degree_certificate_file_name_01) {
		this.degree_certificate_file_name_01 = degree_certificate_file_name_01;
	}
	public String getDegree_certificate_file_name_02() {
		return degree_certificate_file_name_02;
	}
	public void setDegree_certificate_file_name_02(String degree_certificate_file_name_02) {
		this.degree_certificate_file_name_02 = degree_certificate_file_name_02;
	}
	public String getFour_industry_name() {
		return four_industry_name;
	}
	public void setFour_industry_name(String four_industry_name) {
		this.four_industry_name = four_industry_name;
	}

	public String getCommissioner_status_name() {
		return commissioner_status_name;
	}

	public void setCommissioner_status_name(String commissioner_status_name) {
		this.commissioner_status_name = commissioner_status_name;
	}

	public String getInstitution_type_name() {
		return institution_type_name;
	}

	public void setInstitution_type_name(String institution_type_name) {
		this.institution_type_name = institution_type_name;
	}

	public String getReg_date() {
		return reg_date;
	}

	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}

	public String getUpdate_date() {
		return update_date;
	}

	public void setUpdate_date(String update_date) {
		this.update_date = update_date;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMobile_phone() {
		return mobile_phone;
	}

	public void setMobile_phone(String mobile_phone) {
		this.mobile_phone = mobile_phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getInstitution_type() {
		return institution_type;
	}

	public void setInstitution_type(String institution_type) {
		this.institution_type = institution_type;
	}

	public String getInstitution_name() {
		return institution_name;
	}

	public void setInstitution_name(String institution_name) {
		this.institution_name = institution_name;
	}

	public String getCommissioner_status() {
		return commissioner_status;
	}

	public void setCommissioner_status(String commissioner_status) {
		this.commissioner_status = commissioner_status;
	}

	public int getDegree_certificate_file_id_01() {
		return degree_certificate_file_id_01;
	}

	public void setDegree_certificate_file_id_01(int degree_certificate_file_id_01) {
		this.degree_certificate_file_id_01 = degree_certificate_file_id_01;
	}

	public int getDegree_certificate_file_id_02() {
		return degree_certificate_file_id_02;
	}

	public void setDegree_certificate_file_id_02(int degree_certificate_file_id_02) {
		this.degree_certificate_file_id_02 = degree_certificate_file_id_02;
	}

	public MultipartFile getDegree_certi_file_01() {
		return degree_certi_file_01;
	}

	public void setDegree_certi_file_01(MultipartFile degree_certi_file_01) {
		this.degree_certi_file_01 = degree_certi_file_01;
	}

	public MultipartFile getDegree_certi_file_02() {
		return degree_certi_file_02;
	}

	public void setDegree_certi_file_02(MultipartFile degree_certi_file_02) {
		this.degree_certi_file_02 = degree_certi_file_02;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getPrivate_info_yn() {
		return private_info_yn;
	}

	public void setPrivate_info_yn(String private_info_yn) {
		this.private_info_yn = private_info_yn;
	}

	public String getInfo_terms_yn() {
		return info_terms_yn;
	}

	public void setInfo_terms_yn(String info_terms_yn) {
		this.info_terms_yn = info_terms_yn;
	}

	public String getSecurity_yn() {
		return security_yn;
	}

	public void setSecurity_yn(String security_yn) {
		this.security_yn = security_yn;
	}

	public String getBank_name() {
		return bank_name;
	}

	public void setBank_name(String bank_name) {
		this.bank_name = bank_name;
	}

	public String getBank_account() {
		return bank_account;
	}

	public void setBank_account(String bank_account) {
		this.bank_account = bank_account;
	}

	public String getNational_skill_large() {
		return national_skill_large;
	}

	public void setNational_skill_large(String national_skill_large) {
		this.national_skill_large = national_skill_large;
	}

	public String getNational_skill_middle() {
		return national_skill_middle;
	}

	public void setNational_skill_middle(String national_skill_middle) {
		this.national_skill_middle = national_skill_middle;
	}

	public String getNational_skill_small() {
		return national_skill_small;
	}

	public void setNational_skill_small(String national_skill_small) {
		this.national_skill_small = national_skill_small;
	}

	public String getFour_industry() {
		return four_industry;
	}

	public void setFour_industry(String four_industry) {
		this.four_industry = four_industry;
	}

	public String getRnd_class() {
		return rnd_class;
	}

	public void setRnd_class(String rnd_class) {
		this.rnd_class = rnd_class;
	}

	public String getDegree_01() {
		return degree_01;
	}

	public void setDegree_01(String degree_01) {
		this.degree_01 = degree_01;
	}

	public String getDegree_school_01() {
		return degree_school_01;
	}

	public void setDegree_school_01(String degree_school_01) {
		this.degree_school_01 = degree_school_01;
	}

	public String getDegree_major_01() {
		return degree_major_01;
	}

	public void setDegree_major_01(String degree_major_01) {
		this.degree_major_01 = degree_major_01;
	}

	public String getDegree_date_01() {
		return degree_date_01;
	}

	public void setDegree_date_01(String degree_date_01) {
		this.degree_date_01 = degree_date_01;
	}

	public String getDegree_02() {
		return degree_02;
	}

	public void setDegree_02(String degree_02) {
		this.degree_02 = degree_02;
	}

	public String getDegree_school_02() {
		return degree_school_02;
	}

	public void setDegree_school_02(String degree_school_02) {
		this.degree_school_02 = degree_school_02;
	}

	public String getDegree_major_02() {
		return degree_major_02;
	}

	public void setDegree_major_02(String degree_major_02) {
		this.degree_major_02 = degree_major_02;
	}

	public String getDegree_date_02() {
		return degree_date_02;
	}

	public void setDegree_date_02(String degree_date_02) {
		this.degree_date_02 = degree_date_02;
	}

	public String getCareer_company_01() {
		return career_company_01;
	}

	public void setCareer_company_01(String career_company_01) {
		this.career_company_01 = career_company_01;
	}

	public String getCareer_depart_01() {
		return career_depart_01;
	}

	public void setCareer_depart_01(String career_depart_01) {
		this.career_depart_01 = career_depart_01;
	}

	public String getCareer_position_01() {
		return career_position_01;
	}

	public void setCareer_position_01(String career_position_01) {
		this.career_position_01 = career_position_01;
	}

	public String getCareer_start_date_01() {
		return career_start_date_01;
	}

	public void setCareer_start_date_01(String career_start_date_01) {
		this.career_start_date_01 = career_start_date_01;
	}

	public String getCareer_retire_date_01() {
		return career_retire_date_01;
	}

	public void setCareer_retire_date_01(String career_retire_date_01) {
		this.career_retire_date_01 = career_retire_date_01;
	}

	public String getCareer_description_01() {
		return career_description_01;
	}

	public void setCareer_description_01(String career_description_01) {
		this.career_description_01 = career_description_01;
	}

	public String getCareer_company_02() {
		return career_company_02;
	}

	public void setCareer_company_02(String career_company_02) {
		this.career_company_02 = career_company_02;
	}

	public String getCareer_depart_02() {
		return career_depart_02;
	}

	public void setCareer_depart_02(String career_depart_02) {
		this.career_depart_02 = career_depart_02;
	}

	public String getCareer_position_02() {
		return career_position_02;
	}

	public void setCareer_position_02(String career_position_02) {
		this.career_position_02 = career_position_02;
	}

	public String getCareer_start_date_02() {
		return career_start_date_02;
	}

	public void setCareer_start_date_02(String career_start_date_02) {
		this.career_start_date_02 = career_start_date_02;
	}

	public String getCareer_retire_date_02() {
		return career_retire_date_02;
	}

	public void setCareer_retire_date_02(String career_retire_date_02) {
		this.career_retire_date_02 = career_retire_date_02;
	}

	public String getCareer_description_02() {
		return career_description_02;
	}

	public void setCareer_description_02(String career_description_02) {
		this.career_description_02 = career_description_02;
	}

	public String getCareer_company_03() {
		return career_company_03;
	}

	public void setCareer_company_03(String career_company_03) {
		this.career_company_03 = career_company_03;
	}

	public String getCareer_depart_03() {
		return career_depart_03;
	}

	public void setCareer_depart_03(String career_depart_03) {
		this.career_depart_03 = career_depart_03;
	}

	public String getCareer_position_03() {
		return career_position_03;
	}

	public void setCareer_position_03(String career_position_03) {
		this.career_position_03 = career_position_03;
	}

	public String getCareer_start_date_03() {
		return career_start_date_03;
	}

	public void setCareer_start_date_03(String career_start_date_03) {
		this.career_start_date_03 = career_start_date_03;
	}

	public String getCareer_retire_date_03() {
		return career_retire_date_03;
	}

	public void setCareer_retire_date_03(String career_retire_date_03) {
		this.career_retire_date_03 = career_retire_date_03;
	}

	public String getCareer_description_03() {
		return career_description_03;
	}

	public void setCareer_description_03(String career_description_03) {
		this.career_description_03 = career_description_03;
	}

	public String getCareer_company_04() {
		return career_company_04;
	}

	public void setCareer_company_04(String career_company_04) {
		this.career_company_04 = career_company_04;
	}

	public String getCareer_depart_04() {
		return career_depart_04;
	}

	public void setCareer_depart_04(String career_depart_04) {
		this.career_depart_04 = career_depart_04;
	}

	public String getCareer_position_04() {
		return career_position_04;
	}

	public void setCareer_position_04(String career_position_04) {
		this.career_position_04 = career_position_04;
	}

	public String getCareer_start_date_04() {
		return career_start_date_04;
	}

	public void setCareer_start_date_04(String career_start_date_04) {
		this.career_start_date_04 = career_start_date_04;
	}

	public String getCareer_retire_date_04() {
		return career_retire_date_04;
	}

	public void setCareer_retire_date_04(String career_retire_date_04) {
		this.career_retire_date_04 = career_retire_date_04;
	}

	public String getCareer_description_04() {
		return career_description_04;
	}

	public void setCareer_description_04(String career_description_04) {
		this.career_description_04 = career_description_04;
	}

	public String getThesis_sci_yn_01() {
		return thesis_sci_yn_01;
	}

	public void setThesis_sci_yn_01(String thesis_sci_yn_01) {
		this.thesis_sci_yn_01 = thesis_sci_yn_01;
	}

	public String getThesis_title_01() {
		return thesis_title_01;
	}

	public void setThesis_title_01(String thesis_title_01) {
		this.thesis_title_01 = thesis_title_01;
	}

	public String getThesis_writer_01() {
		return thesis_writer_01;
	}

	public void setThesis_writer_01(String thesis_writer_01) {
		this.thesis_writer_01 = thesis_writer_01;
	}

	public String getThesis_journal_01() {
		return thesis_journal_01;
	}

	public void setThesis_journal_01(String thesis_journal_01) {
		this.thesis_journal_01 = thesis_journal_01;
	}

	public String getThesis_nationality_01() {
		return thesis_nationality_01;
	}

	public void setThesis_nationality_01(String thesis_nationality_01) {
		this.thesis_nationality_01 = thesis_nationality_01;
	}

	public String getThesis_date_01() {
		return thesis_date_01;
	}

	public void setThesis_date_01(String thesis_date_01) {
		this.thesis_date_01 = thesis_date_01;
	}

	public String getThesis_sci_yn_02() {
		return thesis_sci_yn_02;
	}

	public void setThesis_sci_yn_02(String thesis_sci_yn_02) {
		this.thesis_sci_yn_02 = thesis_sci_yn_02;
	}

	public String getThesis_title_02() {
		return thesis_title_02;
	}

	public void setThesis_title_02(String thesis_title_02) {
		this.thesis_title_02 = thesis_title_02;
	}

	public String getThesis_writer_02() {
		return thesis_writer_02;
	}

	public void setThesis_writer_02(String thesis_writer_02) {
		this.thesis_writer_02 = thesis_writer_02;
	}

	public String getThesis_journal_02() {
		return thesis_journal_02;
	}

	public void setThesis_journal_02(String thesis_journal_02) {
		this.thesis_journal_02 = thesis_journal_02;
	}

	public String getThesis_nationality_02() {
		return thesis_nationality_02;
	}

	public void setThesis_nationality_02(String thesis_nationality_02) {
		this.thesis_nationality_02 = thesis_nationality_02;
	}

	public String getThesis_date_02() {
		return thesis_date_02;
	}

	public void setThesis_date_02(String thesis_date_02) {
		this.thesis_date_02 = thesis_date_02;
	}

	public String getThesis_sci_yn_03() {
		return thesis_sci_yn_03;
	}

	public void setThesis_sci_yn_03(String thesis_sci_yn_03) {
		this.thesis_sci_yn_03 = thesis_sci_yn_03;
	}

	public String getThesis_title_03() {
		return thesis_title_03;
	}

	public void setThesis_title_03(String thesis_title_03) {
		this.thesis_title_03 = thesis_title_03;
	}

	public String getThesis_writer_03() {
		return thesis_writer_03;
	}

	public void setThesis_writer_03(String thesis_writer_03) {
		this.thesis_writer_03 = thesis_writer_03;
	}

	public String getThesis_journal_03() {
		return thesis_journal_03;
	}

	public void setThesis_journal_03(String thesis_journal_03) {
		this.thesis_journal_03 = thesis_journal_03;
	}

	public String getThesis_nationality_03() {
		return thesis_nationality_03;
	}

	public void setThesis_nationality_03(String thesis_nationality_03) {
		this.thesis_nationality_03 = thesis_nationality_03;
	}

	public String getThesis_date_03() {
		return thesis_date_03;
	}

	public void setThesis_date_03(String thesis_date_03) {
		this.thesis_date_03 = thesis_date_03;
	}

	public String getIprs_name_01() {
		return iprs_name_01;
	}

	public void setIprs_name_01(String iprs_name_01) {
		this.iprs_name_01 = iprs_name_01;
	}

	public String getIprs_enroll_01() {
		return iprs_enroll_01;
	}

	public void setIprs_enroll_01(String iprs_enroll_01) {
		this.iprs_enroll_01 = iprs_enroll_01;
	}

	public String getIprs_reg_no_01() {
		return iprs_reg_no_01;
	}

	public void setIprs_reg_no_01(String iprs_reg_no_01) {
		this.iprs_reg_no_01 = iprs_reg_no_01;
	}

	public String getIprs_date_01() {
		return iprs_date_01;
	}

	public void setIprs_date_01(String iprs_date_01) {
		this.iprs_date_01 = iprs_date_01;
	}

	public String getIprs_nationality_01() {
		return iprs_nationality_01;
	}

	public void setIprs_nationality_01(String iprs_nationality_01) {
		this.iprs_nationality_01 = iprs_nationality_01;
	}

	public String getIprs_writer_01() {
		return iprs_writer_01;
	}

	public void setIprs_writer_01(String iprs_writer_01) {
		this.iprs_writer_01 = iprs_writer_01;
	}

	public String getIprs_name_02() {
		return iprs_name_02;
	}

	public void setIprs_name_02(String iprs_name_02) {
		this.iprs_name_02 = iprs_name_02;
	}

	public String getIprs_enroll_02() {
		return iprs_enroll_02;
	}

	public void setIprs_enroll_02(String iprs_enroll_02) {
		this.iprs_enroll_02 = iprs_enroll_02;
	}

	public String getIprs_reg_no_02() {
		return iprs_reg_no_02;
	}

	public void setIprs_reg_no_02(String iprs_reg_no_02) {
		this.iprs_reg_no_02 = iprs_reg_no_02;
	}

	public String getIprs_date_02() {
		return iprs_date_02;
	}

	public void setIprs_date_02(String iprs_date_02) {
		this.iprs_date_02 = iprs_date_02;
	}

	public String getIprs_nationality_02() {
		return iprs_nationality_02;
	}

	public void setIprs_nationality_02(String iprs_nationality_02) {
		this.iprs_nationality_02 = iprs_nationality_02;
	}

	public String getIprs_writer_02() {
		return iprs_writer_02;
	}

	public void setIprs_writer_02(String iprs_writer_02) {
		this.iprs_writer_02 = iprs_writer_02;
	}

	public String getIprs_name_03() {
		return iprs_name_03;
	}

	public void setIprs_name_03(String iprs_name_03) {
		this.iprs_name_03 = iprs_name_03;
	}

	public String getIprs_enroll_03() {
		return iprs_enroll_03;
	}

	public void setIprs_enroll_03(String iprs_enroll_03) {
		this.iprs_enroll_03 = iprs_enroll_03;
	}

	public String getIprs_reg_no_03() {
		return iprs_reg_no_03;
	}

	public void setIprs_reg_no_03(String iprs_reg_no_03) {
		this.iprs_reg_no_03 = iprs_reg_no_03;
	}

	public String getIprs_date_03() {
		return iprs_date_03;
	}

	public void setIprs_date_03(String iprs_date_03) {
		this.iprs_date_03 = iprs_date_03;
	}

	public String getIprs_nationality_03() {
		return iprs_nationality_03;
	}

	public void setIprs_nationality_03(String iprs_nationality_03) {
		this.iprs_nationality_03 = iprs_nationality_03;
	}

	public String getIprs_writer_03() {
		return iprs_writer_03;
	}

	public void setIprs_writer_03(String iprs_writer_03) {
		this.iprs_writer_03 = iprs_writer_03;
	}

	public String getSelf_description() {
		return self_description;
	}

	public void setSelf_description(String self_description) {
		this.self_description = self_description;
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
