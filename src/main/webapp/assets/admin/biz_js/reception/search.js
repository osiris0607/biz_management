var mReceptionDetail;

// Announcement
var receptionStatus;
var mDocList;

//member
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


function searchAnnouncementDetail(status) {
	receptionStatus = status;
	var comAjax = new ComAjax();
	comAjax.setUrl("/admin/api/announcement/match/detail");
	comAjax.setCallback(getAnnouncementCB);
	comAjax.addParam("announcement_id", $("#announcement_id").val());
	comAjax.ajax();
}

function getAnnouncementCB(data){
	if ( data.result.ext_field_list != null) {
		var ext_field_list = data.result.ext_field_list;
		
		for(var i=0; i<ext_field_list.length; i++) {
			// D0000002 는 사용안함이다. 화면에서 안보이게 처리
			if ( ext_field_list[i].ext_field_yn == "D0000002" ){
				// 기관 정보
				if ( ext_field_list[i].ext_type == "D0000001" ) {
					if ( ext_field_list[i].ext_field_name == "사업자 등록번호" ) {
						$("#institution_reg_number_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "기관명" ) {
						$("#institution_name_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "주소" ) {
						$("#institution_address_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "전화" ) {
						$("#institution_phone_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "대표자명" ) {
						$("#institution_owner_name_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "업종" ) {
						$("#institution_industry_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "업태" ) {
						$("#institution_business_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "설립일" ) {
						$("#institution_foundataion_date_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "설립 구분" ) {
						$("#institution_foundataion_type_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "기업 분류" ) {
						$("#institution_classification_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "기업 유형" ) {
						$("#institution_type_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "기업부설연구소 유무" ) {
						$("#institution_laboratory_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "종업원수" ) {
						$("#institution_employee_count_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "매출액(최근3년)" ) {
						$("#institution_capital_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "자본금" ) {
						$("#institution_total_sales_tr").hide();
					}
				}
				// 연구책임자 정보
				if ( ext_field_list[i].ext_type == "D0000002" ) {
					if ( ext_field_list[i].ext_field_name == "성명" ) {
						$("#researcher_name_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "휴대전화" ) {
						$("#researcher_mobile_phone_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "이메일" ) {
						$("#researcher_email_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "주소" ) {
						$("#researcher_address_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "기관명" ) {
						$("#researcher_institution_name_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "부서" ) {
						$("#researcher_institution_department_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "직책" ) {
						$("#researcher_institution_position_tr").hide();
					}
				}
				// 기술컨설팅 요청사항
				if ( ext_field_list[i].ext_type == "D0000003" ) {
					if ( ext_field_list[i].ext_field_name == "구분" ) {
						$("#tech_consulting_type_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "소속 캠퍼스타운" ) {
						$("#tech_consulting_campus_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "국가기술분류체계" ) {
						$("#national_science_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "4차 산업혁명 기술분류" ) {
						$("#tech_consulting_4th_industry_name_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "컨설팅 목적" ) {
						$("#tech_consulting_purpose_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "사전 컨설팅 실시 여부" ) {
						$("#consulting_purpose_tr").hide();
					}
				}
				// 기술 정보
				if ( ext_field_list[i].ext_type == "D0000004" ) {
					if ( ext_field_list[i].ext_field_name == "제품/서비스명" || ext_field_list[i].ext_field_name == "기술명") {
						$("#sevice_name_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "제품/서비스 내용" || ext_field_list[i].ext_field_name == "기술개요"	) {
						$("#sevice_description_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "기술애로사항" || ext_field_list[i].ext_field_name == "기술연구개발 내용") {
						$("#sevice_content_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "컨설팅 요청사항" || ext_field_list[i].ext_field_name == "전문가 요청사항") {
						$("#sevice_request_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "시장/기술 동향") {
						$("#sevice_request_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "첨부 파일" ) {
						$("#sevice_research_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "국가과학기술분류" ) {
						$("#sevice_national_science_large_tr").hide();
						$("#sevice_national_science_middle_tr").hide();
						$("#sevice_national_science_small_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "특징" ) {
						$("#sevice_feature_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "기대효과" ) {
						$("#sevice_effect_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "실증분야" ) {
						$("#tech_info_type_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "4차 산업혁명 기술분류" ) {
						$("#tech_info_4th_industry_tr").hide();
					}
					if ( ext_field_list[i].ext_field_name == "적용 분야" ) {
						$("#tech_info_area_tr").hide();
					}
				}
			}
		}
		
		if ( receptionStatus != "D0000003" && receptionStatus != "D0000004" ) {
			// 제출 서류는 추가 버튼으로 서류 종류가 늘어난다. 따라서 동적 생성한다.
			$("#document_body").empty();
			var index = 0;
			mDocList = data.result.ext_field_list;
			// '필수'인 경우
			var requiredDocList = data.result.ext_field_list.filter(item => (item.ext_type === 'D0000005' && item.ext_field_yn === "D0000003"));
			var requiredDoc = "";
			$.each(requiredDocList, function(key, value) {
				requiredDoc += "<tr>";
				requiredDoc += "	<td>" + (index+1) + "</td>";
				requiredDoc += "	<td><span><span class='font_red'><strong>(필수)</strong></span>" + value.ext_field_name + "</span></td>";
				requiredDoc += "	<td id='submit_files_name_" + index + "' ext_id='" + value.extension_id + "'></td>";
				requiredDoc += "	<td><input type='radio' name='documents_submitted_" + index + "_1' /><label>&nbsp;</label></td>";
				requiredDoc += "	<td><input type='radio' name='documents_submitted_" + index + "_2' /><label>&nbsp;</label></td>";
				requiredDoc += "</tr>";
				index++;
			});
			// '사용'인 경우
			var normalDocList = data.result.ext_field_list.filter(item => (item.ext_type === 'D0000005' && item.ext_field_yn === "D0000001"));
			$.each(normalDocList, function(key, value) {
				requiredDoc += "<tr>";
				requiredDoc += "	<td>" + (index+1) + "</td>";
				requiredDoc += "	<td><span><span class='font_blue'><strong>(선택)</strong></span>" + value.ext_field_name + "</span></td>";
				requiredDoc += "	<td id='submit_files_name_" + index + "' ext_id='" + value.extension_id + "'></td>";
				requiredDoc += "	<td><input type='radio' name='documents_submitted_" + index + "_1' /><label>&nbsp;</label></td>";
				requiredDoc += "	<td><input type='radio' name='documents_submitted_" + index + "_2' /><label>&nbsp;</label></td>";
				requiredDoc += "</tr>";
				index++;
			});
			
			$("#document_body").append(requiredDoc);
		}
    }	
}

var receptionDetailStatus;
function searchReceptionDetail(status) {
	receptionDetailStatus = status;
	var comAjax = new ComAjax();
	comAjax.setUrl("/admin/api/reception/detail");
	comAjax.setCallback(getReceptionCB);
	comAjax.addParam("reception_id", $("#reception_id").val());
	comAjax.ajax();
}

function getReceptionCB(data){
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
	var capitail = "<span class='fl mr5'>2020년</span><span class='fl'>" + mReceptionDetail.institution_capital_1.toString().money() + "</span><span class='fl mr10'>(원)</span><span class='fl mr20'>/</span>";
	capitail += "<span class='fl mr5'>2020년</span><span class='fl'>" + mReceptionDetail.institution_capital_2.toString().money() + "</span><span class='fl mr10'>(원)</span><span class='fl mr20'>/</span>";
	capitail += "<span class='fl mr5'>2018년</span><span class='fl'>" + mReceptionDetail.institution_capital_3.toString().money() + "</span><span class='fl'>(원)</span>";
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
	$("#national_science").html("<span>" + mReceptionDetail.tech_consulting_large + "</span> > <span>" + mReceptionDetail.tech_consulting_middle + "</span> > <span>" + mReceptionDetail.tech_consulting_small + "</span>");
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
		$("#tech_info_description_name_1").html("<span class='necessary_icon'>*</span><span class='icon_box'>기술애로사항</span>");
		$("#tech_info_description_1").html("<span>" + mReceptionDetail.tech_info_problems + "</span>");
		$("#tech_info_description_name_2").html("<span class='necessary_icon'>*</span><span class='icon_box'>컨설팅 요청사항</span>");
		$("#tech_info_description_2").html("<span>" + mReceptionDetail.tech_info_consulting_request + "</span>");
	} else {
		$("#tech_info_description_name_1").html("<span class='necessary_icon'>*</span><span class='icon_box'>기술연구개발 내용</span>");
		$("#tech_info_description_1").html("<span>" + mReceptionDetail.tech_info_rnd_description + "</span>");
		$("#tech_info_description_name_2").html("<span class='necessary_icon'>*</span><span class='icon_box'>전문가 요청사항</span>");
		$("#tech_info_description_2").html("<span>" + mReceptionDetail.tech_info_expert_request + "</span>");
	}
	$("#reception_rnd_text").html("<span>" + mReceptionDetail.tech_info_rnd_description+ "</span>");
	$("#tech_info_market_report").html("<span>" + mReceptionDetail.tech_info_market_report + "</span>");
	
	if ( gfn_isNull(mReceptionDetail.tech_info_upload_file_name) == false ) {
		$("#service_upload_file_label").html("<a href='/user/api/announcement/download/" + mReceptionDetail.tech_info_upload_file_id + "'><span>" + mReceptionDetail.tech_info_upload_file_name + "</span></a>");	
	}
	
	
	$("#tech_info_science_type").html("<span class='fl mr5'>" + mReceptionDetail.tech_info_large + "</span><span class='fl mr5'>&gt;</span><span class='fl mr5'>" + mReceptionDetail.tech_info_middle +"</span><span class='fl mr5'>&gt;</span><span class='fl'>" + mReceptionDetail.tech_info_small + "</span>");
	
	if ( gfn_isNull(mReceptionDetail.tech_info_large) == false ) {
		$("#tech_info_large").val(mReceptionDetail.tech_info_large).trigger('change');	
	}
	if ( gfn_isNull(mReceptionDetail.tech_info_middle) == false ) {
		$("#tech_info_middle").val(mReceptionDetail.tech_info_middle).trigger('change');	
	}
	if ( gfn_isNull(mReceptionDetail.tech_info_small) == false ) {
		$("#tech_info_small").val(mReceptionDetail.tech_info_small).trigger('change');	
	}
	$("#tech_info_feature").html("<span>" + mReceptionDetail.tech_info_feature + "</span>");
	$("#tech_info_effect").html("<span>" + mReceptionDetail.tech_info_effect + "</span>");
	$("#tech_info_area").html("<span>" + mReceptionDetail.tech_info_area + "</span>");
	$("#tech_info_4th_industry").html("<span>" + mReceptionDetail.tech_info_4th_industry_name + "</span>");
	$("#tech_info_type").html("<span>" + mReceptionDetail.tech_info_type + "</span>");
	
	// 전문가 영역
	createExpertHtml();

	//제출 서류
	$.each(mReceptionDetail.submit_files_list, function(key, value) {
		for (var i=0; i<$("#document_body tr").length; i++ ) {
			if ( $("#submit_files_name_"+i).attr("ext_id") == value.extension_id){
				$("#submit_files_name_"+i).attr("file_id", value.file_id);
				$("#submit_files_name_"+i).html("<a href='/user/api/announcement/download/" + value.file_id + "'><span>" + value.file_name + "</span></a>");
				$("input:radio[name=documents_submitted_" + i + "_1]").prop("checked", true);
				break;
			}
		}
	});
}

function createExpertHtml() {
	if ( receptionDetailStatus == "D0000005" ) {
		// 선택된 전문가를 희망 전문가 영역에 그린다.
		var body = $("#expert_body");
		var str = "";
		var index = 0;
		body.empty();
		$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
			str += "<tr expert_id='" + value.expert_id + "'>";
			str += "	<td><input type='checkbox' name='prioiry_checkbox' id='checkbox_" + index + "' member_id='" + value.member_id + "' email='" + value.email + "' sms='" + value.mobile_phone + "'>";
			str += "		<label for='checkbox_" + index + "' class='checkbox_a'>&nbsp;</label>";
			str += "	</td>";
			str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";;
			str += "	<td><span>" + value.research + "</span></td>";
			str += "	<td><span>" + value.name + "</span></td>";
			str += "	<td><span>" + value.institution_name + "</span></td>";
			str += "	<td><span>" + value.institution_department + "</span></td>";
			str += "	<td><span>" + value.mobile_phone + "</span></td>";
			str += "	<td><span>" + value.email + "</span></td>";
			if ( gfn_isNull(value.member_id) == false) {
				str += "	<td><span>전문가 풀</span></td>";
			} else {
				str += "	<td><span>직접 입력</span></td>";
			}
			
			// 미회신
			if (value.participation_type == "D0000001" || value.participation_type == "D0000004") {
				str += "	<td class='td_txt'><span>미회신</span></td>";
				str += "	<td class='s_h'></td>";
			// 미참여
			} else if (value.participation_type == "D0000002") {
				str += "	<td class='td_txt'><span>미참여</span></td>";
				str += "	<td class='s_h'></td>";
			// 참여
			} else if (value.participation_type == "D0000003") {
				str += "	<td class='td_txt'><span>참여</span></td>";
				str += "	<td class='s_h'>";
				str += "	<button type='button' class='gray_btn2 mb5' onclick='moveUp(this)'>▲</button><br>";
				str += "	<button type='button' class='gray_btn2' onclick='moveDown(this)'>▼</button><br>";
			} 
			str += "</tr>";
			
			index++;
		});
		body.append(str);		
	} else if ( receptionDetailStatus == "D0000006" ) { 
		// 선택된 전문가를 희망 전문가 영역에 그린다.
		var body = $("#expert_body");
		var str = "";
		var index = 0;
		body.empty();
		$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
			// D0000006 - 매칭 신청 완료 상태로 참여하기로 한 전문가만 보여지게 한다.
			if ( value.participation_type == "D0000003" ) {
				str += "<tr expert_id='" + value.expert_id + "'>";
				str += "	 <td><span>" + (index+1) + "</span></td>";
				str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";;
				str += "	<td><span>" + value.research + "</span></td>";
				str += "	<td><span>" + value.name + "</span></td>";
				str += "	<td><span>" + value.institution_name + "</span></td>";
				str += "	<td><span>" + value.institution_department + "</span></td>";
				str += "	<td><span>" + value.mobile_phone + "</span></td>";
				str += "	<td><span>" + value.email + "</span></td>";
				if ( gfn_isNull(value.member_id) == false) {
					str += "	<td><span>전문가 풀</span></td>";
				} else {
					str += "	<td><span>직접 입력</span></td>";
				}
			}
			str += "</tr>";
			index++;
		});
		body.append(str);	
	} else {
		// 선택된 전문가를 희망 전문가 영역에 그린다.
		var body = $("#expert_body");
		var str = "";
		var index = 0;
		body.empty();
		$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
			str += "<tr>";
			str += "	 <td><span>" + (index+1) + "</span></td>";
			str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";;
			str += "	<td><span>" + value.research + "</span></td>";
			str += "	<td><span>" + value.name + "</span></td>";
			str += "	<td><span>" + value.institution_name + "</span></td>";
			str += "	<td><span>" + value.institution_department + "</span></td>";
			str += "	<td><span>" + value.mobile_phone + "</span></td>";
			str += "	<td><span>" + value.email + "</span></td>";
			if ( gfn_isNull(value.member_id) == false) {
				str += "	<td><span>전문가 풀</span></td>";
			} else {
				str += "	<td><span>직접 입력</span></td>";
			}
			str += "</tr>";
			
			index++;
		});
		body.append(str);		
	}
}

var isDownloaded = false;
function downloadAllsubmitFile(){
	var iFrameCnt = 0;
	for (var i=0; i<$("#document_body tr").length; i++ ) {
		if ( gfn_isNull($("#submit_files_name_"+i).text()) != true ) {
			var url = "/user/api/announcement/download/" + $("#submit_files_name_"+i).attr("file_id");
			if ( isDownloaded != true) {
				// 보이지 않는 iframe 생성, name는 숫자로
				var frm = $('<iframe name="' + iFrameCnt + '" style="display: none;"></iframe>');
			    frm.appendTo("body"); 
			    // Timeout
			    setTimeout(function() {
		    	}, 2000);		
			}
			$("iframe[name=" + iFrameCnt + "]").attr("src", url);
			iFrameCnt++;
		}
	}
	isDownloaded = true;
}








