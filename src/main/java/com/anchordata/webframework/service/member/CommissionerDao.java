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
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;


@Repository("CommissionerDao")
public class CommissionerDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("commissioner.");
	
	/**
	 * 평가위원 등록
	 */
	public int insertInfo(CommissionerVO vo) throws Exception{
		return update(mapper.concat("insertInfo"), vo);
	}
	/**
	 * 평가위원 수정
	 */
	public int updateInfo(CommissionerVO vo) throws Exception{
		return update(mapper.concat("updateInfo"), vo);
	}
	/**
	 * 평가위원 삭제
	 */
	public int deleteInfo(CommissionerVO vo) throws Exception{
		return delete(mapper.concat("deleteInfo"), vo);
	}
	/**
	 * 평가위원 검색
	 */
	public List<CommissionerVO> selectSearchPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param);
	}
	/**
	 * 평가위원 검색 Row Count
	 */
	public List<CommissionerVO> selectSearchPagingList(DataMap param, int rowCount) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param, rowCount);
	}
	/**
	 * 평가위원 상세
	 */
	public CommissionerVO selectDetail(CommissionerVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * 평가위원 상태 변경
	 */
	public int updateCommissionerStatus(CommissionerVO vo) throws Exception{
		return update(mapper.concat("updateCommissionerStatus"), vo);
	}
	/**
	 * 평가위원 REMARK 변경
	 */
	public int updateCommissionerRemark(CommissionerVO vo) throws Exception{
		return update(mapper.concat("updateCommissionerRemark"), vo);
	}
	/**
	 * 평가위원 상태 삭제
	 */
	public int deleteCommissionerInfo(CommissionerVO vo) throws Exception{
		return delete(mapper.concat("deleteCommissionerInfo"), vo);
	}
	
	/**
	 *  소속 기관 유형별 평가위원 수 (개인/기업/학교/연구원/공공기관/기타(협/단체 등))
	 */
	public CommissionerVO selectInstitutionTypeCount(CommissionerSearchVO vo) throws Exception{
		return selectOne(mapper.concat("selectInstitutionTypeCount"), vo);
	}
	/**
	 * Institution_type별 Count만큼 평가위원 자동 추출
	 */
	public List<CommissionerVO> selecteCommissionerWithCountWithRandom(CommissionerVO vo) throws Exception{
		return selectList(mapper.concat("selecteCommissionerWithCountWithRandom"), vo);
	}
	/**
	 * 은행 정보 변경
	 */
	public int updateBankInfo(CommissionerVO vo) throws Exception{
		return update(mapper.concat("updateBankInfo"), vo);
	}
	/**
	 * 평가 항목 결과 삭제
	 */
	public int deleteCommissionerEvaluationItemInfo(CommissionerEvaluationItemVO vo) throws Exception{
		return delete(mapper.concat("deleteCommissionerEvaluationItemInfo"), vo);
	}
	/**
	 * 평가 항목 결과 등록
	 */
	public int insertCommissionerEvaluationItemInfo(CommissionerEvaluationItemVO vo) throws Exception{
		return update(mapper.concat("insertCommissionerEvaluationItemInfo"), vo);
	}
	/**
	 *  평가 항목 결과 상세 조회
	 */
	public List<Map<String, Object>> selectEvaluationResultItemDetail(CommissionerEvaluationItemVO vo) throws Exception{
		List<Map<String, Object>> result = selectList(mapper.concat("selectEvaluationResultItemDetail"), vo);
		
		return result;
	}
	
	
	public List<CommissionerVO> searchExcelDownload() throws Exception{
		return selectList(mapper.concat("searchExcelDownload"));
	}
	
	
	
}
