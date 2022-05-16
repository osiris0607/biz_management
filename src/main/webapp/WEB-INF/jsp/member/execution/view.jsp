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
		comAjax.setUrl("/member/api/execution/search/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("execution_id", "${vo.execution_id}");
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
			$("#research_funds").html("<span>0 (만원)</span>");
		} else {
			$("#research_funds").html("<span>" + data.result_data.research_funds + " (만원)</span>");
		}

		// 파일 이름
		$("#middle_report_file_name").text(data.result_data.middle_report_file_name);
		$("#middle_report_file_name").attr("file_id", data.result_data.middle_report_file_id);
		$("#final_report_file_name").text(data.result_data.final_report_file_name);
		$("#middle_report_file_name").attr("file_id", data.result_data.final_report_file_id);
		if ( data.result_data.return_upload_files != null) {
	    	uploaded_files = data.result_data.return_upload_files;
	    	$("#file_list").empty();
	    	for(var i=0; i<uploaded_files.length; i++) {
		    	$("#file_list").append("<li>" + uploaded_files[i].name + "<a href='javascript:void(0);' file_id='" + uploaded_files[i].file_id + "' onclick='downloadFile(this)'><span class='d_n'>파일</span></a></li>");
		    }
		}

		// 변경 이력
		var body = $("#changes_list_body");
		body.empty();
		var str = "<tr>";
		str += "		<th scope='col'>변경 완료일</th>";
		str += "		<th scope='col'>변경 내용</th>";
		str += "		<th scope='col'>변경 공문</th> ";
		str += "</tr>";
		
		if ( gfn_isNull(data.result_data.changes_list) || data.result_data.changes_list.length == 0 ) {
			str += "<tr>" + "<td colspan='3'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			$.each(data.result_data.changes_list, function(key, value) {
				str += "<tr>";
				str += "	<td>" + value.change_date + "</td>";
				str += "	<td>" + value.changes + "</td>";
				str += "	<td><a href='javascript:void(0);' file_id='" + value.official_notice_file_id + "' onclick='downloadFile(this)'>" + value.official_notice_file_name + "</a></td>";
				str += "</tr>";
			});
			body.append(str);
		}
	}

	function downloadFile(element) {
		var temp = $(element).attr("file_id");
		location.href = "/util/api/file/download/" + $(element).attr("file_id");
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
	    	location.href = "/member/fwd/agreement/main";
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
				<h3>수행</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>수행</li>
						<li>수행</li>
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
								    <th scope="row">연구기관/연구책임자</th>
								    <td id="research_info"></td> 
								</tr>
								<tr>
								    <th scope="row">연구기간</th>
								    <td id="research_date"></td> 
								</tr>
								<tr>
								    <th scope="row">연구비</th>
								    <td id="research_funds"><span class="fl mr5"></span><span class="fl">(만원)</span></td> 
								</tr>
							</tbody>
				        </table>
						<!--//과제 정보-->								    
						
						<!--과제 보고서-->									
						<h4 class="sub_title_h4">과제 보고서</h4>										
					    <table class="write fixed">
							<caption>과제 보고서</caption> 
							<colgroup>
							    <col style="width: 20%">
							    <col style="width: 80%">
							</colgroup>
							<tbody>		
							    <tr>
									<th scope="row">중간보고서</th>
									<td>										
										<div class="file_form_txt">	  
											<a href="javascript:void(0);" download id="middle_report_file_name" onclick='downloadFile(this)'></a>										
										</div>			
									</td> 
							    </tr>															       
							    <tr>
									<th scope="row">최종보고서</th>
									<td>										
										<div class="file_form_txt">
											<a href="javascript:void(0);" download id="final_report_file_name" onclick='downloadFile(this)'></a>												   
										</div>			
									</td>
							    </tr>
								<tr>
									<th scope="row">기타</th>
									<td>										
										<div class="file_form_txt">													   
											<ul id="file_list" style="clear:both"></ul>
										</div>	
									</td> 
								</tr>
							</tbody>
						</table>
						<!--//과제 보고서-->									
						
						<!--과제 변경 이력-->
						<h4>과제 변경 이력</h4>
						<table class="write fixed documentstory">
							<caption>제출서류</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 40%;">
								<col style="width: 40%;">
							</colgroup>
							<tbody id="changes_list_body">
							</tbody>
				        </table>
						<!--//과제 변경 이력-->
						
						<div class="button_box clearfix fr pb20">
							<button type="button" class="gray_btn fl" onclick="location.href='/member/fwd/execution/main'">목록</button>
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
				<button type="submit" class="blue_btn mr5 ok_btn">예</button>
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