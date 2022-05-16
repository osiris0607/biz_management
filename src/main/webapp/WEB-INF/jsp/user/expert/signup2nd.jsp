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
		<link rel="stylesheet" type="text/css" href="/assets/user/css/style.css" />	
		<link rel="stylesheet" href="/assets/user/css/lib/jquery-ui.min.css">
		<script src="/assets/user/js/lib/jquery-3.3.1.min.js"></script>
		<script src="/assets/user/js/lib/all.min.js"></script>		
		<script src="/assets/user/js/lib/jquery.nice-select.min.js"></script>
		<script src="/assets/user/js/lib/jquery-ui.js"></script>
		<script src="/assets/common/js/common_anchordata.js"></script>
	</head>
	
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
	
<script type='text/javascript'>
	var isNewSignup = false;
	var isCheckId = false;
	var memberSeq = "";
	
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
	 	// 과하 기술 분류 대분류 Click
	 	$("#large_selector").change(function(){
		    largeSelectorChange( $(this).val());
		});
	 	// 과하 기술 분류 중분류 Click
	 	$("#middle_selector").change(function(){
		 	if ( $("#large_selector").val() == "" ) {
		 		alert("대분류를 먼저 선택하시기 바랍니다.");
		 		return;
		 	}
		    middleSelectorChange( $(this).val());
		});
	 	// 과하 기술 분류 소분류 Click
	 	$("#small_selector").change(function(){
		 	if ( $("#middle_selector").val() == "" ) {
		 		alert("중분류를 먼저 선택하시기 바랍니다.");
		 		return;
		 	}
		});

		// 인증 받은 상태만 진입 가능
		checkCertComplete();
		// 회원 소속 유형
		initDepratmentType();
		// 국가 과학 기술 분류
		initScienceCategory();
		// 4차 산업 혁명 
		init4thIndustry();
		// 기존 회원인 경우 전문가 정보를 가지고 온다.
		getExpertDetail();

		showPopup("인증 완료 되었습니다.", "인증 결과 안내");
	});

	function checkCertComplete(){
		if ( gfn_isNull('${vo}') != true ) {
			var certAuthResult = '${vo.result}';
			if ( gfn_isNull('${vo.addVar}') != true ) {
				isNewSignup = false;
				memberSeq = '${vo.addVar}';
			}
			else {
			}
		}
		else {
			showPopup("본인 인증을 먼저 하여야 합니다. 회원 가입 사이트로 이동합니다.", "인증 결과 안내");
			location.href = "/user/fwd/expert/signup1st";
		}
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

	// 국가 과학 기술 분류 
	function initScienceCategory(){
		$("#large_selector").empty();
		$("#middle_selector").empty();
		$("#small_selector").empty();
		
	    var previousName = "";
	    var str = '<option value="">대분류 선택</option>';
       	<c:forEach items="${scienceCategory}" var="code">
			if ( previousName != "${code.large}") {
				str += '<option value="${code.large}">${code.large}</option>';
				previousName =  "${code.large}";
			}
		</c:forEach>

		$("#middle_selector").append('<option value="">중분류 선택</option>');
		$("#small_selector").append('<option value="">소분류 선택</option>');

		$("#large_selector").append(str);
	}
	// 과학 기술 대분류 선택 처리
	function largeSelectorChange(category) {
		if (category != ""){
			$("#middle_selector").empty();
			var previousName = "";
			var str = '<option value="">중분류 선택</option>';
    		<c:forEach items="${scienceCategory}" var="code">
    			if ( category == "${code.large}"){
    				if ( previousName != "${code.middle}") {
    					str += '<option value="${code.middle}">${code.middle}</option>';
    					previousName =  "${code.middle}";
    				}
       			}
			</c:forEach>
			$("#middle_selector").append(str);
			
		} else {
			initScienceCategory();
		}
	}
	// 과학 기술 중분류 선택 처리
	function middleSelectorChange(category) {
		if (category != ""){
			$("#small_selector").empty();
			var previousName = "";
			var str = '<option value="">소분류 선택</option>';
    		<c:forEach items="${scienceCategory}" var="code">
    			if ( category == "${code.middle}"){
    				if ( previousName != "${code.small}") {
    					str += '<option value="${code.small}">${code.small}</option>';
    					previousName =  "${code.small}";
    				}
       			}
			</c:forEach>
			$("#small_selector").append(str);
		}
	}
	// 4차 산업 검색
	function init4thIndustry() {
		$("#4th_industry_selector").empty();

		var index = 1;
		var str = '<option value="">선택</option>';
       	<c:forEach items="${commonCode}" var="code">
			<c:if test="${code.master_id == 'M0000009'}">
				str += '<option value="${code.detail_id}">${code.name}</option>';
			</c:if>
		</c:forEach>
		$("#4th_industry_selector").append(str);
		$("#rnd_4th_selector_1").append(str);
		$("#rnd_4th_selector_2").append(str);
		$("#rnd_4th_selector_3").append(str);
	}
	// 기존 회원인 경우 전문가 정보를 가지고 온다.
	function getExpertDetail() {
		if ( isNewSignup != true ) {
			var comAjax = new ComAjax();
			comAjax.setUrl("/user/api/expert/detail");
			comAjax.addParam("member_seq", Number(memberSeq));
			comAjax.setCallback(expertDetailCB);
			comAjax.ajax();
		}
	}

	function expertDetailCB(data) {
		console.log(data);
		$("#name").val(data.result.name);
		$("#birth").val(data.result.birth.replace(/\-/gi, ""));
		var temp = data.result.mobile_phone.split("-");
		$("#mobile_phone_2").val(temp[1]);
		$("#mobile_phone_3").val(temp[2]);
		temp = data.result.email.split("@");
		$("#email1").val(temp[0]);
		$("#email2").val(temp[1]);
		$("#university").val(data.result.university);
		$("#lab_address").val(data.result.address);
		temp = data.result.phone.split("-");
		$("#phone_1").val(temp[0]);
		$("#phone_2").val(temp[1]);
		$("#phone_3").val(temp[2]);
		$("#department").val(data.result.department);
		$("#university_degree").val(data.result.university_degree);
		$("#major").val(data.result.major);
		$("#degree").val(data.result.degree).prop("selected", true);
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

	function registration(){
		if ( isCheckId == false) {
    		showPopup("이이디 중복체크를 해 주시기 바랍니다.", "회원 가입 안내");
			return;
		}

		var chkVal = ["member_id", "name", "birth", "pwd", "pwd_confirm", "mobile_phone_1", "mobile_phone_2", "mobile_phone_3", "university", 
					  "lab_address", "phone_1", "phone_2", "phone_3", "department" ];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
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
		    showPopup("비밀번호는 영문, 숫자, 특수문자(@$!%*#?&) 조합하여 8자리 이상이어야 합니다.", "회원 가입 안내");
		    return;
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
		if ( $("#security_txt_check:checked").is(":checked") == false ) {
    		showPopup("보안 서약 동의는 필수 선택입니다.", "회원 가입 안내");
    		return;
		}
		if ( $("#personal_information_check:checked").is(":checked") == false ) {
    		showPopup("개인정보 수집 및 이용 동의는 필수 선택입니다.", "회원 가입 안내");
    		return;
		}
		if ( $("input:radio[name=expert_department_type]").is(':checked') == false ) {
    		showPopup("소속기관 유형은 필수 선택입니다.", "회원 가입 안내");
    		return;
		}
		if ( $("#rnd_date_start_1").val() > $("#rnd_date_end_1").val() ) {
			showPopup("R&D 과제1의 시작일이 종료일보다 초과 할 수 없습니다.", "회원 가입 안내");
			return;
		}
		if ( $("#rnd_date_start_2").val() > $("#rnd_date_end_2").val() ) {
			showPopup("R&D 과제2의 시작일이 종료일보다 초과 할 수 없습니다.", "회원 가입 안내");
			return;
		}
		if ( $("#rnd_date_start_3").val() > $("#rnd_date_end_3").val() ) {
			showPopup("R&D 과제3의 시작일이 종료일보다 초과 할 수 없습니다.", "회원 가입 안내");
			return;
		}

		var formData = new FormData();
		// Member 정보
		formData.append("member_id", $("#member_id").val());
		formData.append("name", $("#name").val());
		formData.append("birth", $("#birth").val());
		formData.append("pwd", $("#pwd").val());
		formData.append("institution_type", $("input:radio[name=expert_department_type]:checked").val());
		temp = $("#mobile_phone_selector").val() + "-" + $("#mobile_phone_2").val() + "-" + $("#mobile_phone_3").val();
		formData.append("mobile_phone", temp);
		formData.append("email", mailAddress);
		formData.append("auth_level_expert", "Y");
		formData.append("auth_level_member", "N");
		formData.append("private_info_yn", "Y");
		formData.append("security_yn", "Y");

		// 기관 정보
		formData.append("department_type", $("input:radio[name=expert_department_type]:checked").val());
		formData.append("university", $("#university").val());
		formData.append("lab_address", $("#lab_address").val() + " " + $("#lab_address_detail").val());
		var temp = $("#phone_1").val() + "-" + $("#phone_2").val() + "-" + $("#phone_3").val();
		formData.append("lab_phone", temp);
		formData.append("department", $("#department").val());
		formData.append("position", $("#position").val());
		formData.append("university_degree", $("#university_degree").val());
		formData.append("major", $("#major").val());
		formData.append("degree", $("#degree").val());
		formData.append("university_degree_date", $("#university_degree_date").val());
		formData.append("large", $("#large_selector").val());
		formData.append("middle", $("#middle_selector").val());
		formData.append("small", $("#small_selector").val());
		formData.append("four_industry", $("#4th_industry_selector").val());
		formData.append("research", $("#research").val());
		// 논문
		formData.append("thesis_1", $("#thesis_1").val());
		formData.append("thesis_name_1", $("#thesis_name_1").val());
		formData.append("thesis_date_1", $("#thesis_date_1").val());
		if ( $("#thesis_sci_yn_1").is(':checked') == true ) {
			formData.append("thesis_sci_yn_1", "Y");
		}
		else {
			formData.append("thesis_sci_yn_1", "N");
		}
		formData.append("thesis_2", $("#thesis_2").val());
		formData.append("thesis_name_2", $("#thesis_name_2").val());
		formData.append("thesis_date_2", $("#thesis_date_2").val());
		if ( $("#thesis_sci_yn_2").is(':checked') == true ) {
			formData.append("thesis_sci_yn_2", "Y");
		}
		else {
			formData.append("thesis_sci_yn_2", "N");
		}
		formData.append("thesis_3", $("#thesis_3").val());
		formData.append("thesis_name_3", $("#thesis_name_3").val());
		formData.append("thesis_date_3", $("#thesis_date_3").val());
		if ( $("#thesis_sci_yn_3").is(':checked') == true ) {
			formData.append("thesis_sci_yn_3", "Y");
		}
		else {
			formData.append("thesis_sci_yn_3", "N");
		}
		// 지식 재산권
		formData.append("iprs_1", $("#iprs_1").val());
		formData.append("iprs_enroll_1", $("input:radio[name=license_class1]:checked").val());
		formData.append("iprs_number_1", $("#iprs_number_1").val());
		formData.append("iprs_name_1", $("#iprs_name_1").val());
		formData.append("iprs_date_1", $("#iprs_date_1").val());
		formData.append("iprs_2", $("#iprs_2").val());
		formData.append("iprs_enroll_2", $("input:radio[name=license_class2]:checked").val());
		formData.append("iprs_number_2", $("#iprs_number_2").val());
		formData.append("iprs_name_2", $("#iprs_name_2").val());
		formData.append("iprs_date_2", $("#iprs_date_2").val());
		formData.append("iprs_3", $("#iprs_3").val());
		formData.append("iprs_enroll_3", $("input:radio[name=license_class3]:checked").val());
		formData.append("iprs_number_3", $("#iprs_number_3").val());
		formData.append("iprs_name_3", $("#iprs_name_3").val());
		formData.append("iprs_date_3", $("#iprs_date_3").val());
		// 기술이전
		formData.append("tech_tran_name_1", $("#tech_tran_name_1").val());
		formData.append("tech_tran_date_1", $("#tech_tran_date_1").val());
		formData.append("tech_tran_company_1", $("#tech_tran_company_1").val());
		formData.append("tech_tran_name_2", $("#tech_tran_name_2").val());
		formData.append("tech_tran_date_2", $("#tech_tran_date_2").val());
		formData.append("tech_tran_company_2", $("#tech_tran_company_2").val());
		formData.append("tech_tran_name_3", $("#tech_tran_name_3").val());
		formData.append("tech_tran_date_3", $("#tech_tran_date_3").val());
		formData.append("tech_tran_company_3", $("#tech_tran_company_3").val());
		// RND
		formData.append("rnd_name_1", $("#rnd_name_1").val());
		formData.append("rnd_date_start_1", $("#rnd_date_start_1").val());
		formData.append("rnd_date_end_1", $("#rnd_date_end_1").val());
		formData.append("rnd_class_1", $("#rnd_class_1").val());
		formData.append("rnd_4th_industry_1", $("#rnd_4th_selector_1").val());
		formData.append("rnd_name_2", $("#rnd_name_2").val());
		formData.append("rnd_date_start_2", $("#rnd_date_start_2").val());
		formData.append("rnd_date_end_2", $("#rnd_date_end_2").val());
		formData.append("rnd_class_2", $("#rnd_class_2").val());
		formData.append("rnd_4th_industry_2", $("#rnd_4th_selector_2").val());
		formData.append("rnd_name_3", $("#rnd_name_3").val());
		formData.append("rnd_date_start_3", $("#rnd_date_start_3").val());
		formData.append("rnd_date_end_3", $("#rnd_date_end_3").val());
		formData.append("rnd_class_3", $("#rnd_class_3").val());
		formData.append("rnd_4th_industry_3", $("#rnd_4th_selector_3").val());
		
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
		        	showPopup("등록 되었습니다.");
		        	location.href = "/user/fwd/expert/signup3rd?member_id=" + $("#member_id").val() +"&name=" + $("#name").val();
		        } else {
		        	showPopup(jsonData.result_msg);
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
               $("#lab_address").val(fullRoadAddr);
               
               /* document.getElementById('signUpUserPostNo').value = data.zonecode; //5자리 새우편번호 사용
               document.getElementById('signUpUserCompanyAddress').value = fullRoadAddr;
               document.getElementById('signUpUserCompanyAddressDetail').value = data.jibunAddress; */
           }
        }).open();
	}

