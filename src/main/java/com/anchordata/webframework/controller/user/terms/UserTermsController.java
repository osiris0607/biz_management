package com.anchordata.webframework.controller.user.terms;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller("UserTermsController")
public class UserTermsController {
	
	/**
	 * 개인정보 처리방침
	 */
	@RequestMapping("/user/fwd/terms/privatePolicy")
	public ModelAndView fwdPrivatePolicy(ModelAndView mv) throws Exception {
		mv.setViewName("terms/privatePolicy.user");
		return mv;
	}
	
	/**
	 * 이용 약관
	 */
	@RequestMapping("/user/fwd/terms/tos")
	public ModelAndView fwdTos(ModelAndView mv) throws Exception {
		mv.setViewName("terms/tos.user");
		return mv;
	}
	
	/**
	 * 이메일무단 수집 거부
	 */
	@RequestMapping("/user/fwd/terms/roc")
	public ModelAndView fwdRoc(ModelAndView mv) throws Exception {
		mv.setViewName("terms/roc.user");
		return mv;
	}
	
	
}
