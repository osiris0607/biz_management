<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var choicedExpertList;
	var isChangeExpertList = false;
	var receptionDetailStatus;
	
	$(document).ready(function() {
		searchReceptionDetail();
	});

	function searchReceptionDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/admin/api/reception/detail");
		comAjax.setCallback(getReceptionCB);
		comAjax.addParam("reception_id", $("#reception_id").val());
		comAjax.ajax();
	}

	function getReceptionCB(data){
		mReceptionDetail = data.result_data;

		var body = $("#expert_body");
		var str = "";
		var index = 0;
		body.empty();
		choicedExpertList = mReceptionDetail.choiced_expert_list;
		
		$.each(choicedExpertList, function(key, value) {
			str += "<tr expert_id='" + value.expert_id + "'>";
			str += "	<td><input type='checkbox' name='prioiry_checkbox' id='checkbox_" + index + "' member_id='" + value.member_id + "' email='" + value.email + "' sms='" + value.mobile_phone + "'>";
			str += "		<label for='checkbox_" + index + "' class='checkbox_a'>&nbsp;</label>";
			str += "	</td>";
			str += "	<td><span class='fl mr5'>" + mReceptionDetail.announcement_title + "</span></td>";;
			str += "	<td><span>" + mReceptionDetail.announcement_type_name + "</span></td>";
			str += "	<td><span>" + value.name + "</span></td>";
			str += "	<td><span>" + value.institution_name + "</span></td>";
			str += "	<td><span>" + value.institution_department + "</span></td>";
			str += "	<td><span>" + value.mobile_phone + "</span></td>";
			str += "	<td><span>" + value.email + "</span></td>";
			
			// 미회신
			if (value.participation_type == "D0000001" || value.participation_type == "D0000004") {
				str += "	<td class='td_txt'><span>미회신</span></td>";
				str += "	<td class='s_h'></td>";
			// 미참여
			} else if (value.participation_type == "D0000002") {
				str += "	<td class='td_txt'><span>미참여</span></td>";
				str += "	<td class='s_h'></td>";
			// 참여
			} else if (value.participation_type == "D0000003") {
				str += "	<td class='td_txt'><span>참여</span></td>";
				str += "	<td class='s_h'>";
				str += "	<button type='button' class='gray_btn2 mb5' onclick='moveUp(this)'>▲</button><br>";
				str += "	<button type='button' class='gray_btn2' onclick='moveDown(this)'>▼</button><br>";
			} 
			str += "</tr>";
			
			index++;
		});
		body.append(str);	
	}

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
		$('.expertintention_emailsend_popup_box').fadeOut(350);
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
		
		var formData = new FormData();
		if (confirm('SMS을 전송하시겠습니까?')) {
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
			        	alert("SMS 전송에 성공했습니다.");
			        } else {
			        	alert("SMS 전송에 실패했습니다.");
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

	function onChangeParticipation()
	{
		var body = $("#expert_body");
		var str = "";
		var index = 0;
		body.empty();


		if ( gfn_isNull($("#participation_intention").val()) )
		{
			$.each(choicedExpertList, function(key, value) {
				str += "<tr expert_id='" + value.expert_id + "'>";
				str += "	<td><input type='checkbox' name='prioiry_checkbox' id='checkbox_" + index + "' member_id='" + value.member_id + "' email='" + value.email + "' sms='" + value.mobile_phone + "'>";
				str += "		<label for='checkbox_" + index + "' class='checkbox_a'>&nbsp;</label>";
				str += "	</td>";
				str += "	<td><span class='fl mr5'>" + mReceptionDetail.announcement_title + "</span></td>";;
				str += "	<td><span>" + mReceptionDetail.announcement_type_name + "</span></td>";
				str += "	<td><span>" + value.name + "</span></td>";
				str += "	<td><span>" + value.institution_name + "</span></td>";
				str += "	<td><span>" + value.institution_department + "</span></td>";
				str += "	<td><span>" + value.mobile_phone + "</span></td>";
				str += "	<td><span>" + value.email + "</span></td>";
				
				// 미회신
				if (value.participation_type == "D0000001" || value.participation_type == "D0000004") {
					str += "	<td class='td_txt'><span>미회신</span></td>";
					str += "	<td class='s_h'></td>";
				// 미참여
				} else if (value.participation_type == "D0000002") {
					str += "	<td class='td_txt'><span>미참여</span></td>";
					str += "	<td class='s_h'></td>";
				// 참여
				} else if (value.participation_type == "D0000003") {
					str += "	<td class='td_txt'><span>참여</span></td>";
					str += "	<td class='s_h'>";
					str += "	<button type='button' class='gray_btn2 mb5' onclick='moveUp(this)'>▲</button><br>";
					str += "	<button type='button' class='gray_btn2' onclick='moveDown(this)'>▼</button><br>";
				} 
				str += "</tr>";
				
				index++;
			});
		}
		else 
		{
			var participationList = choicedExpertList.filter(item => (item.participation_type === $("#participation_intention").val()));
			if ( participationList.length == 0) 
			{
				var str = "<tr>" + "<td colspan='9'>조회된 결과가 없습니다.</td>" + "</tr>";
			}
			else 
			{
				$.each(participationList, function(key, value) {
					str += "<tr expert_id='" + value.expert_id + "'>";
					str += "	<td><input type='checkbox' name='prioiry_checkbox' id='checkbox_" + index + "' member_id='" + value.member_id + "' email='" + value.email + "' sms='" + value.mobile_phone + "'>";
					str += "		<label for='checkbox_" + index + "' class='checkbox_a'>&nbsp;</label>";
					str += "	</td>";
					str += "	<td><span class='fl mr5'>" + mReceptionDetail.announcement_title + "</span></td>";;
					str += "	<td><span>" + mReceptionDetail.announcement_type_name + "</span></td>";
					str += "	<td><span>" + value.name + "</span></td>";
					str += "	<td><span>" + value.institution_name + "</span></td>";
					str += "	<td><span>" + value.institution_department + "</span></td>";
					str += "	<td><span>" + value.mobile_phone + "</span></td>";
					str += "	<td><span>" + value.email + "</span></td>";
					
					// 미회신
					if (value.participation_type == "D0000001" || value.participation_type == "D0000004") {
						str += "	<td class='td_txt'><span>미회신</span></td>";
						str += "	<td class='s_h'></td>";
					// 미참여
					} else if (value.participation_type == "D0000002") {
						str += "	<td class='td_txt'><span>미참여</span></td>";
						str += "	<td class='s_h'></td>";
					// 참여
					} else if (value.participation_type == "D0000003") {
						str += "	<td class='td_txt'><span>참여</span></td>";
						str += "	<td class='s_h'>";
						str += "	<button type='button' class='gray_btn2 mb5' onclick='moveUp(this)'>▲</button><br>";
						str += "	<button type='button' class='gray_btn2' onclick='moveDown(this)'>▼</button><br>";
					} 
					str += "</tr>";
					
					index++;
				});
			}
			
		}

		body.append(str);
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
							       <li class="on"><a href="./reception.html" title="접수관리">접수관리</a></li>
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
							<h4 class="sub_title_h4 mb10">전문가 참여 의향 현황</h4>    
					        <!--접수 목록-->
						    <div class="list_search_top_area">							   
							    <ul class="clearfix list_search_top2">
								    <li class="clearfix">                
									    <label for="participation_intention" class="fl list_search_title ta_r mr10 w_8">참여 의향</label>
									    <select name="participation_intention" onchange="onChangeParticipation();" id="participation_intention" class="ace-select fl w_18">
										    <option value="">전체</option>
										    <option value="D0000001">미회신</option>
										    <option value="D0000002">미참여</option>
										    <option value="D0000003">참여</option>
									    </select>
								    </li>								    
								</ul>																
								<!-- <div class="list_search_btn clearfix"><button type="button" class="blue_btn fr">조회</button></div> -->
						    </div>
						    <!--//리스트 상단 검색-->

						    <!--검색 결과-->
						    <div class="list_search_table">
							    <div class="table_count_area">
								    <div class="count_area clearfix">
									    <div class="clearfix">
											<div class="fl mt5">								   
												
											</div>																		   
								        </div>							   
							        </div>
							        <div style="overflow-x:auto;">
								       <table class="list th_c">
									   	   <caption>전문가 정보</caption> 
									   	   <colgroup>
										       <col style="width:6%" />
										       <col style="width:15%" />
										       <col style="width:8%" />
										       <col style="width:5%" />
											   <col style="width:15%" />
										       <col style="width:15%" />
										       <col style="width:10%" />
										       <col style="width:15%" />
										       <col style="width:5%" />
									       </colgroup>									       								       
									       <thead>
										       <tr>
											       <th scope="col" colspan="8">전문가 정보</th>
											       <th scope="col" rowspan="2">참여 의향</th>	
												   <th scope="col" rowspan="2" class="s_h">우선순위 선정</th>	
										       </tr>
											   <tr>
											       <th scope="col">
											         <input type="checkbox" id="allCheck"/><label for="allCheck" class="checkbox_a">&nbsp;</label>
											       </th>
												   <th>공고명</th>
												   <th>구분</th>
												   <th>전문가</th>
												   <th>기관명</th>
												   <th>부서</th>
												   <th>휴대전화</th>
												   <th>이메일</th>
											   </tr>
									       </thead>
									       <tbody id="expert_body">
										   </tbody>
										</table>   
										<!--//검색 결과-->                           
									</div>  
								   <!--페이지 네비게이션-->
								   <div class="page">				
									   <ul class="pagination modal">
									   </ul>
									</div>  
									<!--//페이지 네비게이션-->

									<div class="fr clearfix">
										<button type="button" class="blue_btn2 fl mr5 s_h_button" onclick="$('#save_priority_btn').show();">전문가 매칭 우선순위 선정</button>
										<button type="button" class="blue_btn2 fl mr5" id="save_priority_btn" style="display:none;" onclick="savePriority();">우선순위 저장</button>
										<button type="button" class="blue_btn fl mr5 expertintention_emailsend_popup_open mail_btn">E-mail</button>
										<button type="button" class="blue_btn fl mr5 expertintention_smssend_popup_open sms_btn">SMS</button>
										<button type="button" class="gray_btn2 fl" onclick="location.href='/admin/fwd/reception/match/main'">목록</button>
									</div>
								</div>
								<!--//list_search_table-->
						    </div><!--content view-->
					   </div>
						<!--//contents--> 
				   </div>
				   <!--//sub--> 
				</div>
				<!--//container-->
			 </div>
  <!--//전문가 추가 조사 팝업-->
  
<!--전문가 참여 의향 조사 팝업 - email-->
<div class="expertintention_emailsend_popup_box">
   <div class="popup_bg"></div>
   <div class="expertintention_emailsend_popup">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">전문가 참여 의향 조사</h4>
	       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <div class="popup_txt"><span>[알림]</span>
			   <p class="font_w">전문가 참여 의향 조사 실시</p>
			   <p><span class="font_blue" style="display:inline-block">[발송하기]</span> 버튼을 클릭 시, 기존에 세팅해 놓은 문구로 전문가에게 <span class="font_blue" style="display:inline-block">email</span>이 발송됩니다.<br />발송하시겠습니까?</p>
		   </div>
		   <div class="popup_button_area_center">
		       <button type="button" class="blue_btn mr5" onclick="sendMail();">발송하기</button>
			   <button type="button" class="gray_btn popup_close_btn">취소</button>					   
		   </div>
	   </div>
   </div>
</div>
  <!--//전문가 참여 의향 조사 팝업 - email-->

  <!--전문가 참여 의향 조사 팝업-->
<div class="expertintention_smssend_popup_box">
   <div class="popup_bg"></div>
   <div class="expertintention_smssend_popup">
       <div class="popup_titlebox clearfix">
	       <h4 class="fl">전문가 참여 의향 조사</h4>
	       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
	   </div>
	   <div class="popup_txt_area">
		   <div class="popup_txt"><span>[알림]</span>
			   <p class="font_w">전문가 참여 의향 조사 실시</p>
			   <p><span class="font_blue" style="display:inline-block">[발송하기]</span> 버튼을 클릭 시, 기존에 세팅해 놓은 문구로 전문가에게 <span class="font_blue" style="display:inline-block">SMS</span> 메세지가 발송됩니다.<br />발송하시겠습니까?</p>
		   </div>
		   <div class="popup_button_area_center">
		   		<button type="button" class="blue_btn mr5" onclick="sendSMS();">발송하기</button>
			    <button type="button" class="gray_btn popup_close_btn">취소</button>					   
		   </div>
	   </div>
   </div>
</div>
