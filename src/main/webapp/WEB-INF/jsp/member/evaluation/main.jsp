<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	$(document).ready(function() {
		// 검색 연도 세팅
		initYear();
		// 평가 목록
		searchList(1); 
	});

	function initYear() {
		var date = new Date();
		var year = date.getFullYear();

		getYear(year);
	}

	function getYear(year) {
		$("#search_year_selector option").remove();

		var stY = Number(year) - 10;
		var enY = Number(year);

		var str = "<option value='' selected>년 선택</option>";
		for (var y=enY; y>=stY ; y--) {
			str += "<option value='" + y + "'>" + y + "년</option>";
		}
		$("#search_year_selector").append(str);
	}
	
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/evaluation/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "EVALUATION_REG_NUMBER");
		
		// 아이디에 해당하는 평가만 추출
		comAjax.addParam("member_id", "${member_id}");
		// 평가 완료된 평가목록만 추출 
		var statusList = new Array();
		statusList.push("D0000005");
		comAjax.addParam("status_list", statusList);
		// 평가구분
		var classificationList = new Array();
		classificationList.push($("#evaluation_classification_selector").val());
		comAjax.addParam("classification_list", classificationList);
		// 년도
		if ( gfn_isNull($("#search_year_selector").val()) == false ) {
			var fromDate = $("#search_year_selector").val() + "0101";
			var toDate = $("#search_year_selector").val() + "1231"; 

			comAjax.addParam("evaluation_from", fromDate);
			comAjax.addParam("evaluation_to", toDate);
		}
		// 검색어
		comAjax.addParam("search_text", $("#search_text").val());
		
		comAjax.ajax();
	}

	var evaluationNumberList = new Array();
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
				str += "	<td><span>"+ value.classification_name + "</span></td>";
				str += "	<td><span>"+ value.type_name + "</span></td>";
				str += "	<td><span>"+ value.reception_reg_number + "</span></td>";
				str += "	<td><span>"+ value.agreement_reg_number + "</span></td>";
				str += "	<td><span>"+ value.evaluation_reg_number + "</span></td>";
				str += "	<td><span>"+ value.announcement_business_name + "</span></td>";
				str += "	<td><span>"+ value.announcement_title + "</span></td>";
				str += "	<td><span>"+ value.tech_info_name + "</span></td>";
				str += "	<td><span>"+ value.institution_name + "</span></td>";
				str += "	<td><span>"+ value.steward + "</span></td>";
				str += "	<td class='ls'>"+ value.evaluation_date + "</span></td>";
				if (value.result == "D0000001") {
					str += "<td class='last'><a href='/member/fwd/evaluation/search/detail?evaluation_id=" + value.evaluation_id + "' class='font_blue'>적합</a></td></td>";
				} else {
					str += "<td class='last'><a href='/member/fwd/evaluation/search/detail?evaluation_id=" + value.evaluation_id + "' class='font_red'>부적합</a></td></td>";
				}
				str += "</tr>";
				index++;
			});
			body.append(str);
		}
	}

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
							<h3>평가</h3>
							<div class="route hidden">
								<ul class="clearfix">
									<li><i class="fas fa-home">홈</i></li>
									<li>평가</li>
									<li>평가</li>
								</ul>
							</div>
							<div class="content_area">
								<h4>평가 과제 목록</h4>
								<!--search_area-->
								<div class="search_area">
									<dl class="search_box">
										<dt class="hidden">검색대상</dt>
										<dd class="box agreement_selectbox">
											<label for="evaluation_classification_selector" class="hidden">검색구분</label>
											<select id="evaluation_classification_selector" class="selectbox1 fl ace-select w8" name="select_agreement">	
												<option value="">전체</option>
												<option value="D0000001">선정평가</option>
												<option value="D0000002">중간평가</option>
												<option value="D0000003">최종평가</option>
											</select>
											<label for="agreement_category2" class="hidden">2depth</label>
											<select id="agreement_category2" class="selectbox1 fl ace-select w8" name="agreement_category2">						
												<option>전체</option>
											</select>
											<label for="search_year_selector" class="hidden">3depth</label>
											<select id="search_year_selector" class="selectbox1 fl ace-select w5">
											</select>
											<div class="input_search_box fl w49">
												<label for="search_text" class="hidden">검색어 입력</label>
												<input id="search_text" class="in_w75 fl ml10" name="input_txt" type="text" placeholder="키워드를 입력하여 평가과제를 검색하실 수 있습니다." />
												<div class="fr clearfix">
													<button type="button" onclick="initSearchText();" class="search_txt_del fl" title="검색어 삭제"><img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼" /></button>	
													<button type="button" onclick="searchList(1);" class="serch_btn blue_btn fl mr20" title="검색">검색</button>	
												</div>	
											</div>
										</dd>
									</dl>							
								</div>
								<!--//search_area-->

								<!--table_count_area-->
								<div class="table_count_area">
									<div class="count_area" id="search_count">
										[총 <span class="fw500 font_blue">0</span>건]
									</div>
								</div>
								<!--//table_count_area-->
								
								<!--리스트시작-->							
								<div class="table_area">
									<table class="list fixed agreement_table">										
										<caption>평가 과제 목록</caption>
										<colgroup>
											<col style="width: 5%;">
											<col style="width: 6%;">
											<col style="width: 6%;">
											<col style="width: 7%;">
											<col style="width: 7%;">
											<col style="width: 9%;">
											<col style="width: 8%;">
											<col style="width: 10%;">
											<col style="width: 10%;">
											<col style="width: 8%;">
											<col style="width: 7%;">
											<col style="width: 8%;">
											<col style="width: 9%;">
										</colgroup>
										<thead>
											<tr>
												<th scope="col" class="first">번호</th>
												<th scope="col">평가구분</th>
												<th scope="col">평가유형</th>
												<th scope="col">접수번호</th>
												<th scope="col">과제번호</th>
												<th scope="col">평가번호</th>
												<th scope="col">사업명</th>
												<th scope="col">공고명</th>
												<th scope="col">기술명</th>
												<th scope="col">기관명<br />(개인명)</th>
												<th scope="col">담당간사명</th>
												<th scope="col">평가일자</th>
												<th scope="col" class="last">평가결과</th>
											</tr>
										</thead>
										<tbody id="list_body">
										</tbody>
									</table>
									
									<!--페이지 네비게이션-->
								    <input type="hidden" id="pageIndex" name="pageIndex"/>
								   	<div class="paging_area" id="pageNavi"></div>  
								    <!--//페이지 네비게이션-->								
						    	</div>							
							</div>
						</div>
					</div>
				</section>
			</div>
<!--//container-->


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
