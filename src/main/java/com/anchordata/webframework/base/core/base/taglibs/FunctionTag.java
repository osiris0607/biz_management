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
package com.anchordata.webframework.base.core.base.taglibs;

import org.apache.commons.lang3.StringUtils;


public class FunctionTag {
	
	
//	private static final String CRLF = "[\n\r]";
//	private static final String BR	= "<br/>";
//
//	/**
//	 * 컨텐츠 내용 개행 문자를 <br/> 처리
//	 * 
//	 * @param content
//	 * @return
//	 */
//	public static String br(String content) {
//		return StringUtils.replacePattern(content, CRLF, BR);
//	}
//	
//	/**
//	 * 컨텐츠 내용 <br/>을 개행 문자로 처리
//	 * 
//	 * @param content
//	 * @return
//	 */
//	public static String ce(String content) {
//		return StringUtils.replace(content, BR, Constants.CR);
//	}
	
	/**
	 * id *** 처리
	 * 
	 * @methodName id
	 * @param content
	 * @return String
	 * @author Dong-joo KIM
	 * @since 2018. 12. 18.
	 */
	public static String id(String content) {
		StringBuffer asterisk_id = new StringBuffer();
		if (!StringUtils.isEmpty(content)) {
			Double asterisk = (double) Math.round((double) content.length() / 3);								// 1/3을 별표처리. 소숫점 반올림.
			asterisk_id = new StringBuffer(content.substring(0, (content.length() - asterisk.intValue())));	// 오른쪽으로 1/3만큼 없에주고.
			
			for (int i = 0; i < asterisk.intValue(); i++) {											// 그만큼 별표 추가
				asterisk_id.append("*");
			}
		}
		return asterisk_id.toString();
	}

}
