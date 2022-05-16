package com.anchordata.webframework.controller.userHome.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.announcement.AnnouncementVO;
import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.homeBoard.HomeBoardService;
import com.anchordata.webframework.service.homeBoard.HomeBoardVO;


@Controller("UserHomeGalleryController")
public class UserHomeBoardController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	// 기술 갤러리 리스트
	@RequestMapping("/userHome/fwd/gallery/main")
	public ModelAndView galleryMain(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception {
		mv.setViewName("gallery/main.userHome");
		return mv;
	}
	// 기술 갤러리 상세
	@RequestMapping("/userHome/fwd/gallery/detail")
	public ModelAndView galleryDetail(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception 
	{
		mv.addObject("vo", vo);
		mv.setViewName("gallery/detail.userHome");
		return mv;
	}
	// 공지  리스트
	@RequestMapping("/userHome/fwd/announcement/notice/noticeMain")
	public ModelAndView noticeMain(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception {
		mv.setViewName("announcement/notice/noticeMain.userHome");
		return mv;
	}
	// 공지 상세
	@RequestMapping("/userHome/fwd/announcement/notice/noticeDetail")
	public ModelAndView noticeDetail(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception 
	{
		mv.addObject("vo", vo);
		mv.setViewName("announcement/notice/noticeDetail.userHome");
		return mv;
	}
	// 사업공고  리스트
	@RequestMapping("/userHome/fwd/announcement/notice/businessMain")
	public ModelAndView businessMain(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception 
	{
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/notice/businessMain.userHome");
		return mv;
	}
	// 사업공고 상세
	@RequestMapping("/userHome/fwd/announcement/notice/businessDetail")
	public ModelAndView businessDetail(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception 
	{
		mv.addObject("vo", vo);
		mv.setViewName("announcement/notice/businessDetail.userHome");
		return mv;
	}
	// 보도자료  리스트
	@RequestMapping("/userHome/fwd/announcement/broadcast/broadcastMain")
	public ModelAndView broadcastMain(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception {
		mv.setViewName("announcement/broadcast/broadcastMain.userHome");
		return mv;
	}
	// 보도자료 상세
	@RequestMapping("/userHome/fwd/announcement/broadcast/broadcastDetail")
	public ModelAndView broadcastDetail(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception 
	{
		mv.addObject("vo", vo);
		mv.setViewName("announcement/broadcast/broadcastDetail.userHome");
		return mv;
	}
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	@Autowired
	HomeBoardService homeBoardService;
	
	/*
	* 검색 List
	*/
	@RequestMapping("/userHome/api/board/search/paging")
	public ModelAndView search(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception 
	{
		List<HomeBoardVO> resList;
		if (vo.getBoard_type().equalsIgnoreCase("G") || vo.getBoard_type().equalsIgnoreCase("P"))
		{
			resList = homeBoardService.searchPagingListWithImage(vo);
		}
		else 
		{
			resList = homeBoardService.searchPagingList(vo);
		}
		
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
	/*
	*  상세
	*/
	@RequestMapping("/userHome/api/board/detail")
	public ModelAndView detail(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception 
	{
		vo.setHits(1);
		HomeBoardVO result = homeBoardService.detail(vo);
		mv.addObject("result", true);
		mv.addObject("result_data", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
}
