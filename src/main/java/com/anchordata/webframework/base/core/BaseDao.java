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
package com.anchordata.webframework.base.core;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.anchordata.webframework.base.core.support.mybtis.vo.Order;
import com.anchordata.webframework.base.core.support.mybtis.vo.PageBounds;
import com.anchordata.webframework.base.core.support.mybtis.vo.PageList;
import com.anchordata.webframework.base.core.support.mybtis.vo.PageListData;
import com.anchordata.webframework.base.util.DataMap;

public class BaseDao {

	@Autowired
	@Qualifier("mainSqlSessionTemplate")
	private SqlSession session;
	
	/**
	 * return SqlSession
	 * 
	 * @return
	 */
	public SqlSession getSession() {
		return session;
	}
	
	/**
	 * 1건 조회
	 * 
	 * @param statement
	 * @return
	 */
	public <T> T selectOne(String statement) {
		return session.selectOne(statement);
	}
	
	/**
	 * 1건 조회
	 * 
	 * @param statement
	 * @param parameter
	 * @return
	 */
	public <T> T selectOne(String statement, Object parameter) {
		return session.selectOne(statement, parameter);
	}
	
	/**
	 * 목록 조회
	 * 
	 * @param statement
	 * @return
	 */
	public <E> List<E> selectList(String statement) {
		return session.selectList(statement);
	}
	
	/**
	 * 목록 조회
	 * 
	 * @param statement
	 * @param parameter
	 * @return
	 */
	public <E> List<E> selectList(String statement, Object parameter) {
		return session.selectList(statement, parameter);
	}
	
	/**
	 * 목록 조회
	 * 
	 * @param statement
	 * @param parameter
	 * @param rowBounds
	 * @return
	 */
	public <E> List<E> selectList(String statement, Object parameter, RowBounds rowBounds) {
		return session.selectList(statement, parameter, rowBounds);
	}
	
	/**
	 * 페이징 목록 조회
	 * 
	 * @param queryId
	 * @param param
	 * @param pageBounds
	 * @return
	 */
	public PageListData selectPageData(String queryId, Object param, PageBounds pageBounds) {
		final PageList<Object> list = (PageList<Object>) session.selectList(queryId, param, pageBounds);		
		return new PageListData(pageBounds.getKey(), list);
	}
	
	/**
	 * 페이징 목록 조회
	 * 
	 * @param queryId
	 * @param param
	 * @return
	 */
	public <E> List<E> selectPage(String queryId, Object param) {		
		int page = PageBounds.NO_PAGE;
		int lows = PageBounds.NO_ROW;
		
		if (param instanceof DataMap) {
			page = ((DataMap) param).getInt("page");
			lows = ((DataMap) param).getInt("lows");
		}
		
		return session.selectList(queryId, param, new PageBounds(page, lows));	
	}
	
	/**
	 * 페이징 목록 조회
	 * 
	 * @param queryId
	 * @param param
	 * @param order order
	 * @return
	 */
	public <E> List<E> selectPage(String queryId, Object param, Order... order) {		
		int page = PageBounds.NO_PAGE;
		int lows = PageBounds.NO_ROW;
		
		if (param instanceof DataMap) {
			page = ((DataMap) param).getInt("page");
			lows = ((DataMap) param).getInt("lows");
		}
		
		return session.selectList(queryId, param, new PageBounds(page, lows, order));	
	}
		
	/**
	 * 맵 조회
	 * 
	 * @param statement
	 * @param mapKey
	 * @return
	 */
	public <K, V> Map<K, V> selectMap(String statement, String mapKey) {
		return session.selectMap(statement, mapKey);
	}
	
	/**
	 * 맵 조회
	 * 
	 * @param statement
	 * @param parameter
	 * @param mapKey
	 * @return
	 */
	public <K, V> Map<K, V> selectMap(String statement, Object parameter, String mapKey) {
		return session.selectMap(statement, parameter, mapKey);
	}
	
