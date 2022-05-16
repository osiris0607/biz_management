<script type='text/javascript'>

	$(document).ready(function() {
		searchNoticeList(1);
		searchPosterList(1);
	});

	function formatDate(date) {
	    
	    var d = new Date(date),
	    
	    month = '' + (d.getMonth() + 1) , 
	    day = '' + d.getDate(), 
	    year = d.getFullYear();
	    
	    if (month.length < 2) month = '0' + month; 
	    if (day.length < 2) day = '0' + day; 
	    
	    return [year, month, day].join('-');
	    
	    }
	/*******************************************************************************
	* 포스터 조회
	*******************************************************************************/
	function searchPosterList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/userHome/api/board/search/paging");
		comAjax.setCallback(searchPosterListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
	
		comAjax.addParam("open_yn", "Y");
		// 포스터의 Board Type은 'P' 이다.
		comAjax.addParam("board_type", "P");
	
		comAjax.ajax();
	}
	function searchPosterListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#div_posterList");
		body.empty();


		if (total == 0) 
		{
			var str = "";
			str += "<div class='swiper-slide slide1'>";
			str += "	<div class='title announcement_name1'>등록된 포스터가 없습니다.</div>";
			str += "</div>"
			body.append(str);
		} 
		else 
		{
			var str = "";
			var index = 1;
			$.each(data.result_data, function(key, value) {
				// 3개만 개시한다.
				if (index > 6) 
				{
					return false;
				}
				str += "<div class='swiper-slide slide" + index + "'>";
				str += "	<a href='javscript:void(0);' onclick='movePoster(\"" + index + "\");'>";
				str += "		<img id='poster_" + index + "' src='data:image/gif;base64," + value.return_upload_image_file_info[0].binary_content + "' alt='poster 이미지' />";
				str += "	</a>";
				str += "</div>";
					
				index++;
			});
			body.append(str);
		}
	}
	/*******************************************************************************
	* 공지사항 조회
	*******************************************************************************/
	function searchNoticeList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/userHome/api/board/search/paging");
		comAjax.setCallback(searchNoticeListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");
	
		comAjax.addParam("open_yn", "Y");
		// notice의 Board Type은 'N' 이다.
		comAjax.addParam("board_type", "N");
	
		comAjax.ajax();
	}
	function searchNoticeListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#div_noticeList");
		body.empty();

		if (total == 0) 
		{
			var str = "";
			str += "<div class='swiper-slide slide1'>";
			str += "	<div class='title announcement_name1'>등록된 공지사항이 없습니다.</div>";
			str += "</div>"
			body.append(str);
		} 
		else 
		{
			var str = "";
			var index = 1;
			$.each(data.result_data, function(key, value) {
				
				//date format
				var date = formatDate(value.reg_date);
				
				
				// 3개만 개시한다. -> 게시수량 제한 없음으로 변경됨_0509
				//if (index > 5) 
				//{
				//	return false;
				//}
				str += "<div class='swiper-slide slide" + index + "'>";
				str += "	<div class='title announcement_name1'>";
				str += "		<a href='/userHome/fwd/announcement/notice/noticeDetail?board_id=" + value.board_id +"'>" + value.title + "</a>";
				str += "	</div>";
				str += "	<div class='title announcement_name4'>";
				str += "		<a href='/userHome/fwd/announcement/notice/noticeDetail?board_id=" + value.board_id +"'>" + unescapeHtml(value.description) + "</a>";
				str += "	</div>";
				str += "	<div class='data_day_area'>";
				str += "		<span class='data_day'>" + date + "</span>";
				str += "		<span class='data_writer'>"  + value.writer + "</span>";
				str += "	</div>";
				str += "</div>";
					
				index++;
			});
			body.append(str);
		}
	}

	function movePoster(index)
	{
		var image = new Image();
        image.src = $("#poster_" + index).attr("src");

        var w = window.open("");
        w.document.write(image.outerHTML);
	}
</script>


