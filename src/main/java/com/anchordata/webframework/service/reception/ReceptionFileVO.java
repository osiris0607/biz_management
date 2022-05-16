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


public class ReceptionFileVO {

	private static final long serialVersionUID = 1L;
	private int relative_id;
	private int reception_id;
	private int announcement_id;
	private int extension_id;
	private int file_id;
	private String file_name = "";
	
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}
	public int getRelative_id() {
		return relative_id;
	}
	public void setRelative_id(int relative_id) {
		this.relative_id = relative_id;
	}
	public int getReception_id() {
		return reception_id;
	}
	public void setReception_id(int reception_id) {
		this.reception_id = reception_id;
	}
	public int getAnnouncement_id() {
		return announcement_id;
	}
	public void setAnnouncement_id(int announcement_id) {
		this.announcement_id = announcement_id;
	}
	public int getExtension_id() {
		return extension_id;
	}
	public void setExtension_id(int extension_id) {
		this.extension_id = extension_id;
	}
	public int getFile_id() {
		return file_id;
	}
	public void setFile_id(int file_id) {
		this.file_id = file_id;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
}
