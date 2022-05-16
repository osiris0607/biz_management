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

import java.text.MessageFormat;

import org.springframework.stereotype.Component;

import com.anchordata.webframework.base.core.support.mybtis.vo.Paginator;


@Component
public class DefaultPaginationRenderer extends AbstractPaginationRenderer {

	
	public DefaultPaginationRenderer() {
		firstPageLabel 		= "<a href=\"javascript:;\" data-item=\"{0}\"><img src=\"{1}/static/images/util/paging_first.png\" alt=\"첫번째 목록으로 이동\"></a>";
		previousPageLabel 	= "<a href=\"javascript:;\" data-item=\"{0}\"><img src=\"{1}/static/images/util/paging_prev.png\" alt=\"이전 목록으로 이동\"></a>";
		currentPageLabel 	= "<a href=\"javascript:;\" data-item=\"{0}\" class=\"on\">{1}</a>";
		otherPageLabel		= "<a href=\"javascript:;\" data-item=\"{0}\">{1}</a>";
		nextPageLabel 		= "<a href=\"javascript:;\" data-item=\"{0}\"><img src=\"{1}/static/images/util/paging_next.png\" alt=\"다음 목록으로 이동\"></a>";
		lastPageLabel 		= "<a href=\"javascript:;\" data-item=\"{0}\"><img src=\"{1}/static/images/util/paging_last.png\" alt=\"마지막 목록으로 이동\"></a>";
	}

	@Override
	public String renderPagination(Paginator pagenator, String path) {
		
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<div class=\"paging\">");
		if (pagenator != null) {
			if (pagenator.isFirstPage() && !pagenator.isHasPrePage()) {
				strBuff.append(MessageFormat.format(firstPageLabel, 		new Object[] { Integer.toString(pagenator.getFirstPage()), path }));
				strBuff.append(MessageFormat.format(previousPageLabel, 		new Object[] { Integer.toString(pagenator.getFirstPage()), path }));
			} else {
				strBuff.append(MessageFormat.format(firstPageLabel, 		new Object[] { Integer.toString(pagenator.getFirstPage()), path }));
				strBuff.append(MessageFormat.format(previousPageLabel, 		new Object[] { Integer.toString(pagenator.getPrePage()), path }));
			}
			
			strBuff.append("<p>");
			for (int page : pagenator.getSlider()) {
				if (page == pagenator.getPageNo()) {
					strBuff.append(MessageFormat.format(currentPageLabel, 	new Object[] { Integer.toString(page), Integer.toString(page) }));
				} else {
					strBuff.append(MessageFormat.format(otherPageLabel, 	new Object[] { Integer.toString(page), Integer.toString(page) }));
				}
			}
			strBuff.append("</p>");
			
			if (pagenator.isLastPage()) {
				strBuff.append(MessageFormat.format(nextPageLabel, 			new Object[] { Integer.toString(pagenator.getLastPage()), path }));
				strBuff.append(MessageFormat.format(lastPageLabel, 			new Object[] { Integer.toString(pagenator.getLastPage()), path }));
			} else {
				strBuff.append(MessageFormat.format(nextPageLabel, 			new Object[] { Integer.toString(pagenator.getNextPage()), path }));
				strBuff.append(MessageFormat.format(lastPageLabel, 			new Object[] { Integer.toString(pagenator.getLastPage()), path }));
			}
		}
		strBuff.append("</div>");
		return strBuff.toString();
	}
	
}