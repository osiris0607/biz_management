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

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.evaluation.EvaluationSearchVO;
import com.anchordata.webframework.service.evaluation.EvaluationVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;

@Service("ExecutionService")
public class ExecutionService {
	
	@Autowired
	private ExecutionDao executionDao;
	@Autowired
	private UploadFileService uploadFileService;
	
	
	/**
	 * 수행 정보 등록
	 */
	@Transactional
	public int registration(ExecutionVO vo) throws Exception {
		// 협약 정보 Insert
		int result = executionDao.insertInfo(vo);
		return result;
	}
	/**
	 * 수행 정보 검색
	 */
	@Transactional
	public List<ExecutionVO> searchPagingList(ExecutionSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false  ) {
			search.put("member_id", vo.getMember_id());	
		}
		if (  StringUtils.isEmpty(vo.getExecution_status()) == false  ) {
			search.put("agreement_status", vo.getExecution_status());	
		}
		if (  StringUtils.isEmpty(vo.getSearch_text()) == false ) {
			search.put("search_text", vo.getSearch_text());	
		}
		if (  StringUtils.isEmpty(vo.getExecution_from()) == false ) {
			search.put("execution_from", vo.getExecution_from());	
		}
		if (  StringUtils.isEmpty(vo.getExecution_to()) == false ) {
			search.put("execution_to", vo.getExecution_to());	
		}
		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		if (  StringUtils.isEmpty(vo.getResearch_date()) == false ) {
			search.put("research_date", vo.getResearch_date());	
		}
		if (  StringUtils.isEmpty(vo.getExecution_status()) == false ) {
			search.put("execution_status", vo.getExecution_status());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		return executionDao.selectSearchPagingList(new DataMap(search));
	}
	/**
	 * 수행 정보 상세
	 */
	@Transactional
	public ExecutionVO searchDetail(ExecutionSearchVO vo) throws Exception {
		// 수행 정보 검색
		ExecutionVO returnVO = executionDao.selectDetail(vo);
		
		// 수행 변경 내역 검색
		List<Map<String, Object>> returnMap = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultMap = executionDao.selectChanges(vo);
		for ( Map<String, Object> item : resultMap ) {
			Map<String, Object> origin = item;
			Map<String, Object> temp = new HashMap<String, Object>();   
			  
			Set<String> set = origin.keySet();
			Iterator<String> e = set.iterator();

			while(e.hasNext()){
				String key = e.next();
				Object value = (Object) origin.get(key);
				temp.put(key.toLowerCase(), value);
		   }
			
			returnMap.add(temp);
		}
		
		if ( returnMap != null && returnMap.size()>0) {
			returnVO.setChanges_list(returnMap);
		}
		
		// 수행 연관된 파일 검색
		List<Integer> uploadFileInfo = executionDao.selectFileInfo(vo);
		if (uploadFileInfo.size() > 0 ) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(uploadFileInfo);
			List<UploadFileVO> uploadFileList = uploadFileService.selectSearchList(searchVO);
			if ( uploadFileList != null ) {
				returnVO.setReturn_upload_files(uploadFileList);
			}
		}
		return returnVO;
	}
	/**
	 * 협약 정보 수정
	 */
	@Transactional
	public int modification(ExecutionVO vo) throws Exception {
		// 제출 서류 기타 업로드
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
					executionDao.insertFileInfo(vo);
				}
			}
		}
		// 제출 서류 기타 삭제
		if (vo.getDelete_file_list() != null && vo.getDelete_file_list().size() > 0) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(vo.getDelete_file_list());
			uploadFileService.withdrawal(searchVO);
			
			executionDao.deleteFileWithIds(vo);
		}
		// 중간보고서 Upload File 있을 시 업로드
		if (vo.getMiddle_report_file() != null && vo.getMiddle_report_file().getSize()>0 ) {
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getMiddle_report_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getMiddle_report_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setMiddle_report_file_id(uploadFileVO.getFile_id());
			
			Date today = new Date();
			SimpleDateFormat simpleDateFormat  = new SimpleDateFormat("yyyy-MM-dd");
			vo.setMiddle_report_date(simpleDateFormat.format(today));
		}
		// 최종보고서 Upload File 있을 시 업로드
		if (vo.getFinal_report_file() != null && vo.getFinal_report_file().getSize()>0 ) {
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getFinal_report_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getFinal_report_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setFinal_report_file_id(uploadFileVO.getFile_id());
			
			Date today = new Date();
			SimpleDateFormat simpleDateFormat  = new SimpleDateFormat("yyyy-MM-dd");
			vo.setFinal_report_date(simpleDateFormat.format(today));
		}
		
		// 협약 정보 Insert
		int result = executionDao.updateInfo(vo);
		return result;
	}
	/**
	 * 수행 정보 등록
	 */
	@Transactional
	public int changeHistoryRegistration(ExecutionVO vo) throws Exception {
		// 변경 이력 업로드 파일
		if (vo.getUpload_change_files() != null) {
			for (int i=0; i<vo.getUpload_change_files().length; i++) {
				if (vo.getUpload_change_files()[i].getSize() > 0 ) {
					// 나머지 정보는 Upload File Table에 저장
					String fileName = vo.getUpload_change_files()[i].getOriginalFilename();
					UploadFileVO uploadFileVO  = new UploadFileVO();
					uploadFileVO.setName(fileName);
					uploadFileVO.setBinary_content(vo.getUpload_change_files()[i].getBytes());
					uploadFileService.registration(uploadFileVO);
					
					// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
					vo.setFile_id(uploadFileVO.getFile_id());
					vo.setChanges(vo.getChange_contents_list().get(i));
					executionDao.insertChangeHistoryInfo(vo);
				}
			}
			return 1;
		} else {
			return -1;
		}
	}
	
	
	public List<ExecutionVO> searchExcelDownload(ExecutionSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		
		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false  ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		
		return executionDao.searchExcelDownload(new DataMap(search));
	}
	
	
}
