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
package com.anchordata.webframework.service.emailSMS;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;


@Repository("emailSMSDao")
public class EmailSMSDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("emailSMS.");
	/**
	 *  기관 등록
	 */
	public int insertInfo(emailSMSVO vo) throws Exception{
		return update(mapper.concat("insertInfo"), vo);
	}
	
	public List<emailSMSVO> selectDetail(emailSMSVO vo) throws Exception{
		return selectList(mapper.concat("selectDetail"), vo);
	}
	
	
	
//	/**
//	 * 기관 상세 정보
//	 */
//	public emailSMSVO selectDetailInstitution(emailSMSVO vo) throws Exception{
//		return selectOne(mapper.concat("selectDetailInstitution"), vo);
//	}
//	/**
//	 * 사업자 번호 검색
//	 */
//	public emailSMSVO selectRegNo(emailSMSVO vo) throws Exception{
//		return selectOne(mapper.concat("selectRegNo"), vo);
//	}
//	/**
//	 *  대표자 등록
//	 */
//	public int insertRepresentativeInfo(emailSMSVO vo) throws Exception{
//		return update(mapper.concat("insertRepresentativeInfo"), vo);
//	}
//	/**
//	 * 대표자 검색
//	 */
//	public List<emailSMSVO> selectRepresentativeAlllList(emailSMSVO vo) throws Exception{
//		return selectList(mapper.concat("selectRepresentativeAlllList"), vo);
//	}
//	/**
//	 * 대표자 삭제
//	 */
//	public int deleteRepresentative(emailSMSVO vo) throws Exception{
//		return delete(mapper.concat("deleteRepresentative"), vo);
//	}
}
