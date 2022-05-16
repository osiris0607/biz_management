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
		<link rel="stylesheet" type="text/css" href="/assets/user/css/style.css" />		
		<link rel="stylesheet" href="/assets/user/css/lib/jquery-ui.min.css" />
		<script src="/assets/user/js/lib/jquery-3.3.1.min.js"></script>
		<script src="/assets/user/js/lib/all.min.js"></script>		
		<script src="/assets/user/js/lib/jquery.nice-select.min.js"></script>
		<script src="/assets/user/js/lib/jquery-ui.js"></script>
		<script src="/assets/common/js/common_anchordata.js"></script>
	</head>
	
	<script type='text/javascript'>
		function findID() {
			var chkVal = ["name", "mobile_phone_1", "mobile_phone_2", "mobile_phone_3"];
			for (var i = 0; i < chkVal.length; i++) 
			{
				if ($("#" + chkVal[i]).val() == "" ) {
					showPopup($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.", "아이디 찾기 안내");
					$("#" + chkVal[i]).focus();
					return false;
				}
			}
			
			var formData = new FormData();
			formData.append("name", $("#name").val());
			var temp = $("#mobile_phone_selector").val() + "-" + $("#mobile_phone_2").val() + "-" + $("#mobile_phone_3").val();
			formData.append("mobile_phone", temp);
			
			$.ajax({
			    type : "POST",
			    url : "/user/api/login/find/id",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			    	if (jsonData.result == true) {
			    		$("#found_id").text(jsonData.result_data.member_id);
			    		$("#find_id_area").show();
			    	}
			    	else {
			    		showPopup("입력하신 정보에 해당하는 아이디가 존재하지 않습니다.", "아이디 찾기 안내");
			    	}
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}

		function showPopup(content, title) {
			if ( gfn_isNull(title) != true ) {
				$("#popup_title").html(title);
			}
		 	$("#id_check_info").html(content);
			$('.id_check_info_popup_box, .id_check_info_popup_box .popup_bg').fadeIn(350);
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

					    <!--아이디 찾기 입력란-->
						<div class="content_area login_box_area">
							<h2 style="font-size: 24px;"><span class="font_blue">이름, 휴대폰번호</span>를 통한 본인 확인 절차가 완료되면 등록하신 <span class="font_blue">아이디</span>를 찾으실 수 있습니다.</h2>
							<!--<p class="login_info">해당 아이디로 로그인 후 홈페이지를 이용하시기 바랍니다.</p>-->
							<ul class="login_class clearfix">
								<!-- 로그인-->
								<li class="member_login_box" style="height: 457px">
									<div class="member_login">
										<img src="/assets/user/images/sub/member_login_img.png" alt="개인회원 로그인 이미지" />
										<h3 style="width:100%;text-align:center">아이디 찾기</h3>
										<ul class="login_form">
											<li>
												<form action="" class="w80 clearfix" style="margin: 0 auto;">
													<label for="name" class="fl mt10" style="margin-right: 62px;">이름</label>
													<input type="text" title="이름" id="name" class="fl" style="width: 73.7%;"  placeholder="이름를 입력해 주세요." />
												</form>
											</li>
											<li class="mt10">
												<form action="" class="w80 clearfix" style="margin: 0 auto;">
													<label for="mobile_phone_selector" class="fl mt10" style="margin-right: 33px;">휴대전화</label>
													<select name="mobile_phone_1" title="휴대전화 번호" id="mobile_phone_selector" class="w_8 fl tel_selectbox">
														<option value="010">010</option>
													</select>
													<span style="display:block;" class="fl mc8">-</span>
													<label for="mobile_phone_2" class="hidden">전화</label>
													<input type="tel" title="휴대전화 번호" id="mobile_phone_2" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block w_6 fl d_input ls">
													<span style="display:block;" class="fl mc8">-</span>
													<label for="mobile_phone_3" class="hidden">전화</label>
													<input type="tel" title="휴대전화 번호" id="mobile_phone_3" maxlength="4" oninput="numberOnlyMaxLength(this);" class="form-control brc-on-focusd-inline-block fl d_input ls" style="width:62px;">
												</form>
											</li>												
										</ul>
										<button type="button" class="btn btn_blue member_btn w80 mt30" onclick="findID();">아이디 찾기</button>				
									</div>
								</li>								
							</ul>
						</div>
						<!--//아이디 찾기 입력란-->
						
						<!--아이디 찾기 검색 완료-->
						<div class="content_area login_box_area" id="find_id_area" style="display:none">
							<h2 style="font-size: 24px;">등록하신 <span class="font_blue">아이디</span>는 다음과 같습니다.</h2>							
							<div class="login_class clearfix" style="width: 80%;">								
								<div class="member_login_box" style="height: 157px">
									<div class="member_login">
										<div class="id_search_complate">
											<span id="found_id" style="line-height: 125px;">abc123</span>
										</div>																	
									</div>
								</div>								
							</div>
							<div class="btn_box clearfix mt20 mb20 w80" style="margin: auto;padding-top: 20px;">
								<button type="button" class="blue_btn fl w50" style="height: 50px;margin-right: 1%;" onclick="location.href='/user/fwd/login/memberLogin'" title="로그인화면 바로가기">로그인 화면</button>
								<button type="button" class="gray_btn2 fl" style="width: 49%;height: 50px;" onclick="location.href='/user/fwd/login/find/pwd'" title="비밀번호 찾기">비밀번호 찾기</button>
							</div>
						</div>
						<!--//아이디 찾기 검색 완료-->

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
												<a href="./tos.html" title="이용 약관">
													<span>이용 약관</span>
												</a>
											</li>
											<li>
												<a href="./privacy_policy.html" title="개인정보 처리방침">
													<span>개인정보 처리방침</span>
												</a>
											</li>
											<li>
												<a href="./roc.html" title="이메일무단 수집 거부">
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
		<!--아이디 중복 팝업-->
		<div class="id_check_info_popup_box">
			<div class="popup_bg"></div>
			<div class="id_check_info_popup">
				<div class="popup_titlebox clearfix">
					<h4 class="fl" id="popup_title"></h4>
					<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
				</div>					
				<div class="popup_txt_area">
					<div class="popup_txt_areabg">
						<p id="id_check_info" tabindex="0"></p>	
						<!--p tabindex="0">입력하신 <span class="font_blue">000</span> 아이디는 사용이 가능합니다.</p-->
					</div>
					
					<div class="popup_button_area_center">
						<button type="button" class="blue_btn popup_close_btn" title="확인">확인</button>
					</div>
				</div>						
			</div> 
		</div>
		<!--//아이디 중복 팝업-->
		
    <script src="/assets/user/js/script.js"></script>
	</body>
</html>
