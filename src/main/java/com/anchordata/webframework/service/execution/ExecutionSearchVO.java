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
package com.anchordata.webframework.service.execution;


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
public class ExecutionSearchVO {

	private static final long serialVersionUID = 1L;

	private int execution_id;
	private int agreement_id;
	private int reception_id;
	private String agreement_reg_number = "";
	

	// 평가상태
	private String execution_status;
	// 검색어
	private String search_text;
	// 검색기간 : From
	private String execution_from;
	// 검색기간 : to
	private String execution_to;
	// 아이디별 조회
	private String member_id = "";
	// research_date
	private String research_date = "";
	// 공고 타입
	private String announcement_type = "";

	// paging List Index
	private String pageIndex;
	// Paging List Order by
	private String orderby;
	
	
	private int total_count;
	private int result;
	
	
	
	
	public String getAnnouncement_type() {
		return announcement_type;
	}
	public void setAnnouncement_type(String announcement_type) {
		this.announcement_type = announcement_type;
	}
	public String getResearch_date() {
		return research_date;
	}
	public void setResearch_date(String research_date) {
		this.research_date = research_date;
	}
	public String getExecution_from() {
		return execution_from;
	}
	public void setExecution_from(String execution_from) {
		this.execution_from = execution_from;
	}
	public String getExecution_to() {
		return execution_to;
	}
	public void setExecution_to(String execution_to) {
		this.execution_to = execution_to;
	}
	public int getExecution_id() {
		return execution_id;
	}
	public void setExecution_id(int execution_id) {
		this.execution_id = execution_id;
	}
	public String getExecution_status() {
		return execution_status;
	}
	public void setExecution_status(String execution_status) {
		this.execution_status = execution_status;
	}
	public int getAgreement_id() {
		return agreement_id;
	}
	public void setAgreement_id(int agreement_id) {
		this.agreement_id = agreement_id;
	}
	public String getAgreement_reg_number() {
		return agreement_reg_number;
	}
	public void setAgreement_reg_number(String agreement_reg_number) {
		this.agreement_reg_number = agreement_reg_number;
	}
	public String getSearch_text() {
		return search_text;
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
	public void setSearch_text(String search_text) {
		this.search_text = search_text;
	}
	public int getReception_id() {
		return reception_id;
	}
	public void setReception_id(int reception_id) {
		this.reception_id = reception_id;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
