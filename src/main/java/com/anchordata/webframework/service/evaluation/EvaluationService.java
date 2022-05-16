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
package com.anchordata.webframework.service.evaluation;


import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.DataMap;
import com.anchordata.webframework.service.agreement.AgreementService;
import com.anchordata.webframework.service.agreement.AgreementVO;
import com.anchordata.webframework.service.evaluation.EvaluationItemVO.ItemFormInfo;
import com.anchordata.webframework.service.evaluation.EvaluationItemVO.ItemFormInfo.ItemFormDetailInfo;
import com.anchordata.webframework.service.member.CommissionerEvaluationItemVO;
import com.anchordata.webframework.service.member.CommissionerService;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;

@Service("EvaluationService")
public class EvaluationService {
	
	@Autowired
	private EvaluationDao evaluationDao;

	@Autowired
	private UploadFileService uploadFileService;
	@Autowired
	private CommissionerService commissionerService;
	@Autowired
	private AgreementService agreementService;
	
	
	/**
	 * 평가 정보 등록
	 */
	@Transactional
	public int registration(EvaluationVO vo) throws Exception {
		// 기관 정보 Insert
		int result = evaluationDao.insertInfo(vo);
		return result;
	}
	/**
	 * 평가 정보 상세
	 */
	@Transactional
	public EvaluationVO detail(EvaluationSearchVO vo) throws Exception {
		return evaluationDao.selectDetail(vo);
	}
	/**
	 * 평가 정보 검색
	 */
	@Transactional
	public List<EvaluationVO> searchPagingList(EvaluationSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false  ) {
			search.put("member_id", vo.getMember_id());	
		}
		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false  ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		if (  vo.getReception_match_type_list() != null && vo.getReception_match_type_list().size() > 0  ) {
			search.put("reception_match_type_list", vo.getReception_match_type_list());	
		}
		if (  vo.getClassification_list() != null && vo.getClassification_list().size() > 0  ) {
			search.put("classification_list", vo.getClassification_list());	
		}
		if (  vo.getType_list() != null && vo.getType_list().size() > 0  ) {
			search.put("type_list", vo.getType_list());	
		}
		if (  vo.getStatus_list() != null && vo.getStatus_list().size() > 0  ) {
			search.put("status_list", vo.getStatus_list());	
		}
		if (  vo.getResult_list() != null && vo.getResult_list().size() > 0  ) {
			search.put("result_list", vo.getResult_list());	
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
		
		return evaluationDao.selectSearchPagingList(new DataMap(search));
	}
	/**
	 * 평가에 평가워원으로 선정된 평가위원 Pagination 리스트 검색
	 */
	@Transactional
	public List<EvaluationCommissionerVO> searchRelatedIDPagingList(EvaluationCommissionerVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		
		if (  StringUtils.isEmpty(vo.getEvaluation_reg_number()) == false ) {
			search.put("evaluation_reg_number", vo.getEvaluation_reg_number());	
		}
		
		if (  StringUtils.isEmpty(vo.getChoice_yn()) == false ) {
			search.put("choice_yn", vo.getChoice_yn());	
		}
		
		if ( vo.getEvaluation_id() > 0 ) {
			search.put("evaluation_id", vo.getEvaluation_id());	
		}
		
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		return evaluationDao.searchRelatedIDPagingList(new DataMap(search), Integer.parseInt(vo.getPage_row_count()));
	}
	
	/**
	*  해당 평가에 선정된 평가위원 정보 검색(평가 점수까지 검색)
	*/
	@Transactional
	public List<EvaluationCommissionerVO> searchRelatedCommissionerList(EvaluationCommissionerVO vo) throws Exception {
		List<EvaluationCommissionerVO> resultList = evaluationDao.searchRelatedCommissionerList(vo);
		
		for (EvaluationCommissionerVO item : resultList) {
			// 평가 점수 검색
			CommissionerEvaluationItemVO commissionerEvaluationItemVO = new CommissionerEvaluationItemVO();
			
			commissionerEvaluationItemVO.setEvaluation_id(item.getEvaluation_id());
			commissionerEvaluationItemVO.setMember_id(item.getMember_id());
			commissionerEvaluationItemVO = commissionerService.selectEvaluationResultItemDetail(commissionerEvaluationItemVO);
			item.setCommissioner_item_result_list(commissionerEvaluationItemVO.getItem_result_info_list());
		}
		
		return resultList;
	}
	
