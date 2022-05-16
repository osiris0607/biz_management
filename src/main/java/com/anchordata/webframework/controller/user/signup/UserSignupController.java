package com.anchordata.webframework.controller.user.signup;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;

@Controller("UserSignupController")
public class UserSignupController {
	
	@Autowired
	private CommonCodeService commonCodeService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/user/fwd/signup/main")
	public ModelAndView fwdAdminLogin( Model model, ModelAndView mv) throws Exception {
		String signupInfo = (String)model.asMap().get("signupInfo");
		if ( StringUtils.isEmpty(signupInfo) == false )  {
			JSONParser p = new JSONParser();
			JSONObject obj = (JSONObject)p.parse(signupInfo);
			JSONObject extraVal = (JSONObject)p.parse(obj.get("addVar").toString());
			obj.put("nationality", extraVal.get("nationality").toString());
			obj.put("residence", extraVal.get("residence").toString());
			
			mv.addObject("signupInfo", obj);
		}
		
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		mv.addObject("commonCode", result);
		mv.setViewName("signup/main");
		return mv;
		
	}
	
//	/**
//	 * 인증 정보 입력
//	 */
//	@RequestMapping("/user/rdt/signup")
//	public ModelAndView signup(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
//		mv.setViewName("login/signup");
//		return mv;
//	}
//	
//	/**
//	 * 인증 시작
//	 */
//	@RequestMapping("/user/rdt/pcc_V3_sample_seed_v2")
//	public ModelAndView pcc_V3_sample_seed_v2(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
//		mv.setViewName("login/pcc_V3_sample_seed_v2");
//		return mv;
//	}
//	
//	
//	/**
//	 * 인증 결과
//	 */
//	@RequestMapping("/user/rdt/pcc_V3_result_seed_v2")
//	public ModelAndView pcc_V3_result_seed_v2(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
//		mv.setViewName("login/pcc_V3_result_seed_v2");
//		return mv;
//	}
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	
	@Value("${sit.bizsiren.account_id}")
	private String bizsirenAccountId;
	
	@Value("${sit.bizsiren.service_name}")
	private String bizsirenServiceName;
	
	@Value("${sit.bizsiren.request_number}")
	private String bizsirenRequestNumber;
	
	@Value("${sit.bizsiren.cert_gubun}")
	private String bizsirenCertGubun;
	
	@Value("${sit.bizsiren.user_ret_url}")
	private String bizsirenUserReturnUrl;
	
