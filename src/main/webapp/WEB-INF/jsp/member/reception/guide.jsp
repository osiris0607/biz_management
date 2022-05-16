<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var isConfrimMember = false;
	var isConfrimMemberContent = false;
	var isConfrimInstitution = false;
	var isConfrimInstitutionContent = false;
	var isConfrimInstitutionOK = false;

	$(document).ready(function() {
		initDepratmentType();
		searchMemberDetail();
		searchInstitutionDetail();
	});

	function searchMemberDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/detail'/>");
		comAjax.setCallback(getMemberDetailCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.ajax();
	}
	
	function getMemberDetailCB(data){
		$("#name").html("<span>" + data.result.name + "</span>");
		$("input:radio[name=user_department_type]:input[value='" + data.result.institution_type + "']").prop("checked", true);
		$("#member_id").html("<span>" + data.result.member_id + "</span>");
		var mobilePhoneList = data.result.mobile_phone.split("-");
		$("#mobile_phone_2").val(mobilePhoneList[1]);
		$("#mobile_phone_3").val(mobilePhoneList[2]);
		var emailList = data.result.email.split("@");
		$("#email_1").val(emailList[0]);
		$("#email_2").val(emailList[1]);
		$("#address").val(data.result.address);
		$("#address_detail").val(data.result.address_detail);
		$("#institution_name").val(data.result.university);
		$("#institution_address").val(data.result.lab_address);
		$("#institution_address_detail").val(data.result.lab_address_detail);
		if ( gfn_isNull(data.result.lab_phone) != true ) {
			var institutionPhoneList = data.result.lab_phone.split("-");
			$("#phone_1").val(institutionPhoneList[0]);
			$("#phone_2").val(institutionPhoneList[1]);
			$("#phone_3").val(institutionPhoneList[2]);
		}
		$("#department").val(data.result.department);
		$("#position").val(data.result.position);

		// 회원 정보 체크를 위한 비교
		if ( gfn_isNull(data.result.institution_type) == false && 
				 gfn_isNull(mobilePhoneList[1])== false && gfn_isNull(mobilePhoneList[2])== false &&
				 gfn_isNull(emailList[0])== false && gfn_isNull(emailList[1])== false &&
				 gfn_isNull(data.result.address)== false
			) {
			isConfrimMemberContent = true;
		}
	}

	function searchInstitutionDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/institution/detail'/>");
		comAjax.setCallback(getInstitutionCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.ajax();
	}
	
	function getInstitutionCB(data){
		// 기관 정보가 없으면 기관 정보 확인을 하지 않토록 한다.
		if (data.result == null || data.result.reg_no =="") {
			// 기술 매칭은 기관만 지원 가능하다.
			// 따라서 기술 매칭이 아니면 isConfrimInstitution == true로 하여 개인도 지원 가능토록 한다.
			// 기술 매칭 시 기관 정보가 없으면 접수로 넘어가지 못하게 한다.
			if ($("#announcement_type").val() != "D0000001" && $("#announcement_type").val() != "D0000002" ) {
				isConfrimInstitution = true;
			}
			$("#institution_area").hide();
			return;
		}

		isConfrimInstitution = true;
		$("input:radio[name=institution_department_type]:input[value='" + data.result.type + "']").prop("checked", true);
		$("#reg_no").val(data.result.reg_no);
		$("#company_name").val(data.result.name);
		$("#company_address").val(data.result.address);
		$("#company_address_detail").val(data.result.address_detail);
		var phoneList = data.result.phone.split("-");
		$("#institution_phone_1").val(phoneList[0]);
		$("#institution_phone_2").val(phoneList[1]);
		$("#institution_phone_3").val(phoneList[2]);
		$("#representative_name").val(data.result.representative_name);
		$("#industry_type").val(data.result.industry_type);
		$("#business_type").val(data.result.business_type);
		$("#foundation_date").val(data.result.foundation_date);
		$("input:radio[name=foundation_type_radio]:input[value='" + data.result.foundation_type + "']").prop("checked", true);
		$("input:radio[name=company_class_radio]:input[value='" + data.result.company_class + "']").prop("checked", true);
		$("input:radio[name=company_type_radio]:input[value='" + data.result.company_type + "']").prop("checked", true);
		$("input:radio[name=lab_exist_yn_radio]:input[value='" + data.result.lab_exist_yn + "']").prop("checked", true);


		// 기관 정보 체크를 위한 비교
		if ( !(gfn_isNull(data.result.type) || gfn_isNull(data.result.reg_no) || gfn_isNull(data.result.name) || 
				gfn_isNull(data.result.address)  ||
				 gfn_isNull(phoneList[0]) || gfn_isNull(phoneList[1]) || gfn_isNull(phoneList[2]) ||
				 gfn_isNull(data.result.representative_name) || gfn_isNull(data.result.industry_type) ||
				 gfn_isNull(data.result.business_type) || gfn_isNull(data.result.foundation_date) ||
				 gfn_isNull(data.result.foundation_type) || gfn_isNull(data.result.company_class) ||
				 gfn_isNull(data.result.company_type) || gfn_isNull(data.result.lab_exist_yn)
			)) {
			isConfrimInstitutionContent = true;
		}
	}	

	// 개인별 소속 유형를 만든다.
	function initDepratmentType(){
		$("#user_depratment_type").empty();
		var index = 1;
		var str = "";
       	<c:forEach items="${commonCode}" var="code">
			<c:if test="${code.master_id == 'M0000004'}">
				if (index == 1) {
					str += "<input type='radio' id='user_department_type_radio' name='user_department_type' value='${code.detail_id}' disabled />";
				}
				else {
					str += "<input type='radio' id='user_department_type_radio' name='user_department_type' value='${code.detail_id}'disabled />";
				}
				
				str += "<label for='user_department_type_radio'>${code.name}</label>";
				index++;
			</c:if>
		</c:forEach>
		$("#user_depratment_type").append(str);

		$("#institution_depratment_type").empty();
		var index = 1;
		var str = "";
       	<c:forEach items="${commonCode}" var="code">
			<c:if test="${code.master_id == 'M0000004'}">
				if (index == 1) {
					str += "<input type='radio' id='institution_department_type_radio' name='institution_department_type' value='${code.detail_id}' disabled />";
				}
				else {
					str += "<input type='radio' id='institution_department_type_radio' name='institution_department_type' value='${code.detail_id}'disabled />";
				}
				
				str += "<label for='institution_department_type_radio'>${code.name}</label>";
				index++;
			</c:if>
		</c:forEach>
		$("#institution_depratment_type").append(str);
	}

	function moveRegistration() {
		if ($("#announcement_type").val() == "D0000001" || $("#announcement_type").val() == "D0000002" ) {
			if ( isConfrimInstitution == false ) {
				showPopup("기술 매칭은 기관만 접수 가능합니다.<br>" +
						  "기관이 아닐 경우, 먼저 기관 등록을 해주시기 바랍니다.<br>" +
						  "또한, 상단에 사전 준비사항에서 기관등록을 확인해 주세요.", "접수 안내");
				return;
			}
		} else{
			isConfrimInstitutionOK = true;
		}

		if ( isConfrimMember == false ) {
			showPopup("회원 정보를 확인해 주시기 바랍니다.", "접수 안내");
			return;
		}
		if ( isConfrimInstitutionOK == false ) {
			showPopup("기관 정보를 확인해 주시기 바랍니다.", "접수 안내");
			return;
		}

		// 접수 화면 이동
		if ($("#announcement_type").val() == "D0000001") {
			location.href="/member/fwd/reception/match/consultingExpertRegistration?announcement_id=" + $("#announcement_id").val();;
		} 
		else if  ($("#announcement_type").val() == "D0000002") {
			location.href="/member/fwd/reception/match/researchExpertRegistration?announcement_id=" + $("#announcement_id").val();;
		} 
		else if  ($("#announcement_type").val() == "D0000003") {
			location.href="/member/fwd/reception/contest/registration?announcement_id=" + $("#announcement_id").val();;
		} 
		else if  ($("#announcement_type").val() == "D0000004") {
			location.href="/member/fwd/reception/proposal/registration?announcement_id=" + $("#announcement_id").val();;
		} 
		
	}

	function member_validation_popup() {
		// 접수 안내 문구가 다르게 표현되어야 한다.
		if ( isConfrimMemberContent == false ) {
			$("#member_confirm_guide_fail").show();
			$("#member_confirm_guide_success").hide();
		}
		else {
			$("#member_confirm_guide_fail").hide();
			$("#member_confirm_guide_success").show();
		}
		
		$('.validation_popup_box, .validation_popup_box .popup_bg').fadeIn(350);
	}

	function confirmMember() {
		if ( isConfrimMemberContent == false ){
			showPopup("회원 등록 정보의 (필수)값에 기재되어 있지 않은 내용이 있습니다. 필수 항목을 기재 후 다시 시도해 주시기 바랍니다.", "접수 안내");
			$('.validation_popup_box, .validation_popup_box .popup_bg').fadeOut(350);
			return;
		}
		else {
			isConfrimMember = true;
			$('.validation_popup_box, .validation_popup_box .popup_bg').fadeOut(350);
			$('.validation_confirm').css('display', 'none');
			$('.validation_complete').css('display', 'block');
		}
	}

	function institution_validation_popup() {
		// 접수 안내 문구가 다르게 표현되어야 한다.
		if ( isConfrimInstitution == false ) {
			$("#institution_confirm_guide_fail").show();
			$("#institution_confirm_guide_success").hide();
		}
		else {
			$("#institution_confirm_guide_fail").hide();
			$("#institution_confirm_guide_success").show();
		}

		$('.company_validation_popup_box, .company_validation_popup_box .popup_bg').fadeIn(350);
	}

	function confirmInstitution() {
		if ( isConfrimInstitutionContent == false ){
			showPopup("기관 정보의 (필수)값에 기재되어 있지 않은 내용이 있습니다. 필수 항목을 기재 후 다시 시도해 주시기 바랍니다.", "접수 안내");
			$('.company_validation_popup_box, .company_validation_popup_box .popup_bg').fadeOut(350);
			$('.company_validation_confirm').css('display', 'block');
			$('.company_validation_complete').css('display', 'none');
			
			return;
		}
		else {
			isConfrimInstitutionOK = true;
			$('.company_validation_popup_box, .company_validation_popup_box .popup_bg').fadeOut(350);
			$('.company_validation_confirm').css('display', 'none');
			$('.company_validation_complete').css('display', 'block');
		}
	}
	
	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}
	
