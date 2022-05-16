/*******************************************************************************
 *
 * Copyright ⓒ 2019 namu C&D corp. All rights reserved.
 *
 * This is a proprietary software of kt corp, and you may not use this file except in
 * compliance with license agreement with kt corp. Any redistribution or use of this
 * software, with or without modification shall be strictly prohibited without prior written
 * approval of kt corp, and the copyright notice above does not evidence any actual or
 * intended publication of such software.
 *
 *******************************************************************************/
package com.anchordata.webframework.base.core.support.mybtis.vo;

import java.util.Collection;
import java.util.LinkedHashMap;


public class PageListData extends LinkedHashMap<String, Object>  {

	private static final long serialVersionUID = 8610060910334172737L;

	public PageListData() {}
	
	public <E> PageListData(Collection<? extends E> c, Paginator p) {
		this.put("paginator", p);
		if (c.size() > 0) {
			this.put("list", c);
		}
	}
	
	public <E> PageListData(String key, Collection<? extends E> c) {
		this.put("paginator", ((PageList<?>)c).getPaginator());	
		if (c.size() > 0) {
			this.put(key, c);
		}
	}
	
	public <E> PageListData(String key, Collection<? extends E> c, Paginator p) {
		this.put("paginator", p);
		if (c.size() > 0) {
			this.put(key, c);
		}
	}
	
}
