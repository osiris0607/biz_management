<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<sec:authentication property="principal.username" var="member_id" />
 
<script src="/assets/user/biz_js/reception/match-consulting-search.js"></script>
<script src="/assets/user/biz_js/reception/match-consulting-expert.js"></script>


<script type='text/javascript'>
	$(document).ready(function() {
		// email Select
	 	$("#selectEmail").change(function(){
	 		if ( $("#selectEmail").val() == "1" ) {
				$("#email_2").attr("disabled", false);
				$("#email_2").val("");
			}
			else {
				$("#email_2").attr("disabled", true);
				if ( $("#selectEmail").val() != "0" ) {
					$("#email_2").val($("#selectEmail").val());
				}
				else {
					$("#email_2").val("");
				}
			}
		});
	 	// 과학 기술 분류 대분류 Click
	 	$("#large_selector").change(function(){
		    largeSelectorChange( $(this).val());
		});
	 	// 과학 기술 분류 중분류 Click
	 	$("#middle_selector").change(function(){
		 	if ( $("#large_selector").val() == "" ) {
		 		alert("대분류를 먼저 선택하시기 바랍니다.");
		 		return;
		 	}
		    middleSelectorChange( $(this).val());
		});
	 	// 과학 기술 분류 소분류 Click
	 	$("#small_selector").change(function(){
		 	if ( $("#middle_selector").val() == "" ) {
		 		alert("중분류를 먼저 선택하시기 바랍니다.");
		 		return;
		 	}
		});
	 	// 전문가 과하 기술 분류 대분류 Click
	 	$("#expert_large_selector").change(function(){
		    expertLargeSelectorChange( $(this).val());
		});
	 	// 전문가 과하 기술 분류 중분류 Click
	 	$("#expert_middle_selector").change(function(){
		 	if ( $("#expert_large_selector").val() == "" ) {
		 		alert("대분류를 먼저 선택하시기 바랍니다.");
		 		return;
		 	}
		    expertMiddleSelectorChange( $(this).val());
		});
	 	// 전문가 과하 기술 분류 소분류 Click
	 	$("#expert_small_selector").change(function(){
		 	if ( $("#expert_middle_selector").val() == "" ) {
		 		alert("중분류를 먼저 선택하시기 바랍니다.");
		 		return;
		 	}
		});
		
	 	// 국가 과학 기술 분류
		initScienceCategory();
		initExpertScienceCategory();
		// 4차 산업 혁명 
		init4thIndustry();
		// 캠퍼스
		initCampus();
	 	// match-consulting-search-data.js 에 구현
	 	searchMemberDetail('${member_id}');
		searchInstitutionDetail('${member_id}');
		// 'M0000014 / D0000003' - 접수상태 중에서 전문가 매칭 신청인 경우에는 제출서류를 보여주지 않는다.
		searchAnnouncementDetail("D0000003");
	});
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
	// 국가 과학 기술 분류 
	function initExpertScienceCategory(){
		$("#expert_large_selector").empty();
		$("#expert_middle_selector").empty();
		$("#expert_small_selector").empty();
		
	    var previousName = "";
	    var str = '<option value="">대분류 선택</option>';
	   	<c:forEach items="${scienceCategory}" var="code">
			if ( previousName != "${code.large}") {
				str += '<option value="${code.large}">${code.large}</option>';
				previousName =  "${code.large}";
			}
		</c:forEach>

		$("#expert_middle_selector").append('<option value="">중분류 선택</option>');
		$("#expert_small_selector").append('<option value="">소분류 선택</option>');
		$("#expert_large_selector").append(str);
		
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
	// 과학 기술 대분류 선택 처리
	function expertLargeSelectorChange(category) {
		if (category != ""){
			$("#expert_middle_selector").empty();
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
			$("#expert_middle_selector").append(str);
		} else {
			initExpertScienceCategory();
		}
	}
	// 과학 기술 중분류 선택 처리
	function expertMiddleSelectorChange(category) {
		if (category != ""){
			$("#expert_small_selector").empty();
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
			$("#expert_small_selector").append(str);
		}
	}
	// 4차 산업 초기화
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
	// 캠퍼스 초기화
	function initCampus() {
		$("#campus_list_ul").empty();

		var index = 1;
		var str = "";
	   	<c:forEach items="${commonCode}" var="code">
			<c:if test="${code.master_id == 'M0000010'}">
				str += "<li>";
				str += "	<input type='radio' id='campus_" + index + "' class='fl' name='campus' value='${code.name}'/>";
				str += "	<label for='campus_" + index + "' class='fl'>${code.name}</label>";
				str += "</li>";
			</c:if>
		</c:forEach>
		$("#campus_list_ul").append(str);
	}

	var mailAddress;
	function prepareRegistration(status) {
		if ( directChoiceExpert(status) == false ) {
			return;
		}
		
		// 전문가 매칭 임시 저장인 경우 필수 입력을 체크하지 않는다.
		if ( status != 'D0000003') {
			var chkVal = ["reg_no", "company_name", "company_address", "company_phone", "representative_name", "industry_type", "business_type", 
  				  "foundation_date", "foundation_type", "company_class", "company_type", "employee_no", "total_sales",
				  "research_name","mobile_phone_2", "mobile_phone_3", "email_1", "email_2", "research_address", "research_address_detail", 
				  "consulting_campus", "sevice_name", "sevice_description"];
		  
			for (var i = 0; i < chkVal.length; i++) 
			{
				if ( chkVal[i].indexOf("mobile_phone") != -1 && $("#mobile_phone_tr").attr("use_yn") != "n" ) {
					if ($("#" + chkVal[i]).val() == "" ) {
						showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.", "접수 안내");
						$("#" + chkVal[i]).focus();
						return false;
					}
				}
				else if  ( chkVal[i].indexOf("email_") != -1 && $("#email_tr").attr("use_yn") != "n" ) {
					if ($("#" + chkVal[i]).val() == "" ) {
						showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.", "접수 안내");
						$("#" + chkVal[i]).focus();
						return false;
					}
				}
				else if  ( chkVal[i].indexOf("research_address") != -1 && $("#research_address_tr").attr("use_yn") != "n" ) {
					if ($("#" + chkVal[i]).val() == "" ) {
						showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.", "접수 안내");
						$("#" + chkVal[i]).focus();
						return false;
					}
				}
				else if ( $("#" + chkVal[i]+"_tr").attr("use_yn") != "n" ) {
					if ($("#" + chkVal[i]).val() == "" ) {
						showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.", "접수 안내");
						$("#" + chkVal[i]).focus();
						return false;
					}
				}
			}
			if ( $("input:radio[name=lab_exist_yn_radio]").is(":checked") == false && $("#lab_exist_yn_tr").attr("use_yn") != "n"  ) {
				showPopup("기업부설연구소 유무 은(는) 필수입력입니다.", "접수 안내");
				return;
			}
			if ( $("input:radio[name=con_reception_class_g]").is(":checked") == false && $("#consulting_type_tr").attr("use_yn") != "n" ) {
				showPopup("기술컨설팅 구분 은(는) 필수입력입니다.", "접수 안내");
				return;
			}

			
			if ( $("#sevice_content_tr").attr("use_yn") != "n" ) {
				if ( $("input:radio[name=con_reception_class_g]:checked").val() == "기술애로 컨설팅" ) {
					if ( gfn_isNull($("#reception_problems_text").val()) ) {
						showPopup("기술애로사항은 필수입력입니다.", "접수 안내");
						return;
					}
					if ( gfn_isNull($("#reception_conrequest_text").val()) ) {
						showPopup("컨설팅 요청사항은 필수입력입니다.", "접수 안내");
						return;
					}
				}
				else {
					if ( gfn_isNull($("#reception_rnd_text").val()) ) {
						showPopup("기술연구개발 내용은 필수입력입니다.", "접수 안내");
						return;
					}
					if ( gfn_isNull($("#reception_rndrequest_text").val()) ) {
						showPopup("전문가 요청사항은 필수입력입니다.", "접수 안내");
						return;
					}
				}
			}
			
			if ( gfn_isNull($("select[name=large_selector]").val()) && $("#national_science_large_tr").attr("use_yn") != "n" ) {
				showPopup("국가과학기술분류 대분류 은(는) 필수입력입니다.", "접수 안내");
				return;
			}
			if ( gfn_isNull($("select[name=middle_selector]").val()) && $("#national_science_middle_tr").attr("use_yn") != "n" ) {
				showPopup("국가과학기술분류 중분류 은(는) 필수입력입니다.", "접수 안내");
				return;
			}
			if ( gfn_isNull($("select[name=small_selector]").val()) && $("#national_science_small_tr").attr("use_yn") != "n" ) {
				showPopup("국가과학기술분류 소분류 은(는) 필수입력입니다.", "접수 안내");
				return;
			}
			if ( gfn_isNull($("select[name=4th_industry_selector]").val()) && $("#4th_industry_tr").attr("use_yn") != "n" ) {
				showPopup("4차 산업혁명 기술분류 은(는) 필수입력입니다.", "접수 안내");
				return;
			}
			if ( $("input:radio[name=con_radio_check]").is(":checked") == false && $("#consulting_purpose_tr").attr("use_yn") != "n" ) {
				showPopup("컨설팅 목적 은(는) 필수입력입니다.", "접수 안내");
				return;
			}
			
		
			if ( gfn_isNull($("#email_1").val()) == false && gfn_isNull($("#email_2").val()) == false){
				mailAddress = $("#email_1").val() + "@" + $("#email_2").val();
			}
			else if (gfn_isNull($("#email_1").val()) == false && $("select[name=selectEmail]").val() != "0" && $("select[name=selectEmail]").val() != "1" ) {
				mailAddress =  $("#email_1").val() + "@" + $("select[name=selectEmail]").val();
			}
			// 제출 서류 확인
			for (var i=0; i<$("#document_body tr").length; i++ ) {
				// 필수 파일인 경우 Check
				if ( gfn_isNull($("#submit_files_name_"+(i+1)).val()) && ($("#submit_files_name_"+(i+1)).attr("type") == "D0000003") ) {
					showPopup( $("#submit_files_name_"+(i+1)).attr("field_name") + " 파일은 필수 선택입니다.", "접수 안내");
					return false;
				}
			}
			// 제셀프 체크리스트 확인
			if ( mAnnouncementDetail.ext_check_list != null && mAnnouncementDetail.ext_check_list.length > 0 && 
				 mAnnouncementDetail.ext_check_list[0].all_use_yn == "D0000001" && isSelectSelfCheckList == false
			 	) {
				showPopup( "셀프 체크리스트를 확인해 주시기 바랍니다.", "접수 안내");
				return false;
			}
			// 전문가 선택 여부
			// 반드시 1명 이상의 전문가를 선택해야 한다.
			if ( (mChoiceExpertList == null || mChoiceExpertList.length == 0) && (mDirectChoiceExpertList == null || mDirectChoiceExpertList.length == 0) ) {
				showPopup( "한명 이상의 전문가를 선택해야 합니다.", "접수 안내");
				return false;
			}
		}
		
		
		// 임시 저장 Popup 실행
		if (status == "D0000003") {
			$('.temp_save_box, .popup_bg').fadeIn(350);
		}
		else { // 매칭 popup 실행
			$('.matching_save_box, .popup_bg').fadeIn(350);
		}
	}

	var isRegistration = false;
	function registration(status){
		// 창 닫기
		$('.temp_save_box, .popup_bg').fadeOut(350);
		$('.matching_save_box, .popup_bg').fadeOut(350);
		
		var formData = new FormData();
		// 기관 정보
		formData.append("reception_status", status);
		formData.append("announcement_id", $("#announcement_id").val());
		formData.append("announcement_type", mAnnouncementDetail.type);
		formData.append("member_id", '${member_id}');
		formData.append("institution_reg_number", $("#reg_no").val());
		formData.append("institution_name", $("#company_name").val());
		formData.append("institution_address", $("#company_address").val());
		formData.append("institution_phone", $("#company_phone").val());
		formData.append("institution_owner_name", $("#representative_name").val());
		formData.append("institution_industry", $("#industry_type").val());
		formData.append("institution_business", $("#business_type").val());
		formData.append("institution_foundataion_date", $("#foundation_date").val());
		formData.append("institution_foundataion_type", $("#foundation_type").val());
		formData.append("institution_classification", $("#company_class").val());
		formData.append("institution_type", $("#company_type").val());
		formData.append("institution_laboratory_yn", $("input:radio[name=lab_exist_yn_radio]:checked").val());
		formData.append("institution_employee_count", $("#employee_no").val());
		formData.append("institution_total_sales", $("#total_sales").val());
		formData.append("institution_capital_1", $("#capital_1").val());
		formData.append("institution_capital_2", $("#capital_2").val());
		formData.append("institution_capital_3", $("#capital_3").val());
		// 연구책임자 정보
		formData.append("researcher_name", $("#research_name").val());
		formData.append("researcher_mobile_phone", $("#mobile_phone_selector").val() + "-" + $("#mobile_phone_2").val() + "-" + $("#mobile_phone_3").val() );
		formData.append("researcher_email", $("#email_1").val() + "@" + $("#email_2").val() );
		formData.append("researcher_address", $("#research_address").val() );
		formData.append("researcher_address_detail", $("#research_address_detail").val() );
		formData.append("researcher_institution_name", $("#research_institution_name").val() );
		formData.append("researcher_institution_department", $("#research_institution_department").val() );
		formData.append("researcher_institution_position", $("#research_institution_position").val() );
		//기술컨설팅 요청사항
		formData.append("tech_consulting_type", $("input:radio[name=con_reception_class_g]:checked").val() );
		formData.append("tech_consulting_campus", $("#consulting_campus").val() );
		formData.append("tech_consulting_large", $("#large_selector").val() );
		formData.append("tech_consulting_middle", $("#middle_selector").val() );
		formData.append("tech_consulting_small", $("#small_selector").val() );
		formData.append("tech_consulting_4th_industry", $("#4th_industry_selector").val() );
		formData.append("tech_consulting_purpose", $("input:radio[name=con_radio_check]:checked").val() );
		formData.append("tech_consulting_purpose_etc", $("#con_purpose8_comment").val() );
		//기술 정보
		formData.append("tech_info_name", $("#sevice_name").val() );
		formData.append("tech_info_description", $("#sevice_description").val() );
		formData.append("tech_info_problems", $("#reception_problems_text").val() );
		formData.append("tech_info_consulting_request", $("#reception_conrequest_text").val() );
		formData.append("tech_info_rnd_description", $("#reception_rnd_text").val() );
		formData.append("tech_info_expert_request", $("#reception_rndrequest_text").val() );
		if ( $("#service_upload_file")[0].files[0] != null ) {
			formData.append("tech_info_upload_file", $("#service_upload_file")[0].files[0]);
		}
		//제출 서류
		var submitFileExtIDList = new Array();
		for (var i=0; i<$("#document_body tr").length; i++ ) {
			var fileInfo = new Object();
			if ( gfn_isNull($("#submit_files_name_"+(i+1)).val()) == false ) {
				submitFileExtIDList.push($("#submit_files_name_"+(i+1)).attr("ext_id"));
				formData.append("submit_files", $("#submit_files_"+(i+1))[0].files[0]);
			}
		}
		formData.append("submit_file_ext_id_list", submitFileExtIDList);
		// EXPERT 처리
		var expertList = new Array();
		// 전문가 POOL에서 선택된 전문가
		$.each(mChoiceExpertList, function(key, value) {
			var expert = new Object();
			expert.member_id = value.member_id;
			expert.national_science = value.national_science;
			expert.research = value.research;
			expert.name = value.name;
			expert.institution_name = value.institution_name;
			expert.institution_department = value.institution_department;
			expert.mobile_phone = value.mobile_phone.replace(/\-/gi, "");
			expert.email = value.email;

			expertList.push(expert);
		});
		// 사용자가 직접 입력한 전문가
		$.each(mDirectChoiceExpertList, function(key, value) {
			var expert = new Object();
			expert.member_id = "";
			expert.national_science = "";
			expert.research = value.research;
			expert.name = value.name;
			expert.institution_name = value.university;
			expert.institution_department = value.department;
			expert.mobile_phone = value.mobile_phone;
			expert.email = value.email;

			expertList.push(expert);
		});
		
		formData.append("choiced_expert_info_list_json", JSON.stringify(expertList));

		// 체크 리스트 처리
		var selfCheckList = new Array();
		for (var i=0; i<$("#self_check_list_body tr").length; i++ ) {
			var checkInfo = new Object();
			checkInfo.announcement_check_id = $("#check_list_"+(i+1)).attr("check_id");
			checkInfo.reception_check_value = $("input:radio[name=check_list_radio_" + (i+1) + "]:checked").val();
			selfCheckList.push(checkInfo);
			
		}
		formData.append("self_check_list_json", JSON.stringify(selfCheckList));
		
	 	$.ajax({
		    type : "POST",
		    url : "/member/api/reception/match/registration",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		        	showPopup("등록이 완료되었습니다.", "접수 안내");
		        	isRegistration = true;
		        } else {
		        	showPopup("등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.", "접수 안내");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		}); 
	}

	function selectCampus(){
		if ( $("input:radio[name='campus']").is(":checked") != true ){
			showPopup("선택된 캠퍼스가 없습니다. 다시 선택해 주시기 바랍니다.", "캠퍼스 선택 안내");
			return;
		}
		
		$("#consulting_campus").val($("input[name='campus']:checked").val());
		$('.reception_campus_popup_box, .popup_bg').fadeOut(350);
	}

	function directChoicedCheckBox(){
		if($("#checkbox_txtwrite").prop("checked") == false) {
			$('.cancel_direct_expert_box, .popup_bg').fadeIn(350);
		} 
		else {
			$("#delete_direct_expert").show();
			$("#add_direct_expert").show();
		}
	}

	function addChoicedExpert(){
		$("#custom_expert_list_body").show();

		var temp = $("#custom_expert_list_body tr").length;
		if ( $("#custom_expert_list_body tr").length >= 5) {
			showPopup("5명 이상은 선택할 수 없습니다.", "전문가 선택 안내");
			return;
		}
		
		var addStaffText = '<tr>' +
		'<td class="first"><input type="checkbox">&nbsp;<label for="checkbox3_1">&nbsp;</label></td>'+
		'<td><label for="" class="hidden">연구분야</label><textarea name="" id="" cols="30" rows="2" class="w100" ></textarea></td>'+
		'<td><label for="" class="hidden">성명</label><input type="text" id="" class="form-control w100" /></td>'+
		'<td><label for="" class="hidden">기관명</label><input type="text" id="" class="form-control w100" /></td>'+
		'<td><label for="" class="hidden">부서</label><input type="text" id="" class="form-control w100" /></td>'+
		'<td><label for="" class="hidden">휴대전화</label><select name="" id="" class="w_8 fl d_input ls"><option value="010">010</option></select><span class="fl mc8">-</span><label for="" class="hidden">전화</label><input type="tel" id="" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl" ><span class="fl mc8 ls">-</span><label for="" class="hidden">전화</label><input type="tel" id="" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl ls"></td>'+
		'<td class="last"><label for="" class="hidden">이메일</label><input type="text" id="" class="form-control w100 direct_companypart_email" placeholder="ex)XXX@email.com" /></td>' 
		+ '</tr>';
		
		$("#custom_expert_list_body").append(addStaffText);
	}

	function cancelDircetExpert() {
		$("#custom_expert_list_body").empty();
		$("#delete_direct_expert").hide();
		$("#add_direct_expert").hide();
		$('.cancel_direct_expert_box, .popup_bg').fadeOut(350);
	}
	
	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
		if ( isConfrimInstitution == true) {
			history.back();
		}
		
		if ( isRegistration == true) {
			location.href = "/member/fwd/reception/main";
		}
		$('.common_popup_box, .common_popup_box .popup_bg').fadeOut(350);
	}

	
