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


@Repository("ManagerDao")
public class ManagerDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("manager.");
	
	/**
	 * 관리자 회원 정보 등록
	 */
	public int insertMemberInfo(ManagerVO vo) throws Exception{
		return update(mapper.concat("insertMemberInfo"), vo);
	}
	/**
	 * 관리자 정보 등록
	 */
	public int insertManagerInfo(ManagerVO vo) throws Exception{
		return update(mapper.concat("insertManagerInfo"), vo);
	}
	/**
	 * 관리자 회원 정보 Update
	 */
	public int updateMemberInfo(ManagerVO vo) throws Exception{
		return update(mapper.concat("updateMemberInfo"), vo);
	}
	/**
	 * 관리자 정보 Update
	 */
	public int updateManagerInfo(ManagerVO vo) throws Exception{
		return update(mapper.concat("updateManagerInfo"), vo);
	}
	/**
	 * 관리자 정보 삭제
	 */
	public int deleteManagerInfo(ManagerVO vo) throws Exception{
		return delete(mapper.concat("deleteManagerInfo"), vo);
	}
	/**
	 * 관리자 메뉴 권한 변경
	 */
	public int updateMenuAuth(ManagerVO vo) throws Exception{
		return update(mapper.concat("updateMenuAuth"), vo);
	}
	/**
	 * 관리자 검색
	 */
	public List<ManagerVO> selectSearchPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param);
	}
	/**
	 * 평가위원 상세
	 */
	public ManagerVO selectDetail(ManagerVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * 평가위원 상태 변경
	 */
	public int updateCommissionerStatus(CommissionerVO vo) throws Exception{
		return update(mapper.concat("updateCommissionerStatus"), vo);
	}

	
	
	
}
