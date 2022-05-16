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
		// 'M0000014 / D0000003' - 전문가 매칭 신청인 경우에는 제출서류를 보여주지 않는다.
		searchAnnouncementDetail("D0000003");
		searchReceptionDetail();
		makeExpertList();
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
	function makeExpertList() {

		var body = $("#expert_list_body");
		var str = "";
		body.empty();
		// D0000009 - 매칭 취소인 경우
		// D0000004 - 매칭 신청 완료
		// D0000005 - 매칭 진행 중 
		// 위의 경우는 희망 전문가를 보여준다.
		if ( mReceptionDetail.reception_status == "D0000009" 
			|| mReceptionDetail.reception_status == "D0000004" 
			|| mReceptionDetail.reception_status == "D0000005") {

			$("#expert_list_name").text("희망 전문가");
			$("#expert_list_col_1").text("번호");
			var index = 1;
			$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
				str += "<tr onClick='expertDetail(\""+ value.member_id +"\");' style='cursor:pointer;'>";
				str += "	<td class='first'>" + index + "</td>";
				str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";
				str += "	<td><span>" + value.research + "</span></td>";
				str += "	<td><span>" + value.name + "</span></td>";
				str += "	<td><span>" + value.institution_name + "</span></td>";
				str += "	<td><span>" + value.institution_department + "</span></td>";
				str += "	<td><span>" + phoneFomatter(value.mobile_phone.replace(/\-/gi, ""), 0) + "</span></td>";
				if ( gfn_isNull(value.email) == false  ) {
					var id =value.email.split("@")[0].replace(/(?<=.{3})./gi,"*"); 
					var mail =value.email.split("@")[1];
				 	var userEmail= id+"@"+mail;
					str += "	<td><span>" + userEmail + "</span></td>";
				} else {
					str += "	<td><span></span></td>";
				}
				str += "</tr>";
				
				index++;
			});
			body.append(str);
		} 
		// 관리자에서 희망 전문가 중에서 참여 여부까지 확인 한 상태이다.
		// 희망 전문가 중에서 참여 여부 의사가 한명도 없다면 재신청 메시지로 처리한다.
		// 희망 전문가 중에서 참여 여부 의사가 한명이라도 있으면 사용자가 최종 전문가로 선택할 수 있도록 한다.
		else if (mReceptionDetail.reception_status == "D0000006" ){
			$("#expert_list_name").text("회신 전문가");		

			// D0000003 인 경우 '참여'
			const experts = mReceptionDetail.choiced_expert_list.find((e) => e.participation_type === "D0000003" );
			// 희망 전문가 중에서 참여 의사가 없는 경우
			if ( experts == null || experts.length <=0 ) {
				$("#expert_list_participation_no").show();
				$("#match_retry").show();
			} 
			// 희망 전문가 중에서 참여 의사가 있는 경우
			else {
				$("#expert_list_participation_yes").show();
				$("#match_giveup").show();
				$("#match_complete").show();
				
				var index = 0;
				$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
					if ( value.participation_type == "D0000003") {
						str += "<tr onClick='expertDetail(\""+ value.member_id +"\");' style='cursor:pointer;'>";
						str += "	<td class='first'>";
						str += "		<input type='radio' id='choice_radio_" + index + "' name='choice_expert_radio' value='" + value.expert_id + "'>";
						str += "		<label for='choice_radio_" + index + "'>&nbsp;</label>";
						str += "	</td>";
						str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";
						str += "	<td><span>" + value.research + "</span></td>";
						str += "	<td><span>" + value.name + "</span></td>";
						str += "	<td><span>" + value.institution_name + "</span></td>";
						str += "	<td><span>" + value.institution_department + "</span></td>";
						str += "	<td><span>" + phoneFomatter(value.mobile_phone.replace(/\-/gi, ""), 0) + "</span></td>";
						if ( gfn_isNull(value.email) == false  ) {
							var id =value.email.split("@")[0].replace(/(?<=.{3})./gi,"*"); 
							var mail =value.email.split("@")[1];
						 	var userEmail= id+"@"+mail;
							str += "	<td><span>" + userEmail + "</span></td>";
						} else {
							str += "	<td><span></span></td>";
						}
						str += "</tr>";
						
						index++;
					}
				});
				body.append(str);
			}
		}
		// 사용자가 전문가를 선택한 상태
		else if (mReceptionDetail.reception_status == "D0000007" ){
			$("#expert_list_name").text("회신 전문가");		

			var index = 0;
			$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
				if ( value.participation_type == "D0000003") {
					str += "<tr onClick='expertDetail(\""+ value.member_id +"\");' style='cursor:pointer;'>";
					str += "	<td class='first'>";
					if ( value.choiced_yn == "Y") {
						str += "		<input type='radio' id='choice_radio_" + index + "' checked disabled>";
					} else {
						str += "		<input type='radio' id='choice_radio_" + index + "' disabled>";
					}
					str += "		<label for='choice_radio_" + index + "'>&nbsp;</label>";
					str += "	</td>";
					str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";
					str += "	<td><span>" + value.research + "</span></td>";
					str += "	<td><span>" + value.name + "</span></td>";
					str += "	<td><span>" + value.institution_name + "</span></td>";
					str += "	<td><span>" + value.institution_department + "</span></td>";
					str += "	<td><span>" + phoneFomatter(value.mobile_phone.replace(/\-/gi, ""), 0) + "</span></td>";
					if ( gfn_isNull(value.email) == false  ) {
						var id =value.email.split("@")[0].replace(/(?<=.{3})./gi,"*"); 
						var mail =value.email.split("@")[1];
					 	var userEmail= id+"@"+mail;
						str += "	<td><span>" + userEmail + "</span></td>";
					} else {
						str += "	<td><span></span></td>";
					}
					str += "</tr>";
					
					index++;
				}
			});
			body.append(str);
		} 
		// 매칭 포기한 상태
		else if (mReceptionDetail.reception_status == "D0000010" ){
			$("#expert_list_name").text("회신 전문가");		

			// D0000003 인 경우 '참여'
			const experts = mReceptionDetail.choiced_expert_list.find((e) => e.participation_type === "D0000003" );
			// 희망 전문가 중에서 참여 의사가 없는 경우
			if ( experts == null || experts.length <=0 ) {
			} 
			// 희망 전문가 중에서 참여 의사가 있는 경우
			else {
				$("#expert_list_col_1").text("번호");
				
				var index = 0;
				$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
					if ( value.participation_type == "D0000003") {
						str += "<tr onClick='expertDetail(\""+ value.member_id +"\");' style='cursor:pointer;'>";
						str += "	<td>" + (index+1) + "</td>";
						str += "	<td><span class='fl mr5'>" + unescapeHtml(value.national_science) + "</span></td>";
						str += "	<td><span>" + value.research + "</span></td>";
						str += "	<td><span>" + value.name + "</span></td>";
						str += "	<td><span>" + value.institution_name + "</span></td>";
						str += "	<td><span>" + value.institution_department + "</span></td>";
						str += "	<td><span>" + phoneFomatter(value.mobile_phone.replace(/\-/gi, ""), 0) + "</span></td>";
						if ( gfn_isNull(value.email) == false  ) {
							var id =value.email.split("@")[0].replace(/(?<=.{3})./gi,"*"); 
							var mail =value.email.split("@")[1];
						 	var userEmail= id+"@"+mail;
							str += "	<td><span>" + userEmail + "</span></td>";
						} else {
							str += "	<td><span></span></td>";
						}
						str += "</tr>";
						
						index++;
					}
				});
				body.append(str);
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

	function prepareChoiceExeprt() {
		if($("input:radio[name=choice_expert_radio]").is(":checked") == false) {
			alert("전문가를 선택하여야 합니다.");
			return;
		}
		$('.machhing_save_popup_box, .popup_bg').fadeIn(350);
	}

	function choiceExeprt() {
		var formData = new FormData();
		formData.append("reception_id", $("#reception_id").val() );
		formData.append("reception_status", "D0000007");
		formData.append("expert_id", $("input:radio[name=choice_expert_radio]:checked").val() );
		
		$.ajax({
		    type : "POST",
		    url : "/member/api/reception/match/expert/choice",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	location.href='/member/fwd/reception/main';
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function retryMatch() {
		var formData = new FormData();
		formData.append("reception_id", $("#reception_id").val() );
		formData.append("reception_status", "D0000003");
		
		$.ajax({
		    type : "POST",
		    url : "/member/api/reception/match/expert/retryMatch",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	location.href='/member/fwd/reception/main';
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
		$('.common_popup_box, .common_popup_box .popup_bg').fadeOut(350);
	}
	
</script>

<input type="hidden" id="reception_id" name="reception_id" value="${vo.reception_id}" />
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
										<input type="radio" id="research_reception_class" name="con_reception_class_g" value="창업아이디어" /> 
										<label for="research_reception_class">창업아이디어</label>
										<input type="radio" id="research_reception_class2" name="con_reception_class_g" value="기술개선/융합" /> 
										<label for="research_reception_class2">기술개선/융합</label>
									</td>
							   </tr>								   
								<tr id="consulting_campus_tr">
								   	<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="consulting_campus">소속 캠퍼스타운</label></span></th>
								   	<td>
								   		<input type="text" id="consulting_campus" class="form-control w90 fl mr5" title="소속 캠퍼스타운"/>
								   		<button type="button" class="gray_btn2 fl reception_campus_popup_open">찾아보기</button> 
				   					</td>
							   </tr>
							   <tr>
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
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>사전 컨설팅 실시 여부</span></th>
								   <td>
								   		<input type="radio" id="research_company_reception_practice" name="consulting_take_yn_radio" value="실시"  /> 
										<label for="research_company_reception_practice">실시</label>
										<input type="radio" id="research_company_reception_practice2" name="consulting_take_yn_radio" value="미실시" /> 
										<label for="research_company_reception_practice2">미실시</label>
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
								<tr id="sevice_request_tr">
								    <th scope="row">
								    	<span class="icon_box"><span class="necessary_icon">*</span>
								    	<label for="tech_info_market_report">시장/기술 동향</label></span>
							    	</th>
								    <td>
								    	<input type="text" id="tech_info_market_report" class="form-control w100" placeholder="기술의 시장성 및 기술 동향 입력" />
							    	</td> 										    
								</tr>	
								<tr id="sevice_content_tr">
								   	<th scope="row">
								   		<span class="icon_box"><span class="necessary_icon">*</span>
								   		<label for="reception_rnd_text">기술연구개발 내용</label></span>
							   		</th>
							    	<td>
							    		<input type="text" id="reception_rnd_text" class="form-control w100" placeholder="기업이 개발하고자 하는 기술 내용 입력" />
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
													<label id="service_upload_file_label" class="custom-file-label custom-control-label-write-company" for="service_upload_file">선택된 파일 없음</label>
												</div>															
										   </div>													   
										   <!--//업로드 버튼-->
									    </div>
									</td>  
							    </tr>
							 </tbody>						 
						</table>
						<!--//기술컨설팅 - 기술정보-->
	
						<!--희망전문가-->
						<div class="table_area clearfix">
							<div class="clearfix">
								<h4 class="fl" id="expert_list_name">희망 전문가</h4>
							</div>
							<div class="txt_reply" id="expert_list_participation_yes" style="display:none">
								<p class="fw box_reply">기술매칭사업 참여의향을 보내오신 전문가 목록입니다.</p>
								<p>원하시는 전문가를 선택하신 후, <span class="font_blue">[선택완료]</span>을 클릭하여 주세요.</p>
								<p>원하시는 전문가가 없어 매칭을 포기하실 경우, <span class="font_orange">[매칭포기]</span>를 클릭하여 주세요.</p>
							</div>
							<div class="txt_reply" id="expert_list_participation_no" style="display:none">
								<p class="fw box_reply">매칭의향을 보내온 전문가가 없어 전문가 매칭 신청이 취소되었습니다.</p>
								<p><span class="font_blue">[재신청]</span> 클릭하여 주시면 전문가 매칭 신청이 재가능합니다.</p>
								<p>귀한 시간 내주셔서 감사드립니다.</p>
							</div>
							
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
										<th scope="col" class="first" id="expert_list_col_1">&nbsp;</th>
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
							
						</div>
						<!--//희망전문가-->
						<div class="button_box clearfix fr pb20">
						
							<button type="button" class="green_btn fl mr5" onclick="$('.new_machhingpopup_box, .popup_bg').fadeIn(350);" id="match_retry" style="display:none">재신청</button>
							<button type="button" class="blue_btn4 fl mr5" onclick="$('.machhing_ab_popup_box, .popup_bg').fadeIn(350);" id="match_giveup" style="display:none">매칭포기</button>
							<button type="button" class="blue_btn fl mr5" onclick="prepareChoiceExeprt();"id="match_complete" style="display:none">선택완료</button>		
							<button type="button" class="gray_btn fl" onclick="location.href='/member/fwd/reception/main'">목록</button>
						</div>
					</div>	<!--//table_area-->							
				</div><!--//content_area-->
				<!--//기관-->
			</div>
		</div><!--//sub_contents-->
	</section>
</div>

<!--매칭신청완료 팝업-->
<div class="machhing_save_popup_box">		
	<div class="popup_bg"></div>
	<div class="machhing_save_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">매칭 선택 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">선택한 전문가</span>를 임명 하시겠습니까?</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn new_match" onclick="choiceExeprt();">확인</button>
				<button type="button" class="gray_btn popup_close_btn del_select mr5">취소</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//매칭신청완료 팝업-->

<!--매칭포기 팝업-->
<div class="machhing_ab_popup_box">		
	<div class="popup_bg"></div>
	<div class="machhing_ab_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">매칭포기 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0">매칭 포기 시 다시 사용할 수 없으며, 신규 매칭을 신청  해야 합니다. <br>
			<span class="font_blue">전문가 매칭을 포기</span> 하시겠습니까?</p>
		    <div class="popup_button_area_center">
		    	<button type="button" class="blue_btn popup_close_btn new_match" onclick="updateReceptionStatus('D0000010');">확인</button>
				<button type="button" class="gray_btn popup_close_btn del_select mr5">취소</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//!--매칭포기 팝업-->

<!--재신청 팝업-->
<div class="new_machhingpopup_box">		
	<div class="popup_bg"></div>
	<div class="new_machhingpopup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">재신청 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0">희망전문가를 다시 검색하셔서 전문가 매칭을 다시 하시려면<br /> <span class="font_blue">확인</span>을 클릭해 주세요.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn new_match fl mr5" onclick="retryMatch();">확인</button>
				<button type="button" class="gray_btn popup_close_btn fl">닫기</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//신규매칭 팝업-->

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
