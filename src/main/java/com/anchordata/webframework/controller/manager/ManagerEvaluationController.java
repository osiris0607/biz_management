package com.anchordata.webframework.controller.manager;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.announcement.AnnouncementVO;
import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.evaluation.EvaluationCommissionerVO;



@Controller("ManagerEvaluationController")
public class ManagerEvaluationController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	
	
	@RequestMapping("/manager/fwd/evaluation/main")
	public ModelAndView fwdMain(@ModelAttribute AnnouncementVO vo,ModelAndView mv) throws Exception {
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("evaluation/main.manager");
		return mv;
	}
	
	@RequestMapping("/manager/fwd/evaluation/estimation")
	public ModelAndView fwdEstimation(@ModelAttribute EvaluationCommissionerVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/estimation.manager");
		return mv;
	}
	
	@RequestMapping("/manager/fwd/evaluation/sign/evaluation")
	public ModelAndView fwdSignEvaluation(@ModelAttribute EvaluationCommissionerVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("manager/evaluation/signEvaluation");
		return mv;
	}
	
	@RequestMapping("/manager/fwd/evaluation/sign/chairmanEvaluation")
	public ModelAndView fwdSignChairmanEvaluation(@ModelAttribute EvaluationCommissionerVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("manager/evaluation/signChairmanEvaluation");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
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
