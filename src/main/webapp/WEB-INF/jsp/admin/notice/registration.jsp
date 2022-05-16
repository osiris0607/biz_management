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
	});
	
	var filesTempArr = new Array();
	// 파일 추가
	function addFiles(e) {
	    var files = e.target.files;
	    var filesArr = Array.prototype.slice.call(files);
	    var filesArrLen = filesArr.length;
	    var filesTempArrLen = filesTempArr.length;
	
	    for( var i=0; i<filesArrLen; i++ ) {
	        filesTempArr.push(filesArr[i]);
	        $("#file_list").append("<li>" + filesArr[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + (filesTempArrLen+i)+ "\");'><i class='fas fa-times'></i></a></li>");
	    }
	    $(this).val('');
	}
	// 파일 삭제
	function deleteFile (orderParam) {
	    filesTempArr.splice(orderParam, 1);
	    var innerHtmlTemp = "";
	    var filesTempArrLen = filesTempArr.length;
	    
	    $("#file_list").empty();
	    for(var i=0; i<filesTempArrLen; i++) {
	    	$("#file_list").append("<li>" + filesTempArr[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + i + "\");'><i class='fas fa-times'></i></a></li>");
	    }
	}
	
	function registration(status){
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
		formData.append("title", $("#title").val());
		formData.append("explanation", oEditors.getById["explanation"].getIR());
		
		for (var i=0; i<filesTempArr.length; i++ ) {
			formData.append("upload_files", filesTempArr[i]);
		}

		if (confirm("등록하시겠습니까?")) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/notice/registration",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == 1) {
			            alert("등록 되었습니다.");
			            location.href = "/admin/fwd/notice/main";
			        } else {
			            alert("등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}
</script>


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
							   <button type="button" class="fl blue_btn mr5" onclick="registration();">등록</button>		
							   <button type="button" class="gray_btn2" onclick="location.href='/admin/fwd/notice/main'">목록</button>
						   </div>
					   </div>
                   </div>
				   <!--//contents--> 
                </div>
                <!--//sub--> 
            </div>