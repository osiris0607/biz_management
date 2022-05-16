package com.anchordata.webframework.controller.user.member;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;


@Controller("UserMemberController")
public class UserMemberController {
	
	@RequestMapping("/user/member/mypage")
	public ModelAndView mypage(ModelAndView mv) throws Exception {
		mv.setViewName("member/mypage.user");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	@Autowired
	private MemberService memberService;
	
	/**
	* 아이디 중복 체크
	*/
	@RequestMapping("/user/api/member/check/id")
	public ModelAndView checkId(@ModelAttribute MemberVO vo, HttpServletRequest request, ModelAndView mv) throws Exception {
		MemberVO result = memberService.checkMemberExist(vo);

		if (result == null) {
			mv.addObject("result", "SUCCESS");
		} else {
			mv.addObject("result", "FAIL");
		}

		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	* 등록
	*/
	@RequestMapping("/user/api/member/registration")
	public ModelAndView registration(@ModelAttribute MemberVO vo, HttpServletRequest request, ModelAndView mv) throws Exception {
		int result = memberService.registration(vo);

		if (result == 404) {
			mv.addObject("result", "FAIL");
			mv.addObject("result_msg", "이미 사용중인 아이디입니다. 다른 아이디를 선택해 주십시요.");
		} 
		else if (result == 0) {
			mv.addObject("result", "FAIL");
			mv.addObject("result_msg", "등록에 실패했습니다. 다시 시도해 주시기 바랍니다.");
		} 
		else {
			mv.addObject("result", "SUCCESS");
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
}
