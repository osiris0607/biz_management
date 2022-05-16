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
package com.anchordata.webframework.base.common.auth.dao;


import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.common.auth.vo.UserVO;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.util.DataMap;

@Repository("authDao")
public class AuthDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("auth.");
	
	/**
	 * 유저 정보 가져온다.
	 * 
	 * @param params
	 * @return
	 */
	public UserVO findUserInfo(DataMap params) {
		return selectOne(mapper.concat("findUserInfo"), params);
	}
	
	/**
	 * 
	 * @param params
	 * @return
	 */
	public int insertUserInfo(DataMap params) {
		return insert(mapper.concat("insertUserInfo"), params);
	}
	

}
