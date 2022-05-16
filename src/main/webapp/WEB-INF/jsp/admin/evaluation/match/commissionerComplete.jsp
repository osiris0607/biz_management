<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	$(document).ready(function() {
		searchList(1);
	});

	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/evaluation/match/commissioner/search/pagingRelatedId' />");
		// 20개씩 검색
		comAjax.addParam("evaluation_reg_number", "${vo.evaluation_reg_number}");
		comAjax.addParam("page_row_count", "20");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "MAIL_REPLY_YN DESC");
		comAjax.ajax();
	}

	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='8'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList",
					recordCount : 20
				};
			gfnRenderPaging(params);

			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			var managerList = [];
			var str = "";
			var index = 1;
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		<input value='" + value.member_id + "' name='final_commissioner' id='auto_result_table_checkbox_"+ index + 
								"' email='" + value.email + "' mobile_phone='" + value.mobile_phone + "' type='checkbox'>";
				str += "		<label for='auto_result_table_checkbox_" + index + "'>&nbsp;</label>";
				str += "	</td>";
				str += "	<td><span>" + index + "</span></td>";
				str += "	<td><span>" + value.institution_type_name + "</span></td>";
				str += "	<td><span>" + value.national_skill_large + "</span></td>";
				str += "	<td><span>" + value.rnd_class + "</span></td>";
				str += "	<td><span>" + value.member_name + "</span></td>";
				str += "	<td><span>" + value.institution_name + "</span></td>";
				str += "	<td><span>" + value.mail_reply_yn + "</span></td>";
				str += "	<td><span>" + value.choice_yn + "</span></td>";
				str += "<tr>";

				index++;
			});
			body.append(str);
		}
	}


	var mailAddresses = "";
	var commissionerMailList = new Array();
	var commissionerList = new Array();
	function prepaerSendMail() {
		if($("input:checkbox[name='final_commissioner']").is(":checked") == false) {
			alert("메일 전송할 평가위원을 선택하여야 합니다.");
			return;
		}
		
		$("input:checkbox[name=final_commissioner]:checked").each(function() {
			mailAddresses += $(this).attr("email") + ";";
			commissionerMailList.push($(this).attr("email"));
			commissionerList.push($(this).val());
		});
		// 마지막 ';' 삭제
		$("#mail_receiver").val(mailAddresses.substring(0, mailAddresses.length-1));
		
		$('.rating_email_popup_box').fadeIn(350);
	}

	function sendMail() {
		if ( gfn_isNull($("#mail_receiver").val()) ) {
			alert("수신자 메일 주소가 없습니다. 확인 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#mail_title").val()) ) {
			alert("메일 제목을 입력해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#mail_content").val()) ) {
			alert("메일 내용을 입력해 주시기 바랍니다.");
			return;
		}
		if ( gfn_isNull($("#mail_sender").val()) ) {
			alert("송신자 메일 주소를 설정해야 합니다.");
			return;
		}
		
		if (confirm("메일을 발송하시겠습니까?")) {
			var formData = new FormData();
			formData.append("evaluation_reg_number", "${vo.evaluation_reg_number}" );
			formData.append("commissioner_list", commissionerList);
			formData.append("commissioner_mail_list", commissionerMailList);
			formData.append("mail_title", $("#mail_title").val());
			formData.append("mail_content", $("#mail_content").val());
			formData.append("mail_link", $("#mail_link").val());
			formData.append("mail_sender", $("#mail_sender").val());
			
			$.ajax({
			    type : "POST",
			    url : "/admin/api/evaluation/match/commissioner/sendCompleteMail",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true ) {
			        	alert("매일 발송에 성공 하였습니다.");
			        	$('.rating_email_popup_box').fadeOut(350);
			        } else {
			        	alert("매일 발송에 실패 하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}
	
	function moveMain() {
		location.href = "/admin/fwd/evaluation/main?announcement_type=" + '${vo.announcement_type}' + "&classification="  + '${vo.classification}';
	}
</script>
            
<!--본문시작-->
<div class="contents">
	<div class="location_area">
	    <div class="location_division">
		   <!--페이지 경로-->
	          <ul class="location clearfix">
		       <li><a href="./index.html"><i class="nav-icon fa fa-home"></i></a></li>
			   <li>평가관리</li>
			   <li><strong>기술매칭</strong></li>
		   </ul>	
		  <!--//페이지 경로-->
		  <!--페이지타이틀-->
		   <h3 class="title_area">기술매칭</h3>
		  <!--//페이지타이틀-->
	    </div>
	</div>
					   
                       <div class="contents_view">                           
							<h4 class="sub_title_h4 mb10">평가위원 회신 및 확정</h4> 	       						    

						    <!--평가위원 회신 및 확정-->
						    <div class="list_search_table">
							    <div class="table_count_area">
								    <div class="count_area clearfix">
									    <div class="clearfix">
											<div class="fl mt5" id="search_count">								   
												[총 <span class="font_blue">0</span>건]
											</div>																		   
								        </div>							   
							        </div>
							        <div style="overflow-x:auto;">
								       <table class="list th_c auto_complete_table checkinput_table">
									       <caption>평가위원 등록</caption>     
									       <colgroup>
												<col style="width: 5%;">
												<col style="width: 5%;">
												<col style="width: 10%;">
												<col style="width: 15%;">
												<col style="width: 30%;">
												<col style="width: 10%;">	
												<col style="width: 15%;">
												<col style="width: 5%;">
												<col style="width: 5%;">
										   </colgroup>
									       <thead>
										       <tr>
												   <th scope="col">
												       <input id="auto_result_table_checkboxall" type="checkbox">
													   <label for="auto_result_table_checkboxall">&nbsp;</label>
												   </th>
											       <th scope="col">No.</th>
												   <th scope="col">구분</th>
											       <th scope="col">분야</th>
											       <th scope="col">키워드</th>
												   <th scope="col">이름</th>
											       <th scope="col">기관명</th>
											       <th scope="col">메일회신여부</th>
											       <th scope="col">최종선정여부</th>
										       </tr>
									       </thead>
									       <tbody id="list_body">
										   </tbody>
										</table>   
										<!--//검색 결과-->                           
									</div>  
								    <!--페이지 네비게이션-->
					    			<input type="hidden" id="pageIndex" name="pageIndex"/>
					   				<div class="page" id="pageNavi"></div>  
								    <!--//페이지 네비게이션-->

									<div class="fr clearfix mt30">	
										<button type="button" class="blue_btn fl mr5 mail_btn" onclick="prepaerSendMail();">확정 및 이메일 발송</button>
									    <button type="button" class="blue_btn fl sms_btn mr5">SMS 보내기</button>
									    <button type="button" class="gray_btn2 fl" onclick="moveMain()">목록</button>					  								   
									</div>
								</div>
						    </div><!--//list_search_table-->
						</div><!--contents_view-->
                   </div>
				   <!--//contents--> 
				   
				   
				   <!--이메일 보내기-->
<div class="rating_email_popup_box">
	<div class="popup_bg"></div>
	<div class="rating_email_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">이메일 발송</h4>
			<a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		</div>
		<div class="popup_txt_area">
			<div class="popup_txt">
				<table class="list2">
					<caption>평가위원 추출</caption> 
					<colgroup>												  
					   <col style="width: 20%">
					   <col style="width: 80%">
				   </colgroup>
				   <tbody>
					   <tr>
						   <th scope="row"><label for="rating_mail_receiver">수신자</label></th>
						   <td><input id="mail_receiver" class="form-control w100" type="text" /></td> 
					   </tr>
					  <tr>
						   <th scope="row"><label for="rating_mail_title">발송제목</label></th>
						   <td><input id="mail_title" class="form-control w100" type="text" /></td> 
					   </tr>
					   <tr>
						   <th scope="row"><label for="rating_mail_txt">발송문구</label></th>
						   <td><textarea id="mail_content" rows="10" class="w100"></textarea></td> 
					   </tr>
					   <tr>
						   <th scope="row"><label for="rating_mail_link">참여링크</label></th>
						   <td><input id="mail_link" class="form-control w100" type="text" /></td> 
					   </tr>
					   
					   <tr>
						   <th scope="row"><label for="rating_mail_caller">발신자</label></th>
						   <td><input id="mail_sender" class="form-control w100" type="text" /></td> 
					   </tr>
					</tbody>
				</table>
			</div>					
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn" onclick="sendMail();">이메일 발송</button>
			</div>
		</div>
	</div>
</div>
<!--//이메일 보내기-->
				   
				   
<script src="/assets/admin/js/script.js"></script>