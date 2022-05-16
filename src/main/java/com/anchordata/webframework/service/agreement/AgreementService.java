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


import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.calculation.CalculationService;
import com.anchordata.webframework.service.calculation.CalculationVO;
import com.anchordata.webframework.service.execution.ExecutionSearchVO;
import com.anchordata.webframework.service.execution.ExecutionService;
import com.anchordata.webframework.service.execution.ExecutionVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;

@Service("AgreementService")
public class AgreementService {
	
	@Autowired
	private AgreementDao agreementDao;
	@Autowired
	private UploadFileService uploadFileService;
	@Autowired
	private ExecutionService executionService;
	@Autowired
	private CalculationService calculationService;
	
	
	
	/**
	 * 협약 정보 등록
	 */
	@Transactional
	public int registration(AgreementVO vo) throws Exception {
		// 협약 정보 Insert
		int result = agreementDao.insertInfo(vo);
		return result;
	}
	/**
	 * 협약 정보 수정
	 */
	@Transactional
	public int modification(AgreementVO vo) throws Exception {
		// 협약에 괸련된 연구원 정보 삭제
		agreementDao.deleteResearcherInfo(vo);
		// 협약에 괸련된 연구원 정보 등록
		if (vo.getAgreement_researcher_list() != null && vo.getAgreement_researcher_list().size() > 0 ) {
			agreementDao.insertResearcherInfo(vo);
		}
		// 협약에 괸련된 연구비 정보 삭제
		agreementDao.deleteFundDetailInfo(vo);
		// 협약에 괸련된 연구비 정보 등록
		if (vo.getAgreement_fund_detail_list() != null && vo.getAgreement_fund_detail_list().size() > 0) {
			agreementDao.insertFundDetailInfo(vo);
		}
		
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
					agreementDao.insertRelativeFileInfo(vo);
				}
			}
		}
		// 제출 서류 기타 삭제
		if (vo.getDelete_file_list() != null && vo.getDelete_file_list().size() > 0) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(vo.getDelete_file_list());
			uploadFileService.withdrawal(searchVO);
			
			agreementDao.deleteFileWithIds(vo);
		}
		// 제출 서류 계획서 Upload File 있을 시 업로드
		if (vo.getUpload_plan_file() != null && vo.getUpload_plan_file().getSize()>0 ) {
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getUpload_plan_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getUpload_plan_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setUpload_plan_file_id(uploadFileVO.getFile_id());
		}
		// 제출 서류 협약서 Upload File 있을 시 업로드
		if (vo.getUpload_agreement_file() != null && vo.getUpload_agreement_file().getSize()>0 ) {
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getUpload_agreement_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getUpload_agreement_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setUpload_agreement_file_id(uploadFileVO.getFile_id());
		}
		
		// 협약 정보 Insert
		int result = agreementDao.updateInfo(vo);
		return result;
	}
	/**
	 * 협약 정보 검색
	 */
	@Transactional
	public List<AgreementVO> searchPagingList(AgreementSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false  ) {
			search.put("member_id", vo.getMember_id());	
		}
		if (  StringUtils.isEmpty(vo.getAgreement_status()) == false  ) {
			search.put("agreement_status", vo.getAgreement_status());	
		}
		if (  StringUtils.isEmpty(vo.getSearch_text()) == false ) {
			search.put("search_text", vo.getSearch_text());	
		}
		if (  StringUtils.isEmpty(vo.getEvaluation_from()) == false ) {
			search.put("evaluation_from", vo.getEvaluation_from());	
		}
		if (  StringUtils.isEmpty(vo.getEvaluation_to()) == false ) {
			search.put("evaluation_to", vo.getEvaluation_to());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		if (  StringUtils.isEmpty(vo.getResearch_date()) == false ) {
			search.put("research_date", vo.getResearch_date());	
		}
		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		
		return agreementDao.selectSearchPagingList(new DataMap(search));
	}
	/**
	 * 협약 번호 생성
	 */
	@Transactional
	public String createAgreementNumber() throws Exception {
		// 평가번호 생성
		Calendar cal = Calendar.getInstance();
		//현재 년도, 월, 일
		int year = cal.get ( Calendar.YEAR );
		int month = cal.get ( Calendar.MONTH ) + 1 ;
		int date = cal.get ( Calendar.DATE ) ;
		String monthString = String.format("%02d", month);
		String dateString = String.format("%02d", date);
		// 랜덤 6자리	
       Random generator = new Random();
       generator.setSeed(System.currentTimeMillis());
       String randString = String.format("%06d", generator.nextInt(1000000));
       
		// 협약 번호 생성
		String agreementNumber = "";
		agreementNumber += "AG" + Integer.toString(year) + monthString + dateString + randString;

		return agreementNumber;
	}
	/**
	 * 협약 정보 상세
	 */
	@Transactional
	public AgreementVO searchDetail(AgreementSearchVO vo) throws Exception {
		// 협약 정보 검색
		AgreementVO returnVO = agreementDao.selectDetail(vo);
		// 협약에 연관된 연구원 검색
		List<AgreementResearcherVO> researcher = agreementDao.selectResearcher(vo);
		returnVO.setAgreement_researcher_list(researcher);
		// 협약에 연관된 연구비 검색
		List<AgreementFundDetailVO> fundDetail = agreementDao.selectFundDetail(vo);
		returnVO.setAgreement_fund_detail_list(fundDetail);
		// 협약에 연관된 파일 검색
		List<Integer> uploadFileInfo = agreementDao.selectFileInfo(vo);
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
	 * 협약 Status 정보 업데이트
	 */
	@Transactional
	public int modificationStatus(AgreementVO vo) throws Exception {
		// D0000005 협약 승인 완료이면 협약 번호를 생성하여 입력한다.
		
		if ( StringUtils.isEmpty(vo.getAgreement_status()) == false && vo.getAgreement_status().equals("D0000005") ) {
			vo.setAgreement_reg_number(createAgreementNumber());
		}
		
		int result = agreementDao.updateInfo(vo);
		
		// 협약 완료이면 수행 / 정산에 데이터를 생성한다.
		if ( result > 0 && vo.getAgreement_status().equals("D0000005") ) {
			// 수행
			ExecutionVO excetionVO = new ExecutionVO();
			excetionVO.setReception_id(vo.getReception_id());
			excetionVO.setAgreement_id(vo.getAgreement_id());
			excetionVO.setExecution_status("수행중");
			executionService.registration(excetionVO);
			
			// 정산
			CalculationVO calculationVO = new CalculationVO();
			calculationVO.setReception_id(vo.getReception_id());
			calculationVO.setAgreement_id(vo.getAgreement_id());
			calculationVO.setCalculation_status("미정산");
			calculationService.registration(calculationVO);
		}
		return result;
	}

	public List<AgreementVO> searchExcelDownload(AgreementSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		
		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false  ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		
		return agreementDao.searchExcelDownload(new DataMap(search));
	}
	
	

	
}
