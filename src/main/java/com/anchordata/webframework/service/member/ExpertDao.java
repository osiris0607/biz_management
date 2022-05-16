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

import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;

@Repository("ExpertDao")
public class ExpertDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("expert.");
	
	/**
	 * 회원 검색 All List 
	 */
	public List<ExpertVO> selectAllList(ExpertVO vo) throws Exception{
		return selectList(mapper.concat("selectAllList"), vo);
	}
	
	/**
	 * 상세 검색
	 */
	public ExpertVO selectDetail(ExpertVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * List 검색
	 */
	public List<ExpertVO> selectSearchPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param);
	}
	
	
	
	
	

}
