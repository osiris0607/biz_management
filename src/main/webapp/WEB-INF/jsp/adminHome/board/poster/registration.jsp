<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />


<script type='text/javascript'>
	var oEditors = [];
	$(document).ready(function() {
		nhn.husky.EZCreator.createInIFrame({
			oAppRef : oEditors,
			elPlaceHolder : "txa_description", //textarea에서 지정한 id와 일치해야 합니다. 
			//SmartEditor2Skin.html 파일이 존재하는 경로
			sSkinURI : "/assets/SE2/SmartEditor2Skin.html",
			htParams : {
				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseToolbar : true,
				// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,
				// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,
				fOnBeforeUnload : function() {
	
				}
			},
			fOnAppLoad : function() {
				//기존 저장된 내용의 text 내용을 에디터상에 뿌려주고자 할때 사용
				//oEditors.getById["explanation"].exec("PASTE_HTML",[ "기존 DB에 저장된 내용을 에디터에 적용할 문구" ]);
			},
			fCreator : "createSEditor2"
		});
		
	});
	/*******************************************************************************
	* poster 등록
	*******************************************************************************/
	function btn_registration_onclick(type){
		var chkVal = ["ibx_title"];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		}

		var emptyStr = oEditors.getById["txa_description"].getIR().replace(/(<([^>]+)>)/ig,"");
		if ( oEditors.getById["txa_description"].getIR() == null || emptyStr == "" ) {
			alert("내용은(는) 필수입력입니다.");
			return false;
		} 

		if ($("#input-image").val() == false ){
			alert("이미지 등록은 필수입니다.");
			return false;
		}

		var formData = new FormData();
		// 보도 자료 관리 Type은 "P" 이다.
		formData.append("board_type", type);
		formData.append("title", $("#ibx_title").val());
		formData.append("writer", $("#txt_writer").text());
		formData.append("description", oEditors.getById["txa_description"].getIR());
		formData.append("open_yn", $("input:radio[name=cbx_OpenYn]:checked").val());
		// 첨부파일 Type. 'D'(Document) : 첨부파일, ' P'(Picture) : 기술 이미지
		formData.append("file_type", "P");
		formData.append("file_yn", "Y");
		formData.append("upload_image_file", $("#input-image")[0].files[0]);

		$.ajax({
		    type : "POST",
		    url : "/adminHome/api/board/registration",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		        	$('.board_write_complete_popup_box').fadeIn(350);
		        	setTimeout(() => {
	    	            location.href = "/adminHome/board/poster/main";
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


</script>

<!-- section -->
<section id="content">
	<h2 class="hidden">본문시작</h2>
	<!-- left_menu -->
	<nav id="left_menu">
		<h2 class="left_menu_title"><i class="far fa-list-alt"></i>게시판관리</h2>
		<ul class="left_menu_link">						
			<li><a href="/adminHome/board/notice/main">공지관리</a></li>
			<li><a href="/adminHome/board/broadcast/main">보도자료관리</a></li>
			<li class="on"><a href="/adminHome/board/poster/main">포스터관리</a></li>
			<li><a href="/adminHome/board/gallery/main">기술갤러리관리</a></li>
		</ul>	
	</nav>
	<!-- //left_menu -->
	
	<!-- 서브컨텐츠 -->
	<article class="contents sub_content">
		<h3 class="sub_title">포스터관리</h3>
		<div class="list_table">
			<table class="list2 write_table data_table">
				<caption>포스터관리</caption>     
				<colgroup>
					<col style="width:20%">
					<col style="width:80%">								
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">게시상태</th>	
						<td class="check">
							<div class="data_board_posting_check">
								<input type="radio" id="board_data_check_posting" name="cbx_OpenYn" value="Y"  />
								<label for="board_data_check_posting" class="mr10">게시</label>
								<input type="radio" id="board_data_check_unpublished" name="cbx_OpenYn" value="N" checked="checked"/>
								<label for="board_data_check_unpublished">미게시</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="write_title">제목</label></th>
						<td class="write_title">
							<input id="ibx_title" title="제목" type="text" class="form-control"  />
						</td>				
					</tr>
					<tr>
						<th scope="row">작성자</th>	
						<td class="write_name" id="txt_writer"><span>신기술접수소 관리자</span></td>
					</tr>
					<tr>
						<th scope="row"><label for="data_write_text">내용</label></th>	
						<td class="data_write_text">
							<textarea id="txa_description" title="내용" name="data_write_text"></textarea>
						</td>
					</tr>  
					<tr>
						<th scope="row">첨부파일</th>	
						<td class="poster_write_attachfile">										
							<!-- 업로드 -->
							<div class="image-container">
								<img id="preview-image" class="poster_preview-image" src="https://dummyimage.com/300x400/ffffff/000000.png&text=preview+image" alt="갤러리 이미지">
								<span class="txt">( 가로 사이즈 : 300px / 세로 사이즈 : 400px )<br />실제작 사이즈 : ( 가로 사이즈 : 600px / 세로 사이즈 : 800px ) or ( 가로 사이즈 : 900px / 세로 사이즈 : 1200px )</span>
								<label for="input-image">파일 선택</label>
								<input style="display: block;" type="file" id="input-image" class="hidden poster_input-image" />							
								<label for="upload-name" class="hidden">첨부파일</label>
								<input class="poster_upload-name_sub upload-name" id="upload-name" value="첨부파일" placeholder="첨부파일">
							</div>
							<!-- //업로드 -->										
						</td>
					</tr> 
			    </tbody>
			</table>   
			<!--//검색 결과-->  
		     <div class="write_button_area">
			 	<button type="button" class="blue_btn board_write">등록</button>
				<button type="button" class="gray_btn2" onClick="history.back()">목록</button>
			</div>
		</div><!-- list_table-->
		
	</article>	
	<!-- //서브컨텐츠 -->
</section>
<!--// section -->

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
			   <button type="submit" class="blue_btn popup_close_btn" onclick="btn_registration_onclick('P');">예</button>
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
			   <button type="button" class="gray_btn popup_close_btn" onclick="location.href='/adminHome/board/poster/main'">닫기</button>
		   </div>
	   </div>
    </div>
    <!-- 게시물 등록 완료 팝업 -->

