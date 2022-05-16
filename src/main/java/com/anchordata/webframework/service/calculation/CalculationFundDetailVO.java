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
package com.anchordata.webframework.service.calculation;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
@ToString
public class CalculationFundDetailVO {
	private static final long serialVersionUID = 1L;

	private int fund_id;
	private int calculation_id;
	private String item_name = "";
	private String item_plan = "";
	private String item_excution = "";
	private String item_balance = "";
	private String item_total = "";
	
	
	
	public int getCalculation_id() {
		return calculation_id;
	}
	public void setCalculation_id(int calculation_id) {
		this.calculation_id = calculation_id;
	}
	public String getItem_name() {
		return item_name;
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}
	public String getItem_plan() {
		return item_plan;
	}
	public void setItem_plan(String item_plan) {
		this.item_plan = item_plan;
	}
	public String getItem_excution() {
		return item_excution;
	}
	public void setItem_excution(String item_excution) {
		this.item_excution = item_excution;
	}
	public String getItem_balance() {
		return item_balance;
	}
	public void setItem_balance(String item_balance) {
		this.item_balance = item_balance;
	}
	public String getItem_total() {
		return item_total;
	}
	public void setItem_total(String item_total) {
		this.item_total = item_total;
	}
	public int getFund_id() {
		return fund_id;
	}
	public void setFund_id(int fund_id) {
		this.fund_id = fund_id;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
