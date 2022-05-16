package com.anchordata.webframework.controller.member.execution;



import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.execution.ExecutionSearchVO;
import com.anchordata.webframework.service.execution.ExecutionService;
import com.anchordata.webframework.service.execution.ExecutionVO;


@Controller("MemberExecutionController")
public class MemberExecutionController {
	
	@Autowired
	private ExecutionService executionService;
	
	/**
	*  협약 메인 Page
	*/
	@RequestMapping("/member/fwd/execution/main")
	public ModelAndView fwdMain(@ModelAttribute ExecutionVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("execution/main.member");
		return mv;
	}
	/**
	*  협약 상세 Page
	*/
	@RequestMapping("/member/fwd/execution/search/detail")
	public ModelAndView fwdDetail(@ModelAttribute ExecutionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("execution/detail.member");
		return mv;
	}
	/**
	*  협약 상세 View Page
	*/
	@RequestMapping("/member/fwd/execution/search/view")
	public ModelAndView fwdView(@ModelAttribute ExecutionVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("execution/view.member");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 수행  List
	*/
	@RequestMapping("/member/api/execution/search/paging")
		public ModelAndView searchPagingList(@ModelAttribute ExecutionSearchVO vo, ModelAndView mv) throws Exception {
		List<ExecutionVO> resList = executionService.searchPagingList(vo);
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
	@RequestMapping("/member/api/execution/search/detail")
	public ModelAndView detail(@ModelAttribute ExecutionSearchVO vo, ModelAndView mv) throws Exception {
		ExecutionVO result = executionService.searchDetail(vo);
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
	@RequestMapping("/member/api/execution/modification")
	public ModelAndView modification(@ModelAttribute ExecutionVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", executionService.modification(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	
}
