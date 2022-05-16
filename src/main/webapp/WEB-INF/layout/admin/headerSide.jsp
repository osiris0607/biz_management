<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal.username" var="member_id" />


<script>
	$(document).ready(function() {
		<sec:authorize access="!hasAnyRole('ROLE_ADMIN', 'ROLE_SUPER_ADMIN')">
			searchDetail();
		</sec:authorize>

		<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_SUPER_ADMIN')">
			$("#announcement_menu_yn").show();
			$("#reception_menu_yn").show();
			$("#evaluation_menu_yn").show();
			$("#execution_menu_yn").show();
			$("#agreement_menu_yn").show();
			$("#calculate_menu_yn").show();
			$("#notice_menu_yn").show();
			$("#member_menu_yn").show();
		</sec:authorize>

		<sec:authorize access="hasRole('ROLE_MANAGER')">
			$("#evaluation_btn").show();
		</sec:authorize>
		
	});

	/*******************************************************************************
	* FUNCTION 명 : searchDetail / searchDetailCB (관리자 정보 조회)
	* FUNCTION 기능설명 : 로그인한 관리자의 권한별 메뉴를 구성한다.
	*******************************************************************************/
	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/member/manager/detail'/>");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.ajax();
	}
	function searchDetailCB(data){
		// 메뉴별 권한
		if ( data.result_data.auth_announcement_menu_yn == "Y") {
			$("#announcement_menu_yn").show();
		}
		if ( data.result_data.auth_reception_menu_yn == "Y") {
			$("#reception_menu_yn").show();
		}
		if ( data.result_data.auth_evaluation_menu_yn == "Y") {
			$("#evaluation_menu_yn").show();
		}
		if ( data.result_data.auth_execution_menu_yn == "Y") {
			$("#execution_menu_yn").show();
		}
		if ( data.result_data.auth_agreement_menu_yn == "Y") {
			$("#agreement_menu_yn").show();
		}
		if ( data.result_data.auth_calculate_menu_yn == "Y") {
			$("#calculate_menu_yn").show();
		}
		if ( data.result_data.auth_notice_menu_yn == "Y") {
			$("#notice_menu_yn").show();
		}
	}

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
			location.href = "/user/fwd/login/adminLogin";
		}
	}

	/*******************************************************************************
	* FUNCTION 명 : onMoveEvaluation
	* FUNCTION 기능설명 : 평가관리 페이지로 이동한다.
	*******************************************************************************/
	function onMoveEvaluation() {
		// 최초 이동시 기술매칭의  평가전으로 이동한다.  announcement_type="D0000005" , classification="D0000005"
		location.href = "/admin/fwd/evaluation/main?announcement_type=" + "D0000005" + "&classification=" + "D0000005";
	}

	/*******************************************************************************
	* FUNCTION 명 : onMoveAgreement
	* FUNCTION 기능설명 : 협약관리 페이지로 이동한다.
	*******************************************************************************/
	function onMoveAgreement() {
		// 최초 이동시 기술매칭으로 이동한다.  announcement_type="D0000005"
		location.href = "/admin/fwd/agreement/main?announcement_type=" + "D0000005";
	}

	/*******************************************************************************
	* FUNCTION 명 : onMoveExecution
	* FUNCTION 기능설명 : 수행관리 페이지로 이동한다.
	*******************************************************************************/
	function onMoveExecution() {
		// 최초 이동시 기술매칭으로 이동한다.  announcement_type="D0000005"
		location.href = "/admin/fwd/execution/main?announcement_type=" + "D0000005";
	}

	/*******************************************************************************
	* FUNCTION 명 : onMoveCalculation
	* FUNCTION 기능설명 : 정산관리 페이지로 이동한다.
	*******************************************************************************/
	function onMoveCalculation() {
		// 최초 이동시 기술매칭으로 이동한다.  announcement_type="D0000005"
		location.href = "/admin/fwd/calculation/main?announcement_type=" + "D0000005";
	}
	
	
	
</script>


