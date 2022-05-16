<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	var institutionName;
	var agreementStatus;

	$(document).ready(function() {
		// 협약 목록
		searchDetail(); 

	});


	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/calculation/search/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("calculation_id", "${vo.calculation_id}");
		comAjax.ajax();
	}

	function searchDetailCB(data) {
		console.log(data);
		$("#reception_reg_number").html("<span>" + data.result_data.reception_reg_number + "</span>");
		$("#agreement_reg_number").html("<span>" + data.result_data.agreement_reg_number + "</span>");
		$("#announcement_business_name").html("<span>" + data.result_data.announcement_business_name + "</span>");
		$("#announcement_title").html("<span>" + data.result_data.announcement_title + "</span>");
		$("#tech_info_name").html("<span>" + data.result_data.tech_info_name + "</span>");
		$("#research_date").html("<span>" + data.result_data.research_date + "</span>");


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
	}


	
	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
 		if ( finishSubmit ) {
			$('.send_save_popup_box').fadeOut(350);
	    	location.href = "/member/fwd/calculation/main";
		}

 		if (finishRegistration) {
 			$('.send_save_popup_box').fadeOut(350);
	    	location.reload();
 		}

		
		$('.common_popup_box, .common_popup_box .popup_bg').fadeOut(350);
	}

</script>
            
<!-- container -->
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>					
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>정산</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>정산</li>
						<li>정산</li>
					</ul>
				</div>
				
				
				<!--기관-->
				<div class="content_area copmpany_area execute_area" id="copmpany_area">													
					<div class="table_area">
						<h4>과제 정보</h4>	
						<!--과제 정보-->
						<table class="write fixed assignment_info">
							<caption>과제 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>	
								<tr>
									<th scope="row">접수번호</th>
								    <td id="reception_reg_number"></td> 
							    </tr>
								<tr>
									<th scope="row">과제번호</th>
								    <td id="agreement_reg_number"></td> 
							    </tr>
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
								    <th scope="row">협약기간</th>
								    <td id="research_date"></td> 
								</tr>											
							</tbody>
				        </table>
						<!--//과제 정보-->								    
						
						<!--연구비 정보-->									
						<h4 class="sub_title_h4">연구비 정보</h4>										
					    <table class="write fixed money">
							<caption>연구비 정보</caption> 
							<colgroup>
							    <col style="width: 20%">
							    <col style="width: 80%">
							</colgroup>
							<tbody>	
								<tr>
									<th scope="row">시지원금</th>
									<td id="support_fund"></td> 
								</tr>								   								    															       
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
						<h4 class="sub_title_h4">연구비 상세 정보</h4>	
						<table class="write fixed money_detail list money_span">
							<caption>연구비 정보</caption>
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
						<h4 class="sub_title_h4">정산서류</h4>
						<table class="write fixed">
							<caption>정산서류</caption> 
							<colgroup>
							    <col style="width: 20%">
							    <col style="width: 80%">
							</colgroup>
							<tbody>		
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
							</tbody>
						</table>
						<!--//정산서류-->

						<div class="button_box clearfix fr pb20">
							<button type="button" class="gray_btn fl" onclick="location.href='/member/fwd/calculation/main'">목록</button>
						</div>
					</div>	<!--//table_area-->							
				</div><!--//content_area-->
				<!--//기관-->
			</div>
		</div><!--//sub_contents-->
	</section>
</div>
<!-- //container -->


<!--제출하기 팝업-->
<div class="agreement_send_popup_box">		
	<div class="popup_bg"></div>
	<div class="agreement_send_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">제출 안내</h4>							
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">						
			<div class="popup_titlebox_txt">
				<p><span class="font_blue">[예]</span> 버튼을 누르면 제출이 완료되며, 수정은 불가능합니다.</p>							
				<p>제출 완료 후에는 제출완료 상태이며, 담당자가 제출서류를 확인하여 이상이 없을 경우, <br />
					완료될 예정입니다.</p>
				<p class="font_blue fz_b"><span class="fw500 font_blue">제출하시겠습니까?</span></p>
			</div>
		    <div class="popup_button_area_center">
				<button type="submit" class="blue_btn mr5" onclick="onSubmitExecution();">예</button>
				<button type="button" class="gray_btn lastClose layerClose popup_close_btn">아니요</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//제출하기 팝업-->

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