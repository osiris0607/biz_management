<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var isModification = false;
	
	$(document).ready(function() {
		searchMemberDetail();
	 	searchEvaluationList(1);
	 	searchCommissionerDetail();
	});

	function searchMemberDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/mypage/detail");
		comAjax.setCallback(getMemberDetailCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.ajax();
	}

	function getMemberDetailCB(data){
		$("#name").html("<span>" + data.result.name + "</span>") ;
		$("#mobile_phone").html(data.result.mobile_phone) ;
		$("#email").html(data.result.email) ;
		$("#address").html(data.result.address + " " + data.result.address_detail) ;
	}

	function searchCommissionerDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/commissioner/api/evaluation/commissioner/detail'/>");
		comAjax.setCallback(searchCommissionerDetailCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.ajax();
	}

	function searchCommissionerDetailCB(data){
		console.log(data);
		$("#bank_name").val(data.result_data.bank_name) ;
		$("#bank_number").val(data.result_data.bank_account) ;
	}
	

	function searchEvaluationList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/commissioner/api/evaluation/search/paging'/>");
		comAjax.addParam("member_id", "${member_id}");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("page_row_count", "20");
		comAjax.setCallback(searchEvaluationListCB);
		comAjax.ajax();
	}
	
	function searchEvaluationListCB(data){
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='11'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchEvaluationList"
				};
	
			gfnRenderPaging(params);
			
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>" + index+ "</td>";
				str += "	<td><span>" + value.announcement_type_name + "</span></td>";
				str += "	<td class='announcement_name'><span>" + value.announcement_title + "</span></td>";
				str += "	<td><span>" + value.type_name + "</span></td>";
				str += "	<td><span>" + value.steward_department + "</span></td>";
				str += "	<td><span>" + value.steward + "</span></td>";
				str += "	<td><span>" + value.evaluation_date + "</span></td>";
				str += "	<td><span>" + value.evaluation_date + "</span></td>";
				str += "<td><span class='font_blue'>작성완료</span></td>";
				str += "<td><span class='font_blue'>작성완료</span></td>";

				if (value.chairman_yn == "Y") {
					if ( value.evaluation_report_yn == "Y" && value.chairman_submit_yn == "Y") {
						str += "<td><span class='font_blue'>평가완료</span></td>";
					} else {
						str += "<td class='last'><button type='button' class='blue_btn' onclick='location.href=\"/manager/fwd/evaluation/estimation?evaluation_id=" + value.evaluation_id + "\"'>평가 시작</button></td>";
					}
				} else {
					if ( value.evaluation_report_yn == "Y" ) {
						str += "<td><span class='font_blue'>평가완료</span></td>";
					} else {
						str += "<td class='last'><button type='button' class='blue_btn' onclick='location.href=\"/manager/fwd/evaluation/estimation?evaluation_id=" + value.evaluation_id + "\"'>평가 시작</button></td>";
					}
				}
				
				str += "</tr>";
				index++;
			});
			body.append(str);
		}
	}

	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
		if ( isModification == true) {
			location.reload();
		}
	}

</script>

<!-- container -->
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
		<section id="content" class="est-sub">
			<div id="sub_contents">
		    	<div class="content_area">
					<h3>평가위원 전자평가</h3>
					<div class="route hidden">
						<ul class="clearfix">
							<li><i class="fas fa-home">홈</i></li>
							<li>평가위원 전자평가</li>
							<li>평가위원 전자평가</li>
						</ul>
					</div>
					<div class="content_area">
						<h4>평가 안내</h4>
						<!--안내글-->
						<div class="announcement_index_infotxt">
							<ul>
								<li><a href="" download><span class="fw_b">평가 매뉴얼</span></a>을 확인해 주세요.</li>
								<li>평가 시작 전 <span class="fw_b">보안서약서</span>와 <span class="fw_b">지급청구서</span>를 작성하시기 바랍니다. </li>
								<li><span class="blue_btn">평가 시작</span> 버튼을 클릭할 경우, 평가가 끝나기 전까지 화면 전환이 불가하며, 제출된 평가서는 수정이 불가합니다.</li>
							</ul>
							<a href="" title="평가메뉴얼" class="blue_btn manual" download>평가 메뉴얼 확인하기</a>
						</div>
						<!--안내글-->
								
						<h4>평가 과제 목록</h4>
						<!--table_count_area-->
						<div class="table_count_area">
							<div class="count_area" id="search_count">
								[총 <span class="fw500 font_blue">0</span>건]
							</div>
						</div>
						<!--//table_count_area-->
						<!--리스트시작-->							
						<div class="table_area">
							<table class="list fixed announcement_index_table">
								<caption>공고 목록</caption>
								<colgroup>
									<col style="width:5%" />
									<col style="width:7%" />
									<col style="width:22%" />
									<col style="width:7%" />
									<col style="width:10%" />
									<col style="width:7%" />
									<col style="width:9%" />
									<col style="width:9%" />
									<col style="width:7%" />
									<col style="width:7%" />
									<col style="width:10%" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col" class="first">번호</th>
										<th scope="col">사업명</th>
										<th scope="col">공고명</th>
										<th scope="col">평가구분</th>
										<th scope="col">담당간사 부서명</th>
										<th scope="col">담당 간사명</th>
										<th scope="col">평가 시작일</th>
										<th scope="col">평가 종료일</th>
										<th scope="col">보안 서약서</th>
										<th scope="col">지급 서약서</th>
										<th scope="col" class="last">평가</th>
									</tr>
								</thead>
								<tbody id="list_body">
								</tbody>
							</table>
							<!-- Pagination -->
						   	<input type="hidden" id="pageIndex" name="pageIndex"/>
							<div class="paging_area" id="pageNavi"></div>
							<!-- Pagination -->
						</div>							
					</div>
				</div>
			</div>
	</section>
</div>
 



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
				<button type="button" class="blue_btn popup_close_btn" title="확인" onclick="commonPopupConfirm();">확인</button>
			</div>
		</div>						
	</div> 
</div>
