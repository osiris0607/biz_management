/*******************************************************************************
 *
 * Copyright �뱬 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of namu C&D corp, and you may not use this file except in
 * compliance with license agreement with namu C&D corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of namu C&D corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.base.common.web;

import java.util.HashMap;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller("fileController")
public class FileController {
	
	//@Autowired
	//private FileService fileService;

	/**
	 * 
	 * @param search
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("/file/fileUploadTest")
	public ModelAndView fileUploadTest(@RequestParam HashMap<String, Object> search, ModelAndView mv) throws Exception {
		
		mv.setViewName("file/fileUploadTest.user");
		return mv;
	}
	
	@PostMapping("/file/upload") 
//	public ResponseEntity<?> fileUpload(MultipartHttpServletRequest request) {
	public ResponseEntity<?> fileUpload() {
		return null;
	}
	
}
