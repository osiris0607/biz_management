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
package com.anchordata.webframework.base.core.base.taglibs;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.common.web.service.CommCodeService;
import com.anchordata.webframework.base.util.DataMap;



public class CodeTag extends TagSupport {

	private static final long serialVersionUID = 670666709335726929L;

	private String tag;
	
	private String upCodeId;
	
	private String selected;
	
	private String id;
	
	private String name;
		
	private String width;
	
	private String style;	
	
	private String selectStart	= "<select id=\"{0}\" name=\"{1}\" style=\"width:{2}\">\n"; 
	private String selectOption	= "\t<option value=\"{0}\" {1}>{2}</option>\n"; 
	private String selectClose	= "</select>"; 
	
	private String checkRadio		= "<div class=\"mulity-check-radio\">\n";
	private String radios			= "<div><p class=\"radio-type01\"><input type=\"radio\" 	id=\"{0}\" name=\"{1}\" value=\"{2}\" {3}><label for=\"{0}\"><span></span>{4}</label></p></div>\n";
	
	
	private String switchStart	= "<div class=\"mulity-label-radio\">\n";
	private String switc			= "<div><p class=\"label-radio\"> <input type=\"radio\" 	id=\"{0}\" name=\"{1}\" value=\"{2}\" {3}><label for=\"{0}\">{4}</label></p></div>";
	private String checkbox		= "<div><p class=\"check-type01\"><input type=\"checkbox\" 	id=\"{0}\" name=\"{1}\" value=\"{2}\" {3}><label for=\"{0}\"><span></span>{4}</label></p></div>";
	private String display 		= "<span>{0}</span>"; 
	private String styleDisplay = "<span class=\"{1}\">{0}</span>"; 
	
	private String commClose	= "</div>";
	
	public int doEndTag() throws JspException {
		try {
			JspWriter out = pageContext.getOut();
			
			WebApplicationContext ctx = 
					RequestContextUtils.findWebApplicationContext((HttpServletRequest) pageContext.getRequest(), pageContext.getServletContext());
			
			ServletContext context = ctx.getServletContext();
			CommCodeService codeService = (CommCodeService) context.getAttribute(Constants.COMM_CODES);		
			List<DataMap> codes = codeService.getCodes(upCodeId);
			
			StringBuilder contents = new StringBuilder();
			
			
			if ("select".equals(tag)) {
				contents.append(MessageFormat.format(selectStart, new Object[] { id, name, width }));
			} else if ("radio".equals(tag) || "checkbox".equals(tag)) {
				contents.append(checkRadio);
			} else if ("swich".equals(tag)) {
				contents.append(switchStart);
			}
			
			String codeId 	= null;
			String isSelect = null;
			String color	= null;
			int idx = 1;
			for (DataMap code : codes) {
				codeId  = code.getString("codeId");
				color	= code.getString("color");
				switch (tag) {
					case "select":
					case "options":
						isSelect = selected.equals(codeId) ? "selected" : "";
						contents.append(MessageFormat.format(selectOption, new Object[] {codeId , isSelect, code.getString("codeNm") }));						
						break;
					case "radio":
						isSelect = selected.equals(codeId) ? "checked" : "";
						contents.append(MessageFormat.format(radios, new Object[] {id.concat("-") + (idx++) , name, codeId, isSelect, code.getString("codeNm") }));						
						break;
					case "switch":
						isSelect = selected.equals(codeId) ? "checked" : "";
						contents.append(MessageFormat.format(switc, new Object[] {id.concat("-") + (idx++) , name, codeId, isSelect, code.getString("codeNm") }));						
						break;
					case "checkbox":
						isSelect = selected.contains(codeId) ? "checked" : "";
						contents.append(MessageFormat.format(checkbox, new Object[] {id.concat("-") + (idx++) , name, codeId, isSelect, code.getString("codeNm") }));						
						break;
					case "display":						
						if (selected.equals(codeId)) {
							switch (style == null ? Constants.EMPTY : style){
								case "label":
									contents.append(MessageFormat.format(styleDisplay, new Object[] {code.getString("codeNm"), "label label-".concat(color) }));
									break;
								case "text":
									contents.append(MessageFormat.format(styleDisplay, new Object[] {code.getString("codeNm"), "text-".concat(color) }));
									break;
								default:
									contents.append(MessageFormat.format(display, new Object[] {code.getString("codeNm") }));
									break;
							}
							
							break;
						}												
						break;
					default:
						break;
				}
			}
			if ("select".equals(tag)) {
				contents.append(selectClose);
			} else if ("radio".equals(tag) || "checkbox".equals(tag) || "swich".equals(tag)) {
				contents.append(commClose);
			}
			
			out.println(contents.toString());
			return EVAL_PAGE;
		} catch (IOException e) {
			throw new JspException();
		}
	}


	public void setTag(String tag) {
		this.tag = tag;
	}

	public void setUpCodeId(String upCodeId) {
		this.upCodeId = upCodeId;
	}

	public void setSelected(String selected) {
		this.selected = selected;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setWidth(String width) {
		this.width = width;
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	
	
}