	/**
	 * 해당 평가위원이 평가워원으로 선정된 평가 항목 검색
	 * 평가 Status가 평가 중인 경우(D0000004)만 검색
	 */
	@Transactional
	public List<EvaluationVO> searchRelatedEvaluationPagingList(EvaluationCommissionerVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		search.put("pageIndex", vo.getPageIndex());
		search.put("choice_yn", "Y");
		search.put("status", "D0000004");
		
		if (  StringUtils.isEmpty(vo.getMember_id()) == false ) {
			search.put("member_id", vo.getMember_id());	
		}
		
		
		if ( vo.getEvaluation_id() > 0 ) {
			search.put("evaluation_id", vo.getEvaluation_id());	
		}
		
		if (  StringUtils.isEmpty(vo.getOrderby()) == false ) {
			search.put("orderby", vo.getOrderby());	
		}
		
		return evaluationDao.searchRelatedEvaluationPagingList(new DataMap(search), Integer.parseInt(vo.getPage_row_count()));
	}
	
	/**
	 * 평가번호 생성
	 */
	@Transactional
	public int createEvaluationNumber(EvaluationVO vo) throws Exception {
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
        
		// 평가 번호 생성
		String evaluationNumber = "";
		if ( vo.getAnnouncement_type().equals("D0000005") ) {
			evaluationNumber +="M";
		}
		if ( vo.getAnnouncement_type().equals("D0000003") ) {
			evaluationNumber +="C";
		}
		if ( vo.getAnnouncement_type().equals("D0000002") ) {
			evaluationNumber +="P";
		}
		
        evaluationNumber += Integer.toString(year) + monthString + dateString + randString;
        vo.setEvaluation_reg_number(evaluationNumber);
        
     // status 변경 - D0000002:평가준비
		int result = evaluationDao.updateEvaluationNumber(vo);
		return result;
	}
	/**
	 * 평가번호 초기화
	 */
	@Transactional
	public int clearEvaluationNumber(EvaluationVO vo) throws Exception {
		// 평가번호 초기화
        // status 변경 - D0000001:평가전
        vo.setStatus("D0000001");
        vo.setClassification("D0000005");
		int result = evaluationDao.updateClearEvaluationNumber(vo);
		// 연게된 평가위원 존재 시 삭제 
		evaluationDao.deleteEvaluationCommissionerRelationInfo(vo);
		
		return result;
	}
	/**
	 * 평가 정보 업데이트
	 */
	@Transactional
	public int updateEvaluationInfo(EvaluationVO vo) throws Exception {
		vo.setStatus("D0000002");
		int result = evaluationDao.updateEvaluationInfo(vo);
		return result;
	}
	/**
	 * 메일 전송 정보 업데이트
	 */
	@Transactional
	public int updateMailInfo(EvaluationVO vo) throws Exception {
		int result = evaluationDao.updateMailInfo(vo);
		return result;
	}
	/**
	 * 평가 항목에 해당하는 평가위원 등록
	 */
	@Transactional
	public int insertEvaluationCommissionerRelationInfo(EvaluationVO vo) throws Exception {
		// EVALUATION_REG_NUMBER에 포함되어 있는 개개의 evaluation_id 만큼 Insert 해야 한다.
		int result = 0;
		for(String evaluationId : vo.getEvaluation_id_list()){
		    vo.setEvaluation_id(Integer.parseInt(evaluationId));
		    result = evaluationDao.insertEvaluationCommissionerRelationInfo(vo);
		}
		
		return result;
	}
	/**
	 * STATUS 업데이트
	 */
	@Transactional
	public int updateStatus(EvaluationVO vo) throws Exception {
		int result = evaluationDao.updateStatus(vo);
		return result;
	}
	/**
	 * 평가에 포함되어 있는 평가위원 데이터 업데이트
	 */
	@Transactional
	public int updateEvaluationCommissionerRelationInfo(EvaluationCommissionerVO vo) throws Exception {
		int result = evaluationDao.updateEvaluationCommissionerRelationInfo(vo);
		return result;
	}
	/**
	 * 평가 상태 정보 검색
	 */
	public EvaluationVO selectStatusInfo(EvaluationVO vo) throws Exception {
		return evaluationDao.selectStatusInfo(vo);
	}
	/**
	 * 평가위원 위원장 선임 업데이트
	 */
	@Transactional
	public int updateCommissionerChairmanYN(EvaluationCommissionerVO vo) throws Exception {
		// 모든 평가위원의 위원장 Flag를 'N'로 설정
		// memeber_id가 없으면 전체를 업데이트 한다.
		EvaluationCommissionerVO tempVO = new EvaluationCommissionerVO();
		tempVO.setChairman_yn("N");
		tempVO.setEvaluation_id(vo.getEvaluation_id());
		int result = evaluationDao.updateEvaluationCommissionerInfo(tempVO);
		// 해당 Mebmer_id의 위원장 Flag를 'Y'로 업데이트
		result = evaluationDao.updateEvaluationCommissionerInfo(vo);
		// 해당 평가 항목도 Update
		result = evaluationDao.updateEvaluationChairmanYN(vo);
		return result;
	}
	/**
	 * 평가 상세 페이지에서 업데이트
	 */
	@Transactional
	public int updateDetailInfo(EvaluationVO vo) throws Exception {
		List<Integer> uploadFileIds = new ArrayList<>();
		// 평가 안내 공문
		if (vo.getUpload_guide_file() != null && vo.getUpload_guide_file().getSize()>0 ) {
			// 기존 정보 삭제
			EvaluationVO returnVO = evaluationDao.selectDetail(vo);
			uploadFileIds.add(returnVO.getGuide_file_id());
			// 연관된 모든 파일 삭제  (upload_file Table)
			if ( uploadFileIds != null && uploadFileIds.size() > 0) {
				UploadFileVO searchVO = new UploadFileVO();
				searchVO.setSerach_file_ids(uploadFileIds);
				uploadFileService.withdrawal(searchVO);		
			}
			// 새로운 File은 Upload File Table에 저장
			String fileName = vo.getUpload_guide_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getUpload_guide_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setGuide_file_id(uploadFileVO.getFile_id());
		}
		
		//평가 결과 공문
		if (vo.getUpload_result_file() != null && vo.getUpload_result_file().getSize()>0 ) {
			// 기존 정보 삭제
			uploadFileIds.clear();
			EvaluationVO returnVO = evaluationDao.selectDetail(vo);
			uploadFileIds.add(returnVO.getResult_file_id());
			// 연관된 모든 파일 삭제  (upload_file Table)
			if ( uploadFileIds != null && uploadFileIds.size() > 0) {
				UploadFileVO searchVO = new UploadFileVO();
				searchVO.setSerach_file_ids(uploadFileIds);
				uploadFileService.withdrawal(searchVO);		
			}
			// 새로운 File은 Upload File Table에 저장
			String fileName = vo.getUpload_result_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getUpload_result_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setResult_file_id(uploadFileVO.getFile_id());
		}
		
		//종합 평가서 업르도
		if (vo.getUpload_complete_file() != null && vo.getUpload_complete_file().getSize()>0 ) {
			// 기존 정보 삭제
			uploadFileIds.clear();
			EvaluationVO returnVO = evaluationDao.selectDetail(vo);
			uploadFileIds.add(returnVO.getResult_file_id());
			// 연관된 모든 파일 삭제  (upload_file Table)
			if ( uploadFileIds != null && uploadFileIds.size() > 0) {
				UploadFileVO searchVO = new UploadFileVO();
				searchVO.setSerach_file_ids(uploadFileIds);
				uploadFileService.withdrawal(searchVO);		
			}
			// 새로운 File은 Upload File Table에 저장
			String fileName = vo.getUpload_complete_file().getOriginalFilename();
			UploadFileVO uploadFileVO  = new UploadFileVO();
			uploadFileVO.setName(fileName);
			uploadFileVO.setBinary_content(vo.getUpload_complete_file().getBytes());
			uploadFileService.registration(uploadFileVO);
			// 실제 공고 정보와 연동되는 File은  announcement_file_relative 에 Insert한다.
			vo.setComplete_file_id(uploadFileVO.getFile_id());
			// 종합 평가서 완료 시 평가 완료이
			vo.setStatus("D0000005");
		}
		
		// 평가 정보 Update
		int result = evaluationDao.updateDetailInfo(vo);
		
		// 선정평가 완료인 경우 협약 Table에 해당 정보를 Insert 한다.
		if (vo.getClassification().equals("D0000001")) {
			AgreementVO agreementVO = new AgreementVO();
			agreementVO.setAgreement_status("D0000001");
			agreementVO.setEvaluation_id(vo.getEvaluation_id());
			agreementVO.setReception_id(vo.getReception_id());
			result = agreementService.registration(agreementVO);
		}
		return result;
	}
	/**
	 * 평가위원 보안 사인 업데이트
	 */
	@Transactional
	public int updateCommissionerSignSecurity(EvaluationCommissionerVO vo) throws Exception {
		int result = evaluationDao.updateEvaluationCommissionerInfo(vo);
		return result;
	}
	/**
	 * 평가위원 지급 사인 업데이트
	 */
	@Transactional
	public int updateCommissionerSignPayment(EvaluationCommissionerVO vo) throws Exception {
		int result = evaluationDao.updateEvaluationCommissionerInfo(vo);
		return result;
	}
	/**
	 * 평가위원 평가 완료 사인 업데이트
	 */
	@Transactional
	public int updateCommissionerSignEvaluation(EvaluationCommissionerVO vo) throws Exception {
		int result = evaluationDao.updateEvaluationCommissionerInfo(vo);
		return result;
	}
	/**
	 * 위원장 평가 완료 사인 저장
	 */
	@Transactional
	public int updateCommissionerSignChairmanEvaluation(EvaluationCommissionerVO vo) throws Exception {
		int result = evaluationDao.updateEvaluationCommissionerInfo(vo);
		return result;
	}
	
	
	
	
	
