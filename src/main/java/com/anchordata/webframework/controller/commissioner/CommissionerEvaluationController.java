package com.anchordata.webframework.controller.commissioner;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.announcement.AnnouncementVO;
import com.anchordata.webframework.service.evaluation.EvaluationCommissionerVO;
import com.anchordata.webframework.service.evaluation.EvaluationItemVO;
import com.anchordata.webframework.service.evaluation.EvaluationSearchVO;
import com.anchordata.webframework.service.evaluation.EvaluationService;
import com.anchordata.webframework.service.evaluation.EvaluationVO;
import com.anchordata.webframework.service.member.CommissionerEvaluationItemVO;
import com.anchordata.webframework.service.member.CommissionerService;
import com.anchordata.webframework.service.member.CommissionerVO;



@Controller("CommissionerEvaluationController")
public class CommissionerEvaluationController {
	
	@Autowired
	private EvaluationService evaluationService;
	@Autowired
	private CommissionerService commissionerService;
	
	
	
	@RequestMapping("/commissioner/fwd/evaluation/main")
	public ModelAndView fwdMain(@ModelAttribute AnnouncementVO vo,ModelAndView mv) throws Exception {
		mv.setViewName("evaluation/main.commissioner");
		return mv;
	}
	
	@RequestMapping("/commissioner/fwd/evaluation/estimation")
	public ModelAndView fwdEstimation(@ModelAttribute EvaluationCommissionerVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("evaluation/estimation.commissioner");
		return mv;
	}
	
	@RequestMapping("/commissioner/fwd/evaluation/sign/security")
	public ModelAndView fwdSignSecurity(@ModelAttribute EvaluationCommissionerVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("commissioner/evaluation/signSecurity");
		return mv;
	}
	
	@RequestMapping("/commissioner/fwd/evaluation/sign/payment")
	public ModelAndView fwdSignPayment(@ModelAttribute EvaluationCommissionerVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("commissioner/evaluation/signPayment");
		return mv;
	}
	
	@RequestMapping("/commissioner/fwd/evaluation/sign/evaluation")
	public ModelAndView fwdSignEvaluation(@ModelAttribute EvaluationCommissionerVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("commissioner/evaluation/signEvaluation");
		return mv;
	}
	
