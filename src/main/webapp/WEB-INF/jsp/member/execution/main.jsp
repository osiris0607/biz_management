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
		comAjax.setUrl("/member/api/execution/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE");

		// 아이디
		comAjax.addParam("member_id", "${member_id}");
		// 연구 기관
		comAjax.addParam("research_date", $("#research_date").val());
		// 상태
		comAjax.addParam("execution_status", $("#execution_status_selector").val());
		// 검색어
		comAjax.addParam("search_text", $("#search_text").val());
		
		comAjax.ajax();
	}
	function searchListCB(data) {
		console.log(data);
		var total = data.result_data.length;
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
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>"+ index + "</td>";
				str += "	<td><span>"+ value.reception_reg_number + "</span></td>";
				str += "	<td><span>"+ value.agreement_reg_number + "</span></td>";
				str += "	<td><span>"+ value.announcement_business_name + "</span></td>";
				str += "	<td><span>"+ value.announcement_title + "</span></td>";
				str += "	<td><a href='javascript:void(0);' class='long_name' onclick='onMoveDetailView(\"" + value.execution_id + "\");'><span>"+ value.tech_info_name + "</span></a></td>";
				str += "	<td><span>"+ value.institution_name + "</span></td>";
				str += "	<td><span>"+ value.researcher_name + "</span></td>";
				str += "	<td><span>" + value.research_date + "</span></td>";
				str += "	<td><span>" + value.research_funds + "</span></td>";
				if ( gfn_isNull(value.middle_report_date) ) {
					str += "	<td><span>미제출</span><button type='button' class='blue_btn' onclick='onMoveDetail(\"" + value.execution_id + "\");'>제출하기</button></td>";
				} else {
					str += "	<td><span class='d_b font_blue'>제출완료</span></td>";
				}
				if ( gfn_isNull(value.final_report_date) ) {
					str += "	<td><span>미제출</span><button type='button' class='blue_btn' onclick='onMoveDetail(\"" + value.execution_id + "\");'>제출하기</button></td>";
				} else {
					str += "	<td><span class='d_b font_blue'>제출완료</span></td>";
				}

				str += "	<td><span>" + value.execution_status +"</span></td>";
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
		location.href="/member/fwd/execution/search/detail?execution_id=" + id;
	}

	function onMoveDetailView(id) {
		location.href="/member/fwd/execution/search/view?execution_id=" + id;
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
							<h3>수행</h3>
							<div class="route hidden">
								<ul class="clearfix">
									<li><i class="fas fa-home">홈</i></li>
									<li>수행</li>
									<li>수행</li>
								</ul>
							</div>
							<div class="content_area">						
								<div class="agreement_list_page">
									<div class="execute_list_top_info_txt_area">
										<ol>
											<li>1. 수행중인 과제 중, <span class="fw_b">중간보고서</span> 또는 <span class="fw_b">최종보고서</span>를 제출해주세요.</li>
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
												<select name="execution_status_selector" id="execution_status_selector" class="ace-select fl w_18">				   
												   <option value="">전체</option>
												   <option value="수행중">수행중</option>
												   <option value="수행완료">수행완료</option>
											    </select>
												<div class="input_search_box fl w59">
													<label for="search_text" class="hidden">검색어 입력</label>
													<input id="search_text" class="in_w80 fl ml10" name="input_txt" type="text" value="" placeholder="검색어를 입력하세요.">
													<div class="fr clearfix">
														<button type="button" onclick="initSearchText();" class="search_txt_del fl" title="검색어 삭제"><img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼"></button>	
														<button type="submit" class="serch_btn blue_btn fl mr20" title="검색">검색</button>	
													</div>	
												</div>
											</dd>
										</dl>							
									</div><!--//search_area-->


									<h4>수행 과제</h4>									
									<div class="table_count_area">
										<div class="count_area" id="search_count">
											[총 <span class="fw500 font_blue">0</span>건]
										</div>
									</div>
									
									<div class="table_area">
										<table class="list th_c agreement_list_table">
									       <caption>수행 과제</caption>     
									       <colgroup>
												<col style="width: 4%;">
												<col style="width: 7%;">
												<col style="width: 7%;">
												<col style="width: 6%;">
												<col style="width: 10%;">
												<col style="width: 10%;">
												<col style="width: 7%;">
												<col style="width: 6%;">
												<col style="width: 8%;">
												<col style="width: 10%;">
												<col style="width: 9%;">
												<col style="width: 9%;">
												<col style="width: 7%;">
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
											       <th scope="col">중간보고서</th>
												   <th scope="col">최종보고서</th>
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
