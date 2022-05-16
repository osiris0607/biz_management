<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
  
<script type='text/javascript'>
	$(document).ready(function() {
		searchMemberDetail();
		searchInstitutionDetail();
		searchDetail();		
	});

	function searchMemberDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/detail'/>");
		comAjax.setCallback(getMemberDetailCB);
		comAjax.addParam("member_id", $("#member_id").val());
		comAjax.ajax();
	}

	var memberInfo;
	function getMemberDetailCB(data){
		memberInfo = data.result;
		$("#name").html("<span>" + data.result.name + "</span>") ;
		$("#mobile_phone").html(data.result.mobile_phone) ;
		$("#email").html(data.result.email) ;
		$("#address").html(data.result.address + " " + data.result.address_detail) ;
	}

	function searchInstitutionDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/institution/detail'/>");
		comAjax.setCallback(getInstitutionDetailCB);
		comAjax.addParam("member_id", $("#member_id").val());
		comAjax.ajax();
	}
	
	function getInstitutionDetailCB(data){
		$("#institution_type").html("<span>" + data.result.type_name + "</span>");
		$("#institution_name").html("<span>" + data.result.name +" </span>");
		$("#institution_address").html("<span class='fl'>" + data.result.address +"</span> <span class='fl ls'>" + data.result.address_detail + "</span>");
		$("#institution_phone").html("<span>" + data.result.phone + "</span>");
		$("#institution_depart").html("<span>" + memberInfo.department + "</span>");
		$("#institution_position").html("<span>" + memberInfo.position + "</span>");
	}

	
	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/member/commissioner/detail'/>");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("member_id", $("#member_id").val());
		comAjax.addParam("commissioner_id", $("#commissioner_id").val());
		comAjax.ajax();
	}
	
	function searchDetailCB(data){
		$("#bank_name").html( data.result_data.bank_name + "<span class='d_i'>은행</span>") ;
		$("#bank_account").html( data.result_data.bank_account) ;

		$("#national_skill_large").html( "대분류 - " + data.result_data.national_skill_large) ;
		$("#national_skill_middle").html( "중분류 - " + data.result_data.national_skill_middle) ;
		$("#national_skill_small").html( "소분류 - " + data.result_data.national_skill_small) ;
		$("#four_industry").html(data.result_data.four_industry_name) ;
		$("#rnd_class").html(data.result_data.rnd_class) ;

		// 학력
		var body = $("#degree_body");
		body.empty();
		var str = "";
		if ( gfn_isNull(data.result_data.degree_school_01) == false &&
			 gfn_isNull(data.result_data.degree_major_01) == false &&
			 gfn_isNull(data.result_data.degree_date_01) == false  ) {
				str += "<tr>";
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_01 + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_school_01 + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_major_01 + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_date_01 + "년</center></td>";
				str += "	<td class='td_c'>";
				str += "		<a href='/admin/api/member/commissioner/download/"+ data.result_data.degree_certificate_file_id_01 +"' download class='down_btn'>" + data.result_data.degree_certificate_file_name_01 + "</a>";
				str += "	</td>"
				str += "</tr>";
		 }

		if ( gfn_isNull(data.result_data.degree_school_02) == false &&
			 gfn_isNull(data.result_data.degree_major_02) == false &&
			 gfn_isNull(data.result_data.degree_date_02) == false  ) {
				str += "<tr>";
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_02 + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_school_02 + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_major_02 + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data.degree_date_02 + "년</center></td>";
				str += "	<td class='td_c'>";
				str += "		<a href='/admin/api/member/commissioner/download/"+ data.result_data.degree_certificate_file_id_02 +"' download class='down_btn'>" + data.result_data.degree_certificate_file_name_02 + "</a>";
				str += "	</td>"
				str += "</tr>";
			 }
		body.append(str);

  		// 경력
		var body = $("#career_body");
		body.empty();
		str = "";
		for(var i=1; i<=4; i++) {
			if ( gfn_isNull(data.result_data["career_company_0" + i]) == false) {
				str += "<tr>";
				str += "	<td class='clearfix'><center>"+ data.result_data["career_company_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["career_depart_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["career_position_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["career_start_date_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["career_retire_date_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["career_description_0" + i] + "</center></td>";
				str += "</tr>";
			}
		}
		body.append(str);

  		// 논문
		var body = $("#thesis_body");
		var isExist = false;
		str = "";
		body.empty();
		for(var i=1; i<=3; i++) {
			if ( gfn_isNull(data.result_data["thesis_title_0" + i]) == false) {
				isExist = true;
				str += "<tr>";
				if ( data.result_data["thesis_sci_yn_0" + i] == "Y") {
					str += "	<td class='clearfix'><center>"+ "등재" + "</center></td>";
				} else {
					str += "	<td class='clearfix'><center>"+ "등재안됨" + "</center></td>";
				}
				str += "	<td class='clearfix'><center>"+ data.result_data["thesis_title_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["thesis_writer_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["thesis_journal_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["thesis_nationality_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["thesis_date_0" + i] + "</center></td>";
				str += "</tr>";
			}
		}
		if ( isExist == false ) {
			str = "<tr>" + "<td colspan='6'>조회된 결과가 없습니다.</td>" + "</tr>";
		}
		body.append(str);

		// 지적 재산권
		var body = $("#iprs_body");
		var isExist = false;
		str = "";
		body.empty();
		for(var i=1; i<=3; i++) {
			if ( gfn_isNull(data.result_data["iprs_name_0" + i]) == false) {
				isExist = true;
				str += "<tr>";
				str += "	<td class='clearfix'><center>"+ data.result_data["iprs_name_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["iprs_enroll_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["iprs_reg_no_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["iprs_date_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["iprs_nationality_0" + i] + "</center></td>";
				str += "	<td class='clearfix'><center>"+ data.result_data["iprs_writer_0" + i] + "</center></td>";
				str += "</tr>";
			}
		}
		if ( isExist == false ) {
			str = "<tr>" + "<td colspan='6'>조회된 결과가 없습니다.</td>" + "</tr>";
		}
		body.append(str);

		$("#self_description").html(data.result_data.self_description) ;

		// D0000002 - 신청완료이므로 관리자에게 선정할 수 있는 버튼을 보여준다.
		if ( data.result_data.commissioner_status == "D0000002") {
			$("#reg_fail_btn").show();
			$("#reg_success_btn").show();
		}

/* 		// D0000003 - 선정보류이므로 다시 선정할 수 있도록 한다.
		if ( data.result_data.commissioner_status == "D0000003") {
			$("#reg_success_btn").show();
		}

		// D0000004 - 선정완료이므로 선정 보류할 수 있도록 한다.
		if ( data.result_data.commissioner_status == "D0000004") {
			$("#reg_fail_btn").show();
		} */
	}

	function updateCommissionerStatus(status) {
		var formData = new FormData();
		formData.append("member_id", $("#member_id").val() );
		formData.append("commissioner_status", status);

		if (confirm("선정보류 하시겠습니까?")){
			$.ajax({
			    type : "POST",
			    url : "/admin/api/member/commissioner/update/status",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	alert("변경 되었습니다.");
			    	location.href='/admin/fwd/member/commissioner/main';
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
		
		
	}

	function moveAcceptance(){
		location.href="/admin/fwd/member/commissioner/acceptance?member_id=" + $("#member_id").val() + "&email=" + memberInfo.email + "&mobile_phone=" + memberInfo.mobile_phone;
	}

	
</script>

<input type="hidden" id="member_id" name="member_id" value="${vo.member_id}" />	
<input type="hidden" id="commissioner_id" name="commissioner_id" value="${vo.commissioner_id}" />	
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
								   <li class="on"><a href="/admin/fwd/member/commissioner/main" title="평가위원">평가위원</a></li>
								   <li><a href="/admin/fwd/member/expert/main" title="전문가">전문가</a></li>
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
							       <li><a href="/admin/fwd/home/main"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>회원관리</li>
								   <li><strong>평가위원</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">평가위원</h3>
							  <!--//페이지타이틀-->
						    </div>
					    </div>
					    <div class="contents_view sub_view">
						   <!--관리자 or 내부평가위원 view-->
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
										<td id="name"></td>	
									</tr>									  
									<tr>
										<th scope="row"><span class="icon_box"><span class=" necessary_icon">*</span>휴대전화</span></th>
										<td id="mobile_phone"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class=" necessary_icon">*</span>이메일</span></th>
										<td id="email"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class=" necessary_icon">*</span>주소</span></th>
										<td id="address"></td>
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
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기관 유형</span></th>
										<td id="institution_type"></td>
									</tr>									  
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_company_name">기관명</label></span></th>
										<td id="institution_name"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="address_agreementmember_sign2">주소</label></span></th>
										<td id="institution_address"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_charge_tel2">전화</label></span></th>
										<td id="institution_phone"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_company_partment">부서</label></span></th>
										<td id="institution_depart"></td>
									</tr>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_company_rank">직책</label></span></th>
										<td id="institution_position"></td>
									</tr>																									
								</tbody>
						   </table>
						   

						   <!--계좌 정보-->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">계좌 정보</h4>							  
						   </div>						   
						   <table class="list2 write fixed">
						   <caption>계좌 정보</caption>
								<colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_bankname">은행명</label></span></th>
										<td id="bank_name"></td>	
									</tr>  
									<tr>
										<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_banknumber">계좌번호</label></span></th>
										<td id="bank_account"></td>	
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
								<tr>
									<th scope="row" rowspan="3"><span class="icon_box"><span class="necessary_icon">*</span>국가과학기술분류</span></th>
									<td id="national_skill_large"></td>
								</tr>  
								<tr>
									<td id="national_skill_middle"></td>
								</tr>
								<tr>
									<td id="national_skill_small"></td>
								</tr>
								<tr>
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="industry_4th_technology">4차 산업혁명 기술분류</label></span></th>
								   <td id="four_industry"></td>
							   </tr>							   								
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
								   		<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="research_class">연구 상세 분야</label></span></th>
									  	<td id="rnd_class"></td>
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
									<col style="width: 28%;">
								</colgroup>
								<thead>
									<tr>
										<th><span class="icon_box"><span class="necessary_icon">*</span>학위</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>학교명</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>전공</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>학위취득연도</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>학위증명서</span></th>				
									</tr>
								</thead>
								<tbody id="degree_body">
								</tbody>
						   </table>
						  

						   <!-- 경력 -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">경력</h4>							  
						   </div>						   
						   <table class="list2 fixed history_table write2 bd_r">
								<caption>경력</caption>
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 20%;">
									<col style="width: 10%;">
									<col style="width: 19%;">
									<col style="width: 19%;">
									<col style="width: 22%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>근무처</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>근무부서</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>직급</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>입사</span></th>
										<th scope="col"><span class="icon_box">퇴사</span></th>
										<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>업무내용</span></th>
									</tr>
								</thead>
								<tbody id="career_body"></tbody>
						   </table>
						   

						   <!-- 논문/저서 -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">논문/저서<span class="font_blue">(선택)</span></h4>							  
						   </div>						   
						   <table class="list2 fixed history_table write2 bd_r">
								<caption>논문/저서</caption>
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 20%;">
									<col style="width: 10%;">
									<col style="width: 19%;">
									<col style="width: 19%;">
									<col style="width: 22%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">SCI여부</th>
										<th scope="col">논문저서명명</th>
										<th scope="col">주저자명</th>
										<th scope="col">학술지</th>
										<th scope="col">국내/국외</th>
										<th scope="col">발행일자</th>
									</tr>
								</thead>
								<tbody id="thesis_body"></tbody>
						   </table>
						   
						   <!-- 논문/저서 -->
						   <div class="view_top_area">
							   <h4 class="sub_title_h4">지식재산권<span class="font_blue">(선택)</span></h4>							  
						   </div>						   									
						   <table class="list fixed knowledge_table write2">
								<caption>지식재산권</caption>
								<colgroup>
									<col style="width: 21%;">
									<col style="width: 13%;">
									<col style="width: 14%;">
									<col style="width: 14%;">
									<col style="width: 18%;">
									<col style="width: 10%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">논문저서 명</th>
										<th scope="col">출원/등록</th>
										<th scope="col">출원/등록 번호</th>
										<th scope="col">출원/등록 일자</th>
										<th scope="col">출원/등록 국가</th>
										<th scope="col">발명자명</th>
									</tr>
								</thead>
								<tbody id="iprs_body"></tbody>
						   </table>
						   
						   
						   <!-- 논문/저서 -->
						   <div class="view_top_area clearfix mt30">
							   <h4 class="sub_title_h4">자기기술서<span class="font_blue">(선택)</span></h4>							  
						   </div>						   
						   <table class="list2 font_white">
							   <caption>자기기술서</caption>
								<colgroup>
									<col style="width: 30%;">																		
									<col style="width: 70%;">
								</colgroup>
								<tbody>
									<tr>
									   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="my_skill">자기기술서</label></span></th>
									   <td>
										   <textarea name="my_skill" id="self_description" cols="30" rows="8" class="w100 d_input" disabled></textarea>
										   <p class="ta_r">(500자 이내)</p>
									   </td>
									</tr>
								 </tbody>
							</table>
						   
						   <!--//관리자 or 내부평가위원 view-->						  
						   <div class="fr mt30 clearfix">
						   	   <button type="button" style="display:none;" id="reg_fail_btn" onclick="updateCommissionerStatus('D0000003');" class="gray_btn fl mr5 member_manager_hold_popup_btn">선정보류</button>
							   <button type="button" style="display:none;" id="reg_success_btn" class="blue_btn2 fl mr5" onclick="moveAcceptance();">선정완료 및 이메일 발송</button>
							   <button type="button" class="gray_btn2 fl" onclick="location.href='/admin/fwd/member/commissioner/main'">목록</button>
						   </div>
						   
					   </div><!--contents_view-->
                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>