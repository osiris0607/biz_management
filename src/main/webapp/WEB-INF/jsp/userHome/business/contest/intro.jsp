<script type='text/javascript'>
	$(document).ready(function() 
	{
		btn_searchList_onclick(1);
	});

	/*******************************************************************************
	* Content Paging 조회
	*******************************************************************************/
	function btn_searchList_onclick(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/userHome/api/content/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");

		if ( gfn_isNull($("#search_text").val()) == false) {
			comAjax.addParam("keyword", $("#search_text").val() );
		}
		// proposal의 Type은 'P' 이다.
		comAjax.addParam("content_type", "C");

		comAjax.ajax();
	}
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
		var body = $("#ul_listBody");
		body.empty();
		
		if (total == 0) {
			var str = "<li class='ta_c'>조회된 내용이 없습니다.	</li>";
			body.append(str);
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "btn_searchList_onclick"
				};
			gfnRenderPaging(params);

			var index = 1;
			var str = "";
			g_searchList = data.result_data;
			$.each(g_searchList, function(key, value) {
				str += "<li class='clearfix'>";
				str += "	<div class='business_poster_area clearfix'>";
				str += "		<p class='business_poster_title'>" + value.content_title +"</p>";
				str += "		<div class='poster_image-container'>";
				str += "			<a href='javscript:void(0);' onclick='movePoster(\"" + index + "\");'>";
				str += "				<img id='poster_" + index + "' class='poster_preview-image' src='data:image/gif;base64," + value.return_upload_file_info.binary_content +"' alt='" + value.return_upload_file_info.description + "'>";
				str += "			</a>";
				str += "		</div>";
				str += "		<div class='business_poster_text_area fr'>";
				str += "			<textarea name='business_poster_text_title_outline_c1' id='business_poster_text_title_outline_c1' class='business_poster_text' disabled='disabled'>" + value.content_description + "</textarea>";
				str += "		</div>";
				str += "	</div>";
				str += "</li>";
				
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
	<h2 class="hidden">서브영역</h2>
	<!-- 서브 경로 -->
	<article class="sub_route">
		<h3 class="hidden">서브경로</h3>
		<div class="wrap_area">
			<ul>
				<li><a href="/" class="home"><i class="fas fa-home"></i><span class="hidden">홈</span></a></li>
				<li><a href="/userHome/fwd/business/contest/summary">주요사업 안내</a></li>
				<li><a href="/userHome/fwd/business/contest/summary">기술공모</a></li>
				<li><a href="/userHome/fwd/business/contest/intro">사업소개</a></li>
			</ul>	
		</div>
	</article>
	<!-- //서브 경로 -->
	
		
	<article class="contents">
		<div class="wrap_area clearfix">
			<!-- 서브 레프트메뉴 -->
			<div class="lnb" id="lnb">							
				<h2 class="lnb_title">주요사업 안내</h2>
				<ul class="lnb_menu">
					<li><a href="/userHome/fwd/business/proposal/summary">기술제안</a>
						<ul>
							<li><a href="/userHome/fwd/business/proposal/summary">사업개요</a></li>
							<li><a href="/userHome/fwd/business/proposal/intro">수행사업소개</a></li>
						</ul>
					</li>
					<li><a href="/userHome/fwd/business/match/summary">캠퍼스타운 기술매칭</a>
						<ul>
							<li><a href="/userHome/fwd/business/match/summary">사업개요</a></li>
						</ul>
					</li>
					<li class="on"><a href="/userHome/fwd/business/contest/summary">크라우드소싱 기술공모</a>
						<ul>
							<li><a href="/userHome/fwd/business/contest/summary">사업개요</a></li>
							<li class="on"><a href="/userHome/fwd/business/contest/intro">수행사업소개</a></li>
						</ul>
					</li>
					<li><a href="/userHome/fwd/business/exemplification/summary">태양광 사업</a></li>
				</ul>
			</div>
			<!-- //서브 레프트메뉴 -->
			
			<!-- 서브 컨텐츠 내용 -->
			<div class="sub_contents" id="sub_contents">
				<h2 class="sub_contents_title">기술공모</h2>
				<div class="announcemen_intro_area intro_area">
					<h3 class="title">사업소개</h3>
					<div class="list_search_top_area">							   
						<ul class="clearfix board_list_searchbox">							
							<li class="clearfix">
								<span class="title">키워드</span>								
								<span class="input_search"><label for="search_text" class="fl list_search_title hidden">검색어</label>
								<input type="text" id="search_text" class="form-control" />   
								<button type="button" onclick="$('#search_text').val('');" class="search_txt_del" title="검색어 삭제"><i class="fas fa-times"></i></button></span>
								<button type="submit" onclick="btn_searchList_onclick(1);" class="blue_btn2">조회</button>
							</li>
						</ul>						
					</div>	
					<div class="list_search_table">
						<div class="table_count_area">
							<div class="count_area clearfix mb10">
								<div class="mt20 fl" id="search_count">								   
								[총 <span class="font_blue">0</span>건]
								</div>
								<div class="link_site_btn_areamb10 fr">
									<a href="http://rnd.seoul-tech.com/user/fwd/announcement/main" target="_blank" class="blue_btn link_site">사업지원하기</a>
								</div>
							</div>
						</div>

						<div class="business_area">							
							<ul class="business_area_contents" id="ul_listBody">								
							</ul>
						</div>
						<!--페이지 네비게이션-->
					   	<input type="hidden" id="pageIndex" name="pageIndex"/>
					   	<div class="page" id="pageNavi"></div>  
					    <!--//페이지 네비게이션-->
					</div>							
				</div>
			</div>
			<!-- //서브 컨텐츠 내용 -->
		</div>
	</article>
</section>