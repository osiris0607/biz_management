package com.anchordata.webframework.controller.adminHome.statistics;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.service.homeContent.HomeContentService;
import com.anchordata.webframework.service.homeContent.HomeContentVO;
import com.anchordata.webframework.service.statistics.StatisticsService;
import com.anchordata.webframework.service.statistics.StatisticsVO;



@Controller("AdminHomeStatisticsController")
public class AdminHomeStatisticsController {
	
	@RequestMapping("/adminHome/statistics/visitor/time")
	public ModelAndView rdtManagement(ModelAndView mv) throws Exception {
		mv.setViewName("statistics/visitor/time.adminHome");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	@Autowired
	StatisticsService statisticsService;
	/*
	* statistics 조회
	*/
	@RequestMapping("/adminHome/api/statistics/visitor/searchTime")
	public ModelAndView searchTime(@ModelAttribute StatisticsVO vo, ModelAndView mv) throws Exception 
	{
		List<StatisticsVO> resultData = statisticsService.serachTime(vo);
		if ( resultData.size() > 0)
		{
			mv.addObject( "result", true );
		}
		else 
		{
			mv.addObject( "result", false );
		}
		mv.addObject( "result_data", resultData );
		mv.setViewName("jsonView");
		return mv;
	}
	
	
}
