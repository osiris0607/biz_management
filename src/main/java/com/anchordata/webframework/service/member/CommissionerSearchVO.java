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

public class CommissionerSearchVO {
	private static final long serialVersionUID = 1L;
	
	
	private String member_id = "";
	private String commissioner_status = "";
	private String name = "";
	private String update_date = "";
	private String institution_type = "";
	private String institution_name = "";
	private String rnd_class = "";
	private String national_skill_large = "";
	
	
	private String page_row_count = "";
	
	
	
	// paging List Index
	private String pageIndex;
	// Paging List Order by
	private String orderby;
	
	
	private int total_count;
	private int result;
	
	
	public String getNational_skill_large() {
		return national_skill_large;
	}

	public void setNational_skill_large(String national_skill_large) {
		this.national_skill_large = national_skill_large;
	}

	public String getRnd_class() {
		return rnd_class;
	}

	public void setRnd_class(String rnd_class) {
		this.rnd_class = rnd_class;
	}

	public String getPage_row_count() {
		return page_row_count;
	}

	public void setPage_row_count(String page_row_count) {
		this.page_row_count = page_row_count;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getCommissioner_status() {
		return commissioner_status;
	}

	public void setCommissioner_status(String commissioner_status) {
		this.commissioner_status = commissioner_status;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUpdate_date() {
		return update_date;
	}

	public void setUpdate_date(String update_date) {
		this.update_date = update_date;
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
