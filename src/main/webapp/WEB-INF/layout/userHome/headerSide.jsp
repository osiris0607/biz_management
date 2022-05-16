<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<!-- header -->
<header class="header">
	<div class="top_header_area">
		<div class="wrap_area">
			<div class="top_header_box clearfix">
				<ul class="fl seoul_logo">
					<li><a href="https://www.seoul.go.kr/main/index.jsp" target="_blank"><img src="/assets/userHome/images/seoul_logo.png" alt="서울특별시 로고" /></a></li>
				</ul>
				<ul class="fr top_header_link">
					<li><a href="http://rnd.seoul-tech.com/" target="_blank" title="평가관리 시스템 바로가기">평가관리 시스템</a></li>
					<li><a href="http://www.sit.re.kr/" target="_blank" title="서울기술연구원 바로가기">서울기술연구원</a></li>
				</ul>
				<!--<ul class="fr language">
					<li class="on"><a href="#" title="한글번역">KOR</a></li>
					<li><a href="#" title="영문번역">ENG</a></li>
				</ul>-->
			</div>
		</div>
	</div>
	<!-- menu -->
	<nav id="menu">
		<div class="wrap_area">					
			<div class="header_area clearfix">
				<h1 class="logo">
					<a href="/userHome/fwd/home/main" title="신기술접수소 로고"><img src="/assets/userHome/images/logo.png" alt="신기술접수소" /></a>
				</h1>
				<!-- 상단메뉴 -->
				<div id="nav_area">
					<div class="gnb">
						<div class="top_menu">
							<!-- 왼족 메뉴 bg -->
							<div class="nav_bg_box_left">
								<div class="nav_bg_box_img"></div>												
							</div>	
							<div class="nav_bg_box_right">
								<div class="nav_bg_area"></div>
							</div>
							<!-- //왼족 메뉴 bg -->
							<ul class="menu">
								<li>
									<a class="mn_a" href="/userHome/fwd/intro/main" title="소개 페이지로 이동">소개</a>
									<div class="sub_menu">
										<ul class="menu_2 sub1">
											<li><a href="/userHome/fwd/intro/main" title="소개 페이지로 이동">소개</a></li>								
										</ul>
									</div>
								</li>												
								<li>
									<a href="/userHome/fwd/business/proposal/summary" title="주요사업 안내 페이지로 이동">주요사업 안내</a>	 
									<div class="sub_menu">
										<ul class="menu_2 sub2">
											<li><a href="/userHome/fwd/business/proposal/summary" title="기술 제안 페이지로 이동">기술 제안</a></li>
											<li><a href="/userHome/fwd/business/match/summary" title="기술 매칭 페이지로 이동">기술 매칭</a></li>
											<li><a href="/userHome/fwd/business/contest/summary" title="기술 공모 페이지로 이동">기술 공모</a></li>
											<li><a href="/userHome/fwd/business/exemplification/summary" title="실증 사업 페이지로 이동">실증 사업</a></li>
										</ul>
									</div>
								</li>
								<li>
									<a href="/userHome/fwd/gallery/main" title="선정기술정보 페이지로 이동">선정기술정보</a>
									<div class="sub_menu">
										<ul class="menu_3 sub3">
											<li><a href="/userHome/fwd/gallery/main" title="선정기술 안내 페이지로 이동">선정기술 안내</a></li>
										</ul>
									</div>
								</li>
								<li>
									<a href="/userHome/fwd/announcement/notice/noticeMain" title="알림, 홍보 페이지로 이동">알림&middot;홍보</a>
									<div class="sub_menu">
										<ul class="menu_4 sub4">
											<li><a href="/userHome/fwd/announcement/notice/noticeMain" title="공고 및 공지 페이지로 이동">공지사항</a></li>
											<li><a href="/userHome/fwd/announcement/broadcast/broadcastMain" title="보도자료 페이지로 이동">보도자료</a></li>
										</ul>
									</div>
								</li>																					
							</ul>										
						</div>
						
						<!-- 전체 메뉴 bg -->
						<div class="nav_bg"><span></span></div>
						<!-- //전체 메뉴 bg -->	
					</div>								
				</div>
				<span class="allmenu fr">
					<a href="/userHome/fwd/intro/sitemap/main" title="사이트맵 페이지로 이동"><img src="/assets/userHome/images/allmenu.png" alt="사이트맵" /></a>				
				</span>
				<!-- //상단메뉴 -->	
								
				
				<!-- 반응형 전체 숨김메뉴 -->
				<div class="m-allmenu">
					<div class="menu_btn" id="hamburgerMenu">
						<a href="javascript:void(0);"><span class="hidden">반응형 메뉴 열기</span>    
							<i class="fas fa-bars"></i>
						</a>
					</div>
				</div>
				<div class="menu_bg"></div>
				<div class="sidebar_menu">
					<div class="close_btn">
						<a href="javascript:void(0);"><span class="hidden">반응형 메뉴 닫기</span>     
							<i class="fas fa-times"></i>
						</a>
					</div>							
					<ul class="menu_wrap">
						<li class="1depth">
							<a class="mn_a" href="javascript:void(0);" title="소개 페이지로 이동">소개</a>										
							<ul class="sub-m">
								<li><a href="/userHome/fwd/intro/main" title="소개 페이지로 이동">소개</a></li>								
							</ul>										
						</li>
						<li class="2depth">
							<a href="javascript:void(0);" title="주요사업 안내 페이지로 이동">주요사업 안내</a>										
							<ul class="menu_2 sub2 sub-m">
								<li><a href="javascript:void(0);" title="기술 제안 페이지로 이동">기술 제안</a>
									<ul>
										<li><a href="/userHome/fwd/business/proposal/summary" title="기술 제안 사업개요 페이지로 이동">- 사업개요</a></li>
										<li><a href="/userHome/fwd/business/proposal/intro" title="기술 제안 사업소개 페이지로 이동">- 사업소개</a></li>
									</ul>
								</li>
								<li><a href="javascript:void(0);" title="기술 매칭 페이지로 이동">기술 매칭</a>
									<ul>
										<li><a href="/userHome/fwd/business/match/summary" title="기술 매칭 사업개요 페이지로 이동">- 사업개요</a></li>													
									</ul>
								</li>
								<li><a href="/userHome/fwd/business/contest/summary" title="기술 공모 페이지로 이동">기술 공모</a>
									<ul>
										<li><a href="/userHome/fwd/business/contest/summary" title="기술 공모 사업개요 페이지로 이동">- 사업개요</a></li>
										<li><a href="/userHome/fwd/business/contest/intro" title="기술 공모 사업소개 페이지로 이동">- 사업소개</a></li>
									</ul>
								</li>
								<li><a href="/userHome/fwd/business/exemplification/summary" title="실증 사업 페이지로 이동">실증 사업</a></li>
							</ul>
							
						</li>
						<li class="3depth">
							<a href="javascript:void(0);" title="선정기술정보 페이지로 이동">선정기술정보</a>									
							<ul class="menu_3 sub3 sub-m">
								<li><a href="/userHome/fwd/gallery/main" title="선정기술 안내 페이지로 이동">선정기술 안내</a></li>
							</ul>										
						</li>
						<li class="4depth">
							<a href="javascript:void(0);" title="알림, 홍보 페이지로 이동">알림&middot;홍보</a>										
							<ul class="menu_4 sub4 sub-m">
								<li><a href="/userHome/fwd/announcement/notice/noticeMain" title="공고 및 공지 페이지로 이동">공지사항</a></li>
								<li><a href="/userHome/fwd/announcement/broadcast/broadcastMain" title="보도자료 페이지로 이동">보도자료</a></li>
							</ul>										
						</li>
					</ul>					 
				</div>				
				<!-- //반응형 전체 숨김메뉴 -->											
				
			</div><!--//header_area-->
		</div>				
	</nav>
	<!-- //menu -->
	
</header>
<!-- //header -->