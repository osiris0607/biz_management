// 전문가 검색
function searchExpert(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/user/api/expert/search/paging");
		comAjax.setCallback(searchExpertListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "LARGE DESC");

		comAjax.addParam("large", $("#expert_large_selector").val());
		comAjax.addParam("middle", $("#expert_middle_selector").val());
		comAjax.addParam("small", $("#expert_small_selector").val());
		comAjax.addParam("research", $("#expert_research").val());
		comAjax.addParam("name", $("#expert_name").val());
		comAjax.addParam("university", $("#expert_institution_name").val());
		comAjax.ajax(); 
}	
var mExpertList;
function searchExpertListCB(data) {
	console.log(data);

	var body = $("#expert_list_body");
	body.empty();
	if ( data.result_data == null || data.result_data.length == 0 ) {
		$("#total_count").html("[총 <span class='fw500 font_blue'>0</span>건]");
		var str = "<tr>" + "<td colspan='10'>조회된 결과가 없습니다.</td>" + "</tr>";
		body.append(str);
	} else {
		var params = {
				divId : "pageNavi",
				pageIndex : "pageIndex",
				totalCount : data.result_data.length,
				eventName : "searchExpert"
			};

		gfnRenderPagingMain(params);
		
		$("#total_count").html("[총 <span class='fw500 font_blue'>" + data.result_data.length + "</span>건]");
		
		var str = "";
		var index = 0;
		mExpertList = data.result_data;
		$.each(mExpertList, function(key, value) {
			str += "<tr>";
			str += "	<td class='first'>";
			str += "		<input type='checkbox' id='checkbox" + index + "' name='expert_checkbox' value='" + value.member_id + "'>";
			str += "		<label for='checkbox" + index + "'>&nbsp;</label>";
			str += "	</td>";
			str += "	<td>";
			str += "		<a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>";
			if ( gfn_isNull(value.large) == true ){
				str += "		<span class='fl mr5'>" + "없음" + "</span> ";
			}
			else {
				str += "		<span class='fl mr5'>" + value.large + "</span>";
			}
			str += "			<span class='fl mr5'>&gt;</span>";
			if ( gfn_isNull(value.middle) == true ){
				str += "		<span class='fl mr5'>" + "없음" + "</span>";
			}
			else {
				str += "		<span class='fl mr5'>" + value.middle + "</span>";
			}
			str += "			<span class='fl mr5'>&gt;</span>";
			if ( gfn_isNull(value.small) == true ){
				str += "		<span class='fl mr5'>" + "없음" + "</span>";
			}
			else {
				str += "		<span class='fl mr5'>" + value.small + "</span>";
			}
			str += "		</a>";
			str += "	</td>";
			str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + value.research + "</a></span></td>";
			str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + value.name + "</a></span></td>";
			str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + value.university + "</a></span></td>";
			str += "	<td><span><a href='javascript:void(0);' onclick='expertDetail(\"" + value.member_id + "\");'>" + value.department + "</a></span></td>";
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
		});
		body.append(str);
	}
}
function expertDetail(id) {
	searchExpertDetail(id);
}
function searchExpertDetail(id) {
	var comAjax = new ComAjax();
	comAjax.setUrl("/member/api/reception/expert/detail");
	comAjax.setCallback(getExpertDetailCB);
	comAjax.addParam("member_id", id);
	comAjax.ajax();
}
function getExpertDetailCB(data){
	if ( data.result == false) {
		showPopup("전문가 정보가 없습니다.", "전문가 안내");	
		return false;
	}
	
	$('.reception_expert_popup_box, .popup_bg').fadeIn(350);
	
	$("#expert_detail_name").html("<span class='ls'>" + data.result_data.name+ "</span>");
	$("#expert_detail_institution_name").html("<span class='ls'>" + data.result_data.university + "</span>");
	$("#expert_detail_department").html("<span class='ls'>" + data.result_data.department + "</span>");
	$("#expert_detail_mobile_phone").html("<span class='ls'>" + phoneFomatter(data.result_data.mobile_phone.replace(/\-/gi, ""), 0) + "</span>");
	
	var userEmail = "";
	if ( gfn_isNull(data.result_data.email) == false  ) {
		var id =data.result_data.email.split("@")[0].replace(/(?<=.{3})./gi,"*"); 
		var mail =data.result_data.email.split("@")[1];
	 	userEmail= id+"@"+mail;
	}
	
	$("#expert_detail_email").html("<span class='ls'>" + userEmail + "</span>");
	$("#expert_detail_address").html("<span class='ls'>" + data.result_data.lab_address+ " " + data.result_data.lab_address_detail + "</span>");
	var temp = "<span class='fl mr5'>" + data.result_data.large + "</span><span class='fl mr5'>&gt;</span>" +
		  	   "<span class='fl mr5'>" + data.result_data.middle + "</span><span class='fl mr5'>&gt;</span>" +
		  	   "<span class='fl'>" + data.result_data.small + "</span>";
	$("#expert_detail_national_science").html(temp);
	$("#expert_detail_4th_industry").html("<span>" + data.result_data.four_industry_name + "</span>");
	$("#expert_detail_research").html("<span>" + data.result_data.research + "</span>");
	// 논문
	$("#thesis_1").html("<span>" + data.result_data.thesis_1 + "</span>");
	$("#thesis_name_1").html("<span>" + data.result_data.thesis_name_1 + "</span>");
	$("#thesis_date_1").html("<span>" + data.result_data.thesis_date_1 + "</span>");
	if (data.result_data.thesis_sci_yn_1 == "Y") {
		$("#treatise_check1").prop("checked", true);
	} 
	$("#thesis_2").html("<span>" + data.result_data.thesis_2 + "</span>");
	$("#thesis_name_2").html("<span>" + data.result_data.thesis_name_2 + "</span>");
	$("#thesis_date_2").html("<span>" + data.result_data.thesis_date_2 + "</span>");
	if (data.result_data.thesis_sci_yn_2 == "Y") {
		$("#treatise_check2").prop("checked", true);
	}
	$("#thesis_3").html("<span>" + data.result_data.thesis_3 + "</span>");
	$("#thesis_name_3").html("<span>" + data.result_data.thesis_name_3 + "</span>");
	$("#thesis_date_3").html("<span>" + data.result_data.thesis_date_3 + "</span>");
	if (data.result_data.thesis_sci_yn_3 == "Y") {
		$("#treatise_check3").prop("checked", true);
	} 
	// 특허
	if (data.result_data.iprs_enroll_1 == "R") {
		$("#iprs_enroll_1").html("<span>등록</span>");
	}
	else {
		$("#iprs_enroll_1").html("<span>출원</span>");
	}
	$("#iprs_1").html("<span>" + data.result_data.iprs_1 + "</span>");
	$("#iprs_number_1").html("<span class='ls'>" + data.result_data.iprs_number_1 + "</span>");
	$("#iprs_name_1").html("<span>" + data.result_data.iprs_name_1 + "</span>");
	$("#iprs_date_1").html("<span class='ls'>" + data.result_data.iprs_date_1 + "</span>");
	if (data.result_data.iprs_enroll_2 == "R") {
		$("#iprs_enroll_2").html("<span>등록</span>");
	}
	else {
		$("#iprs_enroll_2").html("<span>출원</span>");
	}
	$("#iprs_2").html("<span>" + data.result_data.iprs_2 + "</span>");
	$("#iprs_number_2").html("<span class='ls'>" + data.result_data.iprs_number_2 + "</span>");
	$("#iprs_name_2").html("<span>" + data.result_data.iprs_name_2 + "</span>");
	$("#iprs_date_2").html("<span class='ls'>" + data.result_data.iprs_date_2 + "</span>");
	if (data.result_data.iprs_enroll_3 == "R") {
		$("#iprs_enroll_3").html("<span>등록</span>");
	}
	else {
		$("#iprs_enroll_3").html("<span>출원</span>");
	}
	$("#iprs_3").html("<span>" + data.result_data.iprs_3 + "</span>");
	$("#iprs_number_3").html("<span class='ls'>" + data.result_data.iprs_number_3 + "</span>");
	$("#iprs_name_3").html("<span>" + data.result_data.iprs_name_3 + "</span>");
	$("#iprs_date_3").html("<span class='ls'>" + data.result_data.iprs_date_3 + "</span>");
	// 기술이전	
	$("#tech_tran_name_1").html("<span>" + data.result_data.tech_tran_name_1 + "</span>");
	$("#tech_tran_date_1").html("<span class='ls'>" + data.result_data.tech_tran_date_1 + "</span>");
	$("#tech_tran_company_1").html("<span>" + data.result_data.tech_tran_company_1 + "</span>");
	$("#tech_tran_name_2").html("<span>" + data.result_data.tech_tran_name_2 + "</span>");
	$("#tech_tran_date_2").html("<span class='ls'>" + data.result_data.tech_tran_date_2 + "</span>");
	$("#tech_tran_company_2").html("<span>" + data.result_data.tech_tran_company_2 + "</span>");
	$("#tech_tran_name_3").html("<span>" + data.result_data.tech_tran_name_3 + "</span>");
	$("#tech_tran_date_3").html("<span class='ls'>" + data.result_data.tech_tran_date_3 + "</span>");
	$("#tech_tran_company_3").html("<span>" + data.result_data.tech_tran_company_3 + "</span>");
	// RND
	$("#rnd_name_1").html("<span>" + data.result_data.rnd_name_1 + "</span>");
	temp = data.result_data.rnd_date_start_1 + " ~ " + data.result_data.rnd_date_end_1;
	$("#rnd_date_1").html("<span class='ls'>" + temp + "</span>");
	$("#rnd_class_1").html("<span class='ls'>" + data.result_data.rnd_class_1 + "</span>");
	$("#rnd_4th_industry_1").html("<span class='ls'>" + data.result_data.rnd_4th_industry_1_name + "</span>");
	$("#rnd_name_2").html("<span>" + data.result_data.rnd_name_2 + "</span>");
	temp = data.result_data.rnd_date_start_2 + " ~ " + data.result_data.rnd_date_end_2;
	$("#rnd_date_2").html("<span class='ls'>" + temp + "</span>");
	$("#rnd_class_2").html("<span class='ls'>" + data.result_data.rnd_class_2 + "</span>");
	$("#rnd_4th_industry_2").html("<span class='ls'>" + data.result_data.rnd_4th_industry_2_name + "</span>");
	$("#rnd_name_3").html("<span>" + data.result_data.rnd_name_3 + "</span>");
	temp = data.result_data.rnd_date_start_3 + " ~ " + data.result_data.rnd_date_end_3;
	$("#rnd_date_3").html("<span class='ls'>" + temp + "</span>");
	$("#rnd_class_3").html("<span class='ls'>" + data.result_data.rnd_class_3 + "</span>");
	$("#rnd_4th_industry_3").html("<span class='ls'>" + data.result_data.rnd_4th_industry_3_name + "</span>");
	
}

