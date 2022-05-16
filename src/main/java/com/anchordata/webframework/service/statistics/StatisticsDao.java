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

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;


@Repository("StatisticsDao")
public class StatisticsDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("statistics.");
	/**
	 * 공지 등록 
	 */
	public List<StatisticsVO> selectTimeCount(StatisticsVO params) throws Exception{
		return selectList(mapper.concat("selectTimeCount"), params);
	}
	
	
}
