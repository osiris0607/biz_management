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
package com.anchordata.webframework.service.calculation;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.agreement.AgreementSearchVO;
import com.anchordata.webframework.service.agreement.AgreementVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;

@Service("CalculationService")
public class CalculationService {
	
	@Autowired
	private CalculationDao calculationDao;
	@Autowired
	private UploadFileService uploadFileService;
	
	
	/**
	 * 정산 정보 등록
	 */
	@Transactional
	public int registration(CalculationVO vo) throws Exception {
		// 협약 정보 Insert
		int result = calculationDao.insertInfo(vo);
		return result;
	}
	/**
	 * 정산 정보 검색
	 */
	@Transactional
	public List<CalculationVO> searchPagingList(CalculationSearchVO vo) throws Exception {
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
		if (  StringUtils.isEmpty(vo.getCalculation_status()) == false ) {
			search.put("calculation_status", vo.getCalculation_status());	
		}
		if (  StringUtils.isEmpty(vo.getExecution_status()) == false ) {
			search.put("execution_status", vo.getExecution_status());	
		}
		if (  StringUtils.isEmpty(vo.getResearch_date()) == false ) {
			search.put("research_date", vo.getResearch_date());	
		}
		if (  StringUtils.isEmpty(vo.getAnnouncement_title()) == false ) {
			search.put("announcement_title", vo.getAnnouncement_title());	
		}
		if (  StringUtils.isEmpty(vo.getTech_info_name()) == false ) {
			search.put("tech_info_name", vo.getTech_info_name());	
		}
		if (  StringUtils.isEmpty(vo.getInstitution_name()) == false ) {
			search.put("institution_name", vo.getInstitution_name());	
		}
		if (  StringUtils.isEmpty(vo.getAgreement_reg_number()) == false ) {
			search.put("agreement_reg_number", vo.getAgreement_reg_number());	
		}
		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		return calculationDao.selectSearchPagingList(new DataMap(search));
	}
	/**
	 * 정산 정보 상세
	 */
	@Transactional
	public CalculationVO searchDetail(CalculationSearchVO vo) throws Exception {
		// 정산 정보 관련된 연구비 검색
		List<CalculationFundDetailVO> fundVO = calculationDao.selectFundDetailInfo(vo);
		// 정산 정보 검색
		CalculationVO returnVO = calculationDao.selectDetail(vo);
		returnVO.setFund_detail_list(fundVO);
		
		return returnVO;
	}
	/**
	 * 정산 정보 수정
	 */
	@Transactional
	public int modification(CalculationVO vo) throws Exception {
		// 중간보고서 Upload File 있을 시 업로드
		if (vo.getDocument_file() != null && vo.getDocument_file().getSize()>0 ) {
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getDocument_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getDocument_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setDocument_file_id(uploadFileVO.getFile_id());
		}
		// 최종보고서 Upload File 있을 시 업로드
		if (vo.getReport_file() != null && vo.getReport_file().getSize()>0 ) {
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getReport_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getReport_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setReport_file_id(uploadFileVO.getFile_id());
		}
		
		// 정산에 괸련된 연구비 정보 삭제
		calculationDao.deleteFundDetailInfo(vo);
		// 협약에 괸련된 연구비 정보 등록
		if (vo.getFund_detail_list() != null && vo.getFund_detail_list().size() > 0) {
			calculationDao.insertFundDetailInfo(vo);
		}
		
		int result = calculationDao.updateInfo(vo);
		return result;
	}
	
	
	/**
	 * 정산 상태 수정
	 */
	@Transactional
	public int statusModification(CalculationVO vo) throws Exception {
		int result = 0;
		if (vo.getActivate_calculation_id_list() != null) {
			for (String id : vo.getActivate_calculation_id_list()) {
				vo.setCalculation_id(Integer.parseInt(id));
				// 정산 정보 업데이트
				result = calculationDao.updateInfo(vo);
			}
		} else {
			// 정산 정보 업데이트
			result = calculationDao.updateInfo(vo);
		}
		return result;
	}
	
	public List<CalculationVO> searchExcelDownload(CalculationSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		
		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false  ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		
		return calculationDao.searchExcelDownload(new DataMap(search));
	}
	
}
