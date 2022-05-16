<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />


<script type='text/javascript'>

	// 리스트 
	var g_searchList;
	// content 수정을 위한 content Id를 찾기위한 Index
	var g_modificationIndex;

	$(document).ready(function() {
		btn_searchList_onclick(1);
	});

	/*******************************************************************************
	* Content Paging 조회
	*******************************************************************************/
	function btn_searchList_onclick(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("/adminHome/api/board/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");

		if ( gfn_isNull($("#search_text").val()) == false) {
			comAjax.addParam("keyword", $("#search_text").val() );
		}
		// broadcast의 Board Type은 'B' 이다.
		comAjax.addParam("board_type", "B");

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
			var str = "<tr>" + "<td colspan='14'>조회된 결과가 없습니다.</td>" + "</tr>";
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

			var index = 1;
			var str = "";
			g_searchList = data.result_data;
			$.each(g_searchList, function(key, value) {
				str += "<tr>";
				str += "	<td><input type='checkbox' name='cbx_deleteYn' class='checkboxs' value='" + value.board_id + "' /></td>";
				str += "	<td class='sequence'></td>";
				str += "	<td class='announcement_name write_title'><a href='/adminHome/board/broadcast/detail?board_id=" + value.board_id +"'>" + value.title + "</a></td>";
				str += "	<td class='write_name'><span>" + value.writer + "</span></td>";
				str += "	<td class='date'>" + value.reg_date + "</td>";
				str += "	<td class='number'>" + value.hits + "</td>";
				if ( value.file_yn == "Y")
				{
					str += "	<td class='notice_write_attachfile'><i class='fas fa-save file_icon'></i></td>";	
				}
				else 
				{
					str += "	<td class='notice_write_attachfile'></td>";
				}
				str += "	<td class='check'>";
				str += "		<div class='notice_board_posting_check'>";
				if ( value.open_yn == "Y")
				{
					str += "			<input type='radio' id='cbx_noticeOpened" + index + "' name='cbx_openYn" + index + "' checked='checked' onclick='btn_openYn_onclick(\"" + value.board_id + "\", \"Y\");'/>";
					str += "			<label for='cbx_noticeOpened" + index + "' class='mr10'>게시</label>";
					str += "			<input type='radio' id='cbx_noticeUnopened" + index + "' name='cbx_openYn" + index + "' onclick='btn_openYn_onclick(\"" + value.board_id + "\", \"N\");' />";
					str += "			<label for='cbx_noticeUnopened" + index + "'>미게시</label>";
				}
				else 
				{
					str += "			<input type='radio' id='cbx_noticeOpened" + index + "' name='cbx_openYn" + index + "' onclick='btn_openYn_onclick(\"" + value.board_id + "\", \"Y\");'/>";
					str += "			<label for='cbx_noticeOpened" + index + "' class='mr10'>게시</label>";
					str += "			<input type='radio' id='cbx_noticeUnopened" + index + "' name='cbx_openYn" + index + "' checked='checked' onclick='btn_openYn_onclick(\"" + value.board_id + "\", \"N\");'/>";
					str += "			<label for='cbx_noticeUnopened" + index + "'>미게시</label>";
				}
				str += "		</div>";
				str += "	</td>";
				str += "</tr>";
	
				index++;
			});
			body.append(str);
		}
	}
	/*******************************************************************************
	* 공지 삭제 버튼
	*******************************************************************************/
	function btn_delete_onclick()
	{
		var formData = new FormData();
		$('input:checkbox[name="cbx_deleteYn"]:checked').each(function (index) {
			formData.append("delete_ids", $(this).val());
    	});

		$.ajax({
		    type : "POST",
		    url : "/adminHome/api/board/delete",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	$('.board_list_del_complete_popup_box').fadeIn(350);
		        	setTimeout(() => {
	    	            location.reload();
	    	        }, 2000);
		        } else {
		            alert("삭제 실패 하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}
	/*******************************************************************************
	* 게시 / 미게시 Radio 버튼
	*******************************************************************************/
	function btn_openYn_onclick(id, value)
	{
		// open_yn 값 Update
		var formData = new FormData();
		formData.append("board_id", id);
		formData.append("open_yn", value);

		$.ajax({
		    type : "POST",
		    url : "/adminHome/api/board/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
			        if ( value == "Y")
			        {
			        	alert("게시로 설정되었습니다.");
			        }
			        else 
			        {
			        	alert("미게시로 설정되었습니다.");
			        }
			        location.href = "/adminHome/board/broadcast/main";
		        } else {
		            alert("수정에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

</script>

<!-- section -->
<section id="content">	
	<h2 class="hidden">본문시작</h2>
	<!-- left_menu -->
	<nav id="left_menu">
		<h2 class="left_menu_title"><i class="far fa-list-alt"></i>게시판관리</h2>
		<ul class="left_menu_link">						
			<li><a href="/adminHome/board/notice/main">공지관리</a></li>
			<li class="on"><a href="/adminHome/board/broadcast/main">보도자료관리</a></li>
			<li><a href="/adminHome/board/poster/main">포스터관리</a></li>
			<li><a href="/adminHome/board/gallery/main">기술갤러리관리</a></li>
		</ul>	
	</nav>
	<!-- //left_menu -->
	
	<!-- 서브컨텐츠 -->
	<article class="contents sub_content">
		<h3 class="sub_title">보도자료관리</h3>
		<!-- list 검색 상단 -->
		<div class="list_search_top_area">							   
			<ul class="clearfix board_list_searchbox">							
				<li class="clearfix">
					<span class="title">키워드</span>								
					<span class="input_search"><label for="board_list_searchbox_search" class="fl list_search_title hidden">검색어</label>
					<input type="text" id="search_text" class="form-control" />   
					<button type="button" class="search_txt_del" onclick="$('#search_text').val('');"><i class="fas fa-times"></i></button></span>
					<button type="button" class="blue_btn2" onclick="btn_searchList_onclick(1);">조회</button>
				</li>
			</ul>						
		</div>		 
		<!-- //list 검색 상단 -->

		<!-- list 검색 결과 -->
		<div class="list_search_table">
			<div class="table_count_area">
				<div class="count_area clearfix mb10">
					<div class="fl mt20" id="search_count">								   
					[총 <span class="font_blue">0</span>건]
					</div>
					<div class="fr clearfix">
						<button type="button" class="gray_btn board_list_del fl mr5">삭제</button>									
						<a href="/adminHome/board/broadcast/registration" class="blue_btn link_btn fl">등록</a>											
					</div>
				</div>
			</div>

			<div class="list_table">
				<table class="list notice_list_table_board">
					<colgroup>
						<col style="width:5%">
						<col style="width:7%">
						<col style="width:28%">
						<col style="width:17%">
						<col style="width:12%">
						<col style="width:8%">
						<col style="width:7%">
						<col style="width:16%">
					</colgroup>
				    <thead>
					    <tr>
							<th scope="col"><input type="checkbox" id="allcheck" /><label for="allcheck" class="hidden">전체 삭제</label></th>
							<th scope="col">번호</th>
							<th scope="col">제목</th>
							<th scope="col">작성자</th>
							<th scope="col">등록일</th>
							<th scope="col">조회수</th>
							<th scope="col">첨부파일</th>
							<th scope="col">게시상태</th>
					    </tr>
				    </thead>
				    <tbody id="tby_listBody">
				   </tbody>
			    </table>   
			    <!--//검색 결과-->  
			   
			   	<!--페이지 네비게이션-->
			   	<input type="hidden" id="pageIndex" name="pageIndex"/>
			   	<div class="page" id="pageNavi"></div>  
			    <!--//페이지 네비게이션-->				
		    </div><!-- list_table-->
		</div>
		<!-- //list 검색 결과 -->
	</article>	
	<!-- //서브컨텐츠 -->
</section>
<!--// section -->


<!--popup-->
    <!-- 로그아웃 팝업 -->
    <div class="logout_popup_box popup_box">
	   <div class="popup_bg"></div>
	   <div class="logout_popup popup_contents">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">로그 아웃</h4>
		       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
			   <p><span class="font_blue">로그아웃</span> 하시겠습니까?</p>				   
		   </div>
		   <div class="popup_button_area_center">
			   <button type="button" class="blue_btn popup_close_btn" onclick="location.href='./login.html'">예</button>
			   <button type="button" class="gray_btn logout_popup_close_btn popup_close_btn">아니요</button>
		   </div>
	   </div>
    </div>
    <!-- //로그아웃 팝업 -->
	
	<!-- 게시물 삭제 팝업 -->
    <div class="board_list_del_popup_box popup_box">
	   <div class="popup_bg"></div>
	   <div class="board_list_del_popup popup_contents">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">삭제 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
			   <p>해당 게시물을 <span class="font_blue">삭제</span> 하시겠습니까?</p>				   
		   </div>
		   <div class="popup_button_area_center">
			   <button type="submit" class="blue_btn popup_close_btn" onclick="btn_delete_onclick();">예</button>
			   <button type="button" class="gray_btn logout_popup_close_btn popup_close_btn">아니요</button>
		   </div>
	   </div>
    </div>
    <!-- //게시물 삭제 팝업 -->

	<!-- 게시물 삭제 완료 팝업 -->
    <div class="board_list_del_complete_popup_box popup_box">
	   <div class="popup_bg"></div>
	   <div class="board_list_del_complete_popup popup_contents">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">삭제 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
			   <p><span class="font_blue">삭제 완료</span> 되었습니다.</p>				   
		   </div>
		   <div class="popup_button_area_center">
			   <button type="button" class="gray_btn popup_close_btn complate_del">닫기</button>
		   </div>
	   </div>
    </div>
    <!-- 게시물 삭제 완료 팝업 -->
