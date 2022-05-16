<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal.username" var="member_id" />


<script>
	$(document).ready(function() {
	});

	/*******************************************************************************
	* FUNCTION 명 : logout / mainLoginCallback (로그아웃)
	* FUNCTION 기능설명 : 로그아웃한다.
	*******************************************************************************/
	function logout() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/logoutJson' />");
		comAjax.setCallback(mainLoginCallback);
		comAjax.ajax();
	}
	function mainLoginCallback(data) {
		if (data.result = "SUCCESS") {
			location.href = "/user/fwd/login/adminHomeLogin";
		}
	}
	
</script>

<!-- skip_nav --> 
	<div id="skip_nav">  
          <a href="#top_nav" title="메인메뉴 바로가기">메인메뉴 바로가기</a>
          <a href="#content" title="본문내용 바로가기">본문내용 바로가기</a>
	</div>
	<!-- //skip_nav --> 
	<!--popup-->	  
    <!-- 로그아웃 팝업 -->
    <div class="logout_popup_box popup_box">
	   <div class="popup_bg"></div>
	   <div class="logout_popup popup_contents">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">로그 아웃</h4>
		       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
			   <p><span class="font_blue">로그아웃</span> 하시겠습니까?</p>				   
		   </div>
		   <div class="popup_button_area_center">
			   <button type="button" class="blue_btn popup_close_btn" onclick="logout();">예</button>
			   <button type="button" class="gray_btn logout_popup_close_btn popup_close_btn">아니요</button>
		   </div>
	   </div>
    </div>
    <!-- //로그아웃 팝업 -->

<!-- header -->
<header class="header">
	<div class="header_top clearfix">
		<div class="fl logo_box clearfix">
		   <h1 class="header_site-logo fl">
			   <a href="/admin/fwd/adminHome/main" title="신기술접수소 홈 이동" class="home_logo clearfix ir">
				   <img class="fl" src="/assets/adminHome/images/admin_logo.png" alt="신기술접수소">
				   신기술 접수소
			   </a>
		   </h1>                        
		</div>
		<div class="class_select_box fr clearfix pc_show">
		   <span class="fl mt10 mr10 pt5"><span class="header_name">관리자</span>님 반갑습니다.</span>                     
		   <a href="javascript:void(0)" title="로그아웃" class="login_icon logout fl mt10 ir"><span>로그아웃</span></a>                    
		   <!--a href="#" title="로그인"  class="login_icon logout fl margint10 ir"><span>로그인</span></a-->                        
		</div>
	</div>
	<!--pc 상단 메뉴-->
	<nav class="nav pc_show" id="top_nav">
		<ul class="clearfix">
			<li><a href="/adminHome/content/proposal" title="콘텐츠관리"><i class="far fa-folder-open"></i>콘텐츠관리</a></li>
			<li><a href="/adminHome/board/notice/main" title="게시판관리"><i class="far fa-list-alt"></i>게시판관리</a></li>
			<li><a href="/adminHome/statistics/visitor/time" title="통계관리"><i class="fas fa-chart-bar"></i>통계관리</a></li>
		</ul>                
	</nav>
	<!--//pc 상단 메뉴-->
</header>
<!--// header -->


<!-- [E] Header -->