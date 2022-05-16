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

	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/calculation/search/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("calculation_id", "${vo.calculation_id}");
		comAjax.ajax();
	}

	function searchDetailCB(data) {
		console.log(data);
		
		$("#agreement_reg_number").html("<span>" + data.result_data.agreement_reg_number + "</span>");
		$("#announcement_business_name").html("<span>" + data.result_data.announcement_business_name + "</span>");
		$("#announcement_title").html("<span>" + data.result_data.announcement_title + "</span>");
		$("#tech_info_name").html("<span>" + data.result_data.tech_info_name + "</span>");
		$("#research_info").html("<span>" + data.result_data.institution_name + "/" + data.result_data.researcher_name + "</span>");
		$("#research_date").html("<span>" + data.result_data.research_date + "</span>");
		if ( gfn_isNull(data.result_data.research_funds) ) {
			$("#research_funds").html("<span>0</span><span>(만원)</span>");
		} else {
			$("#research_funds").html("<span>" + data.result_data.research_funds + "</span><span>(만원)</span>");
		}

		$("#support_fund").html(data.result_data.support_fund + "(만원)");
		$("#cash").html(data.result_data.cash + "(만원)");
		$("#hyeonmul").html(data.result_data.hyeonmul + "(만원)");
		$("#total_cost").html(data.result_data.total_cost + "(만원)");

		// 연구비 상세 정보
		if ( data.result_data.fund_detail_list != null && data.result_data.fund_detail_list.length > 0) {
			$.each(data.result_data.fund_detail_list, function(key, value) {
				$("#fund_detail_body tr").each(function(){
					var tr = $(this);

					if (value.item_name == tr.attr("id")) {
						tr.find('td:eq(1)').text(value.item_plan + "(만원)");
						tr.find('td:eq(2)').text(value.item_excution + "(만원)");
						tr.find('td:eq(3)').text(value.item_balance + "(만원)");
						tr.find('td:eq(4)').text(value.item_total + "(만원)");
						return false;
					}
				});
			});
		}
		
		// 파일 이름
		$("#document_file_name").text(data.result_data.document_file_name);
		$("#document_file_name").attr("file_id", data.result_data.document_file_id);
		$("#report_file_name").text(data.result_data.report_file_name);
		$("#document_file_name").attr("file_id", data.result_data.report_file_id);

		if ( data.result_data.calculation_status != "제출완료" ) {
			$("#btn_submitReport").hide();
		} 
	}

	function onSubmitCompleted() {
		var formData = new FormData();
		formData.append("calculation_id", "${vo.calculation_id}");
		formData.append("calculation_status", "정산완료");
		
		$.ajax({
		    type : "POST",
		    url : "/admin/api/calculation/status/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		            alert("정산완료 되었습니다.");
		            onMoveExecutionPage("${vo.announcement_type}");
		        } else {
		            alert("정산완료에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});

	}

	function downloadFile(element) {
		var temp = $(element).attr("file_id");
		location.href = "/util/api/file/download/" + $(element).attr("file_id");
	}


	/*******************************************************************************
	* 컨퍼넌트 이벤트 
	*******************************************************************************/
	//평가관리 사이트로 이동한다. (기술매칭/기술공모/기술제안)
	function onMoveExecutionPage(evaluationType){
		// 기술매칭/기술공모/기술제안은 URL로 구분
		location.href = "/admin/fwd/calculation/main?announcement_type=" + evaluationType;
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
							   <h2 class="title">정산관리</h2>
						   </div>
						   <!--// 레프트 메뉴 서브 타이틀 -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="javascript:void(0)" onclick="onMoveExecutionPage('D0000005');" title="평가관리">정산관리</a></li>
								   <li class="menu2depth">
									   <ul>
										   <li id="left_menu_match"><a href="javascript:void(0)" onclick="onMoveExecutionPage('D0000005');">기술매칭</a></li>
										   <li id="left_menu_contest"><a href="javascript:void(0)" onclick="onMoveExecutionPage('D0000003');">기술공모</a></li>
										   <li id="left_menu_proposal"><a href="javascript:void(0)" onclick="onMoveExecutionPage('D0000004');">기술제안</a></li>
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
								   <li><a href="javascript:void(0)" onclick="onMoveCalculationPage('${vo.announcement_type}');"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>정산관리</li>
								   <li><strong class="location_name">기술매칭</strong></li>
								</ul>	
							    <!--//페이지 경로-->
							    <!--페이지타이틀-->
							    <h3 class="title_area location_name">기술매칭</h3>
							    <!--//페이지타이틀-->
						    </div>
					    </div><!--location_area-->
					   					   
						<div class="contents_view compute_technologymatching_send_view">	
							<!--과제정보-->
							<div class="view_top_area clearfix">
							   <h4 class="sub_title_h4">과제 정보</h4>
							</div>
							<table class="list2 assignment_info">
							   <caption>과제 정보</caption> 
							   <colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
							   </colgroup>
							   <thead>
								   <tr>
									   <th scope="row">과제번호</th>
									   <td id="agreement_reg_number"></td> 
								   </tr>
							   </thead>
							   <tbody>
									<tr>
									   <th scope="row">사업명</th>
									   <td id="announcement_business_name"></td> 
								    </tr>
									<tr>
									   <th scope="row">공고명</th>
									   <td id="announcement_title"></td> 
									</tr>
									<tr>
									   <th scope="row">기술명</th>
									   <td id="tech_info_name"></td> 
									</tr>
									<tr>
									   <th scope="row">연구기관/연구책임자</th>
									   <td id="research_info"></td> 
									</tr>
									<tr>
									   <th scope="row">연구기간</th>
									   <td id="research_date"></td> 
									</tr>
									<tr>
									   <th scope="row">연구비</th>
									   <td id="research_funds"></td> 
									</tr>
							   </tbody>
							</table>
							<!--//과제정보-->

							<!--연구비 정보-->
							<div class="view_top_area clearfix">
							   <h4 class="sub_title_h4">연구비 정보</h4>							  
							</div>
							<table class="list2 compute_money">
								<caption>연구비 정보</caption> 
								<colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
								</colgroup>
								<thead>								   
									<tr>
										<th scope="row">시지원금</th>
										<td id="support_fund"></td> 
									</tr>								  
								</thead>
								<tbody>								   								    															       
									<tr>
										<th scope="row">민간부담금 현금</th>
										<td id="cash"></td>
									</tr>
									<tr>
										<th scope="row">민간부담금 현물</th>
										<td id="hyeonmul"></td>
									</tr>
									<tr>
										<th scope="row">총 사업비</th>
										<td id="total_cost"></td>
									</tr>			
								</tbody>
							</table>
							<!--//연구비 정보-->

							<!--연구비 상세정보-->													    
							<div class="view_top_area">
								<h4 class="sub_title_h4">연구비 상세정보</h4>
							</div>
							<table class="list compute_detail_money">
								<caption>연구비 상세정보</caption> 
								<colgroup>
									<col style="width: 20%;">
									<col style="width: 20%;">
									<col style="width: 20%;">
									<col style="width: 20%;">
									<col style="width: 20%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">비목</th>
										<th scope="col">계획</th>
										<th scope="col">집행</th>
										<th scope="col">잔액(자동계산)</th>
										<th scope="col">최종</th>
									</tr>
								</thead>
								<tbody id="fund_detail_body">											
									<tr id="ab">
										<td class="ta_c total">인건비(A+B)</td>
										<td class="total"></td> 
										<td class="total"></td> 
										<td class="total"></td> 
										<td class="total"></td> 
									</tr>
									<tr id="a">
										<td class="th_color">내부인건비(A)</td>
										<td></td> 
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr id="b">
										<td class="th_color">외부인건비(B)</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr id="cdef">
										<td class="total">경비(C+D+E+F)</td>
										<td class="total"></td> 
										<td class="total"></td> 
										<td class="total"></td> 
										<td class="total"></td> 
									</tr>
									<tr id="c">
										<td class="th_color">연구장비/재료비(C)</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr id="d">
										<td class="th_color">연구활동비(D)</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
									<tr id="e">
										<td class="th_color">위탁사업비(E)</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td> 
									</tr>
									<tr id="f">
										<td class="th_color">성과장려비(F)</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td> 
									</tr>
									<tr id="g">
										<td class="ta_c total">간접비(G)</td>
										<td class="total"></td> 
										<td class="total"></td> 
										<td class="total"></td> 
										<td class="total"></td> 
									</tr>
									<tr id="abcdefg">
										<td scope="col" class="total_all">합계(A+B+C+D+E+F+G)</td>
										<td class="total_all"></td> 
										<td class="total_all"></td> 
										<td class="total_all"></td> 
										<td class="total_all"></td> 
									</tr>	
								</tbody>
							</table>
							<!--//연구비 상세정보-->


							<!--정산서류-->
							<div class="view_top_area clearfix">
							   <h4 class="sub_title_h4">정산 서류</h4>							  
							</div>
							<table class="list2 docu_mission">
								<caption>정산 서류</caption> 
								<colgroup>
								   <col style="width: 20%">
								   <col style="width: 80%">
								</colgroup>
								<thead>
								   <tr>
										<th scope="row">정산서류</th>
										<td>										
											<div class="file_form_txt">	  
												<a href="javascript:void(0);" download id="document_file_name" onclick='downloadFile(this)'></a>										
											</div>			
										</td> 
									</tr>
									<tr>
										<th scope="row">정산보고서 </th>
										<td>										
											<div class="file_form_txt">	  
												<a href="javascript:void(0);" download id="report_file_name" onclick='downloadFile(this)'></a>										
											</div>			
										</td> 
									</tr>
								</thead>
								
							</table>
							<!--//정산서류-->
								

							<div class="button_area mt30 p5">
								<button type="button" class="gray_btn2 fr" onclick="onMoveExecutionPage('${vo.announcement_type}')">목록</button>
								<button type="button" id="btn_submitReport" class="blue_btn fr mr5 compute_ok_popup_open">정산완료 승인</button>
							</div>
						</div><!--//contents view-->

                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>
            
            
        <!--정산 승인 팝업-->
	    <div class="compute_ok_popup_box">
		   <div class="popup_bg"></div>
		   <div class="compute_ok_popup">
		       <div class="popup_titlebox clearfix">
			       <h4 class="fl">정산완료 승인 안내</h4>
			       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
			   </div>			  
			   <div class="popup_txt_area">
				   <p>해당 <span class="font_blue">정산서</span>를 <span class="font_blue">승인</span> 하시겠습니까?</p>		
				   <div class="popup_button_area_center">
					  <button type="submit" class="blue_btn mr5" onclick="onSubmitCompleted();">예</button>
					  <button type="button" class="gray_btn popup_close_btn">아니요</button>						   
				   </div>
			   </div>
			   
		   </div>
		</div>
		<!--//정산협약서 승인 팝업-->
<script src="/assets/admin/js/script.js"></script>