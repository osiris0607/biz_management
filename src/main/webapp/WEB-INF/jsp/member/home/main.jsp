<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>

<script src="/assets/user/biz_js/reception/match-consulting-search.js"></script>
<script src="/assets/user/biz_js/reception/match-consulting-expert.js"></script>

<script type='text/javascript'>
	$(document).ready(function() {
		searchMemberDetail('${member_id}');
		searchAnnouncementList(1);
		searchNoticeList(1);
		searchReportList(1);
		searchExpertList(1);
	});

	function searchExpertList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/expert/search/paging'/>");
		comAjax.setCallback(serarchExpertListCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.addParam("search_text", $("#search_expert_text").val());
		
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
		comAjax.ajax();
	}
	
	function serarchExpertListCB(data){
		// 데이터가 없으면 Return
		var total = data.totalCount;
		var body = $("#expert_body");
		body.empty();

		$("#search_expert_count").html("[총 <span class='fw500 font_blue'>" + total + "</span>건]");
		if (total == 0) {
			var str = "<tr>" + "<td colspan='8'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>" + index + "</td>";
				str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "'>" + value.announcement_title + "</a></td>";
				str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "'>" + value.announcement_business_name + "</a></td>";
				str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "'>" + value.institution_name + "</a></td>";
				str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "'>" + value.researcher_name + "</a></td>";
				str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "'>" + phoneFomatter(value.researcher_mobile_phone.replace(/\-/gi, ""), 0) + "</a></td>";

				var userEmail = "";
				if ( gfn_isNull(value.researcher_email) == false  ) {
					var id =value.researcher_email.split("@")[0].replace(/(?<=.{3})./gi,"*"); 
					var mail =value.researcher_email.split("@")[1];
				 	var userEmail= id+"@"+mail;
				}				
				str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "'>" + userEmail + "</a></td>";
				str += "	<td class='last'><span>" + value.choiced_expert_list[0].participation_name + "</span></td>";
				str += "</tr>";
				index++;
			});
			body.append(str);
		}

		var tempString = "<span style='display: inline-block;'><strong></strong>" + mMemberDetail.name + "</span> 전문가님을 전문가로 희망하는 회신 대기중인 사업이 <span class='ls font_blue'>" + total + "</span>개 있습니다.</p>";
			tempString += "<p>검토하시고 회신 부탁드립니다.</p>";
		$("#introduction").html(tempString);
	}

	

	function searchReportList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/report/search/paging'/>");
		comAjax.setCallback(serarchReportListCB);
		comAjax.addParam("member_id", '${member_id}');
		var temp = $("#search_report_text").val();
		comAjax.addParam("search_text", $("#search_report_text").val());
		
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
		comAjax.ajax();
	}
	
	function serarchReportListCB(data){
		// 데이터가 없으면 Return
		var total = data.totalCount;
		var body = $("#report_body");
		body.empty();

		$("#search_report_count").html("[총 <span class='fw500 font_blue'>" + total + "</span>건]");
		if (total == 0) {
			var str = "<tr>" + "<td colspan='8'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
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
	

	function searchAnnouncementList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/user/api/announcement/search/paging' />");
		comAjax.setCallback(searchAnnouncementListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "DATE DESC");

		// D0000005 : member 에서 공고를 볼때는 개시 / 개시 종료된 건만 보여져야 한다. 임의로 정한 코드이다.
		comAjax.addParam("process_status", "D0000005");
		comAjax.ajax();
	}
	
	
	function searchAnnouncementListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#ul_announcement_body");
		body.empty();
		if (total > 0) {
			var index = 1;
			var str = "";
			$.each(data.result, function(key, value) {
				if (index > 4) {
					// for each loop exit
					return false;
				}

				str += "<li>";
				// 개시중 = 접수중
				if ( value.process_status == "D0000003") {
					str += "<span class='announcementnotice_list_class'>접수중</span>";
				}
				// 개시종료 = 접수 마감
				else {
					str += "<span class='announcementnotice_list_class_end'>접수마감</span>";
				}
				str += "	<dl class='announcementnotice_list_txt'>";
				str += "		<dt><a href='/user/fwd/announcement/detail?announcement_id=" + value.announcement_id + "' title='사업공고 제목'>" + value.title + "</a></dt>";
				str += "		<dd><a href='/user/fwd/announcement/detail?announcement_id=" + value.announcement_id + "' title='사업공고 내용'><p>" + unescapeHtml(value.contents) + "</p></a></dd>";
				str += "	</dl>";
				str += "	<dl class='announcementnotice_list_day clearfix'>";
				str += "		<dt>접수기간</dt>";
				str += "		<dd class='ls3'>" + value.receipt_from + "~" + value.receipt_to + "</dd>";
				str += "	</dl>";
				str += "</li>";

				index++;
			});
			body.append(str);
		}
	}

	function searchNoticeList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/user/api/notice/search/paging' />");
		comAjax.setCallback(searchNoticeListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
		comAjax.ajax();
	}
	
	function searchNoticeListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#ul_notice_body");
		body.empty();

		if (total > 0) {
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				if (index > 4) {
					return false;
				}
				
				str += "<li>";
				str += "	<a href='/user/fwd/notice/detail?notice_id=" + value.notice_id + "' title='알림&middot; 바로가기'>";
				str += "		<span class='notice_top clearfix'>";
				str += "			<span class='notice_top clearfix'>";
				var date = value.reg_date.split("-");
				str += "			<span class='fl notice_day'>" + date[0] + "<br />" + date[1] + "." + date[2] + "</span>";
				str += "			<span class='fr notice_link'>바로가기 버튼</span>";
				str += "		</span>";
				str += "		<dl>";
				str += "			<dt>" + value.title + "</dt>";
				str += "			<dd>" + unescapeHtml(value.explanation) + "</dd>";
				str += "		</dl>";
				str += "	</a>";
				str += "</li>";
	
				index++;
			});
			body.append(str);
		}
	}

