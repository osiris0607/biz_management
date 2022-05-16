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

import java.util.ArrayList;
import java.util.Collection;

public class PageList<E> extends ArrayList<E> {
    
	private static final long serialVersionUID = -4381556041264378758L;
	
	private Paginator paginator;

    public PageList() {}
    
	public PageList(Collection<? extends E> c) {
		super(c);
	}
	
	public PageList(Collection<? extends E> c, Paginator p) {
        super(c);
        this.paginator = p;
    }

    public PageList(Paginator p) {
        this.paginator = p;
    }

	public Paginator getPaginator() {
		return paginator;
	}
	
}
