package com.anchordata.webframework.controller.user.expert;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.anchordata.webframework.service.commonCode.CommonCodeService;
import com.anchordata.webframework.service.commonCode.CommonCodeVO;
import com.anchordata.webframework.service.member.ExpertService;
import com.anchordata.webframework.service.member.ExpertVO;
import com.anchordata.webframework.service.member.MemberSearchVO;
import com.anchordata.webframework.service.member.MemberService;
import com.anchordata.webframework.service.member.MemberVO;



@Controller("UserExpertController")
public class UserExpertController {
	
	
	@Autowired
	private CommonCodeService commonCodeService;
	@Autowired
	private MemberService memberService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/user/fwd/expert/signup1st")
	public ModelAndView userExpertSignup(Model model, ModelAndView mv) throws Exception {
		// 전화번호 인증 후 redirection 에서 들어오는 Parameter 정보 처리
		String signupInfo = (String)model.asMap().get("vo");
		if ( StringUtils.isEmpty(signupInfo) == false )  {
			JSONParser p = new JSONParser();
			JSONObject obj = (JSONObject)p.parse(signupInfo);
			obj.put("result", obj.get("result").toString());
			mv.addObject("vo", obj);
		}
		
		mv.setViewName("expert/signup1st");
		return mv;
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/user/fwd/expert/signup2nd")
	public ModelAndView userExpertSignup2nd(Model model, ModelAndView mv) throws Exception {
		// 전화번호 인증 후 redirection 에서 들어오는 Parameter 정보 처리
		String signupInfo = (String)model.asMap().get("vo");
		if ( StringUtils.isEmpty(signupInfo) == false )  {
			JSONParser p = new JSONParser();
			JSONObject obj = (JSONObject)p.parse(signupInfo);
			obj.put("result", obj.get("result").toString());
			obj.put("member_seq", obj.get("addVar").toString());
			mv.addObject("vo", obj);
		}
		
		List<CommonCodeVO> result = commonCodeService.selectListAllDisplayYN();
		List<CommonCodeVO> scienceCategory = commonCodeService.selectNationalScienceCategory();
		
		mv.addObject("commonCode", result);
		mv.addObject("scienceCategory", scienceCategory);
		mv.setViewName("expert/signup2nd");
		return mv;
	}
	
	
	@RequestMapping("/user/fwd/expert/signup3rd")
	public ModelAndView userExpertSignup3rd(@ModelAttribute ExpertVO vo, ModelAndView mv) throws Exception {
		mv.addObject("vo", vo);
		mv.setViewName("expert/signup3rd");
		return mv;
	}
	
	
	///////////////////////////////////////////////////////////////////////////
	// OPEN API 호출
	///////////////////////////////////////////////////////////////////////////
	
	@Autowired
	private ExpertService expertService;
	
	/**
	* All List
	*/
	@RequestMapping("/user/api/expert/search/all")
	public ModelAndView allSearchList(@ModelAttribute ExpertVO vo, ModelAndView mv) throws Exception {
		List<ExpertVO> resList = expertService.searchAllList(vo);
		mv.addObject("result", resList);
		mv.setViewName("jsonView");
		return mv;
	}
	/**
	* 상세 정보
	*/
	@RequestMapping("/user/api/expert/detail")
	public ModelAndView detail(@ModelAttribute ExpertVO vo, ModelAndView mv) throws Exception {
		ExpertVO result = expertService.detail(vo);
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	/**
	* Paging List. 
	* ExpertVO는 기존 전문가 데이터를 이전하기 위해서 만든 것이다. 
	* 실제 MemberVO 데이터를 Return 한다.
	*/
	@RequestMapping("/user/api/expert/search/paging")
		public ModelAndView search(@ModelAttribute MemberSearchVO vo, ModelAndView mv) throws Exception {
		List<MemberVO> resList = memberService.searchExpertPagingList(vo);
		if (resList.size() > 0) {
			mv.addObject("result", true);
			mv.addObject("result_data", resList);
			mv.addObject("totalCount", resList.get(0).getTotal_count());
		} else {
			mv.addObject("result", false);
			mv.addObject("result_msg", "전문가 검색 데이터가 없습니다.");
			mv.addObject("totalCount", 0);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	@Value("${sit.bizsiren.account_id}")
	private String bizsirenAccountId;
	
	@Value("${sit.bizsiren.service_name}")
	private String bizsirenServiceName;
	
	@Value("${sit.bizsiren.request_number}")
	private String bizsirenRequestNumber;
	
	@Value("${sit.bizsiren.cert_gubun}")
	private String bizsirenCertGubun;
	
	@Value("${sit.bizsiren.expert_ret_url}")
	private String bizsirenExpertReturnUrl;
	
	
	/**
	* Bizsiren 인증 요청
	*/
	@RequestMapping("/user/api/expert/cert/bizsiren")
	public ModelAndView certBizsiren(String  extraVal, ModelAndView mv) throws Exception {
		
		System.out.println("bizsirenExpertReturnUrl = " + bizsirenExpertReturnUrl);
		System.out.println("bizsirenRequestNumber = " + bizsirenRequestNumber);
		System.out.println("bizsirenServiceName = " + bizsirenServiceName);
		System.out.println("bizsirenAccountId = " + bizsirenAccountId);
		
		
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
		mv.addObject("retUrl", bizsirenExpertReturnUrl);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	* Bizsiren 인증 요청 결과 수신
	*/
	@SuppressWarnings("unchecked")
	@RequestMapping("/user/api/expert/cert/bizsiren/retUrl")
	public String certBizsirenRetUrl(HttpServletRequest request, RedirectAttributes attr) throws Exception {
		
		System.out.println("ENtER certBizsirenRetUrl !!!!!!!!!!!!!!");
		
		
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
		
		System.out.println("certBizsirenRetUrl result = " + result);
		
		JSONObject vo =new JSONObject();
		if (result.compareToIgnoreCase("Y") == 0) {
			vo.put("result", result);
			vo.put("addVar", addVar);
			String returnParam = vo.toString();
			attr.addFlashAttribute("vo", returnParam);
			
			return "redirect:/user/fwd/expert/signup2nd";
			
		}
		else {
			vo.put("result", result);
			String returnParam = vo.toString();
			attr.addFlashAttribute("vo", returnParam);
			
			return "redirect:/user/fwd/expert/signup1st";
		}
	}
	
	
}
