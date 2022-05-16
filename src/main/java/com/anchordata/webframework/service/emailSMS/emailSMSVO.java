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
package com.anchordata.webframework.service.emailSMS;

import java.util.List;

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
public class emailSMSVO {

	private static final long serialVersionUID = 1L;

	
	private int mail_sms_id;
	private int reception_id;
	private String reception_status = "";
	private String title = "";
	private String comment = "";
	private String link = "";
	private String sender = "";
	private String type = "";
	private String member_id = "";
	
	private List<String> expert_member_ids;
	private List<String> to_mail;
	
	
	
	
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getReception_status() {
		return reception_status;
	}
	public void setReception_status(String reception_status) {
		this.reception_status = reception_status;
	}
	public List<String> getExpert_member_ids() {
		return expert_member_ids;
	}
	public void setExpert_member_ids(List<String> expert_member_ids) {
		this.expert_member_ids = expert_member_ids;
	}
	public int getReception_id() {
		return reception_id;
	}
	public void setReception_id(int reception_id) {
		this.reception_id = reception_id;
	}
	public List<String> getTo_mail() {
		return to_mail;
	}
	public void setTo_mail(List<String> to_mail) {
		this.to_mail = to_mail;
	}
	public int getMail_sms_id() {
		return mail_sms_id;
	}
	public void setMail_sms_id(int mail_sms_id) {
		this.mail_sms_id = mail_sms_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
