<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>

<script type='text/javascript'>
	$(document).ready(function() {
		searchList(1);
		searchNoticeList(1);
	});


	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/user/api/announcement/search/paging' />");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "DATE DESC");

		// D0000005 : member 에서 공고를 볼때는 개시 / 개시 종료된 건만 보여져야 한다. 임의로 정한 코드이다.
		comAjax.addParam("process_status", "D0000005");
		comAjax.ajax();
	}
	
	
	function searchListCB(data) {
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
							<a href="/user/fwd/announcement/main" class="more_btn" title="더보기 버튼">사업공고 더보기 버튼</a>
						</div>
						<ul class="clearfix" id="ul_announcement_body">
						</ul>
					</div>									
				</div>
				<!--//사업공고-->
				<!--간편메뉴-->
				<div class="quickmenu_area fl">
					<div class="quickmenu_box">
						<h3 class="quickmenu-title">간편메뉴</h3>
						<span class="quickmenu-title2">Quick menu</span>
						<ul class="clearfix">
							<li><a href="userHome/fwd/business/proposal/summary" target='_blank' title="사업 안내 보기"><span><img src="/assets/user/images/main/quickmenu_img1.png" alt="사업 안내" /></span><span>사업 안내 보기</span></a></li>
							<li><a href="http://rnd.seoul-tech.com/user/fwd/announcement/main" title="사업 공고 보기"><span><img src="/assets/user/images/main/quickmenu_img2.png" alt="사업공고" /></span><span>사업 공고 보기</span></a></li>
							<li><a href="userHome/fwd/announcement/notice/noticeDetail?board_id=21"  target='_blank' title="규정&middot;서식 보기"><span><img src="/assets/user/images/main/quickmenu_img3.png" alt="규정 서식" /></span><span>규정&middot;서식 보기</span></a></li>
							<sec:authorize access="isAnonymous()">
								<li><a href="javascript:alert('로그인 후 이용 가능합니다.');" title="나의 수행 과제 현황"><span><img src="/assets/user/images/main/quickmenu_img4.png" alt="나의 수행 과제 현황" /></span><span>나의 수행 과제 현황</span></a></li>
							</sec:authorize>
							<sec:authorize access="isAuthenticated()">
								<li><a href="/member/fwd/mypage/report" title="나의 수행 과제 현황"><span><img src="/assets/user/images/main/quickmenu_img4.png" alt="나의 수행 과제 현황" /></span><span>나의 수행 과제 현황</span></a></li>
							</sec:authorize>
						</ul>
					</div>
				</div>
				<!--//간편메뉴-->
			</div>
		</div>
	</section>
	<!--//사업공고 / 퀵메뉴-->
	
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

