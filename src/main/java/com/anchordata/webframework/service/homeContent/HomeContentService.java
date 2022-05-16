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
package com.anchordata.webframework.service.homeContent;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;


@Service("HomeContentService")
public class HomeContentService {
	
	@Autowired
	private HomeContentDao homeContentDao;
	@Autowired
	private UploadFileService uploadFileService;

	/*
	 * 홈페이지  Content 등록
	 */
	@Transactional
	public boolean registration(HomeContentVO vo) throws Exception {
		
		// 연관된 업로드 파일 Insert
		if (vo.getUpload_image_file() != null) {
			if (vo.getUpload_image_file().getSize() > 0 ) {
				// 나머지 정보는 Upload File Table에 저장
				String fileName = vo.getUpload_image_file().getOriginalFilename();
				UploadFileVO uploadFileVO  = new UploadFileVO();
				uploadFileVO.setName(fileName);
				uploadFileVO.setBinary_content(vo.getUpload_image_file().getBytes());
				uploadFileService.registration(uploadFileVO);
				
				// 실제 공고 정보와 연동되는 File은  content table에 Insert한다.
				vo.setImage_file_id(uploadFileVO.getFile_id());
			}
		}
		
		int result = homeContentDao.insertInfo(vo);
		if ( result <= 0) {
			return false;
		}
		
		return true;
	}
	
	/*
	 * 홈페이지  Content 수정
	 */
	@Transactional
	public boolean modification(HomeContentVO vo) throws Exception 
	{
		// 업로드 파일이 있으면 Insert
		if (vo.getUpload_image_file() != null) 
		{
			UploadFileVO uploadFileVO  = new UploadFileVO();
			
			// 업데이트되는 파일이 있으므로 기존 파일은 삭제
			uploadFileVO.setFile_id(vo.getImage_file_id());
			uploadFileService.withdrawal(uploadFileVO);
			
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getUpload_image_file().getOriginalFilename();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getUpload_image_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			
			// 파일 ID 저장
			vo.setImage_file_id(uploadFileVO.getFile_id());
		}
		
		// 사진 파일 Binary로 DB 저장
		if ( homeContentDao.updateInfo(vo) <= 0) {
			return false;
		}

		
		return true;
	}
	
	/*
	 * 홈페이지 Content 삭제
	 */
	@Transactional
	public boolean delete(HomeContentVO vo) throws Exception 
	{
		// upload File 삭제
		UploadFileVO uploadFileVO  = new UploadFileVO();
		uploadFileVO.setFile_id(vo.getImage_file_id());
		uploadFileService.withdrawal(uploadFileVO);

		//  Content 삭제
		if ( homeContentDao.deleteInfo(vo) <= 0) {
			return false;
		}
		
		return true;
	}
	
	/*
	 * 공지 검색
	 */
	@Transactional
	public List<HomeContentVO> searchPagingList(HomeContentVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());

		if ( StringUtils.isEmpty(vo.getKeyword()) == false ) {
			search.put("keyword", vo.getKeyword());	
		}
		if ( StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		if ( StringUtils.isEmpty(vo.getContent_type()) == false ) {
			search.put("content_type", vo.getContent_type());	
		}
		List<HomeContentVO> returnList = homeContentDao.selectSearchPagingList(new DataMap(search));
		
		// 각 Content별 등록된 Upload File을 찾는다.
		for ( HomeContentVO tempVo : returnList)
		{
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setFile_id(tempVo.getImage_file_id());
			UploadFileVO uploadFile = uploadFileService.selectUploadFileContent(searchVO);
			if ( uploadFile != null ) 
			{
				tempVo.setReturn_upload_file_info(uploadFile);
			}
		}

		return returnList;
	}

//	/**
//	 * 상세
//	 */
//	@Transactional
//	public NoticeVO detail(NoticeVO vo) throws Exception {
//		NoticeVO returnVO = noticeDao.selectDetail(vo);
//		// 등록된 Upload File을 찾는다.
//		List<Integer> uploadFileInfo = noticeDao.selectRelativeFileInfo(vo);
//		if (uploadFileInfo.size() > 0 ) {
//			UploadFileVO searchVO = new UploadFileVO();
//			searchVO.setSerach_file_ids(uploadFileInfo);
//			List<UploadFileVO> uploadFileList = uploadFileService.selectSearchList(searchVO);
//			if ( uploadFileList != null ) {
//				returnVO.setReturn_upload_files(uploadFileList);
//			}
//		}
//		// HITS 업데이트
//		noticeDao.updateHits(vo);
//		
//		return returnVO;
//	}
//	/**
//	 * 공지 목록  갯수만큼 최신으로 검색
//	 */
//	@Transactional
//	public List<NoticeVO> countList(String count) throws Exception {
//		return noticeDao.selectCountList(count);
//	}
//	/**
//	 * 공지 목록  갯수만큼 최신으로 검색
//	 */
//	@Transactional
//	public List<NoticeVO> preNextList(NoticeSearchVO vo) throws Exception {
//		HashMap<String, Object> search = new HashMap<String, Object>();
//
//		if (  vo.getNotice_id() != null && vo.getNotice_id().isEmpty() != true ) {
//			search.put("notice_id", vo.getNotice_id());	
//		}
//		if (  vo.getType() != null && vo.getType().isEmpty() != true ) {
//			search.put("type", vo.getType());	
//		}
//
//		return noticeDao.selectPreNextList(new DataMap(search));
//	}
	
}
