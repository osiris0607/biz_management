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


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;


@Service("AnnouncementService")
public class AnnouncementService {
	
	@Autowired
	private AnnouncementDao announcementDao;
	@Autowired
	private UploadFileService uploadFileService;
	
	/**
	 * 공고 등록
	 */
	@Transactional
	public int registration(AnnouncementVO vo) throws Exception {
		// 일반 데이터 입력
		announcementDao.insertInfo(vo);
		// 연관된 업로드 파일 Insert
		if (vo.getUpload_files() != null) {
			for (int i=0; i<vo.getUpload_files().length; i++) {
				if (vo.getUpload_files()[i].getSize() > 0 ) {
					// 나머지 정보는 Upload File Table에 저장
					String fileName = vo.getUpload_files()[i].getOriginalFilename();
					UploadFileVO uploadFileVO  = new UploadFileVO();
					uploadFileVO.setName(fileName);
					uploadFileVO.setBinary_content(vo.getUpload_files()[i].getBytes());
					uploadFileService.registration(uploadFileVO);
					
					// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
					vo.setFile_id(uploadFileVO.getFile_id());
					announcementDao.insertRelativeFileInfo(vo);
				}
			}
		}
		
		// Extension 정보 입력
		if (vo.getExt_field_list() != null && vo.getExt_field_list().size() > 0) {
			announcementDao.insertExtensionInfo(vo);
		}
		// Check List 정보 입력
		if (vo.getExt_check_list() != null && vo.getExt_check_list().size() > 0) {
			announcementDao.insertCheckListInfo(vo);
		}
		
		return 1;
	}
	
	/**
	 * 검색
	 */
	@Transactional
	public List<AnnouncementVO> searchList(AnnouncementSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getReceipt_from()) == false ) {
			search.put("receipt_from", vo.getReceipt_from());	
		}
		if (  StringUtils.isEmpty(vo.getReceipt_to()) == false ) {
			search.put("receipt_to", vo.getReceipt_to());	
		}
		if (  StringUtils.isEmpty(vo.getRegister()) == false ) {
			search.put("register", vo.getRegister());	
		}
		if (  StringUtils.isEmpty(vo.getManager()) == false ) {
			search.put("manager", vo.getManager());	
		}
		if (  StringUtils.isEmpty(vo.getType()) == false ) {
			search.put("type", vo.getType());	
		}
		if (  StringUtils.isEmpty(vo.getProcess_status()) == false ) {
			search.put("process_status", vo.getProcess_status());	
		}
		if (  StringUtils.isEmpty(vo.getYear()) == false ) {
			search.put("year", vo.getYear());	
		}
		if (  StringUtils.isEmpty(vo.getSearch_text()) == false ) {
			search.put("search_text", vo.getSearch_text());	
		}
		if (  StringUtils.isEmpty(vo.getSearch_date_yn()) == false ) {
			search.put("search_date_yn", vo.getSearch_date_yn());	
		}
		
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		return announcementDao.selectSearchPagingList(new DataMap(search));
	}
	
	/**
	 * 상세
	 */
	@Transactional
	public AnnouncementVO detail(AnnouncementVO vo) throws Exception {
		AnnouncementVO returnVO = announcementDao.selectDetail(vo);
		// 등록된 Upload File을 찾는다.
		List<Integer> uploadFileInfo = announcementDao.selectRelativeFileInfo(vo);
		if (uploadFileInfo.size() > 0 ) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(uploadFileInfo);
			List<UploadFileVO> uploadFileList = uploadFileService.selectSearchList(searchVO);
			if ( uploadFileList != null ) {
				returnVO.setReturn_upload_files(uploadFileList);
			}
		}
		
		// Extension 정보 찾기
		returnVO.setExt_field_list(announcementDao.selectExtensionInfo(vo));
		// check List 정보 찾기
		returnVO.setExt_check_list(announcementDao.selectCheckListInfo(vo));
		// HITS 업데이트
		announcementDao.updateHits(vo);
		
		return returnVO;
	}
	
	/**
	 * 수정
	 */
	@Transactional
	public int modification(AnnouncementVO vo) throws Exception {

		announcementDao.updateInfo(vo);
		
		// 연관된 업로드 파일 Insert
		if (vo.getUpload_files() != null) {
			for (int i=0; i<vo.getUpload_files().length; i++) {
				if (vo.getUpload_files()[i].getSize() > 0 ) {
					// 나머지 정보는 Upload File Table에 저장
					String fileName = vo.getUpload_files()[i].getOriginalFilename();
					UploadFileVO uploadFileVO  = new UploadFileVO();
					uploadFileVO.setName(fileName);
					uploadFileVO.setBinary_content(vo.getUpload_files()[i].getBytes());
					uploadFileService.registration(uploadFileVO);
					
					// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
					vo.setFile_id(uploadFileVO.getFile_id());
					announcementDao.insertRelativeFileInfo(vo);
				}
			}
		}
		// 삭제된 파일 삭제
		if (vo.getDelete_file_list() != null && vo.getDelete_file_list().size() > 0) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(vo.getDelete_file_list());
			uploadFileService.withdrawal(searchVO);
			
			announcementDao.deleteRelativeInfoWithFileId(vo);
		}
		// Extension 정보 update
		if (vo.getExt_field_list() != null && vo.getExt_field_list().size() > 0) {
			announcementDao.updateExtensionInfo(vo);
		}
		// Extension check List 정보 update
		if (vo.getExt_check_list() != null && vo.getExt_check_list().size() > 0) {
			announcementDao.updateCheckListInfo(vo);
		}
		return 1;
	}
	
	/**
	 * 삭제
	 */
	@Transactional
	public int withdrawal(AnnouncementVO vo) throws Exception {
		// upload File 삭제
		List<Integer> uploadFileIds = announcementDao.selectRelativeFileInfo(vo);
		
		if ( uploadFileIds != null && uploadFileIds.size() > 0) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(uploadFileIds);
			uploadFileService.withdrawal(searchVO);		
		}

		// upload File 삭제
		announcementDao.deleteRelativeInfo(vo);
		// Extension  삭제
		announcementDao.deleteExtensionInfo(vo);
		// check List 삭제
		announcementDao.deleteCheckListInfo(vo);
		
		
		// 공고 삭제
		return announcementDao.deleteInfo(vo);
	}
	
	/**
	 * Process Status update
	 */
	@Transactional
	public int updateProcessStatus(AnnouncementVO vo) throws Exception {
		return announcementDao.updateProcessStatus(vo);
	}
	
	
	/**
	 * 공고 메인 페이지의 공고별 갯수 데이터
	 */
	@Transactional
	public Map<String,String> getMainSate() throws Exception {
		return announcementDao.selectMainState();
	}
	
	

}
