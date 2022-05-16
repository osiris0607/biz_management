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
package com.anchordata.webframework.service.announcement;

public class AnnouncementExtVO {

	private static final long serialVersionUID = 1L;
	
	private int extension_id;
	private int announcement_id;
	private String ext_type = "";
	private String ext_field_name = "";
	private String ext_field_yn = "";
	
	
	private int total_count;
	private int result;

	

	public String getExt_type() {
		return ext_type;
	}
	public void setExt_type(String ext_type) {
		this.ext_type = ext_type;
	}
	public String getExt_field_name() {
		return ext_field_name;
	}
	public void setExt_field_name(String ext_field_name) {
		this.ext_field_name = ext_field_name;
	}
	public String getExt_field_yn() {
		return ext_field_yn;
	}
	public void setExt_field_yn(String ext_field_yn) {
		this.ext_field_yn = ext_field_yn;
	}
	public int getExtension_id() {
		return extension_id;
	}
	public void setExtension_id(int extension_id) {
		this.extension_id = extension_id;
	}
	public int getAnnouncement_id() {
		return announcement_id;
	}
	public void setAnnouncement_id(int announcement_id) {
		this.announcement_id = announcement_id;
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
