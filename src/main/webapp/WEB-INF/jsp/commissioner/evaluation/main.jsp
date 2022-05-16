<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx }/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script type='text/javascript'>
	var isModification = false;
	
	$(document).ready(function() {
		searchMemberDetail();
	 	searchEvaluationList(1);
	 	searchCommissionerDetail();
	});

	function searchMemberDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("/member/api/mypage/detail");
		comAjax.setCallback(getMemberDetailCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.ajax();
	}

	function getMemberDetailCB(data){
		$("#name").html("<span>" + data.result.name + "</span>") ;
		$("#mobile_phone").html(data.result.mobile_phone) ;
		$("#email").html(data.result.email) ;
		$("#address").html(data.result.address + " " + data.result.address_detail) ;
	}

	function searchCommissionerDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/commissioner/api/evaluation/commissioner/detail'/>");
		comAjax.setCallback(searchCommissionerDetailCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.ajax();
	}

	function searchCommissionerDetailCB(data){
		console.log(data);
		$("#bank_name").val(data.result_data.bank_name) ;
		$("#bank_number").val(data.result_data.bank_account) ;
	}
	

	function searchEvaluationList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/commissioner/api/evaluation/search/paging'/>");
		comAjax.addParam("member_id", "${member_id}");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("page_row_count", "20");
		comAjax.setCallback(searchEvaluationListCB);
		comAjax.ajax();
	}
	
	function searchEvaluationListCB(data){
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='11'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchEvaluationList"
				};
	
			gfnRenderPaging(params);
			
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				str += "<tr>";
				str += "	<td class='first'>" + index+ "</td>";
				str += "	<td><span>" + value.announcement_type_name + "</span></td>";
				str += "	<td class='announcement_name'><span>" + value.announcement_title + "</span></td>";
				str += "	<td><span>" + value.type_name + "</span></td>";
				str += "	<td><span>" + value.steward_department + "</span></td>";
				str += "	<td><span>" + value.steward + "</span></td>";
				str += "	<td><span>" + value.evaluation_date + "</span></td>";
				str += "	<td><span>" + value.evaluation_date + "</span></td>";
				if ( value.security_declaration_yn == "Y") {
					str += "<td><span class='font_blue'>작성완료</span></td>";
				} else {
					str += "<td><a href='javascript:void(0);' onclick='displayPopupSecurity(\"" + value.evaluation_id + "\");'>미작성</a></td>";
				}

				if ( value.payment_declaration_yn == "Y") {
					str += "<td><span class='font_blue'>작성완료</span></td>";
				} else {
					str += "<td><a href='javascript:void(0);' onclick='displayPopupPayment(\"" + value.evaluation_id + "\");'>미작성</a></td>";
				}

				if (value.chairman_yn == "Y") {
					if ( value.evaluation_report_yn == "Y" && value.chairman_submit_yn == "Y") {
						str += "<td><span class='font_blue'>평가완료</span></td>";
					} else {
						if ( value.security_declaration_yn == "Y" && value.payment_declaration_yn == "Y") {
							str += "<td class='last'><button type='button' class='blue_btn' onclick='location.href=\"/commissioner/fwd/evaluation/estimation?evaluation_id=" + value.evaluation_id + "\"'>평가 시작</button></td>";
						} else {
							str += "<td></td>";
						} 
					}
				} else {
					if ( value.evaluation_report_yn == "Y" ) {
						str += "<td><span class='font_blue'>평가완료</span></td>";
					} else {
						if ( value.security_declaration_yn == "Y" && value.payment_declaration_yn == "Y") {
							str += "<td class='last'><button type='button' class='blue_btn' onclick='location.href=\"/commissioner/fwd/evaluation/estimation?evaluation_id=" + value.evaluation_id + "\"'>평가 시작</button></td>";
						} else {
							str += "<td></td>";
						} 
					}
				}
				
				str += "</tr>";
				index++;
			});
			body.append(str);
		}
	}

	
	var selectEvaluationId = "";
	function displayPopupSecurity(evaluationId){
		selectEvaluationId = evaluationId;

		var today = new Date();   
		var year = today.getFullYear(); // 년도
		var month = today.getMonth() + 1;  // 월
		var date = today.getDate();  // 날짜
		
		$("#security_declaration_date").html( "<span class='fl'>" + year + "</span><span class='fl mr10'>년</span><span class='fl'>" + month + "</span><span class='fl mr10'>월</span><span class='fl'>" + date + "</span><span class='fl'>일");
		$(".security_popup_box, .popup_bg").fadeIn(350);
	}			

	function signSecurity() {
		if($(".security_popup_box input[name=security_of_service1]").is(":checked") && $(".security_popup_box input[name=security_of_service2]").is(":checked") && $(".security_popup_box input[name=security_of_service3]").is(":checked")== true){    
			var url = "/commissioner/fwd/evaluation/sign/security?member_id=" + "${member_id}" + "&evaluation_id=" + selectEvaluationId;  
			window.open(url, "_blank", 'width=700, height=460'); 				
			//$('.security_popup_box').fadeOut(350);				
		}
	}

	function agreeSecurity() {
		var today = new Date();   
		var year = today.getFullYear(); // 년도
		var month = today.getMonth() + 1;  // 월
		var date = today.getDate();  // 날짜
		
		var formData = new FormData();
		formData.append("member_id", "${member_id}");
		formData.append("evaluation_id", selectEvaluationId);
		formData.append("security_declaration_date", year+"-"+month+"-"+date);
		formData.append("security_declaration_yn", "Y");
			
		$.ajax({
		    type : "POST",
		    url : "/commissioner/api/evaluation/update/agreeSecurity",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
			    if ( jsonData.result == true) {
			    	showPopup("보안서약서 작성이 완료되었습니다.");
			    	$('.security_popup_box, .security_popup_box .popup_bg').fadeOut(350);
			    	searchEvaluationList(1);
			    } else {
			    	showPopup("보안서약서 작성에 실패했습니다. 디시 시도해 주시기 바랍니다.");
			    }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function displayPopupPayment(evaluationId){
		selectEvaluationId = evaluationId;
		$(".receipt_popup_box, .popup_bg").fadeIn(350);
	}			

	function signPayment() {
			if($("#bank_name").is(":disabled") && $("#bank_number").is(":disabled") == true){    
		 	//if( gfn_isNull($("#bank_name").val()) == false && gfn_isNull($("#bank_number").val()) == false ){    
				 var url = "/commissioner/fwd/evaluation/sign/payment?member_id=" + "${member_id}" + "&evaluation_id=" + selectEvaluationId;  
				window.open(url, "_blank", 'width=700, height=460'); 				
			}
	}

	function agreePayment() {
		var formData = new FormData();
		formData.append("member_id", "${member_id}");
		formData.append("evaluation_id", selectEvaluationId);
		formData.append("payment_declaration_yn", "Y");
			
		$.ajax({
		    type : "POST",
		    url : "/commissioner/api/evaluation/update/agreePayment",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
			    if ( jsonData.result == true) {
			    	showPopup("지급서약서 작성이 완료되었습니다.");
			    	$('.receipt_popup_box').fadeOut(350);	
			    	searchEvaluationList(1);
			    } else {
			    	showPopup("지급서약서 작성에 실패했습니다. 디시 시도해 주시기 바랍니다.");
			    }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function updateBankName(element) {
		var bank_name_modify = $("#bank_name").prop('disabled', true);
		$(".d_input").prop("disabled", bank_name_modify ? false : true);
		if( $(element).text() == '수정하기' ) {
			$(element).text('수정 완료');				
			bank_name_modify.prop( 'disabled', false );			
		}
		else {          
			bank_name_modify.prop( 'disabled', true );
			$(element).text('수정하기');
			updateBankInfo();
		}	
	}

	function updateBankAccount(element) {
		var bank_number_modify = $("#bank_number").prop('disabled', true);
		$(".d_input").prop("disabled", bank_number_modify ? false : true);
		if( $(element).text() == '수정하기' ) {
			$(element).text('수정 완료');				
			bank_number_modify.prop( 'disabled', false );			
		}
		else {          
			bank_number_modify.prop( 'disabled', true );
			$(element).text('수정하기');
			updateBankInfo();
		}	
	}


	function updateBankInfo() {
		var formData = new FormData();
		formData.append("member_id", "${member_id}");
		formData.append("bank_name", $("#bank_name").val());
		formData.append("bank_account", $("#bank_number").val());
			
		$.ajax({
		    type : "POST",
		    url : "/commissioner/api/evaluation/update/bankInfo",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
			    if ( jsonData.result == true) {
			    	showPopup("은행정보 수정이 완료되었습니다.");
			    } else {
			    	showPopup("은행정보 수정에 실패했습니다. 디시 시도해 주시기 바랍니다.");
			    	searchMemberDetail();
			    }
		    },
		    error : function(err) {
		        alert(err.status);
		        searchMemberDetail();
		    }
		});
	}


	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
	}

	function commonPopupConfirm(){
	}

</script>

<!-- container -->
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>	
		<section id="content" class="est-sub">
			<div id="sub_contents">
		    	<div class="content_area">
					<div class="route hidden">
						<ul class="clearfix">
							<li><i class="fas fa-home">홈</i></li>
							<li>평가위원 전자평가</li>
							<li>평가위원 전자평가</li>
						</ul>
					</div>
					<div class="content_area pt120">
						<h4>평가 안내</h4>
						<!--안내글-->
						<div class="announcement_index_infotxt">
							<ul>
								<li><a href="" download><span class="fw_b">평가 매뉴얼</span></a>을 확인해 주세요.</li>
								<li>평가 시작 전 <span class="fw_b">보안서약서</span>와 <span class="fw_b">지급청구서</span>를 작성하시기 바랍니다. </li>
								<li><span class="blue_btn">평가 시작</span> 버튼을 클릭할 경우, 평가가 끝나기 전까지 화면 전환이 불가하며, 제출된 평가서는 수정이 불가합니다.</li>
							</ul>
							<a href="" title="평가메뉴얼" class="blue_btn manual" download>평가 메뉴얼 확인하기</a>
						</div>
						<!--안내글-->
								
						<h4>평가 과제 목록</h4>
						<!--table_count_area-->
						<div class="table_count_area">
							<div class="count_area" id="search_count">
								[총 <span class="fw500 font_blue">0</span>건]
							</div>
						</div>
						<!--//table_count_area-->
						<!--리스트시작-->							
						<div class="table_area">
							<table class="list fixed announcement_index_table">
								<caption>공고 목록</caption>
								<colgroup>
									<col style="width:5%" />
									<col style="width:7%" />
									<col style="width:22%" />
									<col style="width:7%" />
									<col style="width:10%" />
									<col style="width:7%" />
									<col style="width:9%" />
									<col style="width:9%" />
									<col style="width:7%" />
									<col style="width:7%" />
									<col style="width:10%" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col" class="first">번호</th>
										<th scope="col">사업명</th>
										<th scope="col">공고명</th>
										<th scope="col">평가구분</th>
										<th scope="col">담당간사 부서명</th>
										<th scope="col">담당 간사명</th>
										<th scope="col">평가 시작일</th>
										<th scope="col">평가 종료일</th>
										<th scope="col">보안 서약서</th>
										<th scope="col">지급 서약서</th>
										<th scope="col" class="last">평가</th>
									</tr>
								</thead>
								<tbody id="list_body">
								</tbody>
							</table>
							<!-- Pagination -->
						   	<input type="hidden" id="pageIndex" name="pageIndex"/>
							<div class="paging_area" id="pageNavi"></div>
							<!-- Pagination -->
						</div>							
					</div>
				</div>
			</div>
	</section>
</div>
 
 
<!--보안서약서 팝업-->
<div class="security_popup_box">		
	<div class="popup_bg"></div>
	<div class="security_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">평가위원회 보안서약서</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr" id="btn_reset1_1"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="txt">
				<form id="reset_test_form">
					<ol>
						<li><p>① 사업에 대한 평가를 수행하는 과정에서 습득한 기술기밀에 대해 사업수행 중은 물론 종료후에도 서울기술연구원장의 허락없이 자신 또는 제 3자를 위해서 사용하지 않는다.</p><span class="fw_b ta_r"><input type="checkbox" id="security_of_service1" name="security_of_service1" value="동의"><label for="security_of_service1">상기 내용을 확인하고 동의합니다.</label></span>
						</li>
						<li><p>② 사업의 내용 또는 추진성과가 적법하게 공개된 경우라 하여도 미공개 부분에 대해서는 1항과 같은 비밀유지 의무를 부담한다.</p>
							 <span class="fw_b ta_r"><input type="checkbox" id="security_of_service2" name="security_of_service2" value="동의"><label for="security_of_service2">상기 내용을 확인하고 동의합니다.</label></span></li>
						<li><p>③ 위의 사항을 본인이 준수하지 않아 발생하는 제반사항에 대해 필요한 책임을 부담한다.</p>
							 <span class="fw_b ta_r"><input type="checkbox" id="security_of_service3" name="security_of_service3" value="동의"><label for="security_of_service3">상기 내용을 확인하고 동의합니다.</label></span></li>
					</ol>							
					
					<div class="day" style="text-align: center;">								
						<p style="display:inline-block;" class="clearfix" id="security_declaration_date">
						</p>
					</div>

					<div class="sit_leader">
						<p>서울기술연구원장 귀하</p>
					</div>							
				</form>
				<div class="popup_button_area_center clearfix" style="margin: auto;text-align: center;width: 100%;">
					<button type="button" class="blue_btn mr5 security_preview_btn" style="float: none;" onclick="signSecurity();">서명</button>
					<div class="m_a" style="margin: auto;text-align: center;width: 100%;">
						<button type="button" class="blue_btn mr5 d_n sign_complate"  id="btn_reset__" style="float: none;">서명 완료</button>
						<button type="button" class="blue_btn mr5 d_n" onclick="agreeSecurity();" id="btn_reset" style="float: none;">완료</button>							
					</div>
				</div>
			</div>		
		
		</div> 
	</div>
</div>
<!--//보안서약서 팝업-->

<!--보안서약서 확인 팝업-->			
<div class="security_ok_popup_box">		
	<div class="popup_bg"></div>
	<div class="security_ok_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">평가위원회 보안서약서</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">보안서약서</span>가 작성 완료 되었습니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5 popup_close_btn">확인</button>
			</div>	
		</div>									
	</div> 
</div>
<!--지급청구서 확인 팝업-->

<!--지급청구서 팝업-->
<div class="receipt_popup_box">		
	<div class="popup_bg"></div>
	<div class="receipt_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">평가위원회 지급청구서</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr" id="btn_reset2_1"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="txt">
				<form id="reset_test_form2">
					<table class="write fixed">
						<caption>평가위원회 지급청구서</caption>
						<colgroup>
							<col style="width: 20%;">
							<col style="width: 80%;">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">성명</th>
								<td id="name"><span>홍길동</span></td> 
							</tr>									  
							<tr>
								<th scope="row">생년월일</th>
								<td><span><span class="fl ls">1992</span><span class="fl">-</span><span class="fl ls">01</span><span class="fl">-</span><span class="fl ls">20</span></span></td> 
							</tr>
							<tr>
								<th scope="row">휴대전화</th>
								<td id="mobile_phone"></td> 
							</tr>
							<tr>
								<th scope="row">이메일</th>
								<td id="email"></td> 
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td id="address"></td> 
							</tr>
							<tr>
								<th scope="row">은행명</th>
								<td>
									<input type="text" id="bank_name" class="form-control w30 fl mr10"  disabled />
									<label for="bank_name" class="hidden fl">은행명</label>
									<button type="button" title="수정하기" class="gray_btn2" onclick="updateBankName(this);">수정하기</button>
								</td> 
							</tr>
							<tr>
								<th scope="row">계좌번호</th>
								<td>
									<input type="text" id="bank_number" class="form-control w60 fl mr10" disabled />
									<label for="bank_number" class="hidden fl">계좌번호</label>
									<button type="button" title="수정하기" class="gray_btn2" onclick="updateBankAccount(this);">수정하기</button>
								</td> 
							</tr>
						</tbody>
					</table>
				</form>
				<!--사인-->	
				<!--<div class="sign claerfix">															
					 <div class="sign claerfix">															
						 <div class="sigPad claerfix fl" id="linear" style="width:304px">															
							<div class="fl">
								<button type="button" class="blue_btn receipt_sign_save_btn" id="save">서명 저장하기</button>	
							</div>
							<div class="clearButton fr">										
								<button type="button" class="gray_btn clear_btn">지우기</button>											
							</div>	
																
							<div class="sign sigWrapper" style="height:auto;">										
								<canvas class="pad" width="300" height="80" id="downloadImage"></canvas>												
								<span class="sign_txt2">서명</span>
							</div>
						 </div>	
					 </div>									
				</div>-->
				<!--//사인-->
			</div>
			
			<div class="popup_button_area_center clearfix mt5" style="text-align: center;width: 100%;">
				<button type="button" class="blue_btn mr5 receipt_preview_btn" style="float: none;" onclick="signPayment();">서명</button>
				<div class="m_a2" style="margin: auto;text-align: center;width: 100%;">
					<button type="button" class="blue_btn mr5 d_n sign_complate"  id="btn_reset__2" style="float: none;">서명 완료</button>
					<button type="button" class="blue_btn mr5 d_n" onclick="agreePayment();" id="btn_reset2" style="float: none;">완료</button>						
				</div>
			</div>	

		</div>									
	</div> 
</div>
<!--//지급청구서 팝업-->

<!--지급청구서 확인 팝업-->
<div class="receipt_ok_popup_box">		
	<div class="popup_bg"></div>
	<div class="receipt_ok_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">평가위원회 지급청구서</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">지급청구서</span>가 저장 되었습니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5 popup_close_btn">확인</button>
			</div>	
		</div>									
	</div> 
</div>
<!--지급청구서 확인 팝업-->


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
				<button type="button" class="blue_btn popup_close_btn" title="확인" onclick="commonPopupConfirm();">확인</button>
			</div>
		</div>						
	</div> 
</div>
