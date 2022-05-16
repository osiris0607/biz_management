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


import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;


@Service("HomeBoardService")
public class HomeBoardService {
	
	@Autowired
	private HomeBoardDao homeBoardDao;
	@Autowired
	private UploadFileService uploadFileService;

	/*
	 * 홈페이지  board 등록
	 */
	@Transactional
	public boolean registration(HomeBoardVO vo) throws Exception {
		// board_id 값을 먼저 얻어서 file relative에 넣어야 하므로 먼저 insert 한다.
		int result = homeBoardDao.insertInfo(vo);
		if ( result <= 0) {
			return false;
		}
		
		// 연관된 업로드 파일 Insert
		if (vo.getUpload_attach_file() != null) {
			for (int i=0; i<vo.getUpload_attach_file().length; i++) {
				if (vo.getUpload_attach_file()[i].getSize() > 0 ) {
					// 나머지 정보는 Upload File Table에 저장
					String fileName = vo.getUpload_attach_file()[i].getOriginalFilename();
					UploadFileVO uploadFileVO  = new UploadFileVO();
					uploadFileVO.setName(fileName);
					uploadFileVO.setBinary_content(vo.getUpload_attach_file()[i].getBytes());
					uploadFileService.registration(uploadFileVO);
					
					// 실제  정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
					vo.setFile_id(uploadFileVO.getFile_id());
					vo.setFile_type("D");
					homeBoardDao.insertRelativeFileInfo(vo);
				}
			}
		}
		
		// 연관된 img 파일 Insert
		if (vo.getUpload_image_file() != null) {
			for (int i=0; i<vo.getUpload_image_file().length; i++) {
				if (vo.getUpload_image_file()[i].getSize() > 0 ) {
					// 나머지 정보는 Upload File Table에 저장
					String fileName = vo.getUpload_image_file()[i].getOriginalFilename();
					UploadFileVO uploadFileVO  = new UploadFileVO();
					uploadFileVO.setName(fileName);
					uploadFileVO.setBinary_content(vo.getUpload_image_file()[i].getBytes());
					uploadFileService.registration(uploadFileVO);
					
					// 실제 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
					vo.setFile_id(uploadFileVO.getFile_id());
					vo.setFile_type("P");
					homeBoardDao.insertRelativeFileInfo(vo);
				}
			}
		}
		return true;
	}
	/*
	 * 수정
	 */
	@Transactional
	public boolean modification(HomeBoardVO vo) throws Exception 
	{
		// 사진 파일 Binary로 DB 저장
		if ( homeBoardDao.updateInfo(vo) <= 0) {
			return false;
		}
		
		// 연관된 업로드 파일 Insert
		if (vo.getUpload_attach_file() != null) {
			for (int i=0; i<vo.getUpload_attach_file().length; i++) {
				if (vo.getUpload_attach_file()[i].getSize() > 0 ) {
					// 나머지 정보는 Upload File Table에 저장
					String fileName = vo.getUpload_attach_file()[i].getOriginalFilename();
					UploadFileVO uploadFileVO  = new UploadFileVO();
					uploadFileVO.setName(fileName);
					uploadFileVO.setBinary_content(vo.getUpload_attach_file()[i].getBytes());
					uploadFileService.registration(uploadFileVO);
					
					// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
					vo.setFile_id(uploadFileVO.getFile_id());
					vo.setFile_type("D");
					homeBoardDao.insertRelativeFileInfo(vo);
				}
			}
		}
		
		// 연관된 img 파일 Insert
		if (vo.getUpload_image_file() != null) {
			for (int i=0; i<vo.getUpload_image_file().length; i++) {
				if (vo.getUpload_image_file()[i].getSize() > 0 ) {
					// 나머지 정보는 Upload File Table에 저장
					String fileName = vo.getUpload_image_file()[i].getOriginalFilename();
					UploadFileVO uploadFileVO  = new UploadFileVO();
					uploadFileVO.setName(fileName);
					uploadFileVO.setBinary_content(vo.getUpload_image_file()[i].getBytes());
					uploadFileService.registration(uploadFileVO);
					
					// 실제 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
					vo.setFile_id(uploadFileVO.getFile_id());
					vo.setFile_type("P");
					homeBoardDao.insertRelativeFileInfo(vo);
				}
			}
		}
		
		// 삭제된 파일 정보 삭제
		if (vo.getDelete_file_list() != null && vo.getDelete_file_list().size() > 0) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(vo.getDelete_file_list());
			uploadFileService.withdrawal(searchVO);
			
			homeBoardDao.deleteRelativeInfoWithFileId(vo);
		}
		