</script>

<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />
<input type="hidden" id="process_status" name="process_status" value="" />
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>					
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>접수 (전문가 매칭)</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>접수</li>
						<li>접수</li>
					</ul>
				</div>
				<!--기관-->
				<div class="content_area copmpany_area" id="copmpany_area" >													
					<div class="table_area">
						<h4>기관 정보</h4>	
						<!--기관정보-->
						<table class="write fixed">
							<caption>기관 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody id="agency_information_body">
								<tr id="reg_no_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="reg_no">사업자 등록번호</label></span></th>
									<td><input disabled type="text" id="reg_no" title="사업자 등록번호" maxlength="3" class="form-control w_18 fl ls" placeholder="" /></td> 
								</tr>									  
								<tr id="company_name_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="company_name">기관명</label></span></th>
									<td><input disabled type="text" id="company_name" title="기관명" class="form-control w40" placeholder="" /></td>
								</tr>
								<tr id="company_address_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="company_address">주소</label></span></th>
									<td>
										<input disabled type="text" id="company_address" title="주소" class="form-control w100 fl mr5" placeholder="" />
										<!--button class="gray_btn fl">찾기</button-->
									</td> 
								</tr>
								<tr id="company_phone_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="company_phone">전화</label></span></th> 
									<td><input disabled type="tel" id="company_phone" title="전화" class="form-control w_20 fl ls" placeholder="" />
									</td>
								</tr>
								<tr id="representative_name_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="representative_name">대표자명</label></span></th> 
									<td><input disabled type="text" id="representative_name" title="대표자명" class="form-control w_20" placeholder="" /></td>
								</tr>
								<tr id="industry_type_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="industry_type">업종</label></span></th> 
									<td><input type="text" id="industry_type" title="업종" class="form-control w_40" /></td>
								</tr>
								<tr id="business_type_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="business_type">업태</label></span></th> 
									<td><input type="text" id="business_type" title="업태" class="form-control w_40" /></td>
								</tr>
								<tr id="foundation_date_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="foundation_date">설립일</label></span></th> 
									<td>
										<div class="datepicker_area fl mr5">
											<input type="text" id="foundation_date" title="설립일" class="datepicker form-control w_14 mr5 ls" />
										</div>
									</td> 
							   </tr>
							   <tr id="foundation_type_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="foundation_type">설립 구분</label></span></th> 
									<td><input type="text" id="foundation_type" title="설립 구분" class="form-control w_40" /></td> 
							   </tr>
							   <tr id="company_class_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="company_class">기업 분류</label></span></th> 
									<td><input type="text" id="company_class" title="기업 분류" class="form-control w_40" /></td> 
							   </tr>
							   <tr id="company_type_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="company_type">기업 유형</label></span></th> 
									<td><input type="text" id="company_type" title="기업 유형" class="form-control w_40" /></td> 
							   </tr>
							   <tr id="lab_exist_yn_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기업부설연구소 유무</span></th> 
									<td>
										<input type="radio" id="re_member_offerarea_class" name="lab_exist_yn_radio" value="Y" checked /> 
										<label for="re_member_offerarea_class">있음</label>
										<input type="radio" id="re_member_offerarea_class2" name="lab_exist_yn_radio" value="N" /> 
										<label for="re_member_offerarea_class2">없음</label>
									</td>
							   </tr>
							   <tr id="employee_no_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="employee_no">종업원수</label></span></th> 
									<td><input type="text" onkeyup="makeMoneyWithComma(this);" id="employee_no" title="종업원수" class="form-control w_18 fl mr5 ls won_comma" /><span class="fl mt10">(명)</span></td> 
							   </tr>
							   <tr id="total_sales_tr">
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="total_sales">자본금</label></span></th> 
									<td><input type="text" onkeyup="makeMoneyWithComma(this);" id="total_sales" title="매출액(최근3년)" class="form-control w_18 fl mr5 ls won_comma"  /><span class="fl mt10">(원)</span></td> 
							   </tr>
							   <tr id="capital_tr">
									<th scope="row">매출액(최근3년)</th> 
									<td>
										<div class="2018_box fl mr20">
											<label for="capital_1" class="hidden">2018년</label>
											<input type="text" onkeyup="makeMoneyWithComma(this);" id="capital_1" class="form-control w_18 fl mr5 ls won_comma" placeholder="입력"  />
											<span class="fl mt10">(원)</span>
										</div>
										<div class="2019_box fl mr20">
											<label for="capital_2" class="hidden">2019년</label>
											<input type="text" onkeyup="makeMoneyWithComma(this);" id="capital_2" class="form-control w_18 fl mr5 ls won_comma" placeholder="입력"  />
											<span class="fl mt10">(원)</span>
										</div>
										<div class="2020_box">
											<label for="capital_3" class="hidden">2020년</label>
											<input type="text" onkeyup="makeMoneyWithComma(this);" id="capital_3" class="form-control w_18 fl mr5 ls won_comma" placeholder="입력"  />
											<span class="fl mt10">(원)</span>
										</div>
									</td> 
							   </tr>
							</tbody>
				        </table>
						<!--//기관정보-->								    
						
						<!--연구책임자 정보-->
						<h4>연구책임자 정보</h4>		
						<span>
							<input type="checkbox" id="companyinfo_check" onclick="writeReserchInfo();">
							<label for="companyinfo_check">개인정보와 동일</label>
						</span>
					    <table class="write fixed company_d">
							<caption>연구책임자 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>
								<tr id="research_name_tr">
								    <th scope="row">
								    	<span class="icon_box"><span class="necessary_icon">*</span>
								    	<label for="research_name">성명</label></span>
								    </th>
								    <td>
								    	<input type="text" id="research_name" title="성명" class="form-control w_20" placeholder="" />
							    	</td> 
							    </tr>
								<tr id="mobile_phone_tr">
								    <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="mobile_phone_selector">휴대전화</label></span></th>
								    <td>
										<select name="company_reception_phone" id="mobile_phone_selector" class="w_8 fl d_input ls">
											<option value="010">010</option>
										</select>
										<span style="display:block;" class="fl mc8">-</span>
										<label for="mobile_phone_2" class="hidden">휴대전화</label>
										<input type="tel" id="mobile_phone_2" title="휴대전화" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" placeholder="">
										<span style="display:block;" class="fl mc8">-</span>
										<label for="mobile_phone_3" class="hidden">휴대전화</label>
										<input type="tel" id="mobile_phone_3" title="휴대전화" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" placeholder="">
									</td> 
							    </tr>
							    <tr id="email_tr">
								    <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="email_1">이메일</label></span></th>
								    <td>
									    <input type="text" title="이메일" name="email_1" id="email_1" class="form-control w_20 fl ls" placeholder="" />
									    <span class="fl ml1 mr1 pt10 mail_f">@</span>
									    <label for="email_2" class="hidden">이메일</label>
									    <input type="text" title="이메일" name="email_2" id="email_2" class="form-control w_18 fl ls" placeholder="" disabled  />	
									    <label for="selectEmail" class="hidden">이메일</label>
										<select name="selectEmail" id="selectEmail" class="fl ml5 in_wp200 ace-select d_input"> 
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
							    <tr id="research_address_tr">
								    <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
										<label for="research_address">주소</label><label for="research_address_detail" class="hidden">주소</label></span></th> 
									<td>
										<input disabled type="text" id="research_address" title="주소" class="form-control w50 fl  mr5" placeholder="" />
										<input type="text" id="research_address_detail" title="주소" class="form-control w30 fl mr5" placeholder="" />
										<button type="button" class="gray_btn2 fl d_input address_search" onclick="execPostCode('research_address');">검색</button>
									</td>
							    </tr>
							</tbody>						 
						</table>
	
						<p class="mt30 mb10"><span class="font_blue">(선택)</span> 소속기관이 있는경우 입력해주세요.</p>
						<table class="write fixed">
							<caption>연구책임자 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>		
								<tr id="research_institution_name_tr">
									<th scope="row"><span class="icon_box"><label for="research_institution_name">기관명</label></span></th>
									<td class="clearfix">
									   <input type="text" id="research_institution_name" class="form-control w100 fl" />  
									</td>
								</tr>
								<tr id="research_institution_department_tr">
									<th scope="row"><span class="icon_box"><label for="research_institution_department">부서</label></span></th>
									<td class="clearfix">
									   <input type="text" id="research_institution_department" class="form-control w_20 fl" /> 
									</td>
								</tr>
								<tr id="research_institution_position_tr">
									<th scope="row"><span class="icon_box"><label for="research_institution_position">직책</label></span></th>
									<td class="clearfix">
									   <input type="text" id="research_institution_position" class="form-control w_20 fl" />  
									</td>
								</tr>
						    </tbody>						 
						</table>
						<!--//연구책임자 정보-->
						
	
						<!--기술컨설팅 - 기술컨설팅 요청사항-->
						<h4 class="fl sub_title_h4">기술컨설팅 요청사항</h4>							  
					    <table class="write fixed">
						   <caption>기술컨설팅 요청사항</caption> 
						   <colgroup>
							   <col style="width: 20%">
							   <col style="width: 80%">
						   </colgroup>
						   <tbody>
							   <tr id="consulting_type_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>구분</span></th>
								   <td>
										<input type="radio" id="con_reception_class" class="con_reception_class" name="con_reception_class_g" value="기술애로 컨설팅" checked /> 
										<label for="con_reception_class">기술애로 컨설팅</label>
										<input type="radio" id="rnd_reception_class" class="rnd_reception_class" name="con_reception_class_g" value="R&D기획 컨설팅" /> 
										<label for="rnd_reception_class">R&D기획 컨설팅</label>
									</td>
							   </tr>								   
							   <tr id="consulting_campus_tr">
								   	<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="consulting_campus">소속 캠퍼스타운</label></span></th>
								   	<td>
								   		<input type="text" id="consulting_campus" class="form-control w90 fl mr5" title="소속 캠퍼스타운"/>
								   		<button type="button" class="gray_btn2 fl reception_campus_popup_open">찾아보기</button> 
				   					</td>
							   </tr>
							   <tr id="national_science_large_tr">
								   <th scope="row" rowspan="3"><span class="icon_box"><span class="necessary_icon">*</span>국가과학기술분류</span></th>
								   <td>
										<label for="large_selector" class="fl mt5 mr5">대분류</label>
										<select name="large_selector" id="large_selector" class="ace-select" style="width: 94.8%;"></select>
								   </td>
							   </tr>
							   <tr id="national_science_middle_tr">
								   <td>
									   <label for="middle_selector" class="fl mt5 mr5">중분류</label>
									   <select name="middle_selector" id="middle_selector" class="ace-select" style="width: 94.8%;"></select>
								   </td>
							   </tr>
							   <tr id="national_science_small_tr">
								   <td>
									   <label for="small_selector" class="fl mt5 mr5">소분류</label>
									   <select name="small_selector" id="small_selector" class="ace-select" style="width: 94.8%;"></select>
								 </td>
							   </tr>
							   <tr id="4th_industry_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="4th_industry_selector">4차 산업혁명 기술분류</label></span></th>
								   <td>
										<select name="4th_industry_selector" id="4th_industry_selector" class="w20 ace-select"></select>
									</td> 
							   </tr>
							   <tr id="consulting_purpose_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>컨설팅 목적</span></th>
								   <td>
									   <span><input type="radio" id="con_purpose1" class="fl" name="con_radio_check" value="1. 기업의 기술혁신 역량 강화를 위한 총체적인 기술컨설팅" />
									   <label for="con_purpose1" class="fl">1. 기업의 기술혁신 역량 강화를 위한 총체적인 기술컨설팅</label></span><br /><br />
									   <span><input type="radio" id="con_purpose2" class="fl" name="con_radio_check" value="2. 기술기획 및 신제품 아이디어 제공 동의 기술컨설팅" />
									   <label for="con_purpose2" class="fl">2. 기술기획 및 신제품 아이디어 제공 동의 기술컨설팅</label></span><br /><br />
									   <span><input type="radio" id="con_purpose3" class="fl" name="con_radio_check" value="3. 단기 애로기술 해결 및 기술개발" />
									   <label for="con_purpose3" class="fl">3. 단기 애로기술 해결 및 기술개발</label></span><br /><br />
									   <span><input type="radio" id="con_purpose4" class="fl" name="con_radio_check" value="4. 공정자동화 등에 대한 기술컨설팅" />
									   <label for="con_purpose4" class="fl">4. 공정자동화 등에 대한 기술컨설팅</label></span><br /><br />
									   <span><input type="radio" id="con_purpose5" class="fl" name="con_radio_check" value="5. 품질향상, 공정개선에 관한 기술컨설팅" />
									   <label for="con_purpose5" class="fl">5. 품질향상, 공정개선에 관한 기술컨설팅</label></span><br /><br />
									   <span><input type="radio" id="con_purpose6" class="fl" name="con_radio_check" value="6. 국내의 정책·기술·시장· 동향 및 애로기술 관련 기초정보 제공" />
									   <label for="con_purpose6" class="fl">6. 국내의 정책·기술·시장· 동향 및 애로기술 관련 기초정보 제공</label></span><br /><br />
									   <span><input type="radio" id="con_purpose7" class="fl" name="con_radio_check" value="7. 기술연구개발 기획을 위한 R&D 컨설팅" />
									   <label for="con_purpose7" class="fl">7. 기술연구개발 기획을 위한 R&amp;D 컨설팅</label></span><br /><br />
									   <span><input type="radio" id="con_purpose8" class="fl outside_check" name="con_radio_check" value="8. 기타" />
									   <label for="con_purpose8">8. 기타</label><br />
									   <label for="con_purpose8_comment" class="hidden">8. 기타</label>
									   <input type="text" class="w100 form-control" id="con_purpose8_comment" disabled /></span>
								   </td>
							   </tr>							   	   
						   </tbody>
					    </table>
						<!--//기술컨설팅 - 기술컨설팅 요청사항-->
	
						<!--기술컨설팅 - 기술정보-->
						<h4>기술 정보</h4>	
						<table class="write fixed research_tabel_">
							<caption>기술 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>
								<tr id="sevice_name_tr">
								    <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="sevice_name">제품/서비스명</label></span></th>
								    <td><input type="text" id="sevice_name" class="form-control w100" title="제품/서비스명"/></td> 
							    </tr>
								<tr id="sevice_description_tr">
								    <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="sevice_description">제품/서비스 내용</label></span></th>
								    <td><input type="text" id="sevice_description" class="form-control w100" title="제품/서비스 내용"/></td> 
							    </tr>
							    <tr id="sevice_content_tr">
								    <th scope="row">
										<div class="charge_con">
											<span class="icon_box"><span class="necessary_icon">*</span><label for="reception_problems_text">기술애로사항</label></span>
										</div>
										<div class="charge_rnd" style="display: none;">
											<span class="icon_box"><span class="necessary_icon">*</span><label for="reception_rnd_text">기술연구개발 내용</label></span>
										</div>
									</th>
								    <td>
										<div class="charge_con">
											<input type="text" class="form-control w100" id="reception_problems_text" title="기술애로사항" placeholder="기술애로사항(또는 제품/서비스) 내용을 파악할 수 있도록 상세하게 입력" /> 
										</div>
										<div class="charge_rnd" style="display: none;">
											<input type="text" class="form-control w100" id="reception_rnd_text" title="기술연구개발 내용" placeholder="기술연구개발 내용을 파악할 수 있도록 상세하게 입력" />		
										</div>
									</td> 
							    </tr>
								<tr id="sevice_request_tr">
								    <th scope="row">
										<div class="charge_con">
											<span class="icon_box"><span class="necessary_icon">*</span><label for="reception_conrequest_text">컨설팅 요청사항</label></span>
										</div>
										<div class="charge_rnd" style="display: none;">
											<span class="icon_box"><span class="necessary_icon">*</span><label for="reception_rndrequest_text">전문가 요청사항</label></span>
										</div>
									</th>
								    <td>
										<div class="charge_con">
											<input type="text" class="form-control w100" id="reception_conrequest_text" title="컨설팅 요청사항" placeholder="컨설팅 요청사항을 파악할 수 있도록 상세하게 입력" />	
										</div>
										<div class="charge_rnd" style="display: none;">
											<input type="text" class="form-control w100" id="reception_rndrequest_text" title="전문가 요청사항" placeholder="전문가 요청사항을 파악할 수 있도록 상세하게 입력" />	
										</div>
									</td> 
							    </tr>										
								<tr id="sevice_research_tr">
								    <th scope="row"><span class="icon_box"><label for="reception_get_class">첨부 파일</label></span></th>
								    <td>
								    	<div class="clearfix file_form_txt">													   
										   <!--업로드 버튼-->
										   <div class="job_file_upload w100"> 
												<div class="custom-file w100">
													<input type="file" class="custom-file-input custom-file-input-write-company" id="service_upload_file">
													<label class="custom-file-label custom-control-label-write-company" for="service_upload_file">선택된 파일 없음</label>
												</div>															
										   </div>													   
										   <!--//업로드 버튼-->
									    </div>
									</td>  
							    </tr>
							 </tbody>						 
						</table>
						<!--//기술컨설팅 - 기술정보-->
	
						<!--전문가 검색-->
						<div class="clearfix">
								<h4 class="fl">전문가 검색</h4>
								<span class="fl mt60" style="display:inline-block;">&nbsp;&nbsp;(최대 5명까지 선택할 수 있습니다.)</span>
						</div>
					    <table class="write fixed expert_search_table">
						   <caption>전문가 검색</caption> 
						   <colgroup>
							   <col style="width: 20%">
							   <col style="width: 80%">
						   </colgroup>
						   <tbody>
							   <tr>
								   <th scope="row" rowspan="3"><span class="icon_box">국가과학기술분류</span></th>
								   <td>
										<label for="expert_large_selector" class="fl mt5 mr5">대분류</label>
										<select name="expert_large_selector" id="expert_large_selector" class="ace-select" style="width: 94.8%;">
										</select>
								   </td>
							   </tr>								   
							   <tr>
								   <td>
									   <label for="expert_middle_selector" class="fl mt5 mr5">중분류</label>
									   <select name="expert_middle_selector" id="expert_middle_selector" class="ace-select" style="width: 94.8%;">
									   </select>
								   </td>
							   </tr>
							   <tr>
								   <td>
									   <label for="expert_small_selector" class="fl mt5 mr5">소분류</label>
									   <select name="expert_small_selector" id="expert_small_selector" class="ace-select" style="width: 94.8%;">
									   </select>
								 </td>
							   </tr>										   
							   <tr>
								   <th scope="row"><span class="icon_box"><label for="expert_research">연구 분야</label></span></th>
								   <td>
										<textarea name="expert_research" id="expert_research" cols="30" rows="2" class="w100"></textarea>
								   </td> 
							   </tr>
							   <tr>
								   <th scope="row"><span class="icon_box"><label for="expert_name">성명</label></span></th>
								   <td>
										<input type="text" class="w_20 form-control" id="expert_name" />
								   </td> 
							   </tr>
							   <tr>
								   <th scope="row"><span class="icon_box"><label for="expert_institution_name">기관명</label></span></th>
								   <td>
										<input type="text" class="w100 form-control" id="expert_institution_name" />
								   </td> 
							   </tr>
						   </tbody>
					    </table>
						
						<div class="clearfix">
							<button type="button" onclick="searchExpert(1);" class="blue_btn mt10 w100" style="padding: 26px 0; font-weight: 500; font-size: 20px;height: auto;" title="검색">검색</button>
						</div>
						
						<div class="table_count_area mt50 clearfix">
							<div class="count_area fl mt5" id="total_count" style="padding-top: 20px;">
								[총 <span class="fw500 font_blue">0</span>건]
							</div>
							<div class="fr">
								<button type="button" class="blue_btn2 fr mr5 mt5 mb5" onclick="choiceExpert();">선택</button>
							</div>
						</div>
	
						<!--리스트시작-->
						<div class="table_area">										
							<table class="list fixed expert_table">
								<caption>전문가 목록</caption>
								<colgroup>
									<col style="width: 5%;">
									<col style="width: 25%;">
									<col style="width: 18%;">
									<col style="width: 5%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
									<col style="width: 12%;">
									<col style="width: 15%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col" class="first"></th>
										<th scope="col">국가과학기술분류</th>
										<th scope="col">연구분야</th>
										<th scope="col">성명</th>
										<th scope="col">기관명</th>
										<th scope="col">부서</th>
										<th scope="col">휴대전화</th>
										<th scope="col" class="last">이메일</th>
									</tr>
								</thead>
								<tbody id="expert_list_body">
								</tbody>
							</table>
							<!--div class="data_null ta_c">해당 조건에 맞는 전문가 검색 결과가 없습니다.</div-->
						   	<input type="hidden" id="pageIndex" name="pageIndex"/>
							<div class="paging_area" id="pageNavi">
							</div>
						</div>
						<!--//리스트 end-->
	
						<!--희망전문가-->
						<div class="table_area clearfix">
							<div class="clearfix">
								<h4 class="fl">희망 전문가</h4>
								<span class="fl mt60" style="display:inline-block;">&nbsp;&nbsp;(위의 전문가 검색 후 선택하면 자동으로 입력됩니다.)</span>
							</div>
							<p class="mt30 fl"> - 원할한 매칭을 위해 <span class="font_blue">최소 3인</span> 이상의 매칭을 권장합니다.</p>
							<button type="button" class="gray_btn fr mt20 mb10" onclick="deleteExpert();">삭제</button>
							<table class="list fixed expert_hope_search_table mt10">
								<caption>희망 전문가 목록</caption>
								<colgroup>
									<col style="width: 5%;">
									<col style="width: 25%;">
									<col style="width: 18%;">
									<col style="width: 5%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
									<col style="width: 12%;">
									<col style="width: 15%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col" class="first">&nbsp;</th>
										<th scope="col">국가과학기술분류</th>
										<th scope="col">연구분야</th>
										<th scope="col">성명</th>
										<th scope="col">기관명</th>
										<th scope="col">부서</th>
										<th scope="col">휴대전화</th>
										<th scope="col" class="last">이메일</th>
									</tr>
								</thead>
								<tbody id="choiced_expert_list_body">
								</tbody>											
							</table>
							
							<!--직접입력-->
							<div class="clearfix fl mt10">
								<input type="checkbox" id="checkbox_txtwrite" onclick="directChoicedCheckBox();"/>
								<label for="checkbox_txtwrite">직접입력 (검색 목록에 없을 경우 <span class="font_blue">직접 입력</span>해 주세요.)</label>
							</div>
							<div class="fr clearfix">
								<button type="button" class="fl green_btn mb10 mt10 mr5" id="add_direct_expert" style="display:none" onclick="addChoicedExpert();">추가</button>
								<button type="button" class="fl gray_btn mb10 mt10" id="delete_direct_expert" style="display:none" onclick="initChoicedExpert();">삭제</button>
							</div>
							<div class="box_table">
								<table class="list fixed expert_hope_search_table2 mt10 expert_input_table mb20">
									<caption>희망 전문가 직접입력 목록</caption>
									<colgroup>
										<col style="width: 5%;">
										<col style="width: 17%;">
										<col style="width: 8%;">
										<col style="width: 15%;">
										<col style="width: 10%;">
										<col style="width: 18%;">
										<col style="width: 12%;">
									</colgroup>
									<thead>
										<tr>
											<th scope="col" class="first">&nbsp;</th>													
											<th scope="col">연구분야</th>
											<th scope="col">성명</th>
											<th scope="col">기관명</th>
											<th scope="col">부서</th>
											<th scope="col">휴대전화</th>
											<th scope="col" class="last">이메일</th>
										</tr>
									</thead>
									<tbody id="custom_expert_list_body">
									</tbody>											
								</table>
							</div>
						</div>
						<!--//희망전문가-->
						<div class="button_box clearfix fr pb20">
							<button type="button" class="purple_btn fl mr5" onclick="createSelfCheckList();">셀프 체크리스트</button>
							<button type="button" class="blue_btn2 fl mr5 openLayer5" onclick="prepareRegistration('D0000003');">임시저장</button>
							<button type="button" class="blue_btn fl mr5" onclick="prepareRegistration('D0000004');">전문가신청완료</button>
							<button type="button" class="gray_btn fl" onclick="location.href='/member/fwd/reception/main'">목록</button>
						</div>
					</div>	<!--//table_area-->							
				</div><!--//content_area-->
				<!--//기관-->
			</div>
		</div><!--//sub_contents-->
	</section>
