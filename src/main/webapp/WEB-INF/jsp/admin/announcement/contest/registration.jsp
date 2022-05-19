<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var oEditors = [];
	$(document).ready(function() {
		nhn.husky.EZCreator.createInIFrame({
			oAppRef : oEditors,
			elPlaceHolder : "contents", //textarea에서 지정한 id와 일치해야 합니다. 
			//SmartEditor2Skin.html 파일이 존재하는 경로
			sSkinURI : "${ctx }/assets/SE2/SmartEditor2Skin.html",
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


	 	$("#selectEmail").change(function(){
	 		if ( $("#selectEmail").val() == "1" ) {
				$("#email2").attr("disabled", false);
			}
			else {
				$("#email2").attr("disabled", true);
			}
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

	var mailAddress;
	function prepareRegistration(status) {
		if ( status  != "D0000001") {
			var chkVal = ["title", "business_name", "type", "manager", "manager_dept", "manager_job_title", "phone1", 
  				  "phone2", "phone3", "receipt_to", "receipt_from"];
		  
			for (var i = 0; i < chkVal.length; i++) 
			{
				if ($("#" + chkVal[i]).val() == "" ) {
					alert($("#" + chkVal[i]).attr("title") + "은(는) 필수입력입니다.");
					$("#" + chkVal[i]).focus();
					return false;
				}
			} 
		
			//editor 유효성
			var content	= oEditors.getById["contents"].getIR();
			if(content == "" || content == null || content == '&nbsp;' || content == '<br>' || content == '<br/>' || content == '<p>&nbsp;</p>' || content == '<p><br></p>'){ 
				alert("공고 내용은(는) 필수입력입니다.");
				oEditors.getById["smartEditor"].exec("FOCUS");
				return false;
				//포커싱 return; 
			}
			
			if ( gfn_isNull($("#email1").val()) == false && gfn_isNull($("#email2").val()) == false){
				mailAddress = $("#email1").val() + "@" + $("#email2").val();
			}
			else if (gfn_isNull($("#email1").val()) == false && $("select[name=selectEmail]").val() != "0" && $("select[name=selectEmail]").val() != "1" ) {
				mailAddress =  $("#email1").val() + "@" + $("select[name=selectEmail]").val();
			}
			else {
				alert("메일은(는) 필수입력입니다.");
				return false;
			}
		} else {
			if ( gfn_isNull($("#email1").val()) == false && gfn_isNull($("#email2").val()) == false){
				mailAddress = $("#email1").val() + "@" + $("#email2").val();
			}
			else if (gfn_isNull($("#email1").val()) == false && $("select[name=selectEmail]").val() != "0" && $("select[name=selectEmail]").val() != "1" ) {
				mailAddress =  $("#email1").val() + "@" + $("select[name=selectEmail]").val();
			}
		}

		// 임시 저장 Popup 실행
		if (status == "D0000001") {
			 $('.temporary_storage_popup_box').fadeIn(350);
		}
		else { // 등록 popup 실행
			 $('.announcement_write_popup_box').fadeIn(350);
		}
		
	}

	function registration(status){
		// 창 닫기
		 $('.temporary_storage_popup_box').fadeOut(100);
		 $('.announcement_write_popup_box').fadeOut(100);
		
		var formData = new FormData();
		formData.append("title", $("#title").val());
		formData.append("business_name", $("#business_name").val());
		formData.append("type", "D0000003");
		formData.append("manager", $("#manager").val());
		formData.append("manager_dept", $("#manager_dept").val());
		formData.append("manager_job_title", $("#manager_job_title").val());
		var tempStr = $("#phone1").val() + "-" + $("#phone2").val() + "-" + $("#phone3").val();
		formData.append("manager_phone", tempStr);
		formData.append("manager_mail", mailAddress);
		if ( $("#register").val() == null || $("#register").val() == "" ) {
			formData.append("register",'${member_id}');
		}
		else {
			formData.append("register",$("#register").val());
		}
		formData.append("receipt_to", $("#receipt_to").val());
		formData.append("receipt_from", $("#receipt_from").val());
		formData.append("contents", oEditors.getById["contents"].getIR());
		formData.append("process_status", status);

		// Multi File Upload 시에 이용
		// formData.append("Param_name", "Value") 으로 같은 'Param_name'에 Append하면
		// 'Param_name'으로 된 Value를 같는 List가 생성된다.
		// 따라서 아래에서와 같이 
		// formData.append("upload_files", $("#upload_file_" + i)[0].files[0])
		// 이렇게 하면 'upload_files'이라는 변수에 upload file 정보가 list처럼 쌓이게 된다.
		/* for (var i=0; i<$("input[name=file_upload]").length; i++ ) {
			if ( gfn_isNull($("#upload_file_" + i)[0].files[0]) == false ) {
				formData.append("upload_files", $("#upload_file_" + i)[0].files[0]);
			}
		}  */		
		
		for (var i=0; i<filesTempArr.length; i++ ) {
			formData.append("upload_files", filesTempArr[i]);
		}
		
		var extList = new Array();
		// 개인 정보
		for (var i=0; i<$("#personal_info_body tr").length; i++ ) {
			var personalInfo = new Object();
			personalInfo.ext_type = "D0000007";
			personalInfo.ext_field_yn = $("input:radio[name=reception_member_radiooptions" + (i+1) + "]:checked").val();
			personalInfo.ext_field_name = $("#personal_info_"+ (i+1)).text() ;
			extList.push(personalInfo);
		}
		// 기관 정보
		for (var i=0; i<$("#agency_information_body tr").length; i++ ) {
			var institutionsInfo = new Object();
			institutionsInfo.ext_type = "D0000001";
			institutionsInfo.ext_field_yn = $("input:radio[name=reception_institutions_radiooptions" + (i+1) + "]:checked").val();
			institutionsInfo.ext_field_name = $("#institutions_name_"+ (i+1)).text() ;
			extList.push(institutionsInfo);
		}
		// 연구책임자 정보
		for (var i=0; i<$("#consulting_reception_body tr").length; i++ ) {
			var tempInfo = new Object();
			tempInfo.ext_type = "D0000002";
			tempInfo.ext_field_yn = $("input:radio[name=consulting_reception" + (i+1) + "]:checked").val();
			tempInfo.ext_field_name = $("#consulting_reception_name_"+ (i+1)).text() ;
			extList.push(tempInfo);
		}

		// 기술 컨설팅 요청사항
		for (var i=0; i<$("#technique_consulting_body tr").length; i++ ) {
			var tempInfo = new Object();
			tempInfo.ext_type = "D0000003";
			tempInfo.ext_field_yn = $("input:radio[name=con_reception_technique_radiooptions" + (i+1) + "]:checked").val();
			tempInfo.ext_field_name = $("#technique_consulting_name_"+ (i+1)).text() ;
			extList.push(tempInfo);
		}
		// 기술 정보
		var count = $("#technology_body tr").length;
		for (var i=0; i<$("#technology_body tr").length; i++ ) {
			if ( $("#technology_tr_" + (i+1)).attr("use_yn") == "N" ) {
				continue;
			}
			
			var tempInfo = new Object();
			tempInfo.ext_type = "D0000004";
			tempInfo.ext_field_yn = $("input:radio[name=reception_technique_radiooptions" + (i+1) + "]:checked").val();
			tempInfo.ext_field_name = $("#technology_name_"+ (i+1)).text() ;
			extList.push(tempInfo);
		}
		// 제출 서류
		for (var i=0; i<$("#document_body tr").length; i++ ) {
			if ( $("#doc_ext_tr_" + (i+1)).attr("use_yn") == "N" ) {
				continue;
			}
			
			var tempInfo = new Object();
			tempInfo.ext_type = "D0000005";
			tempInfo.ext_field_yn = $("input:radio[name=reception_document_radiooptions" + (i+1) + "]:checked").val();
			tempInfo.ext_field_name = $("#doc_ext_name_"+ (i+1)).text() ;
			extList.push(tempInfo);
		}
		formData.append("ext_field_list_json",  JSON.stringify(extList));


		var checkList = new Array();
		// 체크 리스트 처리
		for (var i=0; i<$(".checklist_box").length; i++ ) {
			var tempInfo = new Object();
			// 전체 사용 여부
			tempInfo.all_use_yn = $("input:radio[name=reception_check_radiooptions1]:checked").val();
			// 항목 사용 여부
			tempInfo.check_list_use_yn = $("input:radio[name=checklist_popupcheck_selected" + (i+1) + "]:checked").val();
			// 항목 내용
			tempInfo.check_list_content = $("#checklist_title" + (i+1)).val();
			// 팝업 사용 여부
			if ( $("input:checkbox[id=popup_use_yn" + (i+1) + "]").is(":checked") == true) {
				tempInfo.popup_use_yn = "D0000001";
			}
			else {
				tempInfo.popup_use_yn = "D0000002";
			}
			// 경고 팝업 사용 여부
			tempInfo.popup_warn_use_yn = $("input:radio[name=checkbox_receptionpopup_selected" + (i+1) + "]:checked").val();
			// 경고 팡업 내용
			tempInfo.popup_warn_content = $("#check_list_popup_title"+ (i+1)).val() ;

			checkList.push(tempInfo);
		}
		formData.append("ext_check_list_json",  JSON.stringify(checkList));

		$.ajax({
		    type : "POST",
		    url : "/admin/api/announcement/contest/registration",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		            alert("등록 되었습니다.");
		            location.href = "/admin/fwd/announcement/contest/main";
		        } else {
		            alert("등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function addFileForm(){
		var str = "<input type='file' id='upload_file_" + $("input[name=FILE_TAG]").length + "' class='file_form_input w_60' name='FILE_TAG' />";
		var html = $( "input[name=FILE_TAG]:last" ); //last를 사용하여 FILE_TAG라는 명을 가진 마지막 태그 호출
		html.after(str); //마지막 FILE_TAG명 뒤에 붙인다.
	}


	function makeTechnologyRow(index) {
		var extName = $("#tech_ext_name_" + index).val();
		$('#technology_body tr:last').remove();
		
		var str = "";
		str += "<tr>";
		str += "	<th scope='row' id='technology_name_" + index + "'>" + extName + "</th>";
		str += "	<td>";
 		str += "		<input type='radio' class='checkbox_reception_selected' name='reception_technique_radiooptions" + index + "' value='D0000001' checked='checked'/>";
		str += "		<label class='mr10' style='margin-right:20px'>선택</label>";
		str += "		<input type='radio' class='checkbox_reception_notselected' name='reception_technique_radiooptions" + index + "' value='D0000002' />";
		str += "		<label class='mr10'>선택 안함</label>";
		str += "	</td>";
		str += "</tr>";

		var trHtml = $( ".technology_information tr:last" ); 
		trHtml.after(str); 
	}


	function addTechnologyInfo(){
		var index = $("#technology_body tr").length + 1;
		var str = "";
		str += "<tr>";
		str += "	<th scope='row' class='clearfix'>";
		str += "		<div style='width:90%;margin:0 auto;'>";
		str += "			<label for='checkbox_reception_table1'>&nbsp;</label>";
		str += "			<input type='text' class='form-control ta_c agency_select_title mr5 mb5' id='tech_ext_name_" + index + "'/>";
		str += "			<button type='button' class='gray_btn' onclick='makeTechnologyRow(" + index + ");'>등록</button>";
		str += "		</div>";
		str += "	</th>";
		str += "	<td>";
/* 		str += "		<input type='radio' class='checkbox_reception_selected' name='reception_technique_ext_radiooptions" + index + "' checked='checked'>";
		str += "		<label class='mr10' style='margin-right:20px'>선택</label>";
		str += "		<input type='radio' class='checkbox_reception_notselected' name='reception_technique_ext_radiooptions" + index + "'>";
		str += "		<label class='mr10'>선택 안함</label>"; */
		str += "	</td>";
		str += "</tr>";
		var trHtml = $( ".technology_information tr:last" ); 
		trHtml.after(str); 
	}

	function makeDocumentRow(index) {
		var extName = $("#doc_ext_name_" + index).val();
		$('#document_body tr:last').remove();

		var str = "";
		str += "<tr>";
		str += "	<td>" + index + "</td>";
		str += "	<td id='doc_ext_name_" + index + "'>" + extName + "</td>";
		str += "	<td>PDF</td>";
		str += "	<td>";
		str += "		<input type='radio' class='checkbox_reception_selected' value='D0000003' name='reception_document_radiooptions" + index + "' checked='checked' />";
		str += "		<label class='w_0'>&nbsp;</label>";
		str += "	</td>";
		str += "	<td>";
		str += "		<input type='radio' class='checkbox_reception_notselected' value='D0000001' name='reception_document_radiooptions" + index + "' />";
		str += "		<label class='w_0'>&nbsp;</label>";
		str += "	</td>";
		str += "	<td>";
		str += "		<input type='radio' class='checkbox_reception_notselected' value='D0000002' name='reception_document_radiooptions" + index + "' />";
		str += "		<label class='w_0'>&nbsp;</label>";
		str += "	</td>";
		str += "</tr>";

		var trHtml = $( ".submission tr:last" ); 
		trHtml.after(str); 
	}
	

	function addDocumentInfo(){
		var index = $("#document_body tr").length + 1;
		var str = "";
		str += "<tr>";
		str += "	<td></td>";
		str += "	<td>";
		str += "		<input type='text' class='form-control w80 mr5 mb5' id='doc_ext_name_" + index + "' />";
		str += "		<input type='button' class='document_disabled_btn gray_btn mb5' onclick='makeDocumentRow(" + index + ");' value='등록' />";
		str += "	</td>";
		str += "	<td>PDF</td>";
		str += "	<td>";
		str += "		<input type='radio' class='checkbox_reception_selected' value='D0000003' name='reception_document_radiooptions" + index + "' checked='checked' disabled/>";
		str += "		<label class='w_0'>&nbsp;</label>";
		str += "	</td>";
		str += "	<td>";
		str += "		<input type='radio' class='checkbox_reception_notselected' value='D0000001' name='reception_document_radiooptions" + index + "' />";
		str += "		<label class='w_0'>&nbsp;</label>";
		str += "	</td>";
		str += "	<td>";
		str += "		<input type='radio' class='checkbox_reception_notselected' value='D0000002' name='reception_document_radiooptions" + index + "' />";
		str += "		<label class='w_0'>&nbsp;</label>";
		str += "	</td>";
		str += "</tr>";
		var trHtml = $( ".submission tr:last" ); 
		trHtml.after(str); 
	}

	function addCheckList(){
		var checkListIndex = $(".checklist_box").length + 1;
		var str = "";
		str += "<div class='checklist_box'>";
		str += "	<div class='checklist_txtbox_area'>";
		str += "		<div class='checklist_txtbox_title clearfix'>";
		str += "			<span class='fl mr20'>항목 " + checkListIndex + ".</span>";
		str += "			<div class='ta_l fl'>";
		str += "				<input type='radio' value='D0000001' id='use_checklist' name='checklist_popupcheck_selected" + checkListIndex + "' checked />";
		str += "				<label class='mr10'>사용</label>";
		str += "				<input type='radio' value='D0000002' id='not_checklist' name='checklist_popupcheck_selected" + checkListIndex + "' />";
		str += "				<label class='mr10'>사용 안함</label>";
		str += "			</div>";
		str += "		</div>";
		str += "		<div class='checklist_txt_area'>";
		str += "			<span class='dim_box' style='display:none'>&nbsp;</span>";
		str += "			<div class='checklist_txtbox w100'>";
		str += "				<textarea name='checklist_txt_box1' id='checklist_title" + checkListIndex + "' class='bd_n mr5 mb10 w100' placeholder='체크리스트 내용을 입력해 주십시요.'></textarea>";
		str += "				<div class='checklist_txtbox_popuparea clearfix'>";
		str += "					<table class='list'>";
		str += "						<caption>체크리스트 팝업</caption>";
		str += "						<colgroup>";
		str += "							<col style='width: 20%' />";
		str += "							<col style='width: 35%' />";
		str += "							<col style='width: 50%' />";
		str += "						</colgroup>";
		str += "						<thead>";
		str += "							<tr>";
		str += "								<th scope='col'>팝업 사용</th>";
		str += "								<th scope='col'><span class='ta_c'>팝업 경고</span></th>";
		str += "								<th scope='col'><span class='ta_c'>팝업 경고 내용</span></th>";
		str += "							</tr>";
		str += "						</thead>";
		str += "						<tbody>";
		str += "							<tr>";
		str += "								<td><input type='checkbox' name='chkbox' class='checkbox_member_manager_table' id='popup_use_yn" + checkListIndex + "'/><label>&nbsp;</label></td>";
		str += "								<td><span><label>&nbsp;</label></span>";
		str += "									<input type='radio' id='checkbox_receptionpopup2_1' value='D0000001' name='checkbox_receptionpopup_selected" + checkListIndex + "' checked />";
		str += "									<label for='checkbox_receptionpopup2_1'>예</label>&nbsp;&nbsp;&nbsp;";
		str += "									<input type='radio' id='checkbox_receptionpopup2_2' value='D0000002' name='checkbox_receptionpopup_selected" + checkListIndex + "' />";	 
		str += "									<label for='checkbox_receptionpopup2_2'>아니오</label></td>";
		str += "								<td><textarea name='checkbox_receptionpopup-txt' id='check_list_popup_title" + checkListIndex + "' class='checkbox_receptionpopup_txt2 w100 bd_n' placeholder='경고 팝업의 내용을 입력해 주십시요.'></textarea></td>";
		str += "							</tr>";
		str += "						</tbody>";
		str += "					</table>";
		str += "				</div>";
		str += "			</div>";
		str += "		</div>";
		str += "	</div>";
		str += "</div>";
		
		var trHtml = $( ".checklist_box:last" ); 
		trHtml.after(str);
	}

</script>


<div class="container" id="content">
                <h2 class="hidden">컨텐츠 화면</h2>
                <div class="sub">
                   <div id="lnb">
				       <div class="lnb_area">
				                 <!-- 레프트 메뉴 서브 타이틀 -->	
					       <div class="lnb_title_area">
						       <h2 class="title">공고관리</h2>
						   </div>
				                 <!--// 레프트 메뉴 서브 타이틀 -->
						    <div class="lnb_menu_area">	
						       <ul class="lnb_menu">
							       <li class="on"><a href="/admin/fwd/announcement/main" title="공고관리">공고관리</a></li>
								   <ul class="menu2depth">
								       <li><a href="/admin/fwd/announcement/match/main">기술매칭</a></li>
								   	   <li class="active"><a href="/admin/fwd/announcement/contest/main">기술공모</a></li>
								   	   <li><a href="/admin/fwd/announcement/proposal/main">기술제안</a></li>
								   </ul>
							   </ul>					
						   </div>						
					   </div>			
				   	</div>

				   <!--본문시작-->
                   <div class="contents">
                       <div class="location_area">
					       <div class="location_division">
							   <!--페이지 경로-->
					           <ul class="location clearfix">
							       <li><a href="/admin/fwd/announcement/main"><i class="nav-icon fa fa-home"></i></a></li>
								   <li>공고관리</li>
								   <li><strong>기술공모</strong></li>
							   </ul>	
							  <!--//페이지 경로-->
							  <!--페이지타이틀-->
							   <h3 class="title_area">기술공모</h3>
							  <!--//페이지타이틀-->
						    </div>
					   </div>

					   					   
                       <div class="contents_view">
						   <!--공고관리 write-->
						   <!--공고정보-->	
						   <div class="announcement_tab1">
							   <div class="view_top_area clearfix">
								   <h4 class="fl sub_title_h4">공고정보</h4>
							   </div>
							   <table class="list2">
								   <caption>공고정보</caption> 
								   <colgroup>
									   <col style="width: 20%" />
									   <col style="width: 80%" />
								   </colgroup>
								   <thead>
									   <tr>
										   <th scope="row"><label for="title"><span class="necessary_icon">*</span>제목</label></th>
										   <td>
											   <input id="title" class="form-control w100" type="text" placeholder="제목 입력" title="제목"/>                                       
										   </td> 
									   </tr>
								   </thead>
								   <tbody>
									   <tr>
										   <th scope="row"><label for="business_name"><span class="necessary_icon">*</span>사업명</label></th>
										   <td>
											   <input id="business_name" class="form-control w100" type="text" placeholder="사업명 입력" title="사업명"/>                                       
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row"><label for="manager"><span class="necessary_icon">*</span>담당자</label></th>
										   <td>
											   <input id="manager" class="form-control w_18" type="text" placeholder="담당자 입력" title="담당자"/>                                 
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row"><label for="manager_dept"><span class="necessary_icon">*</span>담당자 부서</label></th>
										   <td>
											   <input id="manager_dept" class="form-control w_18" type="text" placeholder="담당자 소속 입력" title="담당자 부서"/>                                       
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row"><label for="manager_job_title"><span class="necessary_icon">*</span>담당자 직책</label></th>
										   <td>
											   <input id="manager_job_title" class="form-control w_18" type="text" placeholder="담당자 직책 입력" title="담당자 직책" />                                       
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row"><label for="totalmanager_phone"><span class="necessary_icon">*</span>담당자 전화</label></th>
										   <td>
											   <form name="phone_number" class="clearfix">
												   <input type="tel" maxlength="4" id="phone1" class="form-control  w_5-5 fl" title="담당자 전화"/>
												   <span style="display:block;" class="fl mc8">-</span>
												   <input type="tel" maxlength="4" id="phone2" class="form-control brc-on-focusd-inline-block w_6 fl" title="담당자 전화"/>
												   <span style="display:block;" class="fl mc8">-</span>
												   <input type="tel" maxlength="4" id="phone3" class="form-control brc-on-focusd-inline-block w_6 fl" title="담당자 전화"/>
											   </form>                                     
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="str_email">이메일</label></span></th> 
										   <td class="clearfix">
											   <input type="text" name="email1" id="email1" class="form-control w_20 fl">
											   <span class="fl ml1 mr1 pt10 mail_f">@</span>
											   <input type="text" name="email2" id="email2" class="form-control w_18 fl" disabled>
											   <!--이메일 선택-->
											   <select name="selectEmail" id="selectEmail" class="fl ml5 w_20 ace-select"> 
												   <option value="0" selected>-------선택-------</option> 
												   <option value="1">직접입력</option> 
												   <option value="naver.com">naver.com</option> 
												   <option value="hanmail.net">hanmail.net</option> 
												   <option value="hotmail.com">hotmail.com</option> 
												   <option value="nate.com">nate.com</option> 
												   <option value="yahoo.co.kr">yahoo.co.kr</option> 
												   <option value="empas.com">empas.com</option> 
												   <option value="dreamwiz.com">dreamwiz.com</option> 
												   <option value="freechal.com">freechal.com</option> 
												   <option value="lycos.co.kr">lycos.co.kr</option> 
												   <option value="korea.com">korea.com</option> 
												   <option value="gmail.com">gmail.com</option> 
												   <option value="hanmir.com">hanmir.com</option> 
												   <option value="paran.com">paran.com</option> 
												</select>
											</td> 
									   </tr>
									   <tr>
										   <th scope="row"><label for="register"><span class="necessary_icon">*</span>등록자</label></th>
										   <td>
											   <input id="register" class="form-control w_18" type="text" placeholder="등록자 입력" title="등록자"/>                                       
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row"><label for="reception_begins"><span class="necessary_icon">*</span>접수일자</label></th>
										   <td>
											   <div class="datepicker_area fl mr5 clearfix">
												   <input type="text" id="receipt_from" class="datepicker form-control w_14 fl" placeholder="접수 시작일" title="접수 시작일"/>								   
											   </div>
											   <div class="datepicker_area fl mr5 clearfix">
												   <input type="text" id="receipt_to" class="datepicker form-control w_14 fl" placeholder="접수 종료일" title="접수 종료일"/>					   
											   </div>
										   </td> 
									   </tr>								   
									   <tr>
										   <th scope="row"><span class="necessary_icon">*</span>공고 내용</th>
										   <td>
											   <textarea cols="145" rows="15" id="contents" title="공고 내용"></textarea>                                    
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row"><label for="file_form">첨부파일</label></th>
										   <td>
											   <div class="clearfix file_form_txt">
												   <span class="fl mr10 lh_15"><span class="font_red">※ 공고문, 과업지시서</span> 등 등록</span>
												   <!--업로드 버튼-->
												   <div class="filebox2">
														<form id="frm" method="post" action="" enctype="multipart/form-data">
															<label for="file_upload">파일 선택</label>
															<input type="file" id="file_upload" multiple class="fl gray_btn2 mr5 hidden">
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
								   <button type="button" class="fl blue_btn mr5 tab_2" onclick="window.scrollTo(0,0);">다음</button>							   
							   </div>
					       </div><!--//공고정보-->
						   <!--다음버튼 눌렀을때 기관정보-->
						   <div class="announcement_tab2" style="display:none;">
						       <!--접수관리 view-->
						       
						       <div class="view_top_area clearfix mt30">
								   <h4 class="fl sub_title_h4">개인 정보</h4>								   
							   </div>
							   <table class="list2 agency_information tbody_t">
								   <caption>개인 정보</caption>							  
								   <colgroup>
									   <col style="width: 20%" />
									   <col style="width: 80%" />
								   </colgroup>
								   <tbody id="personal_info_body">
									   <tr>
										   <th scope="row" id="personal_info_1">아이디</th>
										   <td>
											   <input type="radio" id="member_radio_select1" class="checkbox_reception_selected" value='D0000001' name="reception_member_radiooptions1" checked="checked" />
											   <label for="member_radio_select1" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="member_radio_select1_1" class="checkbox_reception_notselected" value='D0000002' name="reception_member_radiooptions1" />
											   <label class="mr10" for="member_radio_select1_1">선택 안함</label>
										   </td> 
									   </tr>							   
									   <tr>
										   <th scope="row" id="personal_info_2">성명</th>
										   <td>									   
											   <input type="radio" id="member_radio_select2" class="checkbox_reception_selected" value="D0000001" name="reception_member_radiooptions2" checked="checked" />
											   <label for="member_radio_select2" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="member_radio_select2_2" class="checkbox_reception_notselected" value='D0000002' name="reception_member_radiooptions2" />
											   <label class="mr10" for="member_radio_select2_2">선택 안함</label>	   						   
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row" id="personal_info_3">휴대전화</th>
										   <td>
										       <input type="radio" id="member_radio_select3" class="checkbox_reception_selected" value="D0000001" name="reception_member_radiooptions3" checked="checked" />
											   <label for="member_radio_select3" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="member_radio_select3_2" class="checkbox_reception_notselected" value='D0000002' name="reception_member_radiooptions3" />
											   <label class="mr10" for="member_radio_select3_2">선택 안함</label>
											</td> 
									   </tr>
									   <tr>
										   <th scope="row" id="personal_info_4">이메일</th> 
										   <td>
										       <input type="radio" id="member_radio_select4" class="checkbox_reception_selected" value="D0000001" name="reception_member_radiooptions4" checked="checked" />
											   <label for="member_radio_select4" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="member_radio_select4_2" class="checkbox_reception_notselected" value="D0000002" name="reception_member_radiooptions4" />
											   <label class="mr10" for="member_radio_select4_2">선택 안함</label>
										   </td>
									   </tr>
									   <tr>
										   <th scope="row" id="personal_info_5">주소</th> 
										   <td>
										       <input type="radio" id="member_radio_select5" class="checkbox_reception_selected" value="D0000001" name="reception_member_radiooptions5" checked="checked" />
											   <label for="member_radio_select5" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="member_radio_select5_2" class="checkbox_reception_notselected" value="D0000002" name="reception_member_radiooptions5" />
											   <label class="mr10" for="member_radio_select5_2">선택 안함</label>
										   </td>
									   </tr>									   
								   </tbody>
							   </table>						   
							   <!--//개인정보-->
						       
							   <!--기관정보-->
							   <div class="view_top_area clearfix mt30">
								   <h4 class="fl sub_title_h4">기관 정보</h4>							  
							   </div>
							   <table class="list2 agency_information tbody_t">
								   <caption>기관 정보</caption> 
								   <colgroup>
									   <col style="width: 20%" />
									   <col style="width: 80%" />
								   </colgroup>
								   <tbody id="agency_information_body">
									   <tr>
										   <th scope="row" id="institutions_name_1">사업자 등록번호</th>
										   <td>
											   <input type="radio" id="radio_select1" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions1" checked="checked" /><label for="radio_select1" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select1_1" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions1" /><label class="mr10" for="radio_select1_1">선택 안함</label>
										   </td> 
									   </tr>							   
									   <tr>
										   <th scope="row" id="institutions_name_2">기관명</th>
										   <td>									   
											   <input type="radio" id="radio_select2" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions2" checked="checked" /><label for="radio_select2" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select2_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions2" /><label class="mr10" for="radio_select2_2">선택 안함</label>	   						   
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_3">주소</th>
										   <td>
										       <input type="radio" id="radio_select3" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions3" checked="checked" /><label for="radio_select3" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select3_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions3" /><label class="mr10" for="radio_select3_2">선택 안함</label>
											</td> 
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_4">전화</th> 
										   <td>
										       <input type="radio" id="radio_select4" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions4" checked="checked" /><label for="radio_select4" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select4_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions4" /><label class="mr10" for="radio_select4_2">선택 안함</label>
										   </td>
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_5">대표자명</th> 
										   <td>
										       <input type="radio" id="radio_select5" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions5" checked="checked" /><label for="radio_select5" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select5_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions5" /><label class="mr10" for="radio_select5_2">선택 안함</label>
										   </td>
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_6">업종</th> 
										   <td>
											   <input type="radio" id="radio_select6" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions6" checked="checked" /><label for="radio_select6" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select6_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions6" /><label class="mr10" for="radio_select6_2">선택 안함</label>
										   </td>
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_7">업태</th> 
										   <td>
											   <input type="radio" id="radio_select7" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions7" checked="checked" /><label for="radio_select7" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select7_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions7" /><label class="mr10" for="radio_select7_2">선택 안함</label>
										   </td>
									   </tr>
									   <tr>
									       <th scope="row" id="institutions_name_8">설립일</th>
									       <td>
										       <input type="radio" id="radio_select8" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions8" checked="checked" /><label for="radio_select9" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select8_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions8" /><label class="mr10" for="radio_select9_2">선택 안함</label>
											</td>
									   </tr>
									   <tr>
									       <th scope="row" id="institutions_name_9">설립 구분</th>
									       <td>
										       <input type="radio" id="radio_select9" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions9" checked="checked" /><label for="radio_select9" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select9_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions9" /><label class="mr10" for="radio_select9_2">선택 안함</label>
											</td>
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_10">기업 분류</th>
										   <td>
											   <input type="radio" id="radio_select10" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions10" checked="checked" /><label for="radio_select10" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select10_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions10" /><label class="mr10" for="radio_select10_2">선택 안함</label>					  
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_11">기업 유형</th>
										   <td>
											   <input type="radio" id="radio_select11" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions11" checked="checked" /><label for="radio_select11" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select11_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions11" /><label class="mr10" for="radio_select11_2">선택 안함</label>						  
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_12">기업부설연구소 유무</th>
										   <td>
											   <input type="radio" id="radio_select12" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions12" checked="checked" /><label for="radio_select12" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select12_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions12" /><label class="mr10" for="radio_select12_2">선택 안함</label>					  
										   </td> 
									   </tr>
   									   <tr>
										   <th scope="row" id="institutions_name_13">종업원수</th>
										   <td>
											   <input type="radio" id="radio_select13" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions13" checked="checked" /><label for="radio_select13" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select13_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions13" /><label class="mr10" for="radio_select13_2">선택 안함</label>					  
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_14">매출액(최근3년)</th>
										   <td>
											   <input type="radio" id="radio_select14" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions14" checked="checked" /><label for="radio_select14" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select14_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions14" /><label class="mr10" for="radio_select14_2">선택 안함</label>					  
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row" id="institutions_name_15">자본금</th>
										   <td>
											   <input type="radio" id="radio_select15" class="checkbox_reception_selected" value='D0000001' name="reception_institutions_radiooptions15" checked="checked" /><label for="radio_select15" style="margin-right:13px;font-size:15px">선택</label>
											   <input type="radio" id="radio_select15_2" class="checkbox_reception_notselected" value='D0000002' name="reception_institutions_radiooptions15" /><label class="mr10" for="radio_select15_2">선택 안함</label>					  
										   </td> 
									   </tr>
								   </tbody>
							   </table>						   					   
							   <!--//기관정보-->
							   
							   <!--연구책임자 정보-->
							   <div class="view_top_area mt30 clearfix">
								   <h4 class="sub_title_h4 fl">연구책임자 정보</h4>							   
							   </div>
							   <table class="list2 technology_information tbody_t">
								   <caption>연구책임자 정보</caption> 
								   <colgroup>
									   <col style="width: 20%" />
									   <col style="width: 80%" />
								   </colgroup>								   
								   <tbody id="consulting_reception_body">
								       <tr>
									       <th scope="row" id="consulting_reception_name_1">성명</th>
									       <td>
										       <input type="radio" id="consulting_reception_name1" class="checkbox_reception_selected" value='D0000001' name="consulting_reception1" checked />
										       <label for="consulting_reception_name1" class="mr10">선택</label>
											   <input type="radio" id="consulting_reception_name2" class="checkbox_reception_notselected" value='D0000002' name="consulting_reception1" />
											   <label for="consulting_reception_name2" class="mr10">선택 안함</label>
										   </td> 
								       </tr>
									   <tr>
									       <th scope="row" id="consulting_reception_name_2">휴대전화</th>
									       <td>
										       <input type="radio" id="consulting_reception_phone1" class="checkbox_reception_selected" value='D0000001' name="consulting_reception2" checked />
										       <label for="consulting_reception_phone1" class="mr10">선택</label>
											   <input type="radio" id="consulting_reception_phone2" class="checkbox_reception_notselected" value='D0000002' name="consulting_reception2" />
											   <label for="consulting_reception_phone2" class="mr10">선택 안함</label>
										   </td> 
								       </tr>
									   <tr>
									       <th scope="row" id="consulting_reception_name_3">이메일</th>
									       <td>
										       <input type="radio" id="consulting_reception_email1" class="checkbox_reception_selected" value='D0000001' name="consulting_reception3" checked />
										       <label for="consulting_reception_email1" class="mr10">선택</label>
											   <input type="radio" id="consulting_reception_email2" class="checkbox_reception_notselected" value='D0000002' name="consulting_reception3" />
											   <label for="consulting_reception_email2" class="mr10">선택 안함</label>
										   </td>  
								       </tr>
									   <tr>
									       <th scope="row" id="consulting_reception_name_4">주소</th>
									       <td>
										       <input type="radio" id="consulting_reception_adress1" class="checkbox_reception_selected" value='D0000001' name="consulting_reception4" checked />
										       <label for="consulting_reception_adress1" class="mr10">선택</label>
											   <input type="radio" id="consulting_reception_adress1_2" class="checkbox_reception_notselected" value='D0000002' name="consulting_reception4" />
											   <label for="consulting_reception_adress1_2" class="mr10">선택 안함</label>
										   </td>  
								       </tr>
									   <tr>
									       <th scope="row" id="consulting_reception_name_5">기관명</th>
									       <td>
										       <input type="radio" id="consulting_reception_companyname1" class="checkbox_reception_selected" value='D0000001' name="consulting_reception5" checked />
										       <label for="consulting_reception_companyname1" class="mr10">선택</label>
											   <input type="radio" id="consulting_reception_companyname1_2" class="checkbox_reception_notselected" value='D0000002' name="consulting_reception5" />
											   <label for="consulting_reception_companyname1_2" class="mr10">선택 안함</label>
										   </td>  
								       </tr>
									   <tr>
									       <th scope="row" id="consulting_reception_name_6">부서</th>
									       <td>
										       <input type="radio" id="consulting_reception_part1" class="checkbox_reception_selected" value='D0000001' name="consulting_reception6" checked />
										       <label for="consulting_reception_part1" class="mr10">선택</label>
											   <input type="radio" id="consulting_reception_part2" class="checkbox_reception_notselected" value='D0000002' name="consulting_reception6" />
											   <label for="consulting_reception_part2" class="mr10">선택 안함</label>
										   </td> 
								       </tr>
                                       <tr>
									       <th scope="row" id="consulting_reception_name_7">직책</th>
									       <td>
										       <input type="radio" id="consulting_reception_position1" class="checkbox_reception_selected" value='D0000001' name="consulting_reception7" checked />
										       <label for="consulting_reception_position1" class="mr10">선택</label>
											   <input type="radio" id="consulting_reception_position2" class="checkbox_reception_notselected" value='D0000002' name="consulting_reception7" />
											   <label for="consulting_reception_position2" class="mr10">선택 안함</label>
										   </td> 
								       </tr>
								   </tbody>
							   </table>
							   <!--//연구책임자 정보-->	

							   <!--기술정보-->
							   <div class="view_top_area mt30 clearfix">
								   <h4 class="sub_title_h4 fl">기술 정보</h4>		
							   </div>
							   <table class="list2 technology_information tbody_t">
								   <caption>기술 정보</caption> 
								   <colgroup>
									   <col style="width: 20%" />
									   <col style="width: 80%" />
								   </colgroup>								   
								   <tbody id="technology_body">
								       <tr>
										   <th scope="row" id="technology_name_1">기술명</th>
										   <td>									   
											   <input type="radio" id="radio_select13" class="checkbox_reception_selected" name="reception_technique_radiooptions1" value="D0000001" checked="checked" /><label for="radio_select13" class="mr10">선택</label>
											   <input type="radio" id="radio_select13_2" class="checkbox_reception_notselected" name="reception_technique_radiooptions1" value="D0000002"/>
											   <label for="radio_select14_2" class="mr10">선택 안함</label>	   						   
										   </td>
									   </tr>
									   <tr>
										   <th scope="row" id="technology_name_2">국가과학기술분류</th>
										   <td>									   
											   <input type="radio" id="radio_select14" class="checkbox_reception_selected" name="reception_technique_radiooptions2" value="D0000001" checked="checked" /><label for="radio_select14" class="mr10">선택</label>
											   <input type="radio" id="radio_select14_2" class="checkbox_reception_notselected" name="reception_technique_radiooptions2" value="D0000002"/>
											   <label for="radio_select14_2" class="mr10">선택 안함</label>	   						   
										   </td> 
									   </tr>
									   <tr>
										   <th scope="row" id="technology_name_3">기술개요</th>
										   <td>
											   <input type="radio" id="radio_select15" class="checkbox_reception_selected" name="reception_technique_radiooptions3" value="D0000001" checked="checked" /><label for="radio_select15" class="mr10">선택</label>
											   <input type="radio" id="radio_select15_2" class="checkbox_reception_notselected" name="reception_technique_radiooptions3" value="D0000002"/>
											   <label for="radio_select15_2" class="mr10">선택 안함</label>	   	
											</td> 
									   </tr>
									   <tr>
										   <th scope="row" id="technology_name_4">특징</th>
										   <td>
											   <input type="radio" id="radio_select16" class="checkbox_reception_selected" name="reception_technique_radiooptions4" value="D0000001" checked="checked" /><label for="radio_select16" class="mr10">선택</label>
											   <input type="radio" id="radio_select16_2" class="checkbox_reception_notselected" name="reception_technique_radiooptions4" value="D0000002"/>
											   <label  for="radio_select16_2" class="mr10">선택 안함</label>	   	
											</td> 
									   </tr>
									   <tr>
										   <th scope="row" id="technology_name_5">기대효과</th>
										   <td>
											   <input type="radio" id="radio_select17" class="checkbox_reception_selected" name="reception_technique_radiooptions5" value="D0000001" checked="checked" />
											   <label for="radio_select17" class="mr10">선택</label>
											   <input type="radio" id="radio_select17_2" class="checkbox_reception_notselected" name="reception_technique_radiooptions5" value="D0000002"/>
											   <label for="radio_select17_2" class="mr10">선택 안함</label>	   	
											</td> 
									   </tr>
								   </tbody>
							   </table>							   
							   <!--//기술정보-->
							   
							   <!--제출서류-->
							   <div class="view_top_area clearfix mt30">
								   <h4 class="fl sub_title_h4">제출 서류</h4>	
								   <div class="mt10 ta_r fr"><button type="button" class="gray_btn" onClick="addDocumentInfo();">추가</button></div>
							   </div>
							   <div style="overflow-x:auto;">						       
								   <table class="list submission">
									   <caption>제출 서류</caption> 
									   <colgroup>
										   <col style="width: 10%" />
										   <col style="width: 40%" />
										   <col style="width: 20%" />
										   <col style="width: 10%" />
										   <col style="width: 10%" />
										   <col style="width: 10%" />
									   </colgroup>
									   <thead>
										   <tr>								   
											   <th scope="colgroup" colspan="3">제출 서류 목록</th> 
											   <th scope="colgroup" colspan="3">구분</th> 
										   </tr>
										   <tr>
											   <th scope="col">No.</th>
											   <th scope="col">파일명</th>
											   <th scope="col">파일 형식</th>
											   <th scope="col">필수</th>
											   <th scope="col">선택</th>
											   <th scope="col">선택 안함</th>
										   </tr>
									   </thead>
									   <tbody id="document_body">
										   <tr>
											   <td>1</td>
											   <td><span id="doc_ext_name_1">문제해결 신청서</span></td>
											   <td>PDF</td>
											   <td><input type="radio" class="checkbox_reception_selected" name="reception_document_radiooptions1" value="D0000003" checked />
											   <label class="w_0">&nbsp;</label></td>
											   <td><input type="radio" class="checkbox_reception_notselected" name="reception_document_radiooptions1" value="D0000001"/>
											   <label class="w_0">&nbsp;</label></td>
											   <td><input type="radio" class="checkbox_reception_notselected" name="reception_document_radiooptions1" value="D0000002"/>
											   <label class="w_0">&nbsp;</label></td>
										   </tr>
										   <tr>
											   <td>2</td>
											   <td><span id="doc_ext_name_2">개인정보 수집 및 이용동의서</span></td>
											   <td>PDF</td>
											   <td><input type="radio" class="checkbox_reception_selected" name="reception_document_radiooptions2" value="D0000003" checked />
											   <label class="w_0">&nbsp;</label></td>
											   <td><input type="radio" class="checkbox_reception_notselected" name="reception_document_radiooptions2" value="D0000001"/>
											   <label class="w_0">&nbsp;</label></td>
											   <td><input type="radio" class="checkbox_reception_notselected" name="reception_document_radiooptions2" value="D0000002"/>
											   <label class="w_0">&nbsp;</label></td>
										   </tr>
										   <tr>
											   <td>3</td>
											   <td><span id="doc_ext_name_3">기술공모 참가 서약서</span></td>
											   <td>PDF</td>
											   <td><input type="radio" class="checkbox_reception_selected" name="reception_document_radiooptions3" value="D0000003" checked/>
											   <label class="w_0">&nbsp;</label></td>
											   <td><input type="radio" class="checkbox_reception_notselected" name="reception_document_radiooptions3" value="D0000001"  />
											   <label class="w_0">&nbsp;</label></td>
											   <td><input type="radio" class="checkbox_reception_notselected" name="reception_document_radiooptions3" value="D0000002"/>
											   <label class="w_0">&nbsp;</label></td>
										   </tr>
										   <tr>
											   <td>4</td>
											   <td><span id="doc_ext_name_4">기타 증빙자료(도면, 시험성적서, 성능인증서, 시방서, 단가산출집계표, 단가산출서, 사업자등록증, 신용평가등급확인서 등)</span></td>
											   <td>PDF</td>
											   <td><input type="radio" class="checkbox_reception_selected" name="reception_document_radiooptions4" value="D0000003"/>
											   <label class="w_0">&nbsp;</label></td>
											   <td><input type="radio" class="checkbox_reception_notselected" name="reception_document_radiooptions4" value="D0000001" checked />
											   <label class="w_0">&nbsp;</label></td>
											   <td><input type="radio" class="checkbox_reception_notselected" name="reception_document_radiooptions4" value="D0000002"/>
											   <label class="w_0">&nbsp;</label></td>
										   </tr>
									   </tbody>
								   </table>
							   </div>
							   <!--//제출서류 view-->

							   <!--체크리스트-->
							   <div class="view_top_area clearfix mt30">
								   <h4 class="fl sub_title_h4">체크리스트</h4>							  
							   </div>
							   <table class="list2 ">
								   <caption>체크리스트</caption> 
								   <colgroup>
									   <col style="width: 20%" />
									   <col style="width: 80%" />
								   </colgroup>
								   <thead>
									   <tr>
										   <th scope="row"><span class="ta_c ">체크리스트</span></th>
										   <td>									   
											   <input type="radio" value="D0000001" name="reception_check_radiooptions1" checked/>
											   <label class="mr10">사용</label>
											   <input type="radio" value="D0000002" name="reception_check_radiooptions1" />
											   <label class="mr10">사용 안함</label>
										   </td> 
									   </tr>								   
								   </thead>
								   <tbody id="checklist_body">
									   <tr>
										   <td colspan="2" class="ta_c">
											   <div class="checklist_box">
												   <div class="checklist_txtbox_area">													   	
												       <div class="checklist_txtbox_title clearfix">
														   <span class="fl mr20">항목 1.</span>
														   <div class="ta_l fl">
															    <input type="radio" value="D0000001" name="checklist_popupcheck_selected1" checked="checked" id="use_checklist" />
																<label class="mr10">사용</label>
																<input type="radio" value="D0000002" name="checklist_popupcheck_selected1" id="not_checklist" />
																<label class="mr10">사용 안함</label>
														   </div>													   	
													   </div>
											           <div class="checklist_txt_area">
														   <span class="dim_box" style="display:none">&nbsp;</span>
														   <div class="checklist_txtbox w100">
																<textarea name="checklist_txt_box1" id="checklist_title1" class="bd_n mr5 mb10 w100" disabled>동일 솔루션(제품·서비스)의 타 실증 사업 수행한 또는 중입니까?(계획서 제출 전 국가과학기술지식정보서비스(www.ntis.go.kr)에서 개별 확인 후 지원)※ 기존 예산지원 사업으로 개발[완료]된 솔루션(제품·서비스)은 지원 가능</textarea>
															 <!--<input type="button" class="fl document_disabled_btn gray_btn mb10" value="입력" />  --> 
																<div class="checklist_txtbox_popuparea clearfix">    
																	<table class="list">
																		<caption>체크리스트 팝업</caption> 
																		<colgroup>
																			 <col style="width: 20%" />
																			 <col style="width: 35%" />
																			 <col style="width: 50%" />
																		 </colgroup>
																		 <thead>
																			<tr>
																			   <th scope="col">팝업 사용</th>
																			   <th scope="col"><span class="ta_c ">팝업 경고</span></th>
																			   <th scope="col"><span class="ta_c ">팝업 경고 내용</span></th>
																			</tr>								   
																		 </thead>
																		 <tbody>
																			<tr>
																			   <td><input type="checkbox" name="chkbox" class="checkbox_member_manager_table" id="popup_use_yn1"/><label>&nbsp;</label></td>
																			   <td><span><label>&nbsp;</label></span>
																				  <input type="radio" id="checkbox_receptionpopup2_1" value="D0000001" name="checkbox_receptionpopup_selected1" checked />
																				  <label for="checkbox_receptionpopup2_1">예</label>&nbsp;&nbsp;&nbsp;
																				  <input type="radio" id="checkbox_receptionpopup2_2" value="D0000002" name="checkbox_receptionpopup_selected1" />
																				  <label for="checkbox_receptionpopup2_2">아니오</label></td>
																			   <td><textarea name="checkbox_receptionpopup-txt" id="check_list_popup_title1" class="checkbox_receptionpopup_txt1 w100 bd_n" disabled>동일 솔루션 실증 수행 사업은 지원 대상이 아닙니다.</textarea></td>
																			</tr>
																		 </tbody>
																    </table>                                                                                                
															    </div>
														   </div>
													   </div>	
												   </div>
											   </div>
											   <div class="checklist_box">
												   <div class="checklist_txtbox_area">													   	
												       <div class="checklist_txtbox_title clearfix">
														   <span class="fl mr20">항목 2.</span>
														   <div class="ta_l fl">
															    <input type="radio" value="D0000001" name="checklist_popupcheck_selected2" checked="checked" id="use_checklist2" />
																<label class="mr10">사용</label>
																<input type="radio" value="D0000002" name="checklist_popupcheck_selected2" id="not_checklist2" />
																<label class="mr10">사용 안함</label>
														   </div>													   	
													   </div>
											           <div class="checklist_txt_area">
														   <span class="dim_box" style="display:none">&nbsp;</span>
														   <div class="checklist_txtbox w100">
																<textarea name="checklist_txt_box1" id="checklist_title2" class="bd_n mr5 mb10 w100" disabled>주관기관이 접수마감일 기준 본점 또는 지점이 법인등기부등본 상 서울시에 소재한 중소기업(법인) 또는 서울시 소재 관할 세무서에 사업자등록을 한 중소기업(법인)입니까?</textarea>
																<div class="checklist_txtbox_popuparea clearfix">    
																	<table class="list">
																		<caption>체크리스트 팝업</caption> 
																		<colgroup>
																			 <col style="width: 20%" />
																			 <col style="width: 35%" />
																			 <col style="width: 50%" />
																		 </colgroup>
																		 <thead>
																			<tr>
																			   <th scope="col">팝업 사용</th>
																			   <th scope="col"><span class="ta_c ">팝업 경고</span></th>
																			   <th scope="col"><span class="ta_c ">팝업 경고 내용</span></th>
																			</tr>								   
																		 </thead>
																		 <tbody>
																			<tr>
																			   <td><input type="checkbox" name="chkbox" class="checkbox_member_manager_table" id="popup_use_yn2"/><label>&nbsp;</label></td>
																			   <td><span><label>&nbsp;</label></span>
																				  <input type="radio" id="checkbox_receptionpopup1_1" value="D0000001" name="checkbox_receptionpopup_selected2" checked />
																				  <label for="checkbox_receptionpopup1_1">예</label>&nbsp;&nbsp;&nbsp;
																				  <input type="radio" id="checkbox_receptionpopup1_2" value="D0000002" name="checkbox_receptionpopup_selected2" />
																				  <label for="checkbox_receptionpopup1_2">아니오</label></td>
																			   <td><textarea name="checkbox_receptionpopup-txt" id="check_list_popup_title2" class="checkbox_receptionpopup_txt1 w100 bd_n" disabled>동일 솔루션 실증 수행 사업은 지원 대상이 아닙니다.</textarea></td>
																			</tr>
																		 </tbody>
																    </table>                                                                                                
															    </div>
														   </div>
													   </div>	
												   </div>
											   </div>											      
											   
											   <div class="w93 pt10" style="text-align:right;margin:auto"><button class="gray_btn" onclick="addCheckList();">추가</button></div>  
										   </td>								   	   
									   </tr>								   
								    </tbody>
							   </table>
							   <!--//체크리스트-->	
							   
							   <div class="fr mt30">
							   	   <button type="button" class="gray_btn2 tab_1" onclick="window.scrollTo(0,0);">이전</button>
								   <button type="button" class="blue_btn2" onclick="prepareRegistration('D0000001');">임시 저장</button>
								   <button type="button" class="blue_btn" onclick="prepareRegistration('D0000002');">등록</button>
								   <button type="button" class="gray_btn2" onclick="location.href='/admin/fwd/announcement/match/main'">목록</button>
							   </div>
						   </div><!--contents_view-->
						   </div><!--//다음버튼 눌렀을때 기관정보-->	
					   </div><!--//contents view-->

                   </div>
				   <!--//contents--> 

                </div>
                <!--//sub--> 
            </div>
            <!--//container-->

            
            
            <!--popup-->
	   <!--등록 팝업-->
	   <div class="announcement_write_popup_box">
		   <div class="popup_bg"></div>
		   <div class="announcement_write_popup">
		       <div class="popup_titlebox clearfix">
			       <h4 class="fl">공고 등록</h4>
			       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
			   </div>
			   <div class="popup_txt_area">
				   <p>작성하신 정보로 <span class="font_blue">공고 등록</span>을 하시겠습니까?</p>
				   <div class="popup_button_area_center clearfix mt10">
					   <button type="button" class="blue_btn mr5" onclick="registration('D0000002');">예</button>
					   <button type="button" class="gray_btn popup_close_btn">아니요</button>
				   </div>
			   </div>
		   </div>
	   </div>
	   <!--//등록 팝업-->
       
	   <!--임시저장 팝업-->
	   <div class="temporary_storage_popup_box">
		   <div class="popup_bg"></div>
		   <div class="temporary_storage_popup">
		       <div class="popup_titlebox clearfix">
			       <h4 class="fl">공고등록 임시저장</h4>
			       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
			   </div>
			   <div class="popup_txt_area">
				   <p>작성하신 정보로 <span class="font_blue">임시저장</span> 하시겠습니까?</p>
				   <div class="popup_button_area_center">
					   <button type="button" class="blue_btn mr5" onclick="registration('D0000001');">예</button>
					   <button type="button" class="gray_btn popup_close_btn">아니요</button>
				   </div>
			   </div>
		   </div>
	   </div>
	   <!--//임시저장 팝업-->