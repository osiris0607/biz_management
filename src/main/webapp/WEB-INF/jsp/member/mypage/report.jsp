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
		searchList(1);
	});

	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/report/search/paging'/>");
		comAjax.setCallback(getSerarchListCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.addParam("search_text", $("#search_text").val());
		
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
		comAjax.ajax();
	}
	
	function getSerarchListCB(data){
		// 데이터가 없으면 Return
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();

		$("#search_count").html("[총 <span class='fw500 font_blue'>" + total + "</span>건]");
		if (total == 0) {
			var str = "<tr>" + "<td colspan='8'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#pageNavi").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
			gfnRenderPagingMain(params);
			
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>" + index + "</td>";
				var type = "";
				if ( value.reception_status == "D0000012") {
					type = "접수";
				}
				str += "	<td><span>" + type + "</span></td>";
				str += "	<td><span>" + value.reception_reg_number + "</span></td>";
				str += "	<td><span>" + value.announcement_business_name + "</span></td>";
				str += "	<td class='announcement_name'><span><a href='/member/fwd/mypage/reportDetail?reception_id=" + value.reception_id + "'>" + value.announcement_title + "</a></span></td>";
				str += "	<td><span>" + value.researcher_institution_name + "</span></td>";
				str += "	<td><span>" + value.researcher_name + "</span></td>";
				str += "	<td class='last'><span></span></td>";
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

<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area clearfix">
				<h3 class="hidden">기관정보관리</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>마이페이지</li>
						<li>기관정보관리</li>
					</ul>
				</div>
				<div id="lnb" class="fl">
					<!-- lnb_area -->	
					<div class="lnb_area">
						<!-- lnb_title_area -->	
						<div class="lnb_title_area">
							<h2 class="title">마이페이지</h2>
						</div>
						<!--// lnb_title_area -->
						<!-- lnb_menu_area -->
						<div class="lnb_menu_area">
							<!-- lnb_menu -->	
							<ul class="lnb_menu">
								<li>
									<a href="/member/fwd/mypage/institution" title="기관정보관리"><span>기관정보관리</span></a>									
								</li>
								<li>
									<a href="/member/fwd/mypage/main" title="개인정보관리 페이지로 이동"><span>개인정보관리</span></a>									
								</li>
								<sec:authorize access="hasAnyRole('ROLE_EXPERT', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/expert" title="전문가 참여 현황" ><span>전문가 참여 현황</span></a>				
									</li>
								</sec:authorize>
								<sec:authorize access="hasAnyRole('ROLE_COMMISSIONER', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/commissioner" title="평가위원정보관리" ><span>평가위원 정보 관리</span></a>				
									</li>
								</sec:authorize>
								<li>
									<a href="/member/fwd/mypage/report" title="나의 수행과제 현황 관리 페이지로 이동" class="active"><span>나의 수행과제 현황 관리</span></a>									
								</li>
							</ul>
							<!--// lnb_menu -->
						</div><!--//lnb_menu_area-->
					</div><!--//lnb_area-->
				</div>
				<!--//lnb-->
				<div class="sub_right_contents fl">
					<h3>나의 수행과제 현황 관리</h3>								
				
					<div class="search_area mt50">
						<dl class="search_box">
							<dt class="hidden">검색대상</dt>
							<dd class="box">
								<label for="report_type_selector" class="hidden">검색 구분</label>
								<select id="report_type_selector" class="selectbox1 fl ace-select">
									<option value="접수">접수</option>
									<option value="수행">수행</option>
									<option value="종료">종료</option>
								</select>
								<div class="input_search_box fl w82">
									<label for="search_text" class="hidden">검색어 입력</label>
									<input id="search_text" class="w80 fl ml10" name="input_txt" type="text" placeholder="검색어를 입력하세요." />
									<div class="fr clearfix">
										<button type="button" class="search_txt_del fl" title="검색어 삭제" onclick="$('#search_text').val('');"><img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼"></button>	
										<button type="button" class="serch_btn blue_btn fl mr20" title="검색" onclick="searchList(1);">검색</button>	
									</div>	
								</div>
							</dd>
						</dl>							
					</div>
					<div class="table_area">
						<table class="list fixed">
							<caption>나의 접수 과제 목록</caption>
							<colgroup>
								<col style="width: 5%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 25%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 20%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="first">번호</th>
									<th scope="col">구분</th>
									<th scope="col">접수번호</th>
									<th scope="col">사업명</th>
									<th scope="col">공고명</th>
									<th scope="col">기관명</th>
									<th scope="col">연구책임자</th>
									<th scope="col" class="last">연구기간</th>
								</tr>
							</thead>
							<tbody id="list_body">
							</tbody>
						</table>
						<!-- Pagenation -->
					   	<input type="hidden" id="pageIndex" name="pageIndex"/>
						<div class="paging_area" id="pageNavi"></div>
					</div><!--//table_area-->						
				</div><!--//sub_right_contents-->
			</div><!--//content_area-->
		</div><!--//sub_contents-->
	</section><!--//content-->
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
