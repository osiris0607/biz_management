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

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;

import com.anchordata.webframework.service.uploadFile.UploadFileVO;
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
public class AgreementVO {
	private static final long serialVersionUID = 1L;

	private int agreement_id;
	private int reception_id;
	private int evaluation_id;
	private String agreement_reg_number = "";
	private String agreement_status = "";
	private String agreement_status_name = "";
	private String remark = "";
	private String research_date = "";
	private String research_funds = "";
	private String reception_reg_number = "";
	private String announcement_type = "";
	private String announcement_business_name = "";
	private String announcement_title = "";
	private String tech_info_name = "";
	private String institution_name = "";
	private String researcher_name = "";
	private String member_id = "";
	private String fund_support_amount1 = "";
	private String fund_support_amount2 = "";
	private String fund_support_amount3 = "";
	private String fund_support_amount4 = "";
	private String fund_cash1 = "";
	private String fund_cash2 = "";
	private String fund_cash3 = "";
	private String fund_cash4 = "";
	private String fund_hyeonmul1 = "";
	private String fund_hyeonmul2 = "";
	private String fund_hyeonmul3 = "";
	private String fund_hyeonmul4 = "";
	private String fund_total_cost1 = "";
	private String fund_total_cost2 = "";
	private String fund_total_cost3 = "";
	private String fund_total_cost4 = "";
	
	
	private String use_yn = "";
	private String reg_date = "";
	private String total_count = "";
	
	
	private List<AgreementResearcherVO> agreement_researcher_list;
	private String agreement_researcher_list_json = "";
	private List<AgreementFundDetailVO> agreement_fund_detail_list;
	private String agreement_fund_detail_list_json = "";
	
	
	@JsonIgnore
	private MultipartFile upload_plan_file;
	private int upload_plan_file_id;
	private String upload_plan_file_name;
	@JsonIgnore
	private MultipartFile upload_agreement_file;
	private int upload_agreement_file_id;
	private String upload_agreement_file_name;
	@JsonIgnore
	private MultipartFile[] upload_files;
	private int file_id;
	private List<UploadFileVO> return_upload_files;
	private List<Integer> delete_file_list;
	
	
	
	
	public String getUpload_plan_file_name() {
		return upload_plan_file_name;
	}
	public void setUpload_plan_file_name(String upload_plan_file_name) {
		this.upload_plan_file_name = upload_plan_file_name;
	}
	public String getUpload_agreement_file_name() {
		return upload_agreement_file_name;
	}
	public void setUpload_agreement_file_name(String upload_agreement_file_name) {
		this.upload_agreement_file_name = upload_agreement_file_name;
	}
	public String getFund_support_amount1() {
		return fund_support_amount1;
	}
	public void setFund_support_amount1(String fund_support_amount1) {
		this.fund_support_amount1 = fund_support_amount1;
	}
	public String getFund_support_amount2() {
		return fund_support_amount2;
	}
	public void setFund_support_amount2(String fund_support_amount2) {
		this.fund_support_amount2 = fund_support_amount2;
	}
	public String getFund_support_amount3() {
		return fund_support_amount3;
	}
	public void setFund_support_amount3(String fund_support_amount3) {
		this.fund_support_amount3 = fund_support_amount3;
	}
	public String getFund_support_amount4() {
		return fund_support_amount4;
	}
	public void setFund_support_amount4(String fund_support_amount4) {
		this.fund_support_amount4 = fund_support_amount4;
	}
	public String getFund_cash1() {
		return fund_cash1;
	}
	public void setFund_cash1(String fund_cash1) {
		this.fund_cash1 = fund_cash1;
	}
	public String getFund_cash2() {
		return fund_cash2;
	}
	public void setFund_cash2(String fund_cash2) {
		this.fund_cash2 = fund_cash2;
	}
	public String getFund_cash3() {
		return fund_cash3;
	}
	public void setFund_cash3(String fund_cash3) {
		this.fund_cash3 = fund_cash3;
	}
	public String getFund_cash4() {
		return fund_cash4;
	}
	public void setFund_cash4(String fund_cash4) {
		this.fund_cash4 = fund_cash4;
	}
	public String getFund_hyeonmul1() {
		return fund_hyeonmul1;
	}
	public void setFund_hyeonmul1(String fund_hyeonmul1) {
		this.fund_hyeonmul1 = fund_hyeonmul1;
	}
	public String getFund_hyeonmul2() {
		return fund_hyeonmul2;
	}
	public void setFund_hyeonmul2(String fund_hyeonmul2) {
		this.fund_hyeonmul2 = fund_hyeonmul2;
	}
	public String getFund_hyeonmul3() {
		return fund_hyeonmul3;
	}
	public void setFund_hyeonmul3(String fund_hyeonmul3) {
		this.fund_hyeonmul3 = fund_hyeonmul3;
	}
	public String getFund_hyeonmul4() {
		return fund_hyeonmul4;
	}
	public void setFund_hyeonmul4(String fund_hyeonmul4) {
		this.fund_hyeonmul4 = fund_hyeonmul4;
	}
	public String getFund_total_cost1() {
		return fund_total_cost1;
	}
	public void setFund_total_cost1(String fund_total_cost1) {
		this.fund_total_cost1 = fund_total_cost1;
	}
	public String getFund_total_cost2() {
		return fund_total_cost2;
	}
	public void setFund_total_cost2(String fund_total_cost2) {
		this.fund_total_cost2 = fund_total_cost2;
	}
	public String getFund_total_cost3() {
		return fund_total_cost3;
	}
	public void setFund_total_cost3(String fund_total_cost3) {
		this.fund_total_cost3 = fund_total_cost3;
	}
	public String getFund_total_cost4() {
		return fund_total_cost4;
	}
	public void setFund_total_cost4(String fund_total_cost4) {
		this.fund_total_cost4 = fund_total_cost4;
	}
	public int getUpload_plan_file_id() {
		return upload_plan_file_id;
	}
	public void setUpload_plan_file_id(int upload_plan_file_id) {
		this.upload_plan_file_id = upload_plan_file_id;
	}
	public int getUpload_agreement_file_id() {
		return upload_agreement_file_id;
	}
	public void setUpload_agreement_file_id(int upload_agreement_file_id) {
		this.upload_agreement_file_id = upload_agreement_file_id;
	}
	public MultipartFile getUpload_plan_file() {
		return upload_plan_file;
	}
	public void setUpload_plan_file(MultipartFile upload_plan_file) {
		this.upload_plan_file = upload_plan_file;
	}
	public MultipartFile getUpload_agreement_file() {
		return upload_agreement_file;
	}
	public void setUpload_agreement_file(MultipartFile upload_agreement_file) {
		this.upload_agreement_file = upload_agreement_file;
	}
	public MultipartFile[] getUpload_files() {
		return upload_files;
	}
	public void setUpload_files(MultipartFile[] upload_files) {
		this.upload_files = upload_files;
	}
	public List<UploadFileVO> getReturn_upload_files() {
		return return_upload_files;
	}
	public void setReturn_upload_files(List<UploadFileVO> return_upload_files) {
		this.return_upload_files = return_upload_files;
	}
	public List<Integer> getDelete_file_list() {
		return delete_file_list;
	}
	public void setDelete_file_list(List<Integer> delete_file_list) {
		this.delete_file_list = delete_file_list;
	}
	public int getFile_id() {
		return file_id;
	}
	public void setFile_id(int file_id) {
		this.file_id = file_id;
	}
	public List<AgreementResearcherVO> getAgreement_researcher_list() {
		return agreement_researcher_list;
	}
	public void setAgreement_researcher_list(List<AgreementResearcherVO> agreement_researcher_list) {
		this.agreement_researcher_list = agreement_researcher_list;
	}
	public String getAgreement_researcher_list_json() {
		return agreement_researcher_list_json;
	}
	public void setAgreement_researcher_list_json(String agreement_researcher_list_json) {
		String tempJsonData = agreement_researcher_list_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			agreement_researcher_list = Arrays.asList(mapper.readValue(tempJsonData, AgreementResearcherVO[].class));
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
		this.agreement_researcher_list_json = agreement_researcher_list_json;
	}
	public List<AgreementFundDetailVO> getAgreement_fund_detail_list() {
		return agreement_fund_detail_list;
	}
	public void setAgreement_fund_detail_list(List<AgreementFundDetailVO> agreement_fund_detail_list) {
		this.agreement_fund_detail_list = agreement_fund_detail_list;
	}
	public String getAgreement_fund_detail_list_json() {
		return agreement_fund_detail_list_json;
	}
	public void setAgreement_fund_detail_list_json(String agreement_fund_detail_list_json) {
		String tempJsonData = agreement_fund_detail_list_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			agreement_fund_detail_list = Arrays.asList(mapper.readValue(tempJsonData, AgreementFundDetailVO[].class));
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
		this.agreement_fund_detail_list_json = agreement_fund_detail_list_json;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getResearch_date() {
		return research_date;
	}
	public void setResearch_date(String research_date) {
		this.research_date = research_date;
	}
	public String getResearch_funds() {
		return research_funds;
	}
	public void setResearch_funds(String research_funds) {
		this.research_funds = research_funds;
	}
	public String getAnnouncement_type() {
		return announcement_type;
	}
	public void setAnnouncement_type(String announcement_type) {
		this.announcement_type = announcement_type;
	}
	public String getAgreement_status_name() {
		return agreement_status_name;
	}
	public void setAgreement_status_name(String agreement_status_name) {
		this.agreement_status_name = agreement_status_name;
	}
	public String getReception_reg_number() {
		return reception_reg_number;
	}
	public void setReception_reg_number(String reception_reg_number) {
		this.reception_reg_number = reception_reg_number;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
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
	public int getAgreement_id() {
		return agreement_id;
	}
	public void setAgreement_id(int agreement_id) {
		this.agreement_id = agreement_id;
	}
	public int getReception_id() {
		return reception_id;
	}
	public void setReception_id(int reception_id) {
		this.reception_id = reception_id;
	}
	public int getEvaluation_id() {
		return evaluation_id;
	}
	public void setEvaluation_id(int evaluation_id) {
		this.evaluation_id = evaluation_id;
	}
	public String getTotal_count() {
		return total_count;
	}
	public void setTotal_count(String total_count) {
		this.total_count = total_count;
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
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
