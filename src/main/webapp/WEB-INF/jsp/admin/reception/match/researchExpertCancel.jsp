<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<sec:authentication property="principal.username" var="member_id" />
 
<script src="/assets/admin/biz_js/reception/search.js"></script>
<script src="/assets/admin/biz_js/reception/expert.js"></script>


<script type='text/javascript'>
	$(document).ready(function() {
		// D0000004 - 전문가 매칭인 경우 제출 서류 입력을 만들지 않는다.
		searchAnnouncementDetail("D0000004");
		searchReceptionDetail();
	});

	function moveExpertReview() {
		location.href="/admin/fwd/reception/expert/review?reception_id=" + $("#reception_id").val(); 
	}
</script>

<input type="hidden" id="reception_id" name="reception_id" value="${vo.reception_id}" />
<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />
<input type="hidden" id="process_status" name="process_status" value="" />

<div class="container" id="content">
    <h2 class="hidden">컨텐츠 화면</h2>
    <div class="sub">
         <!--left menu 서브 메뉴-->     
        <div id="lnb">
	       <div class="lnb_area">
                  <!-- 레프트 메뉴 서브 타이틀 -->	
		       <div class="lnb_title_area">
			       <h2 class="title">접수관리</h2>
			   </div>
                  <!--// 레프트 메뉴 서브 타이틀 -->
			   <div class="lnb_menu_area">	
			       <ul class="lnb_menu">
				       <li class="on"><a href="/admin/fwd/reception/main" title="접수관리">접수관리</a></li>
			  			<li class="menu2depth">
						   	<ul>
							   <li class="active"><a href="/admin/fwd/reception/match/main">기술매칭</a></li>
							   <li><a href="/admin/fwd/reception/contest/main">기술공모</a></li>
							   <li><a href="/admin/fwd/reception/proposal/main">기술제안</a></li>
					   		</ul>
				  		</li>
				   </ul>				
			   </div>						
		   </div>			
	   </div>
		   <!--left menu 서브 메뉴-->

		   <!--본문시작-->
                 <div class="contents">
                     <div class="location_area">
			       <div class="location_division">
					   <!--페이지 경로-->
			           <ul class="location clearfix">
					       <li><a href="./index.html"><i class="nav-icon fa fa-home"></i></a></li>
						   <li>접수관리</li>
						   <li><strong>기술매칭</strong></li>
					   </ul>	
					  <!--//페이지 경로-->
					  <!--페이지타이틀-->
					   <h3 class="title_area">기술매칭</h3>
					  <!--//페이지타이틀-->
				    </div>
			    </div>
			    <div class="contents_view">
				   <!--접수관리 view-->						
				   <!--기관정보-->
				   <div class="view_top_area clearfix mt30">
					   <h4 class="fl sub_title_h4">기관 정보</h4>							  
				   </div>
				   <table class="list2 agency_information">
					   <caption>기관 정보</caption> 
					   <colgroup>
						   <col style="width: 20%" />
						   <col style="width: 80%" />
					   </colgroup>
					   <thead>
						   <tr id="institution_reg_number_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>사업자 등록번호</span></th>
							   <td id="institution_reg_number"></td> 
						   </tr>
					   </thead>
					   <tbody>
						   <tr id="institution_name_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기관명</span></th>
								   <td id="institution_name"></td> 
						   </tr>
						   <tr id="institution_address_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>주소</span></th>
							   <td id="institution_address"></td> 
						   </tr>
						   <tr id="institution_phone_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>전화</span></th> 
							   <td id="institution_phone"></td>
						   </tr>
						   <tr id="institution_owner_name_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>대표자명</span></th> 
							   <td id="institution_owner_name"></td>
						   </tr>
						   <tr id="institution_industry_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>업종</span></th> 
							   <td id="institution_industry"></td>
						   </tr>
						   <tr id="institution_business_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>업태</span></th> 
							   <td id="institution_business"></td>
						   </tr>
						   <tr id="institution_foundataion_date_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>설립일</span></th> 
							   <td id="institution_foundataion_date"></td> 
						   </tr>
						   <tr id="institution_foundataion_type_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>설립 구분</span></th> 
							   <td id="institution_foundataion_type"></td> 
						   </tr>
						   <tr id="institution_classification_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기업 분류</span></th> 
							   <td id="institution_classification"></td> 
						   </tr>
						   <tr id="institution_type_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기타 유형</span></th> 
							   <td id="institution_type"></td> 
						   </tr>
						   <tr id="institution_laboratory_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기업부설연구소 유무</span></th> 
							   <td id="institution_laboratory"></td> 
						   </tr>
						   <tr id="institution_employee_count_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>종업원수</span></th> 
							   <td class="clearfix" id="institution_employee_count"></td> 
						   </tr>
						   <tr id="institution_capital_tr">
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>매출액(최근3년)</span></th> 
							   <td class="clearfix" id="institution_capital"></td> 
						   </tr>
						   <tr id="institution_total_sales_tr"> 
							   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>자본금</span></th> 
							   <td class="clearfix" id="institution_total_sales"></td> 
						   </tr>
					   </tbody>
				   </table>					   
				   <!--//기관정보-->

				   <!--연구책임자 정보-->
				   <div class="view_top_area mt30" style="clear:both">
						   <h4 class="sub_title_h4">연구책임자 정보</h4>							  
				   </div>
				   <table class="list2 font_white">
					   <caption>연구책임자 정보</caption> 
					   <colgroup>
						   <col style="width: 20%" />
						   <col style="width: 80%" />
					   </colgroup>
					   <thead>
						   <tr id="researcher_name_tr">
							   <th scope="row"><span class="necessary_icon">*</span>성명</th>
							   <td id="researcher_name"></td> 
						   </tr>
					   </thead>
					   <tbody>
					   	   <tr id="researcher_mobile_phone_tr">
							   <th scope="row"><span class="necessary_icon">*</span>휴대전화</th>
							   <td id="researcher_mobile_phone"></td> 
						   </tr>
						   <tr id="researcher_email_tr">
							   <th scope="row"><span class="necessary_icon">*</span>이메일</th>
							   <td id="researcher_email"></td> 
						   </tr>
						   <tr id="researcher_address_tr">
							   <th scope="row"><span class="necessary_icon">*</span>주소</th>
							   <td id="researcher_address"><span></span></td> 
						   </tr>
						   <tr id="researcher_institution_name_tr">
							   <th scope="row"><span class="necessary_icon"></span>기관명</th>
							   <td id="researcher_institution_name"></td> 
						   </tr>
						   <tr id="researcher_institution_department_tr">
							   <th scope="row"><span class="necessary_icon"></span>부서</th>
							   <td id="researcher_institution_department"></td> 
						   </tr>
						   <tr id="researcher_institution_position_tr">
							   <th scope="row"><span class="necessary_icon"></span>직책</th>
							   <td id="researcher_institution_position"></td> 
						   </tr>
					   </tbody>
				   </table>						   
				   <!--//연구책임자 정보-->

                         

				   <!--기술컨설팅 요청사항 - 연구개발-->						  
				   <div class="view_top_area clearfix mt30">
					   <h4 class="fl sub_title_h4">기술컨설팅 요청사항</h4>							  
				   </div>
				   <table class="list2 font_white">
					   <caption>기술컨설팅 요청사항</caption> 
					   <colgroup>
						   <col style="width: 20%">
						   <col style="width: 80%">
					   </colgroup>
					   <thead>
						   <tr id="tech_consulting_type_tr">
							   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">구분</span></th>
							   <td id="tech_consulting_type"></td>
						   </tr>
					   </thead>
					   <tbody>
					       <tr id="tech_consulting_campus_tr">
							   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">소속 캠퍼스타운</span></th>
							   <td id="tech_consulting_campus"></td>
						   </tr>
						   <tr id="national_science_tr">
							   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">국가기술분류체계</span></th>
							   <td id="national_science"></td> 
						   </tr>
						   <tr id="tech_consulting_4th_industry_name_tr">
							   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">4차 산업혁명 기술분류</span></th>
							   <td id="tech_consulting_4th_industry_name"></td> 
						   </tr>
						   <tr id="consulting_purpose_tr">
							   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">사전 컨설팅 실시 여부</span></th>
							   <td id="consulting_take_yn"></td>
						   </tr>							   	   
					   </tbody>
				   </table>
				   <!--//기술컨설팅 요청사항 - 연구개발-->


				   <!--기술 정보 - 연구개발-->
				   <div class="view_top_area clearfix mt30">
					   <h4 class="fl sub_title_h4">기술 정보</h4>							  
				   </div>
                         <table class="list2 font_white">
					   <caption>기술 정보</caption> 
					   <colgroup>
						   <col style="width: 20%">
						   <col style="width: 80%">
					   </colgroup>
					   <thead>
						   <tr id="tech_info_name_tr">
							   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">제품/서비스명</span></th>
							   <td id="tech_info_name"></td> 
						   </tr>
					   </thead>
					   <tbody>
						   <tr id="tech_info_description_tr">
							   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">제품/서비스 내용</span></th>
							   <td id="tech_info_description"></td> 
						   </tr>							   
					       <tr id="sevice_request_tr">
							   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">시장/기술 동향</span></th>
							   <td id="tech_info_market_report"></td> 
						   </tr>							   
						   <tr id="sevice_content_tr">
							   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">기술연구개발 내용</span></th>
							   <td id="reception_rnd_text"></td> 
						   </tr>
						   <tr>
							   <th scope="row"><span class="icon_box">첨부 파일</span></th>
							   <td><span><a href="" download="">첨부 파일 .pdf</a></span></td> 
						   </tr>								   
					   </tbody>
				   </table>
				   <!--//기술 정보 - 연구개발-->						   						   
				   
				  <!--매칭신청-->						  
					   <!--희망전문가-->
					   <div class="view_top_area clearfix mt30">
						   <h4 class="fl sub_title_h4">희망전문가</h4>							  
					   </div>
                          <table class="list2 ta_c bd_r">
						   <caption>희망전문가</caption> 
						   <colgroup>
							   <col style="width: 5%" />
							   <col style="width: 23%" />
							   <col style="width: 10%" />
							   <col style="width: 10%" />
							   <col style="width: 10%" />
							   <col style="width: 10%" />
							   <col style="width: 10%" />
							   <col style="width: 15%" />
							   <col style="width: 7%" />
						   </colgroup>
						   <thead>
							   <tr>
								   <th scope="col">순위</th>
								   <th scope="col">국가과학기술분류</th>
								   <th scope="col">연구분야</th>
								   <th scope="col">성명</th>
								   <th scope="col">기관명</th>
								   <th scope="col">부서</th>
								   <th scope="col">휴대전화</th>
								   <th scope="col">이메일</th>
								   <th scope="col">선택 구분</th>
							   </tr>
						   </thead>
						   <tbody id="expert_body"></tbody>
					   </table>	
					   <!--//희망정문가-->
				   
				   
				   <div class="fr mt30">
					   <button type="button" class="gray_btn2" onclick="location.href='./reception_technologymatching.html'">목록</button>
				   </div>
				   <!--//제출서류 확인-->
			   </div><!--contents_view-->
                 </div>
		   <!--//contents--> 

              </div>
              <!--//sub--> 
          </div>