	@Value("${sit.bizsiren.expert_ret_url}")
	private String bizsirenExpertReturnUrl;
	
	
	/**
	* Bizsiren 인증 요청
	*/
	@RequestMapping("/user/api/signup/cert/bizsiren")
	public ModelAndView certBizsiren(String  extraVal, ModelAndView mv) throws Exception {
		
		//날짜 생성
        Calendar today = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String certDate = sdf.format(today.getTime());
		
//		String id       = request.getParameter("id");                               // 본인실명확인 회원사 아이디
		/*
		※ srvNo 주의사항
		submit하기 바로 직전의 요청페이지( EX : http:localhost:8080/pcc_V3_sample_seed_v2.jsp )를
		Bizsiren사이트에 등록 후 나오는 서비스번호 숫자6자리를 셋팅해주십시오(결과페이지 아님!)
		*/
//	    String srvNo    = request.getParameter("srvNo");                            // 본인실명확인 서비스번호
//	    String reqNum   = request.getParameter("reqNum");                           // 본인실명확인 요청번호 (sample 페이지와 result 페이지가  동일하지 않으면 결과페이지 복호화 시 에러)
		String exVar    = "0000000000000000";                                       // 복호화용 임시필드
//	    String retUrl   = request.getParameter("retUrl");                           // 본인실명확인 결과수신 URL
//		String certDate	= request.getParameter("certDate");                         // 본인실명확인 요청시간
//		String certGb	= request.getParameter("certGb");                           // 본인실명확인 본인확인 인증수단
//		String temp =extraVal.replace("&quot;", "\"");
//		String temp2 =temp.replace(";", "\"");
		String addVar	= extraVal.replace("&quot;", "\"");		// 본인실명확인 추가 파라메터

	    //01. 암호화 모듈 선언
		com.sci.v2.pccv2.secu.SciSecuManager seed  = new com.sci.v2.pccv2.secu.SciSecuManager();

		//02. 1차 암호화
		String encStr = "";
		String reqInfo      = bizsirenAccountId+"^"+bizsirenServiceName+"^"+bizsirenRequestNumber+"^"+certDate+"^"+bizsirenCertGubun+"^"+addVar+"^"+exVar;  // 데이터 암호화

		
		seed.setInfoPublic(bizsirenAccountId,"092405D6C99ABA968F51250A78789E9D");  //bizsiren.com > 회원사전용 로그인후 확인. 

		encStr = seed.getEncPublic(reqInfo);

		//03. 위변조 검증 값 생성
		com.sci.v2.pccv2.secu.hmac.SciHmac hmac = new com.sci.v2.pccv2.secu.hmac.SciHmac();
		String hmacMsg  = seed.getEncReq(encStr,"HMAC");

		//03. 2차 암호화
		reqInfo  = seed.getEncPublic(encStr + "^" + hmacMsg + "^" + "0000000000000000");  //2차암호화

		//04. 회원사 ID 처리를 위한 암호화
		reqInfo = seed.EncPublic(reqInfo + "^" + bizsirenAccountId + "^"  + "00000000");
		
		mv.addObject("reqInfo", reqInfo);
		mv.addObject("retUrl", bizsirenUserReturnUrl);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	* Bizsiren 인증 요청 결과 수신
	*/
	@SuppressWarnings("unchecked")
	@RequestMapping("/user/api/signup/cert/bizsiren/retUrl")
	public String certBizsirenRetUrl(HttpServletRequest request, RedirectAttributes attr) throws Exception {
		
		 // 변수 --------------------------------------------------------------------------------
	    String retInfo		= "";																// 결과정보

		String id			= "";                                                               //회원사 비즈사이렌아이디
		String name			= "";                                                               //성명
		String sex			= "";																//성별
		String birYMD		= "";																//생년월일
		String fgnGbn		= "";																//내외국인 구분값
		String scCode		= "";																//가상식별번호
	    String di			= "";																//DI
	    String ci1			= "";																//CI
	    String ci2			= "";																//CI
	    String civersion    = "";                                                               //CI Version
	    
	    String reqNum		= "";                                                               // 본인확인 요청번호
	    String result		= "";                                                               // 본인확인결과 (Y/N)
	    String certDate		= "";                                                               // 검증시간
	    String certGb		= "";                                                               // 인증수단
		String cellNo		= "";																// 핸드폰 번호
		String cellCorp		= "";																// 이동통신사
		String addVar		= "";

		//예약 필드
		String ext1			= "";
		String ext2			= "";
		String ext3			= "";
		String ext4			= "";
		String ext5			= "";

		//복화화용 변수
		String encPara		= "";
		String encMsg		= "";
		String msgChk       = "N";  
		
	    //-----------------------------------------------------------------------------------------------------------------
	    
		reqNum = bizsirenRequestNumber; //sample 페이지의 reqNum과 동일하지 않으면 결과페이지 복호화 시 에러

        // Parameter 수신 --------------------------------------------------------------------
        retInfo  = request.getParameter("retInfo").trim(); //반드시 get과 post 방식 둘 다 받을수있게 허용해놔야함.

        // 1. 암호화 모듈 (jar) Loading
        com.sci.v2.pccv2.secu.SciSecuManager sciSecuMg = new com.sci.v2.pccv2.secu.SciSecuManager();
		sciSecuMg.setInfoPublic(id,"092405D6C99ABA968F51250A78789E9D");  //bizsiren.com > 회원사전용 로그인후 확인. 

        // 3. 1차 파싱---------------------------------------------------------------
		retInfo  = sciSecuMg.getDec(retInfo, reqNum);

		// 4. 요청결과 복호화
        String[] aRetInfo1 = retInfo.split("\\^");
		encPara  = aRetInfo1[0];         //암호화된 통합 파라미터
        encMsg   = aRetInfo1[1];    //암호화된 통합 파라미터의 Hash값
		
		String encMsg2   = sciSecuMg.getMsg(encPara);
		// 5. 위/변조 검증 ---------------------------------------------------------------
        if(encMsg2.equals(encMsg)){
            msgChk="Y";
        }

		if(msgChk.equals("N")){
			System.out.println("HMAC 확인이 필요합니다.");
		}

        // 복호화 및 위/변조 검증 ---------------------------------------------------------------
		retInfo  = sciSecuMg.getDec(encPara, reqNum);
        String[] aRetInfo = retInfo.split("\\^");
		
        name		= aRetInfo[0];
		birYMD		= aRetInfo[1];
        sex			= aRetInfo[2];        
        fgnGbn		= aRetInfo[3];
        di			= aRetInfo[4];
        ci1			= aRetInfo[5];
        ci2			= aRetInfo[6];
        civersion	= aRetInfo[7];
        reqNum		= aRetInfo[8];
        result		= aRetInfo[9];
        certGb		= aRetInfo[10];
		cellNo		= aRetInfo[11];
		cellCorp	= aRetInfo[12];
        certDate	= aRetInfo[13];
		addVar		= aRetInfo[14];

		//예약 필드
		ext1		= aRetInfo[15];
		ext2		= aRetInfo[16];
		ext3		= aRetInfo[17];
		ext4		= aRetInfo[18];
		ext5		= aRetInfo[19];
		
		JSONObject obj =new JSONObject();
		obj.put("result", result);
		obj.put("step_level", "member_info_step3");
		obj.put("cellNo", cellNo);
		obj.put("addVar", addVar);
		
//		RedirectView rdtview = new RedirectView();
//		mv.addObject("signupInfo", obj);
		String returnParam = obj.toString();
		attr.addFlashAttribute("signupInfo", returnParam);
//		attr.addAttribute("signupInfo", returnParam );
		//return "/user/fwd/signup/main";
		return "redirect:/user/fwd/signup/main";
	}
}
