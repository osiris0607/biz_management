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
package com.anchordata.webframework.base.common.web.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.anchordata.webframework.base.common.auth.vo.UserVO;
import com.anchordata.webframework.base.util.DataMap;

public class BaseService {
	
	protected transient Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	protected ObjectMapper objectMapper;
	
	@Autowired
	protected HttpServletRequest request;
		
	/**
	 * 사용자 정보 취득
	 * 
	 * @return
	 */
	protected UserVO getUserInfo() {
		return (UserVO) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	}
		
	/**
	 * Bean To DataMap
	 * 
	 * @param from
	 * @return
	 */
	protected DataMap convert(Object from) {
		return objectMapper.convertValue(from, DataMap.class);
	}
	
	/**
	 * List<DataMap> to DataMap
	 * 
	 * @param list
	 * @param key
	 * @return
	 */
	protected DataMap getListToDataMap(final List<DataMap> list, final String key) {
		return getListToDataMap(list, key, null);
	}
	
	
	/**
	 * List<DataMap> to DataMap
	 * 
	 * @param list
	 * @param key
	 * @param valueKey
	 * @return
	 */
	protected DataMap getListToDataMap(final List<DataMap> list, final String key, final String valueKey) {
		DataMap result = null;
		if (list != null) {
			result = new DataMap();
		}
		for (DataMap map : list) {
			if (valueKey != null) {
				result.put(map.getString(key), map.get(valueKey));
			} else {
				result.put(map.getString(key), map);
			}
		}
		return result;
	}
	
}
