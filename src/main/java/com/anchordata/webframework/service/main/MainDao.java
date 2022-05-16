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


import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;


@Repository("MainDao")
public class MainDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("main.");
	
	
	/**
	 * 정책 검색 리스트
	 */
	public List<MainVO> selectSearchList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param);
	}
	
	/**
	 * 방문자수 증가
	 */
	public int updateVisitCounter() throws Exception{
		return update(mapper.concat("updateVisitCounter"));
	}
	
	/**
	 * 방문자수 증가 통계
	 */
	public int updateVisitstatistics() throws Exception{
		return update(mapper.concat("updateVisitstatistics"));
	}
	
}
