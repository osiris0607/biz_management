<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script src="/assets/user/biz_js/reception/match-consulting-search.js"></script>
<script src="/assets/user/biz_js/reception/match-consulting-expert.js"></script>
  
<script type='text/javascript'>

	$(document).ready(function() {
	 	// match-consulting-search.js 에 구현
	 	searchMemberDetail('${member_id}');
		searchList(1);
		searchExpertParticipation();
	});

	function searchExpertParticipation() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/expert/search/participation'/>");
		comAjax.setCallback(searchExpertParticipationCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.ajax();
	}

	function searchExpertParticipationCB(data)
	{
		$("#count_1").html("<span class='font_yellow'>" + data.result_data.COUNT_1 + "</span>건");
		$("#count_2").html("<span class='font_yellow'>" + data.result_data.COUNT_2 + "</span>건");
		$("#count_3").html("<span class='font_yellow'>" + data.result_data.COUNT_3 + "</span>건");
	}


	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/member/api/mypage/expert/search/paging'/>");
		comAjax.setCallback(getSerarchListCB);
		comAjax.addParam("member_id", '${member_id}');
		comAjax.addParam("search_text", $("#search_text").val());
		comAjax.addParam("reception_expert_status1", $("#select_expert_class_2").val());
		comAjax.addParam("reception_expert_status2", $("#select_expert_class2").val());

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
			$.each(data.result_data, function(key, value) 
			{
				var temp = value.choiced_expert_list[0].participation_name;
				if ( $("#select_expert_class2").val() == "" || $("#select_expert_class2").val() == value.choiced_expert_list[0].participation_name )
				{
					str += "<tr>";
					str += "	<td class='first'>" + index + "</td>";
					str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "&participation_name=" + value.choiced_expert_list[0].participation_name + "'>" + value.announcement_title + "</a></td>";
					str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "&participation_name=" + value.choiced_expert_list[0].participation_name + "'>" + value.announcement_business_name + "</a></td>";
					str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "&participation_name=" + value.choiced_expert_list[0].participation_name + "'>" + value.institution_name + "</a></td>";
					str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "&participation_name=" + value.choiced_expert_list[0].participation_name + "'>" + value.researcher_name + "</a></td>";
					str += "	<td class='announcement_name'><a href='/member/fwd/mypage/receptionDetail?reception_id=" + value.reception_id + "&announcement_type=" + value.announcement_type + "&announcement_id=" + value.announcement_id + "&participation_name=" + value.choiced_expert_list[0].participation_name + "'>" + phoneFomatter(value.researcher_mobile_phone.replace(/\-/gi, ""), 0) + "</a></td>";

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
				}
				
				
			});
			body.append(str);
		}

		var tempString = "<span style='display: inline-block;'><strong></strong>" +mMemberDetail.name + "</span> 전문가님을 전문가로 희망하는 사업이  있습니다.</p>";
			tempString += "<p>검토하시고 회신 부탁드립니다.</p>";
		$("#introduction").html(tempString);
	}
	

	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	
	function commonPopupConfirm(){
		if ( isRegInstitutionResult == true || isRegRepresentativeResult == true) {
			location.reload();
		}
	}

</script>

<!-- container -->
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
										<a href="/member/fwd/mypage/expert" title="전문가 참여 현황" class="active"><span>전문가 참여 현황</span></a>				
									</li>
								</sec:authorize>
								<sec:authorize access="hasAnyRole('ROLE_COMMISSIONER', 'ROLE_ADMIN')">
									<li>
										<a href="/member/fwd/mypage/commissioner" title="평가위원정보관리" ><span>평가위원 정보 관리</span></a>				
									</li>
								</sec:authorize>
								<li>
									<a href="/member/fwd/mypage/report" title="나의 수행과제 현황 관리 페이지로 이동"><span>나의 수행과제 현황 관리</span></a>									
								</li>
							</ul>
							<!--// lnb_menu -->
						</div><!--//lnb_menu_area-->
					</div><!--//lnb_area-->
				</div>
				<!--//lnb-->
				<div class="sub_right_contents fl">
					<h3>전문가 참여 현황</h3>
					<div class="expertlist_business_status business_info_box">
						<ul class="clearfix">
							<li class="business_status">
								<!--전문가 참여 현황-->
								<h3>전문가 참여 현황</h3>
								<ul>
									<li>
										<dl class="clearfix">
											<dt>전문가 매칭중</dt>
											<dd id="count_1"><span class="font_yellow">0</span>건</dd>
										</dl>
									</li>
									<li>
										<dl class="clearfix">
											<dt>전문가 참여 수행중</dt>
											<dd id="count_2"><span class="font_yellow">0</span>건</dd>
										</dl>
									</li>
									<li>
										<dl class="clearfix">
											<dt>참여완료</dt>
											<dd id="count_3"><span class="font_yellow">0</span>건</dd>
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
											<dd class="mail"><span class="font_yellow">0</span>건</dd>
										</dl>
									</li>
									<li>
										<dl class="clearfix">
											<dt>업무연락 발신</dt>
											<dd class="mail"><span class="font_yellow">0</span>건</dd>
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
					<div class="my_expert_txt_area">
						<p id="introduction"></p>
					</div>
					<div class="search_area">
						<dl class="search_box">
							<dt class="hidden">검색대상</dt>
							<dd class="box clearfix">
								<label for="select_expert_class_2" class="fl mt20 mr20" style="font-size: 18px;">구분</label>
								<select id="select_expert_class_2" class="selectbox1 fl ace-select" onchange="$('#select_expert_class2').val('');" style="width: 20%;">
									<option value="">전체</option>
									<option value="1">매칭중</option>
									<option value="2">수행중</option>
									<option value="3">참여완료</option>
								</select>
								<label for="select_expert_class2" class="hidden">검색구분</label>
								<select id="select_expert_class2" class="selectbox2 fl ace-select" style="width: 20%;">
									<option value="">전체</option>
									<option value="참여">참여</option>
									<option value="미참여">미참여</option>
									<option value="미회신">미회신</option>
									<option value="미선정">미선정</option>
								</select>
								<div class="input_search_box2 fl" style="width:70%">
									<label for="search_text" class="hidden">검색어 입력</label>
									<input id="search_text" class="fl ml10" name="input_txt" type="text" placeholder="검색어를 입력하세요." style="width: 73.1%;" />
									<div class="fr clearfix">
										<button type="button" onclick="$('#search_text').val('');" class="search_txt_del fl" title="검색어 삭제"><img src="/assets/user/images/icon/search_txt_del.png" alt="검색어 삭제 버튼"></button>	
										<button type="button" onclick="searchList(1);" class="serch_btn blue_btn fl mr20" title="검색">검색</button>	
									</div>	
								</div>
							</dd>
						</dl>							
					</div>
					<div class="count_area mb10" id="search_count">
					</div>
					<div class="table_area">
						<table class="list fixed">
							<caption>나의 접수 과제 목록</caption>
							<colgroup>
								<col style="width: 5%;">
								<col style="width: 25%;">
								<col style="width: 13%;">
								<col style="width: 12%;">
								<col style="width: 8%;">
								<col style="width: 13%;">
								<col style="width: 17%;">
								<col style="width: 7%;">
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
							<tbody id="list_body">
							</tbody>
						</table>
					</div>						
					
			 		<!-- Pagenation -->
				   	<input type="hidden" id="pageIndex" name="pageIndex"/>
					<div class="paging_area" id="pageNavi"></div>
				</div>			
					
			</div><!--//sub_right_contents-->
		</div><!--//content_area-->
	</section><!--//content-->
