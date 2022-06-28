var mMemberDetail;
var mInstitutionDetail;
var mAnnouncementDetail;
var isConfrimInstitution = false;
var isSelectSelfCheckList = false;

// member
function searchMemberDetail(id) {
	var comAjax = new ComAjax();
	comAjax.setUrl("/member/api/mypage/detail");
	comAjax.setCallback(getDetailCB);
	comAjax.addParam("member_id", id);
	comAjax.ajax();
}
function getDetailCB(data){
	mMemberDetail = data.result;
}

// Institution
function searchInstitutionDetail(id) {
	var comAjax = new ComAjax();
	comAjax.setUrl("/member/api/mypage/institution/detail");
	comAjax.setCallback(getInstitutionCB);
	comAjax.addParam("member_id", id);
	comAjax.ajax();
}
function getInstitutionCB(data){
	console.log('data : ', data);
	// 기관 정보가 없으면 기관 정보 확인을 하지 않토록 한다.
	if (data.result == null || data.result.reg_no =="") {
		// 기술 매칭은 기관만 지원 가능하다.
		// 기술 매칭 시 기관 정보가 없으면 접수 못하게 한다.
		if ($("#announcement_type").val() != "D0000001" && $("#announcement_type").val() != "D0000002" ) {
			isConfrimInstitution = true;
		}
		return;
	}

	mInstitutionDetail = data.result;
	
	$("#reg_no").val(data.result.reg_no);
	$("#company_name").val(data.result.name);
	$("#company_address").val(data.result.address + " " + data.result.address_detail);
	$("#company_phone").val(data.result.phone);
	$("#representative_name").val(data.result.representative_name);
	$("#industry_type").val(data.result.industry_type);
	$("#business_type").val(data.result.business_type);
	$("#foundation_date").val(data.result.foundation_date);
	
	//설립구분
	var foundation_type_name;
	if(data.result.foundation_type == 'D0000001') {
		foundation_type_name = '영리';
	}else if(ata.result.foundation_type == 'D0000002'){
		foundation_type_name = '비영리';
	}
	$("#foundation_type").val(foundation_type_name);


	//기업분류
	var company_class_name;
	if(data.result.company_class == 'D0000001') {
		company_class_name = '대기업';
	}else if(data.result.company_class == 'D0000002'){
		company_class_name = '중견기업';
	}else if(data.result.company_class == 'D0000003'){
		company_class_name = '중소기업';
	}else if(data.result.company_class == 'D0000004'){
		company_class_name = '기타';
	}
	$("#company_class").val(company_class_name);
	
	//기업유형
	var company_type_name;
	if(data.result.company_type == 'D0000001') {
		company_type_name = '여성기업';
	}else if(data.result.company_type == 'D0000002'){
		company_type_name = '장애인기업';
	}else if(data.result.company_type == 'D0000003'){
		company_type_name = '사회적기업';
	}else if(data.result.company_type == 'D0000004'){
		company_type_name = '해당 없음';
	}
	$("#company_type").val(company_type_name);
	
	$("input:radio[name=lab_exist_yn_radio][value='" + data.result.lab_exist_yn + "']").prop("checked", true);
	$("#employee_no").val(data.result.total_count);
	$("#total_sales").val(data.result.total_sales);
	$("#capital_1").val(data.result.capital_1);
	$("#capital_2").val(data.result.capital_2);
	$("#capital_3").val(data.result.capital_3);
}

