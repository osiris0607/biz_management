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
public class AgreementSearchVO {

	private static final long serialVersionUID = 1L;

	private int agreement_id;
	private int evaluation_id;
	private int reception_id;
	private String agreement_reg_number = "";

	// 평가상태
	private String agreement_status;
	// 검색어
	private String search_text;
	// 검색기간 : From
	private String evaluation_from;
	// 검색기간 : to
	private String evaluation_to;
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
	public String getAgreement_status() {
		return agreement_status;
	}
	public void setAgreement_status(String agreement_status) {
		this.agreement_status = agreement_status;
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
	public String getEvaluation_from() {
		return evaluation_from;
	}
	public void setEvaluation_from(String evaluation_from) {
		this.evaluation_from = evaluation_from;
	}
	public String getEvaluation_to() {
		return evaluation_to;
	}
	public void setEvaluation_to(String evaluation_to) {
		this.evaluation_to = evaluation_to;
	}
	public int getEvaluation_id() {
		return evaluation_id;
	}
	public void setEvaluation_id(int evaluation_id) {
		this.evaluation_id = evaluation_id;
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
