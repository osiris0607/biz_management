<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript" src="/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />


<script type='text/javascript'>
	var oEditors = [];
	var oEditors2 = [];

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

		nhn.husky.EZCreator.createInIFrame({
			oAppRef : oEditors2,
			elPlaceHolder : "txa_effect", //textarea에서 지정한 id와 일치해야 합니다. 
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
		$("#file_img_upload").on("change", addImageFiles);
	});

	/*******************************************************************************
	* gallery 상세 조회
	*******************************************************************************/
	var uploaded_files = new Array();
	var uploaded_image_files = new Array();
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
			$("#board_check_posting").prop("checked", true);
		}
		else 
		{
			$("#board_check_unpublished").prop("checked", true);
		}
		
		$("#ibx_title").val(data.result_data.title);
		$("#ibx_businessName").val(data.result_data.business_name);
		$("#ibx_institueName").val(data.result_data.institue_name);
		$("#ibx_fromDate").val(data.result_data.from_date);
		$("#ibx_toDate").val(data.result_data.to_date);
		$("#ibx_skillKeyword").val(data.result_data.skill_keyword);
		$("#txa_description").val(unescapeHtml(data.result_data.description));
		$("#txa_effect").val(unescapeHtml(data.result_data.skill_effect));

		$("#file_img_list").empty();
		if ( data.result_data.return_upload_image_file_info != null) 
		{
			uploaded_image_files = data.result_data.return_upload_image_file_info;
			var str = "";
			var index = 0;
			$.each(uploaded_image_files, function(key, value) {
				str += "<div class='file'>";
				str += "	<img src='data:image/gif;base64," + value.binary_content + "' alt='갤러리 이미지' />";
				str += '	<a href="javascript:void(0)" onclick="deleteImageFile('+index+');" ><i class="fas fa-times"></i></a>';	
				str += "	<span>" + value.name + "</span>";
				str += "</div>";
				index++;
			});
			$("#file_img_list").append(str);
		}


	    if ( data.result_data.return_upload_attach_file_info != null) {
	    	uploaded_files = data.result_data.return_upload_attach_file_info;
	    	$("#file_list").empty();
	    	for(var i=0; i<uploaded_files.length; i++) {
		    	$("#file_list").append("<li><a href='javascript:void(0);' class='del_btn fl mr5' onclick='deleteFile(\"" + i + "\");'><i class='fas fa-times'></i></a>" + uploaded_files[i].name + "</li>");
		    }
		}
	}

	/*******************************************************************************
	* gallery 파일 선택
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
		if ( !(uploaded_files[orderParam] instanceof File) ) 
		{
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
	* gallery 이미지 파일 선택
	*******************************************************************************/
	var filesTempImageArr = new Array();
	// 파일 추가
	function addImageFiles(e) {
	    var files = e.target.files;
	    var filesArr = Array.prototype.slice.call(files);
	    var filesArrLen = filesArr.length;
	    var filesTempArrLen = uploaded_image_files.length;

		var html = '';
	    for( var i=0; i<filesArrLen; i++ ) 
	    {
	    	uploaded_image_files.push(filesArr[i]);
	    	const fileName = filesArr[i].name;
	    	
	    	html += '<div class="file">';
			html += '	<img src="'+URL.createObjectURL(filesArr[i])+'">'
			html += '	<a href="javascript:void(0)" onclick="deleteImageFile('+(filesTempArrLen+i)+');" ><i class="fas fa-times"></i></a>';
			html += '	<span>'+fileName+'</span>';           
			html += '</div>';

			const fileEx = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
			if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp")
			{
				alert("파일은 (jpg, gif, png, bmp) 형식만 등록 가능합니다.");
				return false;
			}
	    }

	    $("#file_img_list").append(html);
	}
	// 파일 삭제
	function deleteImageFile(orderParam) {
		// FILE 이 아닌 경우 이미 기존에 저장한 FILE의 ID 이다. DB에서 삭제하기 위해서 따로 List화 한다.
		if ( !(uploaded_image_files[orderParam] instanceof File) ) 
		{
			deleteFileList.push(uploaded_image_files[orderParam].file_id);
		}
		
		uploaded_image_files.splice(orderParam, 1);
	    var innerHtmlTemp = "";
	    var filesTempArrLen = uploaded_image_files.length;

	    var html = "";
	    $("#file_img_list").empty();
	    for(var i=0; i<filesTempArrLen; i++) 
	    {
			const fileName = uploaded_image_files[i].name;
			
	    	html += '<div class="file">';

	    	if ( !(uploaded_image_files[i] instanceof File) ) 
			{
	    		html += "	<img src='data:image/gif;base64," + uploaded_image_files[i].binary_content + "' alt='갤러리 이미지' />";	
			}
	    	else 
	    	{
	    		html += "<img src='"+URL.createObjectURL(uploaded_image_files[i])+"'>";
	    	}
	    	
	    	
			html += '	<a href="javascript:void(0)" onclick="deleteImageFile(' + i +');" ><i class="fas fa-times"></i></a>';
			html += '	<span>'+fileName+'</span>';           
			html += '</div>';
	    }

	    $("#file_img_list").html(html);
	}
	

	/*******************************************************************************
	* 보도자료 수정
	*******************************************************************************/
	function btn_modification_onclick() {
		var chkVal = ["ibx_title", "ibx_businessName", "ibx_fromDate", "ibx_toDate", "ibx_institueName",
		  			  "ibx_skillKeyword" ];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		}
		
		if ( gfn_isNull($("#ibx_fromDate").val()) == true && gfn_isNull($("#ibx_toDate").val()) == false ) {
			alert("시작 접수일과 종료 접수일을 같이 선택해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#ibx_fromDate").val()) == false && gfn_isNull($("#ibx_toDate").val()) == true) {
			alert("시작 접수일과 종료 접수일을 같이 선택해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#ibx_fromDate").val()) == false && gfn_isNull($("#ibx_toDate").val()) == false) {
			if ( $("#ibx_fromDate").val() > $("#ibx_toDate").val()) {
				alert("시작 접수일이 종료 접수일보다 앞선 날짜 입니다. 다시 선택해 주시기 바랍니다.");
				return;
			}
		}
		
		var emptyStr = oEditors.getById["txa_description"].getIR().replace(/(<([^>]+)>)/ig,"");
		if ( oEditors.getById["txa_description"].getIR() == null || emptyStr == "" ) 
		{
			alert("기술 요약은 필수입력입니다.");
			return false;
		} 
		
		emptyStr = oEditors2.getById["txa_effect"].getIR().replace(/(<([^>]+)>)/ig,"");
		if ( oEditors2.getById["txa_effect"].getIR() == null || emptyStr == "" ) 
		{
			alert("기술 효과는 필수입력입니다.");
			return false;
		} 

		if ( uploaded_image_files.length <= 0)
		{
			alert("기술 이미지는 필수입력입니다.");
			return false;
		}
		
		var formData = new FormData();
		// 보도 자료 관리 Type은 "P" 이다.
		formData.append("board_id", $("#board_id").val());
		formData.append("title", $("#ibx_title").val());
		formData.append("writer", "${member_id}");
		formData.append("description", oEditors.getById["txa_description"].getIR());
		formData.append("skill_effect", oEditors2.getById["txa_effect"].getIR());
		formData.append("open_yn", $("input:radio[name=cbx_OpenYn]:checked").val());
		formData.append("business_name", $("#ibx_businessName").val() );
		formData.append("institue_name", $("#ibx_institueName").val() );
		formData.append("skill_keyword", $("#ibx_skillKeyword").val() );
		formData.append("from_date", $("#ibx_fromDate").val() );
		formData.append("to_date", $("#ibx_toDate").val() );
		
		// 첨부파일 Type. 'D'(Document) : 첨부파일, ' P'(Picture) : 기술 이미지
		formData.append("file_type", "D");
		if ( filesTempArr.length > 0)
		{
			formData.append("file_yn", "Y");
		}
		else
		{
			formData.append("file_yn", "N");
		}

		// 새로 업로드된 파일만 업데이트 한다.
 		for (var i=0; i<uploaded_files.length; i++ ) 
 		{
 	 		if ( uploaded_files[i] instanceof File )
			formData.append("upload_attach_file", uploaded_files[i]);
		} 
 		// 새로 업로드된 파일만 업데이트 한다.
 		for (var i=0; i<uploaded_image_files.length; i++ ) 
 		{
 	 		if ( uploaded_image_files[i] instanceof File )
			formData.append("upload_image_file", uploaded_image_files[i]);
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
			<li><a href="/adminHome/board/broadcast/main">보도자료관리</a></li>
			<li><a href="/adminHome/board/poster/main">포스터관리</a></li>
			<li class="on"><a href="/adminHome/board/gallery/main">기술갤러리관리</a></li>
		</ul>	
	</nav>
	<!-- //left_menu -->
	
	<!-- 서브컨텐츠 -->
	<article class="contents sub_content">
		<h3 class="sub_title">기술갤러리관리</h3>
		<div class="list_table">
			<table class="list2 write_table gallery_table">
				<caption>기술갤러리관리</caption>     
				<colgroup>
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:30%">
					<col style="width:20%">	
					<col style="width:30%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" colspan="2">게시상태</th>	
						<td class="check" colspan="3">
							<div class="gallery_board_posting_check">
								<input type="radio" id="board_check_posting" value="Y" name="cbx_OpenYn" />
								<label for="board_check_posting" class="mr10">게시</label>
								<input type="radio" id="board_check_unpublished" value="N" name="cbx_OpenYn" checked="checked"/>
								<label for="board_check_unpublished">미게시</label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="col" colspan="2">
							<label for="bs_class">사업명</label>
						</th>
						<td class="bs_class">
							<input id="ibx_businessName" title="사업명" type="text" class="form-control" />
						</td>						
						<th scope="col">수행기간</th>	
						<td class="date">
							<div class="datepicker_area">
								<input id="ibx_fromDate" title="수행일" type="text" class="datepicker form-control w120" placeholder="시작일" />			
								<span>~</span>								
								<input id="ibx_toDate" title="수행일" type="text"  class="datepicker form-control w120" placeholder="종료일" />
							</div>	
						</td>
					</tr>
					<tr>
						<th scope="col" colspan="2"><label for="tech_title">기술명</label></th>	
						<td class="tech_title">
							<input id="ibx_title" title="기술명" type="text" class="form-control" />
						</td>
						<th scope="col"><label for="company_name">기관명</label></th>	
						<td class="company_name">
							<input  id="ibx_institueName" title="기관명" type="text" class="form-control" />
						</td>
					</tr>
					
					
					<tr>
						<th scope="col" rowspan="4">사업주요내용</th>
						
						<th scope="row"><label for="key">기술 키워드</label></th>	
						<td class="key" colspan="3">
							<input id="ibx_skillKeyword" title="기술키워드" type="text" class="form-control" id="key" />
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="or_summary">기술 요약</label></th>
						<td colspan="3">
							<textarea id="txa_description" title="기술요약" name="or_summary"  cols="30" rows="10"></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="or_effect">기대효과</label></th>
						<td colspan="3">
							<textarea id="txa_effect" name="or_effect" cols="30" rows="10"></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">기술 이미지</th>
						<td  colspan="3" class="gallery_write_img">										
							<!-- 업로드 -->
							<div id="gallery_attach">
								<label for="file_img_upload">파일 선택</label>
								<input multiple="multiple" id="file_img_upload" type="file" style="display:none"/>				
								<div class="clearfix" id="file_img_list"></div>											
							</div>							
						</td>
					</tr>
					<tr>
						<th scope="row" colspan="2"><label for="or_effect">기술첨부자료</label></th>
						<td colspan="3" class="gallery_write_attachfile">										
							<!-- 업로드 -->
							<div class="filebox2">
								<label for="file_upload">파일 선택</label>
								<input type="file" id="file_upload" multiple class="gray_btn2 mr5 hidden">
								<!-- 여기에 파일 목록 태그 추가 -->															
								<ul id="file_list" style="clear:both"></ul>
							</div>
							<!-- //업로드 -->										
						</td>
					</tr>								 							 
			    </tbody>
			</table>   
			<!--//검색 결과-->  
		     <div class="write_button_area">
			 	<button type="button" class="blue_btn board_modify">수정완료</button>
				<button type="button" class="gray_btn2" onclick="location.href='/adminHome/board/gallery/main'">목록</button>
			</div>
		</div><!-- list_table-->
		
	</article>
	<!-- //서브컨텐츠 -->
</section>
<!--// section -->

<!-- 게시물 수정 팝업 -->
    <div class="board_modify_popup_box popup_box">
	   <div class="popup_bg"></div>
	   <div class="board_notice_modify_popup popup_contents">
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
	   <div class="board_notice_modify_complete_popup popup_contents">
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