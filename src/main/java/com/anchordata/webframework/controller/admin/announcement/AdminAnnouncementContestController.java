package com.anchordata.webframework.controller.admin.announcement;




import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.announcement.AnnouncementSearchVO;
import com.anchordata.webframework.service.announcement.AnnouncementService;
import com.anchordata.webframework.service.announcement.AnnouncementVO;
import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;



@Controller("AdminAnnouncementContestController")
public class AdminAnnouncementContestController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private AnnouncementService announcementService;
	
	
	
	@RequestMapping("/admin/fwd/announcement/contest/main")
	public ModelAndView fwdMain(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/contest/main.admin");
		return mv;
	}

	@RequestMapping("/admin/fwd/announcement/contest/registration")
	public ModelAndView fwdRegistration(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/contest/registration.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/announcement/contest/modification")
	public ModelAndView fwdModification(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/contest/modification.admin");
		return mv;
	}
	
	
	@RequestMapping("/admin/fwd/announcement/contest/detail")
	public ModelAndView fwdDetail(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/contest/detail.admin");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 등록
	*/
	@RequestMapping("/admin/api/announcement/contest/registration")
	public ModelAndView registration(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", announcementService.registration(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	* 변경
	*/
	@RequestMapping("/admin/api/announcement/contest/modification")
	public ModelAndView modification(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", announcementService.modification(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 삭제
	 */
	@RequestMapping("/admin/api/announcement/contest/withdrawal")
	public ModelAndView withdrawal(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.addObject("result", announcementService.withdrawal(vo)); //
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	* 검색 List
	*/
	@RequestMapping("/admin/api/announcement/contest/search/paging")
		public ModelAndView search(@ModelAttribute AnnouncementSearchVO vo, ModelAndView mv) throws Exception {
		List<AnnouncementVO> resList = announcementService.searchList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", resList);
			mv.addObject("totalCount", resList.get(0).getTotal_count());
		} else {
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	*  상세
	*/
	@RequestMapping("/admin/api/announcement/contest/detail")
	public ModelAndView detail(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		AnnouncementVO result = announcementService.detail(vo);
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  process status update
	*/
	@RequestMapping(value = "/admin/api/announcement/contest/update/processStatus")
	public ModelAndView updateProcessStatus (@ModelAttribute AnnouncementVO vo,  ModelAndView mv) throws Exception {
		mv.addObject( "result", announcementService.updateProcessStatus(vo) );
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
