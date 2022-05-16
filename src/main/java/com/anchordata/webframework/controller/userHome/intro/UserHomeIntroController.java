package com.anchordata.webframework.controller.userHome.intro;



import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;



@Controller("UserHomeIntroController")
public class UserHomeIntroController {
	
	@RequestMapping("/userHome/fwd/intro/main")
	public ModelAndView introMain(ModelAndView mv) throws Exception {
		mv.setViewName("intro/main.userHome");
		return mv;
	}
	
	@RequestMapping("/userHome/fwd/intro/sitemap/main")
	public ModelAndView sitemapMain(ModelAndView mv) throws Exception {
		mv.setViewName("intro/sitemapMain.userHome");
		return mv;
	}
	
}
