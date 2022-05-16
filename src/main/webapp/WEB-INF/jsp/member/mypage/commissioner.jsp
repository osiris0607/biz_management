<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var isModification = false;
	
	$(document).ready(function() {
		// email Select
	 	$("#selectEmail").change(function(){
	 		if ( $("#selectEmail").val() == "1" ) {
				$("#email_02").attr("disabled", false);
				$("#email_02").val("");
			}
			else {
				$("#email_02").attr("disabled", true);
				if ( $("#selectEmail").val() != "0" ) {
					$("#email_02").val($("#selectEmail").val());
				}
				else {
					$("#email_02").val("");
				}
			}
		});		

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

	 	initDepratmentType();
		searchMemberDetail();
		searchInstitutionDetail();
		searchDetail();	
		
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

	// 소속 유형를 만든다.
	function initDepratmentType(){
		$("#depratment_type").empty();

		var index = 1;
		var str = "";
       	<c:forEach items="${commonCode}" var="code">
			<c:if test="${code.master_id == 'M0000004'}">
				if (index == 1) {
					str += "<input type='radio' id='department_type_radio' name='department_type' value='${code.detail_id}' checked >";
				}
				else {
					str += "<input type='radio' id='department_type_radio' name='department_type' value='${code.detail_id}'>";
				}
				
				str += "<label for='department_type_radio'>${code.name}</label>";
				index++;
			</c:if>
		</c:forEach>
		$("#depratment_type").append(str);
	}

	function searchMemberDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/detail'/>");
		comAjax.setCallback(getMemberDetailCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.ajax();
	}

	var memberInfo;
	function getMemberDetailCB(data){
		memberInfo = data.result;
		$("#name").html("<span>" + data.result.name + "</span>") ;
		$("#mobile_phone").html(data.result.mobile_phone);
		$("#email").html(data.result.email);
		$("#address").html(data.result.address + " " + data.result.address_detail) ;
	}

	function searchInstitutionDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/institution/detail'/>");
		comAjax.setCallback(getInstitutionDetailCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.ajax();
	}
	
	function getInstitutionDetailCB(data){
		$("#institution_type").html("<span>" + data.result.type_name + "</span>");
		$("#institution_name").html("<span>" + data.result.name +" </span>");
		$("#institution_address").html("<span class='fl'>" + data.result.address +"</span> <span class='fl ls'>" + data.result.address_detail + "</span>");
		$("#institution_phone").html("<span>" + data.result.phone + "</span>");
		$("#institution_depart").html("<span>" + memberInfo.department + "</span>");
		$("#institution_position").html("<span>" + memberInfo.position + "</span>");
	}

	
	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/commissioner/search/detail'/>");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.ajax();
	}

	var detailCommissioner = "";
	function searchDetailCB(data){
		detailCommissioner = data.result_data;

		
		$("#bank_name").val(data.result_data.bank_name) ;
		$("#bank_account").val(data.result_data.bank_account) ;

		
		$("#tech_info_large").val(data.result_data.national_skill_large).trigger('change');
		
		$("#tech_info_middle").val(data.result_data.national_skill_middle).trigger('change') ;
		$("#tech_info_small").val(data.result_data.national_skill_small) ;
		$("#tech_info_4th_industry").val(data.result_data.four_industry) ;
		$("#rnd_class").val(data.result_data.rnd_class) ;

		// 학력
		$("#degree_01").val(data.result_data.degree_01) ;
		$("#degree_school_01").val(data.result_data.degree_school_01) ;
		$("#degree_major_01").val(data.result_data.degree_major_01) ;
		$("#degree_date_01").val(data.result_data.degree_date_01) ;
		if ( gfn_isNull(data.result_data.degree_certificate_file_name_01) == false ) {
			$("#upload_name1").html("<a href='/member/api/mypage/commissioner/download/"+ data.result_data.degree_certificate_file_id_01 +"' download class='down_btn'>" + data.result_data.degree_certificate_file_name_01 + "</a>");
		}
		
		$("#degree_02").val(data.result_data.degree_02) ;
		$("#degree_school_02").val(data.result_data.degree_school_02) ;
		$("#degree_major_02").val(data.result_data.degree_major_02) ;
		$("#degree_date_02").val(data.result_data.degree_date_02) ;
		if ( gfn_isNull(data.result_data.degree_certificate_file_name_02) == false ) {
			$("#upload_name2").html("<a href='/member/api/mypage/commissioner/download/"+ data.result_data.degree_certificate_file_id_02 +"' download class='down_btn'>" + data.result_data.degree_certificate_file_name_02 + "</a>");
		}
		
  		// 경력
  		$("#career_company_01").val(data.result_data.career_company_01) ;
  		$("#career_depart_01").val(data.result_data.career_depart_01) ;
  		$("#career_position_01").val(data.result_data.career_position_01) ;
  		temp = data.result_data.career_start_date_01.split("-");
  		$("#join_day").val(temp[0]) ;
  		$("#join_day1_2").val(temp[1]) ;
  		temp = data.result_data.career_retire_date_01.split("-");
  		$("#leave_day").val(temp[0]) ;
  		$("#leave_day1_2").val(temp[1]) ;
  		$("#career_description_01").val(data.result_data.career_description_01) ;

  		$("#career_company_02").val(data.result_data.career_company_02) ;
  		$("#career_depart_02").val(data.result_data.career_depart_02) ;
  		$("#career_position_02").val(data.result_data.career_position_02) ;
  		temp = data.result_data.career_start_date_02.split("-");
  		$("#join_day2").val(temp[0]) ;
  		$("#join_day2_2").val(temp[1]) ;
  		temp = data.result_data.career_retire_date_02.split("-");
  		$("#leave_day2").val(temp[0]) ;
  		$("#leave_day2_2").val(temp[1]) ;
  		$("#career_description_02").val(data.result_data.career_description_02) ;
  		
  		$("#career_company_03").val(data.result_data.career_company_03) ;
  		$("#career_depart_03").val(data.result_data.career_depart_03) ;
  		$("#career_position_03").val(data.result_data.career_position_03) ;
  		temp = data.result_data.career_start_date_03.split("-");
  		$("#join_day3").val(temp[0]) ;
  		$("#join_day3_2").val(temp[1]) ;
  		temp = data.result_data.career_retire_date_03.split("-");
  		$("#leave_day3").val(temp[0]) ;
  		$("#leave_day3_2").val(temp[1]) ;
  		$("#career_description_03").val(data.result_data.career_description_03) ;

  		$("#career_company_04").val(data.result_data.career_company_04) ;
  		$("#career_depart_04").val(data.result_data.career_depart_04) ;
  		$("#career_position_04").val(data.result_data.career_position_04) ;
  		temp = data.result_data.career_start_date_04.split("-");
  		$("#join_day4").val(temp[0]) ;
  		$("#join_day4_2").val(temp[1]) ;
  		temp = data.result_data.career_retire_date_04.split("-");
  		$("#leave_day4").val(temp[0]) ;
  		$("#leave_day4_2").val(temp[1]) ;
  		$("#career_description_04").val(data.result_data.career_description_04) ;


  		// 논문
  		if ( data.result_data.thesis_sci_yn_01 == "Y") {
  			$("#thesis_sci_yn_01").prop("checked", true) ;
  		}
  		$("#thesis_title_01").val(data.result_data.thesis_title_01) ;
  		$("#thesis_writer_01").val(data.result_data.thesis_writer_01) ;
  		$("#thesis_journal_01").val(data.result_data.thesis_journal_01) ;
  		if ( gfn_isNull(data.result_data.thesis_nationality_01) == false ) {
  			if ( data.result_data.thesis_nationality_01 == "국내") {
  	  			$("#country_type1_1").prop("checked", true) ;
  	 		} else {
  	 			$("#country_type1_2").prop("checked", true) ;
  	 		}
  		}
  		$("#thesis_date_01").val(data.result_data.thesis_date_01) ;
		// 02
  		if ( data.result_data.thesis_sci_yn_02 == "Y") {
  			$("#thesis_sci_yn_02").prop("checked", true) ;
  		}
  		$("#thesis_title_02").val(data.result_data.thesis_title_02) ;
  		$("#thesis_writer_02").val(data.result_data.thesis_writer_02) ;
  		$("#thesis_journal_02").val(data.result_data.thesis_journal_02) ;
  		if ( gfn_isNull(data.result_data.thesis_nationality_02) == false ) {
  			if ( data.result_data.thesis_nationality_02 == "국내") {
  	  			$("#country_type2_1").prop("checked", true) ;
  	 		} else {
  	 			$("#country_type2_2").prop("checked", true) ;
  	 		}
  		}
  		$("#thesis_date_02").val(data.result_data.thesis_date_02) ;
		// 03
  		if ( data.result_data.thesis_sci_yn_03 == "Y") {
  			$("#thesis_sci_yn_03").prop("checked", true) ;
  		}
  		$("#thesis_title_03").val(data.result_data.thesis_title_03) ;
  		$("#thesis_writer_03").val(data.result_data.thesis_writer_03) ;
  		$("#thesis_journal_03").val(data.result_data.thesis_journal_03) ;
  		if ( gfn_isNull(data.result_data.thesis_nationality_03) == false ) {
  			if ( data.result_data.thesis_nationality_03 == "국내") {
  	  			$("#country_type3_1").prop("checked", true) ;
  	 		} else {
  	 			$("#country_type3_2").prop("checked", true) ;
  	 		}
  		}
  		$("#thesis_date_03").val(data.result_data.thesis_date_03) ;

		// 지적 재산권
		$("#iprs_name_01").val(data.result_data.iprs_name_01) ;
  		if ( gfn_isNull(data.result_data.iprs_enroll_01) == false ) {
  			if ( data.result_data.iprs_enroll_01 == "출원") {
  	  			$("#license_pending1").prop("checked", true) ;
  	 		} else {
  	 			$("#license_enrollment1").prop("checked", true) ;
  	 		}
  		}
		$("#iprs_reg_no_01").val(data.result_data.iprs_reg_no_01) ;
		$("#iprs_date_01").val(data.result_data.iprs_date_01) ;
		$("#iprs_nationality_01").val(data.result_data.iprs_nationality_01) ;
		$("#iprs_writer_01").val(data.result_data.iprs_writer_01) ;
		// 02
		$("#iprs_name_02").val(data.result_data.iprs_name_02) ;
  		if ( gfn_isNull(data.result_data.iprs_enroll_02) == false ) {
  			if ( data.result_data.iprs_enroll_02 == "출원") {
  	  			$("#license_pending2").prop("checked", true) ;
  	 		} else {
  	 			$("#license_enrollment2").prop("checked", true) ;
  	 		}
  		}
		$("#iprs_reg_no_02").val(data.result_data.iprs_reg_no_02) ;
		$("#iprs_date_02").val(data.result_data.iprs_date_02) ;
		$("#iprs_nationality_02").val(data.result_data.iprs_nationality_02) ;
		$("#iprs_writer_02").val(data.result_data.iprs_writer_02) ;
		// 03
		$("#iprs_name_03").val(data.result_data.iprs_name_03) ;
  		if ( gfn_isNull(data.result_data.iprs_enroll_03) == false ) {
  			if ( data.result_data.iprs_enroll_03 == "출원") {
  	  			$("#license_pending3").prop("checked", true) ;
  	 		} else {
  	 			$("#license_enrollment3").prop("checked", true) ;
  	 		}
  		}
		$("#iprs_reg_no_03").val(data.result_data.iprs_reg_no_03) ;
		$("#iprs_date_03").val(data.result_data.iprs_date_03) ;
		$("#iprs_nationality_03").val(data.result_data.iprs_nationality_03) ;
		$("#iprs_writer_03").val(data.result_data.iprs_writer_03) ;
		
		$("#self_description").html(data.result_data.self_description) ;
	}


	function prepareModification(element) {
		if( $(element).text() == '평가위원 정보 수정' ) {
            $(element).text('평가위원 정보 수정 완료');	

    	    var mypage_agreementdata_modify = $(".mypage_agreementdata_area input, .mypage_agreementdata_area select, .mypage_agreementdata_area textarea, .mypage_agreementdata_area .d_input, .mypage_agreementdata_area .ui-datepicker-trigger").prop( 'disabled', true );
    	    $(".d_input").prop("disabled", mypage_agreementdata_modify ? false : true);
    	    mypage_agreementdata_modify.prop( 'disabled', false );
        }
        else {
        	modificaiton();
        }
	}
	

	function modificaiton(){
		var chkVal = ["bank_name", "bank_account",
			  "rnd_class",
			  "degree_01", "degree_school_01", "degree_major_01", "degree_date_01",
			  "career_company_01", "career_depart_01", "career_position_01", "join_day", "join_day1_2", "career_description_01"];

		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.", "평가위원");
				$("#" + chkVal[i]).focus();
				return false;
			}
		} 
		
