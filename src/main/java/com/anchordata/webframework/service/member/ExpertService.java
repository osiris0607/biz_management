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
package com.anchordata.webframework.service.member;


import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;


@Service("ExpertService")
public class ExpertService {
	
	@Autowired
	private ExpertDao expertDao;
	
	/**
	 * all Search List  
	 */
	@Transactional
	public List<ExpertVO> searchAllList(ExpertVO vo) throws Exception {
		return expertDao.selectAllList(vo);
	}
	
	/**
	 * 상세 정보
	 */
	@Transactional
	public ExpertVO detail(ExpertVO vo) throws Exception {
		return expertDao.selectDetail(vo);
	}
	
	/**
	 * 검색
	 */
	@Transactional
	public List<ExpertVO> searchList(ExpertSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getUniversity()) == false ) {
			search.put("university", vo.getUniversity());	
		}
		if (  StringUtils.isEmpty(vo.getResearch()) == false ) {
			search.put("research", vo.getResearch());	
		}
		if (  StringUtils.isEmpty(vo.getName()) == false ) {
			search.put("name", vo.getName());	
		}
		if (  StringUtils.isEmpty(vo.getLarge()) == false ) {
			search.put("large", vo.getLarge());	
		}
		if (  StringUtils.isEmpty(vo.getMiddle()) == false ) {
			search.put("middle", vo.getMiddle());	
		}
		if (  StringUtils.isEmpty(vo.getSmall()) == false ) {
			search.put("small", vo.getSmall());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		return expertDao.selectSearchPagingList(new DataMap(search));
	}
	
	
		
}
