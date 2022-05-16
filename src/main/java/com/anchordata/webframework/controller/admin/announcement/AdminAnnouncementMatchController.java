package com.anchordata.webframework.controller.admin.announcement;



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

import com.anchordata.webframework.service.announcement.AnnouncementSearchVO;
import com.anchordata.webframework.service.announcement.AnnouncementService;
import com.anchordata.webframework.service.announcement.AnnouncementVO;
import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;



@Controller("AdminAnnouncementMatchController")
public class AdminAnnouncementMatchController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private AnnouncementService announcementService;
	@Autowired
	private UploadFileService uploadFileService;
	
	
	
	@RequestMapping("/admin/fwd/announcement/match/main")
	public ModelAndView fwdMain(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/match/main.admin");
		return mv;
	}

	@RequestMapping("/admin/fwd/announcement/match/registration")
	public ModelAndView fwdRegistration(ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/match/registration.admin");
		return mv;
	}
	
	@RequestMapping("/admin/fwd/announcement/match/modification")
	public ModelAndView fwdModification(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/match/modification.admin");
		return mv;
	}
	
	
	@RequestMapping("/admin/fwd/announcement/match/detail")
	public ModelAndView fwdDetail(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("vo", vo);
		mv.addObject("commonCode", result);
		mv.setViewName("announcement/match/detail.admin");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 등록
	*/
	@RequestMapping("/admin/api/announcement/match/registration")
	public ModelAndView registration(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", announcementService.registration(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 변경
	*/
	@RequestMapping("/admin/api/announcement/match/modification")
	public ModelAndView modification(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.addObject( "result", announcementService.modification(vo) );
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 삭제
	 */
	@RequestMapping("/admin/api/announcement/match/withdrawal")
	public ModelAndView withdrawal(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		mv.addObject("result", announcementService.withdrawal(vo)); //
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	* 검색 List
	*/
	@RequestMapping("/admin/api/announcement/match/search/paging")
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
	@RequestMapping("/admin/api/announcement/match/detail")
	public ModelAndView detail(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
		AnnouncementVO result = announcementService.detail(vo);
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	*  첨부파일 다운로드
	*/
	@RequestMapping(value = "/admin/api/announcement/download/{file_id}")
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
	
	/**
	*  process status update
	*/
	@RequestMapping(value = "/admin/api/announcement/match/update/processStatus")
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
