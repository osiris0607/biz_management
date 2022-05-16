package com.anchordata.webframework.controller.member.calculation;



import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.calculation.CalculationSearchVO;
import com.anchordata.webframework.service.calculation.CalculationService;
import com.anchordata.webframework.service.calculation.CalculationVO;


@Controller("MemberCalculationController")
public class MemberCalculationController {
	
	@Autowired
	private CalculationService calculationService;
	
	
	/**
	*  협약 메인 Page
	*/
	@RequestMapping("/member/fwd/calculation/main")
	public ModelAndView fwdMain(@ModelAttribute CalculationVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("calculation/main.member");
		return mv;
	}
	/**
	*  협약 상세 Page
	*/
	@RequestMapping("/member/fwd/calculation/search/detail")
	public ModelAndView fwdDetail(@ModelAttribute CalculationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("calculation/detail.member");
		return mv;
	}
	/**
	*  협약 상세 View Page
	*/
	@RequestMapping("/member/fwd/calculation/search/view")
	public ModelAndView fwdView(@ModelAttribute CalculationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("calculation/view.member");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 수행  List
	*/
	@RequestMapping("/member/api/calculation/search/paging")
		public ModelAndView searchPagingList(@ModelAttribute CalculationSearchVO vo, ModelAndView mv) throws Exception {
		List<CalculationVO> resList = calculationService.searchPagingList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
		} else {
			mv.addObject("result", false);
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  수행 상세
	*/
	@RequestMapping("/member/api/calculation/search/detail")
	public ModelAndView detail(@ModelAttribute CalculationSearchVO vo, ModelAndView mv) throws Exception {
		CalculationVO result = calculationService.searchDetail(vo);
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
	* 수행 변경
	*/
	@RequestMapping("/member/api/calculation/modification")
	public ModelAndView modification(@ModelAttribute CalculationVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", calculationService.modification(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	
}
