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
package com.anchordata.webframework.service.statistics;


public class StatisticsVO {

	private static final long serialVersionUID = 1L;
	
	// 조회 조건
	private String from_date;
	private String to_date;
	
	
	// 결과 값
	private String today_time;
	private String today_time_count;
	
	
	
	public String getToday_time() {
		return today_time;
	}
	public void setToday_time(String today_time) {
		this.today_time = today_time;
	}
	public String getToday_time_count() {
		return today_time_count;
	}
	public void setToday_time_count(String today_time_count) {
		this.today_time_count = today_time_count;
	}
	public String getFrom_date() {
		return from_date;
	}
	public void setFrom_date(String from_date) {
		this.from_date = from_date;
	}
	public String getTo_date() {
		return to_date;
	}
	public void setTo_date(String to_date) {
		this.to_date = to_date;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
