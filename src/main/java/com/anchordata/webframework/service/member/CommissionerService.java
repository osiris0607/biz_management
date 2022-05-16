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
package com.anchordata.webframework.service.member;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.calculation.CalculationSearchVO;
import com.anchordata.webframework.service.calculation.CalculationVO;
import com.anchordata.webframework.service.member.CommissionerEvaluationItemVO.ItemResultInfo;
import com.anchordata.webframework.service.notice.NoticeVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;


@Service("CommissionerService")
public class CommissionerService {
	
	@Autowired
	private CommissionerDao commissionerDao;
	@Autowired
	private UploadFileService uploadFileService;
	
	/**
	 * 평가워원 가입
	 */
	@Transactional
	public int registration(CommissionerVO vo) throws Exception {
		// 파일이 있으면 기존 파일 삭제 후 Insert
		// 기존 파일 정보 삭제
		ArrayList<Integer> list = new ArrayList<Integer>();
		list.add(vo.getDegree_certificate_file_id_01());
		list.add(vo.getDegree_certificate_file_id_02());
		UploadFileVO searchVO = new UploadFileVO();
		searchVO.setSerach_file_ids(list);
		uploadFileService.withdrawal(searchVO);
		
		// 기존 데이터 삭제 후 다시 insert한다.
		commissionerDao.deleteInfo(vo);
		
		if (vo.getDegree_certi_file_01() != null && vo.getDegree_certi_file_01().getSize()>0 ) {
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getDegree_certi_file_01().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getDegree_certi_file_01().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setDegree_certificate_file_id_01(uploadFileVO.getFile_id());
		}
		
		// degree_certi_file_02 존재
		if (vo.getDegree_certi_file_02() != null && vo.getDegree_certi_file_02().getSize()>0 ) {
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getDegree_certi_file_02().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getDegree_certi_file_02().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setDegree_certificate_file_id_02(uploadFileVO.getFile_id());
		}
		// 평가위원 Insert
		int result = commissionerDao.insertInfo(vo);
		return result;
	}
	
