<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<!DOCTYPE html>
<html lang="ko">


<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	<meta name="viewport" content="initial-scale=1, viewport-fit=cover">
	<link href="/assets/img/common/favicon.ico" rel="shrtcut icon">
	<link href="/assets/img/common/favicon-152.png" rel="apple-touch-icon-precomposed">
	<title>로그인 - 청출어람</title>
	<link rel="stylesheet" href="/assets/css/style.css">
	<script src="/assets/js/jquery-3.4.1.min.js"></script>
	<script src="/assets/js/ANUI.js"></script>
	<script src="/assets/js/common.js"></script>
</head>

<script type='text/javascript'>

	$(document).ready(function() {
		

		//onclick="location.href='https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=b9aeb20cc1f2a9f391ffdad3d91dbc34&redirect_uri=http://youthstart.or.kr/login/kakao'"
			
		$("#kakao_login_btn").click(function() {
			var url = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=b9aeb20cc1f2a9f391ffdad3d91dbc34&redirect_uri=" + $("#kakao_redirect_url").val();
			//var url = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=b9aeb20cc1f2a9f391ffdad3d91dbc34&redirect_uri=http://localhost:11001/login/kakao";
			location.href= url;
		});
		
		
	});

</script>

<body class="">
	<input type="hidden" id="kakao_redirect_url" name="kakao_redirect_url" value="${vo.kakao_redirect_url}" />
	<div class="container--sub login">
		<!-- mark: content -->
		<div id="cont">
			<section class="login-wrap">
				<h1>로그인</h1>
				<button type="button" class="loginX" onclick="history.back()">닫기</button>
				<article>
					<!-- 청소년 사용자 -->
					<p class="mb--s">SNS로 간편하게 로그인하여 이용하실 수 있습니다.<br>학교, 도서관 등 다중이용 PC로 소셜로그인을 하신 경우 이용 후 반드시 로그아웃 해 주시기 바랍니다. </p>
					<div class="btn-wrap">
						<button type="button" class="btn--kakao" id="kakao_login_btn"><span>카카오계정 로그인</span></button>
					</div>
					<!-- 관리자 -->
					<!-- <div class="login-form">
						<p>관리자는 SNS 로그인이 아닌 아이디로 로그인해 주시기 바랍니다.</p>
						<div class="inp-wrap"><input type="text" placeholder="아이디를 입력해주세요." class=""></div>
						<div class="inp-wrap"><input type="password" placeholder="비밀번호를 입력해주세요." class=""></div>
						<div class="btn-wrap">
							<button type="button" class="btn--login"><span>로그인</span></button>
						</div>
						<div class="form-grp">
							<span><input type="checkbox" id="" class="form__chk" checked><label for=""><span class="label-txt">아이디 저장</span></label></span>
						</div>
					</div> -->
				</article>
			</section>
			
		   	<c:if test="${userId ne null}">
		        <h1>로그인 성공입니다</h1>
		        <input type="button" value="로그아웃" onclick="location.href='/logout'">
		    </c:if>
		</div>
	</div>
</body>
<script>


</script>

</html>
