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
package com.anchordata.webframework.service.statistics;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service("StatisticsService")
public class StatisticsService {
	
	@Autowired
	private StatisticsDao statisticsDao;

	/**
	 * 공지사항 등록
	 */
	@Transactional
	public List<StatisticsVO> serachTime(StatisticsVO vo) throws Exception {
		return statisticsDao.selectTimeCount(vo);
	}
	
}
