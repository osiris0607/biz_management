<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>

	$(document).ready(function() {
		// 검색 연도 세팅
		initYear();
		// 검색		
		btn_searchList_onclick(1);
	});
	
	/*******************************************************************************
	* Content Paging 조회
	*******************************************************************************/
	function btn_searchList_onclick(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/user/api/announcement/search/paging' />");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "DATE DESC");


		// D0000005 : member 에서 공고를 볼때는 개시 / 개시 종료된 건만 보여져야 한다. 임의로 정한 코드이다.
		comAjax.addParam("process_status", "D0000005");
		comAjax.addParam("type", $("#search_select_b option:selected").val());
		comAjax.addParam("year", $("#search_select option:selected").val());
		comAjax.addParam("search_text", $("#search_text").val());
		
		comAjax.ajax();
	}
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='10'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "btn_searchList_onclick"
				};
			gfnRenderPaging(params);

			
			$("#search_count").html("[총 <span class='fw500 font_blue'>" + total + "</span>건]");
			var index = 1;
			var str = "";
			
			$.each(data.result, function(key, value) {
				// 작성중인 공고는 보여주지 않느다.
				if ( value.process_status == "D0000001" || value.process_status == "D0000002") {
					return false;
				}

				str += "<tr>";
				str += "	<td>" + index + "</td>";
				str += "	<td>"+ value.type_name + "</td>";
				str += "	<td><a href='/userHome/fwd/announcement/notice/businessDetail?announcement_id=" + value.announcement_id + "'><div class='txt_hidden'>" + value.title + "</div></a></td>";
				str += "	<td>"+ value.reg_date +"</td>";
				str += "	<td>"+ value.receipt_from + " ~ " + value.receipt_to +"</td>";

				// 개시중 = 접수중
				if ( value.process_status == "D0000003") {
					str += "	<td class='last'><span class='receipting'>접수중</span></td>	";
				}
				// 개시종료 = 접수 마감
				else {
					str += "	<td class='last'><span class='receiptend'>접수 마감</span></td>	";
				}
				str += "</tr>";
				index++;
			});
			body.append(str);
		}
	}

	/*******************************************************************************
	* 날짜 세팅
	*******************************************************************************/
	function initYear() {
		var date = new Date();
		var year = date.getFullYear();

		getYear(year);
	}

	function getYear(year) {
		$("#search_select option").remove();

		var stY = Number(year) - 10;
		var enY = Number(year);

		var str = "<option value='' selected>년 선택</option>";
		for (var y=enY; y>=stY ; y--) {
			str += "<option value='" + y + "'>" + y + "년</option>";
		}
		$("#search_select").append(str);
	}

</script>



<section>	
	<h2 class="hidden">서브영역</h2>
	<!-- 서브 경로 -->
	<article class="sub_route">
		<h3 class="hidden">서브경로</h3>
		<div class="wrap_area">
			<ul>
				<li><a href="/" class="home"><i class="fas fa-home"></i><span class="hidden">홈</span></a></li>
				<li><a href="/userHome/fwd/announcement/notice/noticeMain">알림&middot;홍보</a></li>
				<li><a href="/userHome/fwd/announcement/notice/noticeMain">공지사항</a></li>
				<li><a href="/userHome/fwd/announcement/notice/businessMain">사업공고</a></li>
			</ul>
		</div>
	</article>
	<!-- //서브 경로 -->
		
	<article class="contents">
		<div class="wrap_area clearfix">
			<!-- 서브 레프트메뉴 -->
			<div class="lnb" id="lnb">
				<h2 class="lnb_title">알림&middot;홍보</h2>
				<ul class="lnb_menu">
					<li class="on"><a href="/userHome/fwd/announcement/notice/noticeMain">공지사항</a></li>
					<li><a href="/userHome/fwd/announcement/broadcast/broadcastMain">보도자료</a></li>
				</ul>
			</div>
			<!-- //서브 레프트메뉴 -->
			
			<!-- 서브 컨텐츠 내용 -->
			<div class="sub_contents" id="sub_contents">
				<div class="statistics">
					<ul>
						<li><a href="/userHome/fwd/announcement/notice/noticeMain">공지사항</a></li>
						<li class="active"><a href="/userHome/fwd/announcement/notice/businessMain">사업공고</a></li>
					</ul>
				</div>
				<h2 class="sub_contents_title">사업공고</h2>
				<div class="board_businessnotice_area businessnotice_list_area">
					<div class="list_search_top_area">	
						<div class="board_list_searchbox">								
							<label for="search_select" class="hidden">검색년도</label>
							<select name="search_select" id="search_select" class="ace-select">
							</select>
							
							<label for="search_select_b" class="hidden">사업구분</label>
							<select name="search_select2" id="search_select_b" class="ace-select">
							   	<option value="">전체</option>
					          	<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.master_id == 'M0000005'}">
										<option value=<c:out value='${code.detail_id}'/>><c:out value='${code.name}'/></option>;
									</c:if>
								</c:forEach>
					  	 	</select>	
								
							<span class="input_search2 business_notice_search">
								<label for="search_text" class="fl list_search_title hidden">검색어</label>
								<input type="text" id="search_text" class="form-control" />   
								<button type="button" onclick="$('#search_text').val('');" class="search_txt_del" title="검색어 삭제"><i class="fas fa-times"></i></button>
							</span>
							<button type="button" onclick="btn_searchList_onclick(1);" class="blue_btn2">조회</button>							
						</div>
					</div>	
					
					<!-- list 검색 결과 -->
					<div class="list_search_table">
						<div class="table_count_area">
							<div class="count_area clearfix mb10">
								<div class="fl mt20" id="search_count">								   
								[총 <span class="font_blue">0</span>건]
								</div>								
							</div>
						</div>

						<div class="list_tablex business_table_area">									
							<table class="list business_table">
								<caption>공고 목록</caption>
								<colgroup>
									<col style="width: 8%;">
									<col style="width: 18%;">
									<col style="width: 28%;">
									<col style="width: 13%;">
									<col style="width: 20%;">
									<col style="width: 13%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">사업명</th>
										<th scope="col">공고명</th>
										<th scope="col">공고일</th>
										<th scope="col">접수기간</th>
										<th scope="col">상태</th>
									</tr>
								</thead>
								<tbody id="list_body">
								</tbody>
							</table>
						</div>
						<!--//검색 결과--> 							
							
						<!--페이지 네비게이션-->
					   	<input type="hidden" id="pageIndex" name="pageIndex"/>
					   	<div class="page" id="pageNavi"></div>  
					    <!--//페이지 네비게이션-->				
					</div>
					<!-- //list 검색 결과 -->
				</div>
			</div>
			<!-- //서브 컨텐츠 내용 -->
		</div>
	</article>
</section>