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

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import com.anchordata.webframework.base.util.DataMap;


public class ListTag extends TagSupport {

	private static final long serialVersionUID = 670666709335726929L;

	private String tag;
	
	private List<DataMap> list;
	
	private String selected;
	
	private String id;
	
	private String name;
		
	private String width;
	
	private String prprtyKey;
	
	private String prprtyVal;
	
	
	protected String selectStart 	= "<select id=\"{0}\" name=\"{1}\" style=\"width:{2}\">\n"; 
	protected String selectOption 	= "\t<option value=\"{0}\" {1}>{2}</option>\n"; 
	protected String selectClose 	= "</select>"; 
	
	protected String checkRadio		= "<div class=\"mulity-check-radio\">\n";
	protected String radios 		= "<div><p class=\"radio-type01\"><input type=\"radio\" 	id=\"{0}\" name=\"{1}\" value=\"{2}\" {3}><label for=\"{0}\"><span></span>{4}</label></p></div>\n";
	
	
	protected String switchStart	= "<div class=\"mulity-label-radio\">\n";
	protected String switc			= "<div><p class=\"label-radio\"> <input type=\"radio\" 	id=\"{0}\" name=\"{1}\" value=\"{2}\" {3}><label for=\"{0}\">{4}</label></p></div>";
	protected String checkbox 		= "<div><p class=\"check-type01\"><input type=\"checkbox\" 	id=\"{0}\" name=\"{1}\" value=\"{2}\" {3}><label for=\"{0}\"><span></span>{4}</label></p></div>";
	protected String display 		= "<span>{0}</span>"; 
	
	protected String commClose		= "</div>";
	
	public int doEndTag() throws JspException {
		try {
			JspWriter out = pageContext.getOut();
			StringBuilder contents = new StringBuilder();
			if ("select".equals(tag)) {
				contents.append(MessageFormat.format(selectStart, new Object[] { id, name, width }));
			} else if ("radio".equals(tag) || "checkbox".equals(tag)) {
				contents.append(checkRadio);
			} else if ("swich".equals(tag)) {
				contents.append(switchStart);
			}
			
			String key 	= null;
			String isSelect =  null;
			int idx = 1;
			for (DataMap code : list) {
				key = code.getString(prprtyKey);
					
				switch (tag) {
					case "select":
					case "options":
						isSelect = selected.equals(key) ? "selected" : "";
						contents.append(MessageFormat.format(selectOption, new Object[] {key , isSelect, code.getString(prprtyVal) }));						
						break;
					case "radio":
						isSelect = selected.equals(key) ? "checked" : "";
						contents.append(MessageFormat.format(radios, new Object[] {id.concat("-") + (idx++) , name, key, isSelect, code.getString(prprtyVal) }));						
						break;
					case "switch":
						isSelect = selected.equals(key) ? "checked" : "";
						contents.append(MessageFormat.format(switc, new Object[] {id.concat("-") + (idx++) , name, key, isSelect, code.getString(prprtyVal) }));						
						break;
					case "checkbox":
						isSelect = selected.contains(key) ? "checked" : "";
						contents.append(MessageFormat.format(checkbox, new Object[] {id.concat("-") + (idx++) , name, key, isSelect, code.getString(prprtyVal) }));						
						break;
					case "display":						
						if (selected.equals(key)) {						
							contents.append(MessageFormat.format(display, new Object[] {code.getString(prprtyVal) }));
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

	public void setList(List<DataMap> list) {
		this.list = list;
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

	public void setPrprtyKey(String prprtyKey) {
		this.prprtyKey = prprtyKey;
	}

	public void setPrprtyVal(String prprtyVal) {
		this.prprtyVal = prprtyVal;
	}
	
	
}
