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
package com.anchordata.webframework.service.reception;


import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.evaluation.EvaluationService;
import com.anchordata.webframework.service.evaluation.EvaluationVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;


@Service("ReceptionService")
public class ReceptionService {
	
	@Autowired
	private ReceptionDao receptionDao;
	@Autowired
	private UploadFileService uploadFileService;
	@Autowired
	private EvaluationService evaluationService;
	
	
	/**
	 * 접수 등록
	 */
	@Transactional
	public int registration(ReceptionVO vo) throws Exception {
		// 기술 정보 관련 Upload File 있을 시 업로드
		if (vo.getTech_info_upload_file() != null && vo.getTech_info_upload_file().getSize()>0 ) {
			// 나머지 정보는 Upload File Table에 저장
			String fileName = vo.getTech_info_upload_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getTech_info_upload_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setTech_info_upload_file_id(uploadFileVO.getFile_id());
		}
		// 일반 데이터 입력
		int result = receptionDao.insertInfo(vo);
		if (result == 1) {
			// 제출 서류 입력
			// 연관된 업로드 파일 Insert
			if (vo.getSubmit_files() != null) {
				for (int i=0; i<vo.getSubmit_files().length; i++) {
					if (vo.getSubmit_files()[i].getSize() > 0 ) {
						// 나머지 정보는 Upload File Table에 저장
						String fileName = vo.getSubmit_files()[i].getOriginalFilename();
						UploadFileVO uploadFileVO  = new UploadFileVO();
						uploadFileVO.setName(fileName);
						uploadFileVO.setBinary_content(vo.getSubmit_files()[i].getBytes());
						uploadFileService.registration(uploadFileVO);
						
						// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
						vo.setSubmit_file_id(uploadFileVO.getFile_id());
						// 공고에 어떤 재출 문서인지를 알기위해 Extesion ID도 입력한다.
						vo.setSubmit_file_ext_id(Integer.parseInt(vo.getSubmit_file_ext_id_list().get(i)));
						vo.setSubmit_file_name(fileName);
						receptionDao.insertRelativeFileInfo(vo);
					}
				}
			}
			// EXPERT 정보 입력 
			if (vo.getChoiced_expert_list() != null && vo.getChoiced_expert_list().size() > 0) {
				receptionDao.insertExpertInfo(vo);
			}
			
			// CHECK LIST 정보 입력 
			if (vo.getSelf_check_list() != null && vo.getSelf_check_list().size() > 0) {
				receptionDao.insertCheckListInfo(vo);
			}
		}
		
		return result;
	}
	/**
	 * Member 접수 목록 검색
	 */
	@Transactional
	public List<ReceptionVO> searchMemberReceptionList(ReceptionSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false ) {
			search.put("member_id", vo.getMember_id());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		List<ReceptionVO> result = receptionDao.selectMemberSearchPagingList(new DataMap(search));
		return result;
	}
	/**
	 * admin 접수 목록 검색
	 */
	@Transactional
	public List<ReceptionVO> searchAdminReceptionList(ReceptionSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());

		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		if (  StringUtils.isEmpty(vo.getAnnouncement_name()) == false ) {
			search.put("announcement_name", vo.getAnnouncement_name());	
		}
		if (  StringUtils.isEmpty(vo.getReception_from_date()) == false ) {
			search.put("reception_from_date", vo.getReception_from_date());	
		}
		if (  StringUtils.isEmpty(vo.getReception_to_date()) == false ) {
			search.put("reception_to_date", vo.getReception_to_date());	
		}
		if (  StringUtils.isEmpty(vo.getInstitution_name()) == false ) {
			search.put("institution_name", vo.getInstitution_name());	
		}
		if (  StringUtils.isEmpty(vo.getReception_reg_number()) == false ) {
			search.put("reception_reg_number", vo.getReception_reg_number());	
		}
		if (  StringUtils.isEmpty(vo.getReception_status()) == false ) {
			search.put("reception_status", vo.getReception_status());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		List<ReceptionVO> result = receptionDao.selectAdminSearchPagingList(new DataMap(search));
		
		for (int i=0; i<result.size(); i++) {
			List<ReceptionExpertVO> expertInfo = receptionDao.selectExpertInfo(result.get(i));
			result.get(i).setChoiced_expert_list(expertInfo);
		}
		
		return result;
	}
	/**
	 * 접수 상세
	 */
	@Transactional
	public ReceptionVO detail(ReceptionVO vo) throws Exception {
		// 접수 정보 찾기
		ReceptionVO returnVO = receptionDao.selectDetail(vo);
		// 등록된 Upload File 찾기
		List<ReceptionFileVO> uploadFileInfo = receptionDao.selectRelativeFileInfo(vo);
		returnVO.setSubmit_files_list(uploadFileInfo);
		// 등록된 전문가 정보 찾기
		List<ReceptionExpertVO> expertInfo = receptionDao.selectExpertInfo(vo);
		returnVO.setChoiced_expert_list(expertInfo);
		// 등록된 Check List 정보 찾기
		List<ReceptionCheckListVO> checkListInfo = receptionDao.selectCheckListInfo(vo);
		returnVO.setSelf_check_list(checkListInfo);
		
		return returnVO;
	}	
	/**
	 * 접수 삭제
	 */
	@Transactional
	public int withdrawal(ReceptionVO vo) throws Exception {
		
		// 일단 Status만 바꾼다.
		vo.setReception_status("D0000011");
		return updateReceptionStatus(vo);
		
//		// 제출 서류 목록 파일 ID
//		List<ReceptionFileVO> submintFiles = receptionDao.selectRelativeFileInfo(vo);
//		List<Integer> uploadFileIds = new ArrayList<>();
//		for (int i=0; i<submintFiles.size(); i++) {
//			uploadFileIds.add(submintFiles.get(i).getFile_id());
//		}
//		// 기술 항목에 있는 파일 ID
//		// 기술 항목에 있는 파일은 하나이다.
//		ReceptionVO returnVO = receptionDao.selectDetail(vo);
//		uploadFileIds.add(returnVO.getTech_info_upload_file_id());
//		// 연관된 모든 파일 삭제  (upload_file Table)
//		if ( uploadFileIds != null && uploadFileIds.size() > 0) {
//			UploadFileVO searchVO = new UploadFileVO();
//			searchVO.setSerach_file_ids(uploadFileIds);
//			uploadFileService.withdrawal(searchVO);		
//		}
//
//		// 제출 서류 upload File 정보 삭제 (reception_file_relative Table)
//		receptionDao.deleteFileRelativeInfo(vo);
//		// 전문가  정보 삭제 (reception_expert Table)
//		receptionDao.deleteExpertInfo(vo);
//		// check List 삭제 (reception_checklist Table)
//		receptionDao.deleteCheckListInfo(vo);
//		// 공고 삭제
//		return receptionDao.deleteInfo(vo);
	}	
	/**
	 * 접수 수정
	 */
	@Transactional
	public int modification(ReceptionVO vo) throws Exception {
		// 기술 정보 Upload File 있을 시 업로드
		List<Integer> uploadFileIds = new ArrayList<>();
		if (vo.getTech_info_upload_file() != null && vo.getTech_info_upload_file().getSize()>0 ) {
			// 기존 정보 삭제
			ReceptionVO returnVO = receptionDao.selectDetail(vo);
			uploadFileIds.add(returnVO.getTech_info_upload_file_id());
			// 연관된 모든 파일 삭제  (upload_file Table)
			if ( uploadFileIds != null && uploadFileIds.size() > 0) {
				UploadFileVO searchVO = new UploadFileVO();
				searchVO.setSerach_file_ids(uploadFileIds);
				uploadFileService.withdrawal(searchVO);		
			}
			// 새로운 File은 Upload File Table에 저장
			String fileName = vo.getTech_info_upload_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getTech_info_upload_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setTech_info_upload_file_id(uploadFileVO.getFile_id());
		}
		// 접수 정보 Update
		receptionDao.updateInfo(vo);
		
		// 전문가  정보 Update (reception_expert Table)
		// 원칙적으로는 삭제된 정보는 삭제하고 새로운 정보는 Insert하고 Update 정보는 Update 해야한다.
		// 3가지 Transaction을 하기 보단 기존의 전체 데이터를 삭제하고 새로운 정보를 모두 Insert해서 데이터를 유지한다.
		receptionDao.deleteExpertInfo(vo);
		// 새로운 정보를 Insert
		if (vo.getChoiced_expert_list() != null && vo.getChoiced_expert_list().size() > 0) {
			receptionDao.insertExpertInfo(vo);
		}
		// Check List 정보 Update (reception_expert Table)
		// 원칙적으로는 삭제된 정보는 삭제하고 새로운 정보는 Insert하고 Update 정보는 Update 해야한다.
		// 3가지 Transaction을 하기 보단 기존의 전체 데이터를 삭제하고 새로운 정보를 모두 Insert해서 데이터를 유지한다.
		receptionDao.deleteCheckListInfo(vo);
		// 새로운 정보를 Insert
		if (vo.getSelf_check_list() != null && vo.getSelf_check_list().size() > 0) {
			receptionDao.insertCheckListInfo(vo);
		}
		
		// 제출 서류 Update
		// 변경된 항목 삭제
		// getSubmit_files가 있으면 기존 파일 변경 혹은 새로운 Insert가 있는 것이다.
		// 따라서 getSubmit_files의  extension_id에 해당하는 기존 파일을 모두 삭제하고 새롭게 Insert한다.
		uploadFileIds.clear();
		List<ReceptionFileVO> submitFiles = receptionDao.selectRelativeFileInfo(vo);
		for (int i=0; i<submitFiles.size(); i++) {
			// 전달 받은 extension_id에 해당하는 기존 파일을 모두 삭제
			for (int j=0; j<vo.getSubmit_file_ext_id_list().size(); j++) {
				if ( submitFiles.get(i).getExtension_id() == Integer.parseInt(vo.getSubmit_file_ext_id_list().get(j)) ) {
					uploadFileIds.add(submitFiles.get(i).getFile_id());
				}	
			}
		}
		// 연관된 모든 파일 삭제  (upload_file Table)
		if ( uploadFileIds != null && uploadFileIds.size() > 0) {
			UploadFileVO searchVO = new UploadFileVO();
			searchVO.setSerach_file_ids(uploadFileIds);
			uploadFileService.withdrawal(searchVO);		
		}
		// 새로운 파일 Upload
		if (vo.getSubmit_files() != null) {
			for (int i=0; i<vo.getSubmit_files().length; i++) {
				if (vo.getSubmit_files()[i].getSize() > 0 ) {
					// 나머지 정보는 Upload File Table에 저장
					String fileName = vo.getSubmit_files()[i].getOriginalFilename();
					UploadFileVO uploadFileVO  = new UploadFileVO();
					uploadFileVO.setName(fileName);
					uploadFileVO.setBinary_content(vo.getSubmit_files()[i].getBytes());
					uploadFileService.registration(uploadFileVO);
					
					// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
					vo.setSubmit_file_id(uploadFileVO.getFile_id());
					// 공고에 어떤 재출 문서인지를 알기위해 Extesion ID도 입력한다.
					vo.setSubmit_file_ext_id(Integer.parseInt(vo.getSubmit_file_ext_id_list().get(i)));
					vo.setSubmit_file_name(fileName);
					receptionDao.insertRelativeFileInfo(vo);
				}
			}
		}
		
		return 1;
	}
	/**
	 * 기술매칭 시 실제 접수 완료 
	 */
	@Transactional
	public int submitCompleteReception(ReceptionVO vo) throws Exception {
		updateReceptionStatus(vo);
		
		// 연관된 업로드 파일 Insert
		if (vo.getSubmit_files() != null) {
			for (int i=0; i<vo.getSubmit_files().length; i++) {
				if (vo.getSubmit_files()[i].getSize() > 0 ) {
					// 나머지 정보는 Upload File Table에 저장
					String fileName = vo.getSubmit_files()[i].getOriginalFilename();
					UploadFileVO uploadFileVO  = new UploadFileVO();
					uploadFileVO.setName(fileName);
					uploadFileVO.setBinary_content(vo.getSubmit_files()[i].getBytes());
					uploadFileService.registration(uploadFileVO);
					
					// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
					vo.setSubmit_file_id(uploadFileVO.getFile_id());
					// 공고에 어떤 재출 문서인지를 알기위해 Extesion ID도 입력한다.
					vo.setSubmit_file_ext_id(Integer.parseInt(vo.getSubmit_file_ext_id_list().get(i)));
					vo.setSubmit_file_name(fileName);
					receptionDao.insertRelativeFileInfo(vo);
				}
			}
		}
		
		// CHECK LIST 정보 입력 
		if (vo.getSelf_check_list() != null && vo.getSelf_check_list().size() > 0) {
			receptionDao.insertCheckListInfo(vo);
		}
		
		return 1;
	}
	
