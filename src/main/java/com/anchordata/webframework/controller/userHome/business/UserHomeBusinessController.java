package com.anchordata.webframework.controller.userHome.business;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.homeContent.HomeContentService;
import com.anchordata.webframework.service.homeContent.HomeContentVO;



@Controller("UserHomeBusinessController")
public class UserHomeBusinessController {
	
	// 기술 제안 사업 개요
	@RequestMapping("/userHome/fwd/business/proposal/summary")
	public ModelAndView proposalSummary(ModelAndView mv) throws Exception {
		mv.setViewName("business/proposal/summary.userHome");
		return mv;
	}
	// 기술 제안 사업 소개
	@RequestMapping("/userHome/fwd/business/proposal/intro")
	public ModelAndView proposalIntro(ModelAndView mv) throws Exception {
		mv.setViewName("business/proposal/intro.userHome");
		return mv;
	}
	// 기술 매칭 사업 개요
	@RequestMapping("/userHome/fwd/business/match/summary")
	public ModelAndView matchSummary(ModelAndView mv) throws Exception {
		mv.setViewName("business/match/summary.userHome");
		return mv;
	}
	// 기술 공모 사업 개요
	@RequestMapping("/userHome/fwd/business/contest/summary")
	public ModelAndView contestSummary(ModelAndView mv) throws Exception {
		mv.setViewName("business/contest/summary.userHome");
		return mv;
	}
	// 기술 곰모 사업 소개
	@RequestMapping("/userHome/fwd/business/contest/intro")
	public ModelAndView contestIntro(ModelAndView mv) throws Exception {
		mv.setViewName("business/contest/intro.userHome");
		return mv;
	}
	// 실증 사업 소개 (태양광)
	@RequestMapping("/userHome/fwd/business/exemplification/summary")
	public ModelAndView exemplificationSummary(ModelAndView mv) throws Exception {
		mv.setViewName("business/exemplification/summary.userHome");
		return mv;
	}
	// 실증 사업 소개 (자원순환)
	@RequestMapping("/userHome/fwd/business/exemplification/resource")
	public ModelAndView exemplificationResource(ModelAndView mv) throws Exception {
		mv.setViewName("business/exemplification/resource.userHome");
		return mv;
	}
	// 실증 사업 소개 (자원순환)
	@RequestMapping("/userHome/fwd/business/exemplification/greengas")
	public ModelAndView exemplificationGreengas(ModelAndView mv) throws Exception {
		mv.setViewName("business/exemplification/greengas.userHome");
		return mv;
	}
	
	
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	@Autowired
	HomeContentService homeContentService;
	
	/*
	* 검색 List
	*/
	@RequestMapping("/userHome/api/content/search/paging")
		public ModelAndView search(@ModelAttribute HomeContentVO vo, ModelAndView mv) throws Exception {
		List<HomeContentVO> resList = homeContentService.searchPagingList(vo);
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
	
}
