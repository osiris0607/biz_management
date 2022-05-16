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

import com.anchordata.webframework.service.institution.InstitutionVO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class MemberVO {

	private static final long serialVersionUID = 1L;

	// member Field
	private int member_seq;
	private String member_id = "";
	private String name = "";
	private String birth = "";
	private String pwd = "";
	private String phone = "";
	private String mobile_phone = "";
	private String email = "";
	private String address = "";
	private String address_detail = "";
	private String nationality = "";
	private String residence_yn = "";
	private String institution_type = "";
	private String gender = "";
	private String auth_level_super_admin = "";
	private String auth_level_admin = "";
	private String auth_level_manager = "";
	private String auth_level_expert = "";
	private String auth_level_commissioner = "";
	private String auth_level_member = "Y";
	private String reg_terms_yn = "";
	private String private_info_yn = "";
	private String security_yn = "";
	private String admin_use_yn = "";
	private String use_yn = "";
	private String login_date = "";
	private String reg_date = "";
	private String institution_id = "";
	
	// member Extension Field
	private String department_type = "";
	private String university = "";
	private String department = "";
	private String position = "";
	private String lab_address = "";
	private String lab_address_detail = "";
	private String lab_phone = "";
	private String degree = "";
	private String university_degree = "";
	private String university_degree_date = "";
	private String major = "";
	private String research = "";
	private String large = "";
	private String middle = "";
	private String small = "";
	private String four_industry = "";
	private String four_industry_name = "";
	
	//논문 정보
	private String thesis_1 = "";
	private String thesis_name_1 = "";
	private String thesis_date_1 = "";
	private String thesis_sci_yn_1 = "";
	private String thesis_2 = "";
	private String thesis_name_2 = "";
	private String thesis_date_2 = "";
	private String thesis_sci_yn_2 = "";
	private String thesis_3 = "";
	private String thesis_name_3 = "";
	private String thesis_date_3 = "";
	private String thesis_sci_yn_3 = "";
	//지식 재산권
	private String iprs_1 = "";
	private String iprs_enroll_1 = "";
	private String iprs_number_1 = "";
	private String iprs_name_1 = "";
	private String iprs_date_1 = "";
	private String iprs_2 = "";
	private String iprs_enroll_2 = "";
	private String iprs_number_2 = "";
	private String iprs_name_2 = "";
	private String iprs_date_2 = "";
	private String iprs_3 = "";
	private String iprs_enroll_3 = "";
	private String iprs_number_3 = "";
	private String iprs_name_3 = "";
	private String iprs_date_3 = "";
	//기술 이전
	private String tech_tran_name_1 = "";
	private String tech_tran_date_1 = "";
	private String tech_tran_company_1 = "";
	private String tech_tran_name_2 = "";
	private String tech_tran_date_2 = "";
	private String tech_tran_company_2 = "";
	private String tech_tran_name_3 = "";
	private String tech_tran_date_3 = "";
	private String tech_tran_company_3 = "";
	//R&D과제
	private String rnd_name_1 = "";
	private String rnd_date_start_1 = "";
	private String rnd_date_end_1 = "";
	private String rnd_class_1 = "";
	private String rnd_4th_industry_1 = "";
	private String rnd_4th_industry_1_name = "";
	private String rnd_name_2 = "";
	private String rnd_date_start_2 = "";
	private String rnd_date_end_2 = "";
	private String rnd_class_2 = "";
	private String rnd_4th_industry_2 = "";
	private String rnd_4th_industry_2_name = "";
	private String rnd_name_3 = "";
	private String rnd_date_start_3 = "";
	private String rnd_date_end_3 = "";
	private String rnd_class_3 = "";
	private String rnd_4th_industry_3 = "";
	private String rnd_4th_industry_3_name = "";
	
	
	private int total_count;
	
	private String current_pwd = "";
	private String new_pwd = "";
	
	
	// institution Info
	private InstitutionVO institution;
	
	
	private String institution_type_name = "";
	private String nationality_name = "";
	private String institution_name = "";
	
	
	
	public String getAuth_level_super_admin() {
		return auth_level_super_admin;
	}
	public void setAuth_level_super_admin(String auth_level_super_admin) {
		this.auth_level_super_admin = auth_level_super_admin;
	}
	public String getInstitution_name() {
		return institution_name;
	}
	public void setInstitution_name(String institution_name) {
		this.institution_name = institution_name;
	}
	public String getInstitution_type_name() {
		return institution_type_name;
	}
	public void setInstitution_type_name(String institution_type_name) {
		this.institution_type_name = institution_type_name;
	}
	public String getNationality_name() {
		return nationality_name;
	}
	public void setNationality_name(String nationality_name) {
		this.nationality_name = nationality_name;
	}
	public String getAuth_level_commissioner() {
		return auth_level_commissioner;
	}
	public void setAuth_level_commissioner(String auth_level_commissioner) {
		this.auth_level_commissioner = auth_level_commissioner;
	}
	public String getFour_industry_name() {
		return four_industry_name;
	}
	public void setFour_industry_name(String four_industry_name) {
		this.four_industry_name = four_industry_name;
	}
	public String getRnd_4th_industry_1_name() {
		return rnd_4th_industry_1_name;
	}
	public void setRnd_4th_industry_1_name(String rnd_4th_industry_1_name) {
		this.rnd_4th_industry_1_name = rnd_4th_industry_1_name;
	}
	public String getRnd_4th_industry_2_name() {
		return rnd_4th_industry_2_name;
	}
	public void setRnd_4th_industry_2_name(String rnd_4th_industry_2_name) {
		this.rnd_4th_industry_2_name = rnd_4th_industry_2_name;
	}
	public String getRnd_4th_industry_3_name() {
		return rnd_4th_industry_3_name;
	}
	public void setRnd_4th_industry_3_name(String rnd_4th_industry_3_name) {
		this.rnd_4th_industry_3_name = rnd_4th_industry_3_name;
	}
	public String getInstitution_type() {
		return institution_type;
	}
	public void setInstitution_type(String institution_type) {
		this.institution_type = institution_type;
	}
	public String getLab_address_detail() {
		return lab_address_detail;
	}
	public void setLab_address_detail(String lab_address_detail) {
		this.lab_address_detail = lab_address_detail;
	}
	public String getAddress_detail() {
		return address_detail;
	}
	public void setAddress_detail(String address_detail) {
		this.address_detail = address_detail;
	}
	public String getInstitution_id() {
		return institution_id;
	}
	public void setInstitution_id(String institution_id) {
		this.institution_id = institution_id;
	}
	public InstitutionVO getInstitution() {
		return institution;
	}
	public void setInstitution(InstitutionVO institution) {
		this.institution = institution;
	}

	public int getMember_seq() {
		return member_seq;
	}

	public void setMember_seq(int member_seq) {
		this.member_seq = member_seq;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
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

	public String getNationality() {
		return nationality;
	}

	public void setNationality(String nationality) {
		this.nationality = nationality;
	}

	public String getResidence_yn() {
		return residence_yn;
	}

	public void setResidence_yn(String residence_yn) {
		this.residence_yn = residence_yn;
	}

	public String getDepartment_type() {
		return department_type;
	}

	public void setDepartment_type(String department_type) {
		this.department_type = department_type;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getAuth_level_admin() {
		return auth_level_admin;
	}

	public void setAuth_level_admin(String auth_level_admin) {
		this.auth_level_admin = auth_level_admin;
	}

	public String getAuth_level_manager() {
		return auth_level_manager;
	}

	public void setAuth_level_manager(String auth_level_manager) {
		this.auth_level_manager = auth_level_manager;
	}

	public String getAuth_level_expert() {
		return auth_level_expert;
	}

	public void setAuth_level_expert(String auth_level_expert) {
		this.auth_level_expert = auth_level_expert;
	}

	public String getAuth_level_member() {
		return auth_level_member;
	}

	public void setAuth_level_member(String auth_level_member) {
		this.auth_level_member = auth_level_member;
	}

	public String getReg_terms_yn() {
		return reg_terms_yn;
	}

	public void setReg_terms_yn(String reg_terms_yn) {
		this.reg_terms_yn = reg_terms_yn;
	}

	public String getPrivate_info_yn() {
		return private_info_yn;
	}

	public void setPrivate_info_yn(String private_info_yn) {
		this.private_info_yn = private_info_yn;
	}

	public String getSecurity_yn() {
		return security_yn;
	}

	public void setSecurity_yn(String security_yn) {
		this.security_yn = security_yn;
	}

	public String getAdmin_use_yn() {
		return admin_use_yn;
	}

	public void setAdmin_use_yn(String admin_use_yn) {
		this.admin_use_yn = admin_use_yn;
	}

	public String getUse_yn() {
		return use_yn;
	}

	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}

	public String getLogin_date() {
		return login_date;
	}

	public void setLogin_date(String login_date) {
		this.login_date = login_date;
	}

	public String getReg_date() {
		return reg_date;
	}

	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}

	public String getUniversity() {
		return university;
	}

	public void setUniversity(String university) {
		this.university = university;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getLab_address() {
		return lab_address;
	}

	public void setLab_address(String lab_address) {
		this.lab_address = lab_address;
	}

	public String getLab_phone() {
		return lab_phone;
	}

	public void setLab_phone(String lab_phone) {
		this.lab_phone = lab_phone;
	}

	public String getDegree() {
		return degree;
	}

	public void setDegree(String degree) {
		this.degree = degree;
	}

	public String getUniversity_degree() {
		return university_degree;
	}

	public void setUniversity_degree(String university_degree) {
		this.university_degree = university_degree;
	}

	public String getUniversity_degree_date() {
		return university_degree_date;
	}

	public void setUniversity_degree_date(String university_degree_date) {
		this.university_degree_date = university_degree_date;
	}

	public String getMajor() {
		return major;
	}

	public void setMajor(String major) {
		this.major = major;
	}

	public String getResearch() {
		return research;
	}

	public void setResearch(String research) {
		this.research = research;
	}

	public String getLarge() {
		return large;
	}

	public void setLarge(String large) {
		this.large = large;
	}

	public String getMiddle() {
		return middle;
	}

	public void setMiddle(String middle) {
		this.middle = middle;
	}

	public String getSmall() {
		return small;
	}

	public void setSmall(String small) {
		this.small = small;
	}

	public String getFour_industry() {
		return four_industry;
	}

	public void setFour_industry(String four_industry) {
		this.four_industry = four_industry;
	}

	public String getThesis_1() {
		return thesis_1;
	}

	public void setThesis_1(String thesis_1) {
		this.thesis_1 = thesis_1;
	}

	public String getThesis_name_1() {
		return thesis_name_1;
	}

	public void setThesis_name_1(String thesis_name_1) {
		this.thesis_name_1 = thesis_name_1;
	}

	public String getThesis_date_1() {
		return thesis_date_1;
	}

	public void setThesis_date_1(String thesis_date_1) {
		this.thesis_date_1 = thesis_date_1;
	}

	public String getThesis_sci_yn_1() {
		return thesis_sci_yn_1;
	}

	public void setThesis_sci_yn_1(String thesis_sci_yn_1) {
		this.thesis_sci_yn_1 = thesis_sci_yn_1;
	}

	public String getThesis_2() {
		return thesis_2;
	}

	public void setThesis_2(String thesis_2) {
		this.thesis_2 = thesis_2;
	}

	public String getThesis_name_2() {
		return thesis_name_2;
	}

	public void setThesis_name_2(String thesis_name_2) {
		this.thesis_name_2 = thesis_name_2;
	}

	public String getThesis_date_2() {
		return thesis_date_2;
	}

	public void setThesis_date_2(String thesis_date_2) {
		this.thesis_date_2 = thesis_date_2;
	}

	public String getThesis_sci_yn_2() {
		return thesis_sci_yn_2;
	}

	public void setThesis_sci_yn_2(String thesis_sci_yn_2) {
		this.thesis_sci_yn_2 = thesis_sci_yn_2;
	}

	public String getThesis_3() {
		return thesis_3;
	}

	public void setThesis_3(String thesis_3) {
		this.thesis_3 = thesis_3;
	}

	public String getThesis_name_3() {
		return thesis_name_3;
	}

	public void setThesis_name_3(String thesis_name_3) {
		this.thesis_name_3 = thesis_name_3;
	}

	public String getThesis_date_3() {
		return thesis_date_3;
	}

	public void setThesis_date_3(String thesis_date_3) {
		this.thesis_date_3 = thesis_date_3;
	}

	public String getThesis_sci_yn_3() {
		return thesis_sci_yn_3;
	}

	public void setThesis_sci_yn_3(String thesis_sci_yn_3) {
		this.thesis_sci_yn_3 = thesis_sci_yn_3;
	}

	public String getIprs_1() {
		return iprs_1;
	}

	public void setIprs_1(String iprs_1) {
		this.iprs_1 = iprs_1;
	}

	public String getIprs_enroll_1() {
		return iprs_enroll_1;
	}

	public void setIprs_enroll_1(String iprs_enroll_1) {
		this.iprs_enroll_1 = iprs_enroll_1;
	}

	public String getIprs_number_1() {
		return iprs_number_1;
	}

	public void setIprs_number_1(String iprs_number_1) {
		this.iprs_number_1 = iprs_number_1;
	}

	public String getIprs_name_1() {
		return iprs_name_1;
	}

	public void setIprs_name_1(String iprs_name_1) {
		this.iprs_name_1 = iprs_name_1;
	}

	public String getIprs_date_1() {
		return iprs_date_1;
	}

	public void setIprs_date_1(String iprs_date_1) {
		this.iprs_date_1 = iprs_date_1;
	}

	public String getIprs_2() {
		return iprs_2;
	}

	public void setIprs_2(String iprs_2) {
		this.iprs_2 = iprs_2;
	}

	public String getIprs_enroll_2() {
		return iprs_enroll_2;
	}

	public void setIprs_enroll_2(String iprs_enroll_2) {
		this.iprs_enroll_2 = iprs_enroll_2;
	}

	public String getIprs_number_2() {
		return iprs_number_2;
	}

	public void setIprs_number_2(String iprs_number_2) {
		this.iprs_number_2 = iprs_number_2;
	}

	public String getIprs_name_2() {
		return iprs_name_2;
	}

	public void setIprs_name_2(String iprs_name_2) {
		this.iprs_name_2 = iprs_name_2;
	}

	public String getIprs_date_2() {
		return iprs_date_2;
	}

	public void setIprs_date_2(String iprs_date_2) {
		this.iprs_date_2 = iprs_date_2;
	}

	public String getIprs_3() {
		return iprs_3;
	}

	public void setIprs_3(String iprs_3) {
		this.iprs_3 = iprs_3;
	}

	public String getIprs_enroll_3() {
		return iprs_enroll_3;
	}

	public void setIprs_enroll_3(String iprs_enroll_3) {
		this.iprs_enroll_3 = iprs_enroll_3;
	}

	public String getIprs_number_3() {
		return iprs_number_3;
	}

	public void setIprs_number_3(String iprs_number_3) {
		this.iprs_number_3 = iprs_number_3;
	}

	public String getIprs_name_3() {
		return iprs_name_3;
	}

	public void setIprs_name_3(String iprs_name_3) {
		this.iprs_name_3 = iprs_name_3;
	}

	public String getIprs_date_3() {
		return iprs_date_3;
	}

	public void setIprs_date_3(String iprs_date_3) {
		this.iprs_date_3 = iprs_date_3;
	}

	public String getTech_tran_name_1() {
		return tech_tran_name_1;
	}

	public void setTech_tran_name_1(String tech_tran_name_1) {
		this.tech_tran_name_1 = tech_tran_name_1;
	}

	public String getTech_tran_date_1() {
		return tech_tran_date_1;
	}

	public void setTech_tran_date_1(String tech_tran_date_1) {
		this.tech_tran_date_1 = tech_tran_date_1;
	}

	public String getTech_tran_company_1() {
		return tech_tran_company_1;
	}

	public void setTech_tran_company_1(String tech_tran_company_1) {
		this.tech_tran_company_1 = tech_tran_company_1;
	}

	public String getTech_tran_name_2() {
		return tech_tran_name_2;
	}

	public void setTech_tran_name_2(String tech_tran_name_2) {
		this.tech_tran_name_2 = tech_tran_name_2;
	}

	public String getTech_tran_date_2() {
		return tech_tran_date_2;
	}

	public void setTech_tran_date_2(String tech_tran_date_2) {
		this.tech_tran_date_2 = tech_tran_date_2;
	}

	public String getTech_tran_company_2() {
		return tech_tran_company_2;
	}

	public void setTech_tran_company_2(String tech_tran_company_2) {
		this.tech_tran_company_2 = tech_tran_company_2;
	}

	public String getTech_tran_name_3() {
		return tech_tran_name_3;
	}

	public void setTech_tran_name_3(String tech_tran_name_3) {
		this.tech_tran_name_3 = tech_tran_name_3;
	}

	public String getTech_tran_date_3() {
		return tech_tran_date_3;
	}

	public void setTech_tran_date_3(String tech_tran_date_3) {
		this.tech_tran_date_3 = tech_tran_date_3;
	}

	public String getTech_tran_company_3() {
		return tech_tran_company_3;
	}

	public void setTech_tran_company_3(String tech_tran_company_3) {
		this.tech_tran_company_3 = tech_tran_company_3;
	}

	public String getRnd_name_1() {
		return rnd_name_1;
	}

	public void setRnd_name_1(String rnd_name_1) {
		this.rnd_name_1 = rnd_name_1;
	}

	public String getRnd_date_start_1() {
		return rnd_date_start_1;
	}

	public void setRnd_date_start_1(String rnd_date_start_1) {
		this.rnd_date_start_1 = rnd_date_start_1;
	}

	public String getRnd_date_end_1() {
		return rnd_date_end_1;
	}

	public void setRnd_date_end_1(String rnd_date_end_1) {
		this.rnd_date_end_1 = rnd_date_end_1;
	}

	public String getRnd_class_1() {
		return rnd_class_1;
	}

	public void setRnd_class_1(String rnd_class_1) {
		this.rnd_class_1 = rnd_class_1;
	}

	public String getRnd_4th_industry_1() {
		return rnd_4th_industry_1;
	}

	public void setRnd_4th_industry_1(String rnd_4th_industry_1) {
		this.rnd_4th_industry_1 = rnd_4th_industry_1;
	}

	public String getRnd_name_2() {
		return rnd_name_2;
	}

	public void setRnd_name_2(String rnd_name_2) {
		this.rnd_name_2 = rnd_name_2;
	}

	public String getRnd_date_start_2() {
		return rnd_date_start_2;
	}

	public void setRnd_date_start_2(String rnd_date_start_2) {
		this.rnd_date_start_2 = rnd_date_start_2;
	}

	public String getRnd_date_end_2() {
		return rnd_date_end_2;
	}

	public void setRnd_date_end_2(String rnd_date_end_2) {
		this.rnd_date_end_2 = rnd_date_end_2;
	}

	public String getRnd_class_2() {
		return rnd_class_2;
	}

	public void setRnd_class_2(String rnd_class_2) {
		this.rnd_class_2 = rnd_class_2;
	}

	public String getRnd_4th_industry_2() {
		return rnd_4th_industry_2;
	}

	public void setRnd_4th_industry_2(String rnd_4th_industry_2) {
		this.rnd_4th_industry_2 = rnd_4th_industry_2;
	}

	public String getRnd_name_3() {
		return rnd_name_3;
	}

	public void setRnd_name_3(String rnd_name_3) {
		this.rnd_name_3 = rnd_name_3;
	}

	public String getRnd_date_start_3() {
		return rnd_date_start_3;
	}

	public void setRnd_date_start_3(String rnd_date_start_3) {
		this.rnd_date_start_3 = rnd_date_start_3;
	}

	public String getRnd_date_end_3() {
		return rnd_date_end_3;
	}

	public void setRnd_date_end_3(String rnd_date_end_3) {
		this.rnd_date_end_3 = rnd_date_end_3;
	}

	public String getRnd_class_3() {
		return rnd_class_3;
	}

	public void setRnd_class_3(String rnd_class_3) {
		this.rnd_class_3 = rnd_class_3;
	}

	public String getRnd_4th_industry_3() {
		return rnd_4th_industry_3;
	}

	public void setRnd_4th_industry_3(String rnd_4th_industry_3) {
		this.rnd_4th_industry_3 = rnd_4th_industry_3;
	}

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}

	public String getCurrent_pwd() {
		return current_pwd;
	}

	public void setCurrent_pwd(String current_pwd) {
		this.current_pwd = current_pwd;
	}

	public String getNew_pwd() {
		return new_pwd;
	}

	public void setNew_pwd(String new_pwd) {
		this.new_pwd = new_pwd;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
