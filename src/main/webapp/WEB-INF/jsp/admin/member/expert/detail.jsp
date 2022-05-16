<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
  
<script type='text/javascript'>
	$(document).ready(function() {
		searchExpertDetail();
	});

	function searchExpertDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/reception/expert/detail");
		comAjax.setCallback(getExpertDetailCB);
		var temp = $("#member_id").val();
		comAjax.addParam("member_id", $("#member_id").val());
		comAjax.ajax();
	}
	function getExpertDetailCB(data){
		if ( data.result == false) {
			showPopup("전문가 정보가 없습니다.", "전문가 안내");	
			return false;
		}
		
		$("#expert_detail_name").html("<span>" + data.result_data.name+ "</span>");
		$("#expert_detail_mobile_phone").html("<span>" + data.result_data.mobile_phone + "</span>");
		$("#expert_detail_email").html("<span>" + data.result_data.email + "</span>");
		

		var departmentTypeName;
		if ( data.result_data.department_type ==  "D0000001") {
			departmentTypeName = "개인";
		} else if ( data.result_data.department_type ==  "D0000002") {
			departmentTypeName = "기업";
		} else if ( data.result_data.department_type ==  "D0000003") {
			departmentTypeName = "학교";
		} else if ( data.result_data.department_type ==  "D0000004") {
			departmentTypeName = "연구원";
		} else if ( data.result_data.department_type ==  "D0000005") {
			departmentTypeName = "공공기관";
		} else if ( data.result_data.department_type ==  "D0000006") {
			departmentTypeName = "기타(협/단체 등)";
		}
			
		
		$("#expert_detail_department_type").html("<span>" + departmentTypeName + "</span>");
		$("#expert_detail_institution_name").html("<span>" + data.result_data.university + "</span>");
		$("#expert_detail_lab_address").html("<span>" + data.result_data.lab_address+ " " + data.result_data.lab_address_detail + "</span>");
		$("#expert_detail_lab_phone").html("<span>" + data.result_data.lab_phone + "</span>");
		$("#expert_detail_department").html("<span>" + data.result_data.department + "</span>");
		$("#expert_detail_position").html("<span>" + data.result_data.position + "</span>");

		$("#expert_detail_degree").html("<span>" + data.result_data.degree + "</span>");
		$("#expert_detail_university_degree").html("<span>" + data.result_data.university_degree + "</span>");
		$("#expert_detail_major").html("<span>" + data.result_data.major + "</span>");
		$("#expert_detail_university_degree_date").html("<span>" + data.result_data.university_degree_date + "</span>");
		
		
		
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

	
</script>

<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />	
<div class="container" id="content">
			   <!--본문시작-->
               <div class="container" id="content">
                <h2 class="hidden">컨텐츠 화면</h2>
                <div class="sub">
                   <!--left menu 서브 메뉴-->     
                   <div id="lnb">
				       <div class="lnb_area">
		                   <!-- 레프트 메뉴 서브 타이틀 -->	
					       <div class="lnb_title_area">
						       <h2 class="title">회원관리</h2>
						   </div>
		                   <!--// 레프트 메뉴 서브 타이틀 -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">							       
								   <li><a href="/admin/fwd/member/researcher/main" title="연구자">연구자</a></li>
								   <li><a href="/admin/fwd/member/commissioner/main" title="평가위원">평가위원</a></li>
								   <li  class="on"><a href="/admin/fwd/member/expert/main" title="전문가">전문가</a></li>
								   <li><a href="/admin/fwd/member/manager/main" title="관리자 or 내부평가위원">관리자 or 내부평가위원</a></li>
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
								   <li>회원관리</li>
								   <li><strong>전문가 관리</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">전문가 관리</h3>
							  <!--//페이지타이틀-->
						    </div>
					    </div>
					    <div class="contents_view sub_view member_page">
						   <!--관리자 계정관리 view-->
						   <div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">기본 정보</h4>
							   <!-- <span class="fr mt30"><input type="checkbox" class="checkbox_member_manager_table" /><label>이용 중지</label></span> -->
						   </div>						   
						   <table class="list2">
							   <caption>기본 정보</caption>
							   <colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
							   </colgroup>
							   <tbody>
									<tr>
										<th scope="row">성명</th>
										<td id="expert_detail_name"></td>	
									</tr>									  
									<tr>
										<th scope="row"><span class="icon_box">휴대전화</span></th>
										<td id="expert_detail_mobile_phone"></td>	
									</tr>
									<tr>
										<th scope="row"><span class="icon_box">이메일</span></th>
										<td id="expert_detail_email"></td>
									</tr>
								</tbody>
						   </table>
						   

						   <!--기관 정보-->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">기관 정보</h4>							  
						   </div>						   
						   <table class="list2">
							   <caption>기관 정보</caption>
							   <colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
							   </colgroup>
							   <tbody>
									<tr>
										<th scope="row"><span class="icon_box">기관 유형</span></th>
										<td id="expert_detail_department_type"></td>
									</tr>									  
									<tr>
										<th scope="row"><span class="icon_box"><label for="agreementmember_company_name">기관명</label></span></th>
										<td id="expert_detail_institution_name">
										</td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><label for="address_agreementmember_sign2">주소</label></span></th>
										<td id="expert_detail_lab_address">
										</td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><label for="agreementmember_charge_tel2">전화</label></span></th>
										<td id="expert_detail_lab_phone">
										</td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><label for="agreementmember_company_partment">부서</label></span></th>
										<td id="expert_detail_department">
										</td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><label for="agreementmember_company_rank">직책</label></span></th>
										<td id="expert_detail_position">
										</td>
									</tr>																									
								</tbody>
						   </table>
						   
						   <!-- 학력 -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">학력</h4>							  
						   </div>						   
						   <table class="list2 write fixed bd_r">
								<caption>학력</caption>
								<colgroup>
									<col style="width: 10%;">
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 12%;">
								</colgroup>
								<thead>
									<tr>
										<th><span class="icon_box">학위</span></th>
										<th scope="col"><span class="icon_box">학교명</span></th>
										<th scope="col"><span class="icon_box">전공</span></th>
										<th scope="col"><span class="icon_box">학위취득연도</span></th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td id="expert_detail_degree">	
										</td>
										<td id="expert_detail_university_degree">
										</td>
										<td id="expert_detail_major">
										</td>	
										<td id="expert_detail_university_degree_date">
										</td>
									</tr>														
								</tbody>
						   </table>
						   					   
						   <!-- 기술 분야 -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">기술 분야</h4>							  
						   </div>						   
						   <table class="list2 write fixed">
						   <caption>기술 분야 </caption>
								<colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
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
								</tbody>
						   </table>

						   <!-- 연구 분야 -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">연구 분야</h4>							  
						   </div>						   
						   <table class="list2 write fixed">
								<caption>연구 분야</caption>
								<colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
								</colgroup>
								<tbody>
									<tr>
									   <th scope="row" rowspan="3"><span class="icon_box"><span class="necessary_icon">*</span><label for="research_class">연구 상세 분야</label></span></th>
									   <td id="expert_detail_research">
									   </td>
									</tr>
								</tbody>
						   </table>
						   
						   <!-- 논문/저서 -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">논문/저서<span class="font_blue">(최근 3년)</span></h4>							  
						   </div>						   
						   <table class="list2 fixed history_table write2 bd_r">
								<caption>논문/저서</caption>
								<colgroup>
									<col style="width: 40%;">
									<col style="width: 30%;">
									<col style="width: 20%;">
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
						   
						   <!-- 지식재산권 -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">지식재산권<span class="font_blue">(최근 3년)</span></h4>							  
						   </div>						   									
						   <table class="list fixed knowledge_table write2">
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
						   
						   
						   <!-- 기술이전 -->
						   <div class="view_top_area clearfix mt30">
							   <h4 class="sub_title_h4">기술이전<span class="font_blue">(최근 3년)</span></h4>							  
						   </div>						   
						   <table class="list fixed technology_transmigrate_table write2 list">
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
						    <!-- //기술이전 -->

							<!-- R&D과제 -->
						   <div class="view_top_area clearfix mt30">
							   <h4 class="sub_title_h4">R&D과제<span class="font_blue">(최근 3년)</span></h4>							  
						   </div>						   
						   <table class="list fixed rnd_table write2 list">
								<caption>R&amp;D과제</caption>
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
						    <!-- //기술이전 -->

						   <!--//관리자 계정관리 view-->
						   <div class="fr mt30 clearfix">
							   <!-- <button type="button" class="blue_btn member_view_revise fl mr5">수정</button> -->
							   <button type="button" class="gray_btn2 fl" onclick="location.href='/admin/fwd/member/expert/main'">목록</button>
						   </div>
					   </div><!--contents_view-->
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>