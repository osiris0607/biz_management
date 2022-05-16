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


public class ReceptionExpertVO {

	private static final long serialVersionUID = 1L;
	private int expert_id;
	private int reception_id;
	private String member_id = "";
	private String national_science = "";
	private String research = "";
	private String name = "";
	private String institution_name = "";
	private String institution_department = "";
	private String mobile_phone = "";
	private String email = "";
	private String participation_type = "";
	private String participation_name = "";
	private String choiced_yn = "";
	private String priority = "";
	
	
	
	public String getParticipation_name() {
		return participation_name;
	}
	public void setParticipation_name(String participation_name) {
		this.participation_name = participation_name;
	}
	public String getChoiced_yn() {
		return choiced_yn;
	}
	public void setChoiced_yn(String choiced_yn) {
		this.choiced_yn = choiced_yn;
	}
	public String getPriority() {
		return priority;
	}
	public void setPriority(String priority) {
		this.priority = priority;
	}
	public String getParticipation_type() {
		return participation_type;
	}
	public void setParticipation_type(String participation_type) {
		this.participation_type = participation_type;
	}
	public int getExpert_id() {
		return expert_id;
	}
	public void setExpert_id(int expert_id) {
		this.expert_id = expert_id;
	}
	public int getReception_id() {
		return reception_id;
	}
	public void setReception_id(int reception_id) {
		this.reception_id = reception_id;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getNational_science() {
		return national_science;
	}
	public void setNational_science(String national_science) {
		this.national_science = national_science;
	}
	public String getResearch() {
		return research;
	}
	public void setResearch(String research) {
		this.research = research;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getInstitution_name() {
		return institution_name;
	}
	public void setInstitution_name(String institution_name) {
		this.institution_name = institution_name;
	}
	public String getInstitution_department() {
		return institution_department;
	}
	public void setInstitution_department(String institution_department) {
		this.institution_department = institution_department;
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
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
}