<section>	
	<h2 class="t_indent">메인영역</h2>
	<article class="main">					
		<!-- 메인 텍스트 -->
		<div class="main_txt">
			<p>기술혁신으로 달라지는 서울의 미래</p>
			<em>신기술 접수소</em>
		</div>
		<!-- //메인 텍스트 -->

		<!-- 메인이미지 -->
		<!--<img src="/assets/userHome/images/index_bg.png" alt="메인이미지" class="main_img pc_img" />-->
		<!-- //메인이미지 -->					

		<!-- 빠른 링크 -->
		<div class="quick_link">
			<div class="wrap_area">
				<ul class="clearfix">
					<li><span>Quick Site</span></li>
					<li><a href="http://rnd.seoul-tech.com/" target="_blank" title="평가관리시스템 바로가기">평가관리시스템 <br />(사업지원하기)</a></li>
								<li><a href="./business_examination.html" target="_self" title="실증사업 바로가기">실증사업</a></li>
								<li><a href="http://www.sit.re.kr/" target="_blank" title="서울기술연구원 바로가기">서울기술연구원</a></li>
				</ul> 
			</div>
		</div>
	</article>
	<!-- //빠른 링크 -->				

	<!-- poster_data -->
	<article class="poster_data">
		<h2 class="t_indent">poster & data</h2>
		<div class="wrap_area clearfix">
			<!-- poster -->
			<div class="poster">
				<div class="swiper mySwiper2 swiper-container s2">
					<div class="swiper-wrapper" id="div_posterList">
					</div>
					<div class="swiper-button-next"><i class="fas fa-chevron-right"></i></div>
					<div class="swiper-button-prev"><i class="fas fa-chevron-left"></i></div>
					<div class="swiper-pagination"></div>	 
					<div class="slide_btn2">
						<button class="start2 on"><i class="fas fa-play"></i></button>
						<button class="stop2"><i class="fas fa-pause"></i></button>
					</div>
				</div>						
			</div>
			<!-- //poster -->

			<!-- data -->
			<div class="data clearfix">			
				<a href="/userHome/fwd/announcement/notice/noticeMain" title="공지사항 게시판 페이지로 이동" class="more_btn"><i class="fas fa-plus"></i></a>
				<div class="swiper mySwiper3 swiper-container s3">
					<h3>공지사항</h3>								
					<div class="swiper-wrapper" id="div_noticeList">
					</div>
					<div class="bottom clearfix">
						<div class="swiper-button-prev"><i class="fas fa-chevron-left"></i></div>									
						<div class="slide_btn3">
							<button class="start3"><i class="fas fa-play"></i></button>
							<button class="stop3"><i class="fas fa-pause"></i></button>
						</div>
						<div class="swiper-button-next"><i class="fas fa-chevron-right"></i></div>
						<div class="swiper-pagination"></div>
					</div>
				</div>							
			</div>
			<!-- //data -->
		</div>				
	</article>
	<!-- //poster_data -->

	<!-- movie -->
	<article class="main_movie" id="main_contents">
		<h2 class="t_indent">movie</h2>
		<div class="wrap_area">						
			<div class="movie_box_area">
				<div class="movie_box movie-slider">
					<div class="swiper mySwiper swiper-container s1">
						<div class="swiper-wrapper">
							<div class="swiper-slide slide1">											
								<iframe id="player0" width="560" height="315" src="https://www.youtube.com/embed/h6J8-EPzdRo?enablejsapi=1&html5=1&rel=0" title="신기술 접수소 동영상"></iframe>	
							</div>
							<div class="swiper-slide slide2">
								<iframe  id="player1" width="560" height="315" src="https://www.youtube.com/embed/iGQ1tAE8-50?enablejsapi=1&html5=1&rel=0" title="신기술 접수소 동영상"></iframe>		
							</div>
							<div class="swiper-slide slide3">
								<iframe  id="player2" width="560" height="315" src="https://www.youtube.com/embed/I9PwXak35qc?enablejsapi=1&html5=1&rel=0" title="신기술 접수소 동영상"></iframe>		
							</div>
							<div class="swiper-slide slide4">
								<iframe  id="player3" width="560" height="315" src="https://www.youtube.com/embed/v3-0Jhu_DoU?enablejsapi=1&html5=1&rel=0" title="신기술 접수소 동영상"></iframe>		
							</div>
							<div class="swiper-slide slide5">
								<iframe  id="player4" width="560" height="315" src="https://www.youtube.com/embed/hLZRqT_qg1k?enablejsapi=1&html5=1&rel=0" title="신기술 접수소 동영상"></iframe>											
							</div>						  
						</div>									
						<div class="swiper-pagination"></div>			
					</div>
					<div class="btn_box">									
						<div class="swiper-button-next -dark"><span>다음 영상</span></div>
						<div class="swiper-button-prev -dark"><span>이전 영상</span></div>
					</div>
					<!--<iframe width="588" height="337" src="https://www.youtube.com/embed/US9jgMkapv4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>-->
					<div class="movie_txt">
						<span>당신의 아이디어가 <span class="font-b">서울의 미래</span>를 바꿉니다</span>
					</div>
				</div>							
			</div>												
		</div>					
	</article>
	<!-- //movie -->
</section>