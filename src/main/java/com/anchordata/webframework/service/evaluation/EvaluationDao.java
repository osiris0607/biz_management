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
package com.anchordata.webframework.service.evaluation;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;


@Repository("EvaluationDao")
public class EvaluationDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("evaluation.");
	

	/**
	 *  평가 등록
	 */
	public int insertInfo(EvaluationVO vo) throws Exception{
		return update(mapper.concat("insertInfo"), vo);
	}
	/**
	 * 평가 상세 정보 (EvaluationSearchVO)
	 */
	public EvaluationVO selectDetail(EvaluationSearchVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * 평가 상세 정보 (EvaluationVO)
	 */
	public EvaluationVO selectDetail(EvaluationVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * 평가 검색
	 */
	public List<EvaluationVO> selectSearchPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param);
	}
	/**
	 * 평가 항목에 평가워원으로 선정된 평가위원 Pagination 리스트 검색
	 */
	public List<EvaluationCommissionerVO> searchRelatedIDPagingList(DataMap param, int rowCount) throws Exception{
		return selectPagingList(mapper.concat("searchRelatedIDPagingList"), param, rowCount);
	}
	/**
	 * 평가 항목에 평가워원으로 선정된 평가위원 전체 리스트 검색
	 */
	public List<EvaluationCommissionerVO> searchRelatedCommissionerList(EvaluationCommissionerVO vo) throws Exception{
		return selectList(mapper.concat("searchRelatedCommissionerList"), vo);
	}
	/**
	 * 평가워원으로 선정된 평가 항목 리스트 검색
	 */
	public List<EvaluationVO> searchRelatedEvaluationPagingList(DataMap param, int rowCount) throws Exception{
		return selectPagingList(mapper.concat("searchRelatedEvaluationPagingList"), param, rowCount);
	}
	/**
	 * 평가 번호 업데이트
	 */
	public int updateEvaluationNumber(EvaluationVO vo) throws Exception{
		return update(mapper.concat("updateEvaluationNumber"), vo);
	}
	/**
	 * 평가 번호 초기화
	 */
	public int updateClearEvaluationNumber(EvaluationVO vo) throws Exception{
		return update(mapper.concat("updateClearEvaluationNumber"), vo);
	}
	/**
	 * 평가 정보 업데이트
	 */
	public int updateEvaluationInfo(EvaluationVO vo) throws Exception{
		return update(mapper.concat("updateEvaluationInfo"), vo);
	}
	/**
	 * 메일 전송 정보 업데이트
	 */
	public int updateMailInfo(EvaluationVO vo) throws Exception{
		return update(mapper.concat("updateMailInfo"), vo);
	}
	/**
	 * STATUS 업데이트
	 */
	public int updateStatus(EvaluationVO vo) throws Exception{
		return update(mapper.concat("updateStatus"), vo);
	}
	/**
	 *  평가 항목에 해당하는 평가위원 등록
	 */
	public int insertEvaluationCommissionerRelationInfo(EvaluationVO vo) throws Exception{
		return update(mapper.concat("insertEvaluationCommissionerRelationInfo"), vo);
	}
	/**
	 * 연게된 평가위원 존재 시 삭제 
	 */
	public int deleteEvaluationCommissionerRelationInfo(EvaluationVO vo) throws Exception{
		return delete(mapper.concat("deleteEvaluationCommissionerRelationInfo"), vo);
	}
	/**
	 * 평가에 포함되어 있는 평가위원 데이터 업데이트
	 */
	public int updateEvaluationCommissionerRelationInfo(EvaluationCommissionerVO vo) throws Exception{
		return update(mapper.concat("updateEvaluationCommissionerRelationInfo"), vo);
	}
	/**
	 * 평가 상세 정보
	 */
	public EvaluationVO selectStatusInfo(EvaluationVO vo) throws Exception{
		return selectOne(mapper.concat("selectStatusInfo"), vo);
	}
	/**
	 * 평가 상세 페이지에서 업데이트
	 */
	public int updateDetailInfo(EvaluationVO vo) throws Exception{
		return update(mapper.concat("updateDetailInfo"), vo);
	}
	/**
	 * 평가위원 위원장 선임된 평가 항목 업데이트
	 */
	public int updateEvaluationChairmanYN(EvaluationCommissionerVO vo) throws Exception{
		return update(mapper.concat("updateEvaluationChairmanYN"), vo);
	}
	/**
	 * 평가_평가위원_Relation 데이터 업데이트 (싸인 / 싸인 사용여부 /  위원장 선임)
	 */
	public int updateEvaluationCommissionerInfo(EvaluationCommissionerVO vo) throws Exception{
		return update(mapper.concat("updateEvaluationCommissionerInfo"), vo);
	}
	/**
	 * 평가에 선정된 평가위원 상세 정보 (EvaluationCommissioner)
	 */
	public EvaluationCommissionerVO selectEvaluationCommissionerDetail(EvaluationCommissionerVO vo) throws Exception{
		return selectOne(mapper.concat("selectEvaluationCommissionerDetail"), vo);
	}
	/**
	 * 평가항목 등록
	 */
	public int insertItem(EvaluationItemVO vo) throws Exception{
		return update(mapper.concat("insertItem"), vo);
	}
	/**
	 * 평가항목 삭제
	 */
	public int deleteItem(EvaluationItemVO vo) throws Exception{
		return delete(mapper.concat("deleteItem"), vo);
	}
	/**
	 * 과제에 연결된 평가 항목으로 등록
	 */
	public int insertReleatedItem(EvaluationItemVO vo) throws Exception{
		return update(mapper.concat("insertReleatedItem"), vo);
	}
	/**
	 * 과제에 할당된 평가항목 삭제
	 */
	public int deleteReleatedItem(EvaluationItemVO vo) throws Exception{
		return delete(mapper.concat("deleteReleatedItem"), vo);
	}
	/**
	 * 평가 과제에 할당된 평가 항목 검색
	 */
	public List<Map<String, Object>> selectReleatedItemList(EvaluationItemVO vo) throws Exception{
		List<Map<String, Object>> result = selectList(mapper.concat("selectReleatedItemList"), vo);
		return result;
//		return selectList(mapper.concat("selectReleatedItemList"), vo);
	}
	/**
	 * 평가 과제에 할당되지 않은 평가 항목 검색
	 */
	public List<Map<String, Object>> selectUnreleatedItemList(EvaluationItemVO vo) throws Exception{
		return selectList(mapper.concat("selectUnreleatedItemList"), vo);
	}
	/**
	 * 과제 평가 항목 flag 업데이트
	 */
	public int updateItemCompleteYN(EvaluationItemVO vo) throws Exception{
		return update(mapper.concat("updateItemCompleteYN"), vo);
	}
	/**
	 * 엑셀 다운로드용 전체 평가 데이터
	 */
	public List<EvaluationVO> searchExcelDownload(DataMap param) throws Exception{
		return selectList(mapper.concat("searchExcelDownload"), param);
	}
	
	
	
	
}
