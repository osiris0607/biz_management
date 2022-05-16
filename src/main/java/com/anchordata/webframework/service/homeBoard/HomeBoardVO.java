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
package com.anchordata.webframework.service.homeBoard;


import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.anchordata.webframework.service.uploadFile.UploadFileVO;
import com.fasterxml.jackson.annotation.JsonIgnore;


public class HomeBoardVO {

	private static final long serialVersionUID = 1L;
	
	private int board_id;
	// 게시판관리타입('N'(Notice):공지관리, 'B'(Broadcast) : 보도자료관리, 'P'(Poster) : 포스터관리, 'G'(Galleryl)  : 기술갤러리관리)
	private String board_type;
	private String title; 			// 제목 / 기술명(갤러리관리)
	private String writer;
	private int hits;
	private String file_yn;
	private String open_yn;
	private int file_id;
	private String description; 	// 내용 / 기술요약(갤러리관리)
	// 'D'(Document) : 첨부파일, ' P'(Picture) : 기술 이미지
	private String file_type;
	// 기술 갤러리 관련
	private String business_name;
	private String institue_name;
	private String skill_keyword;
	private String skill_effect;
	private String from_date;
	private String to_date;
	
	@JsonIgnore
	private MultipartFile[] upload_attach_file;
	private List<UploadFileVO> return_upload_attach_file_info;
	
	@JsonIgnore
	private MultipartFile[] upload_image_file;
	private List<UploadFileVO> return_upload_image_file_info;

	// Board 삭제 ID
	private List<Integer> delete_ids;
	// attach_file 삭제 ID
	private List<Integer> delete_file_list;
	
	private int use_yn;
	private String reg_date;
	private int total_count;
	
	
	///////////////////////////////////////////////////
	// 검색 관련
	///////////////////////////////////////////////////
	// 키워드 검색
	private String keyword;
	// paging List Index
	private String pageIndex;
	// Paging List Order by
	private String orderby;
	
	
	
	
	
	public String getSkill_keyword() {
		return skill_keyword;
	}
	public void setSkill_keyword(String skill_keyword) {
		this.skill_keyword = skill_keyword;
	}
	public String getSkill_effect() {
		return skill_effect;
	}
	public void setSkill_effect(String skill_effect) {
		this.skill_effect = skill_effect;
	}
	public String getBusiness_name() {
		return business_name;
	}
	public void setBusiness_name(String business_name) {
		this.business_name = business_name;
	}
	public String getInstitue_name() {
		return institue_name;
	}
	public void setInstitue_name(String institue_name) {
		this.institue_name = institue_name;
	}
	public String getFrom_date() {
		return from_date;
	}
	public void setFrom_date(String from_date) {
		this.from_date = from_date;
	}
	public String getTo_date() {
		return to_date;
	}
	public void setTo_date(String to_date) {
		this.to_date = to_date;
	}
	public List<Integer> getDelete_file_list() {
		return delete_file_list;
	}
	public void setDelete_file_list(List<Integer> delete_file_list) {
		this.delete_file_list = delete_file_list;
	}
	public List<Integer> getDelete_ids() {
		return delete_ids;
	}
	public void setDelete_ids(List<Integer> delete_ids) {
		this.delete_ids = delete_ids;
	}
	public String getFile_yn() {
		return file_yn;
	}
	public void setFile_yn(String file_yn) {
		this.file_yn = file_yn;
	}
	public String getOpen_yn() {
		return open_yn;
	}
	public void setOpen_yn(String open_yn) {
		this.open_yn = open_yn;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getFile_type() {
		return file_type;
	}
	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}
	public int getFile_id() {
		return file_id;
	}
	public void setFile_id(int file_id) {
		this.file_id = file_id;
	}
	public int getBoard_id() {
		return board_id;
	}
	public void setBoard_id(int board_id) {
		this.board_id = board_id;
	}
	public String getBoard_type() {
		return board_type;
	}
	public void setBoard_type(String board_type) {
		this.board_type = board_type;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public int getHits() {
		return hits;
	}
	public void setHits(int hits) {
		this.hits = hits;
	}
	public MultipartFile[] getUpload_attach_file() {
		return upload_attach_file;
	}
	public void setUpload_attach_file(MultipartFile[] upload_attach_file) {
		this.upload_attach_file = upload_attach_file;
	}
	public List<UploadFileVO> getReturn_upload_attach_file_info() {
		return return_upload_attach_file_info;
	}
	public void setReturn_upload_attach_file_info(List<UploadFileVO> return_upload_attach_file_info) {
		this.return_upload_attach_file_info = return_upload_attach_file_info;
	}
	public MultipartFile[] getUpload_image_file() {
		return upload_image_file;
	}
	public void setUpload_image_file(MultipartFile[] upload_image_file) {
		this.upload_image_file = upload_image_file;
	}
	public List<UploadFileVO> getReturn_upload_image_file_info() {
		return return_upload_image_file_info;
	}
	public void setReturn_upload_image_file_info(List<UploadFileVO> return_upload_image_file_info) {
		this.return_upload_image_file_info = return_upload_image_file_info;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getPageIndex() {
		return pageIndex;
	}
	public void setPageIndex(String pageIndex) {
		this.pageIndex = pageIndex;
	}
	public String getOrderby() {
		return orderby;
	}
	public void setOrderby(String orderby) {
		this.orderby = orderby;
	}
	public int getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(int use_yn) {
		this.use_yn = use_yn;
	}
	public int getTotal_count() {
		return total_count;
	}
	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	
	
}
