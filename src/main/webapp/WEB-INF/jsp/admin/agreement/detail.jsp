<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	var memberId;
	var institutionName;
	var agreementStatus;
	var receptionId;

	$(document).ready(function() {
		displayMain();
		// 평가 목록
		searchDetail(); 
		// 기관 정보
		searchInstitution();
	});

	/*******************************************************************************
	* FUNCTION
	*******************************************************************************/
	// announcement_type과 classification에 따라서 달라지는 화면을 그린다.
	function displayMain() {
		if ( "${vo.announcement_type}" == "D0000005" ) {
			$("#left_menu_match").addClass("active");
			$(".location_name").text("기술매칭");
		} else if ( "${vo.announcement_type}" == "D0000004" ) {
			$("#left_menu_proposal").addClass("active");
			$(".location_name").text("기술재안");
			$("#li_evaluation_match").hide();
		} else if ( "${vo.announcement_type}" == "D0000003" ) {
			$("#left_menu_contest").addClass("active");
			$(".location_name").text("기술공모");
			$("#li_evaluation_match").hide();
		}
	}

	// 협약 상세 정보	
	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/agreement/search/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("agreement_id", "${vo.agreement_id}");
		comAjax.ajax();
	}
	function searchDetailCB(data) {
		console.log(data);

		// 협약 준비 중이 아니면 나머지 정보도 보여준다.
		if ( data.result_data.agreement_status == "D0000001") {
			$("#btn_agreement_ready_with_report").show();
			$("#btn_agreement_ready_without_report").show();
		} else if ( data.result_data.agreement_status == "D0000002") { 
			$("#btn_agreement_ready_with_report").hide();
			$("#btn_agreement_ready_without_report").hide();
		} else if ( data.result_data.agreement_status == "D0000005") {
			$("#btn_agreement_auth").hide();
			$("#agreement_ready_div").show();
			$("#remark").prop("disabled", true);
		} 
		else {
			$("#agreement_ready_div").show();
			$("#btn_agreement_auth").show();
		}

		$("#announcement_business_name").html("<span>" + data.result_data.announcement_business_name + "</span>");
		$("#announcement_title").html("<span>" + data.result_data.announcement_title + "</span>");
		$("#tech_info_name").html("<span>" + data.result_data.tech_info_name + "</span>");
		$("#research_info").html("<span>" + data.result_data.institution_name + "/" + data.result_data.researcher_name + "</span>");
		$("#research_date").html("<span>" + data.result_data.research_date + "</span>");
		$("#research_funds").html("<span>" + data.result_data.research_funds + "</span>");

		// 연구원 정보
		$("#bdy_supervision_senior_researcher").empty();
		var supervisionSeniorString = "";
		$("#bdy_supervision_researcher").empty();
		var supervisionString = "";
		$("#bdy_senior_researcher").empty();
		var seniorString = "";
		$("#bdy_researcher").empty();
		var researcherString = "";
		var index1 = 1;
		var index2 = 1;
		$.each(data.result_data.agreement_researcher_list, function(key, value) {
			// 주관기관 - 연구책임자 
			if ( value.institution_gubun == "주관기관" && value.researcher_gubun == "연구책임자") {
				supervisionSeniorString += "<tr>";
				supervisionSeniorString += "	<td>1</td>";
				supervisionSeniorString += "	<td><span>" + value.institution_gubun + "</span></td>";
				supervisionSeniorString += "	<td><span>" + value.institution_name + "</span></td>";
				supervisionSeniorString += "	<td><span>" + value.institution_department + "</span></td>";
				supervisionSeniorString += "	<td><span>" + value.institution_position + "</span></td>";
				supervisionSeniorString += "	<td><span>" + value.name + "</span></td>";
				supervisionSeniorString += "	<td><span>" + value.birth + "</span></td>";
				supervisionSeniorString += "	<td><span>" + value.hand_phone + "</span></td>";
				supervisionSeniorString += "	<td><span>" + value.email + "</span></td>";
				supervisionSeniorString += "	<td><span>" + value.participation_rate + "</span><span>%</span></td>";
				supervisionSeniorString += "	<td><span>" + value.participation_from_date + "</span></td>";
				supervisionSeniorString += "	<td><span>" + value.participation_tod_date + "</span></td>";
				supervisionSeniorString += "</tr>";
			}
			// 주관기관 - 참여연구원
			if ( value.institution_gubun == "주관기관" && value.researcher_gubun == "참여연구원") {
				supervisionString += "<tr>";
				supervisionString += "	<td>" + index1 +"</td>";
				supervisionString += "	<td><span>" + value.institution_gubun + "</span></td>";
				supervisionString += "	<td><span>" + value.institution_name + "</span></td>";
				supervisionString += "	<td><span>" + value.institution_department + "</span></td>";
				supervisionString += "	<td><span>" + value.institution_position + "</span></td>";
				supervisionString += "	<td><span>" + value.name + "</span></td>";
				supervisionString += "	<td><span>" + value.birth + "</span></td>";
				supervisionString += "	<td><span>" + value.hand_phone + "</span></td>";
				supervisionString += "	<td><span>" + value.email + "</span></td>";
				supervisionString += "	<td><span>" + value.participation_rate + "</span><span>%</span></td>";
				supervisionString += "	<td><span>" + value.participation_from_date + "</span></td>";
				supervisionString += "	<td><span>" + value.participation_tod_date + "</span></td>";
				supervisionString += "	<td><span>" + value.role + "</span></td>";
				supervisionString += "</tr>";
				index1++;
			}
			// 참여기관 - 연구책임자
			if ( value.institution_gubun.includes("참여기관") && value.researcher_gubun == "연구책임자") {
				seniorString += "<tr>";
				seniorString += "	<td>1</td>";
				seniorString += "	<td><span>" + "참여기관" + "</span></td>";
				seniorString += "	<td><span>" + value.institution_name + "</span></td>";
				seniorString += "	<td><span>" + value.institution_department + "</span></td>";
				seniorString += "	<td><span>" + value.institution_position + "</span></td>";
				seniorString += "	<td><span>" + value.name + "</span></td>";
				seniorString += "	<td><span>" + value.birth + "</span></td>";
				seniorString += "	<td><span>" + value.hand_phone + "</span></td>";
				seniorString += "	<td><span>" + value.email + "</span></td>";
				seniorString += "	<td><span>" + value.participation_rate + "</span><span>%</span></td>";
				seniorString += "	<td><span>" + value.participation_from_date + "</span></td>";
				seniorString += "	<td><span>" + value.participation_tod_date + "</span></td>";
				seniorString += "</tr>";
			}
			// 참여기관 - 참여연구원
			if ( value.institution_gubun.includes("참여기관") && value.researcher_gubun == "참여연구원") {
				researcherString += "<tr>";
				researcherString += "	<td>" + index2 +"</td>";
				researcherString += "	<td><span>" + value.institution_gubun + "</span></td>";
				researcherString += "	<td><span>" + value.institution_name + "</span></td>";
				researcherString += "	<td><span>" + value.institution_department + "</span></td>";
				researcherString += "	<td><span>" + value.institution_position + "</span></td>";
				researcherString += "	<td><span>" + value.name + "</span></td>";
				researcherString += "	<td><span>" + value.birth + "</span></td>";
				researcherString += "	<td><span>" + value.hand_phone + "</span></td>";
				researcherString += "	<td><span>" + value.email + "</span></td>";
				researcherString += "	<td><span>" + value.participation_rate + "</span><span>%</span></td>";
				researcherString += "	<td><span>" + value.participation_from_date + "</span></td>";
				researcherString += "	<td><span>" + value.participation_tod_date + "</span></td>";
				researcherString += "	<td><span>" + value.role + "</span></td>";
				researcherString += "</tr>";
				index2++;
			}
		});
		$("#bdy_supervision_senior_researcher").append(supervisionSeniorString);
		$("#bdy_supervision_researcher").append(supervisionString);
		$("#bdy_senior_researcher").append(seniorString);
		$("#bdy_researcher").append(researcherString);


		// 연구비 정보
		$("#support_amount1").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_support_amount1) + "</span><span>(만원)</span>");
		$("#support_amount2").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_support_amount2) + "</span><span>(만원)</span>");
		$("#support_amount3").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_support_amount3) + "</span><span>(만원)</span>");
		$("#support_amount4").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_support_amount4) + "</span><span>(만원)</span>");
		$("#cash1").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_cash1) + "</span><span>(만원)</span>");
		$("#cash2").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_cash2) + "</span><span>(만원)</span>");
		$("#cash3").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_cash3) + "</span><span>(만원)</span>");
		$("#cash4").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_cash4) + "</span><span>(만원)</span>");
		$("#hyeonmul1").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_hyeonmul1) + "</span><span>(만원)</span>");
		$("#hyeonmul2").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_hyeonmul2) + "</span><span>(만원)</span>");
		$("#hyeonmul3").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_hyeonmul3) + "</span><span>(만원)</span>");
		$("#hyeonmul4").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_hyeonmul4) + "</span><span>(만원)</span>");
		$("#total_project_cost1").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_total_cost1) + "</span><span>(만원)</span>");
		$("#total_project_cost2").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_total_cost2) + "</span><span>(만원)</span>");
		$("#total_project_cost3").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_total_cost3) + "</span><span>(만원)</span>");
		$("#total_project_cost4").html("<span>" + makeMoneyWithCommaString(data.result_data.fund_total_cost4) + "</span><span>(만원)</span>");


		// 연구비 상세 정보
		$("#fund_detail_body").empty();
		var fundString = "";
		$.each(data.result_data.agreement_fund_detail_list, function(key, value) {
			fundString += "<tr>";
			fundString += "		<td class='th_color'>" + value.type + "</td>";
			fundString += "		<td class='total'>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.ab_total) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.ab_total_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "		<td>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.a) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.a_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "		<td>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.b) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.b_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "		<td class='total'>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.cdef_total) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.cdef_total_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "		<td>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.c) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.c_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "		<td>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.d) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.d_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "		<td>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.e) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.e_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "		<td>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.f) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.f_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "		<td class='total'>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.g) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.g_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "		<td class='total_all'>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.total) + "</span><span>(만원)</span></span>";
			fundString += "			<span class='m_a'><span>" + makeMoneyWithCommaString(value.total_p) + "</span><span>%</span></span>";
			fundString += "		</td>";
			fundString += "</tr>";
		});
		$("#fund_detail_body").append(fundString);
		
		// 파일 이름
		$("#upload_plan_file_name").text(data.result_data.upload_plan_file_name);
		$("#upload_plan_file_name").attr("file_id", data.result_data.upload_plan_file_id);
		$("#upload_agreement_file_name").text(data.result_data.upload_agreement_file_name);
		$("#upload_agreement_file_name").attr("file_id", data.result_data.upload_agreement_file_id);
		if ( data.result_data.return_upload_files != null) {
	    	uploaded_files = data.result_data.return_upload_files;
	    	$("#file_list").empty();
	    	for(var i=0; i<uploaded_files.length; i++) {
		    	$("#file_list").append("<li><a href='javascript:void(0);' file_id='" +uploaded_files[i].file_id + "' onclick='downloadFile(this);'>" + uploaded_files[i].name + "</a></li>");
		    }
		}

		// 비고
		$("#remark").val(data.result_data.remark);
		
		memberId = data.result_data.member_id;
		institutionName = data.result_data.institution_name;
		agreementStatus = data.result_data.agreement_status;
		receptionId = data.result_data.reception_id;
	}

	// 기관 정보
	function searchInstitution() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/institution/detail'/>");
		comAjax.setCallback(getInstitutionCB);
		comAjax.addParam("member_id", memberId);
		comAjax.ajax();
	}
	function getInstitutionCB(data){
		$("#reg_no").html("<span>" + data.result.reg_no + "</span>");
		$("#institution_name").html("<span>" + institutionName + "</span>");
		$("#address").html("<span>" + data.result.address + " " +data.result.address_detail + "</span>");
		$("#phone").html("<span>" + data.result.phone + "</span>");
		$("#representative_name").html("<span>" + data.result.representative_name + "</span>");
		$("#industry_type").html("<span>" + data.result.industry_type + "</span>");
		$("#business_type").html("<span>" + data.result.business_type + "</span>");
		$("#foundation_date").html("<span>" + data.result.foundation_date + "</span>");
		if ( data.result.foundation_type == "D0000001" ) {
			$("#foundation_date").html("<span>영리</span>");
		} else {
			$("#foundation_date").html("<span>비영리</span>");
		}
		if ( data.result.company_class == "D0000001" ) {
			$("#company_class").html("<span>대기업</span>");
		} else if ( data.result.company_class == "D0000002" ){
			$("#company_class").html("<span>중견기업</span>");
		} else if ( data.result.company_class == "D0000003" ){
			$("#company_class").html("<span>중소기업</span>");
		} else {
			$("#company_class").html("<span>기타</span>");
		}
		if ( data.result.company_type == "D0000001" ) {
			$("#company_type").html("<span>여성기업</span>");
		} else if ( data.result.company_type == "D0000002" ){
			$("#company_type").html("<span>장애인기업</span>");
		} else if ( data.result.company_type == "D0000003" ){
			$("#company_type").html("<span>사회적기업</span>");
		} else {
			$("#company_type").html("<span>해당 없음</span>");
		}
		if ( data.result.lab_exist_yn == "Y" ) {
			$("#lab_exist_yn").html("<span>있음</span>");
		} else {
			$("#lab_exist_yn").html("<span>없음</span>");
		}
	}

	function downloadFile(element) {
		location.href = "/util/api/file/download/" +$(element).attr("file_id");
	}


	/*******************************************************************************
	* 컨퍼넌트 이벤트 
	*******************************************************************************/
	// agreement 상태 변경
	function onUpdateAgreementStatus(status) {
		var comment;
		if ( status == "D0000005") {
			if ( agreementStatus != "D0000004") {
				alert("협약서가 미제출  되었습니다.");
				return;
			}
			comment = "협약 완료 승인 하시겠습니까?";
		} else {
			comment = "협약 준비 완료 하시겠습니까?";
		}
		
		if ( confirm(comment) ) {
			var comAjax = new ComAjax();
			comAjax.setUrl("/admin/api/agreement/status/modification");
			comAjax.setCallback(getStatusModificationCB);
			comAjax.addParam("reception_id", receptionId);
			comAjax.addParam("agreement_id", "${vo.agreement_id}");
			comAjax.addParam("agreement_status", status);
			comAjax.addParam("remark", $("#remark").val());
			comAjax.ajax();
		}
	}
	function getStatusModificationCB(data) {
		if(data.result == true) {
			alert("완료 되었습니다.");
			onMoveAgreementPage("${vo.announcement_type}");
		} else {
			alert("실패하였습니다. 다시 시도해 주시기 바랍니다.");
		}
	}
	

	//평가관리 사이트로 이동한다. (기술매칭/기술공모/기술제안)
	function onMoveAgreementPage(evaluationType){
		// 기술매칭/기술공모/기술제안은 URL로 구분
		location.href = "/admin/fwd/agreement/main?announcement_type=" + evaluationType;
	}
	
