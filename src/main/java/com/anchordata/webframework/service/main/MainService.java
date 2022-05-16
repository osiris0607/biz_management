/*******************************************************************************
 *
 * Copyright �뱬 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of namu C&D corp, and you may not use this file except in
 * compliance with license agreement with namu C&D corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of namu C&D corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.service.main;


import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;


@Service("MainService")
public class MainService {
	
	@Autowired
	private MainDao mainDao;
	
	
	/**
	 * 방문자수 증가
	 */
	@Transactional
	public int addVisitCounter() throws Exception {
		return mainDao.updateVisitCounter();
	}
	
	/**
	 * 방문자수 증가
	 */
	@Transactional
	public int updateVisitstatistics() throws Exception 
	{
		return mainDao.updateVisitstatistics();
	}
	
}