</div>


<div class="attachments_popup_box">		
	<div class="popup_bg"></div>
	<div class="attachments_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">첨부파일 미첨부 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">(필수서류 미첨부) </span>필수 입력 값입니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn lastClose layerClose">확인</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//필수서류 미첨부 팝업-->
<!--제출하기 팝업-->
<div class="reception_complete_popup_box">		
	<div class="popup_bg"></div>
	<div class="reception_complete_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">접수 제출 안내</h4>							
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<span class="popup_titlebox_title">2021년 기술제안 사업 전문가 선정 신청서 제출 </span>
			<div class="popup_titlebox_txt">
				<p><span class="font_blue">[예]</span> 버튼을 누르면 전문가 선정 신청서 제출이 완료되며, 수정은 불가능합니다.</p>							
				<p>제출 완료 후에는 담당자가 희망하신 전문가의 참여 의향을 	확인하고 결과를 통보해 드립니다.</p>
				<p class="font_blue fz_b"><span class="fw500 font_blue">전문가 선정 신청서를 제출하시겠습니까?</span></p>
				<p>- 귀한 시간 내주셔서 감사드립니다. -</p>
			</div>
		    <div class="popup_button_area_center">
				<button type="submit" class="blue_btn mr5" onclick="registration('D0000004');">예</button>
				<button type="button" class="gray_btn lastClose layerClose popup_close_btn">아니요</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//제출하기 팝업-->

