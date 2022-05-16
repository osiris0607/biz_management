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

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;


@Repository("MemberDao")
public class MemberDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("member.");
	
	public int updateAuthLeveleCommissioner(MemberVO params) throws Exception{
		return update(mapper.concat("updateAuthLeveleCommissioner"), params);
	}
	
	public int updateAdminUseYN(MemberVO params) throws Exception{
		return update(mapper.concat("updateAdminUseYN"), params);
	}
	
	public MemberVO findLoginInfo(String param) {
		return selectOne(mapper.concat("findLoginInfo"), param);
	}
	/**
	 * 이메일 중복 체크
	 */
	public List<MemberVO> findEmail(String param) {
		return selectList(mapper.concat("findEmail"), param);
	}
	/**
	 * Member 등록
	 */
	public int insertMemberInfo(MemberVO vo) throws Exception{
		return update(mapper.concat("insertMemberInfo"), vo);
	}
	/**
	 * Member 업데이트 
	 */
	public int updateMemberInfo(MemberVO vo) throws Exception{
		return update(mapper.concat("updateMemberInfo"), vo);
	}
	/**
	 * Member Extension 등록 
	 */
	public int insertExtensionInfo(MemberVO vo) throws Exception{
		return update(mapper.concat("insertExtensionInfo"), vo);
	}
	/**
	 * Member Extension 업데이트 
	 */
	public int updateMemberExtensionInfo(MemberVO vo) throws Exception{
		return update(mapper.concat("updateMemberExtensionInfo"), vo);
	}
	/**
	 * Expert 검색
	 */
	public List<MemberVO> selectSearchExpertPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchExpertPagingList"), param);
	}
	/**
	 * Expert 상세
	 */
	public MemberVO selectExpertDetail(MemberVO vo) throws Exception{
		return selectOne(mapper.concat("selectExpertDetail"), vo);
	}
	/**
	 * Login 
	 */
	public MemberVO findLoginInfo(MemberVO vo) throws Exception{
		return selectOne(mapper.concat("findLoginInfo"), vo);
	}
	/**
	 * findID 
	 */
	public MemberVO findID(MemberVO vo) throws Exception{
		return selectOne(mapper.concat("findID"), vo);
	}
	/**
	 * 회원 정보 삭제
	 */
	public int deleteMemberInfo(MemberVO vo) throws Exception{
		return delete(mapper.concat("deleteMemberInfo"), vo);
	}
	/**
	 * 회원 차단
	 */
	public int updateMemberBlock(String param) throws Exception{
		return update(mapper.concat("updateMemberBlock"), param);
	}
	/**
	 * 회원 수 정보
	 */
	public HashMap<String, Object> selectMemberCount() throws Exception{
		return selectOne(mapper.concat("selectMemberCount"));
	}
	
	
	public List<MemberVO> selectPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectPagingList"), param);
	}
	/**
	 * 회원 상세
	 */
	public MemberVO selectDetail(MemberVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * PJS : 2020-03-28
	 * 회원 검색
	 */
	public List<MemberVO> adminSearchList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectAdminSearchPagingList"), param);
	}
	/**
	 * 회원 검색 All
	 */
	public List<MemberVO> selectAllList() throws Exception{
		return selectList(mapper.concat("selectAllList"));
	}
	/**
	 * checkMemberExist 
	 */
	public MemberVO checkMemberExist(MemberVO params) throws Exception{
		return selectOne(mapper.concat("selectMemeberExist"), params);
	}
	
	/**
	 * selectMemberPwd 
	 */
	public MemberVO selectMemberPwd(MemberVO params) throws Exception{
		return selectOne(mapper.concat("selectMemeberPwd"), params);
	}
	/**
	 * New Password Insert
	 */
	public int updateNewPwd(MemberVO param) throws Exception{
		return update(mapper.concat("updateNewPwd"), param);
	}
	/**
	 * Login Time update
	 */
	public int updateLoginTime(String param) throws Exception{
		return update(mapper.concat("updateLoginTime"), param);
	}
	/**
	 * Institution update
	 */
	public int updateInstitution(DataMap param) throws Exception{
		return update(mapper.concat("updateInstitution"), param);
	}
	
	
	/**
	 * 연구자 검색
	 */
	public List<MemberVO> selectSearchResearcherPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchResearcherPagingList"), param);
	}
	
	/**
	 * 회원 History 저장
	 */
	public int insertMemberHistroy(String param) throws Exception{
		return update(mapper.concat("insertMemberHistory"), param);
	}
	/**
	 * 회원 History 검색
	 */
	public List<String> selectMemberHistory(String param) throws Exception{
		return selectList(mapper.concat("selectMemberHistory"), param);
	}
	/**
	 * 회원 History 삭제
	 */
	public int deleteMemberHistory(String param) throws Exception{
		return delete(mapper.concat("deleteMemberHistory"), param);
	}
	

}
