<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var oEditors = [];
	$(document).ready(function() {
		nhn.husky.EZCreator.createInIFrame({
			oAppRef : oEditors,
			elPlaceHolder : "explanation", //textarea에서 지정한 id와 일치해야 합니다. 
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
	
	 	$("#file_upload").on("change", addFiles);
	 	getDetail();
	});
	
	// 파일 추가
	var filesTempArr = new Array();
	function addFiles(e) {
	    var files = e.target.files;
	    var filesArr = Array.prototype.slice.call(files);
	    var filesArrLen = filesArr.length;
	    var filesTempArrLen = uploaded_files.length;

	    for( var i=0; i<filesArrLen; i++ ) {
	    	uploaded_files.push(filesArr[i]);
	        $("#file_list").append("<li>" + filesArr[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + (filesTempArrLen+i)+ "\");'><i class='fas fa-times'></i></a></li>");
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
	    	$("#file_list").append("<li>" + uploaded_files[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + i + "\");'><i class='fas fa-times'></i></a></li>");
	    }
	}
	
	function getDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/notice/detail'/>");
		comAjax.setCallback(getDetailCB);
		comAjax.addParam("notice_id", $("#notice_id").val());
		comAjax.ajax();
	}

	var uploaded_files = new Array();
	function getDetailCB(data){
		if ( data.result == false){
			alert("공지 사항 정보가 없습니다. 다시 시도해 주시기 바랍니다.");
			return;
		}
		
		$("#title").val(data.result_data.title) ;
		$("#explanation").html(unescapeHtml(data.result_data.explanation));
		
	    if ( data.result_data.return_upload_files != null) {
	    	uploaded_files = data.result_data.return_upload_files;
	    	$("#file_list").empty();
	    	for(var i=0; i<uploaded_files.length; i++) {
		    	$("#file_list").append("<li>" + uploaded_files[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + i + "\");'><i class='fas fa-times'></i></a></li>");
		    }
		}
	}


	function modification(status) {
		var chkVal = ["title"];
		for (var i = 0; i < chkVal.length; i++) 
		{
			if ($("#" + chkVal[i]).val() == "" ) {
				alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
				$("#" + chkVal[i]).focus();
				return false;
			}
		}

		if ( oEditors.getById["explanation"].getIR() == null || oEditors.getById["explanation"].getIR() == "" ) {
			alert("내용은(는) 필수입력입니다.");
			return false;
		}
		var formData = new FormData();
		formData.append("notice_id", $("#notice_id").val());
		formData.append("title", $("#title").val());
		formData.append("explanation", oEditors.getById["explanation"].getIR());
		// 새로 업로드된 파일만 업데이트 한다.
 		for (var i=0; i<uploaded_files.length; i++ ) {
 	 		if ( uploaded_files[i] instanceof File )
			formData.append("upload_files", uploaded_files[i]);
		} 
		// 삭제된 파일 리스트 전송
		formData.append("delete_file_list", deleteFileList);

		if (confirm('수정 하시겠습니까?')) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/notice/modification",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			            alert("수정 되었습니다.");
			            location.href = "/admin/fwd/notice/main";
			        } else {
			            alert("수정에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}

	function withdrawal() {
		var formData = new FormData();
		formData.append("notice_id", $("#notice_id").val());

		if (confirm('삭제 하시겠습니까?')) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/notice/withdrawal",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			            alert("삭제 되었습니다.");
			            location.href = "/admin/fwd/notice/main";
			        } else {
			            alert("삭제 실패 하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}

	}

	
</script>

<input type="hidden" id="notice_id" name="notice_id" value="${vo.notice_id}" />
<div class="container" id="content">
                <h2 class="hidden">컨텐츠 화면</h2>
                <div class="sub">
                   <!--left menu 서브 메뉴-->     
                   <div id="lnb">
				       <div class="lnb_area">
		                   <!-- 레프트 메뉴 서브 타이틀 -->	
					       <div class="lnb_title_area">
						       <h2 class="title">알림&middot;정보</h2>
						   </div>
		                   <!--// 레프트 메뉴 서브 타이틀 -->
						   <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="/admin/fwd/notice/main" title="알림&middot;정보">알림&middot;정보</a></li>								   
							   </ul>				
						   </div>
					   </div>			
				   </div>
				   <!--left menu 서브 메뉴-->

				   <!--본문시작-->
                   <div class="contents">
                       <div class="location_area">
					       <div class="location_division">
							   <!--페이지 경로-->
					           <ul class="location clearfix">
							       <li><a href="/admin/fwd/home/main"><i class="nav-icon fa fa-home"></i></a></li>
								   <li><strong>알림&middot;정보</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">알림&middot;정보</h3>
							  <!--//페이지타이틀-->
						   </div>
					   </div>
					   
					   <div class="announcement_tab1">
						   <div class="view_top_area clearfix">
							   <h4 class="fl sub_title_h4">알림&middot;정보</h4>
						   </div>
						   <table class="list2">
							   <caption>알림&middot;정보</caption> 
							   <colgroup>
								   <col style="width: 20%">
								   <col style="width: 80%">
							   </colgroup>
							   <thead>
								   <tr>
									   	<th scope="row">
									   		<span class="icon_box"><span class="necessary_icon">*</span><label for="title">제목</label></span>
							   			</th>
								   		<td>
										   <input id="title" title="제목" class="form-control w100" type="text" placeholder="제목 입력">                     
									   </td> 
								   </tr>
							   </thead>
							   <tbody>							   
								   				   
								   <tr>
									   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>내용</span></th>
									   <td>
										   <textarea  id="explanation" title="내용" cols="30" rows="10" class="w100"></textarea>                                    
									   </td> 
								   </tr>
								   <tr>
									   <th scope="row"><span class="icon_box">첨부파일</span></th>
									   <td>
										   <div class="clearfix file_form_txt">
											   
											   <!--업로드 버튼-->
											   <div class="filebox2">
													<form id="frm" method="post" action="" enctype="multipart/form-data">
													<label for="file_upload">파일 선택</label>
														<input type="file" id="file_upload" multiple="" class="fl gray_btn2 mr5 hidden">
														<!-- 여기에 파일 목록 태그 추가 -->															
														<ul id="file_list" style="clear:both"></ul>
													</form>
												</div>	
												<!--//업로드 버튼-->
										   </div>
									   </td> 
								   </tr>
							   </tbody>
						   </table>     
						   <!--공고관리 write-->
						   <div class="fr mt30 clearfix">						   
						   	   	<button type="button" class="fl blue_btn mr5" onclick="withdrawal();">삭제</button>
							   	<button type="button" class="fl blue_btn mr5" onclick="modification();">수정</button>		
							   	<button type="button" class="gray_btn2" onclick="location.href='/admin/fwd/notice/main'">목록</button>
						   </div>
					   </div>
                   </div>
				   <!--//contents--> 
                </div>
                <!--//sub--> 
            </div>