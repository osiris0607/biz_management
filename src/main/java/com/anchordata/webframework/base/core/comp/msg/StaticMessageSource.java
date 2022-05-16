/*******************************************************************************
 *
 * Copyright ⓒ 2018 kth corp. All rights reserved.
 *
 * This is a proprietary software of kt corp, and you may not use this file except in
 * compliance with license agreement with kt corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of kt corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.base.core.comp.msg;

import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.context.support.MessageSourceAccessor;

public class StaticMessageSource {

	private static MessageSourceAccessor msgSrcAcs;
		
	public static MessageSourceAccessor getMsgSrcAcs() {
		return msgSrcAcs;
	}

	public static void setMsgSrcAcs(MessageSourceAccessor msgSrcAcs) {
		StaticMessageSource.msgSrcAcs = msgSrcAcs;
	}

	/**
	* KEY에 해당하는 메세지 반환
	* 
	* @param  key
	* @return
	*/
	public static String getMessage(String key) {
	   return msgSrcAcs.getMessage(key, LocaleContextHolder.getLocale());
	}
	
	/**
	* KEY에 해당하는 메세지 반환
	* 
	* @param  key
	* @return
	*/
	public static String getMessage(String key, Object[] objs) {
		return msgSrcAcs.getMessage(key, objs, LocaleContextHolder.getLocale());
	}
	
}
