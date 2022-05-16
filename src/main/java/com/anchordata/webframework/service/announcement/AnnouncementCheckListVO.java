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

public class AnnouncementCheckListVO {

	private static final long serialVersionUID = 1L;
	
	private int check_id;
	private int announcement_id;
	private String all_use_yn = "";
	private String check_list_use_yn = "";
	private String check_list_content = "";
	private String popup_use_yn = "";
	private String popup_warn_use_yn = "";
	private String popup_warn_content = "";
	
	
	private int total_count;
	private int result;

	
	
	public int getCheck_id() {
		return check_id;
	}
	public void setCheck_id(int check_id) {
		this.check_id = check_id;
	}
	public int getAnnouncement_id() {
		return announcement_id;
	}
	public void setAnnouncement_id(int announcement_id) {
		this.announcement_id = announcement_id;
	}
	public String getAll_use_yn() {
		return all_use_yn;
	}
	public void setAll_use_yn(String all_use_yn) {
		this.all_use_yn = all_use_yn;
	}
	public String getCheck_list_use_yn() {
		return check_list_use_yn;
	}
	public void setCheck_list_use_yn(String check_list_use_yn) {
		this.check_list_use_yn = check_list_use_yn;
	}
	public String getCheck_list_content() {
		return check_list_content;
	}
	public void setCheck_list_content(String check_list_content) {
		this.check_list_content = check_list_content;
	}
	public String getPopup_use_yn() {
		return popup_use_yn;
	}
	public void setPopup_use_yn(String popup_use_yn) {
		this.popup_use_yn = popup_use_yn;
	}
	public String getPopup_warn_use_yn() {
		return popup_warn_use_yn;
	}
	public void setPopup_warn_use_yn(String popup_warn_use_yn) {
		this.popup_warn_use_yn = popup_warn_use_yn;
	}
	public String getPopup_warn_content() {
		return popup_warn_content;
	}
	public void setPopup_warn_content(String popup_warn_content) {
		this.popup_warn_content = popup_warn_content;
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
