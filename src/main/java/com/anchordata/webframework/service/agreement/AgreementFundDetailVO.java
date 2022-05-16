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
package com.anchordata.webframework.service.agreement;

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
public class AgreementFundDetailVO {
	private static final long serialVersionUID = 1L;

	private int fund_id;
	private int agreement_id;
	private String type = "";
	private String ab_total = "";
	private String ab_total_p = "";
	private String a = "";
	private String a_p = "";
	private String b = "";
	private String b_p = "";
	private String cdef_total = "";
	private String cdef_total_p = "";
	private String c = "";
	private String c_p = "";
	private String d = "";
	private String d_p = "";
	private String e = "";
	private String e_p = "";
	private String f = "";
	private String f_p = "";
	private String g = "";
	private String g_p = "";
	private String total = "";
	private String total_p = "";
	
	
	
	public int getFund_id() {
		return fund_id;
	}
	public void setFund_id(int fund_id) {
		this.fund_id = fund_id;
	}
	public int getAgreement_id() {
		return agreement_id;
	}
	public void setAgreement_id(int agreement_id) {
		this.agreement_id = agreement_id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getAb_total() {
		return ab_total;
	}
	public void setAb_total(String ab_total) {
		this.ab_total = ab_total;
	}
	public String getAb_total_p() {
		return ab_total_p;
	}
	public void setAb_total_p(String ab_total_p) {
		this.ab_total_p = ab_total_p;
	}
	public String getA() {
		return a;
	}
	public void setA(String a) {
		this.a = a;
	}
	public String getA_p() {
		return a_p;
	}
	public void setA_p(String a_p) {
		this.a_p = a_p;
	}
	public String getB() {
		return b;
	}
	public void setB(String b) {
		this.b = b;
	}
	public String getB_p() {
		return b_p;
	}
	public void setB_p(String b_p) {
		this.b_p = b_p;
	}
	public String getCdef_total() {
		return cdef_total;
	}
	public void setCdef_total(String cdef_total) {
		this.cdef_total = cdef_total;
	}
	public String getCdef_total_p() {
		return cdef_total_p;
	}
	public void setCdef_total_p(String cdef_total_p) {
		this.cdef_total_p = cdef_total_p;
	}
	public String getC() {
		return c;
	}
	public void setC(String c) {
		this.c = c;
	}
	public String getC_p() {
		return c_p;
	}
	public void setC_p(String c_p) {
		this.c_p = c_p;
	}
	public String getD() {
		return d;
	}
	public void setD(String d) {
		this.d = d;
	}
	public String getD_p() {
		return d_p;
	}
	public void setD_p(String d_p) {
		this.d_p = d_p;
	}
	public String getE() {
		return e;
	}
	public void setE(String e) {
		this.e = e;
	}
	public String getE_p() {
		return e_p;
	}
	public void setE_p(String e_p) {
		this.e_p = e_p;
	}
	public String getF() {
		return f;
	}
	public void setF(String f) {
		this.f = f;
	}
	public String getF_p() {
		return f_p;
	}
	public void setF_p(String f_p) {
		this.f_p = f_p;
	}
	public String getG() {
		return g;
	}
	public void setG(String g) {
		this.g = g;
	}
	public String getG_p() {
		return g_p;
	}
	public void setG_p(String g_p) {
		this.g_p = g_p;
	}
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getTotal_p() {
		return total_p;
	}
	public void setTotal_p(String total_p) {
		this.total_p = total_p;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
