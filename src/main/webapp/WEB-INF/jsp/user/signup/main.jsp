<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="ie=edge" />
		<meta name="description" content="신기술접수소 사업평가관리시스템" />
		<meta name="keywords" content="신기술 접수소, 서울 신기술 사업평가관리" />
		<meta property="og:type" content="website" />
		<meta property="og:title" content="신기술접수소 사업평가관리시스템 사이트" />
		<meta property="og:url" content="" />
		<meta property="og:description" content="신기술접수소 사업평가관리시스템" />
		<title>신기술접수소 사업평가·관리 시스템</title>		
		<link rel="stylesheet" type="text/css" href="/assets/user/css/default.css" />
		<link rel="stylesheet" type="text/css" href="/assets/user/css/style.css" />
		<link rel="stylesheet" type="text/css" href="/assets/user/css/lib/tip-yellowsimple.css" />
		<script src="/assets/user/js/lib/jquery-3.3.1.min.js"></script>
		<script src="/assets/user/js/lib/all.min.js"></script>		
		<script src="/assets/user/js/lib/jquery.nice-select.min.js"></script>
		<script src="/assets/user/js/lib/jquery.poshytip.js"></script>
		<script src="/assets/common/js/common_anchordata.js"></script>
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
	</head>
	
	<script type='text/javascript'>
		var isRegistration = false;
		var nationality = "";
		var residence = "N";
		var cellNo = "";
		var isCheckId = false;
		var certAuthResult = false;

		// 한 페이지에서 모든 회원 가입이 처리되는데 전화 번호 인증을 위한 Bizsiren 연동 시 return URL 방식으로 새롭게 페이지가 호출된다.
		// 따라서 회원 가입 진행 정보를 서버로 보내고 Bizsiren Return URL 시에 진행 정보를 다시 받아서 진행 받은 상태까지의 페이지로 호출되도록 한다.
		window.onload = function () {
			// 인증 받은 상태만 진입 가능
			checkCertComplete();
		}
	
		$(document).ready(function() {
			// email Select
		 	$("#selectEmail").change(function(){
		 		if ( $("#selectEmail").val() == "1" ) {
					$("#email2").attr("disabled", false);
					$("#email2").val("");
				}
				else {
					$("#email2").attr("disabled", true);
					if ( $("#selectEmail").val() != "0" ) {
						$("#email2").val($("#selectEmail").val());
					}
					else {
						$("#email2").val("");
					}
				}
			});
			
			// 검색 Enter		
			$("#search_text").on("keydown", function(key) {
	            //키의 코드가 13번일 경우 (13번은 엔터키)
	            if (key.keyCode == 13) {
	            	searchList();
	            }
	        });

			// 회원 소속 유형
			initDepratmentType();
		});
		

		function checkCertComplete(){
			if ( '${signupInfo}' != "" ) {
   				certAuthResult = '${signupInfo.result}';
				var addVar = '${signupInfo.addVar}';

				// 핸드폰 인증을 했다는 것은 이미 약관 및 개인 정보 동의를 한 것이다.
				$('input:checkbox[id="reg_terms_yn"]').val("Y");
				$("input:checkbox[id='reg_terms_yn']").prop("checked", true);
				$('input:checkbox[id="private_info_yn"]').val("Y");
				$("input:checkbox[id='private_info_yn']").prop("checked", true);

 				nationality = '${signupInfo.nationality}';
				residence = '${signupInfo.residence}';
				cellNo = '${signupInfo.cellNo}';


				if ( residence == "Y" )
				{
					$("#main_title").text("기본 정보 (거소증 소지 외국인)");
					
				}

				var event = jQuery.Event("confirm");
				$(".step2_box button.next_btn").trigger(event);

				setTimeout(function() {
					if (certAuthResult == "Y") {
						showPopup("휴대폰 인증에 성공했습니다. 다음 단계를 진행해 주시기 바랍니다.", "인증 안내");
						var event = jQuery.Event("confirm");
						$(".step3_box button.next_btn").trigger(event); 
					}
					else {
						showPopup("휴대폰 인증에 실패했습니다. 다시 시도해 주시기 바랍니다.", "인증 안내");
					}
				}, 1000);
			} 
		}
	
		function checkNationality(param) {
			nationality = param;
		}

		function checkResidence(param) {
			residence = param;
		}

		function checkTerms() {
			if (!$('input:checkbox[id="reg_terms_yn"]').is(":checked")) {
				showPopup("이용약관 동의를 체크해주세요.", "이용 약관 안내");
				return false;
			}
			
			if (!$('input:checkbox[id="private_info_yn"]').is(":checked")) {
				showPopup("개인정보 수집 이용 동의를 체크해주세요.", "개인 정보 안내");
				return false;
			}
			$('input:checkbox[id="reg_terms_yn"]').val("Y");
			$('input:checkbox[id="private_info_yn"]').val("Y");

			// 외국인인 경우 거소증 미소지자이면 핸드폰 인증 없이 바로 정보 입력을 이동한다.	
			if ( nationality == "D0000002" && residence == "N")
			{
				var event = jQuery.Event("confirm");
				$(".step3_box button.next_btn").trigger(event); 
				$("#main_title").text("기본 정보 (거소증 미소지 외국인)");
			}
			else 
			{
				var event = jQuery.Event("confirm");
				$(".step2_box button.next_btn").trigger(event); 
			}
			
			
		}

		function checkCertification() 
		{
			// 테스트 후 원복  적용 :::  if ( certAuthResult ) {
			if ( certAuthResult ) {
				var event = jQuery.Event("confirm");
				$(".step3_box button.next_btn").trigger(event); 
			}
			else {
				showPopup("먼저 휴대폰 인증을 시행해 주시기 바랍니다.", "인증 안내");
			}
		}
		
		function certifyBizsiren() {
			if ( certAuthResult ) {
				showPopup("휴대폰 인증이 완료됐습니다. 다음 회원 가입을 진행해 주시기 바랍니다.", "인증 안내");
				return;
			}

			var params = new Object();
			params.nationality = nationality;
			params.residence = residence;
			params.checkTerms = $('input:checkbox[id="reg_terms_yn"]').val();
			params.checkPrivate = $('input:checkbox[id="private_info_yn"]').val();
			var paramsString = JSON.stringify(params)
			
			$.ajax({
			    type : "POST",
			    url : "/user/api/signup/cert/bizsiren",
			    data : {extraVal : paramsString },
			    async : false,
			    success : function(data) {
			    	requestBizsiren(data);
			    },
			    error : function(err) {
			    	alert(err);
			    }
			});
		}

		function requestBizsiren(data) {
			var PCC_window = window.open('', 'PCCV3Window', 'width=400, height=630, resizable=1, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200' );
		       
		   	// iframe형식으로 개발하시지 말아주십시오. iframe으로 개발 시 나오는 문제는 개발지원해드리지 않습니다.
	       	if(PCC_window == null){ 
				 alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
	        }

	        //창을 오픈할때 크롬 및 익스플로어 양쪽 다 테스트 하시길 바랍니다.
		    var newForm = $('<form></form>'); 
		    //set attribute (form) 
		    newForm.attr("name","reqPCCForm"); 
		    newForm.attr("method","post"); 
		    newForm.attr("action","https://pcc.siren24.com/pcc_V3/jsp/pcc_V3_j10_v2.jsp"); 
		    newForm.attr("target","PCCV3Window");

	 		// create element & set attribute (input) 
	 		newForm.append($("<input type='hidden' name='reqInfo' value = '" + data.reqInfo + "'>"));
	 		newForm.append($("<input type='hidden' name='retUrl' value='" + data.retUrl + "'>"));
	 		newForm.append($("<input type='hidden' name='verSion' value='2'>"));

	 		// append form (to body) 
	 		newForm.appendTo('body'); 

	 		// submit form 
	 		newForm.submit();
		}

		// 개인별 소속 유형를 만든다.
		function initDepratmentType(){
			$("#depratment_type").empty();

			var index = 1;
			var str = "";
	       	<c:forEach items="${commonCode}" var="code">
				<c:if test="${code.master_id == 'M0000004'}">
					str += "<input type='radio' id='expert_company_type_radio" + index + "' name='expert_department_type' value='${code.detail_id}'>";
					str += "<label for='expert_company_type_radio" + index + "'>${code.name}</label>";
				</c:if>
			</c:forEach>
			$("#depratment_type").append(str);
		}


		function checkId(){
			if ( $("#member_id").val() == null || $("#member_id").val() == "") {
				showPopup("아이디를 먼저 입력하시기 바랍니다.", "회원 가입 안내");
				return;
			}
			if ( $("#member_id").val().length < 4  ) {
				showPopup("아이디는 4자리 이상이어야 합니다.", "회원 가입 안내");
				return;
			}
			if ( $("#member_id").val().isEngNum() == false  ) {
				showPopup("아이디는 영어 숫자만 가능 합니다.", "회원 가입 안내");
				return;
			}
			
			var formData = new FormData();
			formData.append("member_id", $("#member_id").val());

			$.ajax({
			    type : "POST",
			    url : "/user/api/member/check/id",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			    	if (jsonData.result == "SUCCESS") {
			    		isCheckId = true;
			    		var str = "입력하신 <span class='font_blue'>" + $("#member_id").val() + "</span> 아이디는 사용 가능합니다.<br />";
			    		showPopup(str, "아이디 중복 안내");
			    	}
			    	else {
			    		isCheckId = false;
			    		var str = "입력하신 <span class='font_blue'>" + $("#member_id").val() + "</span> 아이디가 중복 됩니다.<br />다른 아이디로 다시 입력해 주시기 바랍니다.";
			    		showPopup(str, "아이디 중복 안내");
			    	}
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}

		function showPopup(content, title) {

			if ( gfn_isNull(title) != true ) {
				$("#popup_title").html(title);
			}
		 	$("#id_check_info").html(content);
			$('.id_check_info_popup_box, .id_check_info_popup_box .popup_bg').fadeIn(350);
		}
		
		// 주소 검색
		function execPostCode() {
			new daum.Postcode({
	            oncomplete: function(data) {
	               // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	               // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
	               // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	               var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
	               var extraRoadAddr = ''; // 도로명 조합형 주소 변수

	               // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	               // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	               if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                   extraRoadAddr += data.bname;
	               }
	               // 건물명이 있고, 공동주택일 경우 추가한다.
	               if(data.buildingName !== '' && data.apartment === 'Y'){
	                  extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	               }
	               // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	               if(extraRoadAddr !== ''){
	                   extraRoadAddr = ' (' + extraRoadAddr + ')';
	               }
	               // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
	               if(fullRoadAddr !== ''){
	                   fullRoadAddr += extraRoadAddr;
	               }

	               // 우편번호와 주소 정보를 해당 필드에 넣는다.
	               $("#zipcode").val(data.zonecode);
	               $("#address").val(fullRoadAddr);
	               
	               /* document.getElementById('signUpUserPostNo').value = data.zonecode; //5자리 새우편번호 사용
	               document.getElementById('signUpUserCompanyAddress').value = fullRoadAddr;
	               document.getElementById('signUpUserCompanyAddressDetail').value = data.jibunAddress; */
	           }
	        }).open();
		}



		function registration(){
			if ( isCheckId == false) {
	    		showPopup("이이디 중복체크를 해 주시기 바랍니다.", "회원 가입 안내");
				return;
			}

			var chkVal = ["member_id", "name", "pwd", "pwd_confirm", "mobile_phone_2", "mobile_phone_3", "address", "address_detail" ];
			for (var i = 0; i < chkVal.length; i++) 
			{
				if ($("#" + chkVal[i]).val() == "" ) {
					showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.", "회원 가입 안내");
					$("#" + chkVal[i]).focus();
					return false;
				}
			}

			if ( $("#member_id").val().length < 4  ) {
	    		showPopup("아이디는 4자리 이상이어야 합니다.", "회원 가입 안내");
				return;
			}
			if ( $("#member_id").val().isEngNum() == false  ) {
	    		showPopup("아이디는 영어 숫자만 가능 합니다.", "회원 가입 안내");
				return;
			}

			if ( $("#pwd").val() != $("#pwd_confirm").val() ) {
	    		showPopup("비밀번호와  비밀번호 확인 값이 다릅니다.", "회원 가입 안내");
				return;
			}

			var reg = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
			var txt = $("#pwd").val();
			if( !reg.test(txt) ) {
			    alert("비밀번호는 영문, 숫자, 특수문자(@$!%*#?&) 조합하여 8자리 이상이어야 합니다.");
			    return false;
			}
			
			var mailAddress;
			if ( gfn_isNull($("#email1").val()) == false && gfn_isNull($("#email2").val()) == false){
				mailAddress = $("#email1").val() + "@" + $("#email2").val();
			}
			else if (gfn_isNull($("#email1").val()) == false && $("select[name=selectEmail]").val() != "0" && $("select[name=selectEmail]").val() != "1" ) {
				mailAddress =  $("#email1").val() + "@" + $("select[name=selectEmail]").val();
			}
			else {
	    		showPopup("메일은(는) 필수입력입니다.", "회원 가입 안내");
				return;
			}
			if ( $("input:radio[name=expert_department_type]").is(':checked') == false ) {
	    		showPopup("소속기관 유형은 필수 선택입니다.", "회원 가입 안내");
	    		return;
			}
			
			var formData = new FormData();
			// Member 정보
			formData.append("member_id", $("#member_id").val());
			formData.append("name", $("#name").val());
			formData.append("pwd", $("#pwd").val());
			temp = $("#mobile_phone_selector").val() + "-" + $("#mobile_phone_2").val() + "-" + $("#mobile_phone_3").val();
			formData.append("mobile_phone", temp);
			formData.append("email", mailAddress);
			formData.append("address", $("#address").val());
			formData.append("address_detail", $("#address_detail").val());
			formData.append("auth_level_member", "Y");
			formData.append("private_info_yn", "Y");
			formData.append("reg_terms_yn", "Y");
			formData.append("nationality", nationality);
			formData.append("residence_yn", residence);

			// 기관 정보
			formData.append("institution_type", $("input:radio[name=expert_department_type]:checked").val());
			
			$.ajax({
			    type : "POST",
			    url : "/user/api/member/registration",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == "SUCCESS") {
			        	showPopup("등록 되었습니다.", "회원가입 완료");
			        	isRegistration = true;
			        } else {
			        	showPopup(jsonData.result_msg);
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}

		function confirmPopup() {
			if (isRegistration){
				$("#reg_name").text($("#name").val());
				$("#reg_member_id").html("<span>" + $("#member_id").val() + "</span>");

				$('.member_info_step1, .member_info_step2, .member_info_step3, .member_info_step4, .member_info_step5').addClass('active');
				 $('.step5_box').css('display', 'block');
				 $('.step1_box, .step2_box, .step3_box, .step4_box, .step4_box_2').css('display', 'none');
			}
		}
	</script>

	

	<body>
		<div id="wrap">
			<!-- skip_nav --> 
			<div id="skip_nav">  
				<!--a href="#nav" title="메인메뉴 바로가기">메인메뉴 바로가기</a-->
				<a href="#content" title="본문내용 바로가기">본문내용 바로가기</a>
			</div>
			<!-- //skip --> 
			
			<!--아이디 중복 팝업-->
			<div class="id_check_info_popup_box">
				<div class="popup_bg"></div>
				<div class="id_check_info_popup">
					<div class="popup_titlebox clearfix">
						<h4 class="fl" id="popup_title">아이디 중복 안내</h4>
						<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
					</div>					
					<div class="popup_txt_area">
						<div class="popup_txt_areabg">
							<p tabindex="0" id="id_check_info">입력하신 <span class="font_blue">000</span> 아이디가 중복 됩니다.<br />
							다른 아이디로 다시 입력해 주시기 바랍니다.</p>	
							<!--p tabindex="0">입력하신 <span class="font_blue">000</span> 아이디는 사용이 가능합니다.</p-->
						</div>
						<div class="popup_button_area_center">
							<button type="button" class="blue_btn popup_close_btn" onclick="confirmPopup();">확인</button>
						</div>
					</div>						
				</div> 
			</div>
			<!--//아이디 중복 팝업-->
						
			<!-- container -->
			<div id="container" class="mb50">
				<div class="content_area login_area_box">
					<a href="/" title="신기술접수소 사업평가·관리 시스템 홈페이지 이동" class="logo">
						<h1 class="home_logo"><img src="/assets/user/images/main/logo.png" alt="신기술접수소 사업평가·관리 시스템"></h1>
					</a>
				</div>
				<p class="ta_c header_logo_p">사업평가 · 관리시스템 이용자 사이트입니다.</p>
				<section id="content">
					<div id="sub_contents">
						<div class="content_area">
							<div class="member_sign_box">
								<h2>통합 회원가입</h2>
								<div class="member_sign_top_step clearfix">
									<ul>
										<li class="active member_info_step1"><span>01</span><span>회원유형 선택</span></li>
										<li class="member_info_step2"><span>02</span><span>약관동의</span></li>
										<li class="member_info_step3"><span>03</span><span>본인인증</span></li>
										<li class="member_info_step4"><span>04</span><span>정보입력</span></li>
										<li class="member_info_step5"><span>05</span><span>가입완료</span></li>
									</ul>
								</div>
							

								<div class="step1_box step_box">
									<h3 class="hidden">회원가입 유형</h3>
									<!--내국인, 외국인-->
									<ul class="txt_list clearfix foreigner_not_box">
										<li>											
											<a href="javascript:void(0);" title="내국인" class="next_btn_2step" onclick="checkNationality('D0000001');">
												<span class="check_icon"></span>
												<img src="/assets/user/images/sub/signup_step1_memberclass1.png" alt="내국인 이미지" title="내국인" />
												<span class="gray_btn2">내국인</span>
											</a>
										</li>
										<li>											
											<a href="javascript:void(0);" title="외국인" class="foreigner_box_click" onclick="checkNationality('D0000002');">
												<span class="check_icon"></span>
												<img src="/assets/user/images/sub/signup_step1_memberclass1_1.png" alt="외국인 이미지" title="외국인" />
												<span class="gray_btn2">외국인</span>
											</a>
										</li>
									</ul>
									
									<!--거소증 확인-->
									<ul class="txt_list clearfix foreigner_box">
										<li>
											<a href="javascript:void(0);" class="next_btn_2step">
												<img src="/assets/user/images/sub/signup_step2_memberclass1.png" alt="거소증 소지 외국인 이미지" title="거소증 소지 외국인" onclick="checkResidence('Y');">
												<span class="gray_btn2">거소증 소지 외국인</span>
											</a>
										</li>
										<li>
											<a href="javascript:void(0);" class="next_btn_2step">
												<img src="/assets/user/images/sub/signup_step2_memberclass1_1.png" alt="거소증 미소지 외국인 이미지" title="거소증 미소지 외국인" onclick="checkResidence('N');">
												<span class="gray_btn2">거소증 미소지 외국인</span>
											</a>
										</li>
									</ul>	
									<!--//거소증 확인-->									
									<div class="btn_box">
										<button type="button" class="gray_btn2" title="이전">이전</button>
									</div>
								</div>

								<div class="step2_box step_box">
									<!--이용약관-->
									<h3 class="hidden">회원가입 이용약관</h3>
									<h4>이용약관<span class="font_red">(필수)</span></h4>
									<div class="member_info_terms_of_service">
										<p>서울기술연구원은 신기술접수소의 업무 수행을 위하여 다음과 같이 회원 가입시 개인정보를 수집 및 이용합니다.<br />수집된 개인정보는 개인정보 보호법 제30조에 따라 정보주체의 개인정보를 보호하고 있으며 이와 관련한 세부사항은 우리 연구원 개인정보처리방침을 참고하시기 바랍니다.<br />수집한 개인정보는 정해진 목적 이외의 용도로는 이용되지 않으며 수집 목적이 변경될 경우 사전에 알리고 동의를 받을 예정입니다.</p>
										<p>개인정보의 수집 및 이용 목적(개인정보 보호법 제15조) </p>
										<p>회원가입 시 수집한 개인정보는 신기술접수소의 서비스를 제공하기 위해 다음과 같은 업무처리에 사용합니다.<br />가. 기술제안, 아이디어제안, 기술공모, 평가, 혁신기술등록 등을 전자적으로 처리하기 위한 목적으로 사용합니다.<br />나. 회원가입자, 대표자, 업무담당자의 제안사항 확인 및 사실조사를 위한 연락/통지, 처리결과 통보 등의 목적으로 개인정보를 사용합니다.</p>
										<p>개인정보의 보유 및 이용기간<br />신기술접수소의 회원 개인정보는 회원가입 이후부터 보유 및 이용하며 회원탈퇴 시 지체없이 파기 합니다.</p>
									</div>
									<div class="check_box clearfix">
										<span class="fr mt10">
											<input type="checkbox" id="reg_terms_yn" name="reg_terms_yn" value="" />
											<label for="reg_terms_yn">위 약관에 동의합니다.</label>
										</span>
									</div>
									<!--//이용약관-->	
									<!--개인정보 수집 이용 동의-->
									<h4>개인정보 수집 및 이용 동의<span class="font_red">(필수)</span></h4>
									<div class="member_info_usageagreement_service">
										<p>서울기술연구원은 신기술접수소의 원활한 업무처리를 위해 아래와 같이 최소한의 개인정보를 필수항목으로 수집하고 있습니다.</p>
										<p>수집하는 개인정보의 항목(개인정보 보호법 제15조, 제16조)<br />가. 개인회원가입인 경우 : 성명, 휴대전화, 이메일, ID<br />나. 기업회원가입인 경우 : 담당자 성명, 담당자 전화, 이메일, ID<br />※ 개인정보 수집목적이 업무적인 처리를 위함이므로 소속 회사에서 제공하는 전화번호(휴대전화번호)나, 이메일이 있을시 해당정보로 작성바랍니다.</p>
										<p>회원가입 시 수집하는 필요한 최소한의 정보 외의 개인정보 수집에 동의를 거부할 권리가 있으나 최소한의 개인정보(필수항목) 수집동의 거부 시, 신기술접수소 이용이 제한됩니다.</p>
									</div>
									<div class="check_box clearfix">
										<span class="fr mt10">
											<input type="checkbox" id="private_info_yn" name="private_info_yn" value="" />
											<label for="private_info_yn">개인정보 수집 및 이용에 동의합니다.</label>
										</span>
									</div>
									<!--//개인정보 수집 이용 동의-->
									<div class="btn_box clearfix mt20 mb20">
										<button type="button" class="gray_btn2 fl mr10 prv_btn">이전</button>
										<button type="button" class="blue_btn fl next_btn" onClick="checkTerms();">다음</button>
									</div>
								</div>
								
								<div class="step3_box step_box">
									<h3 class="hidden">휴대폰 본인인증</h3>
									<h4>휴대폰 본인인증</h4>									
									<div class="phone_certification">
										<h5>휴대폰 본인인증</h5>
										<p>본인 명의로 등록된 휴대폰으로 본인인증 해주시기 바랍니다.</p>
										<button type="button" class="blue_btn3" title="휴대폰 인증하기" id="cert_btn" onClick="certifyBizsiren();">휴대폰 인증하기</button>
										<!--button type="button" class="blue_btn3" title="휴대폰 인증하기">인증 완료</button-->
									</div>
									<div class="btn_box clearfix mt20 mb20">
										<button type="button" class="gray_btn2 fl mr10 prv_btn">이전</button>
										<button type="button" class="blue_btn fl next_btn" onClick="checkCertification();">다음</button>									
									</div>
								</div>

								<div class="step4_box step_box">
									<h3 class="hidden">기본 정보</h3>
									<h4 id="main_title">기본 정보</h4>
									<div class="table_area">
										<table class="write fixed">
										<caption>기본 정보</caption>
											<colgroup>
												<col style="width: 30%;">																		
												<col style="width: 70%;">
											</colgroup>
											<tbody>
												<tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="name">성명</label></span></th>
													<td><input type="text" class="form-control w40" id="name" title="성명"/></td>	
												</tr>									  
												<tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>소속기관 유형</span></th>
													<td id="depratment_type">
													</td>
												</tr>
												<tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="member_id">아이디</label></span></th>
													<td>
														<input type="text" class="form-control input-sm mr5 fl w40" name="member_id" id="member_id" title="아이디"/>
														<button type="button" class="gray_btn2 fl mr10 id_check_info_popup_open" title="중복확인" onclick="checkId();">중복확인</button>
														<span class="fl mt10"><span class="font_blue">영문, 숫자</span> 조합하여 <span class="font_blue">4자리 이상</span></span>
													</td>
												</tr>	
												<tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="pwd">비밀번호</label></span></th>
													<td>
														<input type="password" id="pwd" class="w40 fl mr10" title="비밀번호">
														<span class="fl mt10"><span class="font_blue">영문, 숫자, 특수문자(@$!%*#?&)</span> 조합하여 <span class="font_blue">8자리 이상</span></span>
													</td>
												</tr>	
												<tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="pwd_confirm">비밀번호 확인</label></span></th>
													<td>
														<input type="password" id="pwd_confirm" class="w40 fl mr10" title="비밀번호 확인"/>
														<span class="fl mt10"><span class="font_blue">영문, 숫자, 특수문자(@$!%*#?&)</span> 조합하여 <span class="font_blue">8자리 이상</span></span>
													</td>
												</tr>
												<tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><span><label for="mobile_phone_selector">휴대전화</label></span></th>
													<td>
													    <select name="reception_charge_tel" id="mobile_phone_selector" class="w_8 fl d_input">
															<option value="010">010</option>
														</select>
														<span style="display:block;" class="fl mc8">-</span>
														<label for="mobile_phone_2" class="hidden">전화</label>
														<input type="tel" id="mobile_phone_2" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" oninput="numberOnlyMaxLength(this);" title="휴대전화"/>
														<span style="display:block;" class="fl mc8">-</span>
														<label for="mobile_phone_3" class="hidden">전화</label>
														<input type="tel" id="mobile_phone_3" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" oninput="numberOnlyMaxLength(this);" title="휴대전화"/>
													</td>
												</tr>
												<tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="email1">이메일</label></span></th>
													<td>
														<input type="text" name="email1" id="email1" class="form-control w_20 fl" />
														<span class="fl ml1 mr1 pt10 mail_f">@</span>
														<label for="email2" class="hidden">이메일</label>
														<input type="text" name="email2" id="email2" class="form-control w_18 fl" disabled />
														<label for="email2" class="hidden">이메일</label>
														<label for="selectEmail" class="hidden">이메일 선택</label>
														<select name="selectEmail" id="selectEmail" class="fl ml5 in_wp200 ace-select"> 
														   <option value="0" selected="">------선택------</option> 
														   <option value="1">직접입력</option> 
														   <option value="naver.com">naver.com</option> 
														   <option value="hanmail.net">hanmail.net</option> 
														   <option value="hotmail.com">hotmail.com</option> 
														   <option value="nate.com">nate.com</option> 
														   <option value="yahoo.co.kr">yahoo.co.kr</option> 
														   <option value="empas.com">empas.com</option> 
														   <option value="dreamwiz.com">dreamwiz.com</option> 
														   <option value="freechal.com">freechal.com</option> 
														   <option value="lycos.co.kr">lycos.co.kr</option> 
														   <option value="korea.com">korea.com</option> 
														   <option value="gmail.com">gmail.com</option> 
														   <option value="hanmir.com">hanmir.com</option> 
														   <option value="paran.com">paran.com</option> 
														</select>
													</td>
												</tr>
												<tr>
													<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="address">주소</label></span></th>
													<td>
														<input type="text" id="address" class="form-control w60 fl mr5 d_input" title="주소" />
														<label for="address_detail" class="hidden">주소</label>
														<input type="text" id="address_detail" class="form-control w30 fl mr5 d_input" title="주소"/>		
														<button type="button" class="gray_btn2 fl d_input" title="검색" style="display: block;" onclick="execPostCode();">검색</button>
													</td>
												</tr>
											</tbody>
										</table>																										
									</div>
									<div class="btn_box clearfix mt20 mb20">
										<button type="button" class="gray_btn2 fl mr10 prv_btn">이전</button><button type="button" class="blue_btn fl" onclick="registration();">등록</button>
									</div>
								</div>


								<div class="step5_box step_box">
									<h3 class="hidden">회원가입 완료</h3>
									<div class="member_sign_end">
										<p class="member_sign_end_txt1"><span class="font_blue">회원가입</span>이 완료되었습니다!</p>
										<p class="member_sign_end_txt2">모든 회원가입절차가 완료되었습니다.<br /><span class="font_blue">로그인 후 </span>서비스 이용이 가능합니다.</p>
									</div>
								

									<div class="table_area">
										<table class="write fixed">
										<caption>회원가입 완료 정보</caption>
											<colgroup>
												<col style="width: 50%;">																		
												<col style="width: 50%;">
											</colgroup>
											<tbody>
												<tr>
													<th scope="row" class="first" ><span>성명</span></th>
													<td class="last" id="reg_name"></td>	
												</tr>									  
												<tr>
													<th scope="row" class="first"><span>아이디</span></th>
													<td class="last" id="reg_member_id">
													</td>
												</tr>											
											</tbody>
										</table>																										
									</div>
									
									<div class="btn_box clearfix mt20 mb20">
										<button type="button" class="blue_btn fl" onclick="location.href='/user/fwd/login/memberLogin'" title="로그인화면 바로가기">로그인 화면</button>
										<button type="button" class="gray_btn2 fl" onclick="location.href='/'" title="메인페이지 바로가기">메인페이지</button>
									</div>
								</div>

							</div>							
						</div>
					</div>
				</section>
			</div>
			<!-- //container -->
			<!-- footer --> 
				<div id="footer" class="main_footer">
					<footer>
						<div class="footer_area">
							<!-- footer_left --> 
							<div class="footer_left">
								<div class="footer_content">
									<div class="footer_link_area clearfix">
										<ul class="fl">
											<li>
												<a href="./tos.html" title="이용 약관">
													<span>이용 약관</span>
												</a>
											</li>
											<li>
												<a href="./privacy_policy.html" title="개인정보 처리방침">
													<span>개인정보 처리방침</span>
												</a>
											</li>
											<li>
												<a href="./roc.html" title="이메일무단 수집 거부">
													<span>이메일무단 수집 거부</span>
												</a>
											</li>
											<li>
												<a href="http://seoul-tech.com/web/intropage/intropageShow.do?page_id=e35c124aa9084e84bc8c663f9ae796cf" title="신기술 접수소 소개">
													<span>신기술 접수소 소개</span>
												</a>
											</li>
											<!--li>
												<a href="#" title="저작권 정책">
													<span>저작권 정책</span>
												</a>
											</li>
											<li>
												<a href="#" title="영상정보처리기기 운영 관리방침">
													<span>영상정보처리기기 운영 관리방침</span>
												</a>
											</li>
											<li>
												<a href="#" title="홈페이지 바로가기">
													<span>홈페이지 바로가기</span>
												</a>
											</li>
											<li>
												<a href="#" title="행정서비스 현장">
													<span>행정서비스 현장</span>
												</a>
											</li-->
										</ul>
										<label for="footer_cooperation" class="hidden">협력기관</label>
										<select id="footer_cooperation" class="selectbox fr in_wp258 ace-select" name="select" onchange="javascript:go_url(this.options[this.selectedIndex].value);">
											<option value="협력기관">협력기관</option>
											<option value="http://www.seoul-tech.com/">신기술 접수소</option>
										</select> 
									</div>
									<div class="footer_addr_area clearfix">
										<div class="footer_logo fl"><img src="/assets/user/images/main/footer_logo.png" alt="신기술접수소 사업평가·관리 시스템"></div>
										<div class="footer_addr_list fr">							
											<address>서울기술연구원(03909) | 서울특별시 마포구 매봉산로37 (상암동) DMC 산학협력연구센터 8층 | TEL. 02-6912-0941</address>
											<p>Copyright  신기술접수소 사업평가·관리 시스템 All rights reserved. </p>							
										</div>							
									</div>
								</div>
							</div>
							<!--// footer_left -->					
						</div>
					</footer>
				</div>
				<!-- //footer -->		
		</div>
		<!-- //wrap -->

		
    <script src="/assets/user/js/script.js"></script>
	</body>
</html>
