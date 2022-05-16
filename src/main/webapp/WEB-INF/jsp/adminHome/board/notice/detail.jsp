<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />


<script type='text/javascript'>


	$(document).ready(function() {
		searchDetail();
	});

	/*******************************************************************************
	* 공지사항 상세 조회
	*******************************************************************************/
	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/adminHome/api/board/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("board_id", $("#board_id").val());
		comAjax.ajax();
	}
	function searchDetailCB(data){
		console.log(data);
		if ( data.result == false){
			alert("공지 사항 정보가 없습니다. 다시 시도해 주시기 바랍니다.");
			return;
		}

		if (data.result_data.open_yn == "Y")
		{
			$("#txt_openYn").html("<span>게시</span>");
		}
		else 
		{
			$("#txt_openYn").html("<span>미게시</span>");
		}
		$("#txt_title").html("<p>" + data.result_data.title + "</p>");
		$("#txt_writer").html("<span>" + data.result_data.writer + "</span>");
		$("#txt_regDate").html(data.result_data.reg_date);
		$("#txt_description").html(unescapeHtml(data.result_data.description));


		var str = "";
		var index = 1;
		$("#div_attachFile").empty();
	    if ( data.result_data.return_upload_attach_file_info != null) 
	    {
	    	$.each(data.result_data.return_upload_attach_file_info, function(key, value) {
				str += "		<a href='/adminHome/api/board/download/" + value.file_id + "' download>";
				var extName = value.name.split('.').pop().toLowerCase();
				if (extName == "hwp" ) {
					str += "	<img src='/assets/adminHome/images/icon_hwp.png' alt='hwp' />" + value.name;
				}
				else if (extName == "pdf" ) {
					str += "	<img src='/assets/adminHome/images/icon_pdf.png' alt='pdf' />" + value.name;
				}
				else if (extName == "xlsx" || extName == "xls" ) {
					str += "	<img src='/assets/adminHome/images/icon_xlsx.png' alt='xlsx' />" + value.name;
				}
				else if (extName == "ppt" || extName == "pptx") {
					str += "	<img src='/assets/adminHome/images/icon_ppt.png' alt='ppt' />" + value.name;
				}
				else if (extName == "zip" ) {
					str += "	<img src='/assets/adminHome/images/icon_zip.png' alt='zip' />" + value.name;
				}
				else {
					str += value.name;
				}
				str += "</a>";
				index++;
			});
		}

	    $("#div_attachFile").append(str);
	}
	/*******************************************************************************
	* 공지 삭제 버튼
	*******************************************************************************/
	function btn_delete_onclick()
	{
		var formData = new FormData();
		formData.append("delete_ids", $("#board_id").val());

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
		        	$('.board_view_del_complete_popup_box').fadeIn(350);
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
<input type="hidden" id="board_id" name="board_id" value="${vo.board_id}" />
<section id="content">	
	<h2 class="hidden">본문시작</h2>
	<!-- left_menu -->
	<nav id="left_menu">
		<h2 class="left_menu_title"><i class="far fa-list-alt"></i>게시판관리</h2>
		<ul class="left_menu_link">						
			<li class="on"><a href="/adminHome/board/notice/main">공지관리</a></li>
			<li><a href="/adminHome/board/broadcast/main">보도자료관리</a></li>
			<li><a href="/adminHome/board/poster/main">포스터관리</a></li>
			<li><a href="/adminHome/board/gallery/main">기술갤러리관리</a></li>
		</ul>	
	</nav>
	<!-- //left_menu -->
	
	<!-- 서브컨텐츠 -->
	<article class="contents sub_content">
		<h3 class="sub_title">공지관리</h3>
		<div class="list_table">
			<table class="list2  view_table notice_table">
				<caption>공지관리</caption>     
				<colgroup>
					<col style="width:20%">
					<col style="width:80%">								
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">게시상태</th>	
						<td class="check">
							<div id="txt_openYn" class="notice_board_posting_check"></div>
						</td>
					</tr>
					<tr>
						<th scope="row">제목</th>
						<td class="write_title" id="txt_title"></td>			
					</tr>
					<tr>
						<th scope="row">작성자</th>	
						<td class="write_name" id="txt_writer"></td>
					</tr>
					<tr>
						<th scope="row">등록일</th>	
						<td class="date" id="txt_regDate"></td>
					</tr>								
					<tr>									
						<th scope="row">내용</th>	
						<td class="notice_write_text" id="txt_description"></td>
					</tr>  
					<tr>
						<th scope="row">첨부파일</th>	
						<td class="notice_write_attachfile">
							<!-- 업로드 -->
							<div class="view_attachfile" id="div_attachFile">
							</div>
							<!-- //업로드 -->
						</td>
					</tr>  
			    </tbody>
			</table>   
			<!--//검색 결과-->  
		     <div class="write_button_area">
				<button type="button" class="blue_btn" onclick="location.href='/adminHome/board/notice/modification?board_id=${vo.board_id}';">수정</button>
				<button type="button" class="gray_btn board_view_del">삭제</button>
				<button type="button" class="gray_btn2" onclick="location.href='/adminHome/board/notice/main'">목록</button>
			</div>
		</div><!-- list_table-->
		
	</article>	
	<!-- //서브컨텐츠 -->
</section>
<!--// section -->

<!-- 게시물 삭제 팝업 -->
    <div class="board_view_del_popup_box popup_box">
	   <div class="popup_bg"></div>
	   <div class="board_view_del_popup popup_contents">
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
    <div class="board_view_del_complete_popup_box popup_box">
	   <div class="popup_bg"></div>
	   <div class="board_view_del_complete_popup popup_contents">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">삭제 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
			   <p><span class="font_blue">삭제 완료</span> 되었습니다.</p>				   
		   </div>
		   <div class="popup_button_area_center">
			   <button type="button" class="gray_btn popup_close_btn" onclick="location.href='/adminHome/board/notice/main'">닫기</button>
		   </div>
	   </div>
    </div>
    <!-- 게시물 삭제 완료 팝업 -->