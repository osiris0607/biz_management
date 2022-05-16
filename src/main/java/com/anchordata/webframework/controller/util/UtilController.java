package com.anchordata.webframework.controller.util;


import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.anchordata.webframework.base.util.GabiaSmsSender;
import com.anchordata.webframework.base.util.SGISOpenAPI;
import com.anchordata.webframework.service.uploadFile.UploadFileService;
import com.anchordata.webframework.service.uploadFile.UploadFileVO;
import com.anchordata.webframework.service.util.UtilAdministrativeDistrictVO;
import com.anchordata.webframework.service.util.UtilService;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;


@Controller("UtilController")
public class UtilController {
	
	@Autowired
	private GabiaSmsSender gabiaSmsSender;
	
	@Autowired
	private UtilService utilService;
	@Autowired
	private UploadFileService uploadFileService;
	
	@Value("${anchorData.SGIS.public_key}")
	private String publicKey;
	
	@Value("${anchorData.SGIS.service_id}")
	private String serviceId;
	
	
	///////////////////////////////////////////////////////////////////////////
	// SGIS 행정구역
	///////////////////////////////////////////////////////////////////////////
	/**
	* SGIS 행정구역 등록
	*/
	@RequestMapping("/util/api/openapi/sgis/administrativeDistrict/registration")
	public ModelAndView administrativeDistrictRegistration(ModelAndView mv) throws Exception {
		// 1. Get Access Token
		String accssToeken = SGISOpenAPI.getAccessToken(publicKey, serviceId);
		// 2. Get 시도 정보 GET
		JsonArray resultJson = SGISOpenAPI.getSIDOInfo(accssToeken);
		// 3. 시도 정보 DB Insert or Update
        for (int i=0; i<resultJson.size(); i++) {
        	JsonObject jsonData = (JsonObject)resultJson.get(i);
        	UtilAdministrativeDistrictVO vo = new UtilAdministrativeDistrictVO();
         	vo.setMaster_id("D000001");
        	vo.setCode(jsonData.get("cd").getAsString());
        	vo.setAddr(jsonData.get("addr_name").getAsString());
        	vo.setAddr(jsonData.get("full_addr").getAsString());
   
        	utilService.registrationAdministrativeDistrict(vo);
        	
        }
		// 4. 시도 정보를 바탕으로 시군구 정보 GET
        for (int i=0; i<resultJson.size(); i++) {
//        	String accssToekenDetail = SGISOpenAPI.getAccessToken(publicKey, serviceId);
        	JsonObject jsonData = (JsonObject)resultJson.get(i);
        	JsonArray resultDetailJson = SGISOpenAPI.getSIDODetailInfo(accssToeken, jsonData.get("cd").getAsString());
        	
        	// 5. 시군구 정보 DB Insert or Update
            for (int j=0; j<resultDetailJson.size(); j++) {
            	JsonObject jsonDetailData = (JsonObject)resultDetailJson.get(j);
            	UtilAdministrativeDistrictVO vo = new UtilAdministrativeDistrictVO();
             	vo.setMaster_id("D000002");
             	vo.setParent_id(jsonData.get("cd").getAsString());
            	vo.setCode(jsonDetailData.get("cd").getAsString());
            	vo.setAddr(jsonDetailData.get("addr_name").getAsString());
            	vo.setAddr(jsonDetailData.get("full_addr").getAsString());
       
            	utilService.registrationAdministrativeDistrict(vo);
            }
        }
        mv.addObject( "result", "1" );
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* SGIS 행정구역 검색 ALL
	*/
	@RequestMapping("/util/api/openapi/sgis/administrativeDistrict/all")
		public ModelAndView searchAllList(ModelAndView mv) throws Exception {
		List<UtilAdministrativeDistrictVO> resList = utilService.selectAdministrativeDistrictAllList();
		mv.addObject("result", resList);
		mv.setViewName("jsonView");
		return mv;
	}
	
	///////////////////////////////////////////////////////////////////////////
	// 파일 관련
	///////////////////////////////////////////////////////////////////////////
	/**
	*  첨부파일 다운로드
	*/
	@RequestMapping(value = "/util/api/file/download/{file_id}")
	public void downloadFile (@PathVariable("file_id") String fileId, HttpSession session, HttpServletResponse response) throws Exception {
		UploadFileVO UploadFileVO = new UploadFileVO();
		UploadFileVO.setFile_id(Integer.parseInt(fileId));
		UploadFileVO = uploadFileService.selectUploadFileContent(UploadFileVO);
		
		response.setContentType("application/octet-stream"); 
		response.setContentLength(UploadFileVO.getBinary_content().length); 
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(UploadFileVO.getName(),"UTF-8")+"\";"); 
		response.setHeader("Content-Transfer-Encoding", "binary"); 
		response.getOutputStream().write(UploadFileVO.getBinary_content()); 
		response.getOutputStream().flush(); 
		response.getOutputStream().close(); 
	}
	
	
	@RequestMapping("/admin/api/reception/tech/match/emailSMS/sendSMS")
	@ResponseBody
    public boolean callSmsAuth() {
        System.out.println("호출1111");
        JsonObject param = new JsonObject();
        // POST 방식으로 호출.(GET, POST, PUT, DELETE 다 가능 합니다.)
        gabiaSmsSender.userAuth();
        System.out.println("authhhhhhhhhhhhhhhhh");
        return true;
    }
	
	
}
