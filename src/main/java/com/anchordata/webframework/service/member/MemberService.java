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


import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.base.util.NaverMailSender;
import com.anchordata.webframework.service.institution.InstitutionVO;



@Service("MemberService")
public class MemberService {
	
	@Autowired
	private MemberDao memberDao;
	
	
	/**
	 * 평가위원 여부
	 */
	@Transactional
	public int updateAuthLeveleCommissioner(MemberVO vo) throws Exception {
		return memberDao.updateAuthLeveleCommissioner(vo);
	}
	/**
	 * 사용여부
	 */
	@Transactional
	public int updateAdminUseYN(MemberVO vo) throws Exception {
		return memberDao.updateAdminUseYN(vo);
	}
	/**
	 * 패스워드 초기화
	 */
	@Transactional
	public int initPassword(MemberVO vo) throws Exception {
		// Password Encrypt 
		String encodedPassword = new BCryptPasswordEncoder().encode("1234");
		vo.setPwd(encodedPassword);
		
		int result = memberDao.updateNewPwd(vo);
		return result;
	}
	
	/**
	 * 로그인 정보 찾기
	 */
	@Transactional
	public MemberVO findLoginInfo(MemberVO vo) throws Exception {
		MemberVO result = memberDao.findLoginInfo(vo);
		return result;
	}
	