</script>


<sec:authorize access="!hasRole('ROLE_EXPERT')">
	<div id="container">					
	<h2 class="hidden">메인 컨텐츠 화면</h2>		
	<!--사업공고 / 퀵메뉴-->
	<section id="content" class="main_area">
		<div class="content_area">
			<!-- main_section -->
			<div class="main_top_contents clearfix">
				<!--사업공고-->
				<div class="business_notice_area fl">
					<div class="business_notice_box">
						<div class="notice_title clearfix">
							<h3 class="notice-box-title">사업공고</h3>
							<a href="/member/fwd/announcement/main" class="more_btn" title="더보기 버튼">사업공고 더보기 버튼</a>
						</div>
						<ul class="clearfix" id="ul_announcement_body"></ul>
					</div>									
				</div>
				<!--//사업공고-->
				<!--간편메뉴-->
				<div class="quickmenu_area fl">
					<div class="quickmenu_box">
						<h3 class="quickmenu-title">간편메뉴</h3>
						<span class="quickmenu-title2">Quick menu</span>
						<ul class="clearfix">
							<li><a href="https://www.seoul-tech.com/web/intropage/intropageShow.do?page_id=bbbeff5fed714551b945a289fa5d9eec" target='_blank' title="사업 안내 보기"><span><img src="/assets/user/images/main/quickmenu_img1.png" alt="사업 안내"></span><span>사업 안내 보기</span></a></li>
							<li><a href="http://rnd.seoul-tech.com/user/fwd/announcement/main" title="사업 공고 보기"><span><img src="/assets/user/images/main/quickmenu_img2.png" alt="사업 공고 보기"></span><span>사업 공고 보기</span></a></li>
							<li><a href="https://www.seoul-tech.com/web/board/boardContentsListPage.do?board_id=1" title="규정&middot;서식 보기"><span><img src="/assets/user/images/main/quickmenu_img3.png" alt="규정 서식 보기"></span><span>규정&middot;서식 보기</span></a></li>
							<sec:authorize access="isAnonymous()">
								<li><a href="javascript:alert('로그인 후 이용 가능합니다.');" title="나의 수행 과제 현황"><span><img src="/assets/user/images/main/quickmenu_img4.png" alt="나의 수행 과제 현황"></span><span>나의 수행 과제 현황</span></a></li>
							</sec:authorize>
							<sec:authorize access="isAuthenticated()">
								<li><a href="/member/fwd/mypage/report" title="나의 수행 과제 현황"><span><img src="/assets/user/images/main/quickmenu_img4.png" alt="나의 수행 과제 현황"></span><span>나의 수행 과제 현황</span></a></li>
							</sec:authorize>
						</ul>
					</div>
				</div>
				<!--//간편메뉴-->
			</div>
		</div>
	</section>
	<!--//사업공고 / 퀵메뉴-->
	
	<!--사업현황,사업연락,사업소개바로가기-->
	<section>
		<div class="business_info_area">
			<div class="content_area">
				<div class="business_info_box">
					<ul class="clearfix">
						<li class="business_status">
							<!--사업현황-->
							<h3>사업현황</h3>
							<ul>
								<li>
									<dl class="clearfix">
										<dt>접수 사업</dt>
										<dd><a href=""><span class="font_yellow">0</span>건</a></dd>
									</dl>
								</li>
								<li>
									<dl class="clearfix">
										<dt>수행 사업</dt>
										<dd><a href=""><span class="font_yellow">0</span>건</a></dd>
									</dl>
								</li>
								<li>
									<dl class="clearfix">
										<dt>종료 사업</dt>
										<dd><a href=""><span class="font_yellow">0</span>건</a></dd>
									</dl>
								</li>
							</ul>
						</li>
						<!--사업연락-->
						<li class="business_col">
							<h3>사업 연락</h3>
							<ul>
								<li>
									<dl class="clearfix">
										<dt>업무연락 수신</dt>
										<dd class="mail"><a href="" class="fl"><span class="font_yellow">0</span>건</a> <span class="fl">/</span> <a href="" class="fl"><span class="font_yellow">10</span>건</a></dd>
									</dl>
								</li>
								<li>
									<dl class="clearfix">
										<dt>업무연락 발신</dt>
										<dd class="mail"><a href=""><span class="font_yellow">0</span>건</a></dd>
									</dl>
								</li>
							</ul>
						</li>
						<!--사업소개 바로가기-->
						<li class="business_info_link">
							<a href="https://seoul-tech.com/web/intropage/intropageShow.do?page_id=e35c124aa9084e84bc8c663f9ae796cf" title="신기술접수소 사업 소개페이지 바로가기"><span class="font_yellow">신기술접수소 사업</span>을 소개합니다.
							<h3>신기술접수소 사업 소개</h3></a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</section>
	<!--//사업현황,사업연락,사업소개바로가기-->
	
	<!--나의 수행 과제 현황-->
	<section>							
		<div class="my_misson_area">
			<div class="content_area">
				<h3><span>나의 수행 과제 현황을 한눈에 조회합니다.</span>나의 수행 과제 현황</h3>
				
				<!--서치-->
				<div class="search_area">
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
									<label for="search_report_text" class="hidden">검색어 입력</label>
									<input id="search_report_text" class="w80 fl ml10" name="input_txt" type="text" placeholder="검색어를 입력하세요." />
									<div class="fr clearfix">
										<button type="button" class="search_txt_del fl" title="검색어 삭제" onclick="$('#search_report_text').val('');"><img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼"></button>	
										<button type="button" class="serch_btn blue_btn fl mr20" title="검색" onclick="searchReportList(1);">검색</button>	
									</div>	
								</div>
						</dd>
					</dl>							
				</div>
	
				<!--결과-->
				<div class="count_area" id="search_report_count">
					[총 <span class="fw500 font_blue">0</span>건]
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
								<th scope="col">연구책임자명</th>
								<th scope="col" class="last">연구기간</th>
							</tr>
						</thead>
						<tbody id="report_body"></tbody>
					</table>
				</div>
			</div>
		</div>
	</section>
	<!--//나의 수행 과제 현황-->
	
	<!--전문가 참여 현황,사업연락,사업소개바로가기 (전문가)-->
	<section>
		<div class="business_info_area">
			<div class="content_area">
				<div class="business_info_box">
					<ul class="clearfix">
						<li class="business_status">
							<!--전문가 참여 현황-->
							<h3>전문가 참여 현황</h3>
							<ul>
								<li>
									<dl class="clearfix">
										<dt>전문가 매칭중</dt>
										<dd><a href=""><span class="font_yellow">0</span>건</a></dd>
									</dl>
								</li>
								<li>
									<dl class="clearfix">
										<dt>전문가 참여 수행중</dt>
										<dd><a href=""><span class="font_yellow">0</span>건</a></dd>
									</dl>
								</li>
								<li>
									<dl class="clearfix">
										<dt>참여완료</dt>
										<dd><a href=""><span class="font_yellow">0</span>건</a></dd>
									</dl>
								</li>
							</ul>											
						</li>
						<!--사업연락-->
						<li class="business_col">
							<h3>사업 연락</h3>
							<ul>
								<li>
									<dl class="clearfix">
										<dt>업무연락 수신</dt>
										<dd class="mail"><a href="" class="fl"><span class="font_yellow">0</span>건</a> <span class="fl">/</span> <a href="" class="fl"><span class="font_yellow">0</span>건</a></dd>
									</dl>
								</li>
								<li>
									<dl class="clearfix">
										<dt>업무연락 발신</dt>
										<dd class="mail"><a href=""><span class="font_yellow">0</span>건</a></dd>
									</dl>
								</li>
							</ul>
						</li>
						<!--사업소개 바로가기-->
						<li class="business_info_link">
							<a href="https://seoul-tech.com/web/intropage/intropageShow.do?page_id=e35c124aa9084e84bc8c663f9ae796cf" title="신기술접수소 사업 소개페이지 바로가기"><span class="font_yellow">신기술접수소 사업</span>을 소개합니다.
							<h3>신기술접수소 사업 소개</h3></a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</section>
	<!--전문가 참여 현황,사업연락,사업소개바로가기 (전문가)-->
	
	<!--공지사항-->
	<section>
		<div class="notice_area">
			<div class="notice_box">
				<div class="content_area">
					<h3>NOTICE</h3>
					<ul class="clearfix" id="ul_notice_body"></ul>
					<button type="button" class="blue_btn notice_more_btn" title="알림&middot;정보 더보기 바로가기" onclick="location.href='/user/fwd/notice/main'">더보기 +</button>
				</div>
			</div>
		</div>
	</section>
	<!--//공지사항-->
		
	</div>

