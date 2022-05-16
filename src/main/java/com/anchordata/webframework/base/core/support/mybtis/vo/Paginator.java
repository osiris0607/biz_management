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

public class Paginator implements Serializable {
    
	private static final long serialVersionUID = 5360250999323058478L;

	private static final int DEFAULT_SLIDERS_COUNT = 10;

    private int rows;

    private int pageNo;
 
    private int totalCnt;

    public Paginator(int pageNo, int rows, int totalCnt) {
        super();
        this.rows = rows;
        this.totalCnt = totalCnt;
        this.pageNo = computePageNo(pageNo);
    }
    
    public int getRows() {
		return rows;
	}

	public int getPageNo() {
		return pageNo;
	}

	public int getTotalCnt() {
		return totalCnt;
	}

	public boolean isFirstPage() {
        return pageNo <= 1;
    }

    public boolean isLastPage() {
        return pageNo >= getTotalPages();
    }
    
    public int getFirstPage() {
    	return 1;
    }
    
    public int getLastPage() {
    	return getTotalPages();
    }

    public int getPrePage() {
        if (isHasPrePage()) {
            return pageNo - 1;
        } else {
            return pageNo;
        }
    }
    
    public int getNextPage() {
        if (isHasNextPage()) {
            return pageNo + 1;
        } else {
            return pageNo;
        }
    }
    
    public int getRowNo() {
    	return (this.getTotalCnt() - getStartRow()) + 1;
    }

    public boolean isDisabledPage(int page) {
        return ((page < 1) || (page > getTotalPages()) || (page == this.pageNo));
    }

    public boolean isHasPrePage() {
        return (pageNo - 1 >= 1);
    }

    public boolean isHasNextPage() {
        return (pageNo + 1 <= getTotalPages());
    }

    public int getStartRow() {
        if (getRows() <= 0 || totalCnt <= 0) {
        	return 0;
        }
        return pageNo > 0 ? (pageNo - 1) * getRows() + 1 : 0;
    }

    public int getEndRow() {
        return pageNo > 0 ? Math.min(rows * pageNo, getTotalCnt()) : 0;
    }

    public int getOffset() {
        return pageNo > 0 ? (pageNo - 1) * getRows() : 0;
    }

    public int getTotalPages() {
        if (totalCnt <= 0) {
            return 0;
        }
        if (rows <= 0) {
            return 0;
        }

        int count = totalCnt / rows;
        if (totalCnt % rows > 0) {
            count++;
        }
        return count;
    }

    protected int computePageNo(int page) {
        return computePageNumber(page, rows, totalCnt);
    }

    public Integer[] getSlider() {
        return slider(DEFAULT_SLIDERS_COUNT);
    }

    public Integer[] slider(int slidersCount) {
        return generateLinkPageNumbers(getPageNo(), (int) getTotalPages(), slidersCount);
    }

    private static int computeLastPageNumber(int totalItems, int pageSize) {
        if (pageSize <= 0){
        	return 1;
        }
        int result = (int) (totalItems % pageSize == 0 ? totalItems / pageSize : totalItems / pageSize + 1);
        if (result <= 1) {
            result = 1;
        }
        return result;
    }

    private static int computePageNumber(int page, int pageSize, int totalItems) {
        if (page <= 1) {
            return 1;
        }
        if (Integer.MAX_VALUE == page || page > computeLastPageNumber(totalItems, pageSize)) { //last page
            return computeLastPageNumber(totalItems, pageSize);
        }
        return page;
    }

    private static Integer[] generateLinkPageNumbers(int currentPageNumber, int lastPageNumber, int count) {
        int avg = count / 2;

        int startPageNumber = currentPageNumber - avg;
        if (startPageNumber <= 0) {
            startPageNumber = 1;
        }

        int endPageNumber = startPageNumber + count - 1;
        if (endPageNumber > lastPageNumber) {
            endPageNumber = lastPageNumber;
        }

        if (endPageNumber - startPageNumber < count) {
            startPageNumber = endPageNumber - count;
            if (startPageNumber <= 0) {
                startPageNumber = 1;
            }
        }

        List<Integer> result = new ArrayList<Integer>();
        for (int i = startPageNumber; i <= endPageNumber; i++) {
            result.add(Integer.valueOf(i));
        }
        return result.toArray(new Integer[result.size()]);
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder();
        sb.append("Paginator");
        sb.append("{pageNo=").append(pageNo);
        sb.append(", rows=").append(rows);
        sb.append(", totalCnt=").append(totalCnt);
        sb.append('}');
        return sb.toString();
    }

}