	@RequestMapping("/commissioner/fwd/evaluation/sign/chairmanEvaluation")
	public ModelAndView fwdSignChairmanEvaluation(@ModelAttribute EvaluationCommissionerVO vo,ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("commissioner/evaluation/signChairmanEvaluation");
		return mv;
	}
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	
	/**
	* 검색 List
	*/
	@RequestMapping("/commissioner/api/evaluation/search/paging")
		public ModelAndView search(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		List<EvaluationVO> resList = evaluationService.searchRelatedEvaluationPagingList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
			mv.addObject("totalCount", resList.size());
		} else {
			mv.addObject("result", false);
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 보안 사인 저장
	*/
	@RequestMapping("/commissioner/api/evaluation/update/signSecurity")
		public ModelAndView updateCommissionerSignSecurity(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateCommissionerSignSecurity(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 지급 사인 저장
	*/
	@RequestMapping("/commissioner/api/evaluation/update/signPayment")
		public ModelAndView updateCommissionerSignPayment(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateCommissionerSignPayment(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가 완료 사인 저장
	*/
	@RequestMapping("/commissioner/api/evaluation/update/signEvaluation")
		public ModelAndView updateCommissionerSignEvaluation(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateCommissionerSignEvaluation(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 위원장 평가 완료 사인 저장
	*/
	@RequestMapping("/commissioner/api/evaluation/update/signChairmanEvaluation")
		public ModelAndView updateCommissionerSignChairmanEvaluation(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateCommissionerSignChairmanEvaluation(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	/**
	* 보안서약서 저장
	*/
	@RequestMapping("/commissioner/api/evaluation/update/agreeSecurity")
		public ModelAndView updateCommissionerAgreeSecurity(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateCommissionerAgreeSecurity(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 지급서약서 저장
	*/
	@RequestMapping("/commissioner/api/evaluation/update/agreePayment")
		public ModelAndView updateCommissionerAgreePayment(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateCommissionerAgreePayment(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가위원 평가서 제출
	*/
	@RequestMapping("/commissioner/api/evaluation/update/submitEvaluation")
		public ModelAndView updateCommissionerEvaluation(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateCommissionerSubmitEvaluation(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가위원장 평가서 제출
	*/
	@RequestMapping("/commissioner/api/evaluation/update/submitChairmanEvaluation")
		public ModelAndView updateCommissionerChairmanEvaluation(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		int result = evaluationService.updateCommissionerChairmanEvaluation(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	/**
	*  commissioner 상세 정보
	*/
	@RequestMapping("/commissioner/api/evaluation/commissioner/detail")
	public ModelAndView detail(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		CommissionerVO resultData = commissionerService.getDetail(vo);
		mv.addObject("result", true);
		mv.addObject("result_data", resultData);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	*  evaluation-commissioner 상세 정보
	*/
	@RequestMapping("/commissioner/api/evaluation/commissioner/detail2")
	public ModelAndView evaluationCommissionerDetail(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		EvaluationCommissionerVO resultData = evaluationService.selectEvaluationCommissionerDetail(vo);
		mv.addObject("result", true);
		mv.addObject("result_data", resultData);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	*  evaluation 상세 정보
	*/
	@RequestMapping("/commissioner/api/evaluation/detail")
	public ModelAndView evaluationDetail(@ModelAttribute EvaluationSearchVO vo, ModelAndView mv) throws Exception {
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
	/**
	*  위원장인 경우 평가위원의 모든 평가 내용을 봐야 한다.
	*  해당 평가에 선정된 평가위원 정보 검색
	*/
	@RequestMapping("/commissioner/api/evaluation/search/relatedCommissionerList")
		public ModelAndView searchRelatedCommissionerList(@ModelAttribute EvaluationCommissionerVO vo, ModelAndView mv) throws Exception {
		List<EvaluationCommissionerVO> resList = evaluationService.searchRelatedCommissionerList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
			mv.addObject("totalCount", resList.size());
		} else {
			mv.addObject("result", false);
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 은행정보 변경
	*/
	@RequestMapping("/commissioner/api/evaluation/update/bankInfo")
		public ModelAndView updateBankInfo(@ModelAttribute CommissionerVO vo, ModelAndView mv) throws Exception {
		int result = commissionerService.updateBankInfo(vo);
		if (result > 0) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 과제에 연결된 평가 항목 리스트 검색
	*/
	@RequestMapping("/commissioner/api/evaluation/item/detail")
		public ModelAndView evaluationItemDetail(@ModelAttribute EvaluationItemVO vo, ModelAndView mv) throws Exception {
		List<EvaluationItemVO> result = evaluationService.selectReleatedItemDetail(vo);
		if (result != null) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가 결과 등록
	*/
	@RequestMapping("/commissioner/api/evaluation/resultItem/registration")
		public ModelAndView registrationEvaluationItem(@ModelAttribute CommissionerEvaluationItemVO vo, ModelAndView mv) throws Exception {
		int result = commissionerService.insertEvaluationResultItemInfo(vo);
		if (result > 0 ) {
			mv.addObject("result", true);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 평가 결과 검색
	*/
	@RequestMapping("/commissioner/api/evaluation/resultItem/detail")
		public ModelAndView evaluationResultItemDetail(@ModelAttribute CommissionerEvaluationItemVO vo, ModelAndView mv) throws Exception {
		CommissionerEvaluationItemVO result = commissionerService.selectEvaluationResultItemDetail(vo);
		if (result != null ) {
			mv.addObject("result", true);
			mv.addObject("result_data", result);
		} else {
			mv.addObject("result", false);
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	
}