// 전문가 선택
var mChoiceExpertList = new Array();
function choiceExpert() {
	if ( $("input:checkbox[name='expert_checkbox']:checked").length == 0) {
		showPopup("먼저 전문가를 선택해 주시기 바랍니다.", "전문가 선택 안내");
		return;
	}
	// 최대 5명만 고를 수 있따.
	if ( mChoiceExpertList.length > 5 || $("input:checkbox[name='expert_checkbox']:checked").length > 5 || 
		 (mChoiceExpertList.length+$("input:checkbox[name='expert_checkbox']:checked").length) > 5	) {
		showPopup("전문가는 5명만 선택 가능합니다.", "전문가 선택 안내");
		return;
	}
	// 이미 선택된 전문가는 다시 선택하지 못한다.
	var isOK = true;
	$("input:checkbox[name='expert_checkbox']:checked").each(function () {
		var temp = $(this).val();
		for (var i=0; i<mChoiceExpertList.length; i++) {
			if ( mChoiceExpertList[i].member_id == $(this).val() ){
				isOK = false;
				break;
			}
		}
	});
	if ( isOK == false) {
		showPopup("이미 선택된 전문가가 있습니다. 다시 선택해 주시기 바랍니다.", "전문가 선택 안내");
		return;
	}
	// 선택된 전문가를 희망 전문가 영역에 그린다.
	var body = $("#choiced_expert_list_body");
	var str = "";
	var index = 0;
	body.empty();
	$("input:checkbox[name='expert_checkbox']:checked").each(function () {
		var memberId= $(this).val();
		$.each(mExpertList, function(key, value) {
			if ( value.member_id ==  memberId ){
				var expert = new Object();
				
				var str = "";
				if ( gfn_isNull(value.large) == true ){
					str += "없음";
				} else {
					str += value.large;
				}
				str += " > ";
				if ( gfn_isNull(value.middle) == true ){
					str += "없음";
				} else {
					str += value.middle;
				}
				str += " > ";
				if ( gfn_isNull(value.small) == true ){
					str += "없음";
				} else {
					str += value.small;
				}
				
				expert.member_id = value.member_id;
				expert.national_science = str;
				expert.research = value.research;
				expert.name = value.name;
				expert.institution_name = value.university;
				expert.institution_department = value.department;
				expert.mobile_phone = value.mobile_phone;
				expert.email = value.email;
				
				mChoiceExpertList.push(expert);
			}
		});
	});
	
	$.each(mChoiceExpertList, function(key, value) {
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
	});
	
	body.append(str);
}