</script>	
	
    <body>	    
        <div id="wrap">
			<div id="skip_nav">  
				<!--a href="#nav" title="메인메뉴 바로가기">메인메뉴 바로가기</a-->
				<a href="#content" title="본문내용 바로가기">본문내용 바로가기</a>
			</div>
			<!--popup-->
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
							<p id="id_check_info" tabindex="0">입력하신 <span class="font_blue">000</span> 아이디가 중복 됩니다.<br />
							다른 아이디로 다시 입력해 주시기 바랍니다.</p>	
							<!--p tabindex="0">입력하신 <span class="font_blue">000</span> 아이디는 사용이 가능합니다.</p-->
						</div>
						
						<div class="popup_button_area_center">
							<button type="button" class="blue_btn popup_close_btn" title="확인">확인</button>
						</div>
					</div>						
				</div> 
			</div>
			<!--//아이디 중복 팝업-->

			<!--보안서약서 팝업-->
			<div class="security_popup_box">
				<div class="popup_bg"></div>
				<div class="security_popup">
					<div class="popup_titlebox clearfix">
						<h4 class="fl">기술 보안 서약 확인</h4>
						<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
					</div>					
					<div class="popup_txt_area">
						<div class="popup_txt_areabg">
						    <h5 class="mt30">기술 보안 서약서</h5>
							<p>본인은 서울기술연구원에서 주관하고 있는 『캠퍼스타운 기술매칭사업』의 기술컨설팅 및 기술연구개발 프로세스에 참여함에 따라 습득하게 된 기업의 기술 및 경영정보 등의 제반 내용을 외부에 누설하지 않을 것이며, 위 내용을 위반할 시에는 관계 법령에 따라 어떠한 처벌을 받음은 물론 어떠한 제재조치를 당하여도 이의를 제기하지 않을 것임을 서약합니다.</p>
						</div>
						<div class="clearfix">
							<div class="fr">
								<input type="checkbox" id="securitypopup_txt_check" class="fl ml10" />
								<label for="securitypopup_txt_check" class="fl mt5">동의합니다.</label>
							</div>
						</div>
						<div class="popup_button_area_center">
							<button type="button" class="blue_btn popup_close_btn" title="확인">확인</button>
						</div>
					</div>						
				</div> 
			</div>
			<!--//보안서약서 팝업-->

			<!--개인정보 수집 및 이용 동의 팝업-->
			<div class="personal_information_popup_box">
				<div class="popup_bg"></div>
				<div class="personal_information_popup">
					<div class="popup_titlebox clearfix">
						<h4 class="fl">개인정보 수집 및 이용 동의 확인</h4>
						<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
					</div>					
					<div class="popup_txt_area">
						<div class="popup_txt_areabg">
							<h5 class="mt30">개인정보 수집 및 이용 동의</h5>
							<p>서울기술연구원은 기업의 기술사업화 및 연구지원 사업 등과 관련하여 개인정보 수집 및 이용을 위해, 개인정보보호법 제15조(개인정보의 수집·이용) 및 22조(동의를 받는 방법)에 따라 정보주체의 개인정보 제공 동의를 받고자 합니다.</p>
							<h6>&lt; 개인정보 수집‧이용에 대한 동의 &gt; </h6>
							<ol>
								<li>1. 수집·이용 목적<br />
									&nbsp;&nbsp;&nbsp;&nbsp;- 서울기술연구원을 포함한 서울시 및 산하기관의 기업 기술사업화 및 연구지원 사업 등의 원활한 사업수행, 서비스 및 각종 정보 제공을 위한 정보 수집‧이용 활용
								</li>
								<li>2. 수집하려는 개인정보의 항목<br />
									&nbsp;&nbsp;&nbsp;&nbsp;- 성명, 생년월일, 과학기술인등록번호, 연락처(휴대번호, 이메일), 전문분야, 소속, 직위(직급), 최종학력, 주요 경력, 연구 이력
								</li>
								<li>3. 보유 및 이용 기간: 받은날로부터 5년</li>
								<li>4. 귀하는 개인정보 수집 및 이용 동의에 대한 거부 권리가 있으나, 개인정보 수집 및 이용에 동의하지 않을 경우 기업지원사업 등에서 제외될 수 있습니다. </li>
							</ol>

							<h6>&lt; 개인정보 제3자 제공 동의 &gt; </h6>
							<ol>
								<li>1. 제공받는자: 서울시, 기술매칭사업 신청자</li>
								<li>2. 제공받는자의 이용 목적: 기술매칭 신청 시 전문가 정보 열람</li>
								<li>3. 제공하는 개인정보 항목: 성명, 전문분야, 소속, 주요경력, 연구이력</li>
								<li>4. 제공받는자의 이용 기간: 기술매칭사업 신청기간</li>
								<li>5. 귀하는 위와 같이 개인정보를 제3자에게 제공하는 것에 대한 동의를 거부할 권리가 있습니다. 단 제3자 동의를 하지 않을 경우 기업지원사업 등에서 제외될 수 있습니다.</li>
							</ol>
						</div>
						<div class="clearfix">
							<div class="fr">
								<input type="checkbox" id="personal_information_popup_check" class="fl ml10" />
								<label for="personal_information_popup_check" class="fl mt5">동의합니다.</label>
							</div>
						</div>
						<div class="popup_button_area_center">
							<button type="button" class="blue_btn popup_close_btn" title="확인">확인</button>
						</div>
					</div>						
				</div> 
			</div>
			<!--//개인정보 수집 및 이용 동의 팝업-->
			<!--//popup-->

			<div id="container">
				<div class="content_area login_area_box">
					<a href="/" title="신기술접수소 사업평가·관리 시스템 홈페이지 이동" class="logo">
						<h1 class="home_logo"><img src="/assets/user/images/main/logo.png" alt="신기술접수소 사업평가·관리 시스템"></h1>
					</a>
				</div>
				<p class="ta_c header_logo_p">사업평가 · 관리시스템입니다.</p>
				<section id="content">
					<div id="sub_contents">
					    <div class="content_area login_box_area expert_box2">						
							<h4 class="ta_l">개인정보</h4>
							<div class="table_area">
								<table class="write fixed mb50">
									<caption>개인 정보</caption>
									<colgroup>
										<col style="width: 20%;">
										<col style="width: 80%;">
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">
												<span class="icon_box"><span class="necessary_icon">*</span>
												<label for="name">성명</label></span>
											</th>
											<td><input type="text" id="name" class="form-control w20" /></td>
										</tr>
										<tr>
											<th scope="row">
												<span class="icon_box"><span class="necessary_icon">*</span>
												<label for="birth">생년월일</label></span>
											</th>
											<td><input type="number" id="birth" class="form-control w40 ls" maxlength="8" oninput="numberMaxLength(this);" placeholder="8자리 YYYYMMDD형식으로 입력해주세요."></td>
										</tr>
										<tr>
											<th scope="row">
												<span class="icon_box"><span class="necessary_icon">*</span>
												<label for="member_id">아이디</label></span>
											</th>
											<td>
												<input type="text" id="member_id" title="아이디" class="form-control w40 fl mr5 ls" placeholder="영문,숫자 조합하여 4자리 이상">
												<button type="button" class="gray_btn2 fl mr10" title="중복확인" onclick="checkId();">중복확인</button>
											</td> 
										</tr>									  
										<tr>
											<th scope="row">
												<span class="icon_box"><span class="necessary_icon">*</span>
												<label for="pwd">비밀번호</label></span>
											</th>
											<td><input type="password" id="pwd" title="비밀번호" class="form-control w40 fl mr5 ls" placeholder="영문,숫자 조합하여 8자리 이상"></td> 										
										</tr>	
										<tr>
											<th scope="row">
												<span class="icon_box"><span class="necessary_icon">*</span>
												<label for="pwd_confirm">비밀번호 학인</label></span>
											</th>
											<td><input type="password" id="pwd_confirm" title="비밀번호 학인" class="form-control w40 fl mr5 ls" placeholder="영문,숫자 조합하여 8자리 이상"></td> 										
										</tr>	

										<tr>
											<th scope="row">
												<span class="icon_box"><span class="necessary_icon">*</span><label for="expert_tel">휴대전화</label></span>
											</th>
											<td>
												<select name="mobile_phone_1" id="mobile_phone_selector" class="w_8 fl">
													<option value="010">010</option>
												</select>
												<span style="display:block;" class="fl mc8">-</span>
												<label for="mobile_phone_2" class="hidden">전화</label>
												<input type="number" id="mobile_phone_2" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="듀대전화">
												<span style="display:block;" class="fl mc8 ls">-</span>
												<label for="mobile_phone_3" class="hidden">전화</label>
												<input type="number" id="mobile_phone_3" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="듀대전화">
											</td>
										</tr>
										<tr>
											<th scope="row">
												<span class="icon_box"><span class="necessary_icon">*</span><label for="expert_email">이메일</label></span>
											</th>
											<td>
												<input type="text" name="email" title="이메일" id="email1" class="form-control w_20 fl ls" placeholder="">
												<span class="fl ml1 mr1 pt10 mail_f">@</span>
												<label for="email2" class="hidden">이메일</label>
												<input type="text" name="email2" id="email2" title="이메일" class="form-control w_18 fl" disabled placeholder="">
												<select name="selectEmail" id="selectEmail" class="fl ml5 in_wp200 ace-select"> 
												   <option value="0">------선택------</option> 
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
									</tbody>
								</table>
							</div>
							<div class="security_box info_txt">
								<p>※ <span class="font_blue">보안 서약 확인</span> 및 <span class="font_blue">개인정보 수집 및 이용</span>에 동의하여 주세요.</p>
							</div>
							<h4 class="ta_l">보안 서약 확인</h4>	
							<div class="clearfix">
								<button type="button" class="blue_btn fl mr10 w20 security_popup_open" title="보안서약서 내용보기">보안서약서 내용보기</button>
								<input type="checkbox" id="security_txt_check" class="fl ml10" />
								<label for="security_txt_check" class="fl mt5">동의합니다.</label>
							</div>
							<h4 class="ta_l">개인정보 수집 및 이용 동의</h4>
							<div class="clearfix mt30">
								<button type="button" class="blue_btn fl mr10 w20 personal_information_popup_open" title="개인정보 수집 및 이용 동의">개인정보 수집 및 이용 동의</button>
								<input type="checkbox" id="personal_information_check" class="fl ml10" />
								<label for="personal_information_check" class="fl mt5">동의합니다.</label>
							</div>
							

							<div class="info_txt mt50">
								<p>※ 정보를 확인하신 후, 추가적으로 수정하실 사항이 있으면 수정해 주세요. <br />
								※ 수정하실 사항이 없으신 경우, <span class="font_blue">[완료]</span>버튼을 클릭하여 주세요.</p>
							</div>
							<!--기관 정보-->
							<h4 class="ta_l">기관 정보</h4>
							<div class="table_area">
								<table class="write fixed mb70">
									<caption>기관 정보</caption>
									<colgroup>
										<col style="width: 20%;">
										<col style="width: 80%;">
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>소속기관 유형</span></th>
											<td id="depratment_type">
											</td>
										</tr>
										<tr>
											<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="university">소속</label></span></th>
											<td><input type="text" id="university" class="form-control w100 fl mr5" title="소속" /></td>
										</tr>
										<tr>
											<th scope="row"><span class="icon_box">
												<span class="necessary_icon">*</span><label for="expert_company_company_address">주소</label></span>
											</th>
											<td>
												<!--span>서울시 강남구 대치동 304-4번지</span-->
												<input type="text" class="form-control w60 fl mr5" id="lab_address" title="주소">
												<label for="address" class="hidden">주소</label>
												<input type="text" class="form-control w30 fl mr5" id="lab_address_detail" title="주소">
												<button type="button" class="gray_btn2 fl" title="검색" onclick="execPostCode();">검색</button>												
											</td>
										</tr>									  
										<tr>
											<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="expert_company_company_tel">전화</label></span></th>
											<td>
												<label for="phone_1" class="hidden">전화</label>
												<input type="number" id="phone_1" maxlength="3" oninput="numberMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 정보의 전화">
												<span style="display:block;" class="fl mc8">-</span>
												<label for="phone_2" class="hidden">전화</label>
												<input type="number" id="phone_2" maxlength="4" oninput="numberMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 정보의 전화">
												<span style="display:block;" class="fl mc8 ls">-</span>
												<label for="phone_3" class="hidden">전화</label>
												<input type="number" id="phone_3" maxlength="4" oninput="numberMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 정보의 전화">
											</td>
										</tr>
										<tr>
											<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="department">부서(학과)</label></span></th>
											<td><input type="text" id="department" class="form-control w_34" title="부서(학과)"/></td> 
										</tr>									  
										<tr>
											<th scope="row"><span class="icon_box"><label for="position">직책</label></span></th>
											<td><input type="text" id="position" class="form-control w_34" title="직책"/></td> 
										</tr>																		
									</tbody>
								</table>
							</div>
							<!--//기관 정보-->

							<!--최종 학력-->
							<h4 class="ta_l">최종 학력</h4>
							<div class="table_area">
								<table class="write fixed mb70">
									<caption>최종 학력</caption>
									<colgroup>
										<col style="width: 20%;">
										<col style="width: 80%;">
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><label for="university_degree">학교명</label></th>
											<td><input type="text" id="university_degree" class="form-control w60 fl mr5"></td>
										</tr>
										<tr>
											<th scope="row"><label for="major">전공</label></th>
											<td><input type="text" id="major" class="form-control w60 fl mr5"></td>
										</tr>
										<tr>
											<th scope="row"><label for="degree">학위</label></th>
											<td>
												<select name="expert_anacademidegree" id="degree" class="w20 ace-select">					
													<option value="학사">학사</option>
													<option value="석사">석사</option>
													<option value="박사">박사</option>
												</select>
											</td>
										</tr>
										<tr>
											<th scope="row"><label for="university_degree_date">학위취득연도</label></th>
											<td>
												<input type="number" id="university_degree_date" class="form-control w20 fl mr5 ta_r ls" maxlength="4" oninput="numberMaxLength(this);" placeholder="4자리 YYYY 형식" style="padding-right: 10px;" />
												<span class="fl mt10">년</span>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<!--//최종 학력-->

							<!--기술분류 및 연구분야-->
							<h4 class="ta_l">기술분류 및 연구분야</h4>
							<div class="table_area">
								<table class="write fixed mb50">
									<caption>기술분류 및 연구분야</caption>
									<colgroup>
										<col style="width: 20%;">
										<col style="width: 80%;">
									</colgroup>
									<tbody>
										<tr>
											<th scope="row" rowspan="3">국가과학기술분류</th>
											<td>
												<label for="large_selector" class="fl mt5 mr5">대분류</label>
												<select name="MainCategory" id="large_selector" class="ace-select" style="width: 94.8%;">
												</select>
											</td>
										</tr>
										<tr>
											<td>
												<label for="middle_selector" class="fl mt5 mr5">중분류</label>
												<select name="MiddleCategory" id="middle_selector" class="ace-select" style="width: 94.8%;">
												</select>
											</td>
										</tr>
										<tr>
											<td>
												<label for="small_selector" class="fl mt5 mr5">소분류</label>
												<select name="SubClass" id="small_selector" class="ace-select" style="width: 94.8%;">
												</select>
											</td>
										</tr>
										<tr>
											<th scope="row"><label for="4th_technology">4차산업기술분류</label></th>
											<td>
												<select name="4th_technology" id="4th_industry_selector" class="w20 ace-select">
												</select>
											</td>
										</tr>
										<tr>
											<th scope="row"><label for="research_class">연구분야</label></th>
											<td>
												<textarea name="research_class" id="research" cols="30" rows="2" class="w100"></textarea>
											</td>
										</tr>										
									</tbody>
								</table>
							</div>
							<!--//기술분류 및 연구분야-->

							<!--논문/저서 -->
							<div class="clearfix">
								<div class="fl"><h4 class="ta_l">논문/저서<span class="font_red" style="font-size:16px">(대표 3개)</span></h4></div>				
							</div>							
							<div class="table_area treatise_table_box">
								<table class="list fixed treatise_table">
									<caption>논문/저서</caption>
									<colgroup>
										<col style="width: 48%;">
										<col style="width: 10%;">
										<col style="width: 14%;">
										<col style="width: 10%;">
									</colgroup>
									<thead>
										<tr>
											<th scope="col" class="first">논문/저서명</th>
											<th scope="col">학술지명</th>
											<th scope="col">발행일자</th>
											<th scope="col" class="last">SCI 여부</th>										
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="first">
												<input type="text" id="thesis_1" class="form-control w100 fl">
												<label for="thesis_1" class="hidden">논문/저서명1</label>
											</td>
											<td>
												<input type="text" id="thesis_name_1" class="form-control w100 fl">
												<label for="thesis_name_1" class="hidden">학술자명1</label>
											</td>
											<td>
												<label for="thesis_date_1" class="hidden">발행일자1</label>
												<div class="datepicker_area fl mr5">
													<input type="text" id="thesis_date_1" class="datepicker form-control w_14 mr5 ls" />
												</div>
											</td>	
											<td class="last">
												<div class="clearfix" style="margin: auto;width:50px">
													<input type="checkbox" id="thesis_sci_yn_1" class="fl ml10 mr5" /><label for="mypage_company_ceo_check1" class="fl">SCI</label>
												</div>												
											</td>
										</tr>
										<tr>
											<td class="first">
												<input type="text" id="thesis_2" class="form-control w100 fl">
												<label for="thesis_2" class="hidden">논문/저서명2</label>
											</td>
											<td>
												<input type="text" id="thesis_name_2" class="form-control w100 fl">
												<label for="thesis_name_2" class="hidden">학술자명2</label>
											</td>
											<td>
												<label for="posting_date_2" class="hidden">발행일자2</label>
												<div class="datepicker_area fl mr5">
													<input type="text" id="thesis_date_2" class="datepicker form-control w_14 mr5 ls">
												</div>
											</td>	
											<td class="last">
												<div class="clearfix" style="margin: auto;width:50px">
													<input type="checkbox" id="thesis_sci_yn_2" class="fl ml10 mr5" /><label for="mypage_company_ceo_check2" class="fl">SCI</label>
												</div>
											</td>
										</tr>
										<tr>
											<td class="first">
												<input type="text" id="thesis_3" class="form-control w100 fl">
												<label for="thesis_3" class="hidden">논문/저서명3</label>
											</td>
											<td>
												<input type="text" id="thesis_name_3" class="form-control w100 fl">
												<label for="thesis_name_3" class="hidden">학술자명3</label>
											</td>
											<td>
												<label for="posting_date_3" class="hidden">발행일자3</label>
												<div class="datepicker_area fl mr5">
													<input type="text" id="thesis_date_3" class="datepicker form-control w_14 mr5 ls">
												</div>
											</td>
											<td class="last">
												<div class="clearfix" style="margin: auto;width:50px">
													<input type="checkbox" id="thesis_sci_yn_3" class="fl ml10 mr5" /><label for="mypage_company_ceo_check3" class="fl">SCI</label>
												</div>
											</td>
										</tr>										
									</tbody>
								</table>
							</div>
							<!--//논문/저서 -->

							<!--지식 재산권 -->
							<div class="clearfix mt50">
								<div class="fl"><h4 class="ta_l">지식 재산권<span class="font_red" style="font-size:16px">(대표 3개)</span></h4></div>			
							</div>								
							<div class="table_area license_table_box">
								<table class="list fixed license_table write2">
									<caption>지식 재산권</caption>
									<colgroup>
										<col style="width: 20%;">
										<col style="width: 33%;">
										<col style="width: 20%;">
										<col style="width: 10%;">
										<col style="width: 17%;">
									</colgroup>
									<thead>
										<tr>
											<th scope="col" class="first">출원/등록</th>
											<th scope="col">특허명</th>
											<th scope="col">출원번호/등록번호</th>
											<th scope="col">출원인</th>
											<th scope="col" class="last">출원일/등록일</th>										
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="first clearfix">												
												<input type="radio" id="IPRs_enroll_1" name="license_class1" checked value="E"/>
												<label for="IPRs_license_1">출원</label>
												<input type="radio" id="IPRs_enroll_1_1" name="license_class1" value="R"/>
												<label for="IPRs_enroll_1_1">등록</label>												
											</td>
											<td>
												<input type="text" id="iprs_1" class="form-control w100 fl" />
												<label for="IPRs_1" class="hidden">특허명1</label>
											</td>
											<td>
												<input type="text" id="iprs_number_1" class="form-control w100 fl ls" />
												<label for="IPRs_number_1" class="hidden">출원번호/등록번호1</label>
											</td>	
											<td>
												<input type="text" id="iprs_name_1" class="form-control w100 fl" />
												<label for="IPRs_name_1" class="hidden">출원인1</label>											
											</td>
											<td class="last">
												<div class="datepicker_area fl mr5">
													<input type="text" id="iprs_date_1" class="datepicker form-control w_14 mr5 ls" />
												</div>
												<label for="IPRs_date_1" class="hidden">출원일/등록일1</label>											
											</td>
										</tr>
										<tr>
											<td class="first clearfix">												
												<input type="radio" id="iprs_enroll_2" name="license_class2" checked value="E"/>
												<label for="iprs_enroll_2">출원</label>
												<input type="radio" id="iprs_enroll_2_1" name="license_class2" value="R"/>
												<label for="iprs_enroll_2_1">등록</label>												
											</td>
											<td>
												<input type="text" id="iprs_2" class="form-control w100 fl" />
												<label for="iprs_2" class="hidden">특허명2</label>
											</td>
											<td>
												<input type="text" id="iprs_number_2" class="form-control w100 fl ls" />
												<label for="iprs_number_2" class="hidden">출원번호/등록번호2</label>
											</td>	
											<td>
												<input type="text" id="iprs_name_2" class="form-control w100 fl" />
												<label for="iprs_name_2" class="hidden">출원인2</label>											
											</td>
											<td class="last">
												<div class="datepicker_area fl mr5">
													<input type="text" id="iprs_date_2" class="datepicker form-control w_14 mr5 ls" />
												</div>
												<label for="iprs_date_2" class="hidden">출원일/등록일2</label>											
											</td>
										</tr>	
										<tr>
											<td class="first clearfix">												
												<input type="radio" id="iprs_enroll_3" name="license_class3" checked value="E"/>
												<label for="iprs_enroll_3">출원</label>
												<input type="radio" id="iprs_enroll_3_1" name="license_class3" value="R"/>
												<label for="iprs_enroll_3_1">등록</label>												
											</td>
											<td>
												<input type="text" id="iprs_3" class="form-control w100 fl" />
												<label for="iprs_3" class="hidden">특허명3</label>
											</td>
											<td>
												<input type="text" id="iprs_number_3" class="form-control w100 fl ls" />
												<label for="iprs_number_3" class="hidden">출원번호/등록번호3</label>
											</td>	
											<td>
												<input type="text" id="iprs_name_3" class="form-control w100 fl" />
												<label for="iprs_name_3" class="hidden">출원인3</label>											
											</td>
											<td class="last">
												<div class="datepicker_area fl mr5">
													<input type="text" id="iprs_date_3" class="datepicker form-control w_14 mr5 ls" />
												</div>
												<label for="iprs_date_3" class="hidden">출원일/등록일3</label>											
											</td>
										</tr>	
									</tbody>
								</table>
							</div>
							<!--//지식재산권 -->

							<!--기술이전-->
							<div class="clearfix mt50">
								<div class="fl"><h4 class="ta_l">기술이전<span class="font_red" style="font-size:16px">(최근 3년)</span></h4></div>
								<!--div class="fr"><button type="button" class="blue_btn2 mt20 technology_transmigrate_add" title="추가">추가</button></div-->
							</div>								
							<div class="table_area technology_transmigrate_table_box">
								<table class="list fixed technology_transmigrate_table write2">
									<caption>기술이전</caption>
									<colgroup>
										<col style="width: 50%;">
										<col style="width: 17%;">
										<col style="width: 33%;">
									</colgroup>
									<thead>
										<tr>
											<th scope="col" class="first">기술이전 기술명</th>
											<th scope="col">기술이전일</th>
											<th scope="col" class="last">기술이전기업</th>										
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="first clearfix">												
												<input type="text" id="tech_tran_name_1" class="w100" />
												<label for="tech_tran_name_1" class="hidden">기술명1</label>											
											</td>
											<td>												
												<div class="datepicker_area fl mr5">
													<input type="text" id="tech_tran_date_1" class="datepicker form-control w_14 mr5 ls" />
												</div>
												<label for="tech_tran_date_1" class="hidden">기술이전일1</label>	
											</td>											
											<td class="last">
												<input type="text" id="tech_tran_company_1" class="w100" />
												<label for="tech_tran_company_1" class="hidden">기술이전기업1</label>									
											</td>
										</tr>
										<tr>
											<td class="first clearfix">												
												<input type="text" id="tech_tran_name_2" class="w100" />
												<label for="tech_tran_name_2" class="hidden">기술명2</label>										
											</td>
											<td>												
												<div class="datepicker_area fl mr5">
													<input type="text" id="tech_tran_date_2" class="datepicker form-control w_14 mr5 ls" />
												</div>
												<label for="tech_tran_date_2" class="hidden">기술이전일2</label>	
											</td>											
											<td class="last">
												<input type="text" id="tech_tran_company_2" class="w100" />
												<label for="tech_tran_company_2" class="hidden">기술이전기업2</label>									
											</td>
										</tr>
										<tr>
											<td class="first clearfix">												
												<input type="text" id="tech_tran_name_3" class="w100" />
												<label for="tech_tran_name_3" class="hidden">기술명3</label>																	
											</td>
											<td>												
												<div class="datepicker_area fl mr5">
													<input type="text" id="tech_tran_date_3" class="datepicker form-control w_14 mr5 ls" />
												</div>
												<label for="tech_tran_date_3" class="hidden">기술이전일3</label>	
											</td>											
											<td class="last">
												<input type="text" id="tech_tran_company_3" class="w100" />
												<label for="tech_tran_company_3" class="hidden">기술이전기업3</label>									
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<!--//기술이전 -->

							<!--R&D과제 -->
							<div class="clearfix mt50">
								<div class="fl"><h4 class="ta_l">R&D과제<span class="font_red" style="font-size:16px">(최근 3년)</span></h4></div>
								<!--div class="fr"><button type="button" class="blue_btn2 mt20 rnd_add" title="추가">추가</button></div-->
							</div>								
							<div class="table_area rnd_table_box">
								<table class="list fixed rnd_table write2">
									<caption>R&D과제</caption>
									<colgroup>
										<col style="width: 30%;">
										<col style="width: 30%;">
										<col style="width: 25%;">
										<col style="width: 15%;">
									</colgroup>
									<thead>
										<tr>
											<th scope="col" class="first">과제명</th>
											<th scope="col">과제기간</th>
											<th scope="col">연구분야</th>
											<th scope="col" class="last">4차산업기술분류</th>										
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="first clearfix">	
												<label for="rnd_name_1" class="hidden">기술명1</label>			
												<input type="text" id="rnd_name_1" class="w100" />													
											</td>
											<td class="clearfix">												
												<div class="datepicker_area fl">
													<label for="rnd_date_start_1" class="hidden">기술이전일1</label>
													<input type="text" id="rnd_date_start_1" class="datepicker form-control w_12 ls" />
												</div>												
												<span class="fl ml5 mr5 mt5">~</span>
												<div class="datepicker_area fl mr5">
													<label for="rnd_date_end_1" class="hidden">기술이전일1</label>
													<input type="text" id="rnd_date_end_1" class="datepicker form-control w_12 ls" />
												</div>												
											</td>
											<td>
												<label for="rnd_class_1" class="hidden">연구분야1</label>	
												<textarea name="rnd_class_1" id="rnd_class_1" cols="30" rows="2" class="w100"></textarea>	
											</td>
											<td class="last">												
												<label for="rnd_4th_1" class="hidden">4차산업기술분류1</label>												
												<select name="rnd_4th_selector_1" id="rnd_4th_selector_1" class="w100 ace-select">
												</select>
											</td>	
										</tr>
										<tr>
											<td class="first clearfix">	
												<label for="rnd_name_2" class="hidden">기술명2</label>			
												<input type="text" id="rnd_name_2" class="w100" />													
											</td>
											<td class="clearfix">												
												<div class="datepicker_area fl">
													<label for="rnd_date_start_2" class="hidden">기술이전일2</label>
													<input type="text" id="rnd_date_start_2" class="datepicker form-control w_12 ls" />
												</div>												
												<span class="fl ml5 mr5 mt5">~</span>
												<div class="datepicker_area fl mr5">
													<label for="rnd_date_end_2" class="hidden">기술이전일2</label>
													<input type="text" id="rnd_date_end_2" class="datepicker form-control w_12 ls" />
												</div>												
											</td>
											<td>
												<label for="rnd_class_2" class="hidden">연구분야2</label>	
												<textarea name="rnd_class_2" id="rnd_class_2" cols="30" rows="2" class="w100"></textarea>	
											</td>
											<td class="last">												
												<label for="rnd_4th_selector_2" class="hidden">4차산업기술분류</label>	
												<select name="rnd_4th_selector_2" id="rnd_4th_selector_2" class="w100 ace-select">
												</select>
											</td>
										</tr>
										<tr>
											<td class="first clearfix">	
												<label for="rnd_problem_name3" class="hidden">기술명3</label>			
												<input type="text" id="rnd_name_3" class="w100" />													
											</td>
											<td class="clearfix">												
												<div class="datepicker_area fl">
													<label for="rnd_date_start_3" class="hidden">기술이전일3</label>
													<input type="text" id="rnd_date_start_3" class="datepicker form-control w_12 ls" />
												</div>												
												<span class="fl ml5 mr5 mt5">~</span>
												<div class="datepicker_area fl mr5">
													<label for="rnd_date_end_3" class="hidden">기술이전일3</label>
													<input type="text" id="rnd_date_end_3" class="datepicker form-control w_12 ls" />
												</div>												
											</td>
											<td>
												<label for="rnd_class_3" class="hidden">연구분야3</label>	
												<textarea name="rnd_class_3" id="rnd_class_3" cols="30" rows="2" class="w100"></textarea>	
											</td>
											<td class="last">												
												<label for="rnd_4th_technology3" class="hidden">4차산업기술분류</label>	
												<select name="SubClass" id="rnd_4th_selector_3" class="w100 ace-select">
												</select>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<!--//기술이전 -->
							<div class="mt30">
								<button type="button" class="w100 expert_certificationcomplate_btn mb50" title="완료" onclick="registration();">완료</button>
							</div>
						</div>
					</div>								
				</section>
			</div>
		</div>
		<script src="/assets/user/js/script.js"></script>
		<script>			
			//달력
			$(".datepicker").datepicker({  
				  showOn: "both", // 버튼과 텍스트 필드 모두 캘린더를 보여준다.
				  //buttonImage: "/application/db/jquery/images/calendar.gif", // 버튼 이미지
				  buttonText	: false, 
				  buttonImageOnly: false, // 버튼에 있는 이미지만 표시한다.
				  changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
				  changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
				  minDate: '-100y', // 현재날짜로부터 100년이전까지 년을 표시한다.
				  nextText: '다음 달', // next 아이콘의 툴팁.
				  prevText: '이전 달', // prev 아이콘의 툴팁.
				  numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
				  stepMonths: 3, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가. 
				  yearRange: 'c-100:c+10', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
				  showButtonPanel: true, // 캘린더 하단에 버튼 패널을 표시한다. ( ...으로 표시되는부분이다.) 
				  currentText: '오늘 날짜' , // 오늘 날짜로 이동하는 버튼 패널
				  closeText: '닫기',  // 닫기 버튼 패널
				  dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
				  showAnim: "slide", //애니메이션을 적용한다.  
				  showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다. 
				  dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], // 요일의 한글 형식.
				  monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] // 월의 한글 형식.
			  });
		</script>

  </body>
</html>