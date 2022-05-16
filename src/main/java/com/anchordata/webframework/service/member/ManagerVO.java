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

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class ManagerVO {

	private static final long serialVersionUID = 1L;

	// member table
	private String member_id = "";
	private String name = "";
	private String pwd = "";
	private String mobile_phone = "";
	private String email = "";
	private String department = "";
	private String position = "";
	private String auth_level_admin = "";
	private String auth_level_manager = "";
	private String login_date = "";
	private String reg_date = "";
	// 내부평가위원으로 D0000007 로 정의한다.
	// 평가위원 검색 및 조회 시에 필요하다.
	private String institution_type = "";
	
	
	// manager table
	private String research_manager_yn = "";
	private String evaluation_manager_yn = "";
	private String auth_announcement_menu_yn = "";
	private String auth_reception_menu_yn = ""; 
	private String auth_evaluation_menu_yn = "";
	private String auth_execution_menu_yn = "";
	private String auth_agreement_menu_yn = "";
	private String auth_calculate_menu_yn = "";
	private String auth_notice_menu_yn = "";
	
	private List<String> history;
	
	private int total_count;
	
	
	// 관리자들의 권한 변경
	private String manager_auth_list_json = "";
	private List<ManagerAuthVO> manager_auth_list;
	
	

	
	public String getInstitution_type() {
		return institution_type;
	}

	public void setInstitution_type(String institution_type) {
		this.institution_type = institution_type;
	}

	public String getManager_auth_list_json() {
		return manager_auth_list_json;
	}

	public void setManager_auth_list_json(String manager_auth_list_json) {
		String tempJsonData = manager_auth_list_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			manager_auth_list = Arrays.asList(mapper.readValue(tempJsonData, ManagerAuthVO[].class));
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
		
		this.manager_auth_list_json = manager_auth_list_json;
	}

	public List<ManagerAuthVO> getManager_auth_list() {
		return manager_auth_list;
	}

	public void setManager_auth_list(List<ManagerAuthVO> manager_auth_list) {
		this.manager_auth_list = manager_auth_list;
	}

	public List<String> getHistory() {
		return history;
	}

	public void setHistory(List<String> history) {
		this.history = history;
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

	public String getAuth_announcement_menu_yn() {
		return auth_announcement_menu_yn;
	}

	public void setAuth_announcement_menu_yn(String auth_announcement_menu_yn) {
		this.auth_announcement_menu_yn = auth_announcement_menu_yn;
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

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
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

	public String getResearch_manager_yn() {
		return research_manager_yn;
	}

	public void setResearch_manager_yn(String research_manager_yn) {
		this.research_manager_yn = research_manager_yn;
	}

	public String getEvaluation_manager_yn() {
		return evaluation_manager_yn;
	}

	public void setEvaluation_manager_yn(String evaluation_manager_yn) {
		this.evaluation_manager_yn = evaluation_manager_yn;
	}

	public String getAuth_reception_menu_yn() {
		return auth_reception_menu_yn;
	}

	public void setAuth_reception_menu_yn(String auth_reception_menu_yn) {
		this.auth_reception_menu_yn = auth_reception_menu_yn;
	}

	public String getAuth_evaluation_menu_yn() {
		return auth_evaluation_menu_yn;
	}

	public void setAuth_evaluation_menu_yn(String auth_evaluation_menu_yn) {
		this.auth_evaluation_menu_yn = auth_evaluation_menu_yn;
	}

	public String getAuth_execution_menu_yn() {
		return auth_execution_menu_yn;
	}

	public void setAuth_execution_menu_yn(String auth_execution_menu_yn) {
		this.auth_execution_menu_yn = auth_execution_menu_yn;
	}

	public String getAuth_agreement_menu_yn() {
		return auth_agreement_menu_yn;
	}

	public void setAuth_agreement_menu_yn(String auth_agreement_menu_yn) {
		this.auth_agreement_menu_yn = auth_agreement_menu_yn;
	}

	public String getAuth_calculate_menu_yn() {
		return auth_calculate_menu_yn;
	}

	public void setAuth_calculate_menu_yn(String auth_calculate_menu_yn) {
		this.auth_calculate_menu_yn = auth_calculate_menu_yn;
	}

	public String getAuth_notice_menu_yn() {
		return auth_notice_menu_yn;
	}

	public void setAuth_notice_menu_yn(String auth_notice_menu_yn) {
		this.auth_notice_menu_yn = auth_notice_menu_yn;
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