	/**
	 * 평가위원 보안서약서 저장
	 */
	@Transactional
	public int updateCommissionerAgreeSecurity(EvaluationCommissionerVO vo) throws Exception {
		int result = evaluationDao.updateEvaluationCommissionerInfo(vo);
		return result;
	}
	/**
	 * 평가위원 지급서약서 저장
	 */
	@Transactional
	public int updateCommissionerAgreePayment(EvaluationCommissionerVO vo) throws Exception {
		int result = evaluationDao.updateEvaluationCommissionerInfo(vo);
		return result;
	}
	/**
	 * 평가 위원 평가서 제출
	 */
	@Transactional
	public int updateCommissionerSubmitEvaluation(EvaluationCommissionerVO vo) throws Exception {
		int result = evaluationDao.updateEvaluationCommissionerInfo(vo);
		return result;
	}
	/**
	 * 평가 위원장 평가서 제출
	 */
	@Transactional
	public int updateCommissionerChairmanEvaluation(EvaluationCommissionerVO vo) throws Exception {
		int result = evaluationDao.updateEvaluationCommissionerInfo(vo);
		return result;
	}
	
	
	
	
	
	/**
	 * 평가에 선정된 평가위원 상세 정보 (EvaluationCommissioner)
	 */
	public EvaluationCommissionerVO selectEvaluationCommissionerDetail(EvaluationCommissionerVO vo) throws Exception {
		return evaluationDao.selectEvaluationCommissionerDetail(vo);
	}
	/**
	 * 평가항목 등록
	 */
	@Transactional
	public int registrationItem(EvaluationItemVO vo) throws Exception {
		// 기존 정보는 지운다. Templete으로 하나의 Type(A1,A2,A3,B1,B2,B3)에 하나의 데이터만 존재한다.
		evaluationDao.deleteItem(vo);
		int result = evaluationDao.insertItem(vo);
		return result;
	}
	/**
	 * 과제에 연결된 평가 항목으로 등록
	 */
	@Transactional
	public int registrationReleatedItem(EvaluationItemVO vo) throws Exception {
		// 기존 정보는 지우고 다시 입력
		evaluationDao.deleteReleatedItem(vo);
		int result = evaluationDao.insertReleatedItem(vo);
		// 평가 항목 등록 완료 Flag 설정
		result = evaluationDao.updateItemCompleteYN(vo);
		return result;
	}
	/**
	 * 과제에 연결된 평가 항목으로 등록
	 */
	@Transactional
	public List<EvaluationItemVO> selectReleatedItemDetail(EvaluationItemVO vo) throws Exception {
		List<Map<String, Object>> releatedItemList = evaluationDao.selectReleatedItemList(vo);
		// 과제에 할당되어 있는 평가 목록으로 변경한다. 
		List<EvaluationItemVO> evaluationItemVOList = new ArrayList<>();
		if (releatedItemList != null && releatedItemList.size() >0 ) {
			Map<Object, Map<Object, List<Map<String, Object>>>> releatedItemMap = releatedItemList.stream()
					  .collect(
							  Collectors.groupingBy((map1) -> map1.get("ITEM_TYPE"),Collectors.groupingBy((map2) -> map2.get("FORM_ITEM_ID")))
				  			);
			// 해당 구조체를 변경	
			releatedItemMap.forEach((key, value)->{
				EvaluationItemVO evaluationItemVO = new EvaluationItemVO();
				List<ItemFormInfo> ItemFormInfoList = new ArrayList<>();
				
				value.forEach((key2, value2)->{
		    		ItemFormInfo resultItemInfo = new ItemFormInfo();
		    		List<ItemFormDetailInfo> itemFormDetailInfoList = new ArrayList<>();
		    		
		    		for (Map<String, Object> item : value2) { 
		    			evaluationItemVO.setItem_type(item.get("ITEM_TYPE").toString());
		    			evaluationItemVO.setForm_title(item.get("FORM_TITLE").toString());
		    			
		    			resultItemInfo.setForm_item_name(item.get("FORM_ITEM_NAME").toString());
		    			resultItemInfo.setForm_item_id(item.get("FORM_ITEM_ID").toString());
		    			
		    			ItemFormDetailInfo resultItemDetailInfo  = new ItemFormDetailInfo();
		    			resultItemDetailInfo.setItem_id(Integer.parseInt(item.get("ITEM_ID").toString()));
		    			resultItemDetailInfo.setForm_item_seq(Integer.parseInt(item.get("FORM_ITEM_SEQ").toString()));
		    			resultItemDetailInfo.setForm_item_detail_name(item.get("FORM_ITEM_DETAIL_NAME").toString());
		    			resultItemDetailInfo.setForm_item_result(item.get("FORM_ITEM_RESULT").toString());
		    			itemFormDetailInfoList.add(resultItemDetailInfo);
			    	}
		    		
		    		resultItemInfo.setItem_form_detail_info_list(itemFormDetailInfoList);
		    		ItemFormInfoList.add(resultItemInfo);
		    	});
				
				evaluationItemVO.setItem_releated_list(ItemFormInfoList);
				evaluationItemVOList.add(evaluationItemVO);
		    });
		}
		
		return evaluationItemVOList;
	}
	
	
	
