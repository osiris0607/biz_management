package com.anchordata.webframework.controller.member.home;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.member.CommissionerService;
import com.anchordata.webframework.service.member.CommissionerVO;



@Controller("MemberHomeController")
public class MemberHomeController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@RequestMapping("/member/fwd/home/main")
	public ModelAndView fwdMain(ModelAndView mv) throws Exception {
		mv.setViewName("home/main.member");
		return mv;
	}
	
	@RequestMapping("/member/fwd/commissioner/registration")
	public ModelAndView fwdRegistration(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.setViewName("commissioner/registration");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////

	@Autowired
	private CommissionerService commissionerService;
	
	/**
	*  commissioner 상세
	*/
	@RequestMapping("/member/api/home/commissioner/detail")
	public ModelAndView detail(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		CommissionerVO resultData = commissionerService.getDetail(vo);
		mv.addObject("result", true);
		mv.addObject("result_data", resultData);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
}
