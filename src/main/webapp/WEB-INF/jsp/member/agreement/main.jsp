<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	$(document).ready(function() {
		// 형약 목록 조회
		searchList(1); 
	});

	/*******************************************************************************
	* 협약 목록 조회
	*******************************************************************************/
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/agreement/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE");
		
		// 아이디에 해당하는 협약만 추출
		comAjax.addParam("member_id", "${member_id}");
		// 공고 종류
		comAjax.addParam("announcement_type", $("#announcement_type_selector").val());
		// 상태
		comAjax.addParam("agreement_status", $("#agreement_status_selector").val());
		// 검색어
		comAjax.addParam("search_text", $("#search_text").val());
		
		comAjax.ajax();
	}
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='14'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};

			gfnRenderPagingMain(params);
			
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			var managerList = [];
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>"+ index + "</td>";
				str += "	<td><span>"+ value.reception_reg_number + "</span></td>";
				str += "	<td><span>"+ value.agreement_reg_number + "</span></td>";
				str += "	<td><span>"+ value.announcement_business_name + "</span></td>";
				str += "	<td><span>"+ value.announcement_title + "</span></td>";
				str += "	<td><a href='javascript:void(0)' onclick='onMoveView(\"" + value.agreement_id + "\");'><span>"+ value.tech_info_name + "</span></a></td>";
				str += "	<td><span>"+ value.institution_name + "</span></td>";
				str += "	<td><span>"+ value.researcher_name + "</span></td>";
				str += "	<td><span></span></td>";
				str += "	<td><span></span></td>";
				if (value.agreement_status == "D0000005") {  // 협약 완료
					str += "	<td><span class='font_blue'>"+ value.agreement_status_name + "</span></td>";
				} else if (value.agreement_status == "D0000004") { // 제출 완료
					str += "	<td><span>"+ value.agreement_status_name + "</span></td>";
				} else if (value.agreement_status == "D0000003") { // 미제출 (재출불필요)
					str += "	<td><span>"+ value.agreement_status_name + "</span></td>";
				} 
				else {
					str += "	<td><span>" + value.agreement_status_name + "</span><button type='button' class='blue_btn' onclick='onMoveDetail(\"" + value.agreement_id + "\");'>제출하기</button></td>";
					
					
				}
				str += "</tr>";
				index++;
			});
			body.append(str);
		}
	}

	/*******************************************************************************
	* 상세 페이지 이동
	*******************************************************************************/
	function onMoveDetail(id) {
		location.href = "/member/fwd/agreement/search/detail?agreement_id=" + id;
	}

	/*******************************************************************************
	* 완료 페이지 이동
	*******************************************************************************/
	function onMoveView(id) {
		location.href = "/member/fwd/agreement/search/view?agreement_id=" + id;
	}

	/*******************************************************************************
	* 검색어 입력 초기화
	*******************************************************************************/
	function initSearchText() {
		$("#search_text").val("");
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
            
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>협약</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>협약</li>
						<li>협약</li>
					</ul>
				</div>
				<div class="content_area">	
					<div class="agreement_list_page">
						<div class="agreement_list_top_info_txt_area">
							<ol>
								<li>1. 협약을 위해 계획서 및 협약내용에 대한 <span class="fw_b">최종 검토</span>가 필요합니다.</li>
								<li>2. 과제를 검색하여, 해당하는 과제의 협약을 위한 상세페이지를 확인할 수 있습니다. </li>
							</ol>
						</div>
						<div class="search_area">
							<dl class="search_box">
								<dt class="hidden">검색대상</dt>
								<dd class="box">
									<label for="announcement_type_selector" class="hidden">사업명</label>
									<select name="announcement_type_selector" id="announcement_type_selector" class="ace-select fl w_18 mr5">
									   <option value="">전체</option>
									   <option value="D0000005">기술매칭</option>
									   <option value="D0000003">기술공모</option>
									   <option value="D0000004">기술제안</option>
								    </select>
									<label for="agreement_status_selector" class="hidden">상태</label>
									<select name="agreement_status_selector" id="agreement_status_selector" class="ace-select fl w_18 mr5">
									   <option value="">전체</option>
									   <option value="D0000002">미제출</option>
									   <option value="D0000004">제출완료</option>
									   <option value="D0000005">협약완료</option>
								    </select>
									<div class="input_search_box fl in_w67">
										<label for="search_text" class="hidden">검색어 입력</label>
										<input id="search_text" class="in_w80 fl ml10" name="input_txt" type="text" value="" placeholder="검색어를 입력하세요.">
										<div class="fr clearfix">
											<button type="button" onclick="initSearchText();" class="search_txt_del fl" title="검색어 삭제"><img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼"></button>	
											<button type="button" onclick="searchList(1);" class="serch_btn blue_btn fl mr20" title="검색">검색</button>	
										</div>	
									</div>
								</dd>
							</dl>							
						</div><!--//search_area-->
	
	
						<h4>협약 과제</h4>
						<p class="receptionmylist_txt"><span class="necessary_icon">*</span>협약 서류 미제출 과제는 제출해 주시기 바랍니다.</p>
						<div class="table_count_area">
							<div class="count_area" id="search_count">
							</div>
						</div>
						
						<div class="table_area">
							<table class="list th_c agreement_list_table">
						       <caption>협약 과제</caption>     
						       <colgroup>
									<col style="width: 5%;">
									<col style="width: 9%;">
									<col style="width: 9%;">
									<col style="width: 9%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
									<col style="width: 9%;">
									<col style="width: 9%;">
									<col style="width: 9%;">
									<col style="width: 11%;">
									<col style="width: 10%;">
							   </colgroup>
						       <thead>
							       <tr>
								       <th scope="col">번호</th>
								       <th scope="col">접수번호</th>
								       <th scope="col">과제번호</th>
									   <th scope="col">사업명</th>
								       <th scope="col">공고명</th>
								       <th scope="col">기술명</th>
								       <th scope="col">연구기관</th>
								       <th scope="col">연구책임자</th>
								       <th scope="col">연구기간</th>
								       <th scope="col">연구비</th>
								       <th scope="col">상태</th>
							       </tr>
						       </thead>
						       <tbody id="list_body">
							   </tbody>
							</table>
						</div>
						<input type="hidden" id="pageIndex" name="pageIndex"/>
						<div class="paging_area" id="pageNavi">
						</div>
					
	
					</div><!--//agreement_list_page-->
					
				</div>
			</div>
		</div>
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