	/**
	 * 과제와 연계된 평가 항목 리스트
	 */
	public List<EvaluationItemVO> selectReleatedItemList(EvaluationItemVO vo) throws Exception {
		vo.setEvaluation_id(vo.getEvaluation_id_list().get(0));
		List<Map<String, Object>> releatedItemList = evaluationDao.selectReleatedItemList(vo);
		List<Map<String, Object>> unreleatedItemList = evaluationDao.selectUnreleatedItemList(vo);
		
		
//		{
//		B2 = {
//			1 = [{
//				FORM_ITEM_NAME = B2_검토항목_01,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 24,
//				FORM_ITEM_RESULT = 적합,
//				FORM_TITLE = B2_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = B2,
//				FORM_ITEM_DETAIL_NAME = B2_검토항목_01_검토의견_01
//			}, {
//				FORM_ITEM_NAME = B2_검토항목_01,
//				FORM_ITEM_SEQ = 2,
//				ITEM_TEMPLETE_ID = 25,
//				FORM_ITEM_RESULT = 적합,
//				FORM_TITLE = B2_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = B2,
//				FORM_ITEM_DETAIL_NAME = B2_검토항목_01_검토의견_02
//			}, {
//				FORM_ITEM_NAME = B2_검토항목_01,
//				FORM_ITEM_SEQ = 3,
//				ITEM_TEMPLETE_ID = 26,
//				FORM_ITEM_RESULT = 적합,
//				FORM_TITLE = B2_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = B2,
//				FORM_ITEM_DETAIL_NAME = B2_검토항목_01_검토의견_03
//			}],
//			2 = [{
//				FORM_ITEM_NAME = B2_검토항목_02,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 27,
//				FORM_ITEM_RESULT = 적합,
//				FORM_TITLE = B2_테스트,
//				FORM_ITEM_ID = 2,
//				ITEM_TYPE = B2,
//				FORM_ITEM_DETAIL_NAME = B2_검토항목_02_검토의견_01
//			}, {
//				FORM_ITEM_NAME = B2_검토항목_02,
//				FORM_ITEM_SEQ = 2,
//				ITEM_TEMPLETE_ID = 28,
//				FORM_ITEM_RESULT = 적합,
//				FORM_TITLE = B2_테스트,
//				FORM_ITEM_ID = 2,
//				ITEM_TYPE = B2,
//				FORM_ITEM_DETAIL_NAME = B2_검토항목_02_검토의견_02
//			}],
//			3 = [{
//				FORM_ITEM_NAME = B2_검토항목_03,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 29,
//				FORM_ITEM_RESULT = 적합,
//				FORM_TITLE = B2_테스트,
//				FORM_ITEM_ID = 3,
//				ITEM_TYPE = B2,
//				FORM_ITEM_DETAIL_NAME = B2_검토항목_03_검토의견_1
//			}]
//		}, A1 = {
//			1 = [{
//				FORM_ITEM_NAME = A1_테스트_항목1,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 10,
//				FORM_ITEM_RESULT = 11,
//				FORM_TITLE = A1_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = A1,
//				FORM_ITEM_DETAIL_NAME = A1_테스트_지표1_1
//			}, {
//				FORM_ITEM_NAME = A1_테스트_항목1,
//				FORM_ITEM_SEQ = 2,
//				ITEM_TEMPLETE_ID = 11,
//				FORM_ITEM_RESULT = 22,
//				FORM_TITLE = A1_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = A1,
//				FORM_ITEM_DETAIL_NAME = A1_테스트_지표1_2
//			}],
//			2 = [{
//				FORM_ITEM_NAME = A1_테스트_항목2,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 12,
//				FORM_ITEM_RESULT = 33,
//				FORM_TITLE = A1_테스트,
//				FORM_ITEM_ID = 2,
//				ITEM_TYPE = A1,
//				FORM_ITEM_DETAIL_NAME = A1_테스트_지표2_1
//			}, {
//				FORM_ITEM_NAME = A1_테스트_항목2,
//				FORM_ITEM_SEQ = 2,
//				ITEM_TEMPLETE_ID = 13,
//				FORM_ITEM_RESULT = 44,
//				FORM_TITLE = A1_테스트,
//				FORM_ITEM_ID = 2,
//				ITEM_TYPE = A1,
//				FORM_ITEM_DETAIL_NAME = A1_테스트_지표2_2
//			}, {
//				FORM_ITEM_NAME = A1_테스트_항목2,
//				FORM_ITEM_SEQ = 3,
//				ITEM_TEMPLETE_ID = 14,
//				FORM_ITEM_RESULT = 55,
//				FORM_TITLE = A1_테스트,
//				FORM_ITEM_ID = 2,
//				ITEM_TYPE = A1,
//				FORM_ITEM_DETAIL_NAME = A1_테스트_지표2_3
//			}],
//			3 = [{
//				FORM_ITEM_NAME = A1_테스트_항목3,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 15,
//				FORM_ITEM_RESULT = 66,
//				FORM_TITLE = A1_테스트,
//				FORM_ITEM_ID = 3,
//				ITEM_TYPE = A1,
//				FORM_ITEM_DETAIL_NAME = A1_테스트_지표3_1
//			}]
//		}, A2 = {
//			1 = [{
//				FORM_ITEM_NAME = 항목1,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 5,
//				FORM_ITEM_RESULT = 1,
//				FORM_TITLE = A2_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = A2,
//				FORM_ITEM_DETAIL_NAME = A2_지표1_1
//			}, {
//				FORM_ITEM_NAME = 항목1,
//				FORM_ITEM_SEQ = 2,
//				ITEM_TEMPLETE_ID = 6,
//				FORM_ITEM_RESULT = 2,
//				FORM_TITLE = A2_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = A2,
//				FORM_ITEM_DETAIL_NAME = A2_지표1_2
//			}, {
//				FORM_ITEM_NAME = 항목1,
//				FORM_ITEM_SEQ = 3,
//				ITEM_TEMPLETE_ID = 7,
//				FORM_ITEM_RESULT = 3,
//				FORM_TITLE = A2_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = A2,
//				FORM_ITEM_DETAIL_NAME = A2_지표1_3
//			}],
//			2 = [{
//				FORM_ITEM_NAME = 항목2,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 8,
//				FORM_ITEM_RESULT = 4,
//				FORM_TITLE = A2_테스트,
//				FORM_ITEM_ID = 2,
//				ITEM_TYPE = A2,
//				FORM_ITEM_DETAIL_NAME = A2_지표2_1
//			}, {
//				FORM_ITEM_NAME = 항목2,
//				FORM_ITEM_SEQ = 2,
//				ITEM_TEMPLETE_ID = 9,
//				FORM_ITEM_RESULT = 5,
//				FORM_TITLE = A2_테스트,
//				FORM_ITEM_ID = 2,
//				ITEM_TYPE = A2,
//				FORM_ITEM_DETAIL_NAME = A2_지표2_2
//			}]
//		}, B1 = {
//			1 = [{
//				FORM_ITEM_NAME = B1_항목_01,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 16,
//				FORM_ITEM_RESULT = 적합,
//				FORM_TITLE = B1_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = B1,
//				FORM_ITEM_DETAIL_NAME = B1_항목01_의견_01
//			}, {
//				FORM_ITEM_NAME = B1_항목_01,
//				FORM_ITEM_SEQ = 2,
//				ITEM_TEMPLETE_ID = 17,
//				FORM_ITEM_RESULT = 부적합,
//				FORM_TITLE = B1_테스트,
//				FORM_ITEM_ID = 1,
//				ITEM_TYPE = B1,
//				FORM_ITEM_DETAIL_NAME = B1_항목01_의견_02
//			}],
//			2 = [{
//				FORM_ITEM_NAME = B1_항목_02,
//				FORM_ITEM_SEQ = 1,
//				ITEM_TEMPLETE_ID = 18,
//				FORM_ITEM_RESULT = 적합,
//				FORM_TITLE = B1_테스트,
//				FORM_ITEM_ID = 2,
//				ITEM_TYPE = B1,
//				FORM_ITEM_DETAIL_NAME = B1_항목02_의견_01
//			}, {
//				FORM_ITEM_NAME = B1_항목_02,
//				FORM_ITEM_SEQ = 2,
//				ITEM_TEMPLETE_ID = 19,
//				FORM_ITEM_RESULT = 적합,
//				FORM_TITLE = B1_테스트,
//				FORM_ITEM_ID = 2,
//				ITEM_TYPE = B1,
//				FORM_ITEM_DETAIL_NAME = B1_항목02_의견_02
//			}]
//		}
//	}
		// 위의 데이터를 Send Form으로 변경한다.
		// 과제에 할당되지 않은 평가 목록으로 변경한다. 
		List<EvaluationItemVO> evaluationItemVOList = new ArrayList<>();
		if (unreleatedItemList != null && unreleatedItemList.size() >0 ) {
			Map<Object, Map<Object, List<Map<String, Object>>>> unreleatedItemMap = unreleatedItemList.stream()
					  .collect(
							  Collectors.groupingBy((map1) -> map1.get("ITEM_TYPE"),Collectors.groupingBy((map2) -> map2.get("FORM_ITEM_ID")))
							  );
			// 해당 구조체를 변경	
			unreleatedItemMap.forEach((key, value)->{
				EvaluationItemVO evaluationItemVO = new EvaluationItemVO();
				List<ItemFormInfo> ItemFormInfoList = new ArrayList<>();
				
				value.forEach((key2, value2)->{
		    		ItemFormInfo resultItemInfo = new ItemFormInfo();
		    		List<ItemFormDetailInfo> itemFormDetailInfoList = new ArrayList<>();
		    		
		    		for (Map<String, Object> item : value2) { 
		    			evaluationItemVO.setItem_type(item.get("ITEM_TYPE").toString());
		    			evaluationItemVO.setForm_title(item.get("FORM_TITLE").toString());
		    			
		    			resultItemInfo.setForm_item_name(item.get("FORM_ITEM_NAME").toString());
		    			resultItemInfo.setForm_item_id(item.get("FORM_ITEM_ID").toString());
		    			
		    			ItemFormDetailInfo resultItemDetailInfo  = new ItemFormDetailInfo();
		    			resultItemDetailInfo.setForm_item_seq(Integer.parseInt(item.get("FORM_ITEM_SEQ").toString()));
		    			resultItemDetailInfo.setForm_item_detail_name(item.get("FORM_ITEM_DETAIL_NAME").toString());
		    			resultItemDetailInfo.setForm_item_result(item.get("FORM_ITEM_RESULT").toString());
		    			itemFormDetailInfoList.add(resultItemDetailInfo);
			    	}
		    		
		    		resultItemInfo.setItem_form_detail_info_list(itemFormDetailInfoList);
		    		ItemFormInfoList.add(resultItemInfo);
		    	});
				
				evaluationItemVO.setItem_unreleated_list(ItemFormInfoList);
				evaluationItemVOList.add(evaluationItemVO);
		    });
		}
		
		// 과제에 할당되어 있는 평가 목록으로 변경한다. 
		if (releatedItemList != null && releatedItemList.size() >0 ) {
			Map<Object, Map<Object, List<Map<String, Object>>>> releatedItemMap = releatedItemList.stream()
					  .collect(
							  Collectors.groupingBy((map1) -> map1.get("ITEM_TYPE"),Collectors.groupingBy((map2) -> map2.get("FORM_ITEM_ID")))
				  			);
			// 해당 구조체를 변경	
			releatedItemMap.forEach((key, value)->{
				EvaluationItemVO evaluationItemVO = new EvaluationItemVO();
				List<ItemFormInfo> ItemFormInfoList = new ArrayList<>();
				
				value.forEach((key2, value2)->{
		    		ItemFormInfo resultItemInfo = new ItemFormInfo();
		    		List<ItemFormDetailInfo> itemFormDetailInfoList = new ArrayList<>();
		    		
		    		for (Map<String, Object> item : value2) { 
		    			evaluationItemVO.setItem_type(item.get("ITEM_TYPE").toString());
		    			evaluationItemVO.setForm_title(item.get("FORM_TITLE").toString());
		    			
		    			resultItemInfo.setForm_item_name(item.get("FORM_ITEM_NAME").toString());
		    			resultItemInfo.setForm_item_id(item.get("FORM_ITEM_ID").toString());
		    			
		    			ItemFormDetailInfo resultItemDetailInfo  = new ItemFormDetailInfo();
		    			resultItemDetailInfo.setForm_item_seq(Integer.parseInt(item.get("FORM_ITEM_SEQ").toString()));
		    			resultItemDetailInfo.setForm_item_detail_name(item.get("FORM_ITEM_DETAIL_NAME").toString());
		    			resultItemDetailInfo.setForm_item_result(item.get("FORM_ITEM_RESULT").toString());
		    			itemFormDetailInfoList.add(resultItemDetailInfo);
			    	}
		    		
		    		resultItemInfo.setItem_form_detail_info_list(itemFormDetailInfoList);
		    		ItemFormInfoList.add(resultItemInfo);
		    	});
				
				evaluationItemVO.setItem_releated_list(ItemFormInfoList);
				evaluationItemVOList.add(evaluationItemVO);
		    });
		}
		 
		return evaluationItemVOList;
	}
	
	
	public List<EvaluationVO> searchExcelDownload(EvaluationSearchVO vo) throws Exception {
		HashMap<String, Object> search = new HashMap<String, Object>();
		
		if (  StringUtils.isEmpty(vo.getAnnouncement_type()) == false  ) {
			search.put("announcement_type", vo.getAnnouncement_type());	
		}
		
		return evaluationDao.searchExcelDownload(new DataMap(search));
	}
	
	
}
