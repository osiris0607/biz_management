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

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class CalculationVO {
	private static final long serialVersionUID = 1L;

	private int calculation_id;
	private int reception_id;
	private int agreement_id;
	private String calculation_status = "";
	private int document_file_id;
	private String document_file_name;
	private int report_file_id;
	private String report_file_name;
	private String support_fund;
	private String cash;
	private String hyeonmul;
	private String total_cost;
	private String reception_reg_number = "";
	private String agreement_reg_number = "";
	private String research_date = "";
	private String research_funds = "";
	private String announcement_type = "";
	private String announcement_business_name = "";
	private String announcement_title = "";
	private String tech_info_name = "";
	private String institution_name = "";
	private String researcher_name = "";
	private String member_id = "";
	private String changes_count = "";
	private String execution_id = "";
	
	private String use_yn = "";
	private String reg_date = "";
	private String total_count = "";
	
	
	@JsonIgnore
	private MultipartFile document_file;
	@JsonIgnore
	private MultipartFile report_file;
	
	private List<CalculationFundDetailVO> fund_detail_list;
	private String fund_detail_list_json = "";
	
	
	private List<String> activate_calculation_id_list;
	
	
	public List<String> getActivate_calculation_id_list() {
		return activate_calculation_id_list;
	}
	public void setActivate_calculation_id_list(List<String> activate_calculation_id_list) {
		this.activate_calculation_id_list = activate_calculation_id_list;
	}
	public String getCash() {
		return cash;
	}
	public void setCash(String cash) {
		this.cash = cash;
	}
	public List<CalculationFundDetailVO> getFund_detail_list() {
		return fund_detail_list;
	}
	public void setFund_detail_list(List<CalculationFundDetailVO> fund_detail_list) {
		this.fund_detail_list = fund_detail_list;
	}
	public String getFund_detail_list_json() {
		return fund_detail_list_json;
	}
	public void setFund_detail_list_json(String fund_detail_list_json) {
		String tempJsonData = fund_detail_list_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			fund_detail_list = Arrays.asList(mapper.readValue(tempJsonData, CalculationFundDetailVO[].class));
		} catch (JsonParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		this.fund_detail_list_json = fund_detail_list_json;
	}
	public String getExecution_id() {
		return execution_id;
	}
	public void setExecution_id(String execution_id) {
		this.execution_id = execution_id;
	}
	public int getCalculation_id() {
		return calculation_id;
	}
	public void setCalculation_id(int calculation_id) {
		this.calculation_id = calculation_id;
	}
	public int getReception_id() {
		return reception_id;
	}
	public void setReception_id(int reception_id) {
		this.reception_id = reception_id;
	}
	public int getAgreement_id() {
		return agreement_id;
	}
	public void setAgreement_id(int agreement_id) {
		this.agreement_id = agreement_id;
	}
	public String getCalculation_status() {
		return calculation_status;
	}
	public void setCalculation_status(String calculation_status) {
		this.calculation_status = calculation_status;
	}
	public int getDocument_file_id() {
		return document_file_id;
	}
	public void setDocument_file_id(int document_file_id) {
		this.document_file_id = document_file_id;
	}
	public String getDocument_file_name() {
		return document_file_name;
	}
	public void setDocument_file_name(String document_file_name) {
		this.document_file_name = document_file_name;
	}
	public int getReport_file_id() {
		return report_file_id;
	}
	public void setReport_file_id(int report_file_id) {
		this.report_file_id = report_file_id;
	}
	public String getReport_file_name() {
		return report_file_name;
	}
	public void setReport_file_name(String report_file_name) {
		this.report_file_name = report_file_name;
	}
	public String getSupport_fund() {
		return support_fund;
	}
	public void setSupport_fund(String support_fund) {
		this.support_fund = support_fund;
	}
	public String getHyeonmul() {
		return hyeonmul;
	}
	public void setHyeonmul(String hyeonmul) {
		this.hyeonmul = hyeonmul;
	}
	public String getTotal_cost() {
		return total_cost;
	}
	public void setTotal_cost(String total_cost) {
		this.total_cost = total_cost;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public MultipartFile getDocument_file() {
		return document_file;
	}
	public void setDocument_file(MultipartFile document_file) {
		this.document_file = document_file;
	}
	public MultipartFile getReport_file() {
		return report_file;
	}
	public void setReport_file(MultipartFile report_file) {
		this.report_file = report_file;
	}
	public String getTotal_count() {
		return total_count;
	}
	public void setTotal_count(String total_count) {
		this.total_count = total_count;
	}
	public String getChanges_count() {
		return changes_count;
	}
	public void setChanges_count(String changes_count) {
		this.changes_count = changes_count;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getResearch_funds() {
		return research_funds;
	}
	public void setResearch_funds(String research_funds) {
		this.research_funds = research_funds;
	}
	public String getReception_reg_number() {
		return reception_reg_number;
	}
	public void setReception_reg_number(String reception_reg_number) {
		this.reception_reg_number = reception_reg_number;
	}
	public String getAgreement_reg_number() {
		return agreement_reg_number;
	}
	public void setAgreement_reg_number(String agreement_reg_number) {
		this.agreement_reg_number = agreement_reg_number;
	}
	public String getResearch_date() {
		return research_date;
	}
	public void setResearch_date(String research_date) {
		this.research_date = research_date;
	}
	public String getAnnouncement_type() {
		return announcement_type;
	}
	public void setAnnouncement_type(String announcement_type) {
		this.announcement_type = announcement_type;
	}
	public String getAnnouncement_business_name() {
		return announcement_business_name;
	}
	public void setAnnouncement_business_name(String announcement_business_name) {
		this.announcement_business_name = announcement_business_name;
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
	public String getResearcher_name() {
		return researcher_name;
	}
	public void setResearcher_name(String researcher_name) {
		this.researcher_name = researcher_name;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