</script>

<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />
<input type="hidden" id="announcement_type" name="announcement_type" value="${vo.announcement_type}" />
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3 class="hidden">접수 안내</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>접수</li>
						<li>접수</li>
					</ul>
				</div>
				<div class="content_area">
					<h3>접수 안내</h3>				
					<div class="reception_info_step list">
						<!--1단계-->
						<h4>사전 준비사항</h4>
						<ul class="txt_list">
							<li>신속한 과제신청을 위해 회원등록 및 기관등록 여부를 미리 확인합니다.</li>
							<li>과제신청에 불편이 없도록 사전에 사용자 권장 환경과 과제신청 유의사항을 확인하시기 바랍니다.</li>
						</ul>
						<div class="table_area">
							<table class="list fixed">
								<caption>리스트 화면</caption>
								<colgroup>
									<col style="width: 20%;">																		
									<col style="width: 65%;">
									<col style="width: 15%;">
								</colgroup>
								<thead>
								<tr>
									<th scope="col" class="first">구분</th>
									<th scope="col">준비사항</th>
									<th scope="col" class="last">확인 여부</th>
								</tr>
								</thead>
								<tbody>
									<tr>
										<td class="first">회원등록 확인</td>
										<td class="ta_l">
											<ul>
												<li>사업을 신청&middot;수행하기 위해서는 회원에 대한 상세정보가 반드시 사전에 등록되어 있어야 합니다. </li>
												<li>과제신청 시, 주관기관 책임자와 실무담당자는 회원가입이 필수적입니다. </li>
												<li><span class="fw500 font_blue">&#39;확인하기&#39;</span> 버튼을 클릭하여, 회원상세정보 등록여부를 확인해주시기 바랍니다. </li>
											</ul>
										</td>																		
										<td class="last">
											<button type="button" class="btn_blue validation_confirm" title="확인하기" onclick="member_validation_popup();">확인하기</button>
											<button type="button" class="btn_blue_ validation_complete" title="확인완료" style="display:none" disabled>확인완료</button>
										</td>
									</tr>
									<tr id="institution_area">
										<td class="first">기관등록 확인</td>
										<td class="ta_l">
											<ul>
												<li>과제를 수행하는 모든 기관(산/학/연 등)은 과제 신청 전, 기관정보 등록이 되어 있어야 합니다. </li>
												<li><span class="fw500 font_blue">&#39;확인하기&#39;</span> 버튼을 클릭하여, 기관정보 등록여부를 확인해주시기 바랍니다.  </li>		
											</ul>
										</td>																		
										<td class="last">
											<button type="button" class="btn_blue company_validation_confirm" title="확인하기" onclick="institution_validation_popup();">확인하기</button>
											<button type="button" class="btn_blue_ company_validation_complete" title="확인완료" style="display:none" disabled>확인완료</button>
										</td>
									</tr>																				
								</tbody>
							</table>																
						</div>
						
						<!--2단계-->
						<h4>사용자 권장 환경</h4>
						<ul class="txt_list">
							<li>본 사이트는 아래와 같은 환경에서 최적화 되어 있습니다.</li>
							<li>아래의 권장 운영 체제 및 브라우저가 아닌 다른 방법으로 이용하실 경우, 접수가 되지 않을 수 있으니 미리 확인하시기 바랍니다.</li>
						</ul>
						<div class="table_area">
							<table class="list fixed">
								<caption>리스트 화면</caption>
								<colgroup>
									<col style="width: 20%;">																		
									<col style="width: 80%;">
								</colgroup>
								<thead>
								<tr>
									<th scope="col" class="first">구분</th>
									<th scope="col" class="last">준비사항</th>
								</tr>
								</thead>
								<tbody>
									<tr>
										<td class="first">권장 운영체제(OS)</td>
										<td class="last ta_l">
											<ul>
												<li>본 포털은 <span class="ls">Windows 7</span> 이상의 운영체제를 권장합니다.</li>
												<li><span class="ls">Windows XP, Vista</span> 등 하위버전의 운영체제에서는 일부 기능이 지원되지 않을 수 있습니다.</li>			
											</ul>
										</td>																		
									</tr>
									<tr>
										<td class="first">권장 웹 브라우저</td>
										<td class="last ta_l">
											<ul>
												<li>본 포털은 <span class="ls">Internet Explore 10</span>버전 이상과 <span class="ls">Chrome, Firefox</span>등의 다양한 웹 브라우저를 지원합니다.</li>
												<li>웹 보안이 강화됨에 따라 보안에 취약한 <span class="ls">Internet Explorer 9</span> 이하 버전은 가능한 사용하지 말 것을 권고드립니다.</li>	
												<li>사용하시는 웹 브라우저가 <span class="ls">Internet Explorer 9</span> 이하일 경우, 상위버전으로 업그레이드 하시거나 <span class="ls">Google Chrome</span>을 이용하시기 바랍니다. </li>	
											</ul>
										</td>																		
									</tr>																				
								</tbody>
							</table>																
						</div>
	
						<!--3단계-->
						<h4>접수 유의사항</h4>
						<ul class="txt_list">
							<li>신청기간이 아닌 사업은 ‘공고목록’에서 조회되지 않습니다. 공고문 등을 통해 신청기간을 미리 확인하시기 바랍니다.</li>
							<li>신청기간 마감이 임박하면 사용자 폭주로 인해 시스템이 느려지거나, 정상적인 서비스가 어려울 수 있으니, 이 점 유의하시어 작성하시기 바랍니다.</li>
						</ul>
						<button type="button" class="blue_btn w100 reception_link_btn mb50" onclick="moveRegistration();">접수 페이지 바로가기 </button>
						<!-- <button type="button" class="blue_btn w100 reception_link_btn mb50" onclick="location.href='/member/fwd/mypage/institution'">마이 페이지 기관 정보 관리 바로가기 </button>
						<button type="button" class="blue_btn w100 reception_link_btn mb50" onclick="location.href='/member/fwd/mypage/main'">마이 페이지 개인 정보 관리 바로가기 </button> -->
					</div>
					
				</div><!--//content_area-->
			</div>
		</div>
	</section>
