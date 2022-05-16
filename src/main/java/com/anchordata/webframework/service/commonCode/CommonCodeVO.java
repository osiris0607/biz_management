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
package com.anchordata.webframework.service.commonCode;

public class CommonCodeVO {

	private int detail_index;
	private String master_id = "";
	private String master_description = "";
	private String parent_id = "";
	private String detail_id = "";
	private String name = "";
	private String detail_description = "";
	private String use_yn = "";
	
	// 국가과학기술분류체계 (national_science_category table)
	private String science_id = "";
	private String large = "";
	private String middle = "";
	private String small = "";
	
	
	
	public String getScience_id() {
		return science_id;
	}
	public void setScience_id(String science_id) {
		this.science_id = science_id;
	}
	public String getLarge() {
		return large;
	}
	public void setLarge(String large) {
		this.large = large;
	}
	public String getMiddle() {
		return middle;
	}
	public void setMiddle(String middle) {
		this.middle = middle;
	}
	public String getSmall() {
		return small;
	}
	public void setSmall(String small) {
		this.small = small;
	}
	public int getDetail_index() {
		return detail_index;
	}
	public void setDetail_index(int detail_index) {
		this.detail_index = detail_index;
	}
	public String getMaster_id() {
		return master_id;
	}
	public void setMaster_id(String master_id) {
		this.master_id = master_id;
	}
	public String getMaster_description() {
		return master_description;
	}
	public void setMaster_description(String master_description) {
		this.master_description = master_description;
	}
	public String getParent_id() {
		return parent_id;
	}
	public void setParent_id(String parent_id) {
		this.parent_id = parent_id;
	}
	public String getDetail_id() {
		return detail_id;
	}
	public void setDetail_id(String detail_id) {
		this.detail_id = detail_id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDetail_description() {
		return detail_description;
	}
	public void setDetail_description(String detail_description) {
		this.detail_description = detail_description;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	
	
	
}
