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
package com.anchordata.webframework.service.notice;


import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;


@Service("NoticeService")
public class NoticeService {
	
	@Autowired
	private NoticeDao noticeDao;
	@Autowired
	private UploadFileService uploadFileService;

	/**
	 * 공지사항 등록
	 */
	@Transactional
	public boolean registration(NoticeVO vo) throws Exception {
		int result = noticeDao.insertNoticeInfo(vo);
		if ( result <= 0) {
			return false;
		}
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
					noticeDao.insertRelativeFileInfo(vo);
				}
			}
		}
		return true;
	}
	/**
	 * 공지 수정
	 */
	@Transactional
	public boolean modification(NoticeVO vo) throws Exception {
		// 사진 파일 Binary로 DB 저장
		if ( noticeDao.updateNoticeInfo(vo) <= 0) {
			return false;
		}
		
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
					noticeDao.insertRelativeFileInfo(vo);
				}
			}
		}
		// 삭제된 파일 삭제
		if (vo.getDelete_file_list() != null && vo.getDelete_file_list().size() > 0) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(vo.getDelete_file_list());
			uploadFileService.withdrawal(searchVO);
			
			noticeDao.deleteRelativeInfoWithFileId(vo);
		}
		
		return true;
	}
	/**
	 * 공지 삭제
	 */
	@Transactional
	public boolean withdrawal(NoticeVO vo) throws Exception {
		// upload File 삭제
		List<Integer> uploadFileIds = noticeDao.selectRelativeFileInfo(vo);
		if ( uploadFileIds != null && uploadFileIds.size() > 0) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(uploadFileIds);
			uploadFileService.withdrawal(searchVO);		
		}

		// upload File 삭제
		if ( noticeDao.deleteRelativeInfo(vo) <= 0) {
			return false;
		}
		// 공고 삭제
		if ( noticeDao.deleteNoticeInfo(vo) <= 0) {
			return false;
		}
		
		return true;
	}
	/**
	 * 상세
	 */
	@Transactional
	public NoticeVO detail(NoticeVO vo) throws Exception {
		NoticeVO returnVO = noticeDao.selectDetail(vo);
		// 등록된 Upload File을 찾는다.
		List<Integer> uploadFileInfo = noticeDao.selectRelativeFileInfo(vo);
		if (uploadFileInfo.size() > 0 ) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(uploadFileInfo);
			List<UploadFileVO> uploadFileList = uploadFileService.selectSearchList(searchVO);
			if ( uploadFileList != null ) {
				returnVO.setReturn_upload_files(uploadFileList);
			}
		}
		// HITS 업데이트
		noticeDao.updateHits(vo);
		
		return returnVO;
	}
	/**
	 * 공지 검색
	 */
	@Transactional
	public List<NoticeVO> searchPagingList(NoticeSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());

		if ( StringUtils.isEmpty(vo.getTitle()) == false ) {
			search.put("title", vo.getTitle());	
		}
		if ( StringUtils.isEmpty(vo.getExplanation()) == false ) {
			search.put("explanation", vo.getExplanation());	
		}
		if ( StringUtils.isEmpty(vo.getTitleExplanation()) == false ) {
			search.put("titleExplanation", vo.getTitleExplanation());	
		}
		if ( StringUtils.isEmpty(vo.getWriter()) == false ) {
			search.put("writer", vo.getWriter());	
		}
		if ( StringUtils.isEmpty(vo.getType()) == false ) {
			search.put("type", vo.getType());	
		}
		if ( StringUtils.isEmpty(vo.getDate_from()) == false ) {
			search.put("date_from", vo.getDate_from());	
		}
		if ( StringUtils.isEmpty(vo.getDate_to()) == false ) {
			search.put("date_to", vo.getDate_to());	
		}
		if ( StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}

		return noticeDao.selectSearchPagingList(new DataMap(search));
	}
	/**
	 * 공지 목록  갯수만큼 최신으로 검색
	 */
	@Transactional
	public List<NoticeVO> countList(String count) throws Exception {
		return noticeDao.selectCountList(count);
	}
	/**
	 * 공지 목록  갯수만큼 최신으로 검색
	 */
	@Transactional
	public List<NoticeVO> preNextList(NoticeSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();

		if (  vo.getNotice_id() != null && vo.getNotice_id().isEmpty() != true ) {
			search.put("notice_id", vo.getNotice_id());	
		}
		if (  vo.getType() != null && vo.getType().isEmpty() != true ) {
			search.put("type", vo.getType());	
		}

		return noticeDao.selectPreNextList(new DataMap(search));
	}
	
}
