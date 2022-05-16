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


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class ManagerAuthVO {

	private static final long serialVersionUID = 1L;

	// member table
	private String member_id = "";
	
	
	// manager table
	private String auth_announcement_menu_yn = "";
	private String auth_reception_menu_yn = ""; 
	private String auth_evaluation_menu_yn = "";
	private String auth_execution_menu_yn = "";
	private String auth_agreement_menu_yn = "";
	private String auth_calculate_menu_yn = "";
	private String auth_notice_menu_yn = "";
	

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getAuth_announcement_menu_yn() {
		return auth_announcement_menu_yn;
	}

	public void setAuth_announcement_menu_yn(String auth_announcement_menu_yn) {
		this.auth_announcement_menu_yn = auth_announcement_menu_yn;
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

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
