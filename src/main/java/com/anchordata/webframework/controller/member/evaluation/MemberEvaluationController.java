package com.anchordata.webframework.controller.member.evaluation;



import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.evaluation.EvaluationSearchVO;
import com.anchordata.webframework.service.evaluation.EvaluationService;
import com.anchordata.webframework.service.evaluation.EvaluationVO;



@Controller("MemberEvaluationController")
public class MemberEvaluationController {
	
	@Autowired
	private EvaluationService evaluationService;
	
	
	@RequestMapping("/member/fwd/evaluation/main")
	public ModelAndView fwdMain(@ModelAttribute EvaluationVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/main.member");
		return mv;
	}
	
	@RequestMapping("/member/fwd/evaluation/search/detail")
	public ModelAndView fwdDetail(@ModelAttribute EvaluationVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/detail.member");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	/**
	* 평가 List
	*/
	@RequestMapping("/member/api/evaluation/search/paging")
		public ModelAndView searchPagingList(@ModelAttribute EvaluationSearchVO vo, ModelAndView mv) throws Exception {
		List<EvaluationVO> resList = evaluationService.searchPagingList(vo);
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
	*  평가 상세
	*/
	@RequestMapping("/member/api/evaluation/search/detail")
	public ModelAndView detail(@ModelAttribute EvaluationSearchVO vo, ModelAndView mv) throws Exception {
		EvaluationVO result = evaluationService.detail(vo);
		if (result != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		} else {
			mv.addObject("result", false);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
//	/**
//	* 등록
//	*/
//	@RequestMapping("/member/api/announcement/registration")
//	public ModelAndView registration(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
//		mv.addObject( "result", announcementService.registration(vo) );
//		mv.setViewName("jsonView");
//		return mv;
//	}
//	/**
//	* 변경
//	*/
//	@RequestMapping("/member/api/announcement/modification")
//	public ModelAndView modification(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
//		mv.addObject( "result", announcementService.modification(vo) );
//		mv.setViewName("jsonView");
//		return mv;
//	}
//	
//	
//	/**
//	 * 삭제
//	 */
//	@RequestMapping("/member/api/announcement/withdrawal")
//	public ModelAndView withdrawal(@ModelAttribute AnnouncementVO vo, ModelAndView mv) throws Exception {
//		mv.addObject("result", announcementService.withdrawal(vo)); //
//		mv.setViewName("jsonView");
//		return mv;
//	}
//	
//	/**
//	* 검색 List
//	*/
//	@RequestMapping("/member/api/announcement/search/paging")
//		public ModelAndView search(@ModelAttribute AnnouncementSearchVO vo, ModelAndView mv) throws Exception {
//		List<AnnouncementVO> resList = announcementService.searchList(vo);
//		if (resList.size() > 0) {
//			mv.addObject("result", resList);
//			mv.addObject("totalCount", resList.get(0).getTotal_count());
//		} else {
//			mv.addObject("totalCount", 0);
//		}
//		
//		mv.setViewName("jsonView");
//		return mv;
//	}
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