</sec:authorize>


<sec:authorize access="hasRole('ROLE_EXPERT')">
	<div id="container">					
		<h2 class="hidden">메인 컨텐츠 화면</h2>		
		<!--희망 전문가 요청 사업목록 (전문가)-->
		<section id="content" class="main_area">							
			<div class="my_expert_area">
				<div class="content_area">
					<h3>희망 전문가 요청 사업</h3>
					<div class="my_expert_txt_area">
						<p id="introduction"></p>
					</div>
					<!--서치-->
					<div class="search_area">
						<dl class="search_box">
							<dt class="hidden">검색대상</dt>
							<dd class="box clearfix">
								<label for="select_expert_class_" class="fl mt20 mr20" style="font-size: 18px;">구분</label>
								<select id="select_expert_class_" class="selectbox1 fl ace-select" style="width: 20%;">
									<option value="0">전체</option>
									<option value="1">매칭중</option>
									<option value="2">수행중</option>
									<option value="3">참여완료</option>
								</select>
								<label for="select_expert_class" class="hidden">검색구분</label>
								<select id="select_expert_class" class="selectbox2 fl ace-select" style="width: 20%;">
									<option value="전체">전체</option>
									<option value="참여">참여</option>
									<option value="미참여">미참여</option>
									<option value="미회신">미회신</option>
									<option value="미선정">미선정</option>
								</select>
								<div class="input_search_box fl" style="width:74%">
									<label for="search_expert_text" class="hidden">검색어 입력</label>
									<input id="search_expert_text" class="w82 fl ml10" name="input_txt" type="text" value="" placeholder="검색어를 입력하세요.">
									<div class="fr clearfix">
										<button type="button" onclick="$('#search_expert_text').val('');" class="search_txt_del fl" title="검색어 삭제"><img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼"></button>	
										<button type="button" onclick="searchExpertList(1);" class="serch_btn blue_btn fl mr20" title="검색">검색</button>
									</div>	
								</div>
							</dd>
						</dl>							
					</div>
		
					<!--결과-->
					<div class="count_area" id="search_expert_count">
						[총 <span class="fw500 font_blue">0</span>건]
					</div>
					<div class="table_area">
						<table class="list fixed">
							<caption>나의 접수 과제 목록</caption>
							<colgroup>
								<col style="width: 5%;">
								<col style="width: 25%;">
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 10%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="first">번호</th>
									<th scope="col">공고명</th>												
									<th scope="col">사업구분</th>
									<th scope="col">기관명</th>
									<th scope="col">성명</th>
									<th scope="col">휴대전화</th>											
									<th scope="col">이메일</th>
									<th scope="col" class="last">진행상태</th>
								</tr>
							</thead>
							<tbody id="expert_body"></tbody>
						</table>
					</div>
				</div>
			</div>
		</section>
		<!--//희망 전문가 요청 사업목록 (전문가)-->
	</div>>
</sec:authorize>




<!--공통팝업-->
<div class="common_popup_box">
	<div class="popup_bg"></div>
	<div class="common_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">팝업 제목</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<!--p tabindex="0">팝업내용입력</p-->
			</div>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn">확인</button>
			</div>
		</div>						
	</div> 
</div>			
	<!--공통팝업 ui확인-->
	<!--a href="" class="common_popup_open">dsdsd</a-->

<!--//공통팝업-->


<!--정보입력 팝업-->
<div class="first_popup_box">		
	<div class="popup_bg"></div>
	<div class="first_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">정보 입력</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0">개인이 아닌 기관이나 기업 등에 소속되어 있는 경우,<br /> 마이페이지로 이동하여 기관정보를 입력하시고 개인정보를 추가 입력 하셔야 합니다.  </p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn popup_close_btn">확인</button>
			</div>	
		</div>									
	</div> 
</div>
<!--정보입력 팝업-->
