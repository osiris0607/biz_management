package com.anchordata.webframework.controller.admin.notice;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.notice.NoticeSearchVO;
import com.anchordata.webframework.service.notice.NoticeService;
import com.anchordata.webframework.service.notice.NoticeVO;


@Controller("adminNoticeController")
public class AdminNoticeController {
	
	/**
	 * 알림 정보 관리 리스트
	 * 
	 */
	@RequestMapping("/admin/fwd/notice/main")
	public String fwdMain(Model model) throws Exception {
		return "notice/main.admin";
	}
	/**
	 * 알림 정보 관리 등록
	 * 
	 */
	@RequestMapping("/admin/fwd/notice/registration")
	public String fwdRegistration(Model model) throws Exception {
		return "notice/registration.admin";
	}
	/**
	 *  알림 정보 관리 상세
	 */
	@RequestMapping("/admin/fwd/notice/detail")
	public ModelAndView fwdDetail(@ModelAttribute NoticeVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("notice/detail.admin");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	@Autowired
	private NoticeService noticeService;
	
	/**
	* 등록
	*/
	@RequestMapping("/admin/api/notice/registration")
	public ModelAndView registration(@ModelAttribute NoticeVO vo, ModelAndView mv) throws Exception {
	mv.addObject( "result", noticeService.registration(vo) );
	mv.setViewName("jsonView");
	return mv;
	}
	/**
	* 공지사항 List
	*/
	@RequestMapping("/admin/api/notice/search/paging")
	public ModelAndView allList(@ModelAttribute NoticeSearchVO vo, ModelAndView mv) throws Exception {
		List<NoticeVO> resList = noticeService.searchPagingList(vo);
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
	@RequestMapping("/admin/api/notice/detail")
	public ModelAndView detail(@ModelAttribute NoticeVO vo, ModelAndView mv) throws Exception {
		NoticeVO result = noticeService.detail(vo);
		if ( result != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  수정
	*/
	@RequestMapping("/admin/api/notice/modification")
	public ModelAndView modification(@ModelAttribute NoticeVO vo, ModelAndView mv) throws Exception {
		boolean result = noticeService.modification(vo);
		mv.addObject( "result", result );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	 * 삭제
	 */
	@RequestMapping("/admin/api/notice/withdrawal")
	public ModelAndView withdrawal(@ModelAttribute NoticeVO vo, ModelAndView mv) throws Exception {
		boolean result = noticeService.withdrawal(vo);
		mv.addObject( "result", result );
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
		
}
