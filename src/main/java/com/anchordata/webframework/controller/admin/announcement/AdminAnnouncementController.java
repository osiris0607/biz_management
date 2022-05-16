package com.anchordata.webframework.controller.admin.announcement;



import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.announcement.AnnouncementService;
import com.anchordata.webframework.service.announcement.AnnouncementVO;
import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;



@Controller("AdminAnnouncementController")
public class AdminAnnouncementController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private AnnouncementService announcementService;
	
	@RequestMapping("/admin/fwd/announcement/main")
	public ModelAndView rdtAnnouncement(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/main.admin");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 등록
	*/
	@RequestMapping("/admin/api/announcement/main/stat")
	public ModelAndView stat(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.addObject("result", true);
		Map<String,String> result = announcementService.getMainSate();
		mv.addObject("result_data", result);
		mv.setViewName("jsonView");
		return mv;
	}

	
}
