<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />


<script type='text/javascript'>
	var oEditors = [];
	var uploaded_files = new Array;

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
		
		searchDetail();

		$("#file_upload").on("change", addFiles);
	});

	/*******************************************************************************
	* 보도자료 상세 조회
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
			$("#board_notice_check_posting").prop("checked", true);
		}
		else 
		{
			$("#board_notice_check_unpublished").prop("checked", true);
		}
		$("#ibx_title").val(data.result_data.title);
		$("#txt_writer").html("<span>" + data.result_data.writer + "</span>");
		$("#txt_regDate").html(data.result_data.reg_date);
		$("#txa_description").val(unescapeHtml(data.result_data.description));


	    if ( data.result_data.return_upload_attach_file_info != null) {
	    	uploaded_files = data.result_data.return_upload_attach_file_info;
	    	$("#file_list").empty();
	    	for(var i=0; i<uploaded_files.length; i++) {
		    	$("#file_list").append("<li><a href='javascript:void(0);' class='del_btn fl mr5' onclick='deleteFile(\"" + i + "\");'><i class='fas fa-times'></i></a>" + uploaded_files[i].name + "</li>");
		    }
		}
	}

	/*******************************************************************************
	* 파일 선택
	*******************************************************************************/
	var filesTempArr = new Array();
	function addFiles(e) {
	    var files = e.target.files;
	    var filesArr = Array.prototype.slice.call(files);
	    var filesArrLen = filesArr.length;
	    var filesTempArrLen = uploaded_files.length;

	    for( var i=0; i<filesArrLen; i++ ) {
	    	uploaded_files.push(filesArr[i]);
	        $("#file_list").append("<li><a href='javascript:void(0);' class='del_btn fl mr5' onclick='deleteFile(\"" + (filesTempArrLen+i)+ "\");'><i class='fas fa-times'></i></a>" + filesArr[i].name + "</li>");
	    }
	    $(this).val('');
	}
	// 파일 삭제
	var deleteFileList = new Array();
	function deleteFile (orderParam) {
		// FILE 이 아닌 경우 이미 기존에 저장한 FILE의 ID 이다. DB에서 삭제하기 위해서 따로 List화 한다.
		if ( !(uploaded_files[orderParam] instanceof File) ) {
			deleteFileList.push(uploaded_files[orderParam].file_id);
		}
		
		uploaded_files.splice(orderParam, 1);
	    var innerHtmlTemp = "";
	    var filesTempArrLen = uploaded_files.length;
	    
	    $("#file_list").empty();
	    for(var i=0; i<filesTempArrLen; i++) {
	    	$("#file_list").append("<li><a href='javascript:void(0);' class='del_btn fl mr5' onclick='deleteFile(\"" + i + "\");'><i class='fas fa-times'></i></a>" + uploaded_files[i].name + "</li>");
	    }
	}

	/*******************************************************************************
	* 보도자료 수정
	*******************************************************************************/
	function btn_modification_onclick() {
		var chkVal = ["ibx_title"];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		}

		if ( oEditors.getById["txa_description"].getIR() == null || oEditors.getById["txa_description"].getIR() == "" ) 
		{
			alert("내용은(는) 필수입력입니다.");
			return false;
		}
		var formData = new FormData();
		formData.append("board_id", $("#board_id").val());
		formData.append("title", $("#ibx_title").val());
		formData.append("description", oEditors.getById["txa_description"].getIR());
		formData.append("open_yn", $("input:radio[name=cbx_OpenYn]:checked").val());

		// 새로 업로드된 파일만 업데이트 한다.
 		for (var i=0; i<uploaded_files.length; i++ ) 
 		{
 	 		if ( uploaded_files[i] instanceof File )
			formData.append("upload_attach_file", uploaded_files[i]);
		} 
		// 삭제된 파일 리스트 전송
		formData.append("delete_file_list", deleteFileList);

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
		        	$('.board_modify_complete_popup_box').fadeIn(350);
		        	setTimeout(() => {
	    	            location.href = "/adminHome/board/broadcast/main";
	    	        }, 2000);
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
<input type="hidden" id="board_id" name="board_id" value="${vo.board_id}" />
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
		<div class="list_table">
			<table class="list2 write_table notice_table">
				<caption>보도자료관리</caption>     
				<colgroup>
					<col style="width:20%">
					<col style="width:80%">								
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">게시상태</th>	
						<td class="check">
							<div class="notice_board_posting_check">
								<input type="radio" id="board_notice_check_posting" name="cbx_OpenYn" value="Y"  />
								<label for="board_notice_check_posting" class="mr10">게시</label>
								<input type="radio" id="board_notice_check_unpublished" name="cbx_OpenYn" value="N"/>
								<label for="board_notice_check_unpublished">미게시</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="write_title">제목</label></th>
						<td class="write_title">
							<input id="ibx_title" title="제목" type="text" class="form-control" id="write_title" />
						</td>				
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
						<th scope="row"><label for="board_notice_write_text">내용</label></th>	
						<td class="data_write_text">
							<textarea id="txa_description" title="내용" name="board_notice_write_text"></textarea>
						</td>
					</tr>  
					<tr>
						<th scope="row">첨부파일</th>	
						<td class="notice_write_attachfile">										
							<div class="filebox2">
								<form method="post" action="" enctype="multipart/form-data">
								<label for="file_upload">파일 선택</label>
									<input type="file" id="file_upload" multiple class="gray_btn2 mr5 hidden">
									<!-- 여기에 파일 목록 태그 추가 -->															
									<ul id="file_list" style="clear:both"></ul>
								</form>
							</div>
							<!-- //업로드 -->										
						</td>
					</tr>  
			    </tbody>
			</table>   
			<!--//검색 결과-->  
		    <div class="write_button_area">
				<button type="button" class="blue_btn board_modify">수정완료</button>					
				<button type="button" class="gray_btn2" onclick="location.href='/adminHome/board/broadcast/main'">목록</button>
			</div>
		</div><!-- list_table-->
		
	</article>	
	<!-- //서브컨텐츠 -->
</section>
<!--// section -->

<!-- 게시물 수정 팝업 -->
    <div class="board_modify_popup_box popup_box">
	   <div class="popup_bg"></div>
	   <div class="board_modify_popup popup_contents">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">수정 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
			   <p>해당 게시물을 <span class="font_blue">수정</span> 하시겠습니까?</p>				   
		   </div>
		   <div class="popup_button_area_center">
			   <button type="submit" class="blue_btn popup_close_btn" onclick="btn_modification_onclick();">예</button>
			   <button type="button" class="gray_btn logout_popup_close_btn popup_close_btn">아니요</button>
		   </div>
	   </div>
    </div>
    <!-- //게시물 수정 팝업 -->

	<!-- 게시물 수정 완료 팝업 -->
    <div class="board_modify_complete_popup_box popup_box">
	   <div class="popup_bg"></div>
	   <div class="board_modify_complete_popup popup_contents">
	       <div class="popup_titlebox clearfix">
		       <h4 class="fl">수정 안내</h4>
		       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr" onClick="history.back()"><i class="fas fa-times"></i></a>
		   </div>
		   <div class="popup_txt_area">
			   <p><span class="font_blue">수정 완료</span> 되었습니다.</p>				   
		   </div>
		   <div class="popup_button_area_center">
			   <button type="button" class="gray_btn popup_close_btn" onClick="history.back()">닫기</button>
		   </div>
	   </div>
    </div>
    <!-- 게시물 수정 완료 팝업 -->