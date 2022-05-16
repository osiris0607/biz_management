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
package com.anchordata.webframework.service.calculation;


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
public class CalculationSearchVO {

	private static final long serialVersionUID = 1L;

	private int calculation_id;
	private int agreement_id;
	private int reception_id;
	private String announcement_type;
	
	// 정산상태
	private String calculation_status;
	// 평가상태
	private String execution_status;
	// 검색어
	private String search_text;
	// 아이디별 조회
	private String member_id = "";
	// research_date
	private String research_date = "";
	// 공고 이름
	private String announcement_title = "";
	// 기술명
	private String tech_info_name = "";
	// 연구기관
	private String institution_name = "";
	// 과제번호
	private String agreement_reg_number = "";

	
	// paging List Index
	private String pageIndex;
	// Paging List Order by
	private String orderby;
	
	
	private int total_count;
	private int result;
	
	
	
	
	public int getCalculation_id() {
		return calculation_id;
	}
	public void setCalculation_id(int calculation_id) {
		this.calculation_id = calculation_id;
	}
	public String getCalculation_status() {
		return calculation_status;
	}
	public void setCalculation_status(String calculation_status) {
		this.calculation_status = calculation_status;
	}
	public String getAnnouncement_title() {
		return announcement_title;
	}
	public void setAnnouncement_title(String announcement_title) {
		this.announcement_title = announcement_title;
	}
	public String getTech_info_name() {
		return tech_info_name;
	}
	public void setTech_info_name(String tech_info_name) {
		this.tech_info_name = tech_info_name;
	}
	public String getInstitution_name() {
		return institution_name;
	}
	public void setInstitution_name(String institution_name) {
		this.institution_name = institution_name;
	}
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
