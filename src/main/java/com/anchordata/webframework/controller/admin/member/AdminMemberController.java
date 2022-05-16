package com.anchordata.webframework.controller.admin.member;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.announcement.AnnouncementSearchVO;
import com.anchordata.webframework.service.announcement.AnnouncementVO;
import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;



@Controller("AdminMemberController")
public class AdminMemberController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@RequestMapping("/admin/fwd/member/detailMember")
	public ModelAndView rdtDetailMember(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("member/detailMember.admin");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 등록
	*/
	@RequestMapping("/admin/api/member/registration")
	public ModelAndView registration(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	* 변경
	*/
	@RequestMapping("/admin/api/member/modification")
	public ModelAndView modification(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 삭제
	 */
	@RequestMapping("/admin/api/member/withdrawal")
	public ModelAndView withdrawal(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	* 검색 List
	*/
	@RequestMapping("/admin/api/member/search/paging")
		public ModelAndView search(@ModelAttribute AnnouncementSearchVO vo, ModelAndView mv) throws Exception {
//		List<AnnouncementVO> resList = announcementService.searchList(vo);
//		if (resList.size() > 0) {
//			mv.addObject("result", resList);
//			mv.addObject("totalCount", resList.get(0).getTotal_count());
//		} else {
//			mv.addObject("totalCount", 0);
//		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	*  상세
	*/
	@RequestMapping("/admin/api/member/detail")
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
