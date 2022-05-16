package com.anchordata.webframework.controller.adminHome.home;



import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;



@Controller("AdminHomeMainController")
public class AdminHomeMainController {
	
	@RequestMapping("/admin/fwd/adminHome/main")
	public ModelAndView rdtManagement(ModelAndView mv) throws Exception {
		mv.setViewName("home/main.adminHome");
		return mv;
	}
	
}
