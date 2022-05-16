<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	$(document).ready(function() {

		$("#lately_week").change(function(){
	        if($("#lately_week").is(":checked")){
			  	var fromDay = new Date();
			  	var year = fromDay.getFullYear();
				var month = (fromDay.getMonth() + 1);
				var day = fromDay.getDate();
				month = (month < 10) ? "0" + String(month) : month;
				day = (day < 10) ? "0" + String(day) : day;
			  	$("#receipt_from").val(year+"-"+month+"-"+day);

			  	var toDay = new Date();
			  	toDay.setDate(toDay.getDate()+7);
		  		year = toDay.getFullYear();
		  		month = (toDay.getMonth() + 1);
		  		day = toDay.getDate();
				month = (month < 10) ? "0" + String(month) : month;
				day = (day < 10) ? "0" + String(day) : day;
				$("#receipt_to").val(year+"-"+month+"-"+day);
	        }else{
	        	$("#receipt_from").val("");
	        	$("#receipt_from").attr("placeholder", "시작일");
	            $("#receipt_to").val("");
	            $("#receipt_to").attr("placeholder", "종료일");
	        }
	    });

		// 검색 연도 세팅
		initYear();
		// 검색		
		searchList(1);
	});
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/user/api/announcement/search/paging' />");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "DATE DESC");


		// D0000005 : member 에서 공고를 볼때는 개시 / 개시 종료된 건만 보여져야 한다. 임의로 정한 코드이다.
		comAjax.addParam("process_status", "D0000005");
		comAjax.addParam("type", $("#type_selector option:selected").val());
		comAjax.addParam("year", $("#search_year_selector option:selected").val());
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
					eventName : "searchList"
				};
	
			gfnRenderPagingMain(params);

			
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
				str += "	<td><a href='/user/fwd/announcement/detail?announcement_id=" + value.announcement_id + "'><div class='txt_hidden'>" + value.title + "</div></a></td>";
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

	function initSearchText(){
		$("#search_text").val("");
	}

</script>
            
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
	
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>공고</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>공고</li>
						<li>공고</li>
					</ul>
				</div>
				<div class="content_area">
					<h4>공고 목록</h4>
					<!--search_area-->
					<div class="search_area">
						<dl class="search_box">
							<dt class="hidden">검색대상</dt>
							<dd class="box">
								<label for="search_year_selector" class="hidden">검색구분</label>
								<select class="in_wp150 fl ace-select ls" id="search_year_selector">
								</select>
								<label for="type_selector" class="hidden">검색구분</label>
								<select name="list-search-member-class" id="type_selector" class="ace-select fl w_12" title="사업명">
								   	<option value="">전체</option>
						          	<c:forEach items="${commonCode}" var="code">
										<c:if test="${code.master_id == 'M0000005'}">
											<option value=<c:out value='${code.detail_id}'/>><c:out value='${code.name}'/></option>;
										</c:if>
									</c:forEach>
						  	 	</select>
								<div class="input_search_box fl in_w72">
									<label for="search_text" class="hidden">검색어 입력</label>
									<input class="in_w85 fl ml10" id="search_text" type="text" placeholder="키워드를 입력하여 공고를 검색하실 수 있습니다." />
									<div class="fr clearfix">
										<button type="button" class="search_txt_del fl" title="검색어 삭제" onclick="initSearchText();">
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
						<div class="count_area" id="search_count">
							[총 <span class="fw500 font_blue">100</span>건]
						</div>
					</div>
					<!--//table_count_area-->
					<!--리스트시작-->							
					<div class="table_area">
						<table class="list fixed">
							<caption>공고 목록</caption>
							<colgroup>
								<col style="width: 5%;">
								<col style="width: 20%;">
								<col style="width: 48%;">
								<col style="width: 17%;">
								<col style="width: 10%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="first">번호</th>
									<th scope="col">사업명</th>
									<th scope="col">공고명</th>
									<th scope="col">접수기간</th>
									<th scope="col" class="last">상태</th>
								</tr>
							</thead>
							<tbody id="list_body">
							</tbody>
						</table>
						
						 <!-- Pagenation -->
					   	<input type="hidden" id="pageIndex" name="pageIndex"/>
						<div class="paging_area" id="pageNavi"></div>
					</div>							
					<!--//리스트end-->
				</div>
			</div>
		</div>
	</section>
</div>
<!--//container-->
            
        
