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
	 	$("input:radio[name=con_radio_check]").click(function(){
	 		if ( $("input:radio[name=con_radio_check]:checked").val() == "8. 기타" ) {
	 			$("#con_purpose8_comment").val("");
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
		searchAnnouncementDetail();
		searchReceptionDetail();
		makeStatusDiplay();
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

	// Reception Status 별로 Expert list 가 달라진다.
	function makeStatusDiplay() {
		$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
			if ( value.choiced_yn == "Y") {
				$("#expert_name").html("<span>" + value.name + "</span>");
				$("#expert_department").html("<span>" + value.institution_department + "</span>");
				$("#expert_phone").html("<span>" + phoneFomatter(value.mobile_phone.replace(/\-/gi, ""), 0) + "</span>");
				var userEmail = "";
				if ( gfn_isNull(value.email) == false  ) {
					var id =value.email.split("@")[0].replace(/(?<=.{3})./gi,"*"); 
					var mail =value.email.split("@")[1];
				 	userEmail= id+"@"+mail;
				}
				$("#expert_email").html("<span>" + userEmail + "</span>");
				return false;
			}
		});

		// 접수 신청 완료 시 화면
		// 모든 Input을 막고 버튼도 목록만 남겨 둔다.
		if ( mReceptionDetail.reception_status == "D0000002" || mReceptionDetail.reception_status == "D0000011" || mReceptionDetail.reception_status == "D0000012") {
			$("#self_check_btn").hide();
			$("#submit_btn").hide();

			for (var i=0; i<$("#document_body tr").length; i++ ) {
				$("#submit_files_"+(i+1)).prop("disabled", true);
			}
		} 
	}

	function updateReceptionStatus(status) {
		$.ajax({
		    type : "POST",
		    url : "/member/api/reception/status/update",
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    data : {
	    				"reception_id" : $("#reception_id").val(),
	    				"reception_status" : status
	    		    },
		    success : function(data) {
		    	console.log(data.result);
	            if (data.result == 1) {
	            	if ( status == "D0000010") {
	            		location.href='/member/fwd/reception/main';
	        		}
	            }
	            else {
	            	if ( status == "D0000010") {
	            		alert("매칭 포기에 실패 하였습니다.");
	        		}
	            }
		    },
		    error : function(err) {
		    	alert(err.status);
		    }
		});
	}


	var mailAddress;
	function prepareModification() {
		// 제출 서류 확인
		for (var i=0; i<$("#document_body tr").length; i++ ) {
			// 필수 파일인 경우 Check
			if ( gfn_isNull($("#submit_files_name_"+(i+1)).val()) && ($("#submit_files_name_"+(i+1)).attr("type") == "D0000003") ) {
				showPopup( $("#submit_files_name_"+(i+1)).attr("field_name") + " 파일은 필수 선택입니다.", "접수 안내");
				return false;
			}
		}
		// 제셀프 체크리스트 확인
/* 		if ( mAnnouncementDetail.ext_check_list != null && mAnnouncementDetail.ext_check_list.length > 0 && 
			 mAnnouncementDetail.ext_check_list[0].all_use_yn == "D0000001" && isSelectSelfCheckList == false
		 	) {
			showPopup( "셀프 체크리스트를 확인해 주시기 바랍니다.", "접수 안내");
			return false;
		} */

		$('.reception_complete_popup_box, .popup_bg').fadeIn(350);
	}

	var isModification = false;
	function modification(status){
		// 창 닫기
		$('.temp_save_box, .popup_bg').fadeOut(1);
		$('.reception_complete_popup_box, .popup_bg').fadeOut(1);
		
		var formData = new FormData();
		formData.append("reception_status", status);
		formData.append("announcement_id", $("#announcement_id").val());
		formData.append("reception_id", $("#reception_id").val());
		formData.append("member_id", '${member_id}');
 		//제출 서류
		var submitFileExtIDList = new Array();
		for (var i=0; i<$("#document_body tr").length; i++ ) {
			if ( $("#submit_files_"+(i+1))[0].files[0] != null ) {
				submitFileExtIDList.push($("#submit_files_name_"+(i+1)).attr("ext_id"));
				formData.append("submit_files", $("#submit_files_"+(i+1))[0].files[0]);
			}
		}
		formData.append("submit_file_ext_id_list", submitFileExtIDList);
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
		    url : "/member/api/reception/match/submitCompleteReception",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		        	showPopup("접수 완료되었습니다.", "접수 안내");
		        	isModification = true;
		        } else {
		        	showPopup("접수 완료에 실패하였습니다. 다시 시도해 주시기 바랍니다.", "접수 안내");
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
			location.href = "/member/fwd/reception/main";
		}
		$('.common_popup_box, .common_popup_box .popup_bg').fadeOut(350);
	}
