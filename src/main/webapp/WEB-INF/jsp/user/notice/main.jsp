<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	$(document).ready(function() {
		searchList(1);
	});
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/user/api/notice/search/paging' />");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");

		if ( gfn_isNull($("#search_selector").val()) == false) {
			comAjax.addParam($("#search_selector").val(), $("#search_text").val() );
		}

		comAjax.ajax();
	}
	
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
		var body = $("#list_body");
		body.empty();
		
		if (total == 0) {
			var str = "<tr>" + "<td colspan='4'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
			gfnRenderPagingReception(params);

			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>" + index + "</td>";
				str += "	<td class='announcement_name'><a href='/user/fwd/notice/detail?notice_id=" + value.notice_id + "'>"+ value.title + "</a></td>";
				str += "	<td>관리자</td>";
				str += "	<td>"+ value.reg_date +"</td>";
				str += "</tr>";
	
				index++;
			});
			body.append(str);
		}
	}

</script>
            
<!-- container -->
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>알림&middot;정보</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>알림·정보</li>
					</ul>
				</div>
				<div class="content_area">
					<h4>알림&middot;정보 목록</h4>
					<!--search_area-->
					<div class="search_area">
						<dl class="search_box">
							<dt class="hidden">검색대상</dt>
							<dd class="box">
								<label for="search_selector" class="hidden">제목</label>
								<select id="search_selector" class="in_wp150 fl ace-select ls">
								   <option value="">선택</option>
								   <option value="title">제목</option>
								   <option value="explanation">내용</option>
								   <option value="titleExplanation">제목+내용</option>												
								</select>											
								<div class="input_search_box fl w85">
									<label for="search_text" class="hidden">검색어 입력</label>
									<input id="search_text" class="in_w85 fl ml10" name="input_txt" type="text" value="" placeholder="검색어를 입력하세요." />
									<div class="fr clearfix">
										<button type="button" class="search_txt_del fl" title="검색어 삭제" onclick="$('#search_text').val('');">
											<img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼" />
										</button>	
										<button type="button" class="serch_btn blue_btn fl mr20" title="검색" onclick="searchList(1);">검색</button>	
									</div>	
								</div>
							</dd>
						</dl>							
					</div>
					<!--//search_area-->
					<!--table_count_area-->
					<div class="table_count_area">
						<div class="count_area" id="search_count"></div>
					</div>
					<!--//table_count_area-->
					<!--리스트시작-->							
					<div class="table_area">
						<table class="list fixed">
							<caption>알림·정보 목록</caption>
							<colgroup>
								<col style="width: 5%;">											
								<col style="width: 80%;">
								<col style="width: 10%;">
								<col style="width: 10%;">											
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="first">번호</th>
									<th scope="col">제목</th>
									<th scope="col">글쓴이</th>											
									<th scope="col" class="last">등록일</th>
								</tr>
							</thead>
							<tbody id="list_body"></tbody>
						</table>
					 		
				 		<!--페이지 네비게이션-->
					   	<input type="hidden" id="pageIndex" name="pageIndex"/>
					   	<div class="paging_area" id="pageNavi"></div>  
						<!--//페이지 네비게이션-->
					</div>							
					<!--//리스트end-->
				</div>
			</div>
		</div>
	</section>
</div>
