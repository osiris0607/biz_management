 package com.anchordata.webframework.controller.user.login;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;


@Controller("UserLoginController")
public class UserLoginController {
	
	@RequestMapping("/user/fwd/login/adminLogin")
	public ModelAndView adminLogin(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) throws Exception {
		mv.setViewName("login/adminLogin");
		return mv;
	}
	
	@RequestMapping("/user/fwd/login/adminHomeLogin")
	public ModelAndView adminHomeLogin(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) throws Exception {
		mv.setViewName("login/adminHomeLogin");
		return mv;
	}
	
	@RequestMapping("/user/fwd/login/memberLogin")
	public ModelAndView memberLogin(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) throws Exception {
		mv.setViewName("login/memberLogin");
		return mv;
	}
	/**
	 *  로그인 Success
	 */
	@RequestMapping("/user/fwd/login/success")
	public String loginSuccess() {
		return "login/loginSuccess.user";
	}
	/**
	 * 로그인 Fail
	 */
	@RequestMapping("/user/fwd/login/loginError")
	public String loginFail() {
		return "error/loginError";
	}
	/**
	 * 인증 정보 입력
	 */
	@RequestMapping("/user/rdt/signup")
	public ModelAndView signup(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		mv.setViewName("login/signup");
		return mv;
	}
	/**
	 * 인증 시작
	 */
	@RequestMapping("/user/rdt/pcc_V3_sample_seed_v2")
	public ModelAndView pcc_V3_sample_seed_v2(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		mv.setViewName("login/pcc_V3_sample_seed_v2");
		return mv;
	}
	/**
	 * 인증 결과
	 */
	@RequestMapping("/user/rdt/pcc_V3_result_seed_v2")
	public ModelAndView pcc_V3_result_seed_v2(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		mv.setViewName("login/pcc_V3_result_seed_v2");
		return mv;
	}
	/**
	 * ID 찾기
	 */
	@RequestMapping("/user/fwd/login/find/id")
	public ModelAndView fwdSearchID(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		mv.setViewName("login/findID");
		return mv;
	}
	/**
	 * PWD 찾기
	 */
	@RequestMapping("/user/fwd/login/find/pwd")
	public ModelAndView fwdSearchPWD(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		mv.setViewName("login/findPWD");
		return mv;
	}	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	@Autowired
	private MemberService memberService;
	
	/**
	* ID 찾기
	*/
	@RequestMapping("/user/api/login/find/id")
	public ModelAndView findID(@ModelAttribute MemberVO vo, HttpServletRequest request, ModelAndView mv) throws Exception {
		MemberVO result = memberService.findID(vo);
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
	* PASSWORD 찾기 ( PASSWORD 초기화
	*/
	@RequestMapping("/user/api/login/find/pwd")
	public ModelAndView findPWD(@ModelAttribute MemberVO vo, HttpServletRequest request, ModelAndView mv) throws Exception {
		MemberVO result = memberService.checkMemberExist(vo);
		if (result != null) {
			// 랜덤 비밀번호 생성 후 해당 계쩡의 메일로 전송
			boolean isOK = memberService.createNewPwd(result);
			mv.addObject("result", isOK);
		} else {
			mv.addObject("result", false);
		}

		mv.setViewName("jsonView");
		return mv;
	}	
	
	
	
	
}
