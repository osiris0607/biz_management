package com.anchordata.webframework.controller.admin.member;



import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.emailSMS.EmailSMSService;
import com.anchordata.webframework.service.emailSMS.emailSMSVO;
import com.anchordata.webframework.service.member.CommissionerSearchVO;
import com.anchordata.webframework.service.member.CommissionerService;
import com.anchordata.webframework.service.member.CommissionerVO;
import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;



@Controller("AdminCommissionerController")
public class AdminCommissionerController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private CommissionerService commissionerService;
	@Autowired
	private MemberService memberService;
	@Autowired
	private UploadFileService uploadFileService;
	@Autowired
	private EmailSMSService emailSMSService;
	
	
	
	
	@RequestMapping("/admin/fwd/member/commissioner/main")
	public ModelAndView fwdMainCommissioner(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("member/commissioner/main.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/member/commissioner/detail")
	public ModelAndView fwdCommissionerDetail(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("member/commissioner/detail.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/member/commissioner/acceptance")
	public ModelAndView fwdAcceptance(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("member/commissioner/acceptance.admin");
		return mv;
	}
	
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API ??????
	///////////////////////////////////////////////////////////////////////////
	
	/**
	* ?????? List
	*/
	@RequestMapping("/admin/api/member/commissioner/search/paging")
		public ModelAndView searchCommissioner(@ModelAttribute CommissionerSearchVO vo, ModelAndView mv) throws Exception {
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
	*  ??????
	*/
	@RequestMapping("/admin/api/member/commissioner/detail")
	public ModelAndView detail(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		CommissionerVO resultData = commissionerService.getDetail(vo);
		mv.addObject("result", true);
		mv.addObject("result_data", resultData);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  ?????? ????????????
	*/
	@RequestMapping("/admin/api/member/commissioner/update/status")
	public ModelAndView updateCommissionerStatus(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		if (commissionerService.updateCommissionerStatus(vo) > 0 ) {
			// ????????? ???????????? Flag???  ?????????.
			MemberVO memberVO = new MemberVO();
			memberVO.setMember_id(vo.getMember_id());
			// D0000004 - ??????????????? ????????????.
			if ( vo.getCommissioner_status().equals("D0000004") ) {
				memberVO.setAuth_level_commissioner("Y");
			} else {
				memberVO.setAuth_level_commissioner("N");
			}
			memberService.updateAuthLeveleCommissioner(memberVO);
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);	
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	*  ??????(remark) ????????????
	*/
	@RequestMapping("/admin/api/member/commissioner/update/remark")
	public ModelAndView updateCommissionerRemark(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		if ( commissionerService.updateCommissionerRemark(vo) > 0 ) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);	
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	/**
	 *  ???????????? ????????????
	 */
	@RequestMapping(value = "/admin/api/member/commissioner/download/{file_id}")
	public void downloadFile (@PathVariable("file_id") String fileId, HttpSession session, HttpServletResponse response) throws Exception {
		UploadFileVO UploadFileVO = new UploadFileVO();
		UploadFileVO.setFile_id(Integer.parseInt(fileId));
		UploadFileVO = uploadFileService.selectUploadFileContent(UploadFileVO);
		
		response.setContentType("application/octet-stream"); 
		response.setContentLength(UploadFileVO.getBinary_content().length); 
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(UploadFileVO.getName(),"UTF-8")+"\";"); 
		response.setHeader("Content-Transfer-Encoding", "binary"); 
		response.getOutputStream().write(UploadFileVO.getBinary_content()); 
		response.getOutputStream().flush(); 
		response.getOutputStream().close(); 
	}
	/**
	* email ??????
	*/
	@RequestMapping("/admin/api/member/commissioner/send/email")
	public ModelAndView sendMail(@ModelAttribute emailSMSVO vo, ModelAndView mv) throws Exception {
		System.out.println("vo, ?????????" + vo.getSender());
		boolean result = emailSMSService.sendMail(vo);
		
		if ( result == true) {
			// ?????? ?????? ???????????? ????????? ?????? ????????? ??????
			CommissionerVO commissionerVO = new CommissionerVO();
			commissionerVO.setMember_id(vo.getMember_id());
			commissionerVO.setCommissioner_status("D0000004");
			if (commissionerService.updateCommissionerStatus(commissionerVO) > 0 ) {
				// ????????? ???????????? Flag???  ?????????.
				MemberVO memberVO = new MemberVO();
				memberVO.setMember_id(vo.getMember_id());
				memberVO.setAuth_level_commissioner("Y");
				memberService.updateAuthLeveleCommissioner(memberVO);
				mv.addObject("result", true);
			} else {
				mv.addObject("result", false);	
			}
			// ???????????? ?????? ?????? ?????? Flag???  ?????????.
			mv.addObject("result", true);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	 * ?????? ????????????
	 */
	@RequestMapping("/admin/api/member/commissioner/excelDownload")
	public void excelDownload(@ModelAttribute CommissionerSearchVO vo, HttpServletResponse response) throws Exception {
		//?????? ?????? ?????? 
		List<CommissionerVO> resList = commissionerService.searchExcelDownload(vo);
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
	    cell.setCellValue("??????");
	    cell = row.createCell(1);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    cell = row.createCell(2);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("?????????");
	    cell = row.createCell(3);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("??????");
	    cell = row.createCell(4);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    cell = row.createCell(5);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("?????????");
	    cell = row.createCell(6);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("???????????????");
	    cell = row.createCell(7);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("???????????????");
	    cell = row.createCell(8);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("????????????");
	    
	    // ????????? ?????? ??????
	    for(CommissionerVO listVO : resList) {
	        row = sheet.createRow(rowNo++);
	        cell = row.createCell(0);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getName());

	        cell = row.createCell(1);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getMobile_phone() );

	        cell = row.createCell(2);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getEmail() );
	        
	        cell = row.createCell(3);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getAddress() );
	        
	        cell = row.createCell(4);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getInstitution_type_name());
	        
	        cell = row.createCell(5);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getInstitution_name());
	        
	        cell = row.createCell(6);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getReg_date());
	        
	        cell = row.createCell(7);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getUpdate_date());
	        
	        cell = row.createCell(8);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(listVO.getCommissioner_status_name());
	    }
	    
	    // ????????? ????????? ????????? ??????
	    response.setContentType("ms-vnd/excel");
	    response.setHeader("Content-Disposition", "attachment;filename=commissioner_info.xls");

	    // ?????? ??????
	    wb.write(response.getOutputStream());
	    wb.close();
	}
	

	
	
//	/**
//	* All List
//	*/
//	@RequestMapping("/user/api/job/all")
//		public ModelAndView allSearchList(@ModelAttribute JobSearchVO vo, ModelAndView mv) throws Exception {
//		List<JobVO> resList = jobService.allList();
//		mv.addObject("result", resList);
//		mv.setViewName("jsonView");
//		return mv;
//	}	
//

	
}