	/**
	 * 접수 Status 변경
	 */
	@Transactional
	public int updateReceptionStatus(ReceptionVO vo) throws Exception {
		return receptionDao.updateReceptionStatus(vo);
	}	
	/**
	 * 전문가 참여여부 Status 변경
	 */
	@Transactional
	public int updateExpertParticipation(ReceptionExpertVO vo) throws Exception {
		return receptionDao.updateExpertParticipation(vo);
	}
	/**
	 * 전문가 정보 수정
	 */
	@Transactional
	public int expertModification(ReceptionVO vo) throws Exception {
		// 전문가  정보 Update (reception_expert Table)
		// 원칙적으로는 삭제된 정보는 삭제하고 새로운 정보는 Insert하고 Update 정보는 Update 해야한다.
		// 3가지 Transaction을 하기 보단 기존의 전체 데이터를 삭제하고 새로운 정보를 모두 Insert해서 데이터를 유지한다.
		receptionDao.deleteExpertInfo(vo);
		// 새로운 정보를 Insert
		if (vo.getChoiced_expert_list() != null && vo.getChoiced_expert_list().size() > 0) {
			receptionDao.insertExpertInfo(vo);
		}			

		return 1;
	}
	/**
	 * 전문가 우선순위 수정
	 */
	@Transactional
	public int expertSetPriority(ReceptionVO vo) throws Exception {
		for (int i=0; i<vo.getChoiced_expert_list().size(); i++) {
			receptionDao.updateExpertPriority(vo.getChoiced_expert_list().get(i));
		}
		
		return 1;
	}	
	/**
	 * 사용자로부터 선택된 전문가 설정
	 */
	@Transactional
	public int expertChoice(ReceptionVO vo) throws Exception {
		// Reception status 변경
		// D0000007 - 전문가 선택 완료
		receptionDao.updateReceptionStatus(vo);
		// 전문가 정보 변경
		// choiced_yn = 'Y'
		ReceptionExpertVO expert = new ReceptionExpertVO();
		expert.setExpert_id(vo.getExpert_id());
		expert.setChoiced_yn("Y");
		receptionDao.updateExpertChoice(expert);
		
		return 1;
	}
	/**
	 * 재매칭
	 */
	@Transactional
	public int retryMatch(ReceptionVO vo) throws Exception {
		// Reception status 변경
		// D0000003 - 전문가 선택 완료
		receptionDao.updateReceptionStatus(vo);
		// 기존 설정된 전문가 정보 삭제
		// 전문가  정보 삭제 (reception_expert Table)
		receptionDao.deleteExpertInfo(vo);
		
		return 1;
	}
	/**
	 * 접수 완료 처리 
	
	 */
	@Transactional
	public int updateReceptionComplete(ReceptionVO vo) throws Exception {
		// 접수 번호 생성
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
        
		String reception_reg_number = Integer.toString(year) + monthString + dateString + randString;
		vo.setReception_reg_number(reception_reg_number);
		
		receptionDao.updateReceptionComplete(vo);
		
		// 접수 완료 후에 해당 접수건을 평가로 입력한다.
		// 최초 입력이므로 'D0000005' - 평가전으로 세팅한다.
		EvaluationVO evaluationVO = new EvaluationVO();
		evaluationVO.setReception_id(vo.getReception_id());
		evaluationVO.setClassification("D0000005");
		evaluationService.registration(evaluationVO);
		
		return 1;
	}	
	/**
	 * 접수 전문가로 선택된 접수 목록 검색 
	 */
	@Transactional
	public List<ReceptionVO> searchExpertReceptionList(ReceptionSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false ) {
			search.put("member_id", vo.getMember_id());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		if (  StringUtils.isEmpty(vo.getSearch_text()) == false ) {
			search.put("search_text", vo.getSearch_text());	
		}
		if (  StringUtils.isEmpty(vo.getReception_expert_status1()) == false ) {
			search.put("reception_expert_status1", vo.getReception_expert_status1());	
		}
		if (  StringUtils.isEmpty(vo.getReception_expert_status2()) == false ) {
			search.put("reception_expert_status2", vo.getReception_expert_status2());	
		}
		
		
		List<ReceptionVO> result = receptionDao.selectExpertSearchPagingList(new DataMap(search));
		
		for (int i=0; i<result.size(); i++) {
			result.get(i).setMember_id(vo.getMember_id());
			List<ReceptionExpertVO> expertInfo = receptionDao.selectExpertInfo(result.get(i));
			
			if ( expertInfo.get(0).getChoiced_yn().equals("N"))
			{
				//expertInfo.get(0).setParticipation_name("미선정");
			}
			
			result.get(i).setChoiced_expert_list(expertInfo);
		}
		return result;
	}
	