	/**
	 * 맵 조회
	 * 
	 * @param statement
	 * @param parameter
	 * @param mapKey
	 * @param rowBounds
	 * @return
	 */
	public <K, V> Map<K, V> selectMap(String statement, Object parameter, String mapKey, RowBounds rowBounds) {
		return session.selectMap(statement, parameter, mapKey, rowBounds);
	}
	
	@SuppressWarnings("unchecked")
	public <E> List<E> selectPagingList(String queryId, DataMap params){ 

		String strPageIndex = params.getString("pageIndex"); 
		String strPageRow = "10"; 
		int nPageIndex = 0; 
		int nPageRow = 10;
		
		if (StringUtils.isEmpty(strPageIndex) == false) {
			nPageIndex = Integer.parseInt(strPageIndex)-1; 
		} 
		
		if (StringUtils.isEmpty(strPageRow) == false) { 
			nPageRow = Integer.parseInt(strPageRow); 
		}
		
		params.put("start", (nPageIndex * nPageRow));
		params.put("end", 10);
		
		List<Object> list = session.selectList(queryId, params);

//		List<DataMap> list = session.selectList(queryId, params);
//		if (list.size() > 0) {
//			params.put("totalCount", list.get(0).get("TOTAL_COUNT")); 
//		}
		
		return (List<E>) list; 
	}
	
	
	@SuppressWarnings("unchecked")
	public <E> List<E> selectPagingList(String queryId, DataMap params, int pageRow){ 

		String strPageIndex = params.getString("pageIndex"); 
		String strPageRow = Integer.toString(pageRow); 
		int nPageIndex = 0; 
		int nPageRow = pageRow;
		
		if (StringUtils.isEmpty(strPageIndex) == false) {
			nPageIndex = Integer.parseInt(strPageIndex)-1; 
		} 
		
		if (StringUtils.isEmpty(strPageRow) == false) { 
			nPageRow = Integer.parseInt(strPageRow); 
		}
		
		params.put("start", (nPageIndex * nPageRow));
		params.put("end", pageRow);
		
		List<Object> list = session.selectList(queryId, params);

//		List<DataMap> list = session.selectList(queryId, params);
//		if (list.size() > 0) {
//			params.put("totalCount", list.get(0).get("TOTAL_COUNT")); 
//		}
		
		return (List<E>) list; 
	}
	


	/**
	 * 등록
	 * 
	 * @param statement
	 * @return
	 */
	public int insert(String statement) {
		return session.insert(statement);
	}
	
	/**
	 * 등록
	 * 
	 * @param statement
	 * @param parameter
	 * @return
	 */
	public int insert(String statement, Object parameter) {
		return session.insert(statement, parameter);
	}
	
	/**
	 * 수정
	 * 
	 * @param statement
	 * @return
	 */
	public int update(String statement) {
		return session.update(statement);
	}
	
	/**
	 * 수정
	 * 
	 * @param statement
	 * @param parameter
	 * @return
	 */
	public int update(String statement, Object parameter) {
		return session.update(statement, parameter);
	}
	
	/**
	 * 삭제
	 * 
	 * @param statement
	 * @return
	 */
	public int delete(String statement) {
		return session.delete(statement);
	}
	
	/**
	 * 삭제
	 * 
	 * @param statement
	 * @param parameter
	 * @return
	 */
	public int delete(String statement, Object parameter) {
		return session.delete(statement, parameter);
	}
	
	/**
	 * 커밋 
	 */
	public void commit() {
		session.commit();
	}
	
	/**
	 * 커밋
	 * 
	 * @param force
	 */
	public void commit(boolean force) {
		session.commit(force);
	}
	
	/**
	 * 롤백
	 */
	public void rollback() {
		session.rollback();
	}
	
	/**
	 * 롤백
	 * 
	 * @param force
	 */
	public void rollback(boolean force) {
		session.rollback(force);
	}
	
	/**
	 * 컨넥션 반환
	 * 
	 * @return
	 */
	public Connection getConnection() {
		return session.getConnection();
	}
}
