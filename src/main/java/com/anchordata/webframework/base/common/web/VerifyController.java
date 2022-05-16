/*******************************************************************************
 *
 * Copyright ⓒ 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of namu C&D corp, and you may not use this file except in
 * compliance with license agreement with namu C&D corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of namu C&D corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.base.common.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.base.common.email.GMailSender;
import com.anchordata.webframework.base.util.TempKey;
import com.anchordata.webframework.base.util.VerifyRecaptcha;

@Controller("verifyController")
public class VerifyController {

	public static final String url = "https://www.google.com/recaptcha/api/siteverify";
	private final static String USER_AGENT = "Mozilla/5.0";

	@Value("${anchorData.verifyEmail}")
	private String verifyEmail;
	
	@Value("${spring.google.recaptcha.secretKey}")
	private String secret;

	@RequestMapping("/verifyEmail")
	public ModelAndView verifyEmail(HttpServletRequest request, ModelAndView mv) {

		String key = new TempKey().getKey(50, false); // 인증키 생성
		GMailSender sender = new GMailSender();

		// sender.sender("수석코치 김코치 이메일인증", email, contents)
		mv.setViewName("/home/verifyEmail.user");
		return mv;
	}

	@RequestMapping("/verifyRecaptcha")
    public ModelAndView verifyRecaptcha(HttpServletRequest request, ModelAndView mv) throws Throwable {
		VerifyRecaptcha.setSecretKey(secret); //secretKey 세팅
		String gRecaptchaResponse = request.getParameter("recaptcha"); //recapcha 파라미터 가져오기
			
        boolean verify = VerifyRecaptcha.verify(gRecaptchaResponse); //리캡챠 인증 true,false 설공 실패 리턴
		String result = "fail";
        if (verify) {
        	result = "success";
        }
	
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
}
