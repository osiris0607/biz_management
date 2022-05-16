package com.anchordata.webframework.controller.admin.member;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.member.ManagerSearchVO;
import com.anchordata.webframework.service.member.ManagerService;
import com.anchordata.webframework.service.member.ManagerVO;
import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;


@Controller("AdminManagerController")
public class AdminManagerController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private ManagerService managerService;
	@Autowired
	private MemberService memberService;
	
	@RequestMapping("/admin/fwd/member/manager/main")
	public ModelAndView fwdMain(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("member/manager/main.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/member/manager/detail")
	public ModelAndView fwdDetail(@ModelAttribute MemberVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("member/manager/detail.admin");
		return mv;
	}
	
	
	@RequestMapping("/admin/fwd/member/manager/registration")
	public ModelAndView fwdRegistration(@ModelAttribute MemberVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("member/manager/registration.admin");
		return mv;
	}

	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 관리자 등록
	*/
	@RequestMapping("/admin/api/member/manager/registration")
	public ModelAndView registration(@ModelAttribute ManagerVO vo, ModelAndView mv) throws Exception {
		int result = managerService.registration(vo);
		if ( result > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 관리자 수정
	*/
	@RequestMapping("/admin/api/member/manager/modification")
	public ModelAndView modification(@ModelAttribute ManagerVO vo, ModelAndView mv) throws Exception {
		int result = managerService.modification(vo);
		if ( result > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	 * 관리자 삭제
	 */
	@RequestMapping("/admin/api/member/manager/withdrawal")
	public ModelAndView withdrawal(@ModelAttribute ManagerVO vo, ModelAndView mv) throws Exception {
		int result = managerService.withdrawal(vo);
		if ( result > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		}
		else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 검색 List
	*/
	@RequestMapping("/admin/api/member/manager/search/paging")
		public ModelAndView search(@ModelAttribute ManagerSearchVO vo, ModelAndView mv) throws Exception {
		List<ManagerVO> resList = managerService.searchPagingList(vo);
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
	@RequestMapping("/admin/api/member/manager/detail")
	public ModelAndView detail(@ModelAttribute ManagerVO vo, ModelAndView mv) throws Exception {
		// 상세 정보
		ManagerVO result = managerService.searchDetail(vo);
		if ( result != null) {
			// Member History 정보
			List<String> history = memberService.selectMemberHistory(vo.getMember_id());
			result.setHistory(history);
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  관리자 메뉴 권한 변경
	*/
	@RequestMapping("/admin/api/member/manager/menu/auth/modification")
	public ModelAndView menuAuthModifcation(@ModelAttribute ManagerVO vo, ModelAndView mv) throws Exception {
		// 상세 정보
		int result = managerService.updateMenuAuth(vo);
		if ( result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		
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