</div>


<!--개인 회원 확인하기 팝업-->
<div class="validation_popup_box">		
	<div class="popup_bg"></div>
	<div class="validation_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">회원 정보 확인</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn fr" onclick="$('.validation_popup_box, .validation_popup_box .popup_bg').fadeOut(350);"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">							
				<div class="table_area">
					<table class="write fixed">
							<caption>대표자 등록</caption>
							<colgroup>
								<col style="width: 20%;">																		
								<col style="width: 80%;">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">성명</th>
									<td id="name"></td>	
								</tr>									  
								<tr>
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>소속기관 유형</span></th>
									<td id="user_depratment_type">
									</td>													
								</tr>
								<tr>
									<th scope="row">아이디</th>
									<td class="ls" id="member_id"></td>	
								</tr>
								<tr>
									<th scope="row"><label for="pw_check">비밀번호</label></th>
									<td>
										<input type="password" id="pw_check" class="w_20 fl d_input2" placeholder="********" disabled title="비밀번호"/>
									</td>	
								</tr>
								<tr>
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>휴대전화</span></th>
									<td class="clearfix">
										<label for="mobile_phone_selector" class="hidden">휴대전화 앞번호</label>
										<select name="mobile_phone_selector" id="mobile_phone_selector" class="w_8 fl d_input" disabled>
											<option value="010">010</option>
										</select>
										<span style="display:block;" class="fl mc8">-</span>
										<label for="mobile_phone_2" class="hidden">휴대전화</label>
										<input type="tel" id="mobile_phone_2" maxlength="4" oninput="numberOnlyMaxLength(this);" title="휴대전화" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" disabled />
										<span style="display:block;" class="fl mc8">-</span>
										<label for="mobile_phone_3" class="hidden">휴대전화</label>
										<input type="tel" id="mobile_phone_3" maxlength="4" oninput="numberOnlyMaxLength(this);" title="휴대전화" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" disabled  />
									</td>	
								</tr>
								<tr>
									<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="email_1">이메일</label></span></th>
									<td>
										<input type="text" name="email_1" id="email_1" class="form-control w_20 fl d_input" disabled title="이메일"/>
										<span class="fl ml1 mr1 pt10 mail_f">@</span>
										<label for="email_2" class="hidden">이메일</label>
										<input type="text" name="email_2" id="email_2" class="form-control w_18 fl" disabled title="이메일"/>
									</td>	
								</tr>
								<tr>
									<th scope="row">
										<span class="icon_box">
											<span class="necessary_icon">*</span>
											<label for="address">주소</label>
										</span>
									</th>
									<td>										
										<input type="text" id="address" class="form-control w60 fl mr5" disabled title="주소"/>
										<label for="address_detail" class="hidden">주소</label>
										<input type="text" id="address_detail" class="form-control w30 fl mr5 d_input" disabled />
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="institution_name">기관명</label></th>
									<td>
										<input type="text" id="institution_name" class="form-control w60 fl d_input" disabled />																	
									</td>	
								</tr>
								<tr>
									<th scope="row"><label for="institution_address">기관 주소</label></th>
									<td>										
										<input type="text" id="institution_address" class="form-control w60 fl mr5" disabled title="기관 주소"/>
										<label for="institution_address_detail" class="hidden">주소</label>
										<input type="text" id="institution_address_detail" class="form-control w30 fl mr5 d_input" disabled />		
									</td>	
								</tr>
								<tr>
									<th scope="row">
										<label for="phone_1">전화</label>
									</th> 
									<td>
										<input type="number" id="phone_1" maxlength="3" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 전화">
										<span style="display:block;" class="fl mc8">-</span>
										<label for="phone_2" class="hidden">전화</label>
										<input type="number" id="phone_2" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 전화">
										<span style="display:block;" class="fl mc8 ls">-</span>
										<label for="phone_3" class="hidden">전화</label>
										<input type="number" id="phone_3" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 전화">
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="department">부서</label></th>
									<td>
										<input type="text" id="department" class="form-control w34 fl d_input" disabled  />
									</td>	
								</tr>
								<tr>
									<th scope="row"><label for="position">직책</label></th>
									<td>
										<input type="text" id="position" class="form-control w34 fl d_input" disabled  />
									</td>	
								</tr>
							</tbody>
						</table>
					<p class="member_popup_txt" id="member_confirm_guide_fail">
						변경된 정보는 <span class="icon_box"><span class="necessary_icon">*</span><span class="font_red2">(필수)</span></span>값에 기재되어 있지 않은 내용이 있습니다.<br /><a href="/member/fwd/mypage/main"><span class="font_blue">마이페이지</span></a>로 이동하셔서 진행해 주시기 바랍니다.
					</p>
					<p class="member_popup_txt" id="member_confirm_guide_success">변경된 정보는 <a href="/member/fwd/mypage/main"><span class="font_blue">마이페이지</span></a>로 이동하셔서 수정 후 접수 진행하시기 바랍니다.</p>
				</div>
			</div>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn" onclick="confirmMember();">확인</button>
			</div>
		</div>			
	</div> 
