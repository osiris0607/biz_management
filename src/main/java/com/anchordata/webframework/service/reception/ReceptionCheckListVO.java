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
package com.anchordata.webframework.service.reception;


public class ReceptionCheckListVO {

	private static final long serialVersionUID = 1L;
	private int reception_check_id;
	private int reception_id;
	private int announcement_check_id;
	private String reception_check_value;
	
	
	public String getReception_check_value() {
		return reception_check_value;
	}
	public void setReception_check_value(String reception_check_value) {
		this.reception_check_value = reception_check_value;
	}
	public int getReception_check_id() {
		return reception_check_id;
	}
	public void setReception_check_id(int reception_check_id) {
		this.reception_check_id = reception_check_id;
	}
	public int getAnnouncement_check_id() {
		return announcement_check_id;
	}
	public void setAnnouncement_check_id(int announcement_check_id) {
		this.announcement_check_id = announcement_check_id;
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
