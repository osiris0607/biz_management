<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script src="/assets/user/biz_js/reception/match-consulting-search.js"></script>
<script src="/assets/user/biz_js/reception/match-consulting-expert.js"></script>
  
<script type='text/javascript'>

	var isOK = false;
	$(document).ready(function() {
		//기술매칭(기술 컨설팅)
		if ($("#announcement_type").val() == "D0000001") {
			$("#cousulting_area").show();
		}
		// 기술매칭(기술 연구개발) 
		else {
			$("#rnd_area").show();
		}

		searchAnnouncementDetail("D0000004");
		searchReceptionDetailForMypage();
		searchExpertParticipation();


		if ( $("#participation_name").val() != "참여" && $("#participation_name").val() != "미참여" )
		{
			$("#button_1").show();
			$("#button_2").show();
		}
		
	});

	function searchExpertParticipation() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/expert/search/participation'/>");
		comAjax.setCallback(searchExpertParticipationCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.ajax();
	}

	function searchExpertParticipationCB(data)
	{
		$("#count_1").html("<span class='font_yellow'>" + data.result_data.COUNT_1 + "</span>건");
		$("#count_2").html("<span class='font_yellow'>" + data.result_data.COUNT_2 + "</span>건");
		$("#count_3").html("<span class='font_yellow'>" + data.result_data.COUNT_3 + "</span>건");
	}

	function updateParticipation(type) {
		var formData = new FormData();
		formData.append("member_id",'${member_id}');
		formData.append("reception_id", $("#reception_id").val());
		formData.append("participation_type", type);


		$.ajax({
		    type : "POST",
		    url : "/member/api/mypage/expert/update/participation",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	showPopup("참여 여부 의사를 반영하였습니다.","참여 여부 안내");
		        	isOK = true;
		        } else {
		        	showPopup("참여 여부 의사 반영에 실패하였습니다.. 다시 시도해 주시기 바랍니다.","참여 여부 안내 안내");
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
		if ( isOK == true ) {
			location.href="/member/fwd/mypage/expert"; 
		}
	}

</script>

<!-- container -->
<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />
<input type="hidden" id="reception_id" name="reception_id" value="${vo.reception_id}" />
<input type="hidden" id="announcement_type" name="announcement_type" value="${vo.announcement_type}" />
<input type="hidden" id="participation_name" name="announcement_type" value="${vo.participation_name}" />



<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>					
	<section id="content">
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
									<a href="/member/fwd/mypage/institution" title="기관정보관리"><span>기관정보관리</span></a>									
								</li>
								<li>
									<a href="/member/fwd/mypage/main" title="개인정보관리 페이지로 이동"><span>개인정보관리</span></a>									
								</li>
								<sec:authorize access="hasAnyRole('ROLE_EXPERT', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/expert" title="전문가 참여 현황" class="active"><span>전문가 참여 현황</span></a>				
									</li>
								</sec:authorize>
								<sec:authorize access="hasAnyRole('ROLE_COMMISSIONER', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/commissioner" title="평가위원정보관리" ><span>평가위원 정보 관리</span></a>				
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
					<h3>전문가 참여 현황</h3>
					<div class="expertlist_business_status business_info_box">
						<ul class="clearfix">
							<li class="business_status">
								<!--전문가 참여 현황-->
								<h3>전문가 참여 현황</h3>
								<ul>
									<li>
										<dl class="clearfix">
											<dt>전문가 매칭중</dt>
											<dd id="count_1"><span class="font_yellow">0</span>건</dd>
										</dl>
									</li>
									<li>
										<dl class="clearfix">
											<dt>전문가 참여 수행중</dt>
											<dd id="count_2"><span class="font_yellow">0</span>건</dd>
										</dl>
									</li>
									<li>
										<dl class="clearfix">
											<dt>참여완료</dt>
											<dd id="count_3"><span class="font_yellow">0</span>건</dd>
										</dl>
									</li>
								</ul>											
							</li>
							<!--사업연락-->
							<li class="business_col">
								<h3>사업 연락</h3>
								<ul>
									<li>
										<dl class="clearfix">
											<dt>업무연락 수신</dt>
											<dd class="mail"><a href=""><span class="font_yellow">0</span>건</a></dd>
										</dl>
									</li>
									<li>
										<dl class="clearfix">
											<dt>업무연락 발신</dt>
											<dd class="mail"><a href=""><span class="font_yellow">0</span>건</a></dd>
										</dl>
									</li>
								</ul>
							</li>
							<!--사업소개 바로가기-->
							<li class="business_info_link">
								<a href="https://seoul-tech.com/web/intropage/intropageShow.do?page_id=e35c124aa9084e84bc8c663f9ae796cf" title="신기술접수소 사업 소개페이지 바로가기"><span class="font_yellow">신기술접수소 사업</span>을 소개합니다.
								<h3>신기술접수소 사업 소개</h3></a>
							</li>
						</ul>
					</div>
					
					<h4>기관 정보</h4>								
					<div class="table_area">									
						<table class="write fixed">
							<caption>기관 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>																		  
								<tr id="institution_reg_number_tr">
								   <th scope="row">사업자 등록번호</th>
								   <td id="institution_reg_number"></td> 
							   </tr>
								<tr id="institution_name_tr">
									<th scope="row">기관명</th>
									<td id="institution_name"></td> 
								</tr>
								<tr id="institution_address_tr">
									<th scope="row">주소</th>												
									<td id="institution_address"></td> 
								</tr>
								<tr id="institution_phone_tr">
									<th scope="row">전화</th> 
									<td id="institution_phone"></td>
								</tr>
								<tr id="institution_owner_name_tr">
									<th scope="row">대표자명</th> 
									<td id="institution_owner_name"></td>
								</tr>
								<tr id="institution_industry_tr">
									<th scope="row">업종</th> 
									<td id="institution_industry"></td>
							    </tr>
							    <tr id="institution_business_tr">
									<th scope="row">업태</th> 
									<td id="institution_business"></td>
							    </tr>
								<tr id="institution_foundataion_date_tr">
									<th scope="row">설립일</th> 
									<td id="institution_foundataion_date"></td> 
							    </tr>
								<tr id="institution_foundataion_type_tr">
									<th scope="row">설립 구분</th> 
								 	<td id="institution_foundataion_type"></td> 
							    </tr>
								<tr id="institution_classification_tr">
									<th scope="row">기업 분류</th> 
									<td id="institution_classification"></td> 
							    </tr>
								<tr id="institution_type_tr">
									<th scope="row">기타 유형</th> 
									<td id="institution_type"></td> 
							    </tr>
								<tr id="institution_laboratory_tr">
									<th scope="row">기업부설연구소 유무</th> 
									<td id="institution_laboratory"></td> 
							    </tr>
								<tr id="institution_employee_count_tr">
									<th scope="row">종업원수</th> 
									<td class="clearfix" id="institution_employee_count"></td> 
							    </tr>
								<tr id="institution_capital_tr">
									<th scope="row">매출액(최근 3년)</th> 
									<td class="clearfix" id="institution_capital"></td> 
							    </tr>
								<tr id="institution_total_sales_tr"> 
									<th scope="row">자본금</th> 
									<td class="clearfix" id="institution_total_sales"></td> 
							    </tr>
							</tbody>
						</table>																	
					</div>	<!--//table_area-->	
					<!--//기관 정보-->	

					<!--연구책임자(담당자) 정보-->
					<h4>연구책임자(담당자) 정보</h4>								
					<div class="table_area">									
						<table class="write fixed">
							<caption>연구책임자(담당자) 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>		
								<tr id="researcher_name_tr">
									<th scope="row">성명</th>
									<td id="researcher_name"></td> 
								</tr>
								<tr id="researcher_mobile_phone_tr">
									<th scope="row">휴대전화</th> 
									<td id="researcher_mobile_phone"></td> 
								</tr>
								<tr id="researcher_email_tr">
									<th scope="row">이메일</th> 
									<td id="researcher_email"></td> 
								</tr>
								<tr id="researcher_address_tr">
								   <th scope="row">주소</th>
								   <td id="researcher_address"><span></span></td> 
							   </tr>
							   <tr id="researcher_institution_name_tr">
								   <th scope="row">기관명</th>
								   <td id="researcher_institution_name"></td> 
							   </tr>
							   <tr id="researcher_institution_department_tr">
								   <th scope="row">부서</th>
								   <td id="researcher_institution_department"></td> 
							   </tr>
							   <tr id="researcher_institution_position_tr">
								   <th scope="row">직책</th>
								   <td id="researcher_institution_position"></td> 
							   </tr>	
							</tbody>
						</table>																	
					</div>	<!--//table_area-->	
					<!--//연구책임자(담당자) 정보-->	

					<!--기술컨설팅 요청사항 - 컨설팅-->
					<div  id="cousulting_area" style="display:none">
						<div class="view_top_area clearfix mt30">
						   <h4 class="fl sub_title_h4">기술컨설팅 요청사항</h4>							  
					    </div>
					    <div class="table_area">
						   <table class="write fixed">
							   <caption>기술컨설팅 요청사항</caption> 
							   <colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
							   </colgroup>
							   <tbody>
								   <tr id="tech_consulting_type_tr">
									   <th scope="row">구분</th>
									   <td id="tech_consulting_type"></td>
								   </tr>							   
								   <tr id="tech_consulting_campus_tr">
									   <th scope="row">소속 캠퍼스타운</th>
									   <td id="tech_consulting_campus"></td>
								   </tr>
								   <tr id="national_science_tr">
									   <th scope="row">국가기술분류체계</th>
									   <td id="national_science"></td> 
								   </tr>
								   <tr id="tech_consulting_4th_industry_name_tr">
									   <th scope="row">4차 산업혁명 기술분류</th>
									   <td id="tech_consulting_4th_industry_name"></td> 
								   </tr>
								   <tr id="tech_consulting_purpose_tr">
									   <th scope="row">컨설팅 목적</th>
									   <td id="tech_consulting_purpose"></td>
								   </tr>							   	   
							   </tbody>
						   </table>	
						</div>
						
						<!--기술 정보 - 컨설팅-->
						<div class="view_top_area clearfix mt30">
						   <h4 class="fl sub_title_h4">기술 정보</h4>							  
					    </div>
					    <div class="table_area">
						   <table class="write fixed">
							   <caption>기술 정보</caption> 
							   <colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
							   </colgroup>
							   <tbody>
								   <tr id="tech_info_name_tr">
									   <th scope="row">제품/서비스명</th>
									   <td id="tech_info_name"></td> 
								   </tr>							  
								   <tr id="tech_info_description_tr">
									   <th scope="row">제품/서비스 내용</th>
									   <td id="tech_info_description"></td> 
								   </tr>
								   <tr id="tech_info_description_1_tr">
									   <th scope="row" id="tech_info_description_name_1"></th>
									   <td id="tech_info_description_1"></td> 
								   </tr>
								   <tr id="tech_info_description_2_tr">
									   <th scope="row" id="tech_info_description_name_2"></th>
									   <td id="tech_info_description_2"></td> 
								   </tr>
								   <tr id="service_upload_file_label_tr">
									   <th scope="row">첨부 파일</th>
									   <td id="service_upload_file_label"></td> 
								    </tr>
							   </tbody>
						   </table>	
					    </div>
					    <!--//기술 정보 - 컨설팅-->
					</div>
				    <!--//기술컨설팅 요청사항 - 컨설팅-->
				   
				    <div id="rnd_area" style="display:none">
					    <!--기술컨설팅 요청사항 - 연구개발-->
					    <div class="view_top_area clearfix mt30">
						   <h4 class="fl sub_title_h4">기술컨설팅 요청사항</h4>							  
					    </div>
					    <div class="table_area">
						   <table class="write fixed">
							   <caption>기술컨설팅 요청사항</caption> 
							   <colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
							   </colgroup>
							   <tbody>
								   <tr id="tech_consulting_type_tr">
									   <th scope="row">구분</th>
									   <td id="tech_consulting_type"></td>
								   </tr>							   
								   <tr id="tech_consulting_campus_tr">
									   <th scope="row">소속 캠퍼스타운</th>
									   <td id="tech_consulting_campus"></td>
								   </tr>
								   <tr id="national_science_tr">
									   <th scope="row">국가기술분류체계</th>
									   <td id="national_science"></td> 
								   </tr>
								   <tr id="tech_consulting_4th_industry_name_tr">
									   <th scope="row">4차 산업혁명 기술분류</th>
									   <td id="tech_consulting_4th_industry_name"></td> 
								   </tr>
								   <tr id="consulting_purpose_tr">
									   <th scope="row">사전 컨설팅 실시 여부</th>
									   <td id="consulting_take_yn"></td>
								   </tr>							   	   
							   </tbody>
						   </table>	
					    </div>
					    <!--//기술컨설팅 요청사항 - 연구개발-->
	
					    <!--기술 정보 - 연구개발-->
					    <div class="view_top_area clearfix mt30">
						   <h4 class="fl sub_title_h4">기술 정보</h4>							  
					    </div>
					    <div class="table_area">
						   <table class="write fixed">
							   <caption>기술 정보</caption> 
							   <colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
							   </colgroup>
								<tbody>
								   <tr id="tech_info_name_tr">
									   <th scope="row">제품/서비스명</th>
									   <td id="tech_info_name"></td> 
								   </tr>								   
								   <tr id="tech_info_description_tr">
									   <th scope="row">제품/서비스 내용</th>
									   <td id="tech_info_description"></td> 
								   </tr>							   
							       <tr id="sevice_request_tr">
									   <th scope="row">시장/기술 동향</th>
									   <td id="tech_info_market_report"></td> 
								   </tr>							   
								   <tr id="sevice_content_tr">
									   <th scope="row">기술연구개발 내용</th>
									   <td id="reception_rnd_text"></td> 
								   </tr>
								   <tr id="service_upload_file_label_tr">
									   <th scope="row">첨부 파일</th>
									   <td id="service_upload_file_label"></td> 
								    </tr>
							   </tbody>
						   </table>	
					     </div>
				    </div>
				    
					   <!--//기술 정보 - 연구개발-->	
					 <div class="fr mt20">
					   <button type="button" class="gray_btn fl mr5 mb10" title="목록" onclick="location.href='/member/fwd/mypage/expert'">목록</button>
					   <button id="button_1" style="display:none" type="button" class="blue_btn fl accept_popup_btn mr5 mb10" title="미참여" onclick="updateParticipation('D0000002');">미참여</button>
					   <button id="button_2" style="display:none" type="button" class="blue_btn fl accept_popup_btn mb10" title="참여" onclick="updateParticipation('D0000003');">참여</button>
				    </div>
					
				</div><!--//sub_right_contents-->
			</div><!--//content_area-->
		</section><!--//content-->
	</div><!--//sub_contents-->
 
 
 <!--기관명검색 팝업-->
<div class="mypage_company_name_popup_box">
	<div class="popup_bg"></div>
	<div class="mypage_company_name_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">기관명 검색</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0" id="reg_no_err"><span class="font_blue">000-00-00000</span> 은<br />기관으로 등록되어 있지 않습니다.<br />기관정보를 직접 입력해 주세요.</p>
			<!--있을경우-->
			<!--p tabindex="0">
				<input type="radio" id="mypage_company_name_radio" name="mypage_company_name_radio">
				<label for="mypage_company_name_radio">이노싱크컨설팅</label>
			</p-->
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn">확인</button>
			</div>	
		</div>
	</div>			
</div>

<!--기관정보등록 팝업-->
<div class="company_signup_popup_box">
	<div class="popup_bg"></div>
	<div class="company_signup_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">기관 정보 등록</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn company_signup_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">기관정보의 최초 등록 시</span>, 등록자의 대표자가 아닌 경우 임시 대표자로 설정됩니다.<br />로그인한 인증서와 동일한 <span class="font_blue">사업자번호의 기관만 등록, 수정</span>이 가능합니다.</p>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn company_signup_popup_close_btn" onclick="toggleText()">확인</button>
			</div>	
		</div>
	</div>			
</div>
<!--//기관정보등록 팝업-->

<!--사업자 등록번호 팝업-->
<div class="companynumber_popup_box">
	<div class="popup_bg"></div>
	<div class="companynumber_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">미등록 기관 등록</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn companynumber_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p tabindex="0">미등록 기관입니다.<br />미등록 기관의 경우 등록해 주세요.<br />
				기업의 경우, <span class="font_blue">사업자등록번호로 중복 확인</span> 부탁 드립니다.</p>
				<ul>
					<li class="clearfix mb5"><label for="notsignup_companyname" class="w45 fl ta_r mr10">미등록 기관명 </label>
						<input type="text" id="notsignup_companyname" class="form-control w50 fl" /></li>
					<li class="clearfix"><label for="li_number2" class="w45 fl ta_r mr10">미등록 기관 사업자 등록번호 </label>
						<input type="text" class="form-control input-sm mr5 w30 fl" name="li_number2" id="li_number2" placeholder="숫자만 입력" maxlength="12"><button type="button" class="gray_btn fl notsignup_test_company_number" title="중복확인">중복확인</button></li>
					<li>
				</ul>
			</div>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn companynumber_popup_close_btn ">등록</button>
			</div>								
		</div>
	</div>				 
</div>
<!--//사업자 등록번호 팝업-->	

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

