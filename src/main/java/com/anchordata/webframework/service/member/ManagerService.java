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
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;


@Service("ManagerService")
public class ManagerService {
	
	@Autowired
	private ManagerDao managerDao;
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private CommissionerDao commissionerDao;
	
	
	/**
	 * 관리자 등록
	 */
	@Transactional
	public int registration(ManagerVO vo) throws Exception {
		MemberVO resultVO = memberDao.findLoginInfo(vo.getMember_id());
		if (resultVO != null) {
			System.out.println("이미 사용중인 아이디입니다. 다른 아이디를 선택해 주십시요.");
			return -1;
		}
		
		// Password Encrypt 
		String encodedPassword = new BCryptPasswordEncoder().encode(vo.getPwd());
		vo.setPwd(encodedPassword);
		
		// Member 정보 Insert
		int result = managerDao.insertMemberInfo(vo);
		// 권한이 Manager일 경우 Manager 정보 Insert
		// admin 권한이면 모든 메뉴를 볼 수 있다.
		if ( vo.getAuth_level_admin().equals("Y") ) {
			vo.setAuth_agreement_menu_yn("Y");
			vo.setAuth_announcement_menu_yn("Y");
			vo.setAuth_calculate_menu_yn("Y");
			vo.setAuth_evaluation_menu_yn("Y");
			vo.setAuth_execution_menu_yn("Y");
			vo.setAuth_notice_menu_yn("Y");
			vo.setAuth_reception_menu_yn("Y");
			vo.setResearch_manager_yn("N");
			vo.setEvaluation_manager_yn("N");
		}
		result = managerDao.insertManagerInfo(vo);
		
		// Manager이면 평가위원이기도 하다. 평기워원으로도 입력
		if ( vo.getAuth_level_manager().equals("Y") ) {
			CommissionerVO commissionerVO = new CommissionerVO();
			commissionerVO.setMember_id(vo.getMember_id());
			commissionerVO.setCommissioner_status("D0000004");
			commissionerVO.setNational_skill_large("기타");
			commissionerVO.setRnd_class("기타");
			result = commissionerDao.insertInfo(commissionerVO);
		}
		
		return result;
	}
	/**
	 * 관리자 수정
	 */
	@Transactional
	public int modification(ManagerVO vo) throws Exception {
		
		// Password Encrypt 
		if ( StringUtils.isEmpty(vo.getPwd()) == false ) {
			String encodedPassword = new BCryptPasswordEncoder().encode(vo.getPwd());
			vo.setPwd(encodedPassword);
		}
		
		// Member 정보 Update
		int result = managerDao.updateMemberInfo(vo);
		// 권한이 Manager일 경우 Manager 정보 Update (없으면 Insert)
		if ( result > 0  ) {
			result = managerDao.updateManagerInfo(vo);
		}
		return result;
	}
	/**
	 * 관리자 삭제
	 */
	@Transactional
	public int withdrawal(ManagerVO vo) throws Exception {
		// Member 정보 삭제
		MemberVO memberVO = new MemberVO();
		memberVO.setMember_id(vo.getMember_id());
		int result = memberDao.deleteMemberInfo(memberVO);
		// Member History 삭제
		result = memberDao.deleteMemberHistory(vo.getMember_id());
		// Manager 삭제
		result = managerDao.deleteManagerInfo(vo);
		// 평가위원 삭제
		CommissionerVO commissionerVO = new CommissionerVO();
		commissionerVO.setMember_id(vo.getMember_id());
		result = commissionerDao.deleteCommissionerInfo(commissionerVO);
		
		
		return result;
	}
	
	
	
	
	
	
	/**
	 * 관리자 검색
	 */
	@Transactional
	public List<ManagerVO> searchPagingList(ManagerSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false ) {
			search.put("member_id", vo.getMember_id());	
		}
		if (  StringUtils.isEmpty(vo.getDepartment()) == false ) {
			search.put("department", vo.getDepartment());	
		}
		if (  StringUtils.isEmpty(vo.getName()) == false ) {
			search.put("name", vo.getName());	
		}
		if (  StringUtils.isEmpty(vo.getAuth_level_admin()) == false ) {
			search.put("auth_level_admin", vo.getAuth_level_admin());	
		}
		if (  StringUtils.isEmpty(vo.getAuth_level_manager()) == false ) {
			search.put("auth_level_manager", vo.getAuth_level_manager());	
		}	
		if (  StringUtils.isEmpty(vo.getResearch_manager_yn()) == false ) {
			search.put("research_manager_yn", vo.getResearch_manager_yn());	
		}
		if (  StringUtils.isEmpty(vo.getEvaluation_manager_yn()) == false ) {
			search.put("evaluation_manager_yn", vo.getEvaluation_manager_yn());	
		}
		
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		return managerDao.selectSearchPagingList(new DataMap(search));
	}
	/**
	 * 관리자 상세  
	 */
	@Transactional
	public ManagerVO searchDetail(ManagerVO vo) throws Exception {
		return managerDao.selectDetail(vo);
	}
	/**
	 * 관리자 메뉴 권한 업데이트
	 */
	@Transactional
	public int updateMenuAuth(ManagerVO vo) throws Exception {
		return managerDao.updateMenuAuth(vo);
	}
	
	
//	
//	/**
//	 * Status 변경
//	 */
//	@Transactional
//	public int updateCommissionerStatus(CommissionerVO vo) throws Exception {
//		return commissionerDao.updateCommissionerStatus(vo);
//	}
	
	
	
	
		
}
