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
		searchAnnouncementDetail("D0000004");
		// D0000005 - 매칭 진행 중일시에 전문가 정보가 다르다.
		searchReceptionDetail("D0000005");
	});
	
	var mailSMSContents;
	function searchMailSMSContents() {
		$.ajax({
		    type : "POST",
		    url : "/admin/api/reception/tech/match/emailSMS/detail",
		    processData: false,
		    contentType: false,
		    async : false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	if ( jsonData.result_data != null && jsonData.result_data.length > 0 ) {
        				mailSMSContents = jsonData.result_data;
   				 	} else {
       					alert("전송할 메일/SMS 내용이 없습니다. 먼저 메일/SMS 전송 내용을 세팅하고 이용하여 주시기 바랍니다.");
    				}
		        } else {
		        	alert("전송할 메일/SMS 내용이 없습니다. 먼저 메일/SMS 전송 내용을 세팅하고 이용하여 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function sendMail() {
		if($("input:checkbox[name=prioiry_checkbox]").is(":checked") == false) {
			alert("한명 이상의 전문가를 선택하여야 합니다.");
			return;
		}
		
		// 가장 최근의 전송 메일 내용을 가져온다. 
		searchMailSMSContents();
		if ( mailSMSContents == null || mailSMSContents.length <= 0 ) {
			return;
		}
		
		var formData = new FormData();
		// Expert Progress에서의 Reception Status는 항상 'D0000005' 매칭 신청 시 이다. 
		formData.append("reception_id", $("#reception_id").val() );
		formData.append("reception_status", "D0000005" );
		// 전송할 메일 내용 
		$.each(mailSMSContents, function(key, value) {
			if (value.type == "email") {
				formData.append("title", value.title);
				formData.append("comment", value.comment);
				formData.append("link", value.link);
				formData.append("sender", value.sender);
			}
		});
		// 전송할 대상 			
		var memberIdList = new Array();
		var toMailList = new Array();
		// 전체 체크 순회
		$("input:checkbox[name=prioiry_checkbox]:checked").each(function() {
			memberIdList.push($(this).attr("member_id"));
			toMailList.push($(this).attr("email"));
		});

		formData.append("expert_member_ids", memberIdList);
		formData.append("to_mail", toMailList);
		
		$.ajax({
		    type : "POST",
		    url : "/admin/api/reception/tech/match/emailSMS/sendMail",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	alert("메일 전송에 성공하였습니다.");
		        } else {
		        	alert("메일 전송에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function sendSMS() {
		if($("input:checkbox[name=prioiry_checkbox]").is(":checked") == false) {
			alert("한명 이상의 전문가를 선택하여야 합니다.");
			return;
		}
		if (confirm("SMS를 전송하시겠습니까?")) {
			// 가장 최근의 전송 메일/SMS 내용을 가져온다. 
			searchMailSMSContents();
			if ( mailSMSContents == null || mailSMSContents.length <= 0 ) {
				return;
			}
			console.log('mailSMSContents : ', mailSMSContents);
			// 접수 별로 한번씩 보내야 한다. 각각의 Status가 틀리기 때문에 동시에 처리할 수가 없다.
			
				var formData = new FormData();
				// Expert Progress에서의 Reception Status는 항상 'D0000005' 매칭 신청 시 이다. 
				formData.append("reception_id", $("#reception_id").val() );
				formData.append("reception_status", "D0000005" );
			
			//전송할 sms 내용
			$.each(mailSMSContents, function(key, value) {
						if (value.type == "sms") {
							formData.append("title", value.title);   //제목
							formData.append("comment", value.comment);  //내용
							formData.append("link", value.link);  //링크
							formData.append("sender", value.sender);  //발송자
						}
			});
			
			// 전송할 대상 			
			var memberIdList = new Array();
			var toSMSList = new Array();
			
			// 전체 체크 순회
			$("input:checkbox[name=prioiry_checkbox]:checked").each(function() {
				memberIdList.push($(this).attr("member_id"));
				toSMSList.push($(this).attr("mobile_phone"));
			});
			
			
			formData.append("expert_member_ids", memberIdList);
			formData.append("to_phone", toSMSList);
			
			//보낼파라미터 : 폰번호, 내용
				$.ajax({
				    type : "POST",
				    url : "/admin/api/reception/tech/match/emailSMS/sendSMS",
				    data : formData,
				    processData: false,
				    contentType: false,
				    mimeType: 'multipart/form-data',
				    success : function(data) {
				    	var jsonData = JSON.parse(data);
				        if (jsonData.result == true) {
				        	alert("SMS 전송에 성공하였습니다.");
				        } else {
				        	alert("SMS 전송에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
				        }
				    },
				    error : function(err) {
				        alert(err.status);
				    }
				});
		}
	}

	function savePriority() {
		var formData = new FormData();

		// 전문가 정보
		var expertList = new Array();
		var index = 0;
		$('#expert_body tr').each(function() { 
			var tempInfo = new Object();
			tempInfo.expert_id = $(this).attr("expert_id");
			tempInfo.priority = index;
			expertList.push(tempInfo);
			index++;
		});
		formData.append("choiced_expert_info_list_json",  JSON.stringify(expertList));
		
		if (confirm('전문가 우선 순위를 변경하시겠습니까?')) {
			$.ajax({
			    type : "POST",
			    url : "/admin/api/reception/tech/match/expert/setPriority",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			        	alert("전문가 매칭 우선순위 변경에 성공했습니다.");
			        	location.reload();
			        } else {
			        	alert("전문가 매칭 우선순위 변경에 실패했습니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}

	}

	function moveUp(itMe){
		var tr = $(itMe).parent().parent(); // 클릭한 버튼이 속한 tr 요소
		tr.prev().before(tr); // 현재 tr 의 이전 tr 앞에 선택한 tr 넣기
	}

	function moveDown(itMe){
		var tr = $(itMe).parent().parent(); // 클릭한 버튼이 속한 tr 요소
		tr.next().after(tr); // 현재 tr 의 다음 tr 뒤에 선택한 tr 넣기
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


					   <div class="view_top_area clearfix mt30">
						   <h4 class="fl sub_title_h4">전문가 참여 의향 현황</h4>							  
					   </div>
					   <div class="list_search_table">
						    <div class="table_count_area">								    
						        <div style="overflow-x:auto;">
							       <table class="list2 ta_c bd_r">
								       <caption>전문가 정보</caption>
									   <colgroup>
										   <col style="width: 7%">
										   <col style="width: 20%">
										   <col style="width: 8%">
										   <col style="width: 8%">
										   <col style="width: 10%">
										   <col style="width: 10%">
										   <col style="width: 10%">
										   <col style="width: 15%">
										   <col style="width: 7%">
										   <col style="width: 7%">
										   <col style="width: 5%" class="s_h">
									   </colgroup>
								       <thead>
									       <tr>
										       <th scope="col" colspan="9">전문가 정보</th>
										       <th scope="col" rowspan="2">참여 의향</th>	
											   <th scope="col" rowspan="2" class="s_h">우선순위 선정</th>	
									       </tr>
										   <tr>
										       <th scope="col">
										         <input type="checkbox" id="allCheck"><label for="allCheck" class="checkbox_a">&nbsp;</label>
										       </th>
											   <th>국가과학기술분류</th>
											   <th>연구분야</th>
											   <th>성명</th>
											   <th>기관명</th>
											   <th>부서</th>
											   <th>휴대전화</th>
											   <th>이메일</th>
											   <th>선택 구분</th>
										   </tr>
								       </thead>
								       <tbody id="expert_body"> 
									   </tbody>
									</table> 							                          
								</div>  

							   <div class="page">				
								   <ul class="pagination modal">
								   </ul>
								</div> 
								
								<div class="fr clearfix">
									<button type="button" class="blue_btn2 fl mr5 s_h_button" onclick="$('#save_priority_btn').show();">전문가 매칭 우선순위 선정</button>
									<button type="button" class="blue_btn2 fl mr5" id="save_priority_btn" style="display:none;" onclick="savePriority();">우선순위 저장</button>
									<button type="button" class="blue_btn fl mr5 expertintention_emailsend_popup_open mail_btn" onclick="sendMail();">E-mail</button>
									<button type="button" class="blue_btn fl mr5 expertintention_smssend_popup_open sms_btn" onclick="sendSMS();">SMS</button>
									<button type="button" class="gray_btn2 fl" onclick="location.href='/admin/fwd/reception/match/main'">목록</button>
								</div>
			   		  		</div>
					   </div>
					   <!--//매칭 진행-->	
					   
					   <!--제출서류 확인 - 컨설팅-->
					   <div class="view_top_area clearfix mt30">
					   </div>
					   
					   <div class="view_top_area fr clearfix mt30">
						   
					   </div>
					   <!--//제출서류 확인-->
				   </div><!--contents_view-->
             	</div>
			   <!--//contents--> 
    </div>
    <!--//sub--> 
</div>