		return true;
	}
	/*
	 * 공지사항 삭제
	 */
	@Transactional
	public boolean delete(HomeBoardVO vo) throws Exception 
	{
		for (Integer id : vo.getDelete_ids())
		{
			HomeBoardVO deleteVo = new HomeBoardVO();
			deleteVo.setBoard_id(id);
			// 파일 삭제
			List<Integer> uploadFileIds = homeBoardDao.selectRelativeFileInfo(deleteVo);
			if ( uploadFileIds != null && uploadFileIds.size() > 0) {
				UploadFileVO searchVO = new UploadFileVO();
				searchVO.setSerach_file_ids(uploadFileIds);
				uploadFileService.withdrawal(searchVO);		
			}
			// home_board_File_relative 삭제
			homeBoardDao.deleteRelativeInfo(deleteVo);
			//  공지사항 삭제
			if ( homeBoardDao.deleteInfo(deleteVo) <= 0) {
				return false;
			}
		}
		
		return true;
	}
	/*
	 * 공지사항 검색
	 */
	@Transactional
	public List<HomeBoardVO> searchPagingList(HomeBoardVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());

		if ( StringUtils.isEmpty(vo.getKeyword()) == false ) {
			search.put("keyword", vo.getKeyword());	
		}
		if ( StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		if ( StringUtils.isEmpty(vo.getBoard_type()) == false ) {
			search.put("board_type", vo.getBoard_type());	
		}
		if ( StringUtils.isEmpty(vo.getOpen_yn()) == false ) {
			search.put("open_yn", vo.getOpen_yn());	
		}
		if ( StringUtils.isEmpty(vo.getTitle()) == false ) {
			search.put("title", vo.getTitle());	
		}
		if ( StringUtils.isEmpty(vo.getDescription()) == false ) {
			search.put("description", vo.getDescription());	
		}
		List<HomeBoardVO> returnList = homeBoardDao.selectSearchPagingList(new DataMap(search));

		return returnList;
	}
	/*
	 * 공지사항 검색
	 */
	@Transactional
	public List<HomeBoardVO> searchPagingListWithImage(HomeBoardVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());

		if ( StringUtils.isEmpty(vo.getKeyword()) == false ) {
			search.put("keyword", vo.getKeyword());	
		}
		if ( StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		if ( StringUtils.isEmpty(vo.getBoard_type()) == false ) {
			search.put("board_type", vo.getBoard_type());	
		}
		if ( StringUtils.isEmpty(vo.getOpen_yn()) == false ) {
			search.put("open_yn", vo.getOpen_yn());	
		}
		if ( StringUtils.isEmpty(vo.getTitle()) == false ) {
			search.put("title", vo.getTitle());	
		}
		if ( StringUtils.isEmpty(vo.getInstitue_name()) == false ) {
			search.put("institue_name", vo.getInstitue_name());	
		}
		if ( StringUtils.isEmpty(vo.getBusiness_name()) == false ) {
			search.put("business_name", vo.getBusiness_name());	
		}
		
		List<HomeBoardVO> returnList = homeBoardDao.selectSearchPagingList(new DataMap(search));
		// 이미지 파일을 얻어온다.
		for ( HomeBoardVO item : returnList) 
		{
			// 등록된 Upload File 중에서 Picture를 찾는다.
			item.setFile_type("P");
			List<Integer> uploadFileInfo = homeBoardDao.selectRelativeFileInfo(item);
			if (uploadFileInfo.size() > 0 ) {
				UploadFileVO searchVO = new UploadFileVO();
				searchVO.setSerach_file_ids(uploadFileInfo);
				List<UploadFileVO> uploadFileList = uploadFileService.selectSearchList(searchVO);
				if ( uploadFileList != null ) {
					item.setReturn_upload_image_file_info(uploadFileList);
				}
			}
		}

		return returnList;
	}

	/*
	 * 상세
	 */
	@Transactional
	public HomeBoardVO detail(HomeBoardVO vo) throws Exception {
		HomeBoardVO returnVO = homeBoardDao.selectDetail(vo);
		
		// 등록된 Upload File 중에서 Document를 찾는다.
		vo.setFile_type("D");
		List<Integer> uploadFileInfo = homeBoardDao.selectRelativeFileInfo(vo);
		if (uploadFileInfo.size() > 0 ) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(uploadFileInfo);
			List<UploadFileVO> uploadFileList = uploadFileService.selectSearchList(searchVO);
			if ( uploadFileList != null ) {
				returnVO.setReturn_upload_attach_file_info(uploadFileList);
			}
		}
		
		// 등록된 Upload File 중에서 Picture를 찾는다.
		vo.setFile_type("P");
		List<Integer> uploadFileInfo2 = homeBoardDao.selectRelativeFileInfo(vo);
		if (uploadFileInfo2.size() > 0 ) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(uploadFileInfo2);
			List<UploadFileVO> uploadFileList = uploadFileService.selectSearchList(searchVO);
			if ( uploadFileList != null ) {
				returnVO.setReturn_upload_image_file_info(uploadFileList);
			}
		}
		
		// HIT수 증가
		if ( vo.getHits() > 0 )
		{
			homeBoardDao.updateInfo(vo);
		}
		
		return returnVO;
	}
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