/* 		if ( gfn_isNull($("#degree_certi_file_01")[0].files[0]) ) {
			showPopup("학위증명서는 필수입력입니다.", "평가위원");
			return;
		} */
		
		if ( gfn_isNull($("select[name=tech_info_large]").val()) ) {
			showPopup("국가과학기술분류 대분류 은(는) 필수입력입니다.", "평가위원");
			return;
		}
		if ( gfn_isNull($("select[name=tech_info_middle]").val()) ) {
			showPopup("국가과학기술분류 중분류 은(는) 필수입력입니다.", "평가위원");
			return;
		}
		if ( gfn_isNull($("select[name=tech_info_small]").val()) ) {
			showPopup("국가과학기술분류 소분류 은(는) 필수입력입니다.", "평가위원");
			return;
		}
		if ( gfn_isNull($("select[name=tech_info_4th_industry]").val()) ) {
			showPopup("4차 산업혁명 기술분류 은(는) 필수입력입니다.", "평가위원");
			return;
		}
		
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
/* 		if ( gfn_isNull($("#degree_certi_file_01")[0].files[0]) == false ) {
			formData.append("degree_certificate_file_id_01", detailCommissioner.degree_certificate_file_id_01 );
			formData.append("degree_certi_file_01", $("#degree_certi_file_01")[0].files[0]);
		} */
		formData.append("degree_02", $("#degree_02").val() );
		formData.append("degree_school_02", $("#degree_school_02").val() );
		formData.append("degree_major_02", $("#degree_major_02").val() );
		formData.append("degree_date_02", $("#degree_date_02").val() );
