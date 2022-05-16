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

public class ManagerSearchVO {
	private static final long serialVersionUID = 1L;
	
	
	private String member_id = "";
	private String department = "";
	private String name = "";
	private String research_manager_yn = "";
	private String evaluation_manager_yn = "";
	private String auth_level_admin = "";
	private String auth_level_manager = "";
	
	
	
	// paging List Index
	private String pageIndex;
	// Paging List Order by
	private String orderby;
	
	
	private int total_count;
	private int result;
	
	
	
	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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
