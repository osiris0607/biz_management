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
		<link rel="stylesheet" type="text/css" href="/assets/user/css/lib/tip-yellowsimple.css" />
		<script src="/assets/user/js/lib/jquery-3.3.1.min.js"></script>
		<script src="/assets/user/js/lib/all.min.js"></script>		
		<script src="/assets/user/js/lib/jquery.nice-select.min.js"></script>
		<script src="/assets/user/js/lib/jquery.poshytip.js"></script>
	</head>

	<body>
		<div id="wrap">
			<!-- skip_nav --> 
			<div id="skip_nav">  
				<!--a href="#nav" title="메인메뉴 바로가기">메인메뉴 바로가기</a-->
				<a href="#content" title="본문내용 바로가기">본문내용 바로가기</a>
			</div>
						
			<!-- container -->
			<div id="container" class="mb50">
				<div class="content_area login_area_box">
					<a href="./index.html" title="신기술접수소 사업평가·관리 시스템 홈페이지 이동" class="logo">
						<h1 class="home_logo"><img src="/assets/user/images/main/logo.png" alt="신기술접수소 사업평가·관리 시스템"></h1>
					</a>
				</div>
				<p class="ta_c header_logo_p">사업평가 · 관리시스템 이용자 사이트입니다.</p>
				<section id="content">
					<div id="sub_contents">
						<div class="content_area">
							<div class="member_sign_box">
								<div class="expert_step_box">
									<h3 class="hidden">회원가입 완료</h3>
									<div class="member_sign_end">
										<p class="member_sign_end_txt1" style="font-size: 28px;"><span class="font_blue">전문가 등록 및 업데이트</span>가 완료되었습니다!</p>
										<p class="member_sign_end_txt2"><span class="font_blue">로그인 후 </span>서비스 이용이 가능합니다.</p>
									</div>
								

									<div class="table_area">
										<table class="write fixed">
										<caption>회원가입 완료 정보</caption>
											<colgroup>
												<col style="width: 50%;">																		
												<col style="width: 50%;">
											</colgroup>
											<tbody>
												<tr>
													<th scope="row" class="first"><span>성명</span></th>
													<td class="last"><c:out value='${vo.name}'/></td>	
												</tr>									  
												<tr>
													<th scope="row" class="first"><span>아이디</span></th>
													<td class="last"><span><c:out value='${vo.member_id}'/></span>
													</td>
												</tr>											
											</tbody>
										</table>																										
									</div>
									
									<div class="btn_box clearfix mt20 mb20">
										<button type="button" class="blue_btn fl" onclick="location.href='/user/fwd/login/memberLogin'" title="로그인화면 바로가기">로그인 화면</button><button type="button" class="gray_btn2 fl" onclick="location.href='/'" title="메인페이지 바로가기">메인페이지</button>
									</div>
								</div>

							</div>							
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
											<!--li>
												<a href="#" title="저작권 정책">
													<span>저작권 정책</span>
												</a>
											</li>
											<li>
												<a href="#" title="영상정보처리기기 운영 관리방침">
													<span>영상정보처리기기 운영 관리방침</span>
												</a>
											</li>
											<li>
												<a href="#" title="홈페이지 바로가기">
													<span>홈페이지 바로가기</span>
												</a>
											</li>
											<li>
												<a href="#" title="행정서비스 현장">
													<span>행정서비스 현장</span>
												</a>
											</li-->
										</ul>
										<label for="footer_cooperation" class="hidden">협력기관</label>
										<select id="footer_cooperation" class="selectbox fr in_wp258 ace-select" name="select" onchange="javascript:go_url(this.options[this.selectedIndex].value);">
											<option value="협력기관">협력기관</option>
											<option value="http://www.seoul-tech.com/">신기술 접수소</option>
										</select> 
									</div>
									<div class="footer_addr_area clearfix">
										<div class="footer_logo fl"><img src="../images/main/footer_logo.png" alt=""></div>
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