<header class="header">
   <div class="header_wrapper clearfix">
   
		<div class="fl logo_box clearfix">
        	<h1 class="header_site-logo fl">
		       <a href="/admin/fwd/home/main" title="신기술접수소 사업평가 관리시스템 홈페이지 이동" class="home_logo clearfix">
			       <img class="fl" src="/assets/admin/images/admin_logo.png" alt="신기술접수소">
				   <span class="logo_txt fl">사업평가&middot;관리 시스템</span>							  
			   </a>						  
		   	</h1>  
		   	<a href="/manager/fwd/evaluation/main" target="_blank" id="evaluation_btn" style="display:none" class="pre_review_btn blue_btn">사전검토</a>
       </div>
      	<div class="class_select_box fr clearfix pc_show">
			<span class="fl margint15 marginr10"><span class="header_name"><c:out value='${member_id}'/></span>님 반갑습니다.</span>
           	<a href="javascript:void(0)" title="전체 메뉴 보기" class="gnb_all fr ir marginl15">전체 메뉴 보기</a>
           	<a href="javascript:void(0)" title="로그아웃" class="login_icon logout fl margint15 ir logout_pop_open"><span>로그아웃</span></a>                    
       </div>                  
   </div>
                                  
   <!--pc 상단 메뉴-->
   <nav class="nav pc_show" id="nav">
      <ul class="clearfix">
          <li id="announcement_menu_yn" style="display:none"><a href="/admin/fwd/announcement/main" title="공고관리"><i class="far fa-file-alt mr8"></i>공고관리</a></li>
          <li id="reception_menu_yn" style="display:none"><a href="/admin/fwd/reception/main" title="접수관리"><i class="fas fa-edit  mr8"></i>접수관리</a></li>
          <li id="evaluation_menu_yn" style="display:none"><a href="javascript:void(0)" title="평가관리" onclick="onMoveEvaluation();"><i class="fas fa-clipboard-check  mr8"></i>평가관리</a></li>
          <li id="execution_menu_yn" style="display:none"><a href="javascript:void(0)" title="수행관리" onclick="onMoveExecution();"><i class="fas fa-clipboard-list  mr8"></i>수행관리</a></li>
          <li id="agreement_menu_yn" style="display:none"><a href="javascript:void(0)" title="협약관리" onclick="onMoveAgreement();"><i class="far fa-handshake  mr8"></i>협약관리</a></li>
          <li id="calculate_menu_yn" style="display:none"><a href="javascript:void(0)" title="정산관리" onclick="onMoveCalculation();"><i class="fas fa-coins  mr8"></i>정산관리</a></li>
          <li id="notice_menu_yn" style="display:none"><a href="/admin/fwd/notice/main" title="알림&middot;정보관리"><i class="fas fa-bullhorn  mr8"></i>알림&middot;정보관리</a></li>
          <li id="member_menu_yn" style="display:none"><a href="/admin/fwd/member/researcher/main" title="회원관리"><i class="fas fa-user-cog  mr8"></i>회원관리</a></li>
      </ul>                
   </nav>
            <!--//pc 상단 메뉴-->
            
	   <!-- skip_nav --> 
 <!--       <div id="skip_nav">  
           <a href="#nav" title="메인메뉴 바로가기">메인메뉴 바로가기</a>
           <a href="#content" title="본문내용 바로가기">본문내용 바로가기</a>
       </div> -->
      <!-- //skip_nav --> 
   <!--popup-->
   <!--로그아웃 팝업-->
   <div class="logout_popup_box">
	   <div class="popup_bg"></div>
	   <div class="logout_popup">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">로그 아웃</h4>
		       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
			   <p><span class="font_blue">로그아웃</span> 하시겠습니까?</p>
			   <div class="popup_button_area_center">
				   <button type="button" class="blue_btn mr5" onclick="logout();">예</button>
				   <button type="button" class="gray_btn logout_popup_close_btn popup_close_btn">아니요</button>
			   </div>
		   </div>
	   </div>
   </div>
   <!--//로그아웃 팝업-->
</header>


<!-- [E] Header -->