</script>

<input type="hidden" id="reception_id" name="reception_id" value="${vo.reception_id}" />
<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />

<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>					
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>접수</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>접수</li>
						<li>접수</li>
					</ul>
				</div>
				<!--기관-->
				<div class="content_area copmpany_area not_view_reception" id="copmpany_area" >													
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
									<td><input disabled type="text" id="company_address" title="주소" class="form-control w100 fl mr5" placeholder="" />
										<!--button class="gray_btn fl">찾기</button--></td> 
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
							<label for="companyinfo_check" class="hidden">check</label>
							<input type="checkbox" id="companyinfo_check" onclick="writeReserchInfo();">
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
									    <input type="text" name="email_1" id="email_1" class="form-control w_20 fl ls" />
									    <span class="fl ml1 mr1 pt10 mail_f">@</span>
									    <label for="email_2" class="hidden">이메일</label>
									    <input type="text" name="email_2" id="email_2" class="form-control w_18 fl ls" disabled  />	
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
										<input disabled type="text" id="research_address_detail" title="주소" class="form-control w30 fl mr5" placeholder="" />
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
													<label class="custom-file-label custom-control-label-write-company" id="service_upload_file_label" for="service_upload_file">선택된 파일 없음</label>
												</div>															
										   </div>													   
										   <!--//업로드 버튼-->
									    </div>
									</td>  
							    </tr>
							 </tbody>						 
						</table>
						<!--//기술컨설팅 - 기술정보-->
						
						<h4>전문가 정보</h4>	
						<table class="write fixed">
							<caption>전문가 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>
								<tr>
								    <th scope="row"><span class="icon_box">성명</span></th>
								    <td id="expert_name"></td> 
							    </tr>
								<tr>
								    <th scope="row"><span class="icon_box">소속기관</span></th>
								    <td id="expert_department"></td> 
							    </tr>
							    <tr>
								    <th scope="row"><span class="icon_box">휴대전화</span></th>
								    <td id="expert_phone"></td> 
							    </tr>
							    <tr>
								    <th scope="row"><span class="icon_box">이메일</span></th>
								    <td class="clearfix" id="expert_email"></td>
							    </tr>										   
							 </tbody>						 
						</table>
						
						<!--기술컨설팅 -제출서류 -->
						<h4>제출 서류</h4>	
						<table class="write fixed">
							<caption>제출 서류</caption>
							<colgroup>
								<col style="width: 15%;">
								<col style="width: 40%;">
								<col style="width: 45%;">
							</colgroup>
							<tbody id="document_body">
							<label for="submit_files_name_1" class="hidden">파일찾기</label>
							<label for="submit_files_name_2" class="hidden">파일찾기</label>
							<label for="submit_files_name_3" class="hidden">파일찾기</label>
							<label for="submit_files_name_4" class="hidden">파일찾기</label>
							<label for="submit_files_name_5" class="hidden">파일찾기</label>
							<label for="submit_files_name_6" class="hidden">파일찾기</label>
							
							 </tbody>						 
						</table>									
						<!--//기술컨설팅 -제출서류 -->
	
						<!--//희망전문가-->
						<div class="button_box clearfix fr pb20">
							<button type="button" class="blue_btn fl mr5" id="submit_btn" onclick="prepareModification();">접수신청완료</button>
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
			<div class="popup_titlebox_txt">
				<p><span class="font_blue">[예]</span> 버튼을 누르면 사업 신청서 제출이 완료되며, 수정은 불가능합니다.</p>							
				<p class="font_blue fz_b"><span class="fw500 font_blue">접수 신청서를 제출하시겠습니까?</span></p>
				<p>- 귀한 시간 내주셔서 감사드립니다. -</p>
			</div>
		    <div class="popup_button_area_center">
				<button type="submit" class="blue_btn mr5" onclick="modification('D0000002');">예</button>
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