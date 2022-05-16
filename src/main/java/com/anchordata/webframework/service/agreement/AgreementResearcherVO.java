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
package com.anchordata.webframework.service.agreement;

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
public class AgreementResearcherVO {
	private static final long serialVersionUID = 1L;

	private int researcher_id;
	private int agreement_id;
	private String researcher_gubun = "";
	private String institution_gubun = "";
	private String institution_name	 = "";
	private String institution_department = "";
	private String institution_position = "";
	private String name = "";
	private String birth = "";
	private String hand_phone = "";
	private String email = "";
	private String participation_rate = "";
	private String participation_from_date = "";
	private String participation_tod_date = "";
	private String role = "";
	
	
	
	public int getAgreement_id() {
		return agreement_id;
	}
	public void setAgreement_id(int agreement_id) {
		this.agreement_id = agreement_id;
	}
	public String getInstitution_name() {
		return institution_name;
	}
	public void setInstitution_name(String institution_name) {
		this.institution_name = institution_name;
	}
	public int getResearcher_id() {
		return researcher_id;
	}
	public void setResearcher_id(int researcher_id) {
		this.researcher_id = researcher_id;
	}
	public String getResearcher_gubun() {
		return researcher_gubun;
	}
	public void setResearcher_gubun(String researcher_gubun) {
		this.researcher_gubun = researcher_gubun;
	}
	public String getInstitution_gubun() {
		return institution_gubun;
	}
	public void setInstitution_gubun(String institution_gubun) {
		this.institution_gubun = institution_gubun;
	}
	public String getInstitution_department() {
		return institution_department;
	}
	public void setInstitution_department(String institution_department) {
		this.institution_department = institution_department;
	}
	public String getInstitution_position() {
		return institution_position;
	}
	public void setInstitution_position(String institution_position) {
		this.institution_position = institution_position;
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
	public String getHand_phone() {
		return hand_phone;
	}
	public void setHand_phone(String hand_phone) {
		this.hand_phone = hand_phone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getParticipation_rate() {
		return participation_rate;
	}
	public void setParticipation_rate(String participation_rate) {
		this.participation_rate = participation_rate;
	}
	public String getParticipation_from_date() {
		return participation_from_date;
	}
	public void setParticipation_from_date(String participation_from_date) {
		this.participation_from_date = participation_from_date;
	}
	public String getParticipation_tod_date() {
		return participation_tod_date;
	}
	public void setParticipation_tod_date(String participation_tod_date) {
		this.participation_tod_date = participation_tod_date;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
