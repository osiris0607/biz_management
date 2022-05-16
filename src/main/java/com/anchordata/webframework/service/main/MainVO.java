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
package com.anchordata.webframework.service.main;


public class MainVO {

	private static final long serialVersionUID = 1L;
	
	private int main_id;
	private String board_name;	// 게시판 이름 (공지사항, 정책제안, 자료실)
	private String borad_id;
	private String pds_type;
	
	
	private String title;
	private String hits;
	private String reg_date;
	
	private int total_count;
	
	
	
	public String getPds_type() {
		return pds_type;
	}
	public void setPds_type(String pds_type) {
		this.pds_type = pds_type;
	}
	public String getBorad_id() {
		return borad_id;
	}
	public void setBorad_id(String borad_id) {
		this.borad_id = borad_id;
	}
	public int getMain_id() {
		return main_id;
	}
	public void setMain_id(int main_id) {
		this.main_id = main_id;
	}
	public String getBoard_name() {
		return board_name;
	}
	public void setBoard_name(String board_name) {
		this.board_name = board_name;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getHits() {
		return hits;
	}
	public void setHits(String hits) {
		this.hits = hits;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public int getTotal_count() {
		return total_count;
	}
	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}



	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
