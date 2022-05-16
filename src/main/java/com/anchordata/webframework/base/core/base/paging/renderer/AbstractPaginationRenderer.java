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

import com.anchordata.webframework.base.core.support.mybtis.vo.Paginator;


public class AbstractPaginationRenderer implements PaginationRenderer {

	protected String firstPageLabel;
	protected String previousPageLabel;
	protected String currentPageLabel;
	protected String otherPageLabel;
	protected String nextPageLabel;
	protected String lastPageLabel;

	public String renderPagination(Paginator pagenator, String path) {

		StringBuffer strBuff = new StringBuffer();
				
		if (pagenator.isFirstPage() && !pagenator.isHasPrePage()) {
			strBuff.append(MessageFormat.format(firstPageLabel, 	new Object[] { Integer.toString(pagenator.getFirstPage()) }));
			strBuff.append(MessageFormat.format(previousPageLabel, 	new Object[] { Integer.toString(pagenator.getFirstPage()) }));
		} else {
			strBuff.append(MessageFormat.format(firstPageLabel, 	new Object[] { Integer.toString(pagenator.getFirstPage()) }));
			strBuff.append(MessageFormat.format(previousPageLabel, 	new Object[] { Integer.toString(pagenator.getPrePage()) }));
		}
		
		for (int page : pagenator.getSlider()) {
			if (page == pagenator.getPageNo()) {
				strBuff.append(MessageFormat.format(currentPageLabel, 	new Object[] { Integer.toString(page) }));
			} else {
				strBuff.append(MessageFormat.format(otherPageLabel, 	new Object[] { Integer.toString(page), Integer.toString(page) }));
			}
		}

		if (pagenator.isLastPage()) {
			strBuff.append( MessageFormat.format(nextPageLabel, 	new Object[] { Integer.toString(pagenator.getLastPage()) }));
			strBuff.append( MessageFormat.format(lastPageLabel, 	new Object[] { Integer.toString(pagenator.getLastPage()) }));
		} else {
			strBuff.append(MessageFormat.format(nextPageLabel, 		new Object[] { Integer.toString(pagenator.getNextPage()) }));
			strBuff.append( MessageFormat.format(lastPageLabel, 	new Object[] { Integer.toString(pagenator.getLastPage()) }));
		}

		return strBuff.toString();
	}
}
