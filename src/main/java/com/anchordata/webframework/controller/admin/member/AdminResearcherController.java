package com.anchordata.webframework.controller.admin.member;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.announcement.AnnouncementVO;
import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.member.MemberSearchVO;
import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;



@Controller("AdminResearcherController")
public class AdminResearcherController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private MemberService memberService;
	
	@RequestMapping("/admin/fwd/member/researcher/main")
	public ModelAndView fwdMain(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("member/researcher/main.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/member/researcher/detail")
	public ModelAndView fwdDetail(@ModelAttribute MemberVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("member/researcher/detail.admin");
		return mv;
	}

	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 검색 List
	*/
	@RequestMapping("/admin/api/member/researcher/search/paging")
		public ModelAndView search(@ModelAttribute MemberSearchVO vo, ModelAndView mv) throws Exception {

		List<MemberVO> resList = memberService.searchResearcherPagingList(vo);
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
	@RequestMapping("/admin/api/member/researcher/detail")
	public ModelAndView detail(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
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
