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
	 	// match-consulting-search-data.js 에 구현
	 	searchMemberDetail('${member_id}');
		searchInstitutionDetail('${member_id}');
		// 'M0000014 / D0000003' - 접수상태 중에서 전문가 매칭 신청인 경우에는 제출서류를 보여주지 않는다.
		searchAnnouncementDetail();
		searchReceptionDetail();
		// 개인 정보 데이터 생성
		writePersonInfo();
		
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

<input type="hidden" id="reception_id" name="reception_id" value="${vo.reception_id}" />
<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />
<input type="hidden" id="process_status" name="process_status" value="" />
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
				
				<div class="content_area copmpany_area">
					<h4>접수 대상</h4>								
					<div class="table_area">									
						<table class="write fixed">
							<caption>접수 대상</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>
								<tr>
								    <th scope="row" class="ta_c">접수 대상</th>											    
									<td>
										<input type="radio" id="selector_member" name="selector_class" value="개인" checked>
										<label for="selector_member">개인</label>		
										<input type="radio" id="selector_company" name="selector_class" value="기관">
										<label for="selector_company" class="mr20" onchange="setDisplay()">기관</label>										
									</td> 
							    </tr>																					
							 </tbody>						 
						</table>
						<!--//접수대상-->									
					</div>	<!--//table_area-->							
				</div><!--//content_area-->	
				
				
				<div class="table_area">
					<div class="content_area member_area not_view_reception" id="member_area">	
						<!--개인정보-->
							<h4>개인 정보</h4>		
							<table class="write fixed">
								<caption>개인 정보</caption>
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 80%;">
								</colgroup>
								<tbody>
									<tr id="person_id_tr">
										<th scope="row">
											<span class="icon_box"><span class="necessary_icon">*</span>
											<label for="member_id">아이디</label></span>
										</th>
										<td>
											<input disabled type="text" id="member_id" title="아이디" class="form-control w_20" placeholder="" />
										</td> 
									</tr>									  
									<tr id="person_name_tr">
										<th scope="row">
											<span class="icon_box"><span class="necessary_icon">*</span>
											<label for="member_name">성명</label></span>
										</th>
										<td><input disabled type="text" id="member_name" title="성명" class="form-control w_20" placeholder="" /></td>
									</tr>
									<tr id="person_mobile_phone_tr">
										<th scope="row">
											<span class="icon_box"><span class="necessary_icon">*</span>
											<label for="member_phone">휴대전화</label></span>
										</th>
										<td>
											<input disabled type="tel" id="member_phone" title="휴대전화" class="form-control w_20" placeholder="" />
										</td> 
									</tr>
									<tr id="person_email_tr">
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
											<label for="member_mail_1">이메일</label></span></th> 
										<td>
											<input type="text" name="member_mail_1" id="member_mail_1" class="form-control w_20 fl ls" placeholder="" disabled />
											<span class="fl ml1 mr1 pt10 mail_f">@</span>
											<label for="member_mail_2" class="hidden">이메일</label>
											<input type="text" name="member_mail_2" id="member_mail_2" class="form-control w_18 fl ls" placeholder="" disabled />
										</td>
									</tr>
									<tr id="person_address_tr">
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>
											<label for="reception_company_ceo_address">주소</label>
										</th> 
										<td>
											<input disabled type="text" id="member_address" class="form-control w50  mr5" placeholder="" />
											<input disabled type="text" id="member_address_detail" class="form-control w30" placeholder="" />
										</td>
									</tr>
									
								</tbody>
							</table>
						</div>
				
				
						<div class="content_area copmpany_area not_view_reception" id="copmpany_area" style="display: none;">			
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
				        </div>
							    
						<div class="not_view_reception">			
							<!--연구책임자 정보-->
							<h4>연구책임자 정보</h4>		
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
									    <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="mobile_phone">휴대전화</label></span></th>
									    <td>
											<select name="company_reception_phone" id="mobile_phone_selector" class="w_8 fl d_input ls">
												<option value="010">010</option>
											</select>
											<span style="display:block;" class="fl mc8">-</span>
											<input type="tel" id="mobile_phone_2" title="휴대전화" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" placeholder="">
											<span style="display:block;" class="fl mc8">-</span>
											<input type="tel" id="mobile_phone_3" title="휴대전화" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls" placeholder="">
										</td> 
								    </tr>
								    <tr id="email_tr">
									    <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>이메일</span></th>
									    <td>
										    <input type="text" name="email_1" id="email_1" class="form-control w_20 fl ls" placeholder="" />
										    <span class="fl ml1 mr1 pt10 mail_f">@</span>
										    <input type="text" name="email_2" id="email_2" class="form-control w_18 fl ls" placeholder="" disabled  />	
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
											<label for="company_reception_company_ceo_address">주소</label><label for="company_reception_company_ceo_address2" class="hidden">주소</label></span></th> 
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
										<th scope="row"><span class="icon_box"><label for="member_reception_company_name">기관명</label></span></th>
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
		
							<!--기술공모 - 기술정보 -->									
							<h4>기술 정보</h4>
							<table class="write fixed">
								<caption>기술 정보</caption>
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 80%;">
								</colgroup>
								<tbody>
									<tr id="service_name_tr">
									    <th scope="row">
									    	<span class="icon_box"><span class="necessary_icon">*</span>
									    	<label for="tech_info_name">기술명</label></span>
								    	</th>
									    <td>
									    	<input type="text" id="tech_info_name" class="form-control w100">
								    	</td> 
								    </tr>
									<tr id="sevice_description_tr">
									    <th scope="row">
									    	<span class="icon_box"><span class="necessary_icon">*</span>
									    	<label for="tech_info_description">기술 개요</label></span>
								    	</th>
									    <td>
									    	<input type="text" id="tech_info_description" class="form-control w100">
								    	</td> 
								    </tr>
								    
								    <tr id="sevice_national_science_large_tr">
									   <th scope="row" rowspan="3"><span class="icon_box"><span class="necessary_icon">*</span>국가과학기술분류</span></th>
									   <td>
											<label for="tech_info_large" class="fl mt5 mr5">대분류</label>
											<select name="tech_info_large" id="tech_info_large" class="ace-select" style="width: 94.8%;"></select>
									   </td>
								   </tr>
								   <tr id="sevice_national_science_middle_tr">
									   <td>
										   <label for="tech_info_middle" class="fl mt5 mr5">중분류</label>
										   <select name="tech_info_middle" id="tech_info_middle" class="ace-select" style="width: 94.8%;"></select>
									   </td>
								   </tr>
								   <tr id="sevice_national_science_small_tr">
									   <td>
										   <label for="tech_info_small" class="fl mt5 mr5">소분류</label>
										   <select name="tech_info_small" id="tech_info_small" class="ace-select" style="width: 94.8%;"></select>
									 </td>
								   </tr>									    
									<tr id="sevice_feature_tr">
									    <th scope="row">
									    	<span class="icon_box"><span class="necessary_icon">*</span>
									    	<label for="tech_info_feature">기술 특징</label></span>
								    	</th>
									    <td>
									    	<input type="text" id="tech_info_feature" title="기술 특징" class="form-control w100">
								    	</td> 
								    </tr>
									<tr id="sevice_effect_tr">
									    <th scope="row">
									    	<span class="icon_box"><span class="necessary_icon">*</span>
									    	<label for="tech_info_effect">기대 효과</label></span>
								    	</th>
									    <td>
									    	<textarea name="kogmo_company_reception_get_class" id="tech_info_effect" title="기대 효과" cols="30" rows="2" class="w100"></textarea>
								    	</td> 
								    </tr>
								 </tbody>						 
							</table>
							<!--기술공모 - 기술정보 -->
							
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
								 </tbody>						 
							</table>									
							<!--//기술컨설팅 -제출서류 -->
						</div>>
					
						<div class="button_box clearfix fr pb20">
							<button type="button" class="gray_btn fl" onclick="location.href='/member/fwd/reception/main'">목록</button>
						</div>
				</div>	<!--//table_area-->							
				
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
				<p><span class="font_blue">[예]</span> 버튼을 누르면 접수 신청서 제출이 완료되며, 수정은 불가능합니다.</p>							
				<p class="font_blue fz_b"><span class="fw500 font_blue">접수 신청서를 제출하시겠습니까?</span></p>
				<p>- 귀한 시간 내주셔서 감사드립니다. -</p>
			</div>
		    <div class="popup_button_area_center">
				<button type="submit" class="blue_btn mr5" onclick="registration('D0000002');">예</button>
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
				<button type="button" class="blue_btn mr5" onclick="registration('D0000001');">저장</button>
				<button type="button" class="gray_btn popup_close_btn" onclick="$('.temp_save_box, .popup_bg').fadeOut(350);">취소</button>
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