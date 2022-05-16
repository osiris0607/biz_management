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
package com.anchordata.webframework.base.common.web.vo;

import java.util.HashMap;
import java.util.List;


public class CommForm {
	
	private FileForm single;
	
	private FileForm thumb;
	
	private List<FileForm> multi;

	private HashMap<String, Object> form;
	
	private HashMap<String, Object> options;

	public FileForm getSingle() {
		return single;
	}

	public void setSingle(FileForm single) {
		this.single = single;
	}

	public FileForm getThumb() {
		return thumb;
	}

	public void setThumb(FileForm thumb) {
		this.thumb = thumb;
	}

	public List<FileForm> getMulti() {
		return multi;
	}

	public void setMulti(List<FileForm> multi) {
		this.multi = multi;
	}

	public HashMap<String, Object> getForm() {
		return form;
	}

	public void setForm(HashMap<String, Object> form) {
		this.form = form;
	}

	public HashMap<String, Object> getOptions() {
		return options;
	}

	public void setOptions(HashMap<String, Object> options) {
		this.options = options;
	}
	
}
