<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<sec:authentication property="principal.username" var="member_id" />
 
<script src="/assets/admin/biz_js/reception/search.js"></script>
<script src="/assets/admin/biz_js/reception/expert.js"></script>
 
<script type='text/javascript'>
	$(document).ready(function() {
		// D0000004 - 전문가 매칭인 경우 제출 서류 입력을 만들지 않는다. 
		searchAnnouncementDetail();
		searchReceptionDetail();
		makeDisplay();
	});


	// Reception Status 별로 Expert list 가 달라진다.
	function makeDisplay() {
		// D0000002 - 점수 신청서 작성 완료
		if ( mReceptionDetail.reception_status == "D0000002") {
			$("#complete_btn").show();
			$("#reject_btn").show();
			$("#match_complete").show();
		}
		// 접수 완료 
		else if ( mReceptionDetail.reception_status == "D0000012" ) {
			$("#complete_btn").hide();
			$("#reject_btn").hide();
			$("#match_complete").show();
		}
		// 접수 취소 
		else if ( mReceptionDetail.reception_status == "D0000011" ) {
			$("#complete_btn").hide();
			$("#reject_btn").hide();
			$("#file_download").hide();
			$("#match_complete").show();
		}

		// 전문가 정보
		$.each(mReceptionDetail.choiced_expert_list, function(key, value) {
			if ( value.choiced_yn == "Y") {
				$("#match_complete_name").html("<span>" + value.name + "</span>");
				$("#match_complete_department").html("<span>" + value.institution_department + "</span>");
				$("#match_complete_phone").html("<span>" + value.mobile_phone + "</span>");
				$("#match_complete_email").html("<span>" + value.email + "</span>");
				return false;
			}
		});

		// 제출 서류 정보
		$("#submit_doc_list_body").empty();
		var index = 0;
		// '필수'인 경우
		var requiredDocList = mDocList.filter(item => (item.ext_type === 'D0000005' && item.ext_field_yn === "D0000003"));
		var requiredDoc = "";
		
		$.each(requiredDocList, function(key, value) {
			requiredDoc += "<tr>";
			requiredDoc += "	<td>" + (index+1) + "</td>";
			requiredDoc += "	<td><span><span class='font_red'><strong>(필수)</strong></span>" + value.ext_field_name + "</span></td>";
			requiredDoc += "	<td id='submit_files_name_" + index + "' ext_id='" + value.extension_id + "'></td>";
			requiredDoc += "	<td><input type='radio' name='documents_submitted_" + index + "' value='Y' checked/><label>&nbsp;</label></td>";
			requiredDoc += "	<td><input type='radio' name='documents_submitted_" + index + "' value='N'/><label>&nbsp;</label></td>";
			requiredDoc += "</tr>";
			index++;
		});
		// '사용'인 경우
		var normalDocList = mDocList.filter(item => (item.ext_type === 'D0000005' && item.ext_field_yn === "D0000001"));
		$.each(normalDocList, function(key, value) {
			requiredDoc += "<tr>";
			requiredDoc += "	<td>" + (index+1) + "</td>";
			requiredDoc += "	<td><span><span class='font_blue'><strong>(선택)</strong></span>" + value.ext_field_name + "</span></td>";
			requiredDoc += "	<td id='submit_files_name_" + index + "' ext_id='" + value.extension_id + "'></td>";
			requiredDoc += "	<td><input type='radio' name='documents_submitted_" + index + "' value='Y' checked/><label>&nbsp;</label></td>";
			requiredDoc += "	<td><input type='radio' name='documents_submitted_" + index + "' value='N'/><label>&nbsp;</label></td>";
			requiredDoc += "</tr>";
			index++;
		});
		
		$("#submit_doc_list_body").append(requiredDoc);

		//제출 서류
		$.each(mReceptionDetail.submit_files_list, function(key, value) {
			for (var i=0; i<$("#submit_doc_list_body tr").length; i++ ) {
				if ( $("#submit_files_name_"+i).attr("ext_id") == value.extension_id){
					$("#submit_files_name_"+i).attr("file_id", value.file_id);
					$("#submit_files_name_"+i).html("<a href='/user/api/announcement/download/" + value.file_id + "'><span>" + value.file_name + "</span></a>");
					break;
				}
			}
		});
	}


	function receptionComplete() {
		$('.application_completed_popup_box, .popup_bg').fadeOut(1);
		
		var formData = new FormData();
		formData.append("reception_id", $("#reception_id").val() );
		formData.append("reception_status", "D0000012");
		
		$.ajax({
		    type : "POST",
		    url : "/admin/api/reception/complete",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	alert("접수 신청이 완료되었습니다.");
		    	location.href='/admin/fwd/reception/match/main';
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}


	var isDownloaded = false;
	function downloadSubmitFile(){
		var iFrameCnt = 0;
		for (var i=0; i<$("#submit_doc_list_body tr").length; i++ ) {
			if ( gfn_isNull($("#submit_files_name_"+i).text()) != true ) {
				var url = "/user/api/announcement/download/" + $("#submit_files_name_"+i).attr("file_id");
				if ( isDownloaded != true) {
					// 보이지 않는 iframe 생성, name는 숫자로
					var frm = $('<iframe name="' + iFrameCnt + '" style="display: none;"></iframe>');
				    frm.appendTo("body"); 
				    // Timeout
				    setTimeout(function() {
			    	}, 2000);		
				}
				$("iframe[name=" + iFrameCnt + "]").attr("src", url);
				iFrameCnt++;
			}
		}
		isDownloaded = true;
	}

</script>

<input type="hidden" id="reception_id" name="reception_id" value="${vo.reception_id}" />
<input type="hidden" id="announcement_id" name="announcement_id" value="${vo.announcement_id}" />
<input type="hidden" id="process_status" name="process_status" value="" />

<div class="container" id="content">
	<h2 class="hidden">컨텐츠 화면</h2>
	<div class="sub">
		<!--left menu 서브 메뉴-->     
		<div id="lnb">
	     	<div class="lnb_area">
		        	<!-- 레프트 메뉴 서브 타이틀 -->	
		      	<div class="lnb_title_area">
		       		<h2 class="title">접수관리</h2>
		   		</div>
		               <!--// 레프트 메뉴 서브 타이틀 -->
				<div class="lnb_menu_area">	
				    <ul class="lnb_menu">
				     	<li class="on"><a href="/admin/fwd/reception/main" title="접수관리">접수관리</a></li>
				  		<li class="menu2depth">
						   	<ul>
							   <li class="active"><a href="/admin/fwd/reception/match/main">기술매칭</a></li>
							   <li><a href="/admin/fwd/reception/contest/main">기술공모</a></li>
							   <li><a href="/admin/fwd/reception/proposal/main">기술제안</a></li>
					   		</ul>
				  		</li>
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
						       <li><a href="./index.html"><i class="nav-icon fa fa-home"></i></a></li>
							   <li>접수관리</li>
							   <li><strong>기술매칭</strong></li>
						   </ul>	
						  <!--//페이지 경로-->
						  <!--페이지타이틀-->
						   <h3 class="title_area">기술매칭</h3>
						  <!--//페이지타이틀-->
					    </div>
				    </div>
				    <div class="contents_view">
					   <!--접수관리 view-->						
					   <!--기관정보-->
					   <div class="view_top_area clearfix mt30">
						   <h4 class="fl sub_title_h4">기관 정보</h4>							  
					   </div>
					   <table class="list2 agency_information">
						   <caption>기관 정보</caption> 
						   <colgroup>
							   <col style="width: 20%" />
							   <col style="width: 80%" />
						   </colgroup>
						   <thead>
							   <tr id="institution_reg_number_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>사업자 등록번호</span></th>
								   <td id="institution_reg_number"></td> 
							   </tr>
						   </thead>
						   <tbody>
							   <tr id="institution_name_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기관명</span></th>
								   <td id="institution_name"></td> 
							   </tr>
							   <tr id="institution_address_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>주소</span></th>
								   <td id="institution_address"></td> 
							   </tr>
							   <tr id="institution_phone_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>전화</span></th> 
								   <td id="institution_phone"></td>
							   </tr>
							   <tr id="institution_owner_name_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>대표자명</span></th> 
								   <td id="institution_owner_name"></td>
							   </tr>
							   <tr id="institution_industry_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>업종</span></th> 
								   <td id="institution_industry"></td>
							   </tr>
							   <tr id="institution_business_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>업태</span></th> 
								   <td id="institution_business"></td>
							   </tr>
							   <tr id="institution_foundataion_date_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>설립일</span></th> 
								   <td id="institution_foundataion_date"></td> 
							   </tr>
							   <tr id="institution_foundataion_type_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>설립 구분</span></th> 
								   <td id="institution_foundataion_type"></td> 
							   </tr>
							   <tr id="institution_classification_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기업 분류</span></th> 
								   <td id="institution_classification"></td> 
							   </tr>
							   <tr id="institution_type_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기타 유형</span></th> 
								   <td id="institution_type"></td> 
							   </tr>
							   <tr id="institution_laboratory_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>기업부설연구소 유무</span></th> 
								   <td id="institution_laboratory"></td> 
							   </tr>
							   <tr id="institution_employee_count_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>종업원수</span></th> 
								   <td class="clearfix" id="institution_employee_count"></td> 
							   </tr>
							   <tr id="institution_capital_tr">
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>매출액(최근3년)</span></th> 
								   <td class="clearfix" id="institution_capital"></td> 
							   </tr>
							   <tr id="institution_total_sales_tr"> 
								   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span>자본금</span></th> 
								   <td class="clearfix" id="institution_total_sales"></td> 
							   </tr>
						   </tbody>
					   </table>					   
					   <!--//기관정보-->

					   <!--연구책임자 정보-->
					   <div class="view_top_area mt30" style="clear:both">
						   <h4 class="sub_title_h4">연구책임자 정보</h4>							  
					   </div>
					   <table class="list2 font_white">
						   <caption>연구책임자 정보</caption> 
						   <colgroup>
							   <col style="width: 20%" />
							   <col style="width: 80%" />
						   </colgroup>
						   <thead>
							   <tr id="researcher_name_tr">
								   <th scope="row"><span class="necessary_icon">*</span>성명</th>
								   <td id="researcher_name"></td> 
							   </tr>
						   </thead>
						   <tbody>
						   	   <tr id="researcher_mobile_phone_tr">
								   <th scope="row"><span class="necessary_icon">*</span>휴대전화</th>
								   <td id="researcher_mobile_phone"></td> 
							   </tr>
							   <tr id="researcher_email_tr">
								   <th scope="row"><span class="necessary_icon">*</span>이메일</th>
								   <td id="researcher_email"></td> 
							   </tr>
							   <tr id="researcher_address_tr">
								   <th scope="row"><span class="necessary_icon">*</span>주소</th>
								   <td id="researcher_address"><span></span></td> 
							   </tr>
							   <tr id="researcher_institution_name_tr">
								   <th scope="row"><span class="necessary_icon"></span>기관명</th>
								   <td id="researcher_institution_name"></td> 
							   </tr>
							   <tr id="researcher_institution_department_tr">
								   <th scope="row"><span class="necessary_icon"></span>부서</th>
								   <td id="researcher_institution_department"></td> 
							   </tr>
							   <tr id="researcher_institution_position_tr">
								   <th scope="row"><span class="necessary_icon"></span>직책</th>
								   <td id="researcher_institution_position"></td> 
							   </tr>
						   </tbody>
					   </table>					   
					   <!--//연구책임자 정보-->

					   <!--기술컨설팅 요청사항 -  컨설팅-->						  
					   <div class="view_top_area clearfix mt30">
						   <h4 class="fl sub_title_h4">기술컨설팅 요청사항</h4>							  
					   </div>
					   <table class="list2 font_white">
						   <caption>기술컨설팅 요청사항</caption> 
						   <colgroup>
							   <col style="width: 20%" />
							   <col style="width: 80%" />
						   </colgroup>
						   <thead>
							   <tr id="tech_consulting_type_tr">
								   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">구분</span></th>
								   <td id="tech_consulting_type"></td>
							   </tr>
						   </thead>
						   <tbody>
						       <tr id="tech_consulting_campus_tr">
								   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">소속 캠퍼스타운</span></th>
								   <td id="tech_consulting_campus"></td>
							   </tr>
							   <tr id="national_science_tr">
								   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">국가기술분류체계</span></th>
								   <td id="national_science"></td> 
							   </tr>
							   <tr id="tech_consulting_4th_industry_name_tr">
								   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">4차 산업혁명 기술분류</span></th>
								   <td id="tech_consulting_4th_industry_name"></td> 
							   </tr>
							   <tr id="tech_consulting_purpose_tr">
								   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">컨설팅 목적</span></th>
								   <td id="tech_consulting_purpose"></td>
							   </tr>							   	   
						   </tbody>
					   </table>
					   <!--//기술컨설팅 요청사항 -  컨설팅-->
					   <!--기술 정보 -  컨설팅-->
					   <div class="view_top_area clearfix mt30">
						   <h4 class="fl sub_title_h4">기술 정보</h4>							  
					   </div>
                          <table class="list2 font_white">
						   <caption>기술 정보</caption> 
						   <colgroup>
							   <col style="width: 20%" />
							   <col style="width: 80%" />
						   </colgroup>
						   <thead>
							   <tr id="tech_info_name_tr">
								   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">제품/서비스명</span></th>
								   <td id="tech_info_name"></td> 
							   </tr>
						   </thead>
						   <tbody>
							   <tr id="tech_info_description_tr">
								   <th scope="row"><span class="necessary_icon">*</span><span class="icon_box">제품/서비스 내용</span></th>
								   <td id="tech_info_description"></td> 
							   </tr>
							   <tr id="tech_info_description_1_tr">
								   <th scope="row" id="tech_info_description_name_1"></th>
								   <td id="tech_info_description_1"></td> 
							   </tr>
							   <tr id="tech_info_description_2_tr">
								   <th scope="row" id="tech_info_description_name_2"></th>
								   <td id="tech_info_description_2"></td> 
							   </tr>
							   <tr id="service_upload_file_label_tr">
								   <th scope="row"><span class="icon_box">첨부 파일</span></th>
								   <td id="service_upload_file_label"></td> 
							    </tr>									
						   </tbody>
					   </table>	
					   <!--//기술 정보 -  컨설팅-->
					  
					  <!--매칭 결과-->
					  <div id="match_complete" style="display: none;">
						  <div class="view_top_area clearfix mt30">
							   <h4 class="fl sub_title_h4">매칭 전문가</h4>							  
						   </div>
                           <table class="list2 font_white">
							   <caption>매칭 전문가</caption> 
							   <colgroup>
								   <col style="width: 20%" />
								   <col style="width: 80%" />
							   </colgroup>
							   <thead>
								   <tr>
									   <th scope="row"><span class="necessary_icon">*</span>성명</th>
									   <td id="match_complete_name"></td> 
								   </tr>
							   </thead>
							   <tbody>
								   <tr>
									   <th scope="row"><span class="necessary_icon">*</span>소속 기관</th>
									   <td id="match_complete_department"></td> 
								   </tr>
								   <tr>
									   <th scope="row"><span class="necessary_icon">*</span>휴대 전화</th>
									   <td id="match_complete_phone"></td> 
								   </tr>
								   <tr>
									   <th scope="row"><span class="necessary_icon">*</span>이메일</th>
									   <td id="match_complete_email"></td> 
								   </tr>								   
							   </tbody>
						   </table>		
					  </div>
					  
					  <div class="view_top_area clearfix mt30">
							   <h4 class="fl sub_title_h4">제출 서류 확인</h4>							  
						   </div>
						   <table class="list">
							   <caption>제출 서류 확인</caption>     
							   <colgroup>
								   <col style="width:10%">
								   <col style="width:30%">
								   <col style="width:30%">
								   <col style="width:15%">
								   <col style="width:15%">
							   </colgroup>
							   <thead>
								   <tr>
									   <th scope="col" rowspan="2">순번</th>
									   <th scope="col" rowspan="2">신청서류</th>
									   <th scope="col" rowspan="2">파일명</th>
									   <th scope="col" colspan="2">접수 결과 입력</th>
								   </tr>
								   <tr>
								       <th scope="col">적합</th>
									   <th scope="col">부적합</th>
								   </tr>
							   </thead>
							   <tbody id="submit_doc_list_body">
								</tbody>
								<tfoot>  
								   <tr>
									   <th colspan="3" class="border_1">결과</th>
									   <td colspan="2" class="ta_c"><span><!--span style="color:red;font-weight:bold">부적합(자동생성)</span--><span style="color:#2874d0;font-weight:bold">적합(자동생성)</span></span></td>                         
								   </tr> 								   
							   </tfoot>
						   </table>
						   <!--제출서류 확인 - 컨설팅-->	
					  
					   <div class="fr mt30">
					   	   <a href="" class="green_btn all_down fl mr5" id="file_download" onclick="downloadSubmitFile();">첨부파일 전체 다운로드</a>
						   <button type="button" id="reject_btn" class="gray_btn be_rejected_popup_box_open">반려</button>
						   <button type="button" id="complete_btn" class="blue_btn application_completed_popup_open">접수 완료</button>
						   <button type="button" class="gray_btn2" onclick="location.href='/admin/fwd/reception/match/main'">목록</button>
					   </div>
<!-- 					   <div class="fr mt30">
					   <button type="button" class="blue_btn" id="match_complete_btn" style="display: none;" onclick="$('.application_completed_popup_box, .popup_bg').fadeIn(350);">매칭완료</button>
						   <button type="button" class="gray_btn2" onclick="location.href='/admin/fwd/reception/match/main'">목록</button>
					   </div> -->
					   <!--//제출서류 확인-->
				   </div><!--contents_view-->
                  </div>
			   <!--//contents--> 
    </div>
    <!--//sub--> 
</div>


<!-- 매칭완료 팝업-->
<div class="application_completed_popup_box">
   <div class="popup_bg"></div>
   <div class="application_completed_popup">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">접수 완료</h4>
	       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <p>작성된 정보로 <span class="font_blue">접수 완료</span> 하시겠습니까?</p>
		   <div class="popup_button_area_center">
			   <button type="button" class="blue_btn mr5" onclick="receptionComplete();">예</button>
			   <button type="button" class="gray_btn popup_close_btn">아니요</button>
		   </div>
	   </div>
   </div>
</div>