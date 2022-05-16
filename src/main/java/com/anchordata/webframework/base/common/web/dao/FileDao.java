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
package com.anchordata.webframework.base.common.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;
import com.anchordata.webframework.base.core.comp.file.vo.FileInfoVO;
import com.anchordata.webframework.base.util.DataMap;


@Repository("fileDao")
public class FileDao extends BaseDao {

	/**
	 * 파일 업로드 정보 등록
	 * 
	 * @param newFiles
	 */
	public void insertFileInfo(List<FileInfoVO> params) {
		insert(Constants.NAMESPACE.concat("comm.file.insertFileInfo"), params);
	}
	
	/**
	 * 파일 업로드 정보 수정
	 * 
	 * @param newFiles
	 */
	public void updateFileInfo(List<FileInfoVO> params) {
		update(Constants.NAMESPACE.concat("comm.file.updateFileInfo"), params);
	}
	
	/**
	 * 파일 업로드 정보 삭제
	 * 
	 * @param delFiles
	 */
	public void removeFileInfoVO(List<FileInfoVO> params) {
		update(Constants.NAMESPACE.concat("comm.file.removeFileInfo"), params);
	}

	/**
	 * 파일 그룹 정보 등록
	 * 
	 * @param newFiles
	 */
	public void insertFileGroupInfo(List<FileInfoVO> params) {
		insert(Constants.NAMESPACE.concat("comm.file.insertFileGroupInfo"), params);
	}
	
	/**
	 * 파일 그룹 정보 수정
	 * 
	 * @param modFiles
	 */
	public void updateFileGroup(List<FileInfoVO> params) {
		update(Constants.NAMESPACE.concat("comm.file.updateFileGroupInfo"), params);
	}	

	/**
	 * 파일 그룹 정보 삭제
	 * 
	 * @param delFiles
	 */
	public void removeFileGroup(List<FileInfoVO> params) {
		delete(Constants.NAMESPACE.concat("comm.file.removeFileGroupInfo"), params);
	}

	/**
	 * 파일명으로 파일 정보 조회
	 * 
	 * @param fileNm
	 * @return
	 */
	public DataMap findFileInfoByName(DataMap params) {
		return selectOne(Constants.NAMESPACE.concat("comm.file.findFileInfoByName"), params);
	}

	/**
	 * 파일그룹 ID로 파일 정보 조회
	 * 
	 * @param params
	 * @return
	 */
	public DataMap findFileInfoByGroup(DataMap params) {
		return selectOne(Constants.NAMESPACE.concat("comm.file.findFileInfoByGroup"), params);
	}
}
