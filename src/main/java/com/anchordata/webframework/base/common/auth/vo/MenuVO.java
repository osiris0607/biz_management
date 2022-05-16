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
package com.anchordata.webframework.base.common.auth.vo;

import java.util.List;

public class MenuVO {

	private String upMenuId;
	
	private String menuId;
	
	private String menuNm;
	
	private String menuPath;
	
	private int dept;
	
	private int prirtNo;
	
	private String roles;
	
	private List<MenuVO> subMenus;
	
	private String[] navi;
	
	private MenuVO parent;

	public String getUpMenuId() {
		return upMenuId;
	}

	public void setUpMenuId(String upMenuId) {
		this.upMenuId = upMenuId;
	}

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getMenuNm() {
		return menuNm;
	}

	public void setMenuNm(String menuNm) {
		this.menuNm = menuNm;
	}

	public String getMenuPath() {
		return menuPath;
	}

	public void setMenuPath(String menuPath) {
		this.menuPath = menuPath;
	}

	public int getDept() {
		return dept;
	}

	public void setDept(int dept) {
		this.dept = dept;
	}

	public int getPrirtNo() {
		return prirtNo;
	}

	public void setPrirtNo(int prirtNo) {
		this.prirtNo = prirtNo;
	}

	public String getRoles() {
		return roles;
	}

	public void setRoles(String roles) {
		this.roles = roles;
	}

	public String[] getNavi() {
		return navi;
	}

	public void setNavi(String[] navi) {
		this.navi = navi;
	}

	public List<MenuVO> getSubMenus() {
		return subMenus;
	}

	public void setSubMenus(List<MenuVO> subMenus) {
		this.subMenus = subMenus;
	}

	public MenuVO getParent() {
		return parent;
	}

	public void setParent(MenuVO parent) {
		this.parent = parent;
	}

}
