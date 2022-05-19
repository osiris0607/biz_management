package com.anchordata.webframework.controller.adminHome.board;


import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.homeBoard.HomeBoardService;
import com.anchordata.webframework.service.homeBoard.HomeBoardVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;



@Controller("AdminHomeBoardController")
public class AdminHomeBoardController {
	
	@RequestMapping("/adminHome/board/notice/main")
	public ModelAndView noticeMain(ModelAndView mv) throws Exception
	{
		mv.setViewName("board/notice/main.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/notice/registration")
	public ModelAndView noticeRegistration(ModelAndView mv) throws Exception
	{
		mv.setViewName("board/notice/registration.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/notice/modification")
	public ModelAndView noticeModification(@ModelAttribute HomeBoardVO vo,ModelAndView mv) throws Exception 
	{
		mv.addObject("vo", vo);
		mv.setViewName("board/notice/modification.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/notice/detail")
	public ModelAndView noticeDetail(@ModelAttribute HomeBoardVO vo,ModelAndView mv) throws Exception 
	{
		mv.addObject("vo", vo);
		mv.setViewName("board/notice/detail.adminHome");
		return mv;
	}

	@RequestMapping("/adminHome/board/broadcast/main")
	public ModelAndView broadcastMain(ModelAndView mv) throws Exception 
	{
		mv.setViewName("board/broadcast/main.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/broadcast/registration")
	public ModelAndView broadcastRegistration(ModelAndView mv) throws Exception
	{
		mv.setViewName("board/broadcast/registration.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/broadcast/detail")
	public ModelAndView broadcastDetail(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception
	{
		mv.addObject("vo", vo);
		mv.setViewName("board/broadcast/detail.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/broadcast/modification")
	public ModelAndView broadcastModification(@ModelAttribute HomeBoardVO vo,ModelAndView mv) throws Exception 
	{
		mv.addObject("vo", vo);
		mv.setViewName("board/broadcast/modification.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/poster/main")
	public ModelAndView posterMain(ModelAndView mv) throws Exception 
	{
		mv.setViewName("board/poster/main.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/poster/registration")
	public ModelAndView posterRegistration(ModelAndView mv) throws Exception
	{
		mv.setViewName("board/poster/registration.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/poster/detail")
	public ModelAndView posterDetail(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception
	{
		mv.addObject("vo", vo);
		mv.setViewName("board/poster/detail.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/poster/modification")
	public ModelAndView posterModification(@ModelAttribute HomeBoardVO vo,ModelAndView mv) throws Exception 
	{
		mv.addObject("vo", vo);
		mv.setViewName("board/poster/modification.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/gallery/main")
	public ModelAndView galleryMain(ModelAndView mv) throws Exception 
	{
		mv.setViewName("board/gallery/main.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/gallery/registration")
	public ModelAndView galleryRegistration(ModelAndView mv) throws Exception
	{
		mv.setViewName("board/gallery/registration.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/gallery/detail")
	public ModelAndView galleryDetail(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception
	{
		mv.addObject("vo", vo);
		mv.setViewName("board/gallery/detail.adminHome");
		return mv;
	}
	
	@RequestMapping("/adminHome/board/gallery/modification")
	public ModelAndView galleryModification(@ModelAttribute HomeBoardVO vo,ModelAndView mv) throws Exception 
	{
		mv.addObject("vo", vo);
		mv.setViewName("board/gallery/modification.adminHome");
		return mv;
	}
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	@Autowired
	HomeBoardService homeBoardService;
	@Autowired
	UploadFileService uploadFileService;
	
	/*
	* 등록
	*/
	@RequestMapping("/adminHome/api/board/registration")
	public ModelAndView registration(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", homeBoardService.registration(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/*
	* 변경
	*/
	@RequestMapping("/adminHome/api/board/modification")
	public ModelAndView modification(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", homeBoardService.modification(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/*
	* 삭제
	*/
	@RequestMapping("/adminHome/api/board/delete")
	public ModelAndView delete(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", homeBoardService.delete(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/*
	* 검색 List
	*/
	@RequestMapping("/adminHome/api/board/search/paging")
		public ModelAndView search(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception {
		List<HomeBoardVO> resList = homeBoardService.searchPagingList(vo);
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
	@RequestMapping("/adminHome/api/board/detail")
	public ModelAndView detail(@ModelAttribute HomeBoardVO vo, ModelAndView mv) throws Exception {
		HomeBoardVO result = homeBoardService.detail(vo);
		mv.addObject("result", true);
		mv.addObject("result_data", result);
		mv.setViewName("jsonView");
		return mv;
	}
	/*
	*  첨부파일 다운로드
	*/
	@RequestMapping(value = "/adminHome/api/board/download/{file_id}")
	public void downloadFile (@PathVariable("file_id") String fileId, HttpSession session, HttpServletResponse response) throws Exception {
		
		UploadFileVO UploadFileVO = new UploadFileVO();
		UploadFileVO.setFile_id(Integer.parseInt(fileId));
		UploadFileVO = uploadFileService.selectUploadFileContent(UploadFileVO);
		
		response.setContentType("application/octet-stream"); 
		response.setContentLength(UploadFileVO.getBinary_content().length); 
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(UploadFileVO.getName(),"UTF-8")+"\";"); 
		response.setHeader("Content-Transfer-Encoding", "binary"); 
		response.getOutputStream().write(UploadFileVO.getBinary_content()); 
		response.getOutputStream().flush(); 
		response.getOutputStream().close(); 
	}
	
}