	/**
	 * 회원 가입
	 */
	@Transactional
	public int registration(MemberVO vo) throws Exception {
		MemberVO resultVO = memberDao.findLoginInfo(vo.getMember_id());
		if (resultVO != null)
		{
			System.out.println("이미 사용중인 아이디입니다. 다른 아이디를 선택해 주십시요.");
			return 404;
		}
		
		// Password Encrypt 
		String encodedPassword = new BCryptPasswordEncoder().encode(vo.getPwd());
		vo.setPwd(encodedPassword);
				
		// Member Insert
		int result = memberDao.insertMemberInfo(vo);
		// Expert Insert	
		if (result !=0 && vo.getAuth_level_expert().compareTo("Y") == 0) {
			result = memberDao.insertExtensionInfo(vo);
		}
		
		return result;
	}
	/**
	 * 회원 정보 수정
	 */
	@Transactional
	public boolean modification(MemberVO vo) throws Exception {
		// Member modification
		MemberVO result = memberDao.findLoginInfo(vo.getMember_id());
		if (result == null)
		{
			System.out.println("해당 아이디의 정보가 없습니다.");
			return false;
		}
		
		if ( StringUtils.isNotEmpty(vo.getPwd()) ) {
			// Password Encrypt 
			String encodedPassword = new BCryptPasswordEncoder().encode(vo.getPwd());
			vo.setPwd(encodedPassword);
		}
		
		memberDao.updateMemberExtensionInfo(vo);
		if ( memberDao.updateMemberInfo(vo) > 0  ) {
			return true;
		}
		else {
			return false;
		}
	}
	/**
	 * 전문가 검색
	 */
	@Transactional
	public List<MemberVO> searchExpertPagingList(MemberSearchVO vo) throws Exception {
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
		if (  StringUtils.isEmpty(vo.getSearch_text()) == false ) {
			search.put("search_text", vo.getSearch_text());	
		}
		if (  StringUtils.isEmpty(vo.getInstitution_type()) == false ) {
			search.put("institution_type", vo.getInstitution_type());	
		}
		if (  StringUtils.isEmpty(vo.getInstitution_name()) == false ) {
			search.put("institution_name", vo.getInstitution_name());	
		}
		if (  StringUtils.isEmpty(vo.getFrom_date()) == false ) {
			search.put("from_date", vo.getFrom_date());	
		}
		if (  StringUtils.isEmpty(vo.getTo_date()) == false ) {
			search.put("to_date", vo.getTo_date());	
		}
		if (  StringUtils.isEmpty(vo.getMember_id()) == false ) {
			search.put("member_id", vo.getMember_id());	
		}
		
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}

		
		return memberDao.selectSearchExpertPagingList(new DataMap(search));
	}
	/**
	 * 전문가 상세  
	 */
	@Transactional
	public MemberVO expertDetail(MemberVO vo) throws Exception {
		return memberDao.selectExpertDetail(vo);
	}
	/**
	 * 아이디 찾기
	 */
	@Transactional
	public MemberVO findID(MemberVO vo) throws Exception {
		MemberVO result = memberDao.findID(vo);
		return result;
	}
	/**
	 * 로그인 정보 기록
	 */
	public int updateLoginTime(String memberId) throws Exception {
		return memberDao.updateLoginTime(memberId);	
	}
	/**
	 * 회원 수 정보
	 * 
	 */
	public HashMap<String, Object> status() throws Exception {
		return memberDao.selectMemberCount();
	}
	/**
	 * 연구자 검색
	 */
	public List<MemberVO> searchResearcherPagingList(MemberSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false ) {
			search.put("member_id", vo.getMember_id());	
		}
		if (  StringUtils.isEmpty(vo.getName()) == false ) {
			search.put("name", vo.getName());	
		}
		if (  StringUtils.isEmpty(vo.getSearch_text()) == false ) {
			search.put("search_text", vo.getSearch_text());	
		}
		if (  StringUtils.isEmpty(vo.getInstitution_name()) == false ) {
			search.put("institution_name", vo.getInstitution_name());	
		}
		if (  StringUtils.isEmpty(vo.getNationality()) == false ) {
			search.put("nationality", vo.getNationality());	
		}
		if (  StringUtils.isEmpty(vo.getInstitution_type()) == false ) {
			search.put("institution_type", vo.getInstitution_type());	
		}
		if (  StringUtils.isEmpty(vo.getFrom_date()) == false ) {
			search.put("from_date", vo.getFrom_date());	
		}
		if (  StringUtils.isEmpty(vo.getTo_date()) == false ) {
			search.put("to_date", vo.getTo_date());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		return memberDao.selectSearchResearcherPagingList(new DataMap(search));
	}
	/**
	 * 회원 Detail List  
	 */
	@Transactional
	public MemberVO detail(MemberVO vo) throws Exception {
		return memberDao.selectDetail(vo);
	}
	/**
	 * 회원 all List  
	 */
	@Transactional
	public List<MemberVO> allList() throws Exception {
		return memberDao.selectAllList();
	}
	/**
	 * 해당 계정이 있는지 조회
	 */
	@Transactional
	public MemberVO checkMemberExist(MemberVO vo) throws Exception {
		MemberVO result = memberDao.checkMemberExist(vo);
		return result;
	}
	/**
	 * 해당 계정/Password가 일치하는지 조회
	 */
	@Transactional
	public boolean checkPwd(MemberVO vo) throws Exception {
		MemberVO result = memberDao.selectMemberPwd(vo);
		if (result == null) {
			return false;
		}
		return new BCryptPasswordEncoder().matches(vo.getPwd(), result.getPwd());
	}
	/**
	 * 해당 계정에 새로운 Pwd 생성
	 */
	@Transactional
	public int changePwd(MemberVO vo) throws Exception {
		byte[] pwdBytes = Base64.getDecoder().decode(vo.getNew_pwd());
		String decodeBase64Pwd = new String(pwdBytes);
		
		// Password Encrypt 
		String encodedPassword = new BCryptPasswordEncoder().encode(decodeBase64Pwd);
		vo.setPwd(encodedPassword);
		
		return memberDao.updateNewPwd(vo);
	}
	/**
	 * 로그인 정보 기록
	 */
	public int updateInstitution(InstitutionVO vo) throws Exception {
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("member_id", vo.getMember_id());
		param.put("institution_id", vo.getReg_no());
		param.put("institution_type", vo.getType());
		param.put("department", vo.getDepartment());
		param.put("position", vo.getPosition());
		return memberDao.updateInstitution(new DataMap(param));	
	}
	/**
	 * 해당 계정에 새로운 Pwd 생성
	 */
	@Transactional
	public boolean createNewPwd(MemberVO vo) throws Exception {
		// 새로운 PWD Random 생성
		Random rnd =new Random();
		StringBuffer pwd =new StringBuffer();
		for(int i=0;i<10;i++){
		    // rnd.nextBoolean() 는 랜덤으로 true, false 를 리턴. true일 시 랜덤 한 소문자를, false 일 시 랜덤 한 숫자를 StringBuffer 에 append 한다.
		    if(rnd.nextBoolean()){
		    	pwd.append((char)((int)(rnd.nextInt(26))+97));
		    }else{
		    	pwd.append((rnd.nextInt(10)));
		    }
		}
		
		// Password Encrypt 
		String encodedPassword = new BCryptPasswordEncoder().encode(pwd.toString());
		vo.setPwd(encodedPassword);
		
		
		int result = memberDao.updateNewPwd(vo);
		// 성공인 경우 메일로 해당 암호 정보를 전달한다.
		if ( result > 0 ) {
			String mailTitle = "[서울시 신기술 접수소] 변경된 패스워드 입니다.";
			String mailSender = "서울시 신기술 접수소";
			List<String> mailToList = new ArrayList<>();
			mailToList.add(vo.getEmail());
			String mailContent = "<p>변경 패스워드 : " + pwd.toString() + "</p>";
			try {
				if ( NaverMailSender.sender(mailTitle, mailSender, mailToList, mailContent) == false ) {
					return false;
				}
			} catch (Exception e) {
				return false;
			}
			return true;
		} else {
			return false;
		}
	}
	/**
	 * 회원 history 남기기
	 * 현재는 로그인 시가만 남긴다.
	 */
	public int insertMemberHistroy(String memberId) throws Exception {
		return memberDao.insertMemberHistroy(memberId);	
	}
	/**
	 * 회원 history 검색
	 * 현재는 로그인 시가만 남긴다.
	 */
	public List<String> selectMemberHistory(String memberId) throws Exception {
		return memberDao.selectMemberHistory(memberId);	
	}
	
}