/* 		if ( gfn_isNull($("#degree_certi_file_02")[0].files[0]) == false ) {
			formData.append("degree_certificate_file_id_02", detailCommissioner.degree_certificate_file_id_02 );
			formData.append("degree_certi_file_02", $("#degree_certi_file_02")[0].files[0]);
		} */
		
		formData.append("career_company_01", $("#career_company_01").val() );
		formData.append("career_depart_01", $("#career_depart_01").val() );
		formData.append("career_position_01", $("#career_position_01").val() );
		formData.append("career_start_date_01", $("#join_day").val() + "-" + $("#join_day1_2").val() );
		formData.append("career_retire_date_01", $("#leave_day").val() + "-" + $("#leave_day1_2").val() );
		formData.append("career_description_01", $("#career_description_01").val() );
		formData.append("career_company_02", $("#career_company_02").val() );
		formData.append("career_depart_02", $("#career_depart_02").val() );
		formData.append("career_position_02", $("#career_position_02").val() );
		if ( gfn_isNull($("#join_day2").val()) == false && gfn_isNull($("#join_day2_2").val()) == false ) {
			formData.append("career_start_date_02", $("#join_day2").val() + "-" + $("#join_day2_2").val() );
		}
		if ( gfn_isNull($("#leave_day2").val()) == false && gfn_isNull($("#leave_day2_2").val()) == false ) {
			formData.append("career_retire_date_02", $("#leave_day2").val() + "-" + $("#leave_day2_2").val() );
		}

		console.log($("#career_description_02").val());
		formData.append("career_description_02", $("#career_description_02").val() );
		
		formData.append("career_company_03", $("#career_company_03").val() );
		formData.append("career_depart_03", $("#career_depart_03").val() );
		formData.append("career_position_03", $("#career_position_03").val() );
		if ( gfn_isNull($("#join_day3").val()) == false && gfn_isNull($("#join_day3_2").val()) == false ) {
			formData.append("career_start_date_03", $("#join_day3").val() + "-" + $("#join_day3_2").val() );
		}
		if ( gfn_isNull($("#leave_day3").val()) == false && gfn_isNull($("#leave_day3_2").val()) == false ) {
			formData.append("career_retire_date_03", $("#leave_day3").val() + "-" + $("#leave_day3_2").val() );
		}
		formData.append("career_description_03", $("#career_description_03").val() );
		formData.append("career_company_04", $("#career_company_04").val() );
		formData.append("career_depart_04", $("#career_depart_04").val() );
		formData.append("career_position_04", $("#career_position_04").val() );
		if ( gfn_isNull($("#join_day4").val()) == false && gfn_isNull($("#join_day4_2").val()) == false ) {
			formData.append("career_start_date_04", $("#join_day4").val() + "-" + $("#join_day4_2").val() );
		}
		if ( gfn_isNull($("#leave_day4").val()) == false && gfn_isNull($("#leave_day4_2").val()) == false ) {
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
		if ( gfn_isNull($("input[name='country_type1']:checked").val()) == false ) {
			formData.append("thesis_nationality_01", $("input[name='country_type1']:checked").val() );
		}
		formData.append("thesis_date_01", $("#thesis_date_01").val() );
		if($("#thesis_sci_yn_02").is(":checked") == true) {
			formData.append("thesis_sci_yn_02", "Y" );
		} else {
			formData.append("thesis_sci_yn_02", "N" );
		}
		formData.append("thesis_title_02", $("#thesis_title_02").val() );
		formData.append("thesis_writer_02", $("#thesis_writer_02").val() );
		formData.append("thesis_journal_02", $("#thesis_journal_02").val() );
		if ( gfn_isNull($("input[name='country_type2']:checked").val()) == false ) {
			formData.append("thesis_nationality_02", $("input[name='country_type2']:checked").val() );
		}
		formData.append("thesis_date_02", $("#thesis_date_02").val() );
		if($("#thesis_sci_yn_03").is(":checked") == true) {
			formData.append("thesis_sci_yn_03", "Y" );
		} else {
			formData.append("thesis_sci_yn_03", "N" );
		}
		formData.append("thesis_title_03", $("#thesis_title_03").val() );
		formData.append("thesis_writer_03", $("#thesis_writer_03").val() );
		formData.append("thesis_journal_03", $("#thesis_journal_03").val() );
		if ( gfn_isNull($("input[name='country_type3']:checked").val()) == false ) {
			formData.append("thesis_nationality_03", $("input[name='country_type3']:checked").val() );
		}
		formData.append("thesis_date_03", $("#thesis_date_03").val() );

		formData.append("iprs_name_01", $("#iprs_name_01").val() );
		if ( gfn_isNull($("input[name='license_class1']:checked").val()) == false ) {
			formData.append("iprs_enroll_01", $("input[name='license_class1']:checked").val() );
		}
		formData.append("iprs_reg_no_01", $("#iprs_reg_no_01").val() );
		formData.append("iprs_date_01", $("#iprs_date_01").val() );
		formData.append("iprs_nationality_01", $("#iprs_nationality_01").val() );
		formData.append("iprs_writer_01", $("#iprs_writer_01").val() );
		formData.append("iprs_name_02", $("#iprs_name_02").val() );
		if ( gfn_isNull($("input[name='license_class2']:checked").val()) == false ) {
			formData.append("iprs_enroll_02", $("input[name='license_class2']:checked").val() );
		}
		formData.append("iprs_reg_no_02", $("#iprs_reg_no_02").val() );
		formData.append("iprs_date_02", $("#iprs_date_02").val() );
		formData.append("iprs_nationality_02", $("#iprs_nationality_02").val() );
		formData.append("iprs_writer_02", $("#iprs_writer_02").val() );
		formData.append("iprs_name_03", $("#iprs_name_03").val() );
		if ( gfn_isNull($("input[name='license_class3']:checked").val()) == false ) {
			formData.append("iprs_enroll_03", $("input[name='license_class3']:checked").val() );
		}
		formData.append("iprs_reg_no_03", $("#iprs_reg_no_03").val() );
		formData.append("iprs_date_03", $("#iprs_date_03").val() );
		formData.append("iprs_nationality_03", $("#iprs_nationality_03").val() );
		formData.append("iprs_writer_03", $("#iprs_writer_03").val() );

		formData.append("self_description", $("#self_description").val() );

		
		$.ajax({
		    type : "POST",
		    url : "/member/api/commissioner/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	showPopup("회원 정보 수정에 성공했습니다.","회원 정보 수정 안내");
		        	isModification = true;
		        } else {
		        	showPopup("회원 정보 수정에 실패했습니다. 다시 시도해 주시기 바랍니다.","회원 정보 수정 안내");
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
		if ( isModification == true) {
			location.reload();
		}
	}

</script>

<!-- container -->
<div id="container" class="mb50">
				<h2 class="hidden">서브 컨텐츠 화면</h2>	
				
				<section id="content"  class="est-sub">
					<div id="sub_contents">
					    <div class="content_area clearfix">
							<h3 class="hidden">기관정보관리</h3>
							<div class="route hidden">
								<ul class="clearfix">
									<li><i class="fas fa-home">홈</i></li>
									<li>마이페이지</li>
									<li>기관정보관리</li>
								</ul>
							</div>
							<div id="lnb" class="fl">
								<!-- lnb_area -->	
								<div class="lnb_area">
									<!-- lnb_title_area -->	
									<div class="lnb_title_area">
										<h2 class="title">마이페이지</h2>
									</div>
									<!--// lnb_title_area -->
									<!-- lnb_menu_area -->
									<div class="lnb_menu_area">
										<!-- lnb_menu -->	
										<ul class="lnb_menu">
											<li>
												<a href="/member/fwd/mypage/institution" title="기관정보관리" ><span>기관정보관리</span></a>									
											</li>
											<li>
												<a href="/member/fwd/mypage/main" title="개인정보관리 페이지로 이동"><span>개인정보관리</span></a>									
											</li>
											<sec:authorize access="hasAnyRole('ROLE_EXPERT', 'ROLE_ADMIN')">
												<li>
													<a href="/member/fwd/mypage/expert" title="전문가 참여 현황" ><span>전문가 참여 현황</span></a>				
												</li>
											</sec:authorize>
											<sec:authorize access="hasAnyRole('ROLE_COMMISSIONER', 'ROLE_ADMIN')">
												<li>
													<a href="/member/fwd/mypage/commissioner" title="평가위원정보관리"  class="active"><span>평가위원 정보 관리</span></a>				
												</li>
											</sec:authorize>
											<li>
												<a href="/member/fwd/mypage/report" title="나의 수행과제 현황 관리 페이지로 이동"><span>나의 수행과제 현황 관리</span></a>									
											</li>
										</ul>
										<!--// lnb_menu -->
									</div><!--//lnb_menu_area-->
								</div><!--//lnb_area-->
							</div>
							<!--//lnb-->
							<div class="sub_right_contents fl">
								<h3>평가위원정보관리</h3>								
								<!--개인정보-->
								<h4>기본 정보</h4>
								<div class="table_area mypage_agreementdata_area">
									<table class="write fixed">
									<caption>기본 정보</caption>
										<colgroup>
											<col style="width: 20%;">																		
											<col style="width: 80%;">
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
									<!--//개인정보-->

									<!--기관정보-->
									<h4>기관 정보</h4>
									<table class="write fixed">
										<caption>기관 정보</caption>
										<colgroup>
											<col style="width: 20%;">																		
											<col style="width: 80%;">
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
									<!--기관정보-->

									<!--계좌 정보-->
									<h4>계좌 정보</h4>
									<table class="write fixed">
										<caption>계좌 정보</caption>
										<colgroup>
											<col style="width: 20%;">																		
											<col style="width: 80%;">
										</colgroup>
										<tbody>
											<tr>
												<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
												<label for="bank_name">은행명</label></span></th>
												<td>
													<input type="text" id="bank_name" class="form-control w_10 mr5" />		
													<span class="d_i">은행</span>
												</td>	
											</tr>  
											<tr>
												<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
												<label for="bank_account">계좌번호</label></span></th>
												<td>
													<input type="text" id="bank_account" oninput="numberOnlyInput(this);" class="form-control w60 mr5 ls" />	
													<span class="d_i">" - " 을 제외한 숫자만 입력해 주세요.</span>									
												</td>
											</tr>																							
										</tbody>
									</table>
									<!--//계좌 정보-->

									<!--기술분야-->
									<h4>기술 분야</h4>
									<table class="write fixed">
										<caption>기술 분야</caption>
										<colgroup>
											<col style="width: 20%;">																		
											<col style="width: 80%;">
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
									<!--//기술분야-->

									<!--연구 분야-->
									<h4>연구 분야</h4>
									<p class="mb5 lh_180">- 평가 가능한 연구 분야 <span class="font_blue">3개 이상</span> 작성하여 주세요. (예시 : 인공지능, 블록체인, IT융합)</p>
									<table class="write fixed">
										<caption>연구 분야</caption>
										<colgroup>
											<col style="width: 20%;">																		
											<col style="width: 80%;">
										</colgroup>
										<tbody>
											<tr>
											   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="rnd_class">연구 상세 분야</label></span></th>
											   <td>
												   <textarea name="rnd_class" id="rnd_class" cols="30" rows="2" class="w100"></textarea>
											   </td>
											</tr>
										</tbody>
									</table>
									<!--//연구 분야-->

									<!--학력-->
									<h4>학력</h4>
									<p class="mb5 lh_180 fl mt10">- <span class="font_blue">최근순</span>으로 기재하여 주십시요.</p>
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
													<select name="degree_type" id="degree_01" class="ace-select w100">
														<option value="학사">학사</option>															   
														<option value="석사">석사</option>
														<option value="박사">박사</option>															   
													</select>
													<label for="degree_01" class="hidden">학위</label>												
												</td>
												<td>
													<input type="text" id="degree_school_01" class="form-control w100" />
													<label for="degree_school_01" class="hidden">학교명</label>
												</td>
												<td>
													<input type="text" id="degree_major_01" class="form-control w100 ls" />
													<label for="degree_major_01" class="hidden">전공</label>
												</td>	
												<td>
													<!--<select id="degree_day" title="년도" class="year custom-select ace-select w100"></select>-->
													<input type="text" id="degree_date_01" class="form-control w60 ls number_t" maxlength="4" />
													<label for="degree_date_01">년</label>											
												</td>
												<td id="upload_name1"></td>
											</tr>
											<tr>														
												<td class="first clearfix">	
													<select name="degree_type" id="degree_02" class="ace-select w100">
														<option value="학사">학사</option>															   
														<option value="석사">석사</option>
														<option value="박사">박사</option>															   
													</select>
													<label for="degree_02" class="hidden">학위</label>												
												</td>
												<td>
													<input type="text" id="degree_school_02" class="form-control w100" />
													<label for="degree_school_02" class="hidden">학교명</label>
												</td>
												<td>
													<input type="text" id="degree_major_02" class="form-control w100 ls" />
													<label for="degree_major_02" class="hidden">전공</label>
												</td>	
												<td>
													<!--<select id="degree_day" title="년도" class="year custom-select ace-select w100"></select>-->
													<input type="text" id="degree_date_02" class="form-control w60 ls number_t" maxlength="4" />
													<label for="degree_date_02">년</label>											
												</td>
												<td id="upload_name2"></td>				
											</tr>	
										</tbody>
									</table>
									<!--//학력-->
									
									<!--경력-->
									<h4>경력</h4>
									<p class="mb5 lh_180 fl mt10">- <span class="font_blue">최근순</span>으로 기재하여 주십시요.</p>
									<table class="list fixed history_table write2">
										<caption>경력</caption>
										<colgroup>													
											<col style="width: 20%;">
											<col style="width: 20%;">
											<col style="width: 10%;">
											<col style="width: 20%;">
											<col style="width: 20%;">
											<col style="width: 20%;">
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
													<input type="text" id="career_company_01" class="form-control w100" />
													<label for="career_company_01" class="hidden">근무처</label>											
												</td>
												<td>
													<input type="text" id="career_depart_01" class="form-control w100" /> 
													<label for="career_depart_01" class="hidden">근무부서</label>
												</td>
												<td>
													<input type="text" id="career_position_01" class="form-control w100 ls" />
													<label for="career_position_01" class="hidden">직급</label>
												</td>	
												<td>
													<input type="text" id="join_day" class="form-control w40 ls number_t" maxlength="4" />
													<label for="join_day" class="mr10">년</label>
													<input type="text" id="join_day1_2" class="form-control w20 ls number_t" maxlength="2" />
													<label for="join_day1_2">월</label>															
												</td>	
												<td>
													<input type="text" id="leave_day" class="form-control w40 ls number_t" maxlength="4" />
													<label for="leave_day" class="mr10">년</label>
													<input type="text" id="leave_day1_2" class="form-control w20 ls number_t" maxlength="2" />
													<label for="leave_day1_2">월</label>
												</td>	
												<td class="last">
													<textarea name="career_description_01" id="career_description_01" rows="3" class="w100"></textarea>	
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
									<!--//경력-->

									<!--논문/저서-->
									<h4>논문/저서<span class="font_blue">(선택)</span></h4>
									<table class="list fixed history_table write2">
										<caption>논문/저서</caption>
										<colgroup>													
											<col style="width: 20%;">
											<col style="width: 20%;">
											<col style="width: 10%;">
											<col style="width: 20%;">
											<col style="width: 20%;">
											<col style="width: 20%;">
										</colgroup>
										<thead>
											<tr>														
												<th scope="col" class="first">SCI/비SCI</th>
												<th scope="col">논문저서 명</th>
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
													<input type="text" id="thesis_title_01" class="form-control w100">
													<label for="thesis_title_01" class="hidden">논문저서명</label>
												</td>
												<td>
													<input type="text" id="thesis_writer_01" class="form-control w100 ls">
													<label for="thesis_writer_01" class="hidden">주 저자명</label>
												</td>	
												<td>
													<input type="text" id="thesis_journal_01" class="form-control w100 ls">
													<label for="thesis_journal_01" class="hidden">학술지</label>											
												</td>	
												<td>															
													<input type="radio" id="country_type1_1" value="국내" name="country_type1">
													<label for="country_type1_1">국내</label>
													<input type="radio" id="country_type1_2" value="국외" name="country_type1">
													<label for="country_type1_2">국외</label>															
												</td>	
												<td class="last ta_c">															
													<div class="datepicker_area mr5">
														<input type="text" id="thesis_date_01" class="datepicker form-control w_12 mr5 ls">														
													</div>															
													<label for="thesis_date_01" class="hidden fl">발행일자</label>
												</td>	
											</tr>
											<tr>
												<td class="first clearfix">	
													<div class="clearfix" style="margin: auto;width:50px">
														<input type="checkbox" id="thesis_sci_yn_02" class="fl ml10 mr5"/>
														<label for="thesis_sci_yn_02" class="fl">SCI</label>
													</div>													
												</td>
												<td>
													<input type="text" id="thesis_title_02" class="form-control w100">
													<label for="thesis_title_02" class="hidden">논문저서명</label>
												</td>
												<td>
													<input type="text" id="thesis_writer_02" class="form-control w100 ls">
													<label for="thesis_writer_02" class="hidden">주 저자명</label>
												</td>	
												<td>
													<input type="text" id="thesis_journal_02" class="form-control w100 ls">
													<label for="thesis_journal_02" class="hidden">학술지</label>											
												</td>	
												<td>
													<input type="radio" id="country_type2_1" value="국내" name="country_type2">
													<label for="country_type2_1">국내</label>
													<input type="radio" id="country_type2_2" value="국외" name="country_type2">
													<label for="country_type2_2">국외</label>	
												</td>	
												<td class="last ta_c">															
													<div class="datepicker_area mr5">
														<input type="text" id="thesis_date_02" class="datepicker form-control w_12 mr5 ls">	
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
													<input type="text" id="thesis_title_03" class="form-control w100">
													<label for="thesis_title_03" class="hidden">논문저서명</label>
												</td>
												<td>
													<input type="text" id="thesis_writer_03" class="form-control w100 ls">
													<label for="thesis_writer_03" class="hidden">주 저자명</label>
												</td>	
												<td>
													<input type="text" id="thesis_journal_03" class="form-control w100 ls">
													<label for="thesis_journal_03" class="hidden">학술지</label>											
												</td>	
												<td>
													<input type="radio" id="country_type3_1" value="국내" name="country_type3">
													<label for="country_type3_1">국내</label>
													<input type="radio" id="country_type3_2" value="국외" name="country_type3">
													<label for="country_type3_2">국외</label>	
												</td>	
												<td class="last ta_c">															
													<div class="datepicker_area mr5">
														<input type="text" id="thesis_date_03" class="datepicker form-control w_12 mr5 ls">		
													</div>															
													<label for="thesis_date_03" class="hidden fl">발행일자</label>
												</td>	
											</tr>	
										</tbody>
									</table>
									<!--논문/저서-->

									<!--지식재산권-->
									<h4>지식재산권<span class="font_blue">(선택)</span></h4>
									<table class="list fixed knowledge_table write2">
										<caption>지식재산권</caption>
										<colgroup>													
											<col style="width: 20%;">
											<col style="width: 15%;">
											<col style="width: 15%;">
											<col style="width: 19%;">
											<col style="width: 15%;">
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
													<input type="radio" id="license_pending1" value="출원" name="license_class1">
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
													<input type="radio" id="license_pending2" value="출원" name="license_class2" />
													<label for="license_pending2">출원</label>
													<input type="radio" id="license_enrollment2" value="등록" name="license_class2" />
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
													<input type="radio" id="license_pending3" value="출원" name="license_class3" />
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
									<!--//지식재산권-->

									<!--자기소개서-->
									<h4>자기기술서<span class="font_blue">(선택)</span></h4>
									<table class="write fixed">
										<caption>자기기술서</caption>
										<colgroup>
											<col style="width: 20%;">																		
											<col style="width: 80%;">
										</colgroup>
										<tbody>
											<tr>
											   <th scope="row" class="ta_c"><label for="self_description">자기기술서</label></th>
											   <td>											   	   
												   <textarea name="self_description" id="self_description" cols="30" rows="8" class="w100"></textarea><span class="fr mt10 fw_b">(500자 이내)</span>
											   </td>
											</tr>
										</tbody>
									</table>
									<!--//자기소개서-->
								</div>
								<button type="button" title="평가위원 정보 수정" class="blue_btn fr mt10 mb5" onclick="prepareModification(this);">평가위원 정보 수정</button>
								<!--//개인정보-->	
							
											
							</div><!--//sub_right_contents-->
						</div><!--//content_area-->
					</div><!--//sub_contents-->
	
				</section><!--//content-->
			</div>
 
 
 <!--개인정보 수정 팝업-->
<div class="member_info_popup_box">
	<div class="popup_bg"></div>
	<div class="member_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">개인정보 수정</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn company_signup_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p tabindex="0">비밀번호를 한번 더 입력해주세요.</p>
				<label for="check_pwd">비밀번호 입력</label>
				<input type="password" class="login_form_input w40" id="check_pwd" placeholder="비밀번호를 입력해주세요." maxlength="20" />	
			</div>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn" onclick="checkPwd();">확인</button>
			</div>
		</div>						
	</div> 
</div>
<!--//개인정보수정 팝업-->

<!--비밀번호 변경 팝업-->
<div class="pw_change_popup_box">		
	<div class="popup_bg"></div>
	<div class="pw_change_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">비밀번호 변경</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">						
			<div class="table_area">
				<table class="write fixed">
					<caption>비밀번호 변경</caption>
					<colgroup>
						<col style="width: 40%;">																		
						<col style="width: 60%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><label for="pw_validation1">비밀번호</label></th>
							<td>
								<label for="pwd">비밀번호 입력</label>
								<input type="password" id="pwd" class="w100" />								
							</td>	
						</tr>									  
						<tr>
							<th scope="row"><label for="pw_validation2">비밀번호 확인</label></th>
							<td>
								<label for="pwd_confirm">비밀번호 확인</label>
								<input type="password" id="pwd_confirm" class="w100" />								
							</td>	
						</tr>									
					</tbody>
				</table>
			</div>	
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn" onclick="newPwdConfirm();">확인</button>
			</div>
		</div>									
	</div> 
</div>
<!--//비밀번호 변경 팝업-->


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
				<button type="button" class="blue_btn popup_close_btn" title="확인" onclick="commonPopupConfirm();">확인</button>
			</div>
		</div>						
	</div> 
</div>
