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
package com.anchordata.webframework.service.institution;


import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.anchordata.webframework.service.member.MemberService;

@Service("InstitutionService")
public class InstitutionService {
	
	@Autowired
	private InstitutionDao institutionDao;
	@Autowired
	private MemberService MemberService;	
	
	
	/**
	 * 기관 정보 등록
	 */
	@Transactional
	public int institutionRegistration(InstitutionVO vo) throws Exception {
				
		// 기관 정보 Insert
		int result = institutionDao.insertinstitutionInfo(vo);
		// 성공이면 해당 기관 정보를 Member에 업데이트 한다.	
		if (result !=0 ) {
			result = MemberService.updateInstitution(vo);
		}
		
		return result;
	}
	/**
	 * 기관 정보 상세
	 */
	@Transactional
	public InstitutionVO detailInstitution(InstitutionVO vo) throws Exception {
		return institutionDao.selectDetailInstitution(vo);
	}
	/**
	 * 사업자 번호 검색
	 */
	@Transactional
	public InstitutionVO searchRegNo(InstitutionVO vo) throws Exception {
		return institutionDao.selectRegNo(vo);
	}
	/**
	 * 대표자 정보 등록
	 */
	@Transactional
	public int representativeRegistration(InstitutionVO vo) throws Exception {
		// 대표자 중복 정보 check
		
		InstitutionVO queryData = institutionDao.selectRepresentativeDuplication(vo);
		
		if ( queryData != null )
		{
			return -2;
		}
		
		// 대표자 정보 Insert
		int result = institutionDao.insertRepresentativeInfo(vo);
		return result;
	}
	/**
	 * 대표자 정보 조회
	 */
	@Transactional
	public List<InstitutionVO> representativeAlllList(InstitutionVO vo) throws Exception {
		return institutionDao.selectRepresentativeAlllList(vo);
	}
	/**
	 * 대표자 정보 삭제
	 */
	@Transactional
	public int representativeWithdrawal(InstitutionVO vo) throws Exception {
		return institutionDao.deleteRepresentative(vo);
	}
	
	
}
