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
package com.anchordata.webframework.service.emailSMS;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.anchordata.webframework.base.util.NaverMailSender;
import com.nhncorp.lucy.security.xss.XssPreventer;

@Service("emailSMSService")
public class EmailSMSService {
	
	@Autowired
	private EmailSMSDao emailSMSDao;
	
	
	/**
	 * 메일 / SMS 발송 정보 설정
	 */
	@Transactional
	public int registration(emailSMSVO vo) throws Exception {
		vo.setComment(XssPreventer.unescape(vo.getComment()));
		int result = emailSMSDao.insertInfo(vo);
		return result;
	}
	/**
	 * 메일 / SMS 발송 정보 상세
	 */
	@Transactional
	public List<emailSMSVO> detail(emailSMSVO vo) throws Exception {
		List<emailSMSVO> result = emailSMSDao.selectDetail(vo);
		return result;
	}
	/**
	 * 메일 발송
	 */
	@Transactional
	public boolean sendMail(emailSMSVO vo) throws Exception {
		System.out.println("메일발송 서비스 ----------------------- >> " + vo.getTitle() +  vo.getSender()+ vo.getTo_mail()+vo.getComment());
		boolean result = NaverMailSender.gmailSender(vo.getTitle(), vo.getSender(), vo.getTo_mail(), vo.getComment());
		return result;
	}	
	
}
