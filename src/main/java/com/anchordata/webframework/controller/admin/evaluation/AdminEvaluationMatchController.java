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
		// ?????? ?????? type??? ??????	
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("evaluation/match/main.admin");
		return mv;
	}
	
	
	@RequestMapping("/admin/fwd/evaluation/match/main")
	public ModelAndView fwdMatchMain(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		// ?????? ?????? type??? ??????	
		vo.setAnnouncement_type("D0000005");
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("evaluation/match/main.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/contest/main")
	public ModelAndView fwdContestMain(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		// ?????? ?????? type??? ??????	
		vo.setAnnouncement_type("D0000003");
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("evaluation/match/main.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/evaluation/proposal/main")
	public ModelAndView fwdProposalMain(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		// ?????? ?????? type??? ??????	
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
	* OPEN API ??????
	/*******************************************************************************************************************
	
	/**
	* ???????????? ?????? List
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
	* ???????????? ?????? Detail
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
	* ???????????? ?????? ?????? ????????????
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
	* ???????????? Status ????????????
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
	* ???????????? ?????? ?????? ??????
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
	* ???????????? ?????? ?????? ?????????
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
	* ???????????? ??????
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
	* ????????? ????????? ???????????? ??????
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
	* ?????? ?????? ????????? ???????????? ???
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
	* ???????????? ?????? ??????
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
	* ???????????? ?????? ?????? ??????
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
			// ?????? ????????? ???????????? ?????? ?????? ????????? ?????? ?????? Flag??? ?????? ( evaluation ???????????? SEND_EMAIL_YN / SEND_EMAIL_DATE ???????????? )
			evaluationService.updateMailInfo(vo);
			// ?????? ????????? ???????????? ???????????? ????????? ??????
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
	* ???????????? ?????? ?????? ?????? ??????
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
			// ?????? ?????? ????????? ????????? ???????????? ?????? ?????? ????????? ?????? ?????? Flag??? ?????? ( evaluation ???????????? COMMISSIONER_YN ???????????? 'Y'. ?????? ?????? ?????? ?????? )
			vo.setCommissioner_yn("Y");
			evaluationService.updateMailInfo(vo);
			// ?????? ITEM_COMPLETE_YN = 'Y'?????? COMMISSIONER_YN = 'Y'??? ????????? ????????? Status??? 'D0000003'-???????????? ????????? ?????????.
			EvaluationVO resVO = evaluationService.selectStatusInfo(vo);
			if ( resVO.getItem_complete_yn().equals("Y")) {
				vo.setStatus("D0000003");
				evaluationService.updateStatus(vo);
			}
			// ????????? ???????????? ?????? ???????????? ????????? ????????????
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
	* ???????????? ????????? ?????? ????????????
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
	* ?????? ?????? ??????????????? ????????????
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
	* ?????? ?????? ??????
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
	* ????????? ????????? ?????? ???????????? ??????
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
	* ????????? ????????? ?????? ?????? ????????? ??????
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
	* ?????? ????????????
	*/
	@RequestMapping("/admin/api/evaluation/excelDownload")
	public void excelDownload(@ModelAttribute EvaluationSearchVO vo, HttpServletResponse response) throws Exception {
		//?????? ?????? ?????? 
		List<EvaluationVO> resList = evaluationService.searchExcelDownload(vo);
		
		// Make Excel File
		// ????????? ??????
	    Workbook wb = new HSSFWorkbook();
	    Sheet sheet = wb.createSheet("????????????");
	    Row row = null;
	    Cell cell = null;
	    int rowNo = 0;


	    // ????????? ????????? ?????????
	    CellStyle headStyle = wb.createCellStyle();
	    headStyle.setBorderTop(BorderStyle.THIN);
	    headStyle.setBorderBottom(BorderStyle.THIN);
	    headStyle.setBorderLeft(BorderStyle.THIN);
	    headStyle.setBorderRight(BorderStyle.THIN);

	    // ????????? ?????????
	    headStyle.setFillForegroundColor(HSSFColorPredefined.YELLOW.getIndex());
	    headStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

	    // ???????????? ????????? ???????????????.
	    headStyle.setAlignment(HorizontalAlignment.CENTER);

	    // ???????????? ?????? ????????? ???????????? ??????
	    CellStyle bodyStyle = wb.createCellStyle();
	    bodyStyle.setBorderTop(BorderStyle.THIN);
	    bodyStyle.setBorderBottom(BorderStyle.THIN);
	    bodyStyle.setBorderLeft(BorderStyle.THIN);
	    bodyStyle.setBorderRight(BorderStyle.THIN);

	    // ?????? ??????
	    row = sheet.createRow(rowNo++);
	    cell = row.createCell(0);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    cell = row.createCell(1);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    cell = row.createCell(2);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    cell = row.createCell(3);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("?????????");
	    cell = row.createCell(4);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("??????/????????????");
	    cell = row.createCell(5);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("?????????(?????????)");
	    cell = row.createCell(6);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("???????????? ?????????");
	    cell = row.createCell(7);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("???????????????");
	    cell = row.createCell(8);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    cell = row.createCell(9);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    cell = row.createCell(10);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    cell = row.createCell(11);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    cell = row.createCell(12);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    
	    // ????????? ?????? ??????
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
	    
	    // ????????? ????????? ????????? ??????
	    response.setContentType("ms-vnd/excel");
	    response.setHeader("Content-Disposition", "attachment;filename=evaluation_info.xls");

	    // ?????? ??????
	    wb.write(response.getOutputStream());
	    wb.close();
	}
	
	
	
}
