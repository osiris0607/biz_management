<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

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
		<link rel="stylesheet" href="/assets/user/css/lib/jquery-ui.min.css" />
		<link rel="stylesheet" type="text/css" href="/assets/user/css/lib/tip-yellowsimple.css" />
		<script src="/assets/user/js/lib/jquery-3.3.1.min.js"></script>
		<script src="/assets/user/js/lib/all.min.js"></script>		
		<script src="/assets/user/js/lib/jquery.nice-select.min.js"></script>
		<script src="/assets/user/js/lib/jquery.poshytip.js"></script>
		<script src="/assets/user/js/lib/jquery-ui.js"></script>
		<script src="/assets/common/js/common_anchordata.js"></script>
	</head>

	<script>
		var memberInfo; 
		
		$(document).ready(function() {
			$("#logout_btn").on("click", function(){
				logout();
			});

			searchMemberDetail();
			searchInstitution();

			// 과학 기술 분류 대분류 Click
		 	$("#tech_info_large").change(function(){
			    largeSelectorChange( $(this).val());
			});
		 	// 과학 기술 분류 중분류 Click
		 	$("#tech_info_middle").change(function(){
			 	if ( $("#tech_info_large").val() == "" ) {
			 		alert("대분류를 먼저 선택하시기 바랍니다.");
			 		return;
			 	}
			    middleSelectorChange( $(this).val());
			});
		 	// 과학 기술 분류 소분류 Click
		 	$("#tech_info_small").change(function(){
			 	if ( $("#tech_info_middle").val() == "" ) {
			 		alert("중분류를 먼저 선택하시기 바랍니다.");
			 		return;
			 	}
			});
		 	// 국가 과학 기술 분류
			initScienceCategory();
			// 4차 산업 혁명 
			init4thIndustry();

			
		});

		// 국가 과학 기술 분류 
		function initScienceCategory(){
			$("#tech_info_large").empty();
			$("#tech_info_middle").empty();
			$("#tech_info_small").empty();
			
		    var previousName = "";
		    var str = '<option value="">대분류 선택</option>';
		   	<c:forEach items="${scienceCategory}" var="code">
				if ( previousName != "${code.large}") {
					str += '<option value="${code.large}">${code.large}</option>';
					previousName =  "${code.large}";
				}
			</c:forEach>

			$("#tech_info_middle").append('<option value="">중분류 선택</option>');
			$("#tech_info_small").append('<option value="">소분류 선택</option>');
			$("#tech_info_large").append(str);
		}
		// 과학 기술 대분류 선택 처리
		function largeSelectorChange(category) {
			if (category != ""){
				$("#tech_info_middle").empty();
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
				$("#tech_info_middle").append(str);
			} else {
				initScienceCategory();
			}
		}
		// 과학 기술 중분류 선택 처리
		function middleSelectorChange(category) {
			if (category != ""){
				$("#tech_info_small").empty();
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
				$("#tech_info_small").append(str);
			}
		}
		// 4차 산업 초기화
		function init4thIndustry() {
			$("#tech_info_4th_industry").empty();

			var index = 1;
			var str = '<option value="">선택</option>';
		   	<c:forEach items="${commonCode}" var="code">
				<c:if test="${code.master_id == 'M0000009'}">
					str += '<option value="${code.detail_id}">${code.name}</option>';
				</c:if>
			</c:forEach>
			$("#tech_info_4th_industry").append(str);
		}
	
		function logout() {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/logoutJson' />");
			comAjax.setCallback(mainLoginCallback);
			comAjax.ajax();
		}
	
		function mainLoginCallback(data) {
			if (data.result = "SUCCESS") {
				location.href = "/user/fwd/login/memberLogin";
			}
		}

		function searchMemberDetail() {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/member/api/mypage/detail'/>");
			comAjax.setCallback(getMemberDetailCB);
			comAjax.addParam("member_id", '${member_id}');
			comAjax.ajax();
		}
		
		function getMemberDetailCB(data){
			memberInfo = data.result;
			$("#name").html("<span>" + data.result.name + "</span>");
			var mobilePhoneList = data.result.mobile_phone.split("-");
			$("#mobile_phone").html("<span class='fl'>" + mobilePhoneList[0] +"</span> <span class='fl'>-</span><span class='fl'>" + mobilePhoneList[1] +"</span><span class='fl'>-</span><span class='fl'>" + mobilePhoneList[2] + "</span>");
			var emailList = data.result.email.split("@");
			$("#email").html("<span class='fl ls'>" + emailList[0] + "</span><span class='fl'>@</span> <span class='fl ls'>" + emailList[1] + "</span>");	
			$("#address").html("<span class='fl'>" + data.result.address +  "</span> <span class='fl ls'>" + data.result.address_detail + "</span>");
		}

		function searchInstitution() {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/member/api/mypage/institution/detail'/>");
			comAjax.setCallback(getInstitutionCB);
			comAjax.addParam("member_id", '${member_id}');
			comAjax.ajax();
		}
		
		function getInstitutionCB(data){
			// 데이터가 없으면 Return
			if ( data.result == null || data.result.reg_no == "") {
				alert("기관정보가 없습니다. 마이페이지에서 기관정보를 입력후 시도해 주시기 바랍니다.");
				history.back();
			}

			$("#institution_type").html("<span>" + data.result.type_name + "</span>");
			$("#institution_name").html("<span>" + data.result.name +" </span>");
			$("#institution_address").html("<span class='fl'>" + data.result.address +"</span> <span class='fl ls'>" + data.result.address_detail + "</span>");
			$("#institution_phone").html("<span>" + data.result.phone + "</span>");
			$("#institution_depart").html("<span>" + memberInfo.department + "</span>");
			$("#institution_position").html("<span>" + memberInfo.position + "</span>");
		}

		var isRegistration = false;
		function prepareRegistration(status) {
			var chkVal = ["bank_name", "bank_account",
				  "rnd_class",
				  "degree_01", "degree_school_01", "degree_major_01", "degree_date_01",
				  "career_company_01", "career_depart_01", "career_position_01", "join_day", "join_day1_2", "career_description_01"];

			for (var i = 0; i < chkVal.length; i++) 
			{
				if ($("#" + chkVal[i]).val() == "" ) {
					showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.", "평가위원 등록");
					$("#" + chkVal[i]).focus();
					return false;
				}
			} 
			
			if ( gfn_isNull($("#degree_certi_file_01")[0].files[0]) ) {
				showPopup("학위증명서는 필수입력입니다.", "평가위원 등록");
				return;
			}
			
			if ( gfn_isNull($("select[name=tech_info_large]").val()) ) {
				showPopup("국가과학기술분류 대분류 은(는) 필수입력입니다.", "평가위원 등록");
				return;
			}
			if ( gfn_isNull($("select[name=tech_info_middle]").val()) ) {
				showPopup("국가과학기술분류 중분류 은(는) 필수입력입니다.", "평가위원 등록");
				return;
			}
			if ( gfn_isNull($("select[name=tech_info_small]").val()) ) {
				showPopup("국가과학기술분류 소분류 은(는) 필수입력입니다.", "평가위원 등록");
				return;
			}
			if ( gfn_isNull($("select[name=tech_info_4th_industry]").val()) ) {
				showPopup("4차 산업혁명 기술분류 은(는) 필수입력입니다.", "평가위원 등록");
				return;
			}
			
			registration(status);
		}

		function registration(status){
			var formData = new FormData();
			// 기관 정보
			formData.append("member_id",'${member_id}');
			formData.append("commissioner_status", status);

			formData.append("bank_name", $("#bank_name").val());
			formData.append("bank_account", $("#bank_account").val());
			formData.append("national_skill_large", $("#tech_info_large").val() );
			formData.append("national_skill_middle", $("#tech_info_middle").val() );
			formData.append("national_skill_small", $("#tech_info_small").val() );
			formData.append("four_industry", $("#tech_info_4th_industry").val() );
			formData.append("rnd_class", $("#rnd_class").val() );

			formData.append("degree_01", $("#degree_01").val() );
			formData.append("degree_school_01", $("#degree_school_01").val() );
			formData.append("degree_major_01", $("#degree_major_01").val() );
			formData.append("degree_date_01", $("#degree_date_01").val() );
			if ( gfn_isNull($("#degree_certi_file_01")[0].files[0]) == false ) {
				formData.append("degree_certi_file_01", $("#degree_certi_file_01")[0].files[0]);
			}
			formData.append("degree_02", $("#degree_02").val() );
			formData.append("degree_school_02", $("#degree_school_02").val() );
			formData.append("degree_major_02", $("#degree_major_02").val() );
			formData.append("degree_date_02", $("#degree_date_02").val() );
			if ( gfn_isNull($("#degree_certi_file_02")[0].files[0]) == false ) {
				formData.append("degree_certi_file_02", $("#degree_certi_file_02")[0].files[0]);
			}
			
			formData.append("career_company_01", $("#career_company_01").val() );
			formData.append("career_depart_01", $("#career_depart_01").val() );
			formData.append("career_position_01", $("#career_position_01").val() );
			formData.append("career_start_date_01", $("#join_day").val() + "-" + $("#join_day1_2").val() );
			formData.append("career_retire_date_01", $("#leave_day").val() + "-" + $("#leave_day1_2").val() );
			formData.append("career_description_01", $("#career_description_01").val() );
			formData.append("career_company_02", $("#career_company_02").val() );
			formData.append("career_depart_02", $("#career_depart_02").val() );
			formData.append("career_position_02", $("#career_position_02").val() );
			if ( gfn_isNull($("#join_day2").val()) == false && gfn_isNull($("#join_day2_2").val() == false ) ) {
				formData.append("career_start_date_02", $("#join_day2").val() + "-" + $("#join_day2_2").val() );
			}
			if ( gfn_isNull($("#leave_day2").val()) == false && gfn_isNull($("#leave_day2_2").val() == false ) ) {
				formData.append("career_retire_date_02", $("#leave_day2").val() + "-" + $("#leave_day2_2").val() );
			}
			formData.append("career_description_02", $("#career_description_02").val() );
			formData.append("career_company_03", $("#career_company_03").val() );
			formData.append("career_depart_03", $("#career_depart_03").val() );
			formData.append("career_position_03", $("#career_position_03").val() );
			if ( gfn_isNull($("#join_day3").val()) == false && gfn_isNull($("#join_day3_2").val() == false ) ) {
				formData.append("career_start_date_03", $("#join_day3").val() + "-" + $("#join_day3_2").val() );
			}
			if ( gfn_isNull($("#leave_day3").val()) == false && gfn_isNull($("#leave_day3_2").val() == false ) ) {
				formData.append("career_retire_date_03", $("#leave_day3").val() + "-" + $("#leave_day3_2").val() );
			}
			formData.append("career_description_03", $("#career_description_03").val() );
			formData.append("career_company_04", $("#career_company_04").val() );
			formData.append("career_depart_04", $("#career_depart_04").val() );
			formData.append("career_position_04", $("#career_position_04").val() );
			if ( gfn_isNull($("#join_day4").val()) == false && gfn_isNull($("#join_day4_2").val() == false ) ) {
				formData.append("career_start_date_04", $("#join_day4").val() + "-" + $("#join_day4_2").val() );
			}
			if ( gfn_isNull($("#leave_day4").val()) == false && gfn_isNull($("#leave_day4_2").val() == false ) ) {
				formData.append("career_retire_date_04", $("#leave_day4").val() + "-" + $("#leave_day4_2").val() );
			}
			formData.append("career_description_04", $("#career_description_04").val() );
			if($("#thesis_sci_yn_01").is(":checked") == true) {
				formData.append("thesis_sci_yn_01", "Y" );
			} else {
				formData.append("thesis_sci_yn_01", "N" );
			}
			formData.append("thesis_title_01", $("#thesis_title_01").val() );
			formData.append("thesis_writer_01", $("#thesis_writer_01").val() );
			formData.append("thesis_journal_01", $("#thesis_journal_01").val() );
			formData.append("thesis_nationality_01", $("input[name='country_type1']:checked").val() );
			formData.append("thesis_date_01", $("#thesis_date_01").val() );
			if($("#thesis_sci_yn_02").is(":checked") == true) {
				formData.append("thesis_sci_yn_02", "Y" );
			} else {
				formData.append("thesis_sci_yn_02", "N" );
			}
			formData.append("thesis_title_02", $("#thesis_title_02").val() );
			formData.append("thesis_writer_02", $("#thesis_writer_02").val() );
			formData.append("thesis_journal_02", $("#thesis_journal_02").val() );
			formData.append("thesis_nationality_02", $("input[name='country_type2']:checked").val() );
			formData.append("thesis_date_02", $("#thesis_date_02").val() );
			if($("#thesis_sci_yn_03").is(":checked") == true) {
				formData.append("thesis_sci_yn_03", "Y" );
			} else {
				formData.append("thesis_sci_yn_03", "N" );
			}
			formData.append("thesis_title_03", $("#thesis_title_03").val() );
			formData.append("thesis_writer_03", $("#thesis_writer_03").val() );
			formData.append("thesis_journal_03", $("#thesis_journal_03").val() );
			formData.append("thesis_nationality_03", $("input[name='country_type3']:checked").val() );
			formData.append("thesis_date_03", $("#thesis_date_03").val() );

			formData.append("iprs_name_01", $("#iprs_name_01").val() );
			formData.append("iprs_enroll_01", $("input[name='license_class1']:checked").val() );
			formData.append("iprs_reg_no_01", $("#iprs_reg_no_01").val() );
			formData.append("iprs_date_01", $("#iprs_date_01").val() );
			formData.append("iprs_nationality_01", $("#iprs_nationality_01").val() );
			formData.append("iprs_writer_01", $("#iprs_writer_01").val() );
			formData.append("iprs_name_02", $("#iprs_name_02").val() );
			formData.append("iprs_enroll_02", $("input[name='license_class2']:checked").val() );
			formData.append("iprs_reg_no_02", $("#iprs_reg_no_02").val() );
			formData.append("iprs_date_02", $("#iprs_date_02").val() );
			formData.append("iprs_nationality_02", $("#iprs_nationality_02").val() );
			formData.append("iprs_writer_02", $("#iprs_writer_02").val() );
			formData.append("iprs_name_03", $("#iprs_name_03").val() );
			formData.append("iprs_enroll_03", $("input[name='license_class3']:checked").val() );
			formData.append("iprs_reg_no_03", $("#iprs_reg_no_03").val() );
			formData.append("iprs_date_03", $("#iprs_date_03").val() );
			formData.append("iprs_nationality_03", $("#iprs_nationality_03").val() );
			formData.append("iprs_writer_03", $("#iprs_writer_03").val() );

			formData.append("self_description", $("#self_description").val() );
			
			
		 	$.ajax({
			    type : "POST",
			    url : "/member/api/commissioner/registration",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == 1) {
			        	showPopup("평가위원 신청이 완료되었습니다.", "평가위원 등록");
			        	isRegistration = true;
			        } else {
			        	showPopup("평가위원 신청에 실패하였습니다. 다시 시도해 주시기 바랍니다.", "평가위원 등록");
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
		 	$("#popup_info").html(content);
			$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
		}

		function commonPopupConfirm(){

			if ( isRegistration == true) {
				location.href = "/";
			}
			
			$('.common_popup_box, .common_popup_box .popup_bg').fadeOut(350);
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
			
				
			<!--공통 팝업-->
			<div class="common_popup_box">
				<div class="popup_bg"></div>
				<div class="id_check_info_popup">
					<div class="popup_titlebox clearfix">
						<h4 class="fl" id="popup_title"></h4>
						<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
					</div>					
					<div class="popup_txt_area">
						<div class="popup_txt_areabg">
							<p id="popup_info" tabindex="0"></p>	
						</div>
						
						<div class="popup_button_area_center">
							<button type="button" class="blue_btn" title="확인" onclick="commonPopupConfirm();">확인</button>
						</div>
					</div>						
				</div> 
			</div>
			
			<!--logout 팝업-->
		   	<div class="logout_popup_box">
			   <div class="popup_bg"></div>
			   <div class="logout_popup">
			       <div class="popup_titlebox clearfix">
				       <h4 class="fl">로그 아웃</h4>
				       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">로그아웃</span></a>
				   </div>
				   <div class="popup_txt_area">
					   <p><span class="font_blue">로그아웃</span> 하시겠습니까?</p>
					   <div class="popup_button_area_center">
						   <button type="button" class="blue_btn mr5" onclick="logout();">예</button>
						   <button type="button" class="gray_btn logout_popup_close_btn popup_close_btn">아니요</button>
					   </div>
				   </div>
			   </div>
		   	</div>
			<!--logout 팝업-->

			<!--임시저장 팝업-->
			<div class="temp_storage_popup_box" style="display: none;">
				<div class="popup_bg"></div>
				<div class="temporary_storage_popup">
					<div class="popup_titlebox clearfix">
						<h4 class="fl">임시 저장 안내</h4>
						<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
					</div>					
					<div class="popup_txt_area">
						<div class="popup_txt_areabg">
							<p tabindex="0">임시 저장 되었습니다.</p>							
						</div>
						<div class="popup_button_area_center">
							<button type="button" class="blue_btn popup_close_btn">확인</button>
						</div>
					</div>						
				</div> 
			</div>
			<!--//임시저장 팝업-->

			<!--완료 팝업-->
			<div class="complate_popup_box_01" style="display: none;">
				<div class="popup_bg"></div>
				<div class="complate_popup">
					<div class="popup_titlebox clearfix">
						<h4 class="fl">등록 안내</h4>
						<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
					</div>					
					<div class="popup_txt_area">
						<div class="popup_txt_areabg">
							<p tabindex="0">등록 되었습니다.</p>							
						</div>
						<div class="popup_button_area_center clearfix">							
							<button type="button" class="gray_btn popup_close_btn fl">확인</button>
						</div>
					</div>						
				</div> 
			</div>
			<!--완료 팝업-->
						
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
							<div class="member_sign_box agreement_sign_box">
								<h2>평가위원 등록</h2>
								<!--정보수집/활용 동의 및 보안서약-->
								<div class="agreement_step1_box step_box">
									<!--개인정보 추가수집 동의-->
									<h3 class="hidden">개인정보 추가수집 동의</h3>
									<h4>개인정보 추가 수집 동의<span class="font_red">(필수)</span></h4>
									<div class="txt_box">
										<p>개인정보 추가 수집 및 이용안내에 나열된 선택정보, 학력, 경력, 논문, 지적재산권 등 평가위원 개인정보 추가수집에 동의하지 않으실 경우 평가위원으로 참여하실 수 없습니다.</p>
									</div>
									<div class="check_box clearfix">
										<span class="fr mt10"><input type="checkbox" id="member_info_terms_of_service" name="member_info_terms_of_service" value="동의" /><label for="member_info_terms_of_service">동의합니다.</label></span>
									</div>
									<!--//개인정보 추가수집 동의-->	
									<!--정보 활용 동의-->
									<h4>정보 활용 동의<span class="font_red">(필수)</span></h4>
									<div class="txt_box">
										<p>신청자의 자격 검증을 위해 제3의 기관(대학(학위정보) 및 4대보험관리기관(자격정보)에 개별 조회할 수 있으며, 정보 활용 동의가 없을 경우 평가위원으로 참여하실 수 없습니다.<br />또한, 수집된 정보는 전문가 매칭 등 신기술접수소 사업을 위해 연구자를 대상으로 공개될 수 있습니다.</p>
									</div>
									<div class="check_box clearfix">
										<span class="fr mt10"><input type="checkbox" id="member_info_usageagreement_service" name="member_info_usageagreement_service" value="동의" /><label for="member_info_usageagreement_service">동의합니다.</label></span>
									</div>
									<!--//정보 활용 동의-->
									<!--보안서약-->
									<h4>보안 서약<span class="font_red">(필수)</span></h4>
									<div class="txt_box">
										<p>다음 사항을 준수할 것을 서약합니다.<br /><br />
											1. 사업에 대한 평가를 수행하는 과정에서 습득한 기술기밀에 대해 사업수행 중은 물론 종료 후에도 서울기술연구원장의 허락없이 자신 또는 제 3자를 위해서 사용하지 않는다.<br />
											2.  사업의 내용 또는 추진성과가 적법하게 공개된 경우라고 하여도 미공개 부문에 대해서는 1항과 같은 비밀유지 의무를 부담한다.<br />
											3.  위의 사항을 본인이 준수하지 않아 발생하는 제반사항에 대해 필요한 책임을 부담한다.<br />
										</p>
									</div>
									<div class="check_box clearfix">
										<span class="fr mt10"><input type="checkbox" id="member_info_security_service" name="member_info_security_service" value="동의" /><label for="member_info_security_service">동의합니다.</label></span>
									</div>
									<!--//보안서약-->
									<div class="btn_box mt20 mb20 fr">
										<button type="button" class="blue_btn next_btn alert_check" onclick="window.scrollTo(0,0);">다음</button>
									</div>
								</div>
								<!--//정보수집/활용 동의 및 보안서약-->
								<!--기본 정보 입력-->
								<div class="agreement_step2_box step_box">
									<div class="area_table_box">
										<!--기본 정보-->
										<h3 class="hidden">기본 정보</h3>
										<h4>기본 정보</h4>
										<div class="table_area">
											<table class="write fixed">
											<caption>기본 정보</caption>
												<colgroup>
													<col style="width: 30%;">																		
													<col style="width: 70%;">
												</colgroup>
												<tbody>
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>성명</span></th>
														<td id="name"></td>	
													</tr>									  
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>휴대전화</span></th>
														<td id="mobile_phone"></td>
													</tr>
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>이메일</span></th>
														<td id="email"></td>
													</tr>
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>주소</span></th>
														<td id="address"></td>
													</tr>												
												</tbody>
											</table>																										
										</div>
										<!--//기본 정보-->

										<!--기관 정보-->										
										<h4>기관 정보</h4>
										<div class="table_area">
											<table class="write fixed">
											<caption>기관 정보</caption>
												<colgroup>
													<col style="width: 30%;">																		
													<col style="width: 70%;">
												</colgroup>
												<tbody>
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기관 유형</span></th>
														<td id="institution_type" title="기관 유형"></td>
													</tr>									  
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기관명</span></th>
														<td id="institution_name" title="기관명"></td>
													</tr>
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>주소</span></th>
														<td id="institution_address" title="기관 주소"></td>
													</tr>
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>전화</span></th>
														<td id="institution_phone" title="기관 전화"></td>
													</tr>
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>부서</span></th>
														<td id="institution_depart" title="기관 부서"></td>
													</tr>
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>직책</span></th>
														<td id="institution_position" title="기관 직책"></td>
													</tr>																									
												</tbody>
											</table>																										
										</div>
										<!--//기관 정보-->

										<!--계좌 정보-->
										<h4>계좌 정보</h4>
										<div class="table_area">
											<table class="write fixed">
											<caption>계좌 정보</caption>
												<colgroup>
													<col style="width: 30%;">																		
													<col style="width: 70%;">
												</colgroup>
												<tbody>
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="bank_name">은행명</label></span></th>
														<td>
															<input type="text" title="은행명" id="bank_name" class="form-control w_10 mr5" />					
															<span class="d_i">은행</span>
														</td>	
													</tr>  
													<tr>
														<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="bank_account">계좌번호</label></span></th>
														<td>
															<input type="text" title="은행 계좌번호" id="bank_account" oninput="numberOnlyInput(this);" class="form-control w60 mr5 ls" />
															<span class="d_i">&quot; - &quot; 을 제외한 숫자만 입력해 주세요.</span>										
														</td>
													</tr>																							
												</tbody>
											</table>																										
										</div>
										<!--//계좌 정보-->

										<!--기술 분야-->										
										<h4>기술 분야</h4>
										<div class="table_area">
											<table class="write fixed">
											<caption>기술 분야</caption>
												<colgroup>
													<col style="width: 30%;">																		
													<col style="width: 70%;">
												</colgroup>
												<tbody>
													<tr>
													   <th scope="row" rowspan="3"><span class="icon_box"><span class="necessary_icon">*</span>국가과학기술분류</span></th>
													   <td>
														   <label for="tech_info_large" class="fl mt5 mr5">대분류</label>
														   <select name="tech_info_large" id="tech_info_large" class="ace-select w_93_8" >
														   </select>
													   </td>
												    </tr>
													<tr>
													   <td>
														   <label for="tech_info_middle" class="fl mt5 mr5">중분류</label>
														   <select name="tech_info_middle" id="tech_info_middle" class="ace-select w_93_8">
														   </select>
													   </td>
												    </tr>
													<tr>
													   <td>
														   <label for="tech_info_small" class="fl mt5 mr5">소분류</label>
														   <select name="tech_info_small" id="tech_info_small" class="ace-select w_93_8">
														   </select>
													   </td>
												    </tr>
													<tr>
													   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="tech_info_4th_industry">4차 산업혁명 기술분류</label></span></th>
													   <td>
														   <select name="tech_info_4th_industry" id="tech_info_4th_industry" class="ace-select w30">
														   </select>
														</td> 
												   </tr>																							
												</tbody>
											</table>																										
										</div>
										<!--//기술 분야-->

										<!--연구 분야-->										
										<h4>연구 분야</h4>
										<div class="table_area">
											<p class="mb5 lh_180">- 평가 가능한 연구 분야 <span class="font_blue">3개 이상</span> 작성하여 주세요. (예시 : 인공지능, 블록체인, IT융합)</p>
											<table class="write fixed">
											<caption>연구 분야</caption>
												<colgroup>
													<col style="width: 30%;">																		
													<col style="width: 70%;">
												</colgroup>
												<tbody>
													<tr>
													   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="rnd_class">연구 상세 분야</label></span></th>
													   <td>
													       <textarea name="rnd_class" title="연구 상세 분야" id="rnd_class" cols="30" rows="2" class="w100"></textarea>
													   </td>
													</tr>
												</tbody>
											</table>
									    </div>
										<!--//연구 분야-->
									</div>
									<div class="btn_box clearfix mt50 mb20">										
										<button type="button" class="blue_btn next_btn" onclick="window.scrollTo(0,0);">다음</button>
									</div>
								</div>
								
								<!--상세정보 입력-->
								<div class="agreement_step3_box step_box">
									<div class="area_table_box clearfix">
										<!--기본 정보-->
										<h3 class="hidden">상세 정보</h3>
										<!--학력-->
										<h4>학력</h4>
										<p class="mb5 lh_180 fl mt10">- <span class="font_blue">최근순</span>으로 기재하여 주십시요.</p>
										<!--<div class="btn_area fr clearfix">
											<button type="button" class="green_btn fl mb10 add_education_btn" id="addItemBtn">추가</button>
											<button type="button" class="gray_btn fl mb10 del_education_btn ml5">삭제</button>
										</div>-->
										<div class="table_area">									
											<table class="list fixed education_table write2" id="example">
												<caption>학력</caption>
												<colgroup>													
													<col style="width: 15%;">
													<col style="width: 20%;">
													<col style="width: 25%;">
													<col style="width: 12%;">
													<col style="width: 28%;">
												</colgroup>
												<thead>
													<tr>														
														<th scope="col" class="first"><span class="icon_box"><span class="necessary_icon">*</span>학위</span></th>
														<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>학교명</span></th>
														<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>전공</span></th>
														<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>학위취득연도</span></th>
														<th scope="col" class="last"><span class="icon_box"><span class="necessary_icon">*</span>학위증명서</span></th>										
													</tr>
												</thead>
												<tbody>
													<tr>														
														<td class="first clearfix">	
															<select name="degree_01" title="학위" id="degree_01" class="ace-select w100">
																<option value="학사">학사</option>															   
															    <option value="석사">석사</option>
															    <option value="박사">박사</option>															   
														    </select>
															<label for="degree_01" class="hidden">학위</label>												
														</td>
														<td>
															<input type="text" title="학교명" id="degree_school_01" class="form-control w100" />
															<label for="degree_school_01" class="hidden">학교명</label>
														</td>
														<td>
															<input type="text" title="전공" id="degree_major_01" class="form-control w100 ls" />
															<label for="degree_major_01" class="hidden">전공</label>
														</td>	
														<td>
															<input type="text" title="학위취득연도" id="degree_date_01" class="form-control w60 ls number_t" maxlength="4"  />
															<label for="degree_date_01">년</label>											
														</td>
														<td>
															<div class="clearfix file_form_txt">													   
															   <!--업로드 버튼-->	
															   <div class="filebox bs3-primary">
																  <input class="upload-name" value="선택된 파일이 없습니다." id="upload-name" disabled="disabled" style="width:100%">
																  <label for="upload-name" class="hidden">선택된 파일이 없습니다.</label>								  
																  <input type="file" id="degree_certi_file_01" class="upload-hidden"> 
																  <label for="degree_certi_file_01" class="mt5">학위증명서 찾기</label> 
																</div>													   
															   <!--//업로드 버튼-->														   
															</div>	
														</td>														
													</tr>
													<tr>														
														<td class="first clearfix">	
															<select name="degree_type" title="학위" id="degree_02" class="ace-select w100">
																<option value="학사">학사</option>															   
															    <option value="석사">석사</option>
															    <option value="박사">박사</option>															   
														    </select>
															<label for="degree_02" class="hidden">학위</label>												
														</td>
														<td>
															<input type="text" title="학교명" id="degree_school_02" class="form-control w100" />
															<label for="degree_school_02" class="hidden">학교명</label>
														</td>
														<td>
															<input type="text" title="전공" id="degree_major_02" class="form-control w100 ls" />
															<label for="degree_major_02" class="hidden">전공</label>
														</td>	
														<td>
															<input type="text" title="학위취득연도" id="degree_date_02" class="form-control w60 ls number_t" maxlength="4"  />
															<label for="degree_date_02">년</label>											
														</td>
														<td>
															
															<div class="clearfix file_form_txt">													   
															   <!--업로드 버튼-->	
															   <div class="filebox bs3-primary">
																  <input class="upload-name" value="선택된 파일이 없습니다." id="upload-name2" disabled="disabled" style="width:100%">
																  <label for="upload-name2" class="hidden">선택된 파일이 없습니다.</label>								  
																  <input type="file" id="degree_certi_file_02" class="upload-hidden"> 
																  <label for="degree_certi_file_02" class="mt5">학위증명서 찾기</label> 
																</div>													   
															   <!--//업로드 버튼-->														   
															</div>															
														</td>														
													</tr>	
												</tbody>
											</table>
										</div>	
										<!--//학력-->

										<!--경력-->
										<h4>경력</h4>
										<p class="mb5 lh_180 fl mt10">- <span class="font_blue">최근순</span>으로 기재하여 주십시요.</p>							
										<!--<div class="btn_area fr clearfix">
											<button type="button" class="green_btn fl mb10 add_history_btn">추가</button>
											<button type="button" class="gray_btn fl mb10 del_history_btn ml5">삭제</button>
										</div>-->
										<div class="table_area">									
											<table class="list fixed history_table write2">
												<caption>경력</caption>
												<colgroup>													
													<col style="width: 20%;">
													<col style="width: 20%;">
													<col style="width: 10%;">
													<col style="width: 19%;">
													<col style="width: 19%;">
													<col style="width: 22%;">
												</colgroup>
												<thead>
													<tr>														
														<th scope="col" class="first"><span class="icon_box"><span class="necessary_icon">*</span>근무처</span></th>
														<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>근무부서</span></th>
														<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>직급</span></th>
														<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>입사</span></th>
														<th scope="col"><span class="icon_box">퇴사</span></th>
														<th scope="col" class="last"><span class="icon_box"><span class="necessary_icon">*</span>업무내용</span></th>
													</tr>
												</thead>
												<tbody>
													<tr>														
														<td class="first clearfix">	
															<input type="text" title="근무처" id="career_company_01" class="form-control w100" />
															<label for="career_company_01" class="hidden">근무처</label>											
														</td>
														<td>
															<input type="text" title="근무부서" id="career_depart_01" class="form-control w100" />
															<label for="career_depart_01" class="hidden">근무부서</label>
														</td>
														<td>
															<input type="text" title="직급" id="company_rank" class="form-control w100 ls" />
															<label for="company_rank" class="hidden">직급</label>
														</td>	
														<td>
															<input type="text" title="입사 년도" id="join_day" class="form-control w40 ls number_t" maxlength="4" />
															<label for="join_day" class="mr10">년</label>
															<input type="text" title="입사 월" id="join_day1_2" class="form-control w20 ls number_t" maxlength="2" />
															<label for="join_day1_2">월</label>															
														</td>	
														<td>
															<input type="text" title="퇴사 년도" id="leave_day" class="form-control w40 ls number_t" maxlength="4" />
															<label for="leave_day" class="mr10">년</label>
															<input type="text" title="퇴사 월" id="leave_day1_2" class="form-control w20 ls number_t" maxlength="2" />
															<label for="leave_day1_2">월</label>
														</td>	
														<td class="last">
															<textarea title="업무내용" name="career_description_01" id="career_description_01" rows="3" class="w100"></textarea>	
															<label for="career_description_01" class="hidden">업무내용</label>
														</td>	
													</tr>
													<tr>														
														<td class="first clearfix">	
															<input type="text" id="career_company_02" class="form-control w100" />
															<label for="career_company_02" class="hidden">근무처</label>											
														</td>
														<td>
															<input type="text" id="career_depart_02" class="form-control w100" />
															<label for="career_depart_02" class="hidden">근무부서</label>
														</td>
														<td>
															<input type="text" id="career_position_02" class="form-control w100 ls" />
															<label for="career_position_02" class="hidden">직급</label>
														</td>	
														<td>
															<input type="text" id="join_day2" class="form-control w40 ls number_t" maxlength="4" />
															<label for="join_day2" class="mr10">년</label>
															<input type="text" id="join_day2_2" class="form-control w20 ls number_t" maxlength="2" />
															<label for="join_day2_2">월</label>															
														</td>	
														<td>
															<input type="text" id="leave_day2" class="form-control w40 ls number_t" maxlength="4" />
															<label for="leave_day2" class="mr10">년</label>
															<input type="text" id="leave_day2_2" class="form-control w20 ls number_t" maxlength="2" />
															<label for="leave_day2_2">월</label>
														</td>	
														<td class="last">
															<textarea name="career_description_02" id="career_description_02" rows="3" class="w100"></textarea>	
															<label for="career_description_02" class="hidden">업무내용</label>
														</td>	
													</tr>
													<tr>														
														<td class="first clearfix">	
															<input type="text" id="career_company_03" class="form-control w100" />
															<label for="career_company_03" class="hidden">근무처</label>											
														</td>
														<td>
															<input type="text" id="career_depart_03" class="form-control w100" />
															<label for="career_depart_03" class="hidden">근무부서</label>
														</td>
														<td>
															<input type="text" id="career_position_03" class="form-control w100 ls" />
															<label for="career_position_03" class="hidden">직급</label>
														</td>	
														<td>
															<input type="text" id="join_day3" class="form-control w40 ls number_t" maxlength="4" />
															<label for="join_day3" class="mr10">년</label>
															<input type="text" id="join_day3_2" class="form-control w20 ls number_t" maxlength="2" />
															<label for="join_day3_2">월</label>															
														</td>	
														<td>
															<input type="text" id="leave_day3" class="form-control w40 ls number_t" maxlength="4" />
															<label for="leave_day3" class="mr10">년</label>
															<input type="text" id="leave_day3_2" class="form-control w20 ls number_t" maxlength="2" />
															<label for="leave_day3_2">월</label>
														</td>	
														<td class="last">
															<textarea name="career_description_03" id="career_description_03" rows="3" class="w100"></textarea>	
															<label for="career_description_03" class="hidden">업무내용</label>
														</td>	
													</tr>
													<tr>														
														<td class="first clearfix">	
															<input type="text" id="career_company_04" class="form-control w100" />
															<label for="career_company_04" class="hidden">근무처</label>											
														</td>
														<td>
															<input type="text" id="career_depart_04" class="form-control w100" />
															<label for="career_depart_04" class="hidden">근무부서</label>
														</td>
														<td>
															<input type="text" id="career_position_04" class="form-control w100 ls" />
															<label for="career_position_04" class="hidden">직급</label>
														</td>	
														<td>
															<input type="text" id="join_day4" class="form-control w40 ls number_t" maxlength="4" />
															<label for="join_day4" class="mr10">년</label>
															<input type="text" id="join_day4_2" class="form-control w20 ls number_t" maxlength="2" />
															<label for="join_day4_2">월</label>															
														</td>	
														<td>
															<input type="text" id="leave_day4" class="form-control w40 ls number_t" maxlength="4" />
															<label for="leave_day4" class="mr10">년</label>
															<input type="text" id="leave_day4_2" class="form-control w20 ls number_t" maxlength="2" />
															<label for="leave_day4_2">월</label>
														</td>	
														<td class="last">
															<textarea name="career_description_04" id="career_description_04" rows="3" class="w100"></textarea>	
															<label for="career_description_04" class="hidden">업무내용</label>
														</td>	
													</tr>
												</tbody>
											</table>
										</div>	
										<!--//경력-->
										<!--논문/저서-->
										<h4>논문/저서<span class="font_blue">(선택)</span></h4>										
										<div class="table_area">									
											<table class="list fixed treatise_table write2">
												<caption>논문/저서</caption>
												<colgroup>
													<col style="width: 10%;">
													<col style="width: 25%;">
													<col style="width: 12%;">
													<col style="width: 10%;">
													<col style="width: 13%;">
													<col style="width: 15%;">
												</colgroup>
												<thead>
													<tr>
														<th scope="col" class="first">SCI 여부</th>
														<th scope="col">논문저서명</th>
														<th scope="col">주 저자명</th>
														<th scope="col">학술지</th>
														<th scope="col">국내/국외</th>
														<th scope="col" class="last">발행일자</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td class="first clearfix">	
															<div class="clearfix" style="margin: auto;width:50px">
																<input type="checkbox" id="thesis_sci_yn_01" class="fl ml10 mr5">
																<label for="thesis_sci_yn_01" class="fl">SCI</label>
															</div>																									
														</td>
														<td>
															<input type="text" id="thesis_title_01" class="form-control w100" />
															<label for="thesis_title_01" class="hidden">논문저서명</label>
														</td>
														<td>
															<input type="text" id="thesis_writer_01" class="form-control w100 ls" />
															<label for="thesis_writer_01" class="hidden">주 저자명</label>
														</td>	
														<td>
															<input type="text" id="thesis_journal_01" class="form-control w100 ls" />
															<label for="thesis_journal_01" class="hidden">학술지</label>											
														</td>	
														<td>															
															<input type="radio" id="country_type1_1" value="국내" name="country_type1" checked>
															<label for="country_type1_1">국내</label>
															<input type="radio" id="country_type1_2" value="국외" name="country_type1">
															<label for="country_type1_2">국외</label>															
														</td>	
														<td class="last">															
															<div class="datepicker_area fl mr5">
																<input type="text" id="thesis_date_01" class="datepicker form-control w_14 mr5 ls" />
															</div>															
															<label for="thesis_date_01" class="hidden fl">발행일자</label>
														</td>	
													</tr>
													<tr>
														<td class="first clearfix">	
															<div class="clearfix" style="margin: auto;width:50px">
																<input type="checkbox" id="thesis_sci_yn_02" class="fl ml10 mr5">
																<label for="thesis_sci_yn_02" class="fl">SCI</label>
															</div>													
														</td>
														<td>
															<input type="text" id="thesis_title_02" class="form-control w100" />
															<label for="thesis_title_02" class="hidden">논문저서명</label>
														</td>
														<td>
															<input type="text" id="thesis_writer_02" class="form-control w100 ls" />
															<label for="thesis_writer_02" class="hidden">주 저자명</label>
														</td>	
														<td>
															<input type="text" id="thesis_journal_02" class="form-control w100 ls" />
															<label for="thesis_journal_02" class="hidden">학술지</label>											
														</td>	
														<td>
															<input type="radio" id="country_type2_1" value="국내" name="country_type2" checked>
															<label for="country_type2_1">국내</label>
															<input type="radio" id="country_type2_2" value="국외" name="country_type2">
															<label for="country_type2_2">국외</label>	
														</td>	
														<td class="last">															
															<div class="datepicker_area fl mr5">
																<input type="text" id="thesis_date_02" class="datepicker form-control w_14 mr5 ls" />
															</div>															
															<label for="thesis_date_02" class="hidden fl">발행일자</label>
														</td>	
													</tr>	
													<tr>
														<td class="first clearfix">	
															<div class="clearfix" style="margin: auto;width:50px">
																<input type="checkbox" id="thesis_sci_yn_03" class="fl ml10 mr5">
																<label for="thesis_sci_yn_03" class="fl">SCI</label>
															</div>												
														</td>
														<td>
															<input type="text" id="thesis_title_03" class="form-control w100" />
															<label for="thesis_title_03" class="hidden">논문저서명</label>
														</td>
														<td>
															<input type="text" id="thesis_writer_03" class="form-control w100 ls" />
															<label for="thesis_writer_03" class="hidden">주 저자명</label>
														</td>	
														<td>
															<input type="text" id="thesis_journal_03" class="form-control w100 ls" />
															<label for="thesis_journal_03" class="hidden">학술지</label>											
														</td>	
														<td>
															<input type="radio" id="country_type3_1" value="국내" name="country_type3" checked>
															<label for="country_type3_1">국내</label>
															<input type="radio" id="country_type3_2" value="국외" name="country_type3">
															<label for="country_type3_2">국외</label>	
														</td>	
														<td class="last">															
															<div class="datepicker_area fl mr5">
																<input type="text" id="thesis_date_03" class="datepicker form-control w_14 mr5 ls" />
															</div>															
															<label for="thesis_date_03" class="hidden fl">발행일자</label>
														</td>	
													</tr>	
												</tbody>
											</table>
										</div>	
										<!--//논문/저서-->

										<!--지식재산권-->
										<h4>지식재산권<span class="font_blue">(선택)</span></h4>										
										<div class="table_area">									
											<table class="list fixed knowledge_table write2">
												<caption>지식재산권</caption>
												<colgroup>													
													<col style="width: 25%;">
													<col style="width: 13%;">
													<col style="width: 15%;">
													<col style="width: 17%;">
													<col style="width: 18%;">
													<col style="width: 10%;">
												</colgroup>
												<thead>
													<tr>														
														<th scope="col" class="first">지식재산권명</th>
														<th scope="col">출원/등록</th>
														<th scope="col">출원/등록 번호</th>
														<th scope="col">출원/등록 일자</th>
														<th scope="col">출원/등록 국가</th>
														<th scope="col" class="last">발명자명</th>
													</tr>
												</thead>
												<tbody>
													<tr>														
														<td class="first">
															<input type="text" id="iprs_name_01" class="form-control w100" />
															<label for="iprs_name_01" class="hidden">논문저서명</label>
														</td>														
														<td>												
															<input type="radio" id="license_pending1" value="출원" name="license_class1" checked>
															<label for="license_pending1">출원</label>
															<input type="radio" id="license_enrollment1" value="등록" name="license_class1">
															<label for="license_enrollment1">등록</label>												
														</td>
														<td>
															<input type="text" id="iprs_reg_no_01" class="form-control w100 ls" />
															<label for="iprs_reg_no_01" class="hidden">출원/등록 번호</label>									
														</td>	
														<td>
															<div class="datepicker_area fl mr5">
																<input type="text" id="iprs_date_01" class="datepicker form-control w_14 mr5 ls" />
															</div>
															<label for="iprs_date_01" class="hidden">출원/등록 일자</label>
														</td>	
														<td>
															<input type="text" id="iprs_nationality_01" class="form-control w100 ls" />
															<label for="iprs_nationality_01" class="hidden">출원/등록 국가</label>
														</td>	
														<td class="last">															
															<input type="text" id="iprs_writer_01" class="form-control w100 ls" />
															<label for="iprs_writer_01" class="hidden fl">발명자명</label>
														</td>	
													</tr>
													<tr>														
														<td class="first">
															<input type="text" id="iprs_name_02" class="form-control w100" />
															<label for="iprs_name_02" class="hidden">논문저서명</label>
														</td>
														<td>												
															<input type="radio" id="license_pending2" value="출원" name="license_class2" checked>
															<label for="license_pending2">출원</label>
															<input type="radio" id="license_enrollment2" value="등록" name="license_class2">
															<label for="license_enrollment2">등록</label>												
														</td>
														<td>
															<input type="text" id="iprs_reg_no_02" class="form-control w100 ls" />
															<label for="iprs_reg_no_02" class="hidden">출원/등록 번호</label>									
														</td>	
														<td>
															<div class="datepicker_area fl mr5">
																<input type="text" id="iprs_date_02" class="datepicker form-control w_14 mr5 ls" />
															</div>
															<label for="iprs_date_02" class="hidden">출원/등록 일자</label>
														</td>	
														<td>
															<input type="text" id="iprs_nationality_02" class="form-control w100 ls" />
															<label for="iprs_nationality_02" class="hidden">출원/등록 국가</label>
														</td>	
														<td class="last">															
															<input type="text" id="iprs_writer_02" class="form-control w100 ls" />
															<label for="iprs_writer_02" class="hidden fl">발명자명</label>
														</td>	
													</tr>
													<tr>
														<td class="first">															
															<input type="text" id="iprs_name_03" class="form-control w100" />
															<label for="iprs_name_03" class="hidden">논문저서명</label>
														</td>
														<td>												
															<input type="radio" id="license_pending3" value="출원" name="license_class3" checked>
															<label for="license_pending3">출원</label>
															<input type="radio" id="license_enrollment3" value="등록" name="license_class3">
															<label for="license_enrollment3">등록</label>												
														</td>	
														<td>
															<input type="text" id="iprs_reg_no_03" class="form-control w100 ls" />
															<label for="iprs_reg_no_03" class="hidden">출원/등록 번호</label>									
														</td>	
														<td>
															<div class="datepicker_area fl mr5">
																<input type="text" id="iprs_date_03" class="datepicker form-control w_14 mr5 ls" />
															</div>
															<label for="iprs_date_03" class="hidden">출원/등록 일자</label>
														</td>	
														<td>
															<input type="text" id="iprs_nationality_03" class="form-control w100 ls" />
															<label for="iprs_nationality_03" class="hidden">출원/등록 국가</label>
														</td>	
														<td class="last">															
															<input type="text" id="iprs_writer_03" class="form-control w100 ls" />
															<label for="iprs_writer_03" class="hidden fl">발명자명</label>
														</td>	
													</tr>
												</tbody>
											</table>
										</div>	
										<!--//지식재산권-->

										<!--자기기술서-->
										<h4>자기기술서<span class="font_blue">(선택)</span></h4>										
										<div class="table_area">									
											<table class="write fixed">
											<caption>자기기술서</caption>
												<colgroup>
													<col style="width: 30%;">																		
													<col style="width: 70%;">
												</colgroup>
												<tbody>
													<tr>
													   <th scope="row" class="ta_c"><label for="self_description">자기기술서(500자 이내)</label></th>
													   <td>
													       <textarea name="my_skill" id="self_description" cols="30" rows="8" class="w100"></textarea>
													   </td>
													</tr>
												</tbody>
											</table>
										</div>	
										<!--//자기기술서-->
									</div>
								<!--//상세정보 입력-->
									<div class="btn_box clearfix mt50 mb20">																				
										<button type="button" class="gray_btn2 prv_btn fl mr10" title="이전" onclick="window.scrollTo(0,0);">이전</button>
										<button type="button" class="blue_btn complate_popup_btn" onclick="prepareRegistration('D0000002');">완료</button>
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
