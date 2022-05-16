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

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

public class Order implements Serializable {

	private static final long serialVersionUID = -277683697499376144L;
	
	private static final String INJECTION_REGEX = "[A-Za-z0-9\\_\\-\\+\\.]+";
	
	private Direction direction;
	private String property;
	private String orderExpr;
	
	
	public Order(String property, Direction direction) {
		this.direction = direction;
		this.property = property;
	}

	public Order(String property, Direction direction, String orderExpr) {
		this.direction = direction;
		this.property = property;
		this.orderExpr = orderExpr;
	}

	public Direction getDirection() {
		return direction;
	}

	public String getProperty() {
		return property;
	}

	public String getOrderExpr() {
		return orderExpr;
	}

	public void setDirection(Direction direction) {
		this.direction = direction;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public void setOrderExpr(String orderExpr) {
		this.orderExpr = orderExpr;
	}

	public static boolean isSQLInjection(String str) {
		return !Pattern.matches(INJECTION_REGEX, str);
	}

	public static List<Order> formString(String orderSegment) {
		return formString(orderSegment, null);
	}

	public static List<Order> formString(String orderSegment, String orderExpr) {
		if (orderSegment == null || orderSegment.trim().equals("")) {
			return new ArrayList<Order>(0);
		}

		List<Order> results = new ArrayList<Order>();
		String[] orderSegments = orderSegment.trim().split(",");
		for (int i = 0; i < orderSegments.length; i++) {
			String sortSegment = orderSegments[i];
			Order order = _formString(sortSegment, orderExpr);
			if (order != null) {
				results.add(order);
			}
		}
		return results;
	}

	private static Order _formString(String orderSegment, String orderExpr) {
		if (orderSegment == null || orderSegment.trim().equals("") || orderSegment.startsWith("null.") || orderSegment.startsWith(".")) {
			return null;
		}

		String[] array = orderSegment.trim().split("\\.");
		if (array.length != 1 && array.length != 2) {
			throw new IllegalArgumentException("orderSegment pattern must be {property}.{direction}, input is: " + orderSegment);
		}

		return create(array[0], array.length == 2 ? array[1] : "asc", orderExpr);
	}

	public static Order create(String property, String direction) {
		return create(property, direction, null);
	}

	/**
	 *
	 * @param property
	 * @param direction
	 * @param orderExpr
	 *            placeholder is "?", in oracle like: "nlssort( ?,'NLS_SORT=SCHINESE_PINYIN_M')". Warning: you must preventorderExpr SQL injection.
	 * @return
	 */
	public static Order create(String property, String direction, String orderExpr) {
		return new Order(property, Order.Direction.fromString(direction), orderExpr);
	}
	
	@Override
	public String toString() {
		if (isSQLInjection(property)) {
			throw new IllegalArgumentException("SQLInjection property: " + property);
		}
		if (orderExpr != null && orderExpr.indexOf("?") != -1) {
			String[] exprs = orderExpr.split("\\?");
			if (exprs.length == 2) {
				return String.format(orderExpr.replaceAll("\\?", "%s"), property) + (direction == null ? "" : " " + direction.name());
			}
			return String.format(orderExpr.replaceAll("\\?", "%s"), property, direction == null ? "" : " " + direction.name());
		}
		return property + (direction == null ? "" : " " + direction.name());
	}

	/**
	 * PropertyPath implements the pairing of an {@link Direction} and a
	 * property. It is used to provide input for
	 *
	 * @author Oliver Gierke
	 */
	public static enum Direction {
		ASC, DESC;
		public static Direction fromString(String value) {
			try {
				return Direction.valueOf(value.toUpperCase(Locale.US));
			} catch (Exception e) {
				return ASC;
			}
		}
	}
}
