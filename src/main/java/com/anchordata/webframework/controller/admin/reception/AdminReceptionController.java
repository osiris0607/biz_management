package com.anchordata.webframework.controller.admin.reception;

import java.util.List;
import java.util.Map;

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
import com.anchordata.webframework.service.reception.ReceptionExpertVO;
import com.anchordata.webframework.service.reception.ReceptionSearchVO;
import com.anchordata.webframework.service.reception.ReceptionService;
import com.anchordata.webframework.service.reception.ReceptionVO;


@Controller("AdminReceptionController")
public class AdminReceptionController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private ReceptionService receptionService;
	@Autowired
	private EmailSMSService emailSMSService;
	
	/**
	*  접수 Main 화면 이동
	*/
	@RequestMapping("/admin/fwd/reception/main")
	public ModelAndView fwdReception(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("reception/main.admin");
		return mv;
	}	
	/**
	*  기술 메칭 Main 화면 이동
	*/
	@RequestMapping("/admin/fwd/reception/match/main")
	public ModelAndView fwdTechMatch(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/main.admin");
		return mv;
	}
	/**
	*  기술 메칭 - 기술컨설팅 접수의 전문가 매칭 신청서 상세
	*/
	@RequestMapping("/admin/fwd/reception/match/consultingExpertDetail")
	public ModelAndView fwdDetailConsultingExpert(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/consultingExpertDetail.admin");
		return mv;
	}
	/**
	*  기술 메칭 - 기술연구개발 접수의 전문가 매칭 신청서 상세
	*/
	@RequestMapping("/admin/fwd/reception/match/researchExpertDetail")
	public ModelAndView fwdDetailResearchExpert(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/researchExpertDetail.admin");
		return mv;
	}
	/**
	*  기술 메칭 - 기술컨설팅 전문가 매칭 쉬초 확인 Page
	*/
	@RequestMapping("/admin/fwd/reception/match/consultingExpertCancel")
	public ModelAndView fwdConsultingExpertCancel(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/consultingExpertCancel.admin");
		return mv;
	}	
	/**
	*  기술 메칭 - 기술연구개발 전문가 매칭 쉬초 확인 Page
	*/
	@RequestMapping("/admin/fwd/reception/match/researchExpertCancel")
	public ModelAndView fwdResearchExpertCancel(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/consultingExpertCancel.admin");
		return mv;
	}	
	/**
	*  기술 메칭 - 기술컨설팅 전문가 매칭 진행 중 확인 Page
	*/
	@RequestMapping("/admin/fwd/reception/match/consultingExpertProgress")
	public ModelAndView fwdㅊCnsultingExpertProgress(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/consultingExpertProgress.admin");
		return mv;
	}	
	/**
	*  기술 메칭 - 기술연구개발 전문가 매칭 진행 중 확인 Page
	*/
	@RequestMapping("/admin/fwd/reception/match/researchExpertProgress")
	public ModelAndView fwdResearchExpertProgress(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/researchExpertProgress.admin");
		return mv;
	}
	/**
	*  기술 메칭 - 기술컨설팅 전문가 매칭 진행 완료 확인 Page
	*/
	@RequestMapping("/admin/fwd/reception/match/consultingExpertClosed")
	public ModelAndView fwdConsultingExpertClosed(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/consultingExpertClosed.admin");
		return mv;
	}	
	/**
	*  기술 메칭 - 기술연구개발 전문가 매칭 진행 완료 확인 Page
	*/
	@RequestMapping("/admin/fwd/reception/match/researchExpertClosed")
	public ModelAndView fwdResearchExpertClosed(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/researchExpertClosed.admin");
		return mv;
	}
	/**
	*  기술 메칭 - 기술컨설팅 접수 상태 확인 Page
	*/
	@RequestMapping("/admin/fwd/reception/match/consultingDetail")
	public ModelAndView fwdConsultingDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/consultingDetail.admin");
		return mv;
	}
	/**
	*  기술 메칭 - 기술연구 접수 상태 확인 Page
	*/
	@RequestMapping("/admin/fwd/reception/match/researchDetail")
	public ModelAndView fwdㄲesearchDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/match/researchDetail.admin");
		return mv;
	}
	
	
	/**
	*  접수 - 기술 메칭 화면에서 조회하는 공고 상세
	*/
	@RequestMapping("/admin/fwd/reception/match/announcementDetail")
	public ModelAndView fwdAnnouncementDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/announcementDetail.admin");
		return mv;
	}
	/**
	*  접수 - 기술매칭의  전문가 신청사 관리자가 전문가를 확인하기 위한 화면
	*/
	@RequestMapping("/admin/fwd/reception/expert/review")
	public ModelAndView fwdExpertReview(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/expertReview.admin");
		return mv;
	}
	/**
	*   접수 - 기술 매칭 시 EMAIL / SMS 내용 Setting
	*/
	@RequestMapping("/admin/fwd/reception/match/emailSMS/setup")
	public ModelAndView fwdSetEmailSMS(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/setEmailSMS.admin");
		return mv;
	}
	/**
	*   접수 - 전문가 참여 현황 페이지
	*/
	@RequestMapping("/admin/fwd/reception/match/expertParticipation")
	public ModelAndView fwdExpertParticipation(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/expertParticipation.admin");
		return mv;
	}
	/**
	*   기술 공모 Main 화면 이동
	*/
	@RequestMapping("/admin/fwd/reception/contest/main")
	public ModelAndView fwdContestMain(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/contest/main.admin");
		return mv;
	}
	/**
	*   기술 공모 상세
	*/
	@RequestMapping("/admin/fwd/reception/contest/detail")
	public ModelAndView fwdContestDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/contest/detail.admin");
		return mv;
	}
	
	
	/**
	*   기술 제안 Main 화면 이동
	*/
	@RequestMapping("/admin/fwd/reception/proposal/main")
	public ModelAndView fwdProposalMain(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/proposal/main.admin");
		return mv;
	}
	/**
	*   기술 제안 상세
	*/
	@RequestMapping("/admin/fwd/reception/proposal/detail")
	public ModelAndView fwdProposalDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("reception/proposal/detail.admin");
		return mv;
	}
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	*  접수 리스트
	*/
	@RequestMapping("/admin/api/reception/search/paging")
	public ModelAndView detail(@ModelAttribute ReceptionSearchVO vo, ModelAndView mv) throws Exception {
		List<ReceptionVO> resList = receptionService.searchAdminReceptionList(vo);
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
	*  상세
	*/
	@RequestMapping("/admin/api/reception/detail")
	public ModelAndView detail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		ReceptionVO resultData = receptionService.detail(vo);
		mv.addObject("result", true);
		mv.addObject("result_data", resultData);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 희망 전문가 변경
	*/
	@RequestMapping("/admin/api/reception/tech/match/expert/modification")
	public ModelAndView modification(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		int result = receptionService.expertModification(vo);
		if ( result != 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 전문가 priority 변경
	*/
	@RequestMapping("/admin/api/reception/tech/match/expert/setPriority")
	public ModelAndView setPriority(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		int result = receptionService.expertSetPriority(vo);
		if ( result != 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}	
	/**
	* email / sms 발송 정보 설정
	* 접수 - 기술매칭 에서만 사용된다.
	*/
	@RequestMapping("/admin/api/reception/tech/match/emailSMS/registration")
	public ModelAndView setupEmailSMS(@ModelAttribute emailSMSVO vo, ModelAndView mv) throws Exception {
		int result = emailSMSService.registration(vo);
		if ( result != 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* email / sms 발송 정보 상세
	* 접수 - 기술매칭 에서만 사용된다.
	*/
	@RequestMapping("/admin/api/reception/tech/match/emailSMS/detail")
	public ModelAndView detailEmailSMS(@ModelAttribute emailSMSVO vo, ModelAndView mv) throws Exception {
		List<emailSMSVO> result = emailSMSService.detail(vo);
		if ( result != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* email 발송
	*/
	@RequestMapping("/admin/api/reception/tech/match/emailSMS/sendMail")
	public ModelAndView sendMail(@ModelAttribute emailSMSVO vo, ModelAndView mv) throws Exception {
		System.out.println("VO Mail ---------> " + vo.getTo_mail());
		boolean result = emailSMSService.sendMail(vo);
		if ( result == true) {
			// D0000004 - 매칭 신청인 경우에만 메일 혹은 문자를 보냈을 경우에 매칭 진행 중 status 로 바뀐다. 나머지 Status에서는 그냥 메일만 보낸다.
			// 마참가지로 전문가의 Participation status도  D0000004 인 경우에만 바꾼다.
			// D0000004가 아닌 경우는 이미 한번 이상 메잉 혹은 문자를 전송한 상태이다. D0000004 에서 메일 혹은 문자를 전송해야 다른 Status로 바뀐다.
			if ( vo.getReception_status().compareToIgnoreCase("D0000004") == 0) {
				// reception status 변경 (매칭 진행 중)
				ReceptionVO receptionVO = new ReceptionVO();
				receptionVO.setReception_id(vo.getReception_id());
				// D0000005 - 매칭 진행 중으로 변경
				receptionVO.setReception_status("D0000005");
				receptionService.updateReceptionStatus(receptionVO);
				
				// reception expert 참여여부 status 변경 (메일 발송 중)
				for (int i=0; i<vo.getExpert_member_ids().size(); i++) {
					ReceptionExpertVO receptionExpertVO = new ReceptionExpertVO();	
					receptionExpertVO.setReception_id(vo.getReception_id());
					receptionExpertVO.setMember_id(vo.getExpert_member_ids().get(i));
					// D0000001 - 메일을 전송한 상태이므로 미회신으로 변경한다.
					receptionExpertVO.setParticipation_type("D0000001");
					receptionService.updateExpertParticipation(receptionExpertVO);
				}
			}
			// 메일 발송 시간만 업데이트 한다.
			else {
				// reception status 변경 (매칭 진행 중)
				ReceptionVO receptionVO = new ReceptionVO();
				receptionVO.setReception_id(vo.getReception_id());
				// D0000005 - 매칭 진행 중으로 변경
				receptionVO.setReception_status(vo.getReception_status());
				receptionService.updateReceptionStatus(receptionVO);
			}
			mv.addObject("result", true);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/admin/api/reception/tech/match/emailSMS/sendSMS")
	public ModelAndView sendSMS(@ModelAttribute emailSMSVO vo, ModelAndView mv) throws Exception {
		System.out.println("VO Mail ---------> " + vo.getTo_phone());
		boolean result = emailSMSService.sendSMS(vo);
		if ( result == true) {
			// D0000004 - 매칭 신청인 경우에만 메일 혹은 문자를 보냈을 경우에 매칭 진행 중 status 로 바뀐다. 나머지 Status에서는 그냥 메일만 보낸다.
			// 마참가지로 전문가의 Participation status도  D0000004 인 경우에만 바꾼다.
			// D0000004가 아닌 경우는 이미 한번 이상 메잉 혹은 문자를 전송한 상태이다. D0000004 에서 메일 혹은 문자를 전송해야 다른 Status로 바뀐다.
			if ( vo.getReception_status().compareToIgnoreCase("D0000004") == 0) {
				// reception status 변경 (매칭 진행 중)
				ReceptionVO receptionVO = new ReceptionVO();
				receptionVO.setReception_id(vo.getReception_id());
				// D0000005 - 매칭 진행 중으로 변경
				receptionVO.setReception_status("D0000005");
				receptionService.updateReceptionStatus(receptionVO);
				
				// reception expert 참여여부 status 변경 (메일 발송 중)
				for (int i=0; i<vo.getExpert_member_ids().size(); i++) {
					ReceptionExpertVO receptionExpertVO = new ReceptionExpertVO();	
					receptionExpertVO.setReception_id(vo.getReception_id());
					receptionExpertVO.setMember_id(vo.getExpert_member_ids().get(i));
					// D0000001 - 메일을 전송한 상태이므로 미회신으로 변경한다.
					receptionExpertVO.setParticipation_type("D0000001");
					receptionService.updateExpertParticipation(receptionExpertVO);
				}
			}
			// 메일 발송 시간만 업데이트 한다.
			else {
				// reception status 변경 (매칭 진행 중)
				ReceptionVO receptionVO = new ReceptionVO();
				receptionVO.setReception_id(vo.getReception_id());
				// D0000005 - 매칭 진행 중으로 변경
				receptionVO.setReception_status(vo.getReception_status());
				receptionService.updateReceptionStatus(receptionVO);
			}
			mv.addObject("result", true);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	* reception status 변경
	*/
	@RequestMapping("/admin/api/reception/updateStatus")
	public ModelAndView updateStatus(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		int result = receptionService.updateReceptionStatus(vo);
		if ( result != 0) {
			mv.addObject("result", true);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* reception 접수 완료
	*/
	@RequestMapping("/admin/api/reception/complete")
	public ModelAndView completeStatus(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		// 접수 번호 및 Status Update
		int result = receptionService.updateReceptionComplete(vo);
		if ( result != 0) {
			mv.addObject("result", true);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	 * 접수 정보 다운로드
	 * @return
	 */
	@RequestMapping("/admin/api/reception/excelDownload")
	public void excelDownload(@ModelAttribute ReceptionSearchVO vo, HttpServletResponse response) throws Exception {
		//전체 회원 정보 
		List<ReceptionVO> resList = receptionService.searchAdminReceptionAllList(vo);
		
		// Make Excel File
		// 워크북 생성
	    Workbook wb = new HSSFWorkbook();
	    Sheet sheet = wb.createSheet("접수정보");
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
	    cell.setCellValue("공고명");
	    cell = row.createCell(1);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("구분");
	    cell = row.createCell(2);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("제품/서비스명");
	    cell = row.createCell(3);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("기관명");
	    cell = row.createCell(4);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("성명");
	    cell = row.createCell(5);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("진행상태");
	    cell = row.createCell(6);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("접수번호");
	    cell = row.createCell(7);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("등록일");
	    
	    // 데이터 부분 생성
	    for(ReceptionVO listVO : resList) {
	        row = sheet.createRow(rowNo++);
	        cell = row.createCell(0);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAnnouncement_title());

	        cell = row.createCell(1);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAnnouncement_type_name() );

	        cell = row.createCell(2);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAnnouncement_business_name());
	        
	        cell = row.createCell(3);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getInstitution_name());
	        
	        cell = row.createCell(4);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getResearcher_name());
	        
	        String statusName = "";
	        if ( listVO.getReception_status().compareToIgnoreCase("D0000004") == 0 ) {
	        	statusName = "매칭 신청";
	        } else if ( listVO.getReception_status().compareToIgnoreCase("D0000005") == 0 ) {
	        	statusName = "매칭 진행 중";
	        }
	        
	        cell = row.createCell(5);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(statusName);
	        
	        cell = row.createCell(6);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getReception_reg_number());
	        
	        cell = row.createCell(7);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getReg_date());
	    }
	    
	    // 컨텐츠 타입과 파일명 지정
	    response.setContentType("ms-vnd/excel");
	    response.setHeader("Content-Disposition", "attachment;filename=reception_info.xls");

	    // 엑셀 출력
	    wb.write(response.getOutputStream());
	    wb.close();
	}
	/**
	* 등록
	*/
	@RequestMapping("/admin/api/reception/main/stat")
	public ModelAndView stat(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("result", true);
		Map<String,String> result = receptionService.selectMainState();
		mv.addObject("result_data", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
}