<!--셀페체크리스트항목 팝업-->
<div class="selfchecklist_popup_box">		
	<div class="popup_bg"></div>
	<div class="selfchecklist_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">셀프체크리스트 항목</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<h4 class="popup_txt_title">신청사항 또는 가점사항</h4>
			<div class="table_area">
				<table class="list fixed">
					<caption>신청사항 또는 가점사항</caption>
					<colgroup>
						<col style="width: 81%;">																		
						<col style="width: 19%;">
					</colgroup>
					<thead>
					<tr>
						<th scope="col" class="first">질문</th>
						<th scope="col" class="last">선택</th>
					</tr>
					</thead>
					<tbody id="self_check_list_body">
					</tbody>
				</table>
				
			</div>						
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn" onclick="completeCheckList();">완료</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//셀페체크리스트항목 팝업-->
<!--셀프체크리스트 팝업 경고창 팝업-->
<div class="selfchecklistnecessary_warning_popup_box">		
	<div class="popup_bg"></div>
	<div class="selfchecklistnecessary_warning_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">항목 미체크 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0">체크 하지 않은 항목이 있습니다.<br /><span class="font_blue">모두 체크해주세요.</span></p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn popup_close_btn">확인</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//셀프체크리스트 팝업 경고창 팝업-->
<!--소속 캠퍼스타운 팝업-->
<div class="reception_campus_popup_box">		
	<div class="popup_bg"></div>
	<div class="reception_campus_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">소속 캠퍼스타운</h4>							
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">						
			<div class="popup_titlebox_txt">
				<ul class="clearfix" id="campus_list_ul"></ul>
			</div>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5" onclick="selectCampus();">선택</button>
				<button type="button" class="gray_btn lastClose layerClose popup_close_btn">닫기</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//소속 캠퍼스타운 팝업-->

