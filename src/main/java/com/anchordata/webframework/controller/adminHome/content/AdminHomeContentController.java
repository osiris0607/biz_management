package com.anchordata.webframework.controller.adminHome.content;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.homeContent.HomeContentService;
import com.anchordata.webframework.service.homeContent.HomeContentVO;



@Controller("AdminHomeContentController")
public class AdminHomeContentController {
	
	@RequestMapping("/adminHome/content/proposal")
	public ModelAndView contentProposal(ModelAndView mv) throws Exception {
		mv.setViewName("content/proposal.adminHome");
		return mv;
	}

	@RequestMapping("/adminHome/content/contest")
	public ModelAndView contentContest(ModelAndView mv) throws Exception {
		mv.setViewName("content/contest.adminHome");
		return mv;
	}
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	@Autowired
	HomeContentService homeContentService;
	
	/*
	* Home Content 등록
	*/
	@RequestMapping("/adminHome/api/content/registration")
	public ModelAndView registration(@ModelAttribute HomeContentVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", homeContentService.registration(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/*
	* Home Content 변경
	*/
	@RequestMapping("/adminHome/api/content/modification")
	public ModelAndView modification(@ModelAttribute HomeContentVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", homeContentService.modification(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/*
	* Home Content 삭제
	*/
	@RequestMapping("/adminHome/api/content/delete")
	public ModelAndView delete(@ModelAttribute HomeContentVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", homeContentService.delete(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/*
	* 검색 List
	*/
	@RequestMapping("/adminHome/api/content/search/paging")
		public ModelAndView search(@ModelAttribute HomeContentVO vo, ModelAndView mv) throws Exception {
		List<HomeContentVO> resList = homeContentService.searchPagingList(vo);
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

//	/**
//	*  상세
//	*/
//	@RequestMapping("/member/api/announcement/detail")
//	public ModelAndView detail(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
//		AnnouncementVO result = announcementService.detail(vo);
//		mv.addObject("result", result);
//		mv.setViewName("jsonView");
//		return mv;
//	}
//	/**
//	*  첨부파일 다운로드
//	*/
//	@RequestMapping(value = "/member/api/announcement/download/{file_id}")
//	public void downloadFile (@PathVariable("file_id") String fileId, HttpSession session, HttpServletResponse response) throws Exception {
//		UploadFileVO UploadFileVO = new UploadFileVO();
//		UploadFileVO.setFile_id(Integer.parseInt(fileId));
//		UploadFileVO = uploadFileService.selectUploadFileContent(UploadFileVO);
//		
//		response.setContentType("application/octet-stream"); 
//		response.setContentLength(UploadFileVO.getBinary_content().length); 
//		response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(UploadFileVO.getName(),"UTF-8")+"\";"); 
//		response.setHeader("Content-Transfer-Encoding", "binary"); 
//		response.getOutputStream().write(UploadFileVO.getBinary_content()); 
//		response.getOutputStream().flush(); 
//		response.getOutputStream().close(); 
//	}
	
}
