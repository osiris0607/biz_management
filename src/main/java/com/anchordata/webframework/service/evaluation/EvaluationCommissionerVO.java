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
package com.anchordata.webframework.service.evaluation;



import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;

import com.anchordata.webframework.service.member.CommissionerEvaluationItemVO.ItemResultInfo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class EvaluationCommissionerVO {
	
	private static final long serialVersionUID = 1L;

	private int relation_id;
	private int evaluation_id;
	private String evaluation_reg_number = "";
	private String member_id = "";
	private String choice_yn = "";
	private String mail_reply_yn = "";
	private String mail_send_date = "";
	
	// 조회 결과
	private String mobile_phone = "";
	private String email = "";
	private String institution_type_name = "";
	private String national_skill_large = "";
	private String rnd_class = "";
	private String member_name = "";
	private String institution_name = "";
	private String chairman_yn = "";
	private String security_declaration_yn = "";
	private String security_declaration_date = "";
	private String security_declaration_sign;
	private String payment_declaration_yn = "";
	private String payment_declaration_sign;
	private String evaluation_report_yn = "";
	private String evaluation_report_declaration_sign;
	private String total_point = "";
	
	private String chairman_result = "";
	private String chairman_comment = "";
	private String chairman_sign = "";
	private String chairman_submit_yn;
	
	
	// evaluation 조회 값
	private String announcement_title = "";
	private String announcement_type_name = "";
	private String steward_department = "";
	private String steward = "";
	private String type_name = "";
	private String evaluation_date = "";
	
	
	// 평가위원 ID 리스트
	private List<String> commissioner_relation_list;
	// 평가위원 평가점수 리스트
	private List<ItemResultInfo> commissioner_item_result_list;
	
	
	// paging List Index
	private String pageIndex;
	// Paging List Order by
	private String orderby;
	private String page_row_count = "";
	
	
	
	public String getChairman_result() {
		return chairman_result;
	}
	public void setChairman_result(String chairman_result) {
		this.chairman_result = chairman_result;
	}
	public String getChairman_comment() {
		return chairman_comment;
	}
	public void setChairman_comment(String chairman_comment) {
		this.chairman_comment = chairman_comment;
	}
	public String getChairman_sign() {
		return chairman_sign;
	}
	public void setChairman_sign(String chairman_sign) {
		this.chairman_sign = chairman_sign;
	}
	public String getChairman_submit_yn() {
		return chairman_submit_yn;
	}
	public void setChairman_submit_yn(String chairman_submit_yn) {
		this.chairman_submit_yn = chairman_submit_yn;
	}
	public List<ItemResultInfo> getCommissioner_item_result_list() {
		return commissioner_item_result_list;
	}
	public void setCommissioner_item_result_list(List<ItemResultInfo> commissioner_item_result_list) {
		this.commissioner_item_result_list = commissioner_item_result_list;
	}
	public String getTotal_point() {
		return total_point;
	}
	public void setTotal_point(String total_point) {
		this.total_point = total_point;
	}
	public String getEvaluation_report_declaration_sign() {
		return evaluation_report_declaration_sign;
	}
	public void setEvaluation_report_declaration_sign(String evaluation_report_declaration_sign) {
		this.evaluation_report_declaration_sign = evaluation_report_declaration_sign;
	}
	public String getSecurity_declaration_sign() {
		return security_declaration_sign;
	}
	public void setSecurity_declaration_sign(String security_declaration_sign) {
		this.security_declaration_sign = security_declaration_sign;
	}
	public String getPayment_declaration_sign() {
		return payment_declaration_sign;
	}
	public void setPayment_declaration_sign(String payment_declaration_sign) {
		this.payment_declaration_sign = payment_declaration_sign;
	}
	public String getSecurity_declaration_date() {
		return security_declaration_date;
	}
	public void setSecurity_declaration_date(String security_declaration_date) {
		this.security_declaration_date = security_declaration_date;
	}
	public String getAnnouncement_type_name() {
		return announcement_type_name;
	}
	public void setAnnouncement_type_name(String announcement_type_name) {
		this.announcement_type_name = announcement_type_name;
	}
	public String getAnnouncement_title() {
		return announcement_title;
	}
	public void setAnnouncement_title(String announcement_title) {
		this.announcement_title = announcement_title;
	}
	public String getSteward_department() {
		return steward_department;
	}
	public void setSteward_department(String steward_department) {
		this.steward_department = steward_department;
	}
	public String getSteward() {
		return steward;
	}
	public void setSteward(String steward) {
		this.steward = steward;
	}
	public String getType_name() {
		return type_name;
	}
	public void setType_name(String type_name) {
		this.type_name = type_name;
	}
	public String getEvaluation_date() {
		return evaluation_date;
	}
	public void setEvaluation_date(String evaluation_date) {
		this.evaluation_date = evaluation_date;
	}
	public String getEvaluation_report_yn() {
		return evaluation_report_yn;
	}
	public void setEvaluation_report_yn(String evaluation_report_yn) {
		this.evaluation_report_yn = evaluation_report_yn;
	}
	public String getSecurity_declaration_yn() {
		return security_declaration_yn;
	}
	public void setSecurity_declaration_yn(String security_declaration_yn) {
		this.security_declaration_yn = security_declaration_yn;
	}
	public String getPayment_declaration_yn() {
		return payment_declaration_yn;
	}
	public void setPayment_declaration_yn(String payment_declaration_yn) {
		this.payment_declaration_yn = payment_declaration_yn;
	}
	public int getEvaluation_id() {
		return evaluation_id;
	}
	public void setEvaluation_id(int evaluation_id) {
		this.evaluation_id = evaluation_id;
	}
	public String getChairman_yn() {
		return chairman_yn;
	}
	public void setChairman_yn(String chairman_yn) {
		this.chairman_yn = chairman_yn;
	}
	public List<String> getCommissioner_relation_list() {
		return commissioner_relation_list;
	}
	public void setCommissioner_relation_list(List<String> commissioner_relation_list) {
		this.commissioner_relation_list = commissioner_relation_list;
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
	public String getPage_row_count() {
		return page_row_count;
	}
	public void setPage_row_count(String page_row_count) {
		this.page_row_count = page_row_count;
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
	public String getInstitution_type_name() {
		return institution_type_name;
	}
	public void setInstitution_type_name(String institution_type_name) {
		this.institution_type_name = institution_type_name;
	}
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
	public String getMember_name() {
		return member_name;
	}
	public void setMember_name(String member_name) {
		this.member_name = member_name;
	}
	public String getInstitution_name() {
		return institution_name;
	}
	public void setInstitution_name(String institution_name) {
		this.institution_name = institution_name;
	}
	public String getEvaluation_reg_number() {
		return evaluation_reg_number;
	}
	public void setEvaluation_reg_number(String evaluation_reg_number) {
		this.evaluation_reg_number = evaluation_reg_number;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getChoice_yn() {
		return choice_yn;
	}
	public void setChoice_yn(String choice_yn) {
		this.choice_yn = choice_yn;
	}
	public String getMail_reply_yn() {
		return mail_reply_yn;
	}
	public void setMail_reply_yn(String mail_reply_yn) {
		this.mail_reply_yn = mail_reply_yn;
	}
	public String getMail_send_date() {
		return mail_send_date;
	}
	public void setMail_send_date(String mail_send_date) {
		this.mail_send_date = mail_send_date;
	}
	public int getRelation_id() {
		return relation_id;
	}
	public void setRelation_id(int evaluation_id) {
		this.relation_id = evaluation_id;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
