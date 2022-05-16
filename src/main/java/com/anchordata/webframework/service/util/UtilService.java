package com.anchordata.webframework.service.util;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service("UtilService")
public class UtilService {
	
	@Autowired
	private UtilDao dao;
	

	
	/**
	 * 행정구역 등록  
	 */
	@Transactional
	public int registrationAdministrativeDistrict(UtilAdministrativeDistrictVO vo) throws Exception {
		// Member Insert
		return dao.insertAdministrativeDistrict(vo);
	}
	
	/**
	 * 행정구역 all List  
	 */
	public List<UtilAdministrativeDistrictVO> selectAdministrativeDistrictAllList() throws Exception {
		List<UtilAdministrativeDistrictVO> result = dao.selectAdministrativeDistrictAllList();
		return result;
	}
	
	
	
	

}