// Announcement
var receptionStatus;
var targetStatus;
function searchAnnouncementDetail(status) {
	receptionStatus = status;
	var comAjax = new ComAjax();
	comAjax.setUrl("/member/api/announcement/detail");
	comAjax.setCallback(getAnnouncementCB);
	comAjax.addParam("announcement_id", $("#announcement_id").val());
	comAjax.ajax();
}
function getAnnouncementCB(data){
	mAnnouncementDetail = data.result;
	console.log('JS mAnnouncementDetail ---> ', mAnnouncementDetail);
	// 기관 정보
    if ( data.result.ext_field_list != null) {
		var ext_field_list = data.result.ext_field_list;
		console.log('ext_field_list ---> ', ext_field_list);
		for(var i=0; i<ext_field_list.length; i++) {
			
			// 공고제안 인 경우 접수 대상이 존재한다.
			// 접수 대상만 데이터가 3개이다. 따라서 접수 대상만 따로 처리한다. 접수 대상의 Type은 D0000008 이다.
			// 필드 값 D0000001(개인), D0000002(기관)인 경우 사용자가 따로 선택하지 않고 자동으로 개인인 경우와 기관인 경우의 입력 Field를 보여준다. 즉 화면에서 개인/기관 선택하지 못하게 한다.
			// D0000003(개인/기관) 인 경우만 화면에 보여지게 한다.
 			if ( ext_field_list[i].ext_type == "D0000008" ) {
 				targetStatus = ext_field_list[i].ext_field_yn;
				// 개인 및 기관인 경우는 해당 UI를 보여주지 않는다.
				if ( ext_field_list[i].ext_field_yn == "D0000001" ) {
					$("#selector_member").prop('checked', true);
					$("#selector_company").prop('checked', false);
					
					$("#copmpany_area").css('display', 'none');
					$("#member_area").css('display', 'block');
					$("#target_area").hide();
				}
				else if ( ext_field_list[i].ext_field_yn == "D0000002" ) {
					$("#selector_member").prop('checked', false);
					$("#selector_company").prop('checked', true);
					
					$("#copmpany_area").css('display', 'block');
					$("#member_area").css('display', 'none');
					$("#target_area").hide();
				}
				else {
					$("#selector_member").prop('checked', false);
					$("#selector_company").prop('checked', true);
					
					$("#copmpany_area").css('display', 'block');
					$("#member_area").css('display', 'none');
					$("#target_area").show();
				}
			}
			
			// D0000002 는 사용안함이다. 화면에서 안보이게 처리
			if ( ext_field_list[i].ext_field_yn == "D0000002" ){
				// 개인 정보
				if ( ext_field_list[i].ext_type == "D0000007" ) {
					if ( ext_field_list[i].ext_field_name == "아이디" ) {
						$("#person_id_tr").hide();
						$("#person_id_tr").attr("use_yn", "n");
					}
				}
				if ( ext_field_list[i].ext_type == "D0000007" ) {
					if ( ext_field_list[i].ext_field_name == "성명" ) {
						$("#person_name_tr").hide();
						$("#person_name_tr").attr("use_yn", "n");
					}
				}
				if ( ext_field_list[i].ext_type == "D0000007" ) {
					if ( ext_field_list[i].ext_field_name == "휴대전화" ) {
						$("#person_mobile_phone_tr").hide();
						$("#person_mobile_phone_tr").attr("use_yn", "n");
					}
				}
				if ( ext_field_list[i].ext_type == "D0000007" ) {
					if ( ext_field_list[i].ext_field_name == "이메일" ) {
						$("#person_email_tr").hide();
						$("#person_email_tr").attr("use_yn", "n");
					}
				}	
				if ( ext_field_list[i].ext_type == "D0000007" ) {
					if ( ext_field_list[i].ext_field_name == "주소" ) {
						$("#person_address_tr").hide();
						$("#person_address_tr").attr("use_yn", "n");
					}
				}
				
				// 기관 정보
				if ( ext_field_list[i].ext_type == "D0000001" ) {
					if ( ext_field_list[i].ext_field_name == "사업자 등록번호" ) {
						$("#reg_no_tr").hide();
						$("#reg_no_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "기관명" ) {
						$("#company_name_tr").hide();
						$("#company_name_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "주소" ) {
						$("#company_address_tr").hide();
						$("#company_address_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "전화" ) {
						$("#company_phone_tr").hide();
						$("#company_phone_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "대표자명" ) {
						$("#representative_name_tr").hide();
						$("#representative_name_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "업종" ) {
						$("#industry_type_tr").hide();
						$("#industry_type_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "업태" ) {
						$("#business_type_tr").hide();
						$("#business_type_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "설립일" ) {
						$("#foundation_date_tr").hide();
						$("#foundation_date_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "설립 구분" ) {
						$("#foundation_type_tr").hide();
						$("#foundation_type_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "기업 분류" ) {
						$("#company_class_tr").hide();
						$("#company_class_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "기업 유형" ) {
						$("#company_type_tr").hide();
						$("#company_type_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "기업부설연구소 유무" ) {
						$("#lab_exist_yn_tr").hide();
						$("#lab_exist_yn_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "종업원수" ) {
						$("#employee_no_tr").hide();
						$("#employee_no_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "매출액(최근3년)" ) {
						$("#total_sales_tr").hide();
						$("#total_sales_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "자본금" ) {
						$("#capital_tr").hide();
						$("#capital_tr").attr("use_yn", "n");
					}
				}
				// 연구책임자 정보
				if ( ext_field_list[i].ext_type == "D0000002" ) {
					if ( ext_field_list[i].ext_field_name == "성명" ) {
						$("#research_name_tr").hide();
						$("#research_name_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "휴대전화" ) {
						$("#mobile_phone_tr").hide();
						$("#mobile_phone_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "이메일" ) {
						$("#email_tr").hide();
						$("#email_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "주소" ) {
						$("#research_address_tr").hide();
						$("#research_address_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "기관명" ) {
						$("#research_institution_name_tr").hide();
						$("#research_institution_name_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "부서" ) {
						$("#research_institution_department_tr").hide();
						$("#research_institution_department_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "직책" ) {
						$("#research_institution_position_tr").hide();
						$("#research_institution_position_tr").attr("use_yn", "n");
					}
				}
				// 기술컨설팅 요청사항
				if ( ext_field_list[i].ext_type == "D0000003" ) {
					if ( ext_field_list[i].ext_field_name == "구분" ) {
						$("#consulting_type_tr").hide();
						$("#consulting_type_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "소속 캠퍼스타운" ) {
						$("#consulting_campus_tr").hide();
						$("#consulting_campus_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "국가기술분류체계" ) {
						$("#national_science_large_tr").hide();
						$("#national_science_middle_tr").hide();
						$("#national_science_small_tr").hide();
						
						$("#national_science_large_tr").attr("use_yn", "n");
						$("#national_science_middle_tr").attr("use_yn", "n");
						$("#national_science_small_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "4차 산업혁명 기술분류" ) {
						$("#4th_industry_tr").hide();
						$("#4th_industry_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "컨설팅 목적" ) {
						$("#consulting_purpose_tr").hide();
						$("#consulting_purpose_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "사전 컨설팅 실시 여부" ) {
						$("#consulting_purpose_tr").hide();
						$("#consulting_purpose_tr").attr("use_yn", "n");
					}
				}
				// 기술 정보
				if ( ext_field_list[i].ext_type == "D0000004" ) {
					if ( ext_field_list[i].ext_field_name == "제품/서비스명" || ext_field_list[i].ext_field_name == "기술명") {
						$("#sevice_name_tr").hide();
						$("#sevice_name_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "제품/서비스 내용" || ext_field_list[i].ext_field_name == "기술개요"	) {
						$("#sevice_description_tr").hide();
						$("#sevice_description_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "기술애로사항" || ext_field_list[i].ext_field_name == "기술연구개발 내용") {
						$("#sevice_content_tr").hide();
						$("#sevice_content_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "컨설팅 요청사항" || ext_field_list[i].ext_field_name == "전문가 요청사항") {
						$("#sevice_request_tr").hide();
						$("#sevice_request_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "시장/기술 동향") {
						$("#sevice_request_tr").hide();
						$("#sevice_request_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "첨부 파일" ) {
						$("#sevice_research_tr").hide();
						$("#sevice_research_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "국가과학기술분류" ) {
						$("#sevice_national_science_large_tr").hide();
						$("#sevice_national_science_large_tr").attr("use_yn", "n");
						$("#sevice_national_science_middle_tr").hide();
						$("#sevice_national_science_middle_tr").attr("use_yn", "n");
						$("#sevice_national_science_small_tr").hide();
						$("#sevice_national_science_small_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "특징" ) {
						$("#sevice_feature_tr").hide();
						$("#sevice_feature_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "기대효과" ) {
						$("#sevice_effect_tr").hide();
						$("#sevice_effect_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "실증분야" ) {
						$("#tech_info_type_tr").hide();
						$("#tech_info_type_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "4차 산업혁명 기술분류" ) {
						$("#tech_info_4th_industry_tr").hide();
						$("#tech_info_4th_industry_tr").attr("use_yn", "n");
					}
					if ( ext_field_list[i].ext_field_name == "적용 분야" ) {
						$("#tech_info_area_tr").hide();
						$("#tech_info_area_tr").attr("use_yn", "n");
					}
				}
			}
		}
		// 전문가 신청인 경우 제출 서류는 보여주지 않는다.
		if ( receptionStatus != "D0000003" && receptionStatus != "D0000004") {
			// 제출 서류는 추가 버튼으로 서류 종류가 늘어난다. 따라서 동적 생성한다.
			$("#document_body").empty();
			var nomalDoc = "";
			var isFirstNormal = true;
			var index = 1;
			// '사용'인 경우
			var normalDocList = ext_field_list.filter(item => (item.ext_type === 'D0000005' && item.ext_field_yn === "D0000001"));
			$.each(normalDocList, function(key, value) {
				nomalDoc += "<tr>";
				if (isFirstNormal == true) {
					isFirstNormal = false;
					nomalDoc += "	<th scope='row' rowspan='" + normalDocList.length + "' class='ta_c'><span class='font_blue'>(선택)</span></th>";	
				}
				nomalDoc += "	<th scope='row'>" + value.ext_field_name + "</th>";
				nomalDoc += "	<td>";
				nomalDoc += "		<div class='filebox'>";
				nomalDoc += "			<input id='submit_files_name_" + index + "' type='" + value.ext_field_yn + "' field_name='" + value.ext_field_name + "' class='upload-name in_w80' disabled='disabled' ext_id='" + value.extension_id + "' /> ";
				nomalDoc += "			<label for='submit_files_" + index + "'>찾아보기</label>";
				nomalDoc += "			<input type='file' id='submit_files_" + index + "' class='upload-hidden'/>";				
				nomalDoc += "		</div>";
				nomalDoc += "	</td>";
				nomalDoc += "</tr>";
				
				index++;
			});
			// '필수'인 경우
			var requiredDocList = ext_field_list.filter(item => (item.ext_type === 'D0000005' && item.ext_field_yn === "D0000003"));
			var requiredDoc = "";
			var isFirstRequired = true;
			$.each(requiredDocList, function(key, value) {
				requiredDoc += "<tr>";
				if (isFirstRequired == true) {
					isFirstRequired = false;
					requiredDoc += "	<th scope='row' rowspan='" + requiredDocList.length + "' class='ta_c'><span class='font_red'>(필수)</span></th>";	
				}
				requiredDoc += "	<th scope='row'>" + value.ext_field_name + "</th>";
				requiredDoc += "	<td>";
				requiredDoc += "		<div class='filebox'>";
				requiredDoc += "			<input id='submit_files_name_" + index + "' type='" + value.ext_field_yn + "' field_name='" + value.ext_field_name + "' class='upload-name in_w80' disabled='disabled' ext_id='" + value.extension_id + "' /> ";
				requiredDoc += "			<label for='submit_files_" + index + "'>찾아보기</label>";
				requiredDoc += "			<input type='file' id='submit_files_" + index + "' class='upload-hidden'/>";
				requiredDoc += "		</div>";
				requiredDoc += "	</td>";
				requiredDoc += "</tr>";
				
				index++;
			});	
			
			$("#document_body").append(requiredDoc);
			$("#document_body").append(nomalDoc);
		}
    }
}


function writeReserchInfo() {
	$("#research_name").val(mMemberDetail.name);
	var stringSplit = mMemberDetail.mobile_phone.split("-");
	$("#mobile_phone_2").val(stringSplit[1]);
	$("#mobile_phone_3").val(stringSplit[2]);
	stringSplit = mMemberDetail.email.split("@");
	$("#email_1").val(stringSplit[0]);
	$("#email_2").val(stringSplit[1]);
	$("#research_address").val(mMemberDetail.address);
	$("#research_address_detail").val(mMemberDetail.address_detail);
}


function writePersonInfo() {
	$("#member_id").val(mMemberDetail.member_id);
	$("#member_name").val(mMemberDetail.name);
	$("#member_phone").val(mMemberDetail.mobile_phone);
	stringSplit = mMemberDetail.email.split("@");
	$("#member_mail_1").val(stringSplit[0]);
	$("#member_mail_2").val(stringSplit[1]);
	$("#member_address").val(mMemberDetail.address);
	$("#member_address_detail").val(mMemberDetail.address_detail);
}

var selectCheckList = new Array();
function createSelfCheckList() {
	// 샐프 체크리스트는 추가 버튼으로 리스트가 늘어난다. 따라서 동적 생성한다.
	$("#self_check_list_body").empty();
	
	// Check List 전체 사용 여부 필드이다.
	// D0000001 사용 / D0000002 사용안함.
	if ( mAnnouncementDetail.ext_check_list == null || mAnnouncementDetail.ext_check_list.length == 0 || mAnnouncementDetail.ext_check_list[0].all_use_yn != "D0000001" ) {
		showPopup("셀프 채크리스트가 존재하지 않습니다.다른 항목을 작성해 주세요.", "채크리스트 안내");
		isSelectSelfCheckList = true;
		return;
	}
	
	var str="";
	var index = 1;
	$.each(mAnnouncementDetail.ext_check_list, function(key, value) {
		// 개별 Check List 사용여부 이다.
		// D0000001 사용 / D0000002 사용안함.
		if ( value.check_list_use_yn == "D0000001") {
			str += "<tr id='check_list_" + index + "' check_id='" + value.check_id + "'>";
			str += "	<td class='first ta_l' id='ckeck_list_contents_" + index + "'>" + value.check_list_content + "</td>";
			str += "	<td class='last'>";
			
			// check List 선택시 경고 팝업 사용 여부
			// D0000001 이면 경고 팝업을 생성
			if ( value.popup_use_yn == "D0000001" ) {
				// 경고 팝업을 언제 띄울껀지 결정
				// D0000001 이면 '예'를  클릭할때 생성
				if ( value.popup_warn_use_yn == "D0000001" ) {
					// 기존에 선택한 값이 있는 경우. 기존에 선택한 값으로 세팅한다.
					if ( selectCheckList.length > 0){
						const checkRow = selectCheckList.find((e) => e.check_id === value.check_id.toString() );
						// '예' 를 선택한다 경우
						if ( checkRow.check_list_yn == "Y"){
							str += "		<input type='radio' id='area_class" + index + "' name='check_list_radio_" + index + "' value='Y' " +
					   						"onclick='checkSelfCheckList(this, \"" + value.popup_warn_content + "\");' checked_ok='N' checked />";
							str += "		<label for='area_class" + index + "'>예</label> ";
							str += "		<input type='radio' id='area_class" + index + "_1' name='check_list_radio_" + index + "' checked_ok='Y' value='N' />";
							str += "		<label for='area_class" + index + "_1'>아니오</label>";
						}
						// '아니오'를 선택한 경우
						else {
							str += "		<input type='radio' id='area_class" + index + "' name='check_list_radio_" + index + "' value='Y' " +
					   						"onclick='showPopup(\"" + value.popup_warn_content + "\", \"샐프 체크리스트 안내\");' checked_ok='N' />";
							str += "		<label for='area_class" + index + "'>예</label> ";
							str += "		<input type='radio' id='area_class" + index + "_1' name='check_list_radio_" + index + "' checked_ok='Y' value='N' checked />";
							str += "		<label for='area_class" + index + "_1'>아니오</label>";							
						}
					}
					else {
						str += "		<input type='radio' id='area_class" + index + "' name='check_list_radio_" + index + "' value='Y' " +
		   					   			"onclick='showPopup(\"" + value.popup_warn_content + "\", \"샐프 체크리스트 안내\");' checked_ok='N'/>";
						str += "		<label for='area_class" + index + "'>예</label> ";
						str += "		<input type='radio' id='area_class" + index + "_1' name='check_list_radio_" + index + "' checked_ok='Y' value='N' />";
						str += "		<label for='area_class" + index + "_1'>아니오</label>";
					}
				}
				// 아니면 '아니오'를 클릭할때 생성
				else {
					// 기존에 선택한 값이 있는 경우. 기존에 선택한 값으로 세팅한다.
					if ( selectCheckList.length > 0){
						const checkRow = selectCheckList.find((e) => e.check_id === value.check_id.toString() );
						// '예' 를 선택한다 경우
						if ( checkRow.check_list_yn == "Y"){
							str += "		<input type='radio' id='area_class" + index + "' name='check_list_radio_" + index + "' checked_ok='Y' value='Y' checked />";
							str += "		<label for='area_class" + index + "'>예</label> ";
							str += "		<input type='radio' id='area_class" + index + "_1' name='check_list_radio_" + index + "' value='N'" +
											"onclick='showPopup(\"" + value.popup_warn_content + "\", \"샐프 체크리스트 안내\");' checked_ok='N'/>";
							str += "		<label for='area_class" + index + "_1'>아니오</label>";
						}
						else {
							str += "		<input type='radio' id='area_class" + index + "' name='check_list_radio_" + index + "' checked_ok='Y' value='Y' />";
							str += "		<label for='area_class" + index + "'>예</label> ";
							str += "		<input type='radio' id='area_class" + index + "_1' name='check_list_radio_" + index + "' value='N'" +
											"onclick='showPopup(\"" + value.popup_warn_content + "\", \"샐프 체크리스트 안내\");' checked_ok='N' checked/>";
							str += "		<label for='area_class" + index + "_1'>아니오</label>";
						}
					}
					else {
						str += "		<input type='radio' id='area_class" + index + "' name='check_list_radio_" + index + "' checked_ok='Y' value='Y' />";
						str += "		<label for='area_class" + index + "'>예</label> ";
						str += "		<input type='radio' id='area_class" + index + "_1' name='check_list_radio_" + index + "' value='N'" +
										"onclick='showPopup(\"" + value.popup_warn_content + "\", \"샐프 체크리스트 안내\");' checked_ok='N' />";
						str += "		<label for='area_class" + index + "_1'>아니오</label>";
					}
				}
			}
			else {
				if ( selectCheckList.length > 0){
					const checkRow = selectCheckList.find((e, checkIndex, arr) => e.check_id === value.check_id.toString() );
					
					if ( checkRow.check_list_yn == "Y"){
						str += "		<input type='radio' id='area_class" + index + "' name='check_list_radio_" + index + "' value='Y' checked />";
						str += "		<label for='area_class" + index + "'>예</label> ";
						str += "		<input type='radio' id='area_class" + index + "_1' name='check_list_radio_" + index + "' value='N' />";
						str += "		<label for='area_class" + index + "_1'>아니오</label>";
					}
					else {
						str += "		<input type='radio' id='area_class" + index + "' name='check_list_radio_" + index + "' value='Y' />";
						str += "		<label for='area_class" + index + "'>예</label> ";
						str += "		<input type='radio' id='area_class" + index + "_1' name='check_list_radio_" + index + "' value='N' checked />";
						str += "		<label for='area_class" + index + "_1'>아니오</label>";
					}
				}
				else {
					str += "		<input type='radio' id='area_class" + index + "' name='check_list_radio_" + index + "' value='Y' />";
					str += "		<label for='area_class" + index + "'>예</label> ";
					str += "		<input type='radio' id='area_class" + index + "_1' name='check_list_radio_" + index + "' value='N' />";
					str += "		<label for='area_class" + index + "_1'>아니오</label>";
					
				}
				
			}
			str += "	</td>";
			str += "</tr>";
			
			index++;
		}
	});
	
	$("#self_check_list_body").append(str);
	$('.selfchecklist_popup_box, .popup_bg').fadeIn(350);
}

function completeCheckList() {
	var isSelectCheckListOK = true;
	selectCheckList = new Array();
	for (var i=0; i<$("#self_check_list_body tr").length; i++ ) {
		if ( $("input:radio[name='check_list_radio_" + (i+1) + "']").is(':checked') == false ) {
			showPopup("체크 하지 않은 항목이 있습니다. 모두 체크해주세요.", "채크리스트 안내");
			return;
		}
		
		// 접수 이전에 본인이 접수 조건에 적합한지를 스스로 체크하는 항목이다.
		// check list의 항목 선택 시에 경고 팝업이 뜬 경우는 접수 항목에 맞지 않는 경우이다. 에러로 처리한다.
		if ( $("input:radio[name='check_list_radio_" + (i+1) + "']:checked").attr("checked_ok") == "N" ) {
			isSelectCheckListOK = false;
			isSelectSelfCheckList = false;
		}
		
		var selfCheckListInfo = new Object();
		selfCheckListInfo.check_id = $("#check_list_" + (i+1)).attr("check_id");
		selfCheckListInfo.check_list_content = $("#ckeck_list_contents_" + (i+1)).text();
		selfCheckListInfo.check_list_yn = $("input:radio[name='check_list_radio_" + (i+1) + "']:checked").val();
		
		selectCheckList.push(selfCheckListInfo);
	}
	
	
	if ( isSelectCheckListOK == false){
		showPopup("체크리스트 조건을 만족하지 않는 사항이 있습니다. 체크리스트 조건을 만족하지 않으면 접수가 불가합니다.", "채크리스트 안내");
		return;
	} else {
		isSelectSelfCheckList = true;
	}
	
	$('.selfchecklist_popup_box, .popup_bg').fadeOut(350);
}



// 접수 상세
var mReceptionDetail;
function searchReceptionDetail() {
	var comAjax = new ComAjax();
	comAjax.setUrl("/member/api/reception/detail");
	comAjax.setCallback(getReceptionCB);
	comAjax.addParam("reception_id", $("#reception_id").val());
	comAjax.ajax();
}

var msubmitFileList;
function getReceptionCB(data){
	mReceptionDetail = data.result_data;
	console.log('mReceptionDetail : ', mReceptionDetail);
	// 기관 정보
	$("#reg_no").val(mReceptionDetail.institution_reg_number);
	$("#company_name").val(mReceptionDetail.institution_name);
	$("#company_address").val(mReceptionDetail.institution_address);
	$("#company_phone").val(mReceptionDetail.institution_phone);
	$("#representative_name").val(mReceptionDetail.institution_owner_name);
	$("#industry_type").val(mReceptionDetail.institution_industry);
	$("#business_type").val(mReceptionDetail.institution_business);
	$("#foundation_date").val(mReceptionDetail.institution_foundataion_date);
	$("#foundation_type").val(mReceptionDetail.institution_foundataion_type);
	$("#company_class").val(mReceptionDetail.institution_classification);
	$("#company_type").val(mReceptionDetail.institution_type);
	$("input:radio[name=lab_exist_yn_radio][value='" + mReceptionDetail.institution_laboratory_yn + "']").prop("checked", true);
	$("#employee_no").val(mReceptionDetail.institution_employee_count);
	$("#total_sales").val(mReceptionDetail.institution_total_sales);
	$("#capital_1").val(mReceptionDetail.institution_capital_1);
	$("#capital_2").val(mReceptionDetail.institution_capital_2);
	$("#capital_3").val(mReceptionDetail.institution_capital_3);
	// 연구책임자 정보
	$("#research_name").val(mReceptionDetail.researcher_name);
	var phoneList = mReceptionDetail.researcher_mobile_phone.split("-");
	$("#mobile_phone_2").val(phoneList[1]);
	$("#mobile_phone_3").val(phoneList[2]);
	var mailList = mReceptionDetail.researcher_email.split("@");
	$("#email_1").val(mailList[0]);
	$("#email_2").val(mailList[1]);
	$("#research_address").val(mReceptionDetail.researcher_address);
	$("#research_address_detail").val(mReceptionDetail.researcher_address_detail);
	$("#research_institution_name").val(mReceptionDetail.researcher_institution_name);
	$("#research_institution_department").val(mReceptionDetail.researcher_institution_department);
	$("#research_institution_position").val(mReceptionDetail.researcher_institution_position);
	//기술컨설팅 요청사항
	$("input:radio[name=con_reception_class_g][value='" + unescapeHtml(mReceptionDetail.tech_consulting_type) + "']").prop("checked", true);
	$("#consulting_campus").val(mReceptionDetail.tech_consulting_campus);
	if ( gfn_isNull(mReceptionDetail.tech_consulting_large) == false ) {
		$("#large_selector").val(mReceptionDetail.tech_consulting_large).trigger('change');	
	}
	if ( gfn_isNull(mReceptionDetail.tech_consulting_middle) == false ) {
		$("#middle_selector").val(mReceptionDetail.tech_consulting_middle).trigger('change');	
	}
	if ( gfn_isNull(mReceptionDetail.tech_consulting_small) == false ) {
		$("#small_selector").val(mReceptionDetail.tech_consulting_small).trigger('change');	
	}
	$("#4th_industry_selector").val(mReceptionDetail.tech_consulting_4th_industry).prop("selected",true);
	$("input:radio[name=con_radio_check][value='" + unescapeHtml(mReceptionDetail.tech_consulting_purpose) + "']").prop("checked", true);
	if ( unescapeHtml(mReceptionDetail.tech_consulting_purpose) != "8. 기타" ) {
 			$("#con_purpose8_comment").val("");
	} else {
		$("#con_purpose8_comment").val(mReceptionDetail.tech_consulting_purpose_etc);
	}
	$("input:radio[name=consulting_take_yn_radio][value='" + unescapeHtml(mReceptionDetail.tech_consulting_take_yn) + "']").prop("checked", true);
	
	//기술 정보
	$("#sevice_name").val(mReceptionDetail.tech_info_name);
	$("#sevice_description").val(mReceptionDetail.tech_info_description);
	$("#reception_problems_text").val(mReceptionDetail.tech_info_problems);
	$("#reception_conrequest_text").val(mReceptionDetail.tech_info_consulting_request);
	$("#reception_rnd_text").val(mReceptionDetail.tech_info_rnd_description);
	$("#reception_rndrequest_text").val(mReceptionDetail.tech_info_expert_request);
	$("#service_upload_file_label").text(mReceptionDetail.tech_info_upload_file_name);
	$("#tech_info_market_report").val(mReceptionDetail.tech_info_market_report);
	
	$("#tech_info_name").val(mReceptionDetail.tech_info_name);
	$("#tech_info_description").val(mReceptionDetail.tech_info_description);
	if ( gfn_isNull(mReceptionDetail.tech_info_large) == false ) {
		$("#tech_info_large").val(mReceptionDetail.tech_info_large).trigger('change');	
	}
	if ( gfn_isNull(mReceptionDetail.tech_info_middle) == false ) {
		$("#tech_info_middle").val(mReceptionDetail.tech_info_middle).trigger('change');	
	}
	if ( gfn_isNull(mReceptionDetail.tech_info_small) == false ) {
		$("#tech_info_small").val(mReceptionDetail.tech_info_small).trigger('change');	
	}
	$("#tech_info_feature").val(mReceptionDetail.tech_info_feature);
	$("#tech_info_effect").val(mReceptionDetail.tech_info_effect);
	$("#tech_info_area").val(mReceptionDetail.tech_info_area);
	$("#tech_info_4th_industry").val(mReceptionDetail.tech_info_4th_industry).prop("selected",true);
	$("input:radio[name=tech_info_type_radio][value='" + mReceptionDetail.tech_info_type + "']").prop("checked", true);

	//제출 서류
	msubmitFileList = mReceptionDetail.submit_files_list;
	$.each(mReceptionDetail.submit_files_list, function(key, value) {
		for (var i=0; i<$("#document_body tr").length; i++ ) {
			if ( $("#submit_files_name_"+(i+1)).attr("ext_id") == value.extension_id){
				$("#submit_files_name_"+(i+1)).val(value.file_name);
				break;
			}
		}
	});
	// 선택된 전문가를 희망 전문가 영역에 그린다.
	var body = $("#choiced_expert_list_body");
	var str = "";
	var index = 0;
	var choicedExpertCount = 0;
	body.empty();
	mChoiceExpertList = Object.assign([], mReceptionDetail.choiced_expert_list);
	$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
		if ( gfn_isNull(value.member_id) == false) {
			str += "<tr>";
			str += "	<td class='first'>";
			str += "		<input type='checkbox' id='choice_checkbox" + index + "' name='choice_expert_checkbox' value='" + value.member_id + "'>";
			str += "		<label for='choice_checkbox" + index + "'>&nbsp;</label>";
			str += "	</td>";
			str += "	<td>";
			str += "		<a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>";
			str += "			<span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span> ";
			str += "		</a>";
			str += "	</td>";
			str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + value.research + "</a></span></td>";
			str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + value.name + "</a></span></td>";
			str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + value.institution_name + "</a></span></td>";
			str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + value.institution_department + "</a></span></td>";
			str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + phoneFomatter(value.mobile_phone.replace(/\-/gi, ""), 0) + "</a></span></td>";
			if ( gfn_isNull(value.email) == false  ) {
				var id =value.email.split("@")[0].replace(/(?<=.{3})./gi,"*"); 
				var mail =value.email.split("@")[1];
			 	var userEmail= id+"@"+mail;
				str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + userEmail + "</a></span></td>";
			} else {
				str += "	<td><span></span></td>";
			}
			str += "</tr>";
			
			index++;
		}
		// 직접 지정한 전문가 이다.
		else {
			$('#custom_expert_list_body').show();
			
			var addStaffText = '<tr>' +
			'<td class="first"><input type="checkbox">&nbsp;<label for="">&nbsp;</label></div></td>'+
			'<td><label for="" class="hidden">연구분야</label><textarea name="" id="" cols="30" rows="2" class="w100" ></textarea></td>'+
			'<td><label for="" class="hidden">성명</label><input type="text" id="" class="form-control w100" /></td>'+
			'<td><label for="" class="hidden">기관명</label><input type="text" id="" class="form-control w100" /></td>'+
			'<td><label for="" class="hidden">부서</label><input type="text" id="" class="form-control w100" /></td>'+
			'<td><label for="" class="hidden">휴대전화</label><select name="" id="" class="w_8 fl d_input ls"><option value="010">010</option></select><span class="fl mc8">-</span><label for="" class="hidden">전화</label><input type="tel" id="" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl" ><span class="fl mc8 ls">-</span><label for="" class="hidden">전화</label><input type="tel" id="" maxlength="4" class="form-control brc-on-focusd-inline-block w_6 fl ls"></td>'+
			'<td class="last"><label for="" class="hidden">이메일</label><input type="text" id="" class="form-control w100 direct_companypart_email" placeholder="ex)XXX@email.com" /></td>' 
			+ '</tr>';
			$('#custom_expert_list_body').append(addStaffText);
			
			var $row = $("#custom_expert_list_body tr:eq(" + choicedExpertCount +")");
			$row.find('td:eq(1) textarea').val(value.research);
			$row.find('td:eq(2) input').val(value.name);
			$row.find('td:eq(3) input').val(value.institution_name);
			$row.find('td:eq(4) input').val(value.institution_department);
			var tempPhone = value.mobile_phone.split("-");
			$row.find('td:eq(5) input:eq(0)').val(tempPhone[1])
	    	$row.find('td:eq(5) input:eq(1)').val(tempPhone[2]);
			$row.find('td:eq(6) input').val(value.email);
				
			choicedExpertCount++;		    	
			
			var expert = new Object();
			expert.member_id = "";
			expert.national_science = "";
	    	expert.research = value.research;
	    	expert.name = value.name;
	    	expert.university = value.institution_name;
	    	expert.department = value.institution_department;
	    	expert.mobile_phone = value.mobile_phone;
	    	expert.email = value.email;
	    	
	    	mDirectChoiceExpertList.push(expert);
			
			$("#delete_direct_expert").show();
			$("#add_direct_expert").show();
			$("#checkbox_txtwrite").prop("checked", true);
		}
	});
	body.append(str);
	
	// mChoiceExpertList 에서 사용자가 직접 입력한 전문가는 삭제한다.
	var count = mChoiceExpertList.length;
	var indexCount = 0;
	while (true && count>0) {
		if ( gfn_isNull(mChoiceExpertList[indexCount].member_id) == true ) {
			mChoiceExpertList.splice(indexCount,1);
		} else {
			indexCount++;
		}
		
		if ( indexCount >= mChoiceExpertList.length) {
			break;
		}
	}
}

function searchReceptionDetailForMypage() {
	var comAjax = new ComAjax();
	comAjax.setUrl("/member/api/reception/detail");
	comAjax.setCallback(getReceptionCBForMypage);
	comAjax.addParam("reception_id", $("#reception_id").val());
	comAjax.ajax();
}

function getReceptionCBForMypage(data){
	mReceptionDetail = data.result_data;
	// 기관 정보
	$("#institution_reg_number").html("<span>" + mReceptionDetail.institution_reg_number + "</span>");
	$("#institution_name").html("<span>" + mReceptionDetail.institution_name + "</span>");
	$("#institution_address").html("<span>" + mReceptionDetail.institution_address + "</span>");
	$("#institution_phone").html("<span>" + mReceptionDetail.institution_phone + "</span>");
	$("#institution_owner_name").html("<span>" + mReceptionDetail.institution_owner_name + "</span>");
	$("#institution_industry").html("<span>" + mReceptionDetail.institution_industry + "</span>");
	$("#institution_business").html("<span>" + mReceptionDetail.institution_business + "</span>");
	$("#institution_foundataion_date").html("<span>" + mReceptionDetail.institution_foundataion_date + "</span>");
	$("#institution_foundataion_type").html("<span>" + mReceptionDetail.institution_foundataion_type + "</span>");
	$("#institution_classification").html("<span>" + mReceptionDetail.institution_classification + "</span>");
	$("#institution_type").html("<span>" + mReceptionDetail.institution_type + "</span>");
	if ( mReceptionDetail.institution_laboratory_yn == "Y") {
		$("#institution_laboratory").html("<span>" + "있음" + "</span>");
	} else {
		$("#institution_laboratory").html("<span>" + "없음" + "</span>");
	}
	$("#institution_employee_count").html("<span class='fl'>" + mReceptionDetail.institution_employee_count + "</span><span class='fl'>(명)</span>");
	var capitail = "<span class='fl mr5'>2021년</span><span class='fl'>" + mReceptionDetail.institution_capital_1.toString().money() + "</span><span class='fl mr10'>(원)</span><span class='fl mr20'>/</span>";
	capitail += "<span class='fl mr5'>2020년</span><span class='fl'>" + mReceptionDetail.institution_capital_2.toString().money() + "</span><span class='fl mr10'>(원)</span><span class='fl mr20'>/</span>";
	capitail += "<span class='fl mr5'>2019년</span><span class='fl'>" + mReceptionDetail.institution_capital_3.toString().money() + "</span><span class='fl'>(원)</span>";
	$("#institution_capital").html(capitail);
	$("#institution_total_sales").html("<span class='fl'>" + mReceptionDetail.institution_total_sales.toString().money() + "</span><span class='fl'>(원)</span>");
	// 연구책임자 정보
	$("#researcher_name").html("<span>" + mReceptionDetail.researcher_name + "</span>");
	$("#researcher_mobile_phone").html("<span>" + mReceptionDetail.researcher_mobile_phone + "</span>");
	$("#researcher_email").html("<span>" + mReceptionDetail.researcher_email + "</span>");
	$("#researcher_address").html("<span>" + mReceptionDetail.researcher_address + " " + mReceptionDetail.researcher_address_detail + "</span>");
	$("#researcher_institution_name").html("<span>" + mReceptionDetail.researcher_institution_name + "</span>");
	$("#researcher_institution_department").html("<span>" + mReceptionDetail.researcher_institution_department + "</span>");
	$("#researcher_institution_position").html("<span>" + mReceptionDetail.researcher_institution_position + "</span>");
	//기술컨설팅 요청사항
	$("#tech_consulting_type").html("<span>" + mReceptionDetail.tech_consulting_type + "</span>");
	$("#tech_consulting_campus").html("<span>" + mReceptionDetail.tech_consulting_campus + "</span>");
	$("#national_science").html("<span class='d_ib'>" + mReceptionDetail.tech_consulting_large + "</span> > <span class='d_ib'>" + mReceptionDetail.tech_consulting_middle + "</span> > <span class='d_ib'>" + mReceptionDetail.tech_consulting_small + "</span>");
	$("#tech_consulting_4th_industry_name").html("<span>" + mReceptionDetail.tech_consulting_4th_industry_name + "</span>");
	var purpose = mReceptionDetail.tech_consulting_purpose;
	if ( mReceptionDetail.tech_consulting_purpose == "8. 기타") {
		purpose += "(" + mReceptionDetail.tech_consulting_purpose_etc + ")"
	}
	$("#tech_consulting_purpose").html("<span>" + purpose + "</span>");
	$("#consulting_take_yn").html("<span>" + mReceptionDetail.tech_consulting_take_yn + "</span>");
	
	//기술 정보
	$("#tech_info_name").html("<span>" + mReceptionDetail.tech_info_name + "</span>");
	$("#tech_info_description").html("<span>" + mReceptionDetail.tech_info_description + "</span>");
	if ( mReceptionDetail.tech_consulting_type == "기술애로 컨설팅" ) {
		$("#tech_info_description_name_1").html("기술애로사항");
		$("#tech_info_description_1").html("<span>" + mReceptionDetail.tech_info_problems + "</span>");
		$("#tech_info_description_name_2").html("컨설팅 요청사항");
		$("#tech_info_description_2").html("<span>" + mReceptionDetail.tech_info_consulting_request + "</span>");
	} else {
		$("#tech_info_description_name_1").html("기술연구개발 내용");
		$("#tech_info_description_1").html("<span>" + mReceptionDetail.tech_info_rnd_description + "</span>");
		$("#tech_info_description_name_2").html("전문가 요청사항");
		$("#tech_info_description_2").html("<span>" + mReceptionDetail.tech_info_expert_request + "</span>");
	}
	$("#reception_rnd_text").html("<span>" + mReceptionDetail.tech_info_rnd_description+ "</span>");
	$("#tech_info_market_report").html("<span>" + mReceptionDetail.tech_info_market_report + "</span>");
	
	if ( gfn_isNull(mReceptionDetail.tech_info_upload_file_name) == false ) {
		$("#service_upload_file_label").html("<a href='/user/api/announcement/download/" + mReceptionDetail.tech_info_upload_file_id + "'><span>" + mReceptionDetail.tech_info_upload_file_name + "</span></a>");	
	}
	
	$("#tech_info_feature").html("<span>" + mReceptionDetail.tech_info_feature + "</span>");
	$("#tech_info_effect").html("<span>" + mReceptionDetail.tech_info_effect + "</span>");
	$("#tech_info_area").html("<span>" + mReceptionDetail.tech_info_area + "</span>");
	$("#tech_info_4th_industry").html("<span>" + mReceptionDetail.tech_info_4th_industry_name + "</span>");
	$("#tech_info_type").html("<span>" + mReceptionDetail.tech_info_type + "</span>");
}