	/**
	 * 회원 정보 수정
	 */
	@Transactional
	public int modification(CommissionerVO vo) throws Exception {
		// 파일이 있으면 기존 파일 삭제 후 Insert
		if (vo.getDegree_certi_file_01() != null && vo.getDegree_certi_file_01().getSize()>0 ) {
			// 기존 정보 삭제
			ArrayList<Integer> list = new ArrayList<Integer>();
			list.add(vo.getDegree_certificate_file_id_01());
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(list);
			uploadFileService.withdrawal(searchVO);
			
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getDegree_certi_file_01().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getDegree_certi_file_01().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setDegree_certificate_file_id_01(uploadFileVO.getFile_id());
		}
		// 파일이 있으면 기존 파일 삭제 후 Insert
		if (vo.getDegree_certi_file_02() != null && vo.getDegree_certi_file_02().getSize()>0 ) {
			// 기존 정보 삭제
			ArrayList<Integer> list = new ArrayList<Integer>();
			list.add(vo.getDegree_certificate_file_id_02());
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(list);
			uploadFileService.withdrawal(searchVO);
			
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getDegree_certi_file_02().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getDegree_certi_file_02().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setDegree_certificate_file_id_02(uploadFileVO.getFile_id());
		}
		
		int result = commissionerDao.updateInfo(vo);
		return result;
	}
	/**
	 * 평가워원 검색
	 */
	@Transactional
	public List<CommissionerVO> searchPagingList(CommissionerSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false ) {
			search.put("member_id", vo.getMember_id());	
		}
		if (  StringUtils.isEmpty(vo.getCommissioner_status()) == false ) {
			search.put("commissioner_status", vo.getCommissioner_status());	
		}
		if (  StringUtils.isEmpty(vo.getName()) == false ) {
			search.put("name", vo.getName());	
		}
		if (  StringUtils.isEmpty(vo.getUpdate_date()) == false ) {
			search.put("update_date", vo.getUpdate_date());	
		}
		if (  StringUtils.isEmpty(vo.getInstitution_type()) == false ) {
			search.put("institution_type", vo.getInstitution_type());	
		}
		if (  StringUtils.isEmpty(vo.getInstitution_name()) == false ) {
			search.put("institution_name", vo.getInstitution_name());	
		}
		if (  StringUtils.isEmpty(vo.getRnd_class()) == false ) {
			search.put("rnd_class", vo.getRnd_class());	
		}
		if (  StringUtils.isEmpty(vo.getNational_skill_large()) == false ) {
			search.put("national_skill_large", vo.getNational_skill_large());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		if (  StringUtils.isEmpty(vo.getPage_row_count()) == false ) {
			return commissionerDao.selectSearchPagingList(new DataMap(search), Integer.parseInt(vo.getPage_row_count()));
		} else {
			return commissionerDao.selectSearchPagingList(new DataMap(search));
		}
	}
	/**
	 * 평가워원 상세  
	 */
	@Transactional
	public CommissionerVO getDetail(CommissionerVO vo) throws Exception {
		return commissionerDao.selectDetail(vo);
	}
	/**
	 * Status 변경
	 */
	@Transactional
	public int updateCommissionerStatus(CommissionerVO vo) throws Exception {
		return commissionerDao.updateCommissionerStatus(vo);
	}
	/**
	 * REMARK 변경
	 */
	@Transactional
	public int updateCommissionerRemark(CommissionerVO vo) throws Exception {
		return commissionerDao.updateCommissionerRemark(vo);
	}
	/**
	 *  소속 기관 유형별 평가위원 수 (개인/기업/학교/연구원/공공기관/기타(협/단체 등))
	 */
	@Transactional
	public CommissionerVO searchInstitutionTypeCount(CommissionerSearchVO vo) throws Exception {
		return commissionerDao.selectInstitutionTypeCount(vo);
	}
	/**
	 *  Institution_type별 Count만큼 평가위원 자동 추출
	 */
	@Transactional
	public List<CommissionerVO> searchAutoChoice(CommissionerVO vo) throws Exception {
			
		List<CommissionerVO> resultList = new ArrayList<CommissionerVO>();
		
		// 선정된 평가위원 중에서 선택 
		vo.setCommissioner_status("D0000004");
		// Institution_type이 개인인 평가위원을 Count 만큼 Ramdom하게 찾는다.
		if (vo.getInstitution_type_personal_count()>0 ) {
			vo.setInstitution_type("D0000001");
			vo.setInstitution_type_count_limit(vo.getInstitution_type_personal_count());
			List<CommissionerVO> tempList = commissionerDao.selecteCommissionerWithCountWithRandom(vo);
			
			resultList.addAll(tempList);
		}
		// Institution_type이 기업인 평가위원을 Count 만큼 Ramdom하게 찾는다.
		if (vo.getInstitution_type_company_count()>0 ) {
			vo.setInstitution_type("D0000002");
			vo.setInstitution_type_count_limit(vo.getInstitution_type_company_count());
			List<CommissionerVO> tempList = commissionerDao.selecteCommissionerWithCountWithRandom(vo);
			
			resultList.addAll(tempList);
		}
		// Institution_type이 학교인 평가위원을 Count 만큼 Ramdom하게 찾는다.
		if (vo.getInstitution_type_school_count()>0 ) {
			vo.setInstitution_type("D0000003");
			vo.setInstitution_type_count_limit(vo.getInstitution_type_school_count());
			List<CommissionerVO> tempList = commissionerDao.selecteCommissionerWithCountWithRandom(vo);
			
			resultList.addAll(tempList);
		}
		// Institution_type이 연구원인 평가위원을 Count 만큼 Ramdom하게 찾는다.
		if (vo.getInstitution_type_commissioner_count()>0 ) {
			vo.setInstitution_type("D0000004");
			vo.setInstitution_type_count_limit(vo.getInstitution_type_commissioner_count());
			List<CommissionerVO> tempList = commissionerDao.selecteCommissionerWithCountWithRandom(vo);
			
			resultList.addAll(tempList);
		}
		// Institution_type이 공공기관인 평가위원을 Count 만큼 Ramdom하게 찾는다.
		if (vo.getInstitution_type_department_count()>0 ) {
			vo.setInstitution_type("D0000005");
			vo.setInstitution_type_count_limit(vo.getInstitution_type_department_count());
			List<CommissionerVO> tempList = commissionerDao.selecteCommissionerWithCountWithRandom(vo);
			
			resultList.addAll(tempList);
		}
		// Institution_type이 기타(협/단체 등)인 평가위원을 Count 만큼 Ramdom하게 찾는다.
		if (vo.getInstitution_type_etc_count()>0 ) {
			vo.setInstitution_type("D0000006");
			vo.setInstitution_type_count_limit(vo.getInstitution_type_etc_count());
			List<CommissionerVO> tempList = commissionerDao.selecteCommissionerWithCountWithRandom(vo);
			
			resultList.addAll(tempList);
		}
		// Institution_type이 내부평가위원인 평가위원을 Count 만큼 Ramdom하게 찾는다.
		if (vo.getInstitution_type_manager_count()>0 ) {
			vo.setInstitution_type("D0000007");
			vo.setInstitution_type_count_limit(vo.getInstitution_type_manager_count());
			List<CommissionerVO> tempList = commissionerDao.selecteCommissionerWithCountWithRandom(vo);
			
			resultList.addAll(tempList);
		}
		return resultList;
	}
	/**
	 * 평가위원 은행 정보 업데이트
	 */
	@Transactional
	public int updateBankInfo(CommissionerVO vo) throws Exception {
		int result = commissionerDao.updateBankInfo(vo);
		return result;
	}
	/**
	 * 평가 항목 결과 저장
	 */
	@Transactional
	public int insertEvaluationResultItemInfo(CommissionerEvaluationItemVO vo) throws Exception {
		// 기존 데이터 삭제
		int result = commissionerDao.deleteCommissionerEvaluationItemInfo(vo);
		// 새롭게 등록한다.
		result = commissionerDao.insertCommissionerEvaluationItemInfo(vo);
		return result;
	}
	/**
	 * 평가 항목 결과 조회
	 */
	@Transactional
	public CommissionerEvaluationItemVO selectEvaluationResultItemDetail(CommissionerEvaluationItemVO vo) throws Exception {
		List<Map<String, Object>> result = commissionerDao.selectEvaluationResultItemDetail(vo);
		if ( result != null && result.size() > 0 ) {
			List<ItemResultInfo> itemResultInfoList = new ArrayList<>();
			
			for ( Map<String, Object> value : result) {
				ItemResultInfo itemResultInfo = new ItemResultInfo();
				itemResultInfo.setItem_id( Integer.parseInt(value.get("ITEM_ID").toString()));
				itemResultInfo.setItem_result(value.get("ITEM_RESULT").toString());
				itemResultInfoList.add(itemResultInfo);
			}
			vo.setItem_result_info_list(itemResultInfoList);
		}
		return vo;
	}
	
	public List<CommissionerVO> searchExcelDownload(CommissionerSearchVO vo) throws Exception 
	{
		return commissionerDao.searchExcelDownload();
	}
	
	
}
	
		
