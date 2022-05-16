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
package com.anchordata.webframework.service.calculation;


import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.agreement.AgreementVO;


@Repository("CalculationDao")
public class CalculationDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("calculation.");
	/**
	 *  정산 등록
	 */
	public int insertInfo(CalculationVO vo) throws Exception{
		return update(mapper.concat("insertInfo"), vo);
	}
	/**
	 * 정산 리스트 검색
	 */
	public List<CalculationVO> selectSearchPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param);
	}
	/**
	 * 정산 상세 정보
	 */
	public CalculationVO selectDetail(CalculationSearchVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * 정산 업데이트
	 */
	public int updateInfo(CalculationVO vo) throws Exception{
		return update(mapper.concat("updateInfo"), vo);
	}
	/**
	 * 정산에 괸련된 연구비 정보 등록
	 */
	public int insertFundDetailInfo(CalculationVO vo) throws Exception{
		return update(mapper.concat("insertFundDetailInfo"), vo);
	}
	/**
	 * 정산에 괸련된 연구비 정보 검색
	 */
	public List<CalculationFundDetailVO> selectFundDetailInfo(CalculationSearchVO vo) throws Exception{
		return selectList(mapper.concat("selectFundDetailInfo"), vo);
	}
	/**
	 * 정산에 괸련된 연구비 정보 삭제
	 */
	public int deleteFundDetailInfo(CalculationVO vo) throws Exception{
		return delete(mapper.concat("deleteFundDetailInfo"), vo);
	}
	
	/**
	 * 엑셀 다운로드용 전체 평가 데이터
	 */
	public List<CalculationVO> searchExcelDownload(DataMap param) throws Exception{
		return selectList(mapper.concat("searchExcelDownload"), param);
	}
	
	
}
