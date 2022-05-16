<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	$(document).ready(function() {
		// 수행 목록
		searchList(1); 
	});

	/*******************************************************************************
	* FUNCTION 명 : searchList
	* FUNCTION 기능설명 : 협약 정보 리스트를 가져온다.
	*******************************************************************************/
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/calculation/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE");

		// 아이디
		comAjax.addParam("member_id", "${member_id}");
		// 연구 기간
		comAjax.addParam("research_date", $("#research_date").val());
		// 상태
		comAjax.addParam("execution_status", $("#execution_status_selector").val());
		// 검색어
		comAjax.addParam($("#compute_search_selector").val(), $("#search_text").val());
		
		comAjax.ajax();
	}
	function searchListCB(data) {
		console.log(data);
		var total = data.result_data.length;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='10'>조회된 결과가 없습니다.</td>" + "</tr>";
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
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>"+ index + "</td>";
				str += "	<td><span>"+ value.agreement_reg_number + "</span></td>";
				str += "	<td><span>"+ value.announcement_business_name + "</span></td>";
				str += "	<td><span>"+ value.announcement_title + "</span></td>";
				str += "	<td><span>"+ value.tech_info_name + "</span></td>";
				str += "	<td><span>"+ value.institution_name + "</span></td>";
				str += "	<td><span>"+ value.researcher_name + "</span></td>";
				str += "	<td><span>" + value.research_date + "</span></td>";
				str += "	<td><span>" + value.research_funds + "</span></td>";

				if ( value.calculation_status == "미정산") {
					str += "<td><span>" + value.calculation_status + "</span></td>";
				}else if ( value.calculation_status == "정산 입력") { 
					str += "<td><button type='button' class='blue_btn' onclick='onMoveDetail(\"" + value.calculation_id + "\");'>정산 입력</button></td>";

				}
				else if ( value.calculation_status == "제출완료") {
					str += "<td><span>" + value.calculation_status + "</span></td>";
				} else {
					str += "<td><a href='javascript:void(0);' onclick='onMoveDetailView(\"" + value.calculation_id + "\");'><span class='font_blue'>" + value.calculation_status + "</span></a></td>";
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
		location.href="/member/fwd/calculation/search/detail?calculation_id=" + id;
		
	}

	function onMoveDetailView(id) {
		location.href="/member/fwd/calculation/search/view?calculation_id=" + id;
	}
	
	

	/*******************************************************************************
	* 검색어 입력 초기화
	*******************************************************************************/
	function initSearchText() {
		$("#search_text").val("");
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
				<div class="content_area">						
					<div class="agreement_list_page">
						<div class="execute_list_top_info_txt_area">
							<ol>
								<li>수행중인 과제 중 <span class="fw_b">연구비 사용내용</span>을 입력합니다. </li>
							</ol>
						</div>
						<div class="search_area">
							<dl class="search_box">
								<dt class="hidden">검색대상</dt>
								<dd class="box">												
									<div class="datepicker_area fl">
										<label for="research_date">연구기간</label>
										<input type="text" id="research_date" class="datepicker form-control w_12 ls mr5" />
									</div>
									<label for="execution_status_selector" class="hidden">수행 선택</label>
									<select name="execution_status" id="execution_status_selector" class="ace-select fl w_18">				   
									   <option value="">전체</option>
									   <option value="수행중">수행중</option>
									   <option value="수행완료">수행완료</option>
								    </select>
								    <label for="compute_search_selector" class="hidden">분류 선택</label>
									<select name="compute_search_select" id="compute_search_selector" class="ace-select fl w_18">				   
									   <option value="">전체</option>
									   <option value="announcement_title">공고명</option>
									   <option value="tech_info_name">기술명</option>
									   <option value="institution_name">연구기관</option>
									   <option value="agreement_reg_number">과제번호</option>
									</select>	
									<div class="input_search_box fl w43">													
										<label for="search_text" class="hidden">검색어 입력</label>
										<input id="search_text" class="w70 fl ml10" name="input_txt" type="text" value="" placeholder="검색어를 입력하세요.">
										<div class="fr clearfix">
											<button type="button" class="search_txt_del fl" title="검색어 삭제" onclick="initSearchText();"><img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼"></button>	
											<button type="submit" class="serch_btn blue_btn fl mr20" title="검색" onclick="searchList(1);">검색</button>	
										</div>	
									</div>
								</dd>
							</dl>							
						</div><!--//search_area-->


						<h4>연구비 정산</h4>									
						<div class="table_count_area">
							<div class="count_area" id="search_count">
								[총 <span class="fw500 font_blue">0</span>건]
							</div>
						</div>
						
						<div class="table_area">
							<table class="list th_c compute_list_table">
						       <caption>연구비 정산</caption>     
						       <colgroup>
									<col style="width: 5%;">
									<col style="width: 7%;">
									<col style="width: 7%;">
									<col style="width: 14%;">
									<col style="width: 14%;">
									<col style="width: 10%;">
									<col style="width: 8%;">
									<col style="width: 15%;">
									<col style="width: 10%;">
									<col style="width: 10%;">
							   </colgroup>
						       <thead>
							       <tr>
								       <th scope="col">번호</th>
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
					</div>							

				</div>
			</div>
		</div>
	</section>
</div>
<!-- //container -->
