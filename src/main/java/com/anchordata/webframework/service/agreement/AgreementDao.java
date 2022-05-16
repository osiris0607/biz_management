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
package com.anchordata.webframework.service.agreement;


import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;


@Repository("AgreementDao")
public class AgreementDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("agreement.");
	/**
	 *  협약 등록
	 */
	public int insertInfo(AgreementVO vo) throws Exception{
		return update(mapper.concat("insertInfo"), vo);
	}
	/**
	 * 협약 리스트 검색
	 */
	public List<AgreementVO> selectSearchPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param);
	}
	/**
	 * 협약 상세 정보
	 */
	public AgreementVO selectDetail(AgreementSearchVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * 평가 번호 업데이트
	 */
	public int updateInfo(AgreementVO vo) throws Exception{
		return update(mapper.concat("updateInfo"), vo);
	}
	/**
	 * 협약에 괸련된 연구원 정보 등록
	 */
	public int insertResearcherInfo(AgreementVO vo) throws Exception{
		return update(mapper.concat("insertResearcherInfo"), vo);
	}
	/**
	 * 협약에 괸련된 연구원 정보 삭제
	 */
	public int deleteResearcherInfo(AgreementVO vo) throws Exception{
		return delete(mapper.concat("deleteResearcherInfo"), vo);
	}
	/**
	 * 협약에 괸련된 연구비 정보 등록
	 */
	public int insertFundDetailInfo(AgreementVO vo) throws Exception{
		return update(mapper.concat("insertFundDetailInfo"), vo);
	}
	/**
	 * 협약에 괸련된 연구비 정보 삭제
	 */
	public int deleteFundDetailInfo(AgreementVO vo) throws Exception{
		return delete(mapper.concat("deleteFundDetailInfo"), vo);
	}
	/**
	 * 협약에 연관된 연구원 검색
	 */
	public List<AgreementResearcherVO> selectResearcher(AgreementSearchVO param) throws Exception{
		return selectList(mapper.concat("selectResearcher"), param);
	}
	/**
	 * 협약에 연관된 연구비 검색
	 */
	public List<AgreementFundDetailVO> selectFundDetail(AgreementSearchVO param) throws Exception{
		return selectList(mapper.concat("selectFundDetail"), param);
	}
	/**
	 * 연관된 업로드 파일 Insert
	 */
	public int insertRelativeFileInfo(AgreementVO vo) throws Exception{
		return update(mapper.concat("insertRelativeFileInfo"), vo);
	}
	/**
	 * 협약에 연계된 파일 검색
	 */
	public List<Integer> selectFileInfo(AgreementSearchVO vo) throws Exception{
		return selectList(mapper.concat("selectFileInfo"), vo);
	}
	/**
	 * 연관된 업로드 파일 삭제
	 */
	public int deleteFileWithIds(AgreementVO vo) throws Exception{
		return delete(mapper.concat("deleteFileWithIds"), vo);
	}
	
	/**
	 * 엑셀 다운로드용 전체 평가 데이터
	 */
	public List<AgreementVO> searchExcelDownload(DataMap param) throws Exception{
		return selectList(mapper.concat("searchExcelDownload"), param);
	}

	
	
}
