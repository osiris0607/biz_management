package com.anchordata.webframework.controller.admin.evaluation;



import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor.HSSFColorPredefined;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.emailSMS.EmailSMSService;
import com.anchordata.webframework.service.emailSMS.emailSMSVO;
import com.anchordata.webframework.service.evaluation.EvaluationCommissionerVO;
import com.anchordata.webframework.service.evaluation.EvaluationItemVO;
import com.anchordata.webframework.service.evaluation.EvaluationSearchVO;
import com.anchordata.webframework.service.evaluation.EvaluationService;
import com.anchordata.webframework.service.evaluation.EvaluationVO;
import com.anchordata.webframework.service.member.CommissionerSearchVO;
import com.anchordata.webframework.service.member.CommissionerService;
import com.anchordata.webframework.service.member.CommissionerVO;



@Controller("AdminEvaluationMatchController")
public class AdminEvaluationMatchController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private EvaluationService evaluationService;
	@Autowired
	private CommissionerService commissionerService;
	@Autowired
	private EmailSMSService emailSMSService;
	
	
	@RequestMapping("/admin/fwd/evaluation/main")
	public ModelAndView fwdEvaluationMain(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		// 평가 매칭 type을 전달	
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("evaluation/match/main.admin");
		return mv;
	}
	
	
	@RequestMapping("/admin/fwd/evaluation/match/main")
	public ModelAndView fwdMatchMain(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		// 평가 매칭 type을 전달	
		vo.setAnnouncement_type("D0000005");
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("evaluation/match/main.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/contest/main")
	public ModelAndView fwdContestMain(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		// 평가 매칭 type을 전달	
		vo.setAnnouncement_type("D0000003");
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("evaluation/match/main.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/proposal/main")
	public ModelAndView fwdProposalMain(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		// 평가 매칭 type을 전달	
		vo.setAnnouncement_type("D0000004");
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("evaluation/match/main.admin");
		return mv;
	}
	
	
	@RequestMapping("/admin/fwd/evaluation/match/detail")
	public ModelAndView fwdDetail(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("evaluation/match/detail.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/match/commissioner/regist")
	public ModelAndView fwdRegistEvaluator(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.setViewName("evaluation/match/commissionerList.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/match/commissioner/registComplete")
	public ModelAndView fwdRegistResult(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/match/commissionerComplete.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/match/commissioner/detail")
	public ModelAndView fwdCommissionerDetail(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/match/commissionerDetail");
		return mv;
	}
	
	
	@RequestMapping("/admin/fwd/evaluation/match/commissioner/report/security")
	public ModelAndView fwdReportSecurity(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/match/reportSecurity");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/match/commissioner/report/payment")
	public ModelAndView fwdReportPayment(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/match/reportPayment");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/match/commissioner/report/estimation")
	public ModelAndView fwdReportEstimation(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/match/reportEstimation");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/match/commissioner/report/finalEstimation")
	public ModelAndView fwdReportFinalEstimation(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/match/reportFinalEstimation");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/match/item/registration")
	public ModelAndView fwdItemRegist(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/match/itemRegistration.admin");
		return mv;
	}
	
	
	/*******************************************************************************************************************
	* OPEN API 호출
	/*******************************************************************************************************************
	
	/**
	* 기술매칭 평가 List
	*/
	@RequestMapping("/admin/api/evaluation/match/search/paging")
		public ModelAndView searchPagingList(@ModelAttribute EvaluationSearchVO vo, ModelAndView mv) throws Exception {
		List<EvaluationVO> resList = evaluationService.searchPagingList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
			mv.addObject("totalCount", resList.get(0).getTotal_count());
		} else {
			mv.addObject("result", false);
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 기술매칭 평가 Detail
	*/
	@RequestMapping("/admin/api/evaluation/match/search/detail")
		public ModelAndView searchDetail(@ModelAttribute EvaluationSearchVO vo, ModelAndView mv) throws Exception {
		EvaluationVO result = evaluationService.detail(vo);
		if (result != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 기술매칭 평가 정보 업데이트
	*/
	@RequestMapping("/admin/api/evaluation/match/update")
		public ModelAndView updateEvaluationInfo(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateEvaluationInfo(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 기술매칭 Status 업데이트
	*/
	@RequestMapping("/admin/fwd/evaluation/match/update/status")
		public ModelAndView updateStatus(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		int result = 0;
		for (String regNumber:vo.getUpdate_evaluation_reg_number_list()) {
			vo.setEvaluation_reg_number(regNumber);
			result = evaluationService.updateStatus(vo);
		}
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}	
	/**
	* 기술매칭 평가 번호 생성
	*/
	@RequestMapping("/admin/api/evaluation/match/create/evaluationNumber")
		public ModelAndView createEvaluationNumber(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.createEvaluationNumber(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 기술매칭 평가 번호 초기화
	*/
	@RequestMapping("/admin/api/evaluation/match/clear/evaluationNumber")
		public ModelAndView clearEvaluationNumber(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.clearEvaluationNumber(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가위원 검색
	*/
	@RequestMapping("/admin/api/evaluation/match/commissioner/search/paging")
		public ModelAndView searchCommissionerPagingList(@ModelAttribute CommissionerSearchVO vo, ModelAndView mv) throws Exception {
		List<CommissionerVO> resList = commissionerService.searchPagingList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
			mv.addObject("totalCount", resList.get(0).getTotal_count());
		} else {
			mv.addObject("result", false);
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가에 선정된 평가위원 검색
	*/
	@RequestMapping("/admin/api/evaluation/match/commissioner/search/pagingRelatedId")
		public ModelAndView searchRelatedIDPagingList(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		List<EvaluationCommissionerVO> resList = evaluationService.searchRelatedIDPagingList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
			mv.addObject("totalCount", resList.size());
		} else {
			mv.addObject("result", false);
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 소속 기관 유형별 평가위원 수
	*/
	@RequestMapping("/admin/api/evaluation/match/commissioner/search/institutionTypeCount")
		public ModelAndView searchInstitutionTypeCount(@ModelAttribute CommissionerSearchVO vo, ModelAndView mv) throws Exception {
		CommissionerVO resultVO = commissionerService.searchInstitutionTypeCount(vo);
		if (resultVO != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", resultVO);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가위원 자동 추출
	*/
	@RequestMapping("/admin/api/evaluation/match/commissioner/search/autoChoice")
		public ModelAndView searchAutoChoice(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		List<CommissionerVO> resList = commissionerService.searchAutoChoice(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
			mv.addObject("totalCount", resList.size());
		} else {
			mv.addObject("result", false);
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가위원 의향 메일 전송
	*/
	@RequestMapping("/admin/api/evaluation/match/commissioner/sendMail")
		public ModelAndView sendMail(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		
		emailSMSVO emailVO = new emailSMSVO();
		emailVO.setTo_mail(vo.getCommissioner_mail_list());
		emailVO.setTitle(vo.getMail_title());
		emailVO.setComment(vo.getMail_content());
		emailVO.setLink(vo.getMail_link());
		emailVO.setSender(vo.getMail_sender());
		boolean result = emailSMSService.sendMail(emailVO);
		
		if ( result == true) {
			// 메일 전송이 완료되면 해당 평가 항목의 메일 전송 Flag를 설정 ( evaluation 테이블의 SEND_EMAIL_YN / SEND_EMAIL_DATE 업데이트 )
			evaluationService.updateMailInfo(vo);
			// 평가 항목에 해당하는 평가위원 데이터 저장
			evaluationService.insertEvaluationCommissionerRelationInfo(vo);
			mv.addObject("result", true);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;		
	}
	/**
	* 평가위원 최종 선정 메일 전송
	*/
	@RequestMapping("/admin/api/evaluation/match/commissioner/sendCompleteMail")
		public ModelAndView sendCompleteMail(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		
		emailSMSVO emailVO = new emailSMSVO();
		emailVO.setTo_mail(vo.getCommissioner_mail_list());
		emailVO.setTitle(vo.getMail_title());
		emailVO.setComment(vo.getMail_content());
		emailVO.setLink(vo.getMail_link());
		emailVO.setSender(vo.getMail_sender());
		boolean result = emailSMSService.sendMail(emailVO);
		
		if ( result == true) {
			// 최종 선정 메일이 전송이 완료되면 해당 평가 항목의 메일 전송 Flag를 설정 ( evaluation 테이블의 COMMISSIONER_YN 업데이트 'Y'. 평가 위원 선정 완료 )
			vo.setCommissioner_yn("Y");
			evaluationService.updateMailInfo(vo);
			// 만약 ITEM_COMPLETE_YN = 'Y'이고 COMMISSIONER_YN = 'Y'인 평가가 있다면 Status를 'D0000003'-평가대기 상태로 바꾼다.
			EvaluationVO resVO = evaluationService.selectStatusInfo(vo);
			if ( resVO.getItem_complete_yn().equals("Y")) {
				vo.setStatus("D0000003");
				evaluationService.updateStatus(vo);
			}
			// 평가에 포함되어 있는 평가위원 데이터 업데이트
			EvaluationCommissionerVO relationVO = new EvaluationCommissionerVO();
			relationVO.setCommissioner_relation_list(vo.getCommissioner_list());
			relationVO.setChoice_yn("Y");
			evaluationService.updateEvaluationCommissionerRelationInfo(relationVO);
			mv.addObject("result", true);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;		
	}
	/**
	* 평가위원 위원장 선임 업데이트
	*/
	@RequestMapping("/admin/api/evaluation/match/commissioner/relationID/update/chairman")
		public ModelAndView updateCommissionerChairman(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateCommissionerChairmanYN(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가 상세 페이지에서 업데이트
	*/
	@RequestMapping("/admin/api/evaluation/match/update/detail")
		public ModelAndView updateDetailInfo(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateDetailInfo(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가 항목 등록
	*/
	@RequestMapping("/admin/api/evaluation/match/item/registration")
		public ModelAndView registrationItem(@ModelAttribute EvaluationItemVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.registrationItem(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 과제에 연결된 평가 항목으로 등록
	*/
	@RequestMapping("/admin/api/evaluation/match/releatedItem/registration")
		public ModelAndView registrationReleatedItem(@ModelAttribute EvaluationItemVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.registrationReleatedItem(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/*
	* 과제에 연결된 평가 항목 리스트 검색
	*/
	@RequestMapping("/admin/api/evaluation/match/releatedItem/search/list")
		public ModelAndView searchReleatedItemList(@ModelAttribute EvaluationItemVO vo, ModelAndView mv) throws Exception {
		List<EvaluationItemVO> result = evaluationService.selectReleatedItemList(vo);
		if (result != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}

	/*
	* 엑셀 다운로드
	*/
	@RequestMapping("/admin/api/evaluation/excelDownload")
	public void excelDownload(@ModelAttribute EvaluationSearchVO vo, HttpServletResponse response) throws Exception {
		//전체 회원 정보 
		List<EvaluationVO> resList = evaluationService.searchExcelDownload(vo);
		
		// Make Excel File
		// 워크북 생성
	    Workbook wb = new HSSFWorkbook();
	    Sheet sheet = wb.createSheet("평가정보");
	    Row row = null;
	    Cell cell = null;
	    int rowNo = 0;


	    // 테이블 헤더용 스타일
	    CellStyle headStyle = wb.createCellStyle();
	    headStyle.setBorderTop(BorderStyle.THIN);
	    headStyle.setBorderBottom(BorderStyle.THIN);
	    headStyle.setBorderLeft(BorderStyle.THIN);
	    headStyle.setBorderRight(BorderStyle.THIN);

	    // 배경색 노란색
	    headStyle.setFillForegroundColor(HSSFColorPredefined.YELLOW.getIndex());
	    headStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

	    // 데이터는 가운데 정렬합니다.
	    headStyle.setAlignment(HorizontalAlignment.CENTER);

	    // 데이터용 경계 스타일 테두리만 지정
	    CellStyle bodyStyle = wb.createCellStyle();
	    bodyStyle.setBorderTop(BorderStyle.THIN);
	    bodyStyle.setBorderBottom(BorderStyle.THIN);
	    bodyStyle.setBorderLeft(BorderStyle.THIN);
	    bodyStyle.setBorderRight(BorderStyle.THIN);

	    // 헤더 생성
	    row = sheet.createRow(rowNo++);
	    cell = row.createCell(0);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("접수번호");
	    cell = row.createCell(1);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("과제번호");
	    cell = row.createCell(2);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("평가번호");
	    cell = row.createCell(3);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("공고명");
	    cell = row.createCell(4);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("제품/서비스명");
	    cell = row.createCell(5);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("기관명(개인명)");
	    cell = row.createCell(6);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("담당간사 부서명");
	    cell = row.createCell(7);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("담당간사명");
	    cell = row.createCell(8);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("평가구분");
	    cell = row.createCell(9);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("평가유형");
	    cell = row.createCell(10);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("평가일자");
	    cell = row.createCell(11);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("평가결과");
	    cell = row.createCell(12);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("평가상태");
	    
	    // 데이터 부분 생성
	    for(EvaluationVO listVO : resList) {
	        row = sheet.createRow(rowNo++);
	        cell = row.createCell(0);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getReception_reg_number());

	        cell = row.createCell(1);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAgreement_reg_number() );

	        cell = row.createCell(2);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getEvaluation_reg_number());
	        
	        cell = row.createCell(3);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAnnouncement_title());
	        
	        cell = row.createCell(4);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getTech_info_name());
	        
	        cell = row.createCell(5);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getInstitution_name());
	        
	        cell = row.createCell(6);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getSteward_department());
	        
	        cell = row.createCell(7);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getSteward());
	        
	        cell = row.createCell(8);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getClassification_name());
	        
	        cell = row.createCell(9);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getType_name());
	        
	        cell = row.createCell(10);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getEvaluation_date());
	        
	        cell = row.createCell(11);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getResult_name());
	        
	        cell = row.createCell(12);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getStatus_name());
	    }
	    
	    // 컨텐츠 타입과 파일명 지정
	    response.setContentType("ms-vnd/excel");
	    response.setHeader("Content-Disposition", "attachment;filename=evaluation_info.xls");

	    // 엑셀 출력
	    wb.write(response.getOutputStream());
	    wb.close();
	}
	
	
	
}
