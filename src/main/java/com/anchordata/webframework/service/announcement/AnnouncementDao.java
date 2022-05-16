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
package com.anchordata.webframework.service.announcement;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;


@Repository("AnnouncementDao")
public class AnnouncementDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("announcement.");
	
	/**
	 * 등록 
	 */
	public int insertInfo(AnnouncementVO param) throws Exception{
		return update(mapper.concat("insertInfo"), param);
	}
	/**
	 * 수정 
	 */
	public int updateInfo(AnnouncementVO param) throws Exception{
		return update(mapper.concat("updateInfo"), param);
	}
	/**
	 * 공고에 연계된 파일 등록 
	 */
	public int insertRelativeFileInfo(AnnouncementVO param) throws Exception{
		return update(mapper.concat("insertRelativeFileInfo"), param);
	}
	/**
	 * 공고에 연계된 접수 정보 등록
	 */
	public int insertExtensionInfo(AnnouncementVO param) throws Exception{
		return update(mapper.concat("insertExtensionInfo"), param);
	}
	/**
	 * 공고에 연계된 접수 정보 수정
	 */
	public int updateExtensionInfo(AnnouncementVO param) throws Exception{
		return update(mapper.concat("updateExtensionInfo"), param);
	}
	/**
	 * 공고에 연계된 접수 정보 검색
	 */
	public List<AnnouncementExtVO> selectExtensionInfo(AnnouncementVO param) throws Exception{
		return selectList(mapper.concat("selectExtensionInfo"), param);
	}
	/**
	 * 공고에 연계된 체크리스트 정보 등록
	 */
	public int insertCheckListInfo(AnnouncementVO param) throws Exception{
		return update(mapper.concat("insertCheckListInfo"), param);
	}
	/**
	 * 공고에 연계된 접수 정보 수정
	 */
	public int updateCheckListInfo(AnnouncementVO param) throws Exception{
		return update(mapper.concat("updateCheckListInfo"), param);
	}
	/**
	 * 공고에 연계된 체크리스트 정보 검색
	 */
	public List<AnnouncementCheckListVO> selectCheckListInfo(AnnouncementVO param) throws Exception{
		return selectList(mapper.concat("selectCheckListInfo"), param);
	}
	
	/**
	 * Process Status Update
	 */
	public int updateProcessStatus(AnnouncementVO vo) throws Exception{
		return update(mapper.concat("updateProcessStatus"), vo);
	}
	
	/**
	 * 공고 HITS 수 업데이트
	 */
	public int updateHits(AnnouncementVO vo) throws Exception{
		return update(mapper.concat("updateHits"), vo);
	}
	
	
	/**
	 * 검색
	 */
	public List<AnnouncementVO> selectSearchPagingList(DataMap param) throws Exception{
		return selectPagingList(mapper.concat("selectSearchPagingList"), param);
	}
	
	/**
	 * 상세
	 */
	public AnnouncementVO selectDetail(AnnouncementVO vo) throws Exception{
		return selectOne(mapper.concat("selectDetail"), vo);
	}
	
	public List<Integer> selectRelativeFileInfo(AnnouncementVO vo) throws Exception{
		return selectList(mapper.concat("selectRelativeFileInfo"), vo);
	}
	
	/**
	 * 삭제
	 */
	public int deleteInfo(AnnouncementVO params) throws Exception{
		return delete(mapper.concat("deleteInfo"), params);
	}
	
	/**
	 * Relative 삭제
	 */
	public int deleteRelativeInfo(AnnouncementVO params) throws Exception{
		return delete(mapper.concat("deleteRelativeInfo"), params);
	}
	/**
	 * Relative 삭제 With File ID List
	 */
	public int deleteRelativeInfoWithFileId(AnnouncementVO params) throws Exception{
		return delete(mapper.concat("deleteRelativeInfoWithFileId"), params);
	}
	
	
	/**
	 * Extension 삭제
	 */
	public int deleteExtensionInfo(AnnouncementVO params) throws Exception{
		return delete(mapper.concat("deleteExtensionInfo"), params);
	}
	
	/**
	 * check List 삭제
	 */
	public int deleteCheckListInfo(AnnouncementVO params) throws Exception{
		return delete(mapper.concat("deleteCheckListInfo"), params);
	}
	
	/**
	 * Main Page state
	 */
	public Map<String,String> selectMainState() throws Exception{
		return selectOne(mapper.concat("selectMainState"));
	}
	
	
}
