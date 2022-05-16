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
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.anchordata.webframework.base.common.web.dao.CommCodeDao;
import com.anchordata.webframework.base.util.DataMap;


@Service("commCodeService")
public class CommCodeService extends BaseService {

	@Autowired
	private CommCodeDao commCodeDao;
	
	/**
	 * 코드 목록 조회
	 * 
	 * @param upCodeId
	 * @return
	 */
	public List<DataMap> getCodes(String upCodeId) {
		List<DataMap> list = commCodeDao.getCodes();
		List<DataMap> codes = 
				list.stream()
					.filter(p -> upCodeId.equals(p.getString("upCodeId")))
					.collect(Collectors.toList());
		
		return codes;
	}	
}