<!--전문가 정보 팝업-->
<div class="reception_expert_popup_box">		
	<div class="popup_bg"></div>
	<div class="reception_expert_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">전문가 정보</h4>							
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">						
			<div class="popup_titlebox_txt">
				<div class="table_area">
					<table class="write fixed">
						<caption>개인 정보</caption>
						<colgroup>
							<col style="width: 20%;">
							<col style="width: 80%;">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">성명</th>
								<td id="expert_detail_name"></td> 
							</tr>									  
							<tr>
								<th scope="row">기관명(학교)</th>
								<td id="expert_detail_institution_name"></td> 
							</tr>
							<tr>
								<th scope="row">부서(학과)</th>
								<td id="expert_detail_department"></td> 
							</tr>
							<tr>
								<th scope="row">휴대전화</th>
								<td id="expert_detail_mobile_phone"></td> 
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td id="expert_detail_email"></td> 
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td id="expert_detail_address"></td> 
							</tr>										
						</tbody>
					</table>

					<h4 class="sub_title_h4">기술분류 및 연구분야</h4>
					<table class="write fixed">
						<caption>기술분류 및 연구분야</caption>
						<colgroup>
							<col style="width: 20%;">
							<col style="width: 80%;">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">국가과학기술분류</th>
								<td id="expert_detail_national_science"></td> 
							</tr>									  
							<tr>
								<th scope="row">4차산업기술분류</th>
								<td id="expert_detail_4th_industry"><span>빅데이터</span></td> 
							</tr>
							<tr>
								<th scope="row">연구분야</th>
								<td id="expert_detail_research"><span>빅데이터, 데이터, 빅</span></td> 
							</tr>																		
						</tbody>
					</table>

					<h4 class="sub_title_h4">논문/저서</h4>
					<table class="list fixed">
						<caption>논문/저서</caption>
						<colgroup>
							<col style="width: 50%;">
							<col style="width: 25%;">
							<col style="width: 15%;">
							<col style="width: 10%;">
						</colgroup>
						<thead>
							<tr>
								<th scope="col" class="first">논문/저자명</th>
								<th scope="col">학술지명</th>
								<th scope="col">발행일자</th>											
								<th scope="col" class="last">SCI 여부</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="first" id="thesis_1"></td>
								<td id="thesis_name_1" ></td>
								<td id="thesis_date_1"></td>											
								<td class="last">
									<input type="checkbox" id="treatise_check1" disabled />
									<label for="treatise_check1" >SCI</label>
								</td>
							</tr>
							<tr>
								<td class="first" id="thesis_2"></td>
								<td id="thesis_name_2"></td>
								<td id="thesis_date_2"></td>											
								<td class="last">
									<input type="checkbox" id="treatise_check2" disabled />
									<label for="treatise_check2">SCI</label>
								</td>
							</tr>
							<tr>
								<td class="first" id="thesis_3"></td>
								<td id="thesis_name_3"></td>
								<td id="thesis_date_3"></td>											
								<td class="last">
									<input type="checkbox" id="treatise_check3" disabled />
									<label for="treatise_check3">SCI</label>
								</td>
							</tr>
						</tbody>
					</table>

					<h4 class="sub_title_h4">지식재산권</h4>
					<table class="list fixed">
						<caption>지식재산권</caption>
						<colgroup>
							<col style="width: 10%;">
							<col style="width: 50%;">
							<col style="width: 15%;">
							<col style="width: 10%;">
							<col style="width: 15%;">
						</colgroup>
						<thead>
							<tr>
								<th scope="col" class="first">출원.등록</th>
								<th scope="col">특허명</th>
								<th scope="col">출원번호/등록번호</th>	
								<th scope="col">출원인</th>	
								<th scope="col" class="last">출원일/등록일</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="first" id="iprs_enroll_1"></td>
								<td id="iprs_1"></td>
								<td id="iprs_number_1"></td>
								<td id="iprs_name_1"></td>
								<td class="last" id="iprs_date_1"></td>
							</tr>
							<tr>
								<td class="first" id="iprs_enroll_2"></td>
								<td id="iprs_2"></td>
								<td id="iprs_number_2"></td>
								<td id="iprs_name_2"></td>
								<td class="last" id="iprs_date_2"></td>
							</tr>
							<tr>
								<td class="first" id="iprs_enroll_3"></td>
								<td id="iprs_3"></td>
								<td id="iprs_number_3"></td>
								<td id="iprs_name_3"></td>
								<td class="last" id="iprs_date_3"></td>
							</tr>
						</tbody>
					</table>

					<h4 class="sub_title_h4">기술이전</h4>
					<table class="list fixed">
						<caption>기술이전</caption>
						<colgroup>
							<col style="width: 65%;">
							<col style="width: 15%;">
							<col style="width: 20%;">							
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
								<td class="first" id="tech_tran_name_1"></td>											
								<td id="tech_tran_date_1"></td>
								<td class="last" id="tech_tran_company_1"></td>
							</tr>
							<tr>
								<td class="first" id="tech_tran_name_2"></td>											
								<td id="tech_tran_date_2"></td>
								<td class="last" id="tech_tran_company_2"></td>
							</tr>
							<tr>
								<td class="first" id="tech_tran_name_3"></td>											
								<td id="tech_tran_date_3"></td>
								<td class="last" id="tech_tran_company_3"></td>
							</tr>
						</tbody>
					</table>

					<h4 class="sub_title_h4">R&D과제</h4>
					<table class="list fixed">
						<caption>R&D과제</caption>
						<colgroup>
							<col style="width: 40%;">
							<col style="width: 20%;">
							<col style="width: 20%;">	
							<col style="width: 20%;">
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
								<td class="first" id="rnd_name_1"></td>											
								<td id="rnd_date_1"></td>
								<td id="rnd_class_1"></td>
								<td class="last" id="rnd_4th_industry_1"></td>
							</tr>
							<tr>
								<td class="first" id="rnd_name_2"></td>											
								<td id="rnd_date_2"></td>
								<td id="rnd_class_2"></td>
								<td class="last" id="rnd_4th_industry_2"></td>
							</tr>
							<tr>
								<td class="first" id="rnd_name_3"></td>											
								<td id="rnd_date_3"></td>
								<td id="rnd_class_3"></td>
								<td class="last" id="rnd_4th_industry_3"></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		    <div class="popup_button_area_center">							
				<button type="button" class="gray_btn lastClose layerClose popup_close_btn">닫기</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//전문가 정보 팝업-->

