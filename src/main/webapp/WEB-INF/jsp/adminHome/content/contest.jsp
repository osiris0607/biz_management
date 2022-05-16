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
		comAjax.setUrl("/adminHome/api/content/search/paging");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "REG_DATE DESC");

		if ( gfn_isNull($("#search_text").val()) == false) {
			comAjax.addParam("keyword", $("#search_text").val() );
		}
		// contest의 Type은 'C' 이다.
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
			var str = "<li class='ta_c'>등록된 게시물이 없습니다.</li>";
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
				str += "		<input type='text' id='ibx_title" + index + "' title='제목' class='form-control business_poster_title' value='" + value.content_title + "' />";
				str += "		<div class='poster_image-container'>";
				str += "			<img id='img_poster" + index + "' class='poster_preview-image' src='data:image/gif;base64," + value.return_upload_file_info.binary_content +"' alt='" + value.return_upload_file_info.description + "'>";
				str += "			<label for='poster_input-image" + index + "'>파일 선택</label>";
				str += "			<input style='display: block;' type='file' id='poster_input-image" + index + "' class='hidden poster_input-image'>";
				str += "			<input id='poster_upload-name" + index + "' class='poster_upload-name'  placeholder='첨부파일'>";
				str += "		</div>";
				str += "		<div class='business_poster_text_area fr'>";
				str += "			<textarea id='txa_description" + index + "' title='내용' name='business_poster_text_title_outline_c2' class='business_poster_text'>" + value.content_description + "</textarea>";
				str += "		</div>";
				str += "	</div>";
				str += "	<div class='buttonarea fr'>";
				str += "		<button type='button' class='blue_btn modify_btn' onclick='g_modificationIndex = " + index +";'>수정</button>";
				str += "		<button type='button' class='gray_btn2 poster_list_cancel' onclick='btn_cancelModification_onclick(\"" + index + "\");'>취소</button>";
				str += "		<button type='button' class='gray_btn poster_list_del' onclick='g_modificationIndex = " + index +";'>삭제</button>";
				str += "	</div>";
				str += "</li>";
	
				index++;
			});
			body.append(str);
		}
	}
	/*******************************************************************************
	* Content 등록
	*******************************************************************************/
	function btn_registration_onclick(type){
		var chkVal = ["ibx_title", "txa_description"];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		}

		if ($("#input-image").val() == false ){
			alert("이미지 등록은 필수입니다.");
			return false;
		}

		var formData = new FormData();
		formData.append("content_title", $("#ibx_title").val());
		formData.append("content_type", type);
		formData.append("content_description", $("#txa_description").val());

		formData.append("upload_image_file", $("#input-image")[0].files[0]);

		$.ajax({
		    type : "POST",
		    url : "/adminHome/api/content/registration",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		        	$('.board_write_complete_popup_box').fadeIn(350);
		        	setTimeout(() => {
	    	            location.reload();
	    	        }, 2500);
		        } else {
		            alert("등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	/*******************************************************************************
	* Content 수정
	*******************************************************************************/
	function btn_modification_onclick(type)
	{
		var chkVal = ["ibx_title" + g_modificationIndex, "txa_description" + g_modificationIndex];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		}

		var formData = new FormData();
		// 실제 list는 0부터 시작한다. 리스트 Index에서 1을 뺀다.
		formData.append("content_id", g_searchList[g_modificationIndex-1].content_id);
		formData.append("image_file_id", g_searchList[g_modificationIndex-1].image_file_id);
		formData.append("content_title", $("#ibx_title" + g_modificationIndex).val());
		formData.append("content_type", type);
		formData.append("content_description", $("#txa_description" + g_modificationIndex).val());

		if ( gfn_isNull($("#poster_input-image" + g_modificationIndex).val()) == false ) 
		{
			formData.append("upload_image_file", $("#poster_input-image" + g_modificationIndex)[0].files[0]);
		}

		$.ajax({
		    type : "POST",
		    url : "/adminHome/api/content/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		        	$('.board_list_modify_complete_popup_box').fadeIn(350);
		        	setTimeout(() => {
	    	            location.reload();
	    	        }, 2000);
		        } else {
		            alert("등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}
	
	/*******************************************************************************
	* Content 수정 취소 버튼
	*******************************************************************************/
	function btn_cancelModification_onclick(index)
	{
		// 수정 취소 하였으므로 이전 데이터로 다시 세팅
		$("#ibx_title" + index).val(g_searchList[index-1].content_title);
		$("#txa_description" + index).val(g_searchList[index-1].content_description);
		$("#img_poster" + index).attr("src", "data:image/gif;base64," + g_searchList[index-1].return_upload_file_info.binary_content);
	}
	
	/*******************************************************************************
	* Content 삭제 버튼
	*******************************************************************************/
	function btn_delete_onclick()
	{
		var formData = new FormData();
		formData.append("content_id", g_searchList[g_modificationIndex-1].content_id);
		formData.append("image_file_id", g_searchList[g_modificationIndex-1].image_file_id);

		$.ajax({
		    type : "POST",
		    url : "/adminHome/api/content/delete",
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

</script>

<!-- section -->
<section id="content">	
	<!-- left_menu -->
	<nav id="left_menu">
		<h2 class="left_menu_title"><i class="far fa-folder-open"></i>콘텐츠관리</h2>
		<ul class="left_menu_link">
			<li class="on"><a href="/adminHome/content/proposal">주요사업소개</a>
				<ul>
					<li><a href="/adminHome/content/proposal">기술제안</a></li>
					<li class="on"><a href="/adminHome/content/contest">기술공모</a></li>
				</ul>
			</li>
		</ul>	
	</nav>
	<!-- //left_menu -->
	
	<!-- 서브컨텐츠 -->
	<article class="contents sub_content">
		<h3 class="sub_title">기술공모</h3>
		<!-- list 검색 상단 -->
		<div class="list_search_top_area">							   
			<ul class="clearfix board_list_searchbox">							
				<li class="clearfix">
					<span class="title">키워드</span>								
					<span class="input_search">
						<label for="board_list_searchbox_search" class="fl list_search_title hidden">검색어</label>
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
						<button type="button" class="blue_btn poster_list_add fl mr5">추가</button>										
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
		<!-- //list 검색 결과 -->
	</article>	
	<!-- //서브컨텐츠 -->
</section>


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

<!-- 게시물 수정 팝업 -->
<div class="board_list_modify_popup_box popup_box">
   <div class="popup_bg"></div>
   <div class="board_list_modify_popup popup_contents">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">수정 안내</h4>
	       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <p>해당 게시물을 <span class="font_blue">수정</span> 하시겠습니까?</p>				   
	   </div>
	   <div class="popup_button_area_center">
		   <button type="submit" class="blue_btn popup_close_btn"  onclick="btn_modification_onclick('C');">예</button>
		   <button type="button" class="gray_btn logout_popup_close_btn popup_close_btn">아니요</button>
	   </div>
   </div>
</div>
   <!-- //게시물 수정 팝업 -->

<!-- 게시물 수정 완료 팝업 -->
<div class="board_list_modify_complete_popup_box popup_box">
   <div class="popup_bg"></div>
   <div class="board_list_modify_complete_popup popup_contents">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">수정 안내</h4>
	       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <p><span class="font_blue">수정 완료</span> 되었습니다.</p>				   
	   </div>
	   <div class="popup_button_area_center">
		   <button type="button" class="gray_btn popup_close_btn complate_del">닫기</button>
	   </div>
   </div>
</div>
   <!-- 게시물 수정 완료 팝업 -->

<!-- 게시물 등록 팝업 -->
<div class="board_write_popup_box popup_box">
   <div class="popup_bg"></div>
   <div class="board_write_popup popup_contents">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">등록 안내</h4>
	       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <p>해당 게시물을 <span class="font_blue">등록</span> 하시겠습니까?</p>				   
	   </div>
	   <div class="popup_button_area_center">
		   <button type="button" class="blue_btn popup_close_btn" onclick="btn_registration_onclick('C');">예</button>
		   <button type="button" class="gray_btn logout_popup_close_btn popup_close_btn">아니요</button>
	   </div>
   </div>
</div>
   <!-- //게시물 등록 팝업 -->

<!-- 게시물 등록 완료 팝업 -->
<div class="board_write_complete_popup_box popup_box">
   <div class="popup_bg"></div>
   <div class="board_write_complete_popup popup_contents">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">등록 안내</h4>
	       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <p><span class="font_blue">등록 완료</span> 되었습니다.</p>				   
	   </div>
	   <div class="popup_button_area_center">
		   <button type="button" class="gray_btn popup_close_btn">닫기</button>
	   </div>
   </div>
</div>
<!-- 게시물 등록 완료 팝업 -->
