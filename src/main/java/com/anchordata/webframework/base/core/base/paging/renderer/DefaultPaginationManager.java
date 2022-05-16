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
package com.anchordata.webframework.base.core.base.paging.renderer;


import java.util.Map;

public class DefaultPaginationManager implements PaginationManager {

	private Map<String, PaginationRenderer> rendererType;

	/**
	 * Set PaginationRenderer 구현 클래스
	 * 
	 * @param rendererType  - PaginationRenderer 구현 클래스 집합 Map.
	 */
	public void setRendererType(Map<String, PaginationRenderer> rendererType) {
		this.rendererType = rendererType;
	}

	/**
	 * 
	 * @param type - tag의 파라미터 값.
	 */
	public PaginationRenderer getRendererType(String type) {
		return (rendererType != null && rendererType.containsKey(type)) ? (PaginationRenderer) rendererType.get(type) : new DefaultPaginationRenderer();
	}

}
