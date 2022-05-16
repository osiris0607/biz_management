<script type='text/javascript'>

	$(document).ready(function() {
		btn_searchList_onclick(1);
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
	* 공지 조회
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
		
		//공지사항게시판 -> 게시/미게시 구분 X
		//comAjax.addParam("open_yn", "Y");
		// notice의 Board Type은 'N' 이다.
		comAjax.addParam("board_type", "N");
	
		comAjax.ajax();
	}
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
		var body = $("#tby_listBody");
		body.empty();
		
		if (total == 0) 
		{
			var str = "<tr>" + "<td colspan='6'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#pageIndex").empty();
		} 
		else 
		{
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "btn_searchList_onclick"
				};
			gfnRenderPaging(params);
	
			/* 날짜포맷 */
			
			
			var index = 1;
			var str = "";
			g_searchList = data.result_data;
			$.each(g_searchList, function(key, value) {
				
				//date format
				var date = formatDate(value.reg_date);
				
				str += "<tr>";
				str += "	<td class='sequence'></td>";
				str += "	<td class='announcement_name write_title'><a href='/userHome/fwd/announcement/notice/noticeDetail?board_id=" + value.board_id +"'>" + value.title + "</a></td>";
				str += "	<td class='company_name'><span>" + value.writer + "</span></td>";
				str += "	<td class='date'>" + date + "</td>";
				str += "	<td class='number'>" + value.hits + "</td>";
				if ( value.file_yn == "Y")
				{
					str += "	<td class='notice_write_attachfile'><i class='fas fa-save file_icon'></i></td>";	
				}
				else 
				{
					str += "	<td class='notice_write_attachfile'></td>";
				}
				str += "</tr>";
	
				index++;
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
				<li><a href="/userHome/fwd/announcement/notice/noticeMain">알림&middot;홍보</a></li>
				<li><a href="/userHome/fwd/announcement/notice/noticeMain">공지사항</a></li>
			</ul>
		</div>
	</article>
	<!-- //서브 경로 -->
	
		
	<article class="contents">
		<div class="wrap_area clearfix">
			<!-- 서브 레프트메뉴 -->
			<div class="lnb" id="lnb">
				<h2 class="lnb_title">알림&middot;홍보</h2>
				<ul class="lnb_menu">
					<li class="on"><a href="/userHome/fwd/announcement/notice/noticeMain">공지사항</a></li>
					<li><a href="/userHome/fwd/announcement/broadcast/broadcastMain">보도자료</a></li>
				</ul>
			</div>
			<!-- //서브 레프트메뉴 -->
			
			<!-- 서브 컨텐츠 내용 -->
			<div class="sub_contents" id="sub_contents">
				<div class="notice_link_title clearfix">
					<h2 class="sub_contents_title">공지사항</h2>
					<div class="notice_link_btn">
						<a href="https://rnd.seoul-tech.com/user/fwd/announcement/main" target="_blank" class="blue_btn link_site">사업지원하기</a>
					</div>
				</div>
				<div class="board_notice_area notice_list_area">	
					<div class="list_search_top_area">	
						<div class="board_list_searchbox">								
							<label for="search_select" class="hidden">검색</label>
							<select name="search_select" id="search_select" class="ace-select">
								<option value="">전체</option>
								<option value="title">제목</option>
								<option value="description">내용</option>
							</select>						
							<span class="input_search notice_search">
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
							<div class="count_area clearfix mb10">
								<div class="fl mt20" id="search_count">								   
								[총 <span class="font_blue">0</span>건]
								</div>								
							</div>
						</div>

						<div class="list_tablex notice_table_area">
							<table class="list notice_table">
								<caption>공지사항</caption>     
								<colgroup>									
									<col style="width:8%">
									<col style="width:40%">
									<col style="width:20%">
									<col style="width:14%">
									<col style="width:10%">
									<col style="width:10%">
								</colgroup>
								<thead>
									<tr>										
										<th scope="col">번호</th>
										<th scope="col">제목</th>
										<th scope="col">작성자</th>
										<th scope="col">등록일</th>
										<th scope="col">조회수</th>
										<th scope="col">첨부파일</th>										
									</tr>
								</thead>
								<tbody id="tby_listBody">
								</tbody>
							</table>   
							<!--//검색 결과--> 														
						</div><!-- list_table-->
						
						<!--페이지 네비게이션-->
					   	<input type="hidden" id="pageIndex" name="pageIndex"/>
					   	<div class="page" id="pageNavi"></div>  
					    <!--//페이지 네비게이션-->		
					    			
					</div>
					<!-- //list 검색 결과 -->
				</div>
			</div>
			<!-- //서브 컨텐츠 내용 -->
		</div>
	</article>
</section>