// 선택된 전문가 삭제
function deleteExpert() {
	if ( $("input:checkbox[name='choice_expert_checkbox']:checked").length == 0) {
		showPopup("선택된 전문가가 없습니다.", "전문가 선택 안내");
		return;
	}
	
	// 선택된 전문가 삭제
	$("input:checkbox[name='choice_expert_checkbox']:checked").each(function () {
		for (var i=0; i<mChoiceExpertList.length; i++) {
			if ( mChoiceExpertList[i].member_id == $(this).val() ){
				mChoiceExpertList.splice(i, 1);
			}
		}
	});
	
	// 선택된 전문가를 희망 전문가 영역에 그린다.
	var body = $("#choiced_expert_list_body");
	var str = "";
	var index = 0;
	body.empty();
	$.each(mChoiceExpertList, function(key, value) {
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
	});
	
	body.append(str);
}

var mDirectChoiceExpertList = new Array();
var isDirectChoiceExpert = false;
function directChoiceExpert(status) {
	if ( status != "D0000003" ) {
		// table의 Row count 가 선택한 전문가 이다.
		var count = $("#custom_expert_list_body tr").length;
		if ( (mChoiceExpertList.length+count) == 0 ) {
			showPopup("반드시 1명 이상의 전문가를 선택해야 합니다.", "전문가 선택 안내");
			return false;
			
		}
		
		if ( mChoiceExpertList.length > 5 || count > 5 || (mChoiceExpertList.length+count) > 5	) {
				showPopup("전문가는 5명만 선택 가능합니다.", "전문가 선택 안내");
				mDirectChoiceExpertList = new Array();
				return false;
		}
		
		var isOK = true;
		mDirectChoiceExpertList = new Array();
		$("#custom_expert_list_body tr").each(function() {
			var $row = $(this); 
	        if ( $row.find('td:eq(1) textarea').val() == "" || $row.find('td:eq(2) input').val() == ""
	        	 || $row.find('td:eq(3) input').val() == "" || $row.find('td:eq(4) input').val() == ""
	        	 || $row.find('td:eq(5) select').val() == "" || $row.find('td:eq(5) input:eq(0)').val() == "" 
	        	 || $row.find('td:eq(5) input:eq(1)').val() == "" || $row.find('td:eq(6) input').val() == "" ) {
	        	showPopup("직접 입력한 전문가의 모든 항목은 필수입력입니다.", "전문가 선택 안내");
	        	isOK = false;
	        	return false;
	        }
	        var expert = new Object();
	    	expert.research = $row.find('td:eq(1) textarea').val();
	    	expert.name = $row.find('td:eq(2) input').val();
	    	expert.university = $row.find('td:eq(3) input').val();
	    	expert.department = $row.find('td:eq(4) input').val();
	    	expert.mobile_phone = $row.find('td:eq(5) select').val() + "-" + $row.find('td:eq(5) input:eq(0)').val() + "-" + $row.find('td:eq(5) input:eq(1)').val();
	    	expert.email = $row.find('td:eq(6) input').val();
	    	
	    	mDirectChoiceExpertList.push(expert);
	    	isDirectChoiceExpert = true;
		});
		
		return isOK;
		
	}
	else {
		$("#custom_expert_list_body tr").each(function() {
			var $row = $(this); 
	        var expert = new Object();
	    	expert.research = $row.find('td:eq(1) textarea').val();
	    	expert.name = $row.find('td:eq(2) input').val();
	    	expert.university = $row.find('td:eq(3) input').val();
	    	expert.department = $row.find('td:eq(4) input').val();
	    	expert.mobile_phone = $row.find('td:eq(5) select').val() + "-" + $row.find('td:eq(5) input:eq(0)').val() + "-" + $row.find('td:eq(5) input:eq(1)').val();
	    	expert.email = $row.find('td:eq(6) input').val();
	    	
	    	mDirectChoiceExpertList.push(expert);
	    	isDirectChoiceExpert = true;
		});
		
		return true;
	}
}

function initChoicedExpert(){
	mDirectChoiceExpertList = new Array();
	
	var isChecked = $("#custom_expert_list_body input[type='checkbox']").is(":checked");
	if ( isChecked == false) {
		showPopup("삭제할 전문가를 선택해야 합니다.", "전문가 선택 안내");
		return;
	}
	
	$("#custom_expert_list_body input[type='checkbox']:checked").each(function() {
		var $row = $(this).parents('tr'); 
    	$row.remove();
	});
	
	//$("#custom_expert_list_body input[type='checkbox']").prop("checked", false);
	
}

