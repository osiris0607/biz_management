package com.anchordata.webframework.service.commonCode;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.anchordata.webframework.base.common.Constants;
import com.anchordata.webframework.base.core.BaseDao;

@Repository("CommonCodeDao")
public class CommonCodeDao extends BaseDao {
	private String mapper	= Constants.NAMESPACE.concat("commonCode.");
		
	public List<CommonCodeVO> selectListAll() throws Exception{
		return selectList(mapper.concat("selectListAll"));
	}
	
	public List<CommonCodeVO> selectListAllDisplayYN() throws Exception{
		return selectList(mapper.concat("selectListAllDisplayYN"));
	}
	
	public List<CommonCodeVO> selectNationalScienceCategory() throws Exception{
		return selectList(mapper.concat("selectNationalScienceCategory"));
	}
	
	
	public int updateUseYN(CommonCodeVO params) throws Exception{
		return update(mapper.concat("updateUseYN"), params);
	}
	
	public int insertInfo(CommonCodeVO params) throws Exception{
		return update(mapper.concat("insertInfo"), params);
	}
	
	public CommonCodeVO selectDetailIdDescOne(CommonCodeVO params) throws Exception{
		return selectOne(mapper.concat("selectDetailIdDescOne"), params);
	}
	
}
