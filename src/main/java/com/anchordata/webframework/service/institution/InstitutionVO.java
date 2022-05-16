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
package com.anchordata.webframework.service.institution;


import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class InstitutionVO {

	private static final long serialVersionUID = 1L;

	private int institution_id;
	private String member_id = "";
	private String type = "";
	private String type_name = "";
	private String reg_no = "";
	private String name = "";
	private String address = "";
	private String address_detail = "";
	private String phone = "";
	private String representative_name = "";
	private String industry_type = "";
	private String business_type = "";
	private String foundation_date = "";
	private String foundation_type = "";
	private String company_class = "";
	private String company_type = "";
	private String lab_exist_yn = "";
	private int employee_no;
	private long total_sales;
	private long capital_1;
	private long capital_2;
	private long capital_3;
	private String use_yn = "";
	private String reg_date = "";
	
	// 대표자 정보
	// reg_no / name 은 공통
	// 기타
	private int representative_id;
	private String mobile_phone = "";
	private String email = "";
	private List<Integer> delete_representative_id_list;
	
	// Member의 직책 및 직급
	// Member table에 업데이트 한다.
	private String department = "";
	private String position = "";
	
	private int total_count;



	public long getTotal_sales() {
		return total_sales;
	}

	public void setTotal_sales(long total_sales) {
		this.total_sales = total_sales;
	}

	public long getCapital_1() {
		return capital_1;
	}

	public void setCapital_1(long capital_1) {
		this.capital_1 = capital_1;
	}

	public long getCapital_2() {
		return capital_2;
	}

	public void setCapital_2(long capital_2) {
		this.capital_2 = capital_2;
	}

	public long getCapital_3() {
		return capital_3;
	}

	public void setCapital_3(long capital_3) {
		this.capital_3 = capital_3;
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

	public String getType_name() {
		return type_name;
	}

	public void setType_name(String type_name) {
		this.type_name = type_name;
	}

	public List<Integer> getDelete_representative_id_list() {
		return delete_representative_id_list;
	}

	public void setDelete_representative_id_list(List<Integer> delete_representative_id_list) {
		this.delete_representative_id_list = delete_representative_id_list;
	}

	public int getRepresentative_id() {
		return representative_id;
	}

	public void setRepresentative_id(int representative_id) {
		this.representative_id = representative_id;
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
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public int getInstitution_id() {
		return institution_id;
	}
	public void setInstitution_id(int institution_id) {
		this.institution_id = institution_id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getReg_no() {
		return reg_no;
	}

	public void setReg_no(String reg_no) {
		this.reg_no = reg_no;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getAddress_detail() {
		return address_detail;
	}

	public void setAddress_detail(String address_detail) {
		this.address_detail = address_detail;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getRepresentative_name() {
		return representative_name;
	}

	public void setRepresentative_name(String representative_name) {
		this.representative_name = representative_name;
	}

	public String getIndustry_type() {
		return industry_type;
	}

	public void setIndustry_type(String industry_type) {
		this.industry_type = industry_type;
	}

	public String getBusiness_type() {
		return business_type;
	}

	public void setBusiness_type(String business_type) {
		this.business_type = business_type;
	}

	public String getFoundation_date() {
		return foundation_date;
	}

	public void setFoundation_date(String foundation_date) {
		this.foundation_date = foundation_date;
	}

	public String getFoundation_type() {
		return foundation_type;
	}

	public void setFoundation_type(String foundation_type) {
		this.foundation_type = foundation_type;
	}

	public String getCompany_class() {
		return company_class;
	}

	public void setCompany_class(String company_class) {
		this.company_class = company_class;
	}

	public String getCompany_type() {
		return company_type;
	}

	public void setCompany_type(String company_type) {
		this.company_type = company_type;
	}

	public String getLab_exist_yn() {
		return lab_exist_yn;
	}

	public void setLab_exist_yn(String lab_exist_yn) {
		this.lab_exist_yn = lab_exist_yn;
	}

	public int getEmployee_no() {
		return employee_no;
	}

	public void setEmployee_no(int employee_no) {
		this.employee_no = employee_no;
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