</div><!--//sub_contents-->
 
 
 <!--기관명검색 팝업-->
<div class="mypage_company_name_popup_box">
	<div class="popup_bg"></div>
	<div class="mypage_company_name_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">기관명 검색</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0" id="reg_no_err"><span class="font_blue">000-00-00000</span> 은<br />기관으로 등록되어 있지 않습니다.<br />기관정보를 직접 입력해 주세요.</p>
			<!--있을경우-->
			<!--p tabindex="0">
				<input type="radio" id="mypage_company_name_radio" name="mypage_company_name_radio">
				<label for="mypage_company_name_radio">이노싱크컨설팅</label>
			</p-->
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn">확인</button>
			</div>	
		</div>
	</div>			
</div>

<!--기관정보등록 팝업-->
<div class="company_signup_popup_box">
	<div class="popup_bg"></div>
	<div class="company_signup_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">기관 정보 등록</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn company_signup_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">기관정보의 최초 등록 시</span>, 등록자의 대표자가 아닌 경우 임시 대표자로 설정됩니다.<br />로그인한 인증서와 동일한 <span class="font_blue">사업자번호의 기관만 등록, 수정</span>이 가능합니다.</p>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn company_signup_popup_close_btn" onclick="toggleText()">확인</button>
			</div>	
		</div>
	</div>			
</div>
<!--//기관정보등록 팝업-->

<!--사업자 등록번호 팝업-->
<div class="companynumber_popup_box">
	<div class="popup_bg"></div>
	<div class="companynumber_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">미등록 기관 등록</h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn companynumber_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p tabindex="0">미등록 기관입니다.<br />미등록 기관의 경우 등록해 주세요.<br />
				기업의 경우, <span class="font_blue">사업자등록번호로 중복 확인</span> 부탁 드립니다.</p>
				<ul>
					<li class="clearfix mb5"><label for="notsignup_companyname" class="w45 fl ta_r mr10">미등록 기관명 </label>
						<input type="text" id="notsignup_companyname" class="form-control w50 fl" /></li>
					<li class="clearfix"><label for="li_number2" class="w45 fl ta_r mr10">미등록 기관 사업자 등록번호 </label>
						<input type="text" class="form-control input-sm mr5 w30 fl" name="li_number2" id="li_number2" placeholder="숫자만 입력" maxlength="12"><button type="button" class="gray_btn fl notsignup_test_company_number" title="중복확인">중복확인</button></li>
					<li>
				</ul>
			</div>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn companynumber_popup_close_btn ">등록</button>
			</div>								
		</div>
	</div>				 
</div>
<!--//사업자 등록번호 팝업-->	

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


<script>			
	//달력
	$(".datepicker").datepicker({  
		  showOn: "both", // 버튼과 텍스트 필드 모두 캘린더를 보여준다.
		  //buttonImage: "/application/db/jquery/images/calendar.gif", // 버튼 이미지
		  buttonText	: false, 
		  buttonImageOnly: false, // 버튼에 있는 이미지만 표시한다.
		  changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
		  changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
		  minDate: '-100y', // 현재날짜로부터 100년이전까지 년을 표시한다.
		  nextText: '다음 달', // next 아이콘의 툴팁.
		  prevText: '이전 달', // prev 아이콘의 툴팁.
		  numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
		  stepMonths: 3, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가. 
		  yearRange: 'c-100:c+10', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
		  showButtonPanel: true, // 캘린더 하단에 버튼 패널을 표시한다. ( ...으로 표시되는부분이다.) 
		  currentText: '오늘 날짜' , // 오늘 날짜로 이동하는 버튼 패널
		  closeText: '닫기',  // 닫기 버튼 패널
		  dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
		  showAnim: "slide", //애니메이션을 적용한다.  
		  showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다. 
		  dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], // 요일의 한글 형식.
		  monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] // 월의 한글 형식.
	  });
</script>

