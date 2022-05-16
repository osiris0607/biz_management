<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal.username" var="member_id" />


<script>
	$(document).ready(function() {
		$("#logout_btn").on("click", function(){
			logout();
		});
	});

	function logout() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/logoutJson' />");
		comAjax.setCallback(mainLoginCallback);
		comAjax.ajax();
	}

	function mainLoginCallback(data) {
		if (data.result = "SUCCESS") {
			location.href = "/user/fwd/login/memberLogin";
		}
	}


	function commissionerDetail() {
		var formData = new FormData();
		formData.append("member_id", '${member_id}');

		$.ajax({
		    type : "POST",
		    url : "/member/api/home/commissioner/detail",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
			        if ( jsonData.result_data == null ){
			        	location.href = "/member/fwd/commissioner/registration";
			        }
			        else if (jsonData.result_data.commissioner_status == "D0000002") {
		        		alert("등록대기 상태입니다. 결과를 기다려 주시기 바랍니다.");
		        	} else {
			        	if (confirm("등록보류 상태입니다. 다시 신청하시겠습니까?")) {
			        		location.href = "/member/fwd/commissioner/registration";
			        	}
		        	}
					
		        	$("#research_li").prop("class", "active");
		        	$("#commissioner_li").prop("class", "");
		        } else {
		        	alert("평가위원 검색에 실패했습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
		
	}
	
</script>


<div id="header">
	<header>			
		<!-- hsection -->
		<div class="hsection">
			<div class="clearfix">
				<ul class="fl member_class clearfix">
				
					<sec:authorize access="hasRole('ROLE_EXPERT')">
						<li class="active" id="research_li"><a href="/" title="연구자">전문가</a></li>
					</sec:authorize>
				
					<sec:authorize access="hasRole('ROLE_COMMISSIONER')">
						<li class="active" id="research_li"><a href="/" title="연구자">연구자</a></li>
						<li id="commissioner_li"><a href="/commissioner/fwd/evaluation/main" title="평가위원">평가위원</a></li>
					</sec:authorize>
					
					<sec:authorize access="!hasRole('ROLE_EXPERT')">
						<sec:authorize access="!hasRole('ROLE_COMMISSIONER')">
							<li class="active" id="research_li"><a href="/" title="연구자">연구자</a></li>
							<li id="commissioner_li"><a href="javascript:void(0);" onclick="commissionerDetail();" title="평가위원 등록">평가위원 등록</a></li>
						</sec:authorize>
					</sec:authorize>
					
					
				</ul>
				<ul class="fr top_area">
					<li class="login_area">						
					
						<sec:authorize access="isAuthenticated()">
							<a href="javascript:void(0);" title="로그인" class="clearfix logout_pop_open">
									<img src="/assets/user/images/icon/icon_login_company.png" class="fl top_img" alt="로그아웃" /><span class="fl">로그아웃</span>
							</a>
						</sec:authorize>
						
						<sec:authorize access="isAnonymous()">
							<!--로그인-->
							<a href="/user/fwd/login/memberLogin" title="로그인" class="clearfix">
								<img src="/assets/user/images/icon/icon_login_company.png" class="fl top_img" alt="로그인" /><span class="fl">로그인</span>
							</a>
						</sec:authorize>
					</li>
					<li>
						<sec:authorize access="isAuthenticated()">
							<a href="/member/fwd/mypage/main" title="로그인" class="clearfix">
									<img src="/assets/user/images/icon/icon_member_sign.png" class="fl top_img" alt="My페이지" /><span class="fl">My페이지</span>
							</a>
						</sec:authorize>
						
						<sec:authorize access="isAnonymous()">
							<a href="/user/fwd/signup/main" title="회원가입" class="clearfix">
								<img src="/assets/user/images/icon/icon_member_sign.png" class="fl top_img" alt="회원가입" /><span class="fl">회원가입</span>
							</a>
						</sec:authorize>
					</li>
				</ul>
			</div>
		</div>
		<!--// hsection -->
		
		<!-- nav -->
		<div id="nav">
			<div class="gnb clearfix">
				<a href="/" title="신기술접수소 사업평가·관리 시스템 홈페이지 이동" class="fl logo">
					<h1 class="home_logo"><img src="/assets/user/images/main/logo.png" alt="신기술접수소 사업평가·관리 시스템" /></h1>
				</a>
				
				<sec:authorize access="!hasRole('ROLE_EXPERT')">
					<nav>
						<ul class="menu fl">
							<li><a href="/member/fwd/announcement/main" title="공고"><span>공고</span></a></li>
							
							<sec:authorize access="isAnonymous()">
								<li><a href="javascript:alert('로그인 후 이용 가능합니다.');" title="접수"><span>접수</span></a></li>
							</sec:authorize>
							<sec:authorize access="isAuthenticated()">
								<li><a href="/member/fwd/reception/main" title="접수"><span>접수</span></a></li>
							</sec:authorize>
							
							<sec:authorize access="isAnonymous()">
								<li><a href="javascript:alert('로그인 후 이용 가능합니다.');" title="협약"><span>협약</span></a></li>
							</sec:authorize>
							<sec:authorize access="isAuthenticated()">
								<li><a href="/member/fwd/agreement/main" title="협약"><span>협약</span></a></li>
							</sec:authorize>
							
							<sec:authorize access="isAnonymous()">
								<li><a href="javascript:alert('로그인 후 이용 가능합니다.');" title="수행"><span>수행</span></a></li>
							</sec:authorize>
							<sec:authorize access="isAuthenticated()">
								<li><a href="/member/fwd/execution/main" title="수행"><span>수행</span></a></li>
							</sec:authorize>
							
							<sec:authorize access="isAnonymous()">
								<li><a href="javascript:alert('로그인 후 이용 가능합니다.');" title="평가"><span>평가</span></a></li>
							</sec:authorize>
							<sec:authorize access="isAuthenticated()">
								<li><a href="/member/fwd/evaluation/main" title="평가"><span>평가</span></a></li>
							</sec:authorize>
							
							<sec:authorize access="isAnonymous()">
								<li><a href="javascript:alert('로그인 후 이용 가능합니다.');" title="정산"><span>정산</span></a></li>
							</sec:authorize>
							<sec:authorize access="isAuthenticated()">
								<li><a href="/member/fwd/calculation/main" title="정산"><span>정산</span></a></li>
							</sec:authorize>
							
							<li><a href="/user/fwd/notice/main" title="알림·정보"><span>알림·정보</span></a></li>
						</ul>
					</nav>
				</sec:authorize>
			</div>
		</div>
		<!--// nav -->
		
   <div class="logout_popup_box">
	   <div class="popup_bg"></div>
	   <div class="logout_popup">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">로그 아웃</h4>
		       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><span class="hidden">로그아웃</span><i class="fas fa-times"></i></a>
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
		
		
	</header>
</div>