<div class="temp_save_box" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 10000; display: none;">
	<div class="popup_bg"></div>
	<div class="save_popup2_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">임시저장 안내</h4>							
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">						
			<p tabindex="0"><span class="font_blue">임시저장</span> 하시겠습니까?</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5" onclick="registration('D0000003');">저장</button>
				<button type="button" class="gray_btn popup_close_btn">취소</button>
			</div>	
		</div>									
	</div> 
</div>

<div class="matching_save_box" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 10000; display: none;">		
	<div class="popup_bg"></div>
	<div class="save_popup2_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">매칭신청 안내</h4>							
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">						
			<p tabindex="0"><span class="font_blue">매칭 신청</span> 하시겠습니까?</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5" onclick="registration('D0000004');">신청</button>
				<button type="button" class="gray_btn popup_close_btn" onclick="$('.matching_save_box, .popup_bg').fadeOut(350);">취소</button>
			</div>	
		</div>									
	</div> 
</div>


<!--임시저장 팝업-->
<div class="save_popup2_box">		
	<div class="popup_bg"></div>
	<div class="save_popup2_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">임시저장 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">임시저장</span> 되었습니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn popup_close_btn">닫기</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//임시저장 팝업-->

<!--접수완료 팝업-->
<div class="save_popup_box">		
	<div class="popup_bg"></div>
	<div class="save_popup_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">접수완료 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">접수완료</span> 되었습니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn popup_close_btn">닫기</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//접수완료 팝업-->

<!--매칭신청완료 팝업-->
<div class="machhing_save_popup_box">		
	<div class="popup_bg"></div>
	<div class="machhing_save_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">매칭신청 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">매칭신청 완료</span> 되었습니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn popup_close_btn">닫기</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//매칭신청완료 팝업-->

<div class="cancel_direct_expert_box" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 10000; display: none;">		
	<div class="popup_bg"></div>
	<div class="save_popup2_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">희망전문가 안내</h4>							
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">						
			<p tabindex="0">직접 입력 희망전문가 작성을 취소하시겠습니까?<br>
							확인 시 작성한 희망전문가 정보가 삭제 됩니다.
			</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5" onclick="cancelDircetExpert();">확인</button>
				<button type="button" class="gray_btn popup_close_btn" onclick="$('.cancel_direct_expert_box, .popup_bg').fadeOut(350);$('#checkbox_txtwrite').prop('checked', true)">취소</button>
			</div>	
		</div>									
	</div> 
</div>


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