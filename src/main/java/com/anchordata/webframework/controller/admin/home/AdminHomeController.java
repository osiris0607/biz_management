package com.anchordata.webframework.controller.admin.home;



import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;



@Controller("AdminHomeController")
public class AdminHomeController {
	
	@RequestMapping("/admin/fwd/home/main")
	public ModelAndView rdtManagement(ModelAndView mv) throws Exception {
		mv.setViewName("home/main.admin");
		return mv;
	}
	
}
