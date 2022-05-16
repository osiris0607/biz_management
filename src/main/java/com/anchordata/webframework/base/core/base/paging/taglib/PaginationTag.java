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
package com.anchordata.webframework.base.core.base.paging.taglib;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.anchordata.webframework.base.core.base.paging.renderer.DefaultPaginationManager;
import com.anchordata.webframework.base.core.base.paging.renderer.PaginationManager;
import com.anchordata.webframework.base.core.base.paging.renderer.PaginationRenderer;
import com.anchordata.webframework.base.core.support.mybtis.vo.Paginator;


public class PaginationTag extends TagSupport {

	private static final long serialVersionUID = 1L;

	private Paginator paginator;
	
	private String type;

	public int doEndTag() throws JspException {
		try {
			JspWriter out = pageContext.getOut();
			PaginationManager paginationManager;

			// WebApplicationContext에 id 'paginationManager'로 정의된 해당 Manager를  찾는다.
			WebApplicationContext ctx = RequestContextUtils.findWebApplicationContext(
					(HttpServletRequest) pageContext.getRequest(), pageContext.getServletContext());

			String path = ctx.getServletContext().getContextPath();
			
			if (ctx.containsBean("paginationManager")) {
				paginationManager = (PaginationManager) ctx.getBean("paginationManager");
			} else {
				// bean 정의가 없다면 DefaultPaginationManager를 사용. 빈설정이 없으면 기본 적인 페이징
				// 리스트라도 보여주기 위함.
				paginationManager = new DefaultPaginationManager();
			}
			
			PaginationRenderer paginationRenderer = paginationManager.getRendererType(type);
			String contents = paginationRenderer.renderPagination(paginator, path);
			out.println(contents);
			return EVAL_PAGE;
		} catch (IOException e) {
			throw new JspException();
		}
	}

	public void setPaginator(Paginator paginator) {
		this.paginator = paginator;
	}

	public void setType(String type) {
		this.type = type;
	}

}
