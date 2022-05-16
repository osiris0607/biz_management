package com.anchordata.webframework.base.util;

import java.util.HashMap;

public class PaginatedArrayList {
	public static HashMap<String, Object> setPageInfo(HashMap<String, Object> reqParam, int defaultCountPerPage) { 
		int pageNo = Integer.parseInt(reqParam.get("pageNo").toString());
		int countPerPage = Integer.parseInt(reqParam.get("countPerPage").toString());
		countPerPage = countPerPage < 100 ? countPerPage : 100; //최대 100개로 제한
		int first = ((pageNo-1)*countPerPage)+1;
		int last = first+countPerPage-1; 
		reqParam.put("countPerPage", countPerPage); 
		reqParam.put("first", first); 
		reqParam.put("last", last); 
		return reqParam; 
	}
}
