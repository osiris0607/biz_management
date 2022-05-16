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
package com.anchordata.webframework.service.execution;


import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;


@Repository("ExecutionDao")
public class ExecutionDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("execution.");
	/**
	 *  수행 등록
	 */
	public int insertInfo(ExecutionVO vo) throws Exception{
		return update(mapper.concat("insertInfo"), vo);
	}
	/**
	 * 수행 리스트 검색
	 */
	public List<ExecutionVO> selectSearchPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param);
	}
	/**
	 * 수행 상세 정보
	 */
	public ExecutionVO selectDetail(ExecutionSearchVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	/**
	 * 수행 연관된 업로드 파일 Insert
	 */
	public int insertFileInfo(ExecutionVO vo) throws Exception{
		return update(mapper.concat("insertFileInfo"), vo);
	}
	/**
	 * 수행 연계된 파일 검색
	 */
	public List<Integer> selectFileInfo(ExecutionSearchVO vo) throws Exception{
		return selectList(mapper.concat("selectFileInfo"), vo);
	}
	/**
	 * 수행 연관된 업로드 파일 삭제
	 */
	public int deleteFileWithIds(ExecutionVO vo) throws Exception{
		return delete(mapper.concat("deleteFileWithIds"), vo);
	}
	/**
	 * 수행 변경 이력
	 */
	public List<Map<String, Object>> selectChanges(ExecutionSearchVO vo) throws Exception{
		return selectList(mapper.concat("selectChanges"), vo);
	}
	/**
	 * 수행 업데이트
	 */
	public int updateInfo(ExecutionVO vo) throws Exception{
		return update(mapper.concat("updateInfo"), vo);
	}
	/**
	 * 변경 내역 저장
	 */
	public int insertChangeHistoryInfo(ExecutionVO vo) throws Exception{
		return update(mapper.concat("insertChangeHistoryInfo"), vo);
	}
	
	/**
	 * 엑셀 다운로드용 전체 평가 데이터
	 */
	public List<ExecutionVO> searchExcelDownload(DataMap param) throws Exception{
		return selectList(mapper.concat("searchExcelDownload"), param);
	}
	
	
	
	
}
