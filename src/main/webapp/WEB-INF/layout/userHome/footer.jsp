<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer>					
	<!-- rolling_banner -->
	<div class="rolling_banner_area">					
		<div class="rolling_banner">
			<div class="wrap_area clearfix">
				<h2 class="hidden">연관 기관 롤링배너</h2>																
				<div class="rollingbanner_btn_box">
					<a href="javascript:void(0)" id="prev"><span class="hidden">이전</span></a>
					<a href="javascript:void(0)" id="stop"><span class="hidden">멈춤</span></a>
					<a href="javascript:void(0)" id="start"><span class="hidden">재생</span></a>
					<a href="javascript:void(0)" id="next"><span class="hidden">다음</span></a>
				</div>
				<div class="rolling_panel">
					<ul class="clearfix">
						<li><a href="https://www.si.re.kr/" target="_blank" title="서울연구원 바로가기"><span><img src="/assets/userHome/images/si.jpg" alt="서울연구원" /></span></a></li>
						<li><a href="https://www.seoul.go.kr/main/index.jsp" target="_blank" title="서울특별시 바로가기"><span><img src="/assets/userHome/images/seoul.jpg" alt="서울특별시" /></span></a></li>
						<li><a href="https://urban.seoul.go.kr/view/html/PMNU0000000000" target="_blank" title="서울도시계획 바로가기"><span><img src="/assets/userHome/images/urbans.jpg" alt="서울도시계획" /></span></a></li>
						<li><a href="https://www.sisul.or.kr/" target="_blank" title="서울시설공단 바로가기"><span><img src="/assets/userHome/images/sisul.jpg" alt="서울시설공단" /></span></a></li>
						<li><a href="https://safecity.seoul.go.kr/index.do" target="_blank" title="서울안전누리 바로가기"><span><img src="/assets/userHome/images/safecity.jpg" alt="서울안전누리" /></span></a></li>
						<li><a href="https://bus.go.kr/" target="_blank" title="서울대중교통 바로가기"><span><img src="/assets/userHome/images/bus.jpg" alt="서울대중교통" /></span></a></li>									
					</ul>
				</div>																
			</div>
		</div>					
	</div>
	<!-- //rolling_banner -->					
	
	<div class="copyright_area">
		<!-- 모바일 협력기관 -->
		<div class="m_b">
			<label for="foot_banner" class="hidden">협력기관</label>
			<select name="foot_banner" id="foot_banner" class="ace-select" onchange="if(this.value) location.href=(this.value);">
				<option value="">--협력기관--</option>
				<option value="https://www.si.re.kr/">서울연구원</option>
				<option value="https://www.seoul.go.kr/main/index.jsp">서울특별시</option>
				<option value="https://urban.seoul.go.kr/view/html/PMNU0000000000">서울도시계획</option>
				<option value="https://www.sisul.or.kr/">서울시설공단</option>
				<option value="https://safecity.seoul.go.kr/index.do">서울안전누리</option>
				<option value="https://bus.go.kr/">서울대중교통</option>
			</select>
		</div>
		<!-- //모바일 협력기관 -->
	
		<!-- copyright -->
		<div class="wrap_area">
			<img src="/assets/userHome/images/bottom_logo.png" alt="신기술접수소 로고 이미지" />
			<ul>
				<li><a href="https://www.sit.re.kr/kr/contents/customer_01/view.do" target="_blank" title="개인정보처리방침 페이지로 이동">개인정보처리방침</a></li>
				<li><a href="https://www.seoul.go.kr/helper/copyright.do" target="_blank" title="저작권 정책 페이지로 이동">저작권 정책</a></li>
				<li><a href="https://www.seoul.go.kr/helper/media.do" target="_blank" title="영상정보처리기기 운영 관리방침 페이지로 이동">영상정보처리기기 운영 관리방침</a></li>
				<li><a href="https://eungdapso.seoul.go.kr/Gud/Gud03/Gud0304/Gud0304_not.jsp" target="_blank" title="행정서비스 현장 페이지로 이동">행정서비스 현장</a></li>
			</ul>
			<address>
				<p>서울기술연구원(03909) 서울특별시 마포구 매봉산로37 (상암동) DMC 산학협력연구센터 8층 <span class="phone"><a href="tel:031-232-9383">TEL. 02-6912-0941</a></span></p>
				<p class="copy">CopyrightⓒSeoul Metropolitan Government all rights reserved.</p>
			</address>
		</div>
		<!-- //copyright -->
		</div>
</footer>
<!-- //footer -->