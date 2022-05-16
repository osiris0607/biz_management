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
public class CommissionerEvaluationItemVO {

	public static class ItemResultInfo { // 내부 클래스
		private int item_id;
		private String item_result;
		
		public int getItem_id() {
			return item_id;
		}
		public void setItem_id(int item_id) {
			this.item_id = item_id;
		}
		public String getItem_result() {
			return item_result;
		}
		public void setItem_result(String item_result) {
			this.item_result = item_result;
		}
    }
	
	private static final long serialVersionUID = 1L;

	private String member_id = "";
	private int evaluation_id;
	private String item_type;
	
	// 평가 항목 결과 JSON String
	private String item_result_info_json = "";
	// 평가 항목 결과 리스트
	private List<ItemResultInfo> item_result_info_list;

	
	public String getItem_type() {
		return item_type;
	}
	public void setItem_type(String item_type) {
		this.item_type = item_type;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public int getEvaluation_id() {
		return evaluation_id;
	}
	public void setEvaluation_id(int evaluation_id) {
		this.evaluation_id = evaluation_id;
	}
	public String getItem_result_info_json() {
		return item_result_info_json;
	}
	public void setItem_result_info_json(String item_result_info_json) {
		String tempJsonData = item_result_info_json.replace("&quot;", "\"");
		ObjectMapper mapper = new ObjectMapper();
		try {
			item_result_info_list = Arrays.asList(mapper.readValue(tempJsonData, ItemResultInfo[].class));
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
		this.item_result_info_json = item_result_info_json;
	}
	public List<ItemResultInfo> getItem_result_info_list() {
		return item_result_info_list;
	}
	public void setItem_result_info_list(List<ItemResultInfo> item_result_info_list) {
		this.item_result_info_list = item_result_info_list;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
