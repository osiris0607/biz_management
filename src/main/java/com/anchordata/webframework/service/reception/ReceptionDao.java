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
package com.anchordata.webframework.service.reception;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;


@Repository("ReceptionDao")
public class ReceptionDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("reception.");
	/**
	 * 등록 
	 */
	public int insertInfo(ReceptionVO param) throws Exception{
		return update(mapper.concat("insertInfo"), param);
	}
	/**
	 * 접수에 연계된 파일 등록 
	 */
	public int insertRelativeFileInfo(ReceptionVO param) throws Exception{
		return update(mapper.concat("insertRelativeFileInfo"), param);
	}
	/**
	 * 접수에 연계된 선택된 전문가 정보 등록
	 */
	public int insertExpertInfo(ReceptionVO param) throws Exception{
		return update(mapper.concat("insertExpertInfo"), param);
	}
	/**
	 * 접수에 연계된 Check List 결과 값 저장
	 */
	public int insertCheckListInfo(ReceptionVO param) throws Exception {
		return update(mapper.concat("insertCheckListInfo"), param);
	}
	/**
	 * Member에서 검색 시
	 */
	public List<ReceptionVO> selectMemberSearchPagingList(DataMap param) throws Exception {
		return selectPagingList(mapper.concat("selectMemberSearchPagingList"), param);
	}	
	/**
	 * Admin에서 검색 시
	 */
	public List<ReceptionVO> selectAdminSearchPagingList(DataMap param) throws Exception {
		return selectPagingList(mapper.concat("selectAdminSearchPagingList"), param);
	}
	/**
	 * Admin에서 엑셀 다운로드 시
	 */
	public List<ReceptionVO> selectAdminSearchAllList(DataMap param) throws Exception {
		return selectList(mapper.concat("selectAdminSearchAllList"), param);
	}
	
	
	
	/**
	 * 상세
	 */
	public ReceptionVO selectDetail(ReceptionVO vo) throws Exception {
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * 삭제
	 */
	public int deleteInfo(ReceptionVO params) throws Exception{
		return delete(mapper.concat("deleteInfo"), params);
	}
	/**
	 * 수정 
	 */
	public int updateInfo(ReceptionVO param) throws Exception{
		return update(mapper.concat("updateInfo"), param);
	}
	/**
	 * 접수에 연관된 파일 검색
	 */
	public List<ReceptionFileVO> selectRelativeFileInfo(ReceptionVO vo) throws Exception {
		return selectList(mapper.concat("selectRelativeFileInfo"), vo);
	}
	/**
	 * 접수에 연관된 전문가 검색
	 */
	public List<ReceptionExpertVO> selectExpertInfo(ReceptionVO vo) throws Exception {
		return selectList(mapper.concat("selectExpertInfo"), vo);
	}	
	/**
	 * 접수에 연관된 Check List 검색
	 */
	public List<ReceptionCheckListVO> selectCheckListInfo(ReceptionVO vo) throws Exception {
		return selectList(mapper.concat("selectCheckListInfo"), vo);
	}	
	/**
	 * 접수에 연관된 파일 정보 삭제
	 */
	public int deleteFileRelativeInfo(ReceptionVO params) throws Exception{
		return delete(mapper.concat("deleteFileRelativeInfo"), params);
	}
	/**
	 * 접수에 연관된 전문가 정보 삭제
	 */
	public int deleteExpertInfo(ReceptionVO params) throws Exception{
		return delete(mapper.concat("deleteExpertInfo"), params);
	}
	/**
	 * 접수에 연관된 Check List 정보 삭제
	 */
	public int deleteCheckListInfo(ReceptionVO params) throws Exception{
		return delete(mapper.concat("deleteCheckListInfo"), params);
	}	
	/**
	 * 접수 Status 변경
	 */
	public int updateReceptionStatus(ReceptionVO params) throws Exception{
		return update(mapper.concat("updateReceptionStatus"), params);
	}
	/**
	 * 접수 완료
	 */
	public int updateReceptionComplete(ReceptionVO params) throws Exception{
		return update(mapper.concat("updateReceptionComplete"), params);
	}	
	/**
	 * 전문가 참여여부 Status 변경
	 */
	public int updateExpertParticipation(ReceptionExpertVO params) throws Exception{
		return update(mapper.concat("updateExpertParticipation"), params);
	}
	/**
	 * 참여 전문가 우선순위 변경 
	 */
	public int updateExpertPriority(ReceptionExpertVO params) throws Exception{
		return update(mapper.concat("updateExpertPriority"), params);
	}
	/**
	 * 참여 전문가 중 선택된 전문가 Update
	 */
	public int updateExpertChoice(ReceptionExpertVO params) throws Exception{
		return update(mapper.concat("updateExpertChoice"), params);
	}
	/**
	 * 접수 전문가로 선택된 접수 목록 검색 
	 */
	public List<ReceptionVO> selectExpertSearchPagingList(DataMap param) throws Exception {
		return selectPagingList(mapper.concat("selectExpertSearchPagingList"), param);
	}
	/**
	 * My페이지 > 나의 수행 과제 현황 관리 List 검색
	 */
	public List<ReceptionVO> selectReportSearchPagingList(DataMap param) throws Exception {
		return selectPagingList(mapper.concat("selectReportSearchPagingList"), param);
	}
	
	/**
	 * Main Page state
	 */
	public Map<String,String> selectMainState() throws Exception{
		return selectOne(mapper.concat("selectMainState"));
	}
	
	/**
	 * Main Page state
	 */
	public Map<String,String> selectExpertParticipation(ReceptionSearchVO vo) throws Exception{
		return selectOne(mapper.concat("selectExpertParticipation"), vo);
	}
	
	
	
	/**
	 * Admin > 접수 > 엑셀 다운로드 데이터 검색
	 */
	public List<ReceptionVO> searchAdminReceptionAllList(DataMap param) throws Exception {
		return selectPagingList(mapper.concat("searchAdminReceptionAllList"), param);
	}
	
	
	

	
	
}
