<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="ie=edge" />
		<meta name="description" content="신기술접수소 사업평가관리시스템" />
		<meta name="keywords" content="신기술 접수소, 서울 신기술 사업평가관리" />
		<meta property="og:type" content="website" />
		<meta property="og:title" content="신기술접수소 사업평가관리시스템 사이트" />
		<meta property="og:url" content="" />
		<meta property="og:description" content="신기술접수소 사업평가관리시스템" />
		<title>신기술접수소 사업평가·관리 시스템</title>		
		<link rel="stylesheet" type="text/css" href="/assets/user/css/default.css" />
		<link rel="stylesheet" type="text/css" href="/assets/user/css/style.css" />
		<script src="/assets/user/js/lib/jquery-3.3.1.min.js"></script>
		<script src="/assets/user/js/lib/all.min.js"></script>		
		<script src="/assets/user/js/lib/jquery.nice-select.min.js"></script>
	</head>

	<script type='text/javascript'>
		$(document).ready(function(){
			 
		    // 저장된 쿠키값을 가져와서 ID 칸에 넣어준다. 없으면 공백으로 들어감.
		    var key = getCookie("loginId");
		    $("#member_id").val(key); 
		     
		    if($("#member_id").val() != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
		        $("#save_id_chb").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
		    }
		     
		    $("#save_id_chb").change(function(){ // 체크박스에 변화가 있다면,
		        if($("#save_id_chb").is(":checked")){ // ID 저장하기 체크했을 때,
		        	var userInputId = $("#member_id").val();
		            setCookie("loginId", userInputId, 7); // 7일 동안 쿠키 보관
		        }else{ // ID 저장하기 체크 해제 시,
		            deleteCookie("loginId");
		        }
		    });
		     
		    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
		    $("#member_id").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
		        if($("#save_id_chb").is(":checked")){ // ID 저장하기를 체크한 상태라면,
		        	var userInputId = $("#member_id").val();
		            setCookie("loginId", userInputId, 7); // 7일 동안 쿠키 보관
		        }
		    });
		});

		function setCookie(cookieName, value, exdays){
		    var exdate = new Date();
		    exdate.setDate(exdate.getDate() + exdays);
		    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
		    document.cookie = cookieName + "=" + cookieValue;
		}
		 
		function deleteCookie(cookieName){
		    var expireDate = new Date();
		    expireDate.setDate(expireDate.getDate() - 1);
		    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
		}
		 
		function getCookie(cookieName) {
		    cookieName = cookieName + '=';
		    var cookieData = document.cookie;
		    var start = cookieData.indexOf(cookieName);
		    var cookieValue = '';
		    if(start != -1){
		        start += cookieName.length;
		        var end = cookieData.indexOf(';', start);
		        if(end == -1)end = cookieData.length;
		        cookieValue = cookieData.substring(start, end);
		    }
		    return unescape(cookieValue);
		}
				
	
	</script>

	<body>
		<div id="wrap">
			<!-- skip_nav --> 
			<div id="skip_nav">  
				<!--a href="#nav" title="메인메뉴 바로가기">메인메뉴 바로가기</a-->
				<a href="#content" title="본문내용 바로가기">본문내용 바로가기</a>
			</div>
			<!-- //skip --> 
			
						
			<!-- container -->
			<div id="container" class="mb50">
				<div class="content_area login_area_box">
					<a href="/" title="신기술접수소 사업평가·관리 시스템 홈페이지 이동" class="logo">
						<h1 class="home_logo"><img src="/assets/user/images/main/logo.png" alt="신기술접수소 사업평가·관리 시스템"></h1>
					</a>
				</div>
				<p class="ta_c header_logo_p">사업평가 · 관리시스템입니다.</p>
				<section id="content">
					<div id="sub_contents">
					    <div class="content_area login_box_area">
							<h2><span class="font_blue">신기술 접수소 홈페이지</span>에 오신 것을 환영합니다.</h2>
							<!--<p class="login_info">해당 아이디로 로그인 후 홈페이지를 이용하시기 바랍니다.</p>-->
							
							<form action="/member/login" method="POST">
							
								<ul class="login_class clearfix">
								<!-- 로그인-->
									<li class="member_login_box">
										<div class="member_login">
											<img src="/assets/user/images/sub/member_login_img.png" alt="개인회원 로그인 이미지" />
											<h3 style="width:100%;text-align:center">로그인</h3>
											<ul class="login_form">
												<li><label for="member_id"></label>
													<input type="text" id="member_id" name="member_id" class="login_form_input text1" placeholder="아이디를 입력해주세요 (아이디는 영문+숫자)" />									
												</li>
												<li><label for="pwd"></label>
													<input type="password" id="pwd" name="pwd" class="login_form_input" placeholder="비밀번호를 입력해주세요 (6자 이상 ~ 20자 이하)" maxlength="20"></li>
												<li class="ta_l">
													<input type="checkbox" id="save_id_chb"/>
													<label for="save_id_chb">아이디 저장</label>
												</li>
											</ul>
											<ul class="login_button_box clearfix">
												<li><button type="submit" class="btn btn_blue2 login_btn">로그인</button></li>
												<li><button type="button" class="btn btn_blue member_btn" onclick="location.href='/user/fwd/signup/main'">회원가입</button></li>
											</ul>
											<ul class="login_search_button_box clearfix">
												<li><button type="button" class="white_btn id_search_btn" onclick="location.href='/user/fwd/login/find/id'">아이디 찾기</button></li>
												<li><button type="button" class="white_btn pw_search_btn" onclick="location.href='/user/fwd/login/find/pwd'">비밀번호 찾기</button></li>
											</ul>
										</div>
									</li>
								</ul>
							</form>
						</div>
					</div>								
				</section>
			</div>
			<!-- //container -->
			<!-- footer --> 
				<div id="footer" class="main_footer">
					<footer>
						<div class="footer_area">
							<!-- footer_left --> 
							<div class="footer_left">
								<div class="footer_content">
									<div class="footer_link_area clearfix">
										<ul class="fl">
											<li>
												<a href="/user/fwd/terms/tos" title="이용 약관">
													<span>이용 약관</span>
												</a>
											</li>
											<li>
												<a href="/user/fwd/terms/privatePolicy" title="개인정보 처리방침">
													<span>개인정보 처리방침</span>
												</a>
											</li>
											<li>
												<a href="/user/fwd/terms/roc" title="이메일무단 수집 거부">
													<span>이메일무단 수집 거부</span>
												</a>
											</li>
											<li>
												<a href="http://seoul-tech.com/web/intropage/intropageShow.do?page_id=e35c124aa9084e84bc8c663f9ae796cf" title="신기술 접수소 소개">
													<span>신기술 접수소 소개</span>
												</a>
											</li>
										</ul>
										<label for="footer_cooperation" class="hidden">협력기관</label>
										<select id="footer_cooperation" class="selectbox fr in_wp258 ace-select" name="select" onchange="javascript:go_url(this.options[this.selectedIndex].value);">
											<option value="협력기관">협력기관</option>
											<option value="http://www.seoul-tech.com/">신기술 접수소</option>
										</select> 
									</div>
									<div class="footer_addr_area clearfix">
										<div class="footer_logo fl"><img src="/assets/user/images/main/footer_logo.png" alt="신기술 접수소 사업평가관리시스템"></div>
										<div class="footer_addr_list fr">							
											<address>서울기술연구원(03909) | 서울특별시 마포구 매봉산로37 (상암동) DMC 산학협력연구센터 8층 | TEL. 02-6912-0941</address>
											<p>Copyright  신기술접수소 사업평가·관리 시스템 All rights reserved. </p>							
										</div>							
									</div>
								</div>
							</div>
							<!--// footer_left -->					
						</div>
					</footer>
				</div>
				<!-- //footer -->		
		</div>
		<!-- //wrap -->

		
    <script src="/assets/user/js/script.js"></script>
	</body>
</html>
