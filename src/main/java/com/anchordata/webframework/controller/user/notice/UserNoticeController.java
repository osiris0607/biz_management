package com.anchordata.webframework.controller.user.notice;

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

import com.anchordata.webframework.service.notice.NoticeSearchVO;
import com.anchordata.webframework.service.notice.NoticeService;
import com.anchordata.webframework.service.notice.NoticeVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;


@Controller("UserNoticeController")
public class UserNoticeController {
	
	
	@Autowired
	private NoticeService noticeService;
	@Autowired
	private UploadFileService uploadFileService;
	
	/**
	 * 공지 사항 리스트
	 */
	@RequestMapping("/user/fwd/notice/main")
	public ModelAndView fwdMain(@ModelAttribute NoticeVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("notice/main.user");
		return mv;
	}
	
	/**
	 * 공지 사항 상세
	 */
	@RequestMapping("/user/fwd/notice/detail")
	public ModelAndView noticeDetail(@ModelAttribute NoticeVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("notice/detail.user");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 공지사항 List
	* 
	*/
	@RequestMapping("/user/api/notice/search/paging")
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
	*  공지 사항 상세
	*/
	@RequestMapping("/user/api/notice/detail")
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
	*  공지사항 첨부파일 다운로드
	* @return
	*/
	@RequestMapping(value = "/user/api/notice/download/{file_id}")
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
