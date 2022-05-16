<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="principal.username" var="member_id" />

<script type='text/javascript'>
	var institutionName;
	var agreementStatus;

	$(document).ready(function() {
		// 협약 목록
		searchDetail(); 

		$("#file_upload").on("change", addFiles);

	});


	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/execution/search/detail");
		comAjax.setCallback(searchDetailCB);
		comAjax.addParam("execution_id", "${vo.execution_id}");
		comAjax.ajax();
	}

	function searchDetailCB(data) {
		console.log(data);
		$("#agreement_reg_number").html("<span>" + data.result_data.agreement_reg_number + "</span>");
		$("#announcement_business_name").html("<span>" + data.result_data.announcement_business_name + "</span>");
		$("#announcement_title").html("<span>" + data.result_data.announcement_title + "</span>");
		$("#tech_info_name").html("<span>" + data.result_data.tech_info_name + "</span>");
		$("#research_info").html("<span>" + data.result_data.institution_name + "/" + data.result_data.researcher_name + "</span>");
		$("#research_date").html("<span>" + data.result_data.research_date + "</span>");
		if ( gfn_isNull(data.result_data.research_funds) ) {
			$("#research_funds").html("<span>0 (만원)</span>");
		} else {
			$("#research_funds").html("<span>" + data.result_data.research_funds + " (만원)</span>");
		}

		// 파일 이름
		$("#middle_report_file_name").text(data.result_data.middle_report_file_name);
		$("#final_report_file_name").text(data.result_data.final_report_file_name);
		if ( data.result_data.return_upload_files != null) {
	    	uploaded_files = data.result_data.return_upload_files;
	    	$("#fileList").empty();
	    	for(var i=0; i<uploaded_files.length; i++) {
		    	$("#fileList").append("<li>" + uploaded_files[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + i + "\");'><span class='d_n'>파일</span><i class='fas fa-times'></i></a></li>");
		    }
		}

		// 변경 이력
		var body = $("#changes_list_body");
		body.empty();
		var str = "<tr>";
		str += "		<th scope='col'>변경 완료일</th>";
		str += "		<th scope='col'>변경 내용</th>";
		str += "		<th scope='col'>변경 공문</th> ";
		str += "</tr>";
		
		if ( gfn_isNull(data.result_data.changes_list) || data.result_data.changes_list.length == 0 ) {
			str += "<tr>" + "<td colspan='3'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
		} else {
			$.each(data.result_data.changes_list, function(key, value) {
				str += "<tr>";
				str += "	<td>" + value.change_date + "</td>";
				str += "	<td>" + value.changes + "</td>";
				str += "	<td><a href='javascript:void(0);' file_id='" + value.official_notice_file_id + "' onclick='downloadFile(this)'>" + value.official_notice_file_name + "</a></td>";
				str += "</tr>";
			});
			body.append(str);
		}

		if ( gfn_isNull(data.result_data.middle_report_date) == false && gfn_isNull(data.result_data.final_report_date) == false ) {
			$("#btn_tempSave").hide();
			$("#btn_submitReport").hide();
		}
	}


	// 수행 내역 저장
	// '1'이면 임시저정 '2'이면 제출
	var finishRegistration = false;
	function onRegistration(type) {

		var formData = new FormData();
		formData.append("execution_id", "${vo.execution_id}");
		// 파일 정보
		if ( $("#middle_report_file")[0].files[0] != null) {
			formData.append("middle_report_file", $("#middle_report_file")[0].files[0]);
		}
		if ( $("#final_report_file")[0].files[0] != null) {
			formData.append("final_report_file", $("#final_report_file")[0].files[0]);
		}
		
		// 새로 업로드된 파일만 업데이트 한다.
 		for (var i=0; i<uploaded_files.length; i++ ) {
 	 		if ( uploaded_files[i] instanceof File )
			formData.append("upload_files", uploaded_files[i]);
		} 
		// 삭제된 파일 리스트 전송
		formData.append("delete_file_list", deleteFileList); 
		

		$.ajax({
		    type : "POST",
		    url : "/member/api/execution/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	if ( type == '1') {
		        		showPopup("임시저장 되었습니다.", "임시저장 안내닫기");
		        		finishRegistration = true;
		        		return true;
		        	}
		        } else {
		        	if ( type == '1') {
		        		showPopup("임시저장에 실패하였습니다.", "임시저장 안내닫기");
		        		return false;
		        	}
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		        return false;
		    }
		});
	}

	// 수행 제출
	var finishSubmit = false;
	function onSubmitExecution() {
		// 협약서 저장
		if ( onRegistration('2') == false ) {
			showPopup("협약서 저출에 실패하였습니다.", "제출 안내닫기");
			return;
		}

		var formData = new FormData();
		formData.append("execution_id", "${vo.execution_id}");
		formData.append("execution_status", "수행완료");
			
		$.ajax({
		    type : "POST",
		    url : "/member/api/execution/modification",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
			    if ( jsonData.result == true) {
			    	showPopup("수행서 제출이 완료되었습니다.", "수행서 제출안내");
			    	finishSubmit = true;
			    } else {
			    	showPopup("수행서 제출에 실패했습니다. 디시 시도해 주시기 바랍니다.", "수행서 제출안내");
			    }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});

	}

	// 파일 추가
	var uploaded_files = new Array();
	var filesTempArr = new Array();
	function addFiles(e) {
	    var files = e.target.files;
	    var filesArr = Array.prototype.slice.call(files);
	    var filesArrLen = filesArr.length;
	    var filesTempArrLen = uploaded_files.length;

	    for( var i=0; i<filesArrLen; i++ ) {
	    	uploaded_files.push(filesArr[i]);
	        $("#fileList").append("<li>" + filesArr[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + (filesTempArrLen+i)+ "\");'><span class='d_n'>파일</span><i class='fas fa-times'></i></a></li>");
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
	    
	    $("#fileList").empty();
	    for(var i=0; i<filesTempArrLen; i++) {
	    	$("#fileList").append("<li>" + uploaded_files[i].name + "<a href='javascript:void(0);' class='fr' onclick='deleteFile(\"" + i + "\");'><span class='d_n'>파일</span><i class='fas fa-times'></i></a></li>");
	    }
	}
	
	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
 		if ( finishSubmit ) {
			$('.send_save_popup_box').fadeOut(350);
	    	location.href = "/member/fwd/execution/main";
		}

 		if (finishRegistration) {
 			$('.send_save_popup_box').fadeOut(350);
	    	location.reload();
 		}

		
		$('.common_popup_box, .common_popup_box .popup_bg').fadeOut(350);
	}

</script>
            
<!-- container -->
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>					
	<section id="content">
		<div id="sub_contents">
		    <div class="content_area">
				<h3>수행</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>수행</li>
						<li>수행</li>
					</ul>
				</div>
				
				
				<!--기관-->
				<div class="content_area copmpany_area execute_area" id="copmpany_area">													
					<div class="table_area">
						<h4>과제 정보</h4>	
						<!--과제 정보-->
						<table class="write fixed assignment_info">
							<caption>과제 정보</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<tbody>	
								<tr>
									<th scope="row">과제번호</th>
								    <td id="agreement_reg_number"></td> 
							    </tr>
							    <tr>
									<th scope="row">사업명</th>
								    <td id="announcement_business_name"></td> 
							    </tr>																	       
								<tr>
									<th scope="row">공고명</th>
								    <td id="announcement_title"></td> 
								</tr>
								<tr>
								    <th scope="row">기술명</th>
								    <td id="tech_info_name"></td> 
								</tr>
								<tr>
								    <th scope="row">연구기관/연구책임자</th>
								    <td id="research_info"></td> 
								</tr>
								<tr>
								    <th scope="row">연구기간</th>
								    <td id="research_date"></td> 
								</tr>
								<tr>
								    <th scope="row">연구비</th>
								    <td id="research_funds"><span class="fl mr5"></span><span class="fl">(만원)</span></td> 
								</tr>
							</tbody>
				        </table>
						<!--//과제 정보-->								    
						
						<!--과제 보고서-->									
						<h4 class="sub_title_h4">과제 보고서</h4>										
					    <table class="write fixed">
							<caption>과제 보고서</caption> 
							<colgroup>
							    <col style="width: 20%">
							    <col style="width: 80%">
							</colgroup>
							<tbody>		
							    <tr>
									<th scope="row">중간보고서</th>
									<td>										
										<div class="clearfix file_form_txt">													   
										   <!--업로드 버튼-->
										   <div class="job_file_upload w100"> 
												<div class="custom-file w100">
													<input type="file" class="custom-file-input custom-file-input-write-company" id="middle_report_file">
													<label class="custom-file-label custom-control-label-write-company" id="middle_report_file_name" for="middle_report_file">선택된 파일 없음</label>
												</div>															
										   </div>													   
										   <!--//업로드 버튼-->
									    </div>			
									</td> 
							    </tr>															       
							    <tr>
									<th scope="row">최종보고서</th>
									<td>										
										<div class="file_form_txt">													   
										   <!--업로드 버튼-->
										   <div class="job_file_upload w100"> 
												<div class="custom-file w100">
													<input type="file" class="custom-file-input custom-file-input-write-company" id="final_report_file">
													<label class="custom-file-label custom-control-label-write-company" id="final_report_file_name" for="final_report_file">선택된 파일 없음</label>
												</div>															
										   </div>													   
										   <!--//업로드 버튼-->
									    </div>			
									</td> 
							    </tr>
								<tr>
									<th scope="row">기타</th>
									<td>										
										<div class="file_form_txt">													  
										   <!--업로드 버튼-->
										   <div class="filebox2">
												<form method="post" action="upload-multiple.php" enctype="multipart/form-data">
												<label for="file_upload">파일 선택</label>
													<input type="file" id="file_upload" multiple="" class="fl gray_btn2 mr5 hidden">
													<!-- 여기에 파일 목록 태그 추가 -->															
													<ul id="fileList" style="clear:both"></ul>
												</form>
											</div>	
											<!--//업로드 버튼-->
									   </div>		
									</td> 
							    </tr>
							</tbody>
						</table>
						<!--//과제 보고서-->									
						
						<!--과제 변경 이력-->
						<h4>과제 변경 이력</h4>
						<table class="write fixed documentstory">
							<caption>제출서류</caption>
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 40%;">
								<col style="width: 40%;">
							</colgroup>
							<tbody id="changes_list_body">
							</tbody>
				        </table>
						<!--//과제 변경 이력-->
						
						<div class="button_box clearfix fr pb20">
							<button type="button" id="btn_tempSave" class="blue_btn2 fl mr5" onclick="onRegistration('1');">임시저장</button>
							<button type="button" id="btn_submitReport" class="blue_btn fl mr5 agreement_send_popup_open">제출하기</button>
							<button type="button" class="gray_btn fl" onclick="location.href='/member/fwd/execution/main'">목록</button>
						</div>
					</div>	<!--//table_area-->							
				</div><!--//content_area-->
				<!--//기관-->
			</div>
		</div><!--//sub_contents-->
	</section>
</div>
<!-- //container -->


<!--제출하기 팝업-->
<div class="agreement_send_popup_box">		
	<div class="popup_bg"></div>
	<div class="agreement_send_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">제출 안내</h4>							
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">						
			<div class="popup_titlebox_txt">
				<p><span class="font_blue">[예]</span> 버튼을 누르면 제출이 완료되며, 수정은 불가능합니다.</p>							
				<p>제출 완료 후에는 제출완료 상태이며, 담당자가 제출서류를 확인하여 이상이 없을 경우, <br />
					완료될 예정입니다.</p>
				<p class="font_blue fz_b"><span class="fw500 font_blue">제출하시겠습니까?</span></p>
			</div>
		    <div class="popup_button_area_center">
				<button type="submit" class="blue_btn mr5" onclick="onSubmitExecution();">예</button>
				<button type="button" class="gray_btn lastClose layerClose popup_close_btn">아니요</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//제출하기 팝업-->

<!--공통 팝업-->
<div class="common_popup_box">
	<div class="popup_bg"></div>
	<div class="id_check_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl" id="popup_title"></h4>
			<a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p id="popup_info" tabindex="0"></p>	
			</div>
			
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn" title="확인" onclick="commonPopupConfirm();">확인</button>
			</div>
		</div>						
	</div> 
</div>