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
package com.anchordata.webframework.service.uploadFile;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;


@Repository("uploadFileDao")
public class uploadFileDao extends BaseDao {
	
	private String mapper	= Constants.NAMESPACE.concat("uploadFile.");
	
	/**
	 * PJS : 2020-03-27
	 * upload File 등록
	 */
	public int insertUploadFileInfo(UploadFileVO params) throws Exception{
		return update(mapper.concat("insertUploadFileInfo"), params);
	}
	
	/**
	 * 수정
	 */
	public int updateInfo(UploadFileVO params) throws Exception{
		return update(mapper.concat("updateInfo"), params);
	}
	
	/**
	 * 삭제
	 */
	public int deleteInfo(UploadFileVO params) throws Exception{
		return delete(mapper.concat("deleteInfo"), params);
	}

	/**
	 * PJS : 2020-03-27
	 * upload File Binary Cotent 찾기 
	 */
	public UploadFileVO selectUploadFileContent(UploadFileVO params) throws Exception{
		return selectOne(mapper.concat("selectUploadFileContent"), params);
	}
	
	
	/**
	 * File ID에 해당하는 List
	 */
	public List<UploadFileVO> selectSearchList(UploadFileVO params) throws Exception{
		return selectList(mapper.concat("selectSearchList"), params);
	}
	
}
