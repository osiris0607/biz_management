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

public class ReceptionSearchVO {

	private static final long serialVersionUID = 1L;
	
	private String member_id = "";
	private String announcement_type = "";
	private String announcement_name = "";
	private String reception_from_date = "";
	private String reception_to_date = "";
	private String institution_name = "";
	private String reception_reg_number = "";
	private String reception_status = "";
	private String search_text = "";
	
	
	private String reception_expert_status1 = "";	// 매칭중, 수행중, 참여완료
	private String reception_expert_status2 = "";	// 참여, 미참여, 미회신, 미선정
	
	// paging List Index
	private String pageIndex;
	// Paging List Order by
	private String orderby;
	
	private int total_count;
	private int result;
	
	
	public String getReception_expert_status1() {
		return reception_expert_status1;
	}
	public void setReception_expert_status1(String reception_expert_status1) {
		this.reception_expert_status1 = reception_expert_status1;
	}
	public String getReception_expert_status2() {
		return reception_expert_status2;
	}
	public void setReception_expert_status2(String reception_expert_status2) {
		this.reception_expert_status2 = reception_expert_status2;
	}
	public String getSearch_text() {
		return search_text;
	}
	public void setSearch_text(String search_text) {
		this.search_text = search_text;
	}
	public String getAnnouncement_name() {
		return announcement_name;
	}
	public void setAnnouncement_name(String announcement_name) {
		this.announcement_name = announcement_name;
	}
	public String getReception_from_date() {
		return reception_from_date;
	}
	public void setReception_from_date(String reception_from_date) {
		this.reception_from_date = reception_from_date;
	}
	public String getReception_to_date() {
		return reception_to_date;
	}
	public void setReception_to_date(String reception_to_date) {
		this.reception_to_date = reception_to_date;
	}
	public String getInstitution_name() {
		return institution_name;
	}
	public void setInstitution_name(String institution_name) {
		this.institution_name = institution_name;
	}
	public String getReception_reg_number() {
		return reception_reg_number;
	}
	public void setReception_reg_number(String reception_reg_number) {
		this.reception_reg_number = reception_reg_number;
	}
	public String getReception_status() {
		return reception_status;
	}
	public void setReception_status(String reception_status) {
		this.reception_status = reception_status;
	}
	public String getAnnouncement_type() {
		return announcement_type;
	}
	public void setAnnouncement_type(String announcement_type) {
		this.announcement_type = announcement_type;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getPageIndex() {
		return pageIndex;
	}
	public void setPageIndex(String pageIndex) {
		this.pageIndex = pageIndex;
	}
	public String getOrderby() {
		return orderby;
	}
	public void setOrderby(String orderby) {
		this.orderby = orderby;
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