	/**
	 * 전문가 참여 현황 
	 */
	public Map<String,String> selectExpertParticipation(ReceptionSearchVO vo) throws Exception {
		return receptionDao.selectExpertParticipation(vo);
	}
	
	/**
	 * My페이지 > 나의 수행 과제 현황 관리 List 검색
	 */
	@Transactional
	public List<ReceptionVO> searchReportReceptionList(ReceptionSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false ) {
			search.put("member_id", vo.getMember_id());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		if (  StringUtils.isEmpty(vo.getSearch_text()) == false ) {
			search.put("search_text", vo.getSearch_text());	
		}
		
		List<ReceptionVO> result = receptionDao.selectReportSearchPagingList(new DataMap(search));
		return result;
	}
	/**
	 * 접수 메인 페이지의 접수별 갯수 데이터
	 */
	@Transactional
	public Map<String,String> selectMainState() throws Exception {
		return receptionDao.selectMainState();
	}
	
	
	/**
	 * admin 접수 엑셀 다운로드
	 */
	@Transactional
	public List<ReceptionVO> searchAdminReceptionAllList(ReceptionSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());

		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		if (  StringUtils.isEmpty(vo.getAnnouncement_name()) == false ) {
			search.put("announcement_name", vo.getAnnouncement_name());	
		}
		if (  StringUtils.isEmpty(vo.getReception_from_date()) == false ) {
			search.put("reception_from_date", vo.getReception_from_date());	
		}
		if (  StringUtils.isEmpty(vo.getReception_to_date()) == false ) {
			search.put("reception_to_date", vo.getReception_to_date());	
		}
		if (  StringUtils.isEmpty(vo.getInstitution_name()) == false ) {
			search.put("institution_name", vo.getInstitution_name());	
		}
		if (  StringUtils.isEmpty(vo.getReception_reg_number()) == false ) {
			search.put("reception_reg_number", vo.getReception_reg_number());	
		}
		if (  StringUtils.isEmpty(vo.getReception_status()) == false ) {
			search.put("reception_status", vo.getReception_status());	
		}
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		List<ReceptionVO> result = receptionDao.searchAdminReceptionAllList(new DataMap(search));
		
		for (int i=0; i<result.size(); i++) {
			List<ReceptionExpertVO> expertInfo = receptionDao.selectExpertInfo(result.get(i));
			result.get(i).setChoiced_expert_list(expertInfo);
		}
		
		return result;
	}
	

}
