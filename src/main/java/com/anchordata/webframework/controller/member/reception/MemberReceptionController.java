package com.anchordata.webframework.controller.member.reception;



import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.reception.ReceptionSearchVO;
import com.anchordata.webframework.service.reception.ReceptionService;
import com.anchordata.webframework.service.reception.ReceptionVO;
import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;



@Controller("MemberReceptionController")
public class MemberReceptionController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private ReceptionService receptionService;
	@Autowired
	private MemberService memberService;
	
	
	@RequestMapping("/member/fwd/reception/main")
	public ModelAndView fwdMain(@ModelAttribute ReceptionVO vo,ModelAndView mv) throws Exception {
		List<CommonCodeVO>  commonCode = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode",  commonCode);
		mv.setViewName("reception/main.member");
		return mv;
	}
	
	@RequestMapping("/member/fwd/reception/announcementDetail")
	public ModelAndView fwdAnnouncementDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("reception/announcementDetail.member");
		return mv;
	}
	
	@RequestMapping("/member/fwd/reception/guide")
	public ModelAndView fwdGuide(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.addObject("vo", vo);
		mv.setViewName("reception/guide.member");
		return mv;
	}
	// ???????????? - ????????? ?????? ??????
	@RequestMapping("/member/fwd/reception/match/consultingRegistration")
	public ModelAndView fwdReceptionMatchConsulting(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/consultingRegistration.member");
		return mv;
	}
	// ???????????? - ????????? ????????? ??????
	@RequestMapping("/member/fwd/reception/match/consultingExpertRegistration")
	public ModelAndView fwdconsultingExpertRegistration(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/consultingExpertRegistration.member");
		return mv;
	}
	// ???????????? - ????????? ?????? ??????
	@RequestMapping("/member/fwd/reception/match/consultingDetail")
	public ModelAndView fwdReceptionMatchConsultingDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/consultingDetail.member");
		return mv;
	}
	// ???????????? - ????????? ?????? ????????? ??????
	@RequestMapping("/member/fwd/reception/match/consultingExpertDetail")
	public ModelAndView fwdDetailMatchConsultingExpert(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/consultingExpertDetail.member");
		return mv;
	}
	// ???????????? - ????????? ?????? ?????? ???
	@RequestMapping("/member/fwd/reception/match/consultingExpertMatching")
	public ModelAndView fwdConsultingExpertMatching(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/consultingExpertMatching.member");
		return mv;
	}
	
	
	// ???????????? - ???????????? ?????? ??????
	@RequestMapping("/member/fwd/reception/researchRegistration")
	public ModelAndView fwdReceptionMatchResearch(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/researchRegistration.member");
		return mv;
	}
	// ???????????? - ???????????? ????????? ??????
	@RequestMapping("/member/fwd/reception/match/researchExpertRegistration")
	public ModelAndView fwdRegistrationMatchResearchExpert(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/researchExpertRegistration.member");
		return mv;
	}
	
	// ???????????? - ???????????? ?????? ??????
	@RequestMapping("/member/fwd/reception/match/researchDetail")
	public ModelAndView fwdReceptionMatchResearchDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/researchDetail.member");
		return mv;
	}
	
	// ???????????? - ???????????? ????????? ?????? ??????
	@RequestMapping("/member/fwd/reception/match/researchExpertDetail")
	public ModelAndView fwDetailMatchResearchExpert(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/researchExpertDetail.member");
		return mv;
	}
	// ???????????? - ???????????? ????????? ?????? ?????? ???
	@RequestMapping("/member/fwd/reception/match/researchExpertMatching")
	public ModelAndView fwdResearchExpertMatching(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/match/researchExpertMatching.member");
		return mv;
	}
	
	
	// ???????????? ?????? ??????
	@RequestMapping("/member/fwd/reception/contest/registration")
	public ModelAndView fwdContestRegistration(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/contest/registration.member");
		return mv;
	}
	/**
	* ?????? ?????? ??????
	*/
	@RequestMapping("/member/fwd/reception/contest/modification")
	public ModelAndView fwdContestModification(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/contest/modification.member");
		return mv;
	}
	/**
	* ?????? ?????? ?????? ??? ??????
	*/
	@RequestMapping("/member/fwd/reception/contest/detail")
	public ModelAndView fwdContestDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/contest/detail.member");
		return mv;
	}
	/**
	* ???????????? ?????? ??????
	*/
	@RequestMapping("/member/fwd/reception/proposal/registration")
	public ModelAndView fwdProposalRegistration(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/proposal/registration.member");
		return mv;
	}
	/**
	* ???????????? ?????? ??? ??????
	*/
	@RequestMapping("/member/fwd/reception/proposal/detail")
	public ModelAndView fwdProposalDetail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/proposal/detail.member");
		return mv;
	}
	/**
	* ???????????? ??????
	*/
	@RequestMapping("/member/fwd/reception/proposal/modification")
	public ModelAndView fwdProposalModification(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.addObject("vo", vo);
		mv.setViewName("reception/proposal/modification.member");
		return mv;
	}
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API ??????
	///////////////////////////////////////////////////////////////////////////
	/**
	* ?????? ?????? ??????
	*/
	@RequestMapping("/member/api/reception/match/registration")
	public ModelAndView registration(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", receptionService.registration(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	*  ????????? ?????? ??????
	*/
	@RequestMapping("/member/api/reception/expert/detail")
	public ModelAndView expertDetail(@ModelAttribute MemberVO vo, ModelAndView mv) throws Exception {
		MemberVO result = memberService.expertDetail(vo);
		if ( result != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		}
		else {
			mv.addObject("result", false);
			mv.addObject("result_msg", "????????? ?????? ???????????? ????????????.");
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* ?????? ?????? ?????? ?????? List
	*/
	@RequestMapping("/member/api/reception/search/paging")
		public ModelAndView search(@ModelAttribute ReceptionSearchVO vo, ModelAndView mv) throws Exception {
		List<ReceptionVO> resList = receptionService.searchMemberReceptionList(vo);
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
	@RequestMapping("/member/api/reception/detail")
	public ModelAndView detail(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		ReceptionVO resultData = receptionService.detail(vo);
		mv.addObject("result", true);
		mv.addObject("result_data", resultData);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	 * ??????
	 */
	@RequestMapping("/member/api/reception/withdrawal")
	public ModelAndView withdrawal(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("result", receptionService.withdrawal(vo)); //
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* ??????
	*/
	@RequestMapping("/member/api/reception/match/modification")
	public ModelAndView modification(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", receptionService.modification(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* ?????? Status update
	*/
	@RequestMapping("/member/api/reception/status/update")
	public ModelAndView updateStatus(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", receptionService.updateReceptionStatus(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* ???????????? ???????????? ??????
	*/
	@RequestMapping("/member/api/reception/match/expert/choice")
	public ModelAndView expertChoice(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", receptionService.expertChoice(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* ?????????
	*/
	@RequestMapping("/member/api/reception/match/expert/retryMatch")
	public ModelAndView retryMatch(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", receptionService.retryMatch(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* ???????????? ??? ????????? ?????? ????????? ?????? ?????? ?????? ??????
	*/
	@RequestMapping("/member/api/reception/match/submitCompleteReception")
	public ModelAndView submitCompleteReception(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", receptionService.submitCompleteReception(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	* ?????? ?????? ??????
	*/
	@RequestMapping("/member/api/reception/contest/registration")
	public ModelAndView contestRegistration(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", receptionService.registration(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* ?????? ?????? ??????
	*/
	@RequestMapping("/member/api/reception/contest/modification")
	public ModelAndView contestModification(@ModelAttribute ReceptionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", receptionService.modification(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
}
