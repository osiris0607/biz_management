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
package com.anchordata.webframework.service.homeBoard;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;


@Repository("HomeBoardDao")
public class HomeBoardDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("homeBoard.");
	/*
	 * 등록 
	 */
	public int insertInfo(HomeBoardVO params) throws Exception{
		return update(mapper.concat("insertInfo"), params);
	}
	/*
	 * Paging 검색
	 */
	public List<HomeBoardVO> selectSearchPagingList(DataMap params) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), params);
	}
	/*
	 * 수정 
	 */
	public int updateInfo(HomeBoardVO params) throws Exception{
		return update(mapper.concat("updateInfo"), params);
	}
	/*
	 * 삭제
	 */
	public int deleteInfo(HomeBoardVO params) throws Exception{
		return update(mapper.concat("deleteInfo"), params);
	}
	/*
	 * Relative File 등록 (Multi File 인 경우에 필요)
	 */
	public int insertRelativeFileInfo(HomeBoardVO param) throws Exception{
		return update(mapper.concat("insertRelativeFileInfo"), param);
	}
	/*
	 * Relative File 검색
	 */
	public List<Integer> selectRelativeFileInfo(HomeBoardVO params) throws Exception{
		return selectList(mapper.concat("selectRelativeFileInfo"), params);
	}
	/*
	 * Relative File 삭제
	 */
	public int deleteRelativeInfo(HomeBoardVO params) throws Exception{
		return delete(mapper.concat("deleteRelativeInfo"), params);
	}
	/*
	 * 상세 검색
	 */
	public HomeBoardVO selectDetail(HomeBoardVO params) throws Exception{
		return selectOne(mapper.concat("selectDetail"), params);
	}
	/*
	 * 공지에 연계된 파일 삭제
	 */
	public int deleteRelativeInfoWithFileId(HomeBoardVO params) throws Exception{
		return delete(mapper.concat("deleteRelativeInfoWithFileId"), params);
	}
//	/**
//	 * 공지 사항 HITS 수 업데이트
//	 */
//	public int updateHits(NoticeVO vo) throws Exception{
//		return update(mapper.concat("updateHits"), vo);
//	}
//	/**
//	 * 공지 목록 삭제
//	 */
//	public int updateNoticeBlock(String params) throws Exception{
//		return update(mapper.concat("updateNoticeBlock"), params);
//	}
//	/**
//	 * 공지 목록  갯수만큼 최신으로 검색
//	 */
//	public List<NoticeVO> selectCountList(String count) throws Exception{
//		return selectList(mapper.concat("selectCountList"), Integer.parseInt(count));
//	}
//	/**
//	 * 이전글 / 다음글 처리
//	 */
//	public List<NoticeVO> selectPreNextList(DataMap param) throws Exception{
//		return selectList(mapper.concat("selectPreNextList"), param);
//	}
//	/**
//	 * Main Page에서 노출되야 하는 공지사항
//	 */
//	public int updateMainPageYN(NoticeVO params) throws Exception{
//		return update(mapper.concat("updateMainPageYN"), params);
//	}
//	/**
//	 * 공지에 연계된 파일 등록 (Multi File 인 경우에 필요)
//	 */
//	public int insertRelativeFileInfo(NoticeVO param) throws Exception{
//		return update(mapper.concat("insertRelativeFileInfo"), param);
//	}



	
	
	
}
