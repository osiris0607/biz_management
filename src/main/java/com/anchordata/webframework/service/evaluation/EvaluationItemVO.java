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


import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;

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
public class EvaluationItemVO {

	static class ItemFormInfo { // 내부 클래스
		static class ItemFormDetailInfo { // 내부 클래스
			private int item_id;
			private int form_item_seq;
			private String form_item_detail_name = "";
			private String form_item_result = "";
			
			
			public int getItem_id() {
				return item_id;
			}
			public void setItem_id(int item_id) {
				this.item_id = item_id;
			}
			public int getForm_item_seq() {
				return form_item_seq;
			}
			public void setForm_item_seq(int form_item_seq) {
				this.form_item_seq = form_item_seq;
			}
			public String getForm_item_detail_name() {
				return form_item_detail_name;
			}
			public void setForm_item_detail_name(String form_item_detail_name) {
				this.form_item_detail_name = form_item_detail_name;
			}
			public String getForm_item_result() {
				return form_item_result;
			}
			public void setForm_item_result(String form_item_result) {
				this.form_item_result = form_item_result;
			}
	    }
		
		
		private String form_item_id = "";
		private String form_item_name = "";
		private List<ItemFormDetailInfo> item_form_detail_info_list;
		
		
		public List<ItemFormDetailInfo> getItem_form_detail_info_list() {
			return item_form_detail_info_list;
		}
		public String getForm_item_id() {
			return form_item_id;
		}
		public void setForm_item_id(String form_item_id) {
			this.form_item_id = form_item_id;
		}
		public void setItem_form_detail_info_list(List<ItemFormDetailInfo> item_form_detail_info_list) {
			this.item_form_detail_info_list = item_form_detail_info_list;
		}
		public String getForm_item_name() {
			return form_item_name;
		}
		public void setForm_item_name(String form_item_name) {
			this.form_item_name = form_item_name;
		}
    }
	
	private static final long serialVersionUID = 1L;

	private int item_templete_id;
	private String item_type = "";
	private String form_title = "";
	private String evaluation_id = "";
	
	
	// 평가 번호 리스트
	private List<String> evaluation_id_list;
	// 평가 항목 리스트
	private List<ItemFormInfo> item_form_info_list;
	// 평가 항목 JSON String
	private String item_form_info_json = "";
	
	// 과제에 연결된 평가 항목 리스트
	private List<ItemFormInfo> item_releated_list;
	// 과제에 연결 안된 평가 항목 리스트
	private List<ItemFormInfo> item_unreleated_list;
	
	
	private String use_yn = "";
	private String reg_date = "";
	
	private String total_count = "";
	

	
	public String getEvaluation_id() {
		return evaluation_id;
	}
	public void setEvaluation_id(String evaluation_id) {
		this.evaluation_id = evaluation_id;
	}
	public List<ItemFormInfo> getItem_releated_list() {
		return item_releated_list;
	}
	public void setItem_releated_list(List<ItemFormInfo> item_releated_list) {
		this.item_releated_list = item_releated_list;
	}
	public List<ItemFormInfo> getItem_unreleated_list() {
		return item_unreleated_list;
	}
	public void setItem_unreleated_list(List<ItemFormInfo> item_unreleated_list) {
		this.item_unreleated_list = item_unreleated_list;
	}
	public String getItem_type() {
		return item_type;
	}
	public void setItem_type(String item_type) {
		this.item_type = item_type;
	}
	public int getItem_templete_id() {
		return item_templete_id;
	}
	public void setItem_templete_id(int item_templete_id) {
		this.item_templete_id = item_templete_id;
	}
	public String getForm_title() {
		return form_title;
	}
	public void setForm_title(String form_title) {
		this.form_title = form_title;
	}
	public List<String> getEvaluation_id_list() {
		return evaluation_id_list;
	}
	public void setEvaluation_id_list(List<String> evaluation_id_list) {
		this.evaluation_id_list = evaluation_id_list;
	}
	public List<ItemFormInfo> getItem_form_info_list() {
		return item_form_info_list;
	}
	public void setItem_form_info_list(List<ItemFormInfo> item_form_info_list) {
		this.item_form_info_list = item_form_info_list;
	}
	public String getItem_form_info_json() {
		return item_form_info_json;
	}
	public void setItem_form_info_json(String item_form_info_json) {
		String tempJsonData = item_form_info_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			item_form_info_list = Arrays.asList(mapper.readValue(tempJsonData, ItemFormInfo[].class));
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
		this.item_form_info_json = item_form_info_json;
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
