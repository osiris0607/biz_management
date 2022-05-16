<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	$(document).ready(function() {
		// 평가 목록
		searchDetail(); 
	});

	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/evaluation/search/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("evaluation_id", "${vo.evaluation_id}");
		comAjax.ajax();
	}

	function searchDetailCB(data) {
		console.log(data);
		var body = $("#list_body");
		body.empty();
		
		$("#classification").html("<span>" + data.result_data.classification_name + "</span>");
		$("#type").html("<span>" + data.result_data.type_name + "</span>");
		$("#evaluation_date").html("<span>" + data.result_data.evaluation_date + "</span>");
		$("#result").html("<span>" + data.result_data.result_name + "</span>");
		$("#reception_reg_number").html("<span>" + data.result_data.reception_reg_number + "</span>");
		$("#agreement_reg_number").html("<span>" + data.result_data.agreement_reg_number + "</span>");
		$("#evaluation_reg_number").html("<span>" + data.result_data.evaluation_reg_number + "</span>");
		$("#announcement_business_name").html("<span>" + data.result_data.announcement_business_name + "</span>");
		$("#announcement_title").html("<span>" + data.result_data.announcement_title + "</span>");
		$("#tech_info_name").html("<span>" + data.result_data.tech_info_name + "</span>");
		$("#steward_department").html("<span>" + data.result_data.steward_department + "</span>");
		$("#steward").html("<span>" + data.result_data.steward + "</span>");
		$("#guide_file_name").html("<a href='/util/api/file/download/" + data.result_data.guide_file_id + "' download><span>" + data.result_data.guide_file_name + "</span></a>");
		$("#result_file_name").html("<a href='/util/api/file/download/" + data.result_data.result_file_id + "' download><span>" + data.result_data.result_file_name + "</span></a>");
		$("#complete_file_name").html("<a href='/util/api/file/download/" + data.result_data.complete_file_id + "' download><span>" + data.result_data.complete_file_name + "</span></a>");
	}


	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
		if ( isWithdrawalReception == true) {
			location.relaod();
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
				<h3>평가</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>평가</li>
						<li>평가</li>
					</ul>
				</div>							
				
				<div class="content_area copmpany_area" id="copmpany_area">													
					<div class="table_area">
						<h4>평가정보</h4>	
						<!--평가정보-->
						<table class="write fixed">
							<caption>평가정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">평가구분</th>
									<td id="classification"></td> 
								</tr>									  
								<tr>
									<th scope="row">평가유형</th>
									<td id="type"></td> 
								</tr>
								<tr>
									<th scope="row">평가일자</th>
									<td id="evaluation_date"></td> 
								</tr>
								<tr>
									<th scope="row">평가결과</th>
									<td id="result"></td> 
								</tr>
								<tr>
									<th scope="row">접수번호</th>
									<td id="reception_reg_number"></td> 
								</tr>
								<tr>
									<th scope="row">과제번호</th>
									<td id="agreement_reg_number"></td> 
								</tr>
								<tr>
									<th scope="row">평가번호</th>
									<td id="evaluation_reg_number"></td> 
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
									<th scope="row">담당간사 부서명</th>
									<td id="steward_department"></td>  
								</tr>
								<tr>
									<th scope="row">담당간사명</th>
									<td id="steward"></td>  
								</tr>
								<tr>
									<th scope="row">평가 안내 공문</th>
									<td id="guide_file_name"><a href="" download class="download_link">평가 안내 공문.pdf</a></td> 
								</tr>
								<tr>
									<th scope="row">평가 결과 공문</th>
									<td id="result_file_name"><a href="" download class="download_link">평가 결과 공문.pdf</a></td> 
								</tr>
								<tr>
									<th scope="row">종합평가서</th>
									<td id="complete_file_name"><a href="" download class="download_link">평가 결과 공문.pdf</a></td> 
								</tr>
							</tbody>
				        </table>
						<!--//평가정보-->								    
						<div class="button_box clearfix fr pb20">
							<button type="button" class="gray_btn" onclick="location.href='/member/fwd/evaluation/main'">목록</button>
						</div>
					</div>	<!--//table_area-->							
				</div><!--//content_area-->
				<!--//기관-->
			</div>
		</div><!--//sub_contents-->
	</section>
</div>
<!-- //container -->


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
