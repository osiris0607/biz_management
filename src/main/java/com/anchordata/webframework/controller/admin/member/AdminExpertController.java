package com.anchordata.webframework.controller.admin.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.member.ExpertService;
import com.anchordata.webframework.service.member.ExpertVO;
import com.anchordata.webframework.service.member.MemberSearchVO;
import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;



@Controller("AdminExpertController")
public class AdminExpertController {
	
	
	@Autowired
	private MemberService memberService;
	@Autowired
	private CommonCodeService commonCodeService;

	@RequestMapping("/admin/fwd/member/expert/main")
	public ModelAndView fwdMainExpert(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("member/expert/main.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/member/expert/detail")
	public ModelAndView fwdDetail(@ModelAttribute ExpertVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("member/expert/detail.admin");
		return mv;
	}
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	
	@Autowired
	private ExpertService expertService;
	
	/**
	* All List
	*/
	@RequestMapping("/admin/api/member/expert/search/all")
	public ModelAndView allSearchList(@ModelAttribute ExpertVO vo, ModelAndView mv) throws Exception {
		List<ExpertVO> resList = expertService.searchAllList(vo);
		mv.addObject("result", resList);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 상세 정보
	*/
	@RequestMapping("/admin/api/member/expert/detail")
	public ModelAndView detail(@ModelAttribute ExpertVO vo, ModelAndView mv) throws Exception {
		ExpertVO result = expertService.detail(vo);
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* Paging List. 
	* ExpertVO는 기존 전문가 데이터를 이전하기 위해서 만든 것이다. 
	* 실제 MemberVO 데이터를 Return 한다.
	*/
	@RequestMapping("/admin/api/member/expert/search/paging")
		public ModelAndView search(@ModelAttribute MemberSearchVO vo, ModelAndView mv) throws Exception {
		List<MemberVO> resList = memberService.searchExpertPagingList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
			mv.addObject("totalCount", resList.get(0).getTotal_count());
		} else {
			mv.addObject("result", false);
			mv.addObject("result_msg", "전문가 검색 데이터가 없습니다.");
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
}
