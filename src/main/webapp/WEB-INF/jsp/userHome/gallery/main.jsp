<script type='text/javascript'>

	$(document).ready(function() {
		btn_searchList_onclick(1);
	});

	
	/*******************************************************************************
	* Paging 조회
	*******************************************************************************/
	function btn_searchList_onclick(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/userHome/api/board/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");

		
		if ( gfn_isNull($("#search_select").val()) == false)
	 	{
			comAjax.addParam($("#search_select").val(), $("#search_text").val() );
		}
		else 
		{
			comAjax.addParam("keyword", $("#search_text").val() );
		}

		comAjax.addParam("open_yn", "Y");
		
		// Galley의 Board Type은 'G' 이다.
		comAjax.addParam("board_type", "G");
	
		comAjax.ajax();
	}
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
		var body = $("#ul_listBody");
		body.empty();
		
		if (total == 0) 
		{
			var str = "<li class='ta_c'>조회된 내용이 없습니다.</li>";
			body.append(str);
			$("#pageIndex").empty();
		} 
		else 
		{
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "btn_searchList_onclick",
					recordCount : 9
				};
			gfnRenderPaging(params);
	
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<li>";
				str += "	<a href='/userHome/fwd/gallery/detail?board_id=" + value.board_id +"'>";
				str += "		<img src='data:image/gif;base64," + value.return_upload_image_file_info[0].binary_content + "' alt='갤러리 이미지' />";
				str += "		<ul>";
				str += "			<li class='tech_name'><span>" + value.title + "</span></li>";
				str += "			<li class='company_name'><span>" + value.institue_name + "</span></li>";
				str += "		</ul>";
				str += "	</a>";
				str += "</li>";
			});
			body.append(str);
		}
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
				<li><a href="/userHome/fwd/gallery/main">기술 갤러리</a></li>
				<li><a href="/userHome/fwd/gallery/main">선정기술 안내</a></li>
			</ul>	
		</div>
	</article>
	<!-- //서브 경로 -->
	
		
	<article class="contents">
		<div class="wrap_area clearfix">
			<!-- 서브 레프트메뉴 -->
			<div class="lnb" id="lnb">
				<h2 class="lnb_title">기술 갤러리</h2>
				<ul class="lnb_menu">
					<li class="on"><a href="/userHome/fwd/gallery/main">선정기술 안내</a></li>
				</ul>
			</div>
			<!-- //서브 레프트메뉴 -->
			
			<!-- 서브 컨텐츠 내용 -->
			<div class="sub_contents" id="sub_contents">
				<h2 class="sub_contents_title">기술 갤러리</h2>
				<div class="board_gallery_area gallery_list_area">	
					<div class="list_search_top_area">	
						<div class="board_list_searchbox">								
							<label for="search_select" class="hidden">검색</label>
							<select name="search_select" id="search_select" class="ace-select">
								<option value="">전체</option>										
								<option value="business_name">사업명</option>
								<option value="title">기술명</option>
								<option value="institue_name">기관명</option>									
							</select>						
							<span class="input_search">
								<label for="search_text" class="fl list_search_title hidden">검색어</label>
								<input type="text" id="search_text" class="form-control" />   
								<button type="button" onclick="$('#search_text').val('');" class="search_txt_del" title="검색어 삭제"><i class="fas fa-times"></i></button>
							</span>
							<button type="button" onclick="btn_searchList_onclick(1);" class="blue_btn2">조회</button>							
						</div>
					</div>	
					
					<!-- list 검색 결과 -->
					<div class="list_search_table">
						<div class="table_count_area">
							<div class="count_area clearfix mb10" id="search_count">
								<div class="fl mt20">								   
								[총 <span class="font_blue">0</span>건]
								</div>								
							</div>
						</div>

						<div class="list_tablex">
							<ul class="gallery_list clearfix" id="ul_listBody">
							</ul>  
							<!--//검색 결과--> 							
							
							<!--페이지 네비게이션-->
						   	<input type="hidden" id="pageIndex" name="pageIndex"/>
						   	<div class="page" id="pageNavi"></div>  
						    <!--//페이지 네비게이션-->							
						</div><!-- list_table-->
					</div>
					<!-- //list 검색 결과 -->
				</div>
			</div>
			<!-- //서브 컨텐츠 내용 -->
		</div>
	</article>
</section>