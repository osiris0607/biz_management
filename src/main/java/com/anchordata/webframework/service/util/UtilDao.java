package com.anchordata.webframework.service.util;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;


@Repository("UtilDao")
public class UtilDao extends BaseDao {
	private String mapper	= Constants.NAMESPACE.concat("util.");
		
	public List<UtilAdministrativeDistrictVO> selectAdministrativeDistrictAllList() throws Exception{
		return selectList(mapper.concat("selectAdministrativeDistrictAllList"));
	}
	
	public int insertAdministrativeDistrict(UtilAdministrativeDistrictVO params) throws Exception{
		return update(mapper.concat("insertAdministrativeDistrict"), params);
	}
	
	
	
	
}
