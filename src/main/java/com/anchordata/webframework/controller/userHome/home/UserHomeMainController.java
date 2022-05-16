package com.anchordata.webframework.controller.userHome.home;



import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;



@Controller("UserHomeMainController")
public class UserHomeMainController {
	
	@RequestMapping("/userHome/fwd/home/main")
	public ModelAndView rdtManagement(ModelAndView mv) throws Exception {
		mv.setViewName("home/main.userHome");
		return mv;
	}
	
}
