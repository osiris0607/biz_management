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

import org.apache.ibatis.session.RowBounds;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class PageBounds extends RowBounds implements Serializable {

	private static final long serialVersionUID = 4452282727354311192L;

	private static final String DEFAULT_KEY = "list"; 
	
	public final static int NO_PAGE = 1;
	
	public final static int NO_ROW = 10;
	
	protected int page = NO_PAGE;
	
	protected int limit = NO_ROW;
	
	protected List<Order> orders = new ArrayList<Order>();
	
	protected boolean containsTotalCount;

	protected Boolean asyncTotalCount;
	
	protected String key = DEFAULT_KEY;

	public PageBounds() {
		containsTotalCount = false;
	}

	public PageBounds(RowBounds rowBounds) {
		if (rowBounds instanceof PageBounds) {
			PageBounds pageBounds = (PageBounds) rowBounds;
			this.page 	= pageBounds.page;
			this.limit 	= pageBounds.limit;
			this.orders = pageBounds.orders;
			this.containsTotalCount = pageBounds.containsTotalCount;
			this.asyncTotalCount 	= pageBounds.asyncTotalCount;
		} else {
			this.page = (rowBounds.getOffset() / rowBounds.getLimit()) + 1;
			this.limit = rowBounds.getLimit();
		}

	}

	public PageBounds(int limit) {
		this.limit = limit;
		this.containsTotalCount = false;
	}

	public PageBounds(int page, int limit) {
		this(page, limit, DEFAULT_KEY, new ArrayList<Order>(), true);
	}

	public PageBounds(int page, int limit, boolean containsTotalCount) {
		this(page, limit, DEFAULT_KEY, new ArrayList<Order>(), containsTotalCount);
	}

	public PageBounds(List<Order> orders) {
		this(NO_PAGE, NO_ROW, DEFAULT_KEY, orders, false);
	}

	public PageBounds(Order... order) {
		this(NO_PAGE, NO_ROW, order);
		this.containsTotalCount = false;
	}

	public PageBounds(int page, int limit, Order... order) {
		this(page, limit, DEFAULT_KEY, Arrays.asList(order), true);
	}
	
	public PageBounds(int page, int limit, String key, Order... order) {
		this(page, limit, key, Arrays.asList(order), true);
	}

	public PageBounds(int page, int limit, String key, List<Order> orders) {
		this(page, limit, key, orders, true);
	}

	public PageBounds(int page, int limit, String key, List<Order> orders, boolean containsTotalCount) {
		this.page 	= (page == 0) ? NO_PAGE : page;
		this.limit 	= (limit == 0) ? NO_ROW : limit;
		this.key 	=  key;
		this.orders = orders;
		this.containsTotalCount = containsTotalCount;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getLimit() {
		return limit;
	}

	public void setLimit(int limit) {
		this.limit = limit;
	}

	public boolean isContainsTotalCount() {
		return containsTotalCount;
	}

	public void setContainsTotalCount(boolean containsTotalCount) {
		this.containsTotalCount = containsTotalCount;
	}

	public List<Order> getOrders() {
		return orders;
	}

	public void setOrders(List<Order> orders) {
		this.orders = orders;
	}

	public Boolean getAsyncTotalCount() {
		return asyncTotalCount;
	}

	public void setAsyncTotalCount(Boolean asyncTotalCount) {
		this.asyncTotalCount = asyncTotalCount;
	}
	
	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	@Override
	public int getOffset() {
		if (page >= 1) {
			return (page - 1) * limit;
		}
		return 0;
	}

	@Override
	public String toString() {
		final StringBuilder sb = new StringBuilder("PageBounds{");
		sb.append("page=").append(page);
		sb.append(", limit=").append(limit);
		sb.append(", orders=").append(orders);
		sb.append(", containsTotalCount=").append(containsTotalCount);
		sb.append(", asyncTotalCount=").append(asyncTotalCount);
		sb.append('}');
		return sb.toString();
	}
}