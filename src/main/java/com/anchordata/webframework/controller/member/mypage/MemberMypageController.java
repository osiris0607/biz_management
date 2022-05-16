package com.anchordata.webframework.controller.member.mypage;



import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.institution.InstitutionService;
import com.anchordata.webframework.service.institution.InstitutionVO;
import com.anchordata.webframework.service.member.CommissionerService;
import com.anchordata.webframework.service.member.CommissionerVO;
import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;
import com.anchordata.webframework.service.reception.ReceptionExpertVO;
import com.anchordata.webframework.service.reception.ReceptionSearchVO;
import com.anchordata.webframework.service.reception.ReceptionService;
import com.anchordata.webframework.service.reception.ReceptionVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;



@Controller("MemberMypageController")
public class MemberMypageController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private InstitutionService institutionService;
	@Autowired
	private MemberService memberService;
	@Autowired
	private ReceptionService receptionService;
	@Autowired
	private CommissionerService commissionerService;
	@Autowired
	private UploadFileService uploadFileService;
	
	
	
	
	/**
	* 개인 정보 / Main Page
	*/
	@RequestMapping("/member/fwd/mypage/main")
	public ModelAndView fwdMain(@ModelAttribute MemberVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("mypage/main.member");
		return mv;
	}
	/**
	* 기관 정보
	*/
	@RequestMapping("/member/fwd/mypage/institution")
	public ModelAndView fwdInstitution(@ModelAttribute MemberVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("mypage/institution.member");
		return mv;
	}
	/**
	* 전문가 현황
	*/
	@RequestMapping("/member/fwd/mypage/expert")
	public ModelAndView fwdExpert(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("mypage/expert.member");
		return mv;
	}
	/**
	* 전문가 현황 상세
	*/
	@RequestMapping("/member/fwd/mypage/receptionDetail")
	public ModelAndView fwdExpertDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("mypage/receptionDetail.member");
		return mv;
	}
	/**
	* 수행 과제 현황
	*/
	@RequestMapping("/member/fwd/mypage/report")
	public ModelAndView fwdReport(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("mypage/report.member");
		return mv;
	}
	/**
	* 수행 과제 현황 상세
	*/
	@RequestMapping("/member/fwd/mypage/reportDetail")
	public ModelAndView fwdReportDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("mypage/reportDetail.member");
		return mv;
	}
	/**
	* 평가위원 정보
	*/
	@RequestMapping("/member/fwd/mypage/commissioner")
	public ModelAndView fwdCommissioner(@ModelAttribute MemberVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("mypage/commissioner.member");
		return mv;
	}
	
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 기관 정보 등록
	*/
	@RequestMapping("/member/api/mypage/institution/registration")
	public ModelAndView institutionRegistration(@ModelAttribute InstitutionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", institutionService.institutionRegistration(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  기관 정보 상세
	*/
	@RequestMapping("/member/api/mypage/institution/detail")
	public ModelAndView institutionDetail(@ModelAttribute InstitutionVO vo, ModelAndView mv) throws Exception {
		InstitutionVO result = institutionService.detailInstitution(vo);
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  사업자 번호 유무 검색
	*/
	@RequestMapping("/member/api/mypage/institution/search/regNo")
	public ModelAndView searchRegNo(@ModelAttribute InstitutionVO vo, ModelAndView mv) throws Exception {
		InstitutionVO result = institutionService.searchRegNo(vo);
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 대표자 등록
	*/
	@RequestMapping("/member/api/mypage/representative/registration")
	public ModelAndView representativeRegistration(@ModelAttribute InstitutionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", institutionService.representativeRegistration(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 대표자 검색 
	*/
	@RequestMapping("/member/api/mypage/representative/search/all")
		public ModelAndView allSearchList(@ModelAttribute InstitutionVO vo, ModelAndView mv) throws Exception {
		List<InstitutionVO> resList = institutionService.representativeAlllList(vo);
		mv.addObject("result", resList);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 대표자 삭제
	*/
	@RequestMapping("/member/api/mypage/representative/withdrawal")
		public ModelAndView representativeWithdrawal(@ModelAttribute InstitutionVO vo, ModelAndView mv) throws Exception {
		int resList = institutionService.representativeWithdrawal(vo);
		mv.addObject("result", resList);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 개인 정보 수정
	*/
	@RequestMapping("/member/api/mypage/modification")
		public ModelAndView myModification(@ModelAttribute MemberVO vo, ModelAndView mv) throws Exception {
		boolean result = memberService.modification(vo);
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  개인 정보 상세
	*/
	@RequestMapping("/member/api/mypage/detail")
	public ModelAndView myDetail(@ModelAttribute MemberVO vo, ModelAndView mv) throws Exception {
		MemberVO result = memberService.detail(vo);
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  비밀번호 확인
	*/
	@RequestMapping("/member/api/mypage/check/id")
	public ModelAndView checkId(@ModelAttribute MemberVO vo, ModelAndView mv) throws Exception {
		mv.addObject("result", memberService.checkPwd(vo));
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 접수 전문가로 선택된 접수 목록 검색 
	*/
	@RequestMapping("/member/api/mypage/expert/search/paging")
		public ModelAndView searchExpertReceptionList(@ModelAttribute ReceptionSearchVO vo, ModelAndView mv) throws Exception {
		List<ReceptionVO> resList = receptionService.searchExpertReceptionList(vo);
		
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
	* 전문가로 참여 현황 
	*/
	@RequestMapping("/member/api/mypage/expert/search/participation")
		public ModelAndView searchExpertParticipation(@ModelAttribute ReceptionSearchVO vo, ModelAndView mv) throws Exception {
		mv.addObject("result", true);
		Map<String,String> result = receptionService.selectExpertParticipation(vo);
		mv.addObject("result_data", result);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 접수 전문가로서 참여 여부 결정
	*/
	@RequestMapping("/member/api/mypage/expert/update/participation")
		public ModelAndView updateExpertParticipation(@ModelAttribute ReceptionExpertVO vo, ModelAndView mv) throws Exception {
		int result = receptionService.updateExpertParticipation(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* My페이지 > 나의 수행 과제 현황 관리 List 검색
	*/
	@RequestMapping("/member/api/mypage/report/search/paging")
		public ModelAndView searchReportList(@ModelAttribute ReceptionSearchVO vo, ModelAndView mv) throws Exception {
		List<ReceptionVO> resList = receptionService.searchReportReceptionList(vo);
		
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
	* My페이지 > 나의 수행 과제 현황 관리 List 검색
	*/
	@RequestMapping("/member/api/mypage/report/search/detail")
	public ModelAndView searchReportDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		ReceptionVO result = receptionService.detail(vo);
		
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
	* My페이지 > 평가위원 정보 관리 검색
	*/
	@RequestMapping("/member/api/mypage/commissioner/search/detail")
	public ModelAndView searchCommissionerDetail(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		CommissionerVO resultData = commissionerService.getDetail(vo);
		
		if (resultData != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", resultData);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	 *  첨부파일 다운로드
	 */
	@RequestMapping(value = "/member/api/mypage/commissioner/download/{file_id}")
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
	* 기술 매칭 등록
	*/
	@RequestMapping("/member/api/commissioner/registration")
	public ModelAndView registrationCommissioner(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", commissionerService.registration(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* My페이지 > 평가위원 정보 관리 검색
	*/
	@RequestMapping("/member/api/commissioner/modification")
	public ModelAndView modificationCommissioner(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", commissionerService.modification(vo) );
		mv.setViewName("jsonView");
		return mv;
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