</script>
            
<div class="container" id="content">
                <h2 class="hidden">컨텐츠 화면</h2>
                <div class="sub">
                    <!--left menu 서브 메뉴-->     
					<div id="lnb">
					   <div class="lnb_area">
						   <!-- 레프트 메뉴 서브 타이틀 -->	
						   <div class="lnb_title_area">
							   <h2 class="title">협약관리</h2>
						   </div>
						   <!--// 레프트 메뉴 서브 타이틀 -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="javascript:void(0)" onclick="onMoveAgreementPage('D0000005');" title="평가관리">협약관리</a></li>
								   <li class="menu2depth">
									   <ul>
										   <li id="left_menu_match"><a href="javascript:void(0)" onclick="onMoveAgreementPage('D0000005');">기술매칭</a></li>
										   <li id="left_menu_contest"><a href="javascript:void(0)" onclick="onMoveAgreementPage('D0000003');">기술공모</a></li>
										   <li id="left_menu_proposal"><a href="javascript:void(0)" onclick="onMoveAgreementPage('D0000004');">기술제안</a></li>
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
								   <li>협약관리</li>
								   <li><strong class="location_name">기술매칭</strong></li>
								</ul>	
							    <!--//페이지 경로-->
							    <!--페이지타이틀-->
							    <h3 class="title_area location_name">기술매칭</h3>
							    <!--//페이지타이틀-->
						    </div>
					    </div><!--location_area-->
					   					   
						<div class="contents_view agreement_technologymatching_send_view">						  
							<div id="agreement_not_ready_div">
								<div class="view_top_area clearfix">
								   <h4 class="fl sub_title_h4">과제 정보</h4>
								</div>
								<table class="list2 assignment_info">
								   <caption>과제정보</caption> 
								   <colgroup>
									   <col style="width: 20%" />
									   <col style="width: 80%" />
								   </colgroup>
								   <thead>
									   <tr>
										   <th scope="row">사업명</th>
										   <td id="announcement_business_name"><span>기술제안</span></td> 
									   </tr>
								   </thead>
								   <tbody>								       
									   <tr>
										   <th scope="row">공고명</th>
										   <td id="announcement_title"><span>기술제안</span></td> 
									   </tr>
									   <tr>
										   <th scope="row">기술명</th>
										   <td id="tech_info_name"><span>기술명</span></td> 
									   </tr>
									   <tr>
										   <th scope="row">연구기관/연구책임자</th>
										   <td id="research_info"><span>연구기관</span>/<span>홍길동</span></td> 
									   </tr>
									   <tr>
										   <th scope="row">연구기간</th>
										   <td id="research_date"><span>2021</span><span>-</span><span>09</span><span>-</span><span>17</span></td> 
									   </tr>
									   <tr>
										   <th scope="row">연구비</th>
										   <td id="research_funds"><span class="mr5">200,000,000</span><span>(만원)</span></td> 
									   </tr>
								   </tbody>
								</table>
	
								<div class="view_top_area clearfix">
								   <h4 class="fl sub_title_h4">기관 정보</h4>							  
								</div>
								<table class="list2 assignment_info">
									<caption>기관 정보</caption> 
									<colgroup>
									   <col style="width: 20%" />
									   <col style="width: 80%" />
									</colgroup>
									<thead>
									   <tr>
											<th scope="row">사업자등록번호</th>
											<td id="reg_no"></td> 
									   </tr>
									</thead>
									<tbody>								       
									   <tr>
											<th scope="row">기관명</th>
											<td id="institution_name"></td> 
									   </tr>
									   <tr>
											<th scope="row">주소</th>
											<td id="address"></td> 
									   </tr>
									   <tr>
											<th scope="row">전화</th>
											<td id="phone"></td>  
									   </tr>
									   <tr>
										    <th scope="row">대표자명</th>
										    <td id="representative_name"></td> 
									   </tr>
									   <tr>
										    <th scope="row">업종</th>
										    <td id="industry_type"></td> 
									   </tr>
									   <tr>
										    <th scope="row">업태</th>
										    <td id="business_type"></td>
									   </tr>
									   <tr>
										    <th scope="row">설립일</th>
											<td id="foundation_date"></td>
									    </tr>
									    <tr>
										    <th scope="row">설립 구분</th>
										    <td id="foundation_type"><span>영리</span></td>
									    </tr>
									    <tr>
										    <th scope="row">기업 분류</th>
										    <td id="company_class"><span>중소기업</span></td>
									    </tr>
										<tr>
										    <th scope="row">기업 유형</th>
										    <td id="company_type"><span>해당없음</span></td>
									    </tr>
										<tr>
										    <th scope="row">기업부설연구소 유무</th>
										    <td id="lab_exist_yn"><span>있음</span></td>
									    </tr>
									</tbody>
								</table>
							</div>
							
							
							<div id="agreement_ready_div" style="display:none">
								<div class="view_top_area section1">
								<div class="section_title">주관기관</div>							    
								<div class="view_top_area clearfix">
									<h4 class="fl sub_title_h4">연구책임자 정보</h4>
								</div>
								<table class="list responsible">
									<caption>연구책임자 정보(주관기관)</caption> 
									<colgroup>
									   <col style="width: 4%" />
									   <col style="width: 6%" />
									   <col style="width: 12%" />
									   <col style="width: 10%" />
									   <col style="width: 7%" />
									   <col style="width: 6%" />
									   <col style="width: 8%" />
									   <col style="width: 9%" />
									   <col style="width: 18%" />
									   <col style="width: 4%" />
									   <col style="width: 8%" />
									   <col style="width: 8%" />
									</colgroup>
									<thead>
									   <tr>
										   <th scope="col">번호</th>
										   <th scope="col">구분</th>
										   <th scope="col">기관명</th>
										   <th scope="col">부서</th>
										   <th scope="col">직책</th>
										   <th scope="col">성명</th>
										   <th scope="col">생년월일</th>
										   <th scope="col">휴대전화</th>
										   <th scope="col">이메일</th>
										   <th scope="col">참여율</th>
										   <th scope="col">참여시작일</th>
										   <th scope="col">참여종료일</th>
									   </tr>
									</thead>
									<tbody id="bdy_supervision_senior_researcher">								       
									</tbody>
								</table>

								<div class="view_top_area clearfix">
								   <h4 class="fl sub_title_h4">참여 연구원 정보</h4>
								</div>
								<table class="list chamyeo">
									<caption>참여 연구원 정보</caption> 
									<colgroup>
									   <col style="width: 4%" />
									   <col style="width: 6%" />
									   <col style="width: 12%" />
									   <col style="width: 10%" />
									   <col style="width: 7%" />
									   <col style="width: 6%" />
									   <col style="width: 6%" />
									   <col style="width: 9%" />
									   <col style="width: 18%" />
									   <col style="width: 4%" />
									   <col style="width: 6%" />
									   <col style="width: 6%" />
									   <col style="width: 6%" />
									</colgroup>
									<thead>
									   <tr>
										   <th scope="col">번호</th>
										   <th scope="col">구분</th>
										   <th scope="col">기관명</th>
										   <th scope="col">부서</th>
										   <th scope="col">직책</th>
										   <th scope="col">성명</th>
										   <th scope="col">생년월일</th>
										   <th scope="col">휴대전화</th>
										   <th scope="col">이메일</th>
										   <th scope="col">참여율</th>
										   <th scope="col">참여시작일</th>
										   <th scope="col">참여종료일</th>
										   <th scope="col">역할</th>
									   </tr>
									</thead>
									<tbody id="bdy_supervision_researcher">								       
									</tbody>
								</table>
							</div>
							<!--//주관기관-->
							
							<!--참여기관-->
							<div class="view_top_area section1">
								<div class="section_title">참여기관</div>							    
								<div class="view_top_area clearfix">
									<h4 class="fl sub_title_h4">연구책임자 정보</h4>
								</div>
								<table class="list responsible">
									<caption>연구책임자 정보</caption> 
									<colgroup>
									   <col style="width: 4%" />
									   <col style="width: 6%" />
									   <col style="width: 12%" />
									   <col style="width: 10%" />
									   <col style="width: 7%" />
									   <col style="width: 6%" />
									   <col style="width: 8%" />
									   <col style="width: 9%" />
									   <col style="width: 18%" />
									   <col style="width: 4%" />
									   <col style="width: 8%" />
									   <col style="width: 8%" />
									</colgroup>
									<thead>
									   <tr>
										   <th scope="col">번호</th>
										   <th scope="col">구분</th>
										   <th scope="col">기관명</th>
										   <th scope="col">부서</th>
										   <th scope="col">직책</th>
										   <th scope="col">성명</th>
										   <th scope="col">생년월일</th>
										   <th scope="col">휴대전화</th>
										   <th scope="col">이메일</th>
										   <th scope="col">참여율</th>
										   <th scope="col">참여시작일</th>
										   <th scope="col">참여종료일</th>
									   </tr>
									</thead>
									<tbody id="bdy_senior_researcher">								       
									</tbody>
								</table>

								<div class="view_top_area clearfix">
								   <h4 class="fl sub_title_h4">참여 연구원 정보</h4>
								</div>
								<table class="list chamyeo">
									<caption>참여 연구원 정보</caption> 
									<colgroup>
									   <col style="width: 4%" />
									   <col style="width: 6%" />
									   <col style="width: 12%" />
									   <col style="width: 10%" />
									   <col style="width: 7%" />
									   <col style="width: 6%" />
									   <col style="width: 6%" />
									   <col style="width: 9%" />
									   <col style="width: 18%" />
									   <col style="width: 4%" />
									   <col style="width: 6%" />
									   <col style="width: 6%" />
									   <col style="width: 6%" />
									</colgroup>
									<thead>
									   <tr>
										   <th scope="col">번호</th>
										   <th scope="col">구분</th>
										   <th scope="col">기관명</th>
										   <th scope="col">부서</th>
										   <th scope="col">직책</th>
										   <th scope="col">성명</th>
										   <th scope="col">생년월일</th>
										   <th scope="col">휴대전화</th>
										   <th scope="col">이메일</th>
										   <th scope="col">참여율</th>
										   <th scope="col">참여시작일</th>
										   <th scope="col">참여종료일</th>
										   <th scope="col">역할</th>
									   </tr>
									</thead>
									<tbody id="bdy_researcher">								       
									</tbody>
								</table>
							</div>
							<!--//참여기관-->

							<!--연구비정보-->
							<div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">연구비 정보</h4>
							</div>
							<div class="table_area">
								<table class="write fixed list research_cost">										 
									<caption>연구비 정보</caption>		
									<colgroup>
									   <col style="width: 20%">
									   <col style="width: 20%">
									   <col style="width: 20%">
									   <col style="width: 20%">
									   <col style="width: 20%">
									</colgroup>
									<thead>
									   <tr><td colspan="5" class="th_color">구분</td></tr>
									   <tr>
										   <th scope="col">&nbsp;</th>
										   <th scope="col">시지원금(A)</th>
										   <th scope="col">민간부담금 현금(B)</th>
										   <th scope="col">민간부담금 현물(C)</th>
										   <th scope="col">총사업비(D=A+B+C)</th>												   
									   </tr>
									</thead>		
																				
									<tbody id="fund_body">	
										<tr>
											<td class="th_color">총사업비</td>
											<td id="support_amount1">
											</td> 
											<td id="cash1">
											</td> 
											<td id="hyeonmul1">
											</td>
											<td id="total_project_cost1">
											</td>
										</tr>
										<tr>
											<td class="th_color">주관기관</td>
											<td id="support_amount2">
											</td> 
											<td id="cash2">
											</td> 
											<td id="hyeonmul2">
											</td>
											<td id="total_project_cost2">
											</td>
										</tr>
										<tr>
											<td class="th_color">참여기관1</td>
											<td id="support_amount3">
											</td> 
											<td id="cash3">
											</td> 
											<td id="hyeonmul3">
											</td>
											<td id="total_project_cost3">
											</td>
										</tr>
										<tr>
											<td class="th_color">참여기관2</td>
											<td id="support_amount4">
											</td> 
											<td id="cash4">
											</td> 
											<td id="hyeonmul3">
											</td>
											<td id="total_project_cost4">
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<!--//연구비정보-->

							<!--인건비 상세정보-->
							<div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">연구비 상세정보</h4>
							</div>
							<div class="table_area">
								<table class="write fixed list research_cost_detail">										 
									<caption>연구비 정보</caption>		
									<colgroup>
									   <col style="width: 5%">
									   <col style="width: 9%">
									   <col style="width: 9%">
									   <col style="width: 9%">
									   <col style="width: 9%">
									   <col style="width: 9%">
									   <col style="width: 9%">
									   <col style="width: 9%">
									   <col style="width: 9%">
									   <col style="width: 9%">
									   <col style="width: 10%">
									</colgroup>
									<thead>
									   <tr><td colspan="11" class="th_color">비목</td></tr>
									   <tr>
										   <th scope="col">&nbsp;</th>
										   <th scope="col" class="total">인건비(A+B)</th>
										   <th scope="col">내부인건비(A)</th>
										   <th scope="col">외부인건비(B)</th>
										   <th scope="col" class="total">경비(C+D+E+F)</th>	
										   <th scope="col">연구장비/재료비(C)</th>	
										   <th scope="col">연구활동비(D)</th>	
										   <th scope="col">위탁사업비(E)</th>	
										   <th scope="col">성과장려비(F)</th>
										   <th scope="col" class="total">간접비(G)</th>
										   <th scope="col" class="total_all">합계(A+B+C+D+E+F+G)</th>
									   </tr>
									</thead>													
									<tbody id="fund_detail_body">	
									</tbody>
								</table>
							</div>
							<!--//인건비 상세정보-->
							
							<!--제출서류-->
							<div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">제출서류</h4>
							</div>
							<table class="write fixed documentssubmit list2">
								<caption>제출서류</caption>
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 80%;">
								</colgroup>
								<tbody>	
									<tr>
										<th scope="row">계획서</th>
										<td>
											<a href="javascript:void(0)" download id="upload_plan_file_name" onclick="downloadFile(this);"></a>												   
										</td> 		
									</tr>																	       
									<tr>
										<th scope="row">협약서</th>
										<td>
											<a href="javascript:void(0)" download id="upload_agreement_file_name" onclick="downloadFile(this);"></a>
										</td> 
									</tr>
									<tr>
									    <th scope="row">기타</th>											    
									   	<td>
											<ul id="file_list" style="clear:both"></ul>
										</td> 
									</tr>											
								</tbody>
							</table>
							<!--//제출서류-->

							<!--비고-->
							<div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">비고</h4>
							</div>
							<table class="write fixed documentssubmit list2">
								<caption>비고</caption>
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 80%;">
								</colgroup>
								<tbody>	
									<tr>
										<th scope="row">비고</th>
										<td><input id="remark" type="text" class="form-control w100" maxlength="20" /><span class="fr">(20자 내외)</span></td> 
									</tr>																		
								</tbody>
							</table>
							<!--//비고-->
							
							</div>

							<div class="button_area mt30 p5">
								<button type="button" class="gray_btn2 fr" onclick="onMoveAgreementPage('${vo.announcement_type}');">목록</button>
								<button type="button" onclick="onUpdateAgreementStatus('D0000005');" id="btn_agreement_auth" style="display:none" class="blue_btn fr mr5 agreemen_ok_popup_open">협약완료 승인</button>
								<button type="button" onclick="onUpdateAgreementStatus('D0000003');" id="btn_agreement_ready_without_report" style="display:none" class="blue_btn fr mr5 agreemen_ok_popup_open">협약준비완료(협약서미제출)</button>
								<button type="button" onclick="onUpdateAgreementStatus('D0000002');" id="btn_agreement_ready_with_report" style="display:none" class="blue_btn fr mr5 agreemen_ok_popup_open">협약준비완료(협약서제출)</button>
							</div>
						</div><!--//contents view-->

                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>