</div>
<!--//개인 회원 확인하기 팝업-->

<!--기관 회원 확인하기 팝업-->
<div class="company_validation_popup_box">		
	<div class="popup_bg"></div>
	<div class="validation_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">기관 정보 확인</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn fr" onclick="$('.company_validation_popup_box, .company_validation_popup_box .popup_bg').fadeOut(350);"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">							
				<div class="table_area">
					<!--기관정보-->
					<table class="write fixed">
						<caption>기관 정보</caption>
						<colgroup>
							<col style="width: 20%;">
							<col style="width: 80%;">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>소속기관 유형</span>
								</th>
								<td id="institution_depratment_type">
								</td> 
							</tr>									  
							<tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>
									<label for="reg_no">사업자 등록번호</label></span>
								</th>
								<td class="clearfix">
									<!--span>000-00-00000</span-->
									<input type="text" class="form-control input-sm mr5 fl" name="reg_no" id="reg_no" oninput="numberOnlyInput(this);" title="사업자 등록번호" disabled/>
								</td>
							</tr>
							<tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>
									<label for="company_name">기관명</label></span>
								</th>
								<td>
								    <!--span>000기관</span-->
									<input type="text" id="company_name" class="form-control w60 fl mr5" disabled title="기관명"/>
								</td> 
							</tr>
							<tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>
									<label for="company_address">주소</label></span>
								</th>
								<td>
									<input type="text" id="company_address" class="form-control w60 fl mr5" disabled title="주소" />
									<label for="company_address_detail" class="hidden">주소</label>
									<input type="text" id="company_address_detail" class="form-control w30 fl mr5" disabled/>
									
								</td> 
							</tr>
							<tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>
									<label for="institution_phone_1">전화</label></span>
								</th> 
								<td>								
									<input type="number" id="institution_phone_1" maxlength="3" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 전화" disabled />
									<span style="display:block;" class="fl mc8">-</span>
									<label for="institution_phone_2" class="hidden">전화</label>
									<input type="number" id="institution_phone_2" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 전화" disabled />
									<span style="display:block;" class="fl mc8 ls">-</span>
									<label for="institution_phone_3" class="hidden">전화</label>
									<input type="number" id="institution_phone_3" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl ls" title="기관 전화" disabled />
								</td>
							</tr>
							<tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>
									<label for="representative_name">대표자명</label></span>
								</th> 
								<td><input type="text" id="representative_name" class="form-control w_20" title="대표자명" disabled /></td>
							</tr>
							<tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>
									<label for="industry_type">업종</label></span>
								</th> 
								<td>
									<input type="text" id="industry_type" class="form-control w_34" title="업종" disabled />
								</td>
							</tr>
							<tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>
									<label for="business_type">업태</label></span>
								</th> 
								<td>
									<input type="text" id="business_type" class="form-control w_34" title="업태" disabled/>
								</td>
							</tr>
							<tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>
									<label for="foundation_date">설립일</label></span>
								</th> 
								<td>
									<div class="datepicker_area fl mr5">
										<input type="text" id="foundation_date" class="form-control w_14 mr5 ls" title="설립일" disabled />
									</div>
								</td> 
						   </tr>
						   <tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>설립 구분</span>
								</th> 
								<td>
									<input type="radio" id="mypage_company_classification_of_establishment1" name="foundation_type_radio" value="D0000001" checked disabled />
									<label for="mypage_company_classification_of_establishment1">영리</label>
									<input type="radio" id="mypage_company_classification_of_establishment2" name="foundation_type_radio" value="D0000002" disabled />
									<label for="mypage_company_classification_of_establishment2">비영리</label>								
								</td> 
						   </tr>
						   <tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>기업 분류</span>
								</th> 
								<td>
									<input type="radio" id="mypage_company_class1" name="company_class_radio" value="D0000001" checked disabled/>
									<label for="mypage_company_class1">대기업</label>
									<input type="radio" id="mypage_company_class2" name="company_class_radio" value="D0000002" disabled/>
									<label for="mypage_company_class2">중견기업</label>	
									<input type="radio" id="mypage_company_class3" name="company_class_radio" value="D0000003" disabled/>
									<label for="mypage_company_class3">중소기업</label>
									<input type="radio" id="mypage_company_class4" name="company_class_radio" value="D0000004" disabled/>
									<label for="mypage_company_class4">기타</label>	
								</td> 
						   </tr>
						   <tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>기업 유형</span>
								</th> 
								<td>
									<input type="radio" id="mypage_company_other_class1" name="company_type_radio" value="D0000001" checked />
									<label for="mypage_company_other_class1">여성기업</label>
									<input type="radio" id="mypage_company_other_class2" name="company_type_radio" value="D0000002" disabled/>
									<label for="mypage_company_other_class2">장애인기업</label>	
									<input type="radio" id="mypage_company_other_class3" name="company_type_radio" value="D0000003" disabled/>
									<label for="mypage_company_other_class3">사회적기업</label>
									<input type="radio" id="mypage_company_other_class4" name="company_type_radio" value="D0000004" disabled/>
									<label for="mypage_company_other_class4">해당 없음</label>	
								</td> 
						   </tr>
						   <tr>
								<th scope="row">
									<span class="icon_box"><span class="necessary_icon">*</span>기업부설연구소 유무</span></th> 
								<td>
									<input type="radio" id="mypage_company_or_lab1" name="lab_exist_yn_radio" value="Y" checked disabled/>
									<label for="mypage_company_or_lab1">있음</label>
									<input type="radio" id="mypage_company_or_lab2" name="lab_exist_yn_radio" value="N" disabled/>
									<label for="mypage_company_or_lab2">없음</label>	
								</td> 
						   </tr>
						</tbody>
					</table>
					<p class="member_popup_txt" id="institution_confirm_guide_fail">변경된 정보는 <span class="icon_box"><span class="necessary_icon">*</span><span class="font_red2">(필수)</span></span>값에 기재되어 있지 않은 내용이 있습니다.<br /><a href="/member/fwd/mypage/institution"><span class="font_blue">마이페이지 기관 정보 관리</span></a>로 이동하셔서 진행해 주시기 바랍니다.</p>
					<p class="member_popup_txt" id="institution_confirm_guide_success">변경된 정보는 <a href="/member/fwd/mypage/institution"><span class="font_blue">마이페이지</span></a>로 이동하셔서 수정 후 접수 진행하시기 바랍니다.</p>
				</div>
			</div>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn validation_popup_close" onclick="confirmInstitution();">확인</button>
			</div>
		</div>			
	</div> 
</div>
<!--//기관 회원 확인하기 팝업-->
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
				<button type="button" class="blue_btn popup_close_btn" title="확인">확인</button>
			</div>
		</div>						
	</div> 
</div>
 <!--//contents--> 
