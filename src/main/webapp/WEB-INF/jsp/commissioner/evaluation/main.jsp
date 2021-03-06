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
			var str = "<tr>" + "<td colspan='11'>????????? ????????? ????????????.</td>" + "</tr>";
			body.append(str);
			$("#search_count").html("[??? <span class='font_blue'>" + total + "</span>???]");
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchEvaluationList"
				};
	
			gfnRenderPaging(params);
			
			$("#search_count").html("[??? <span class='font_blue'>" + total + "</span>???]");
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
					str += "<td><span class='font_blue'>????????????</span></td>";
				} else {
					str += "<td><a href='javascript:void(0);' onclick='displayPopupSecurity(\"" + value.evaluation_id + "\");'>?????????</a></td>";
				}

				if ( value.payment_declaration_yn == "Y") {
					str += "<td><span class='font_blue'>????????????</span></td>";
				} else {
					str += "<td><a href='javascript:void(0);' onclick='displayPopupPayment(\"" + value.evaluation_id + "\");'>?????????</a></td>";
				}

				if (value.chairman_yn == "Y") {
					if ( value.evaluation_report_yn == "Y" && value.chairman_submit_yn == "Y") {
						str += "<td><span class='font_blue'>????????????</span></td>";
					} else {
						if ( value.security_declaration_yn == "Y" && value.payment_declaration_yn == "Y") {
							str += "<td class='last'><button type='button' class='blue_btn' onclick='location.href=\"/commissioner/fwd/evaluation/estimation?evaluation_id=" + value.evaluation_id + "\"'>?????? ??????</button></td>";
						} else {
							str += "<td></td>";
						} 
					}
				} else {
					if ( value.evaluation_report_yn == "Y" ) {
						str += "<td><span class='font_blue'>????????????</span></td>";
					} else {
						if ( value.security_declaration_yn == "Y" && value.payment_declaration_yn == "Y") {
							str += "<td class='last'><button type='button' class='blue_btn' onclick='location.href=\"/commissioner/fwd/evaluation/estimation?evaluation_id=" + value.evaluation_id + "\"'>?????? ??????</button></td>";
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
		var year = today.getFullYear(); // ??????
		var month = today.getMonth() + 1;  // ???
		var date = today.getDate();  // ??????
		
		$("#security_declaration_date").html( "<span class='fl'>" + year + "</span><span class='fl mr10'>???</span><span class='fl'>" + month + "</span><span class='fl mr10'>???</span><span class='fl'>" + date + "</span><span class='fl'>???");
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
		var year = today.getFullYear(); // ??????
		var month = today.getMonth() + 1;  // ???
		var date = today.getDate();  // ??????
		
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
			    	showPopup("??????????????? ????????? ?????????????????????.");
			    	$('.security_popup_box, .security_popup_box .popup_bg').fadeOut(350);
			    	searchEvaluationList(1);
			    } else {
			    	showPopup("??????????????? ????????? ??????????????????. ?????? ????????? ????????? ????????????.");
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
			    	showPopup("??????????????? ????????? ?????????????????????.");
			    	$('.receipt_popup_box').fadeOut(350);	
			    	searchEvaluationList(1);
			    } else {
			    	showPopup("??????????????? ????????? ??????????????????. ?????? ????????? ????????? ????????????.");
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
		if( $(element).text() == '????????????' ) {
			$(element).text('?????? ??????');				
			bank_name_modify.prop( 'disabled', false );			
		}
		else {          
			bank_name_modify.prop( 'disabled', true );
			$(element).text('????????????');
			updateBankInfo();
		}	
	}

	function updateBankAccount(element) {
		var bank_number_modify = $("#bank_number").prop('disabled', true);
		$(".d_input").prop("disabled", bank_number_modify ? false : true);
		if( $(element).text() == '????????????' ) {
			$(element).text('?????? ??????');				
			bank_number_modify.prop( 'disabled', false );			
		}
		else {          
			bank_number_modify.prop( 'disabled', true );
			$(element).text('????????????');
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
			    	showPopup("???????????? ????????? ?????????????????????.");
			    } else {
			    	showPopup("???????????? ????????? ??????????????????. ?????? ????????? ????????? ????????????.");
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
	<h2 class="hidden">?????? ????????? ??????</h2>	
		<section id="content" class="est-sub">
			<div id="sub_contents">
		    	<div class="content_area">
					<div class="route hidden">
						<ul class="clearfix">
							<li><i class="fas fa-home">???</i></li>
							<li>???????????? ????????????</li>
							<li>???????????? ????????????</li>
						</ul>
					</div>
					<div class="content_area pt120">
						<h4>?????? ??????</h4>
						<!--?????????-->
						<div class="announcement_index_infotxt">
							<ul>
								<li><a href="" download><span class="fw_b">?????? ?????????</span></a>??? ????????? ?????????.</li>
								<li>?????? ?????? ??? <span class="fw_b">???????????????</span>??? <span class="fw_b">???????????????</span>??? ??????????????? ????????????. </li>
								<li><span class="blue_btn">?????? ??????</span> ????????? ????????? ??????, ????????? ????????? ????????? ?????? ????????? ????????????, ????????? ???????????? ????????? ???????????????.</li>
							</ul>
							<a href="" title="???????????????" class="blue_btn manual" download>?????? ????????? ????????????</a>
						</div>
						<!--?????????-->
								
						<h4>?????? ?????? ??????</h4>
						<!--table_count_area-->
						<div class="table_count_area">
							<div class="count_area" id="search_count">
								[??? <span class="fw500 font_blue">0</span>???]
							</div>
						</div>
						<!--//table_count_area-->
						<!--???????????????-->							
						<div class="table_area">
							<table class="list fixed announcement_index_table">
								<caption>?????? ??????</caption>
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
										<th scope="col" class="first">??????</th>
										<th scope="col">?????????</th>
										<th scope="col">?????????</th>
										<th scope="col">????????????</th>
										<th scope="col">???????????? ?????????</th>
										<th scope="col">?????? ?????????</th>
										<th scope="col">?????? ?????????</th>
										<th scope="col">?????? ?????????</th>
										<th scope="col">?????? ?????????</th>
										<th scope="col">?????? ?????????</th>
										<th scope="col" class="last">??????</th>
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
 
 
<!--??????????????? ??????-->
<div class="security_popup_box">		
	<div class="popup_bg"></div>
	<div class="security_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">??????????????? ???????????????</h4>
            <a href="javascript:void(0)" title="??????" class="white_font close_btn popup_close_btn fr" id="btn_reset1_1"><i class="fas fa-times"></i><span class="hidden">??????</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="txt">
				<form id="reset_test_form">
					<ol>
						<li><p>??? ????????? ?????? ????????? ???????????? ???????????? ????????? ??????????????? ?????? ???????????? ?????? ?????? ??????????????? ??????????????????????????? ???????????? ?????? ?????? ??? 3?????? ????????? ???????????? ?????????.</p><span class="fw_b ta_r"><input type="checkbox" id="security_of_service1" name="security_of_service1" value="??????"><label for="security_of_service1">?????? ????????? ???????????? ???????????????.</label></span>
						</li>
						<li><p>??? ????????? ?????? ?????? ??????????????? ???????????? ????????? ????????? ????????? ????????? ????????? ???????????? 1?????? ?????? ???????????? ????????? ????????????.</p>
							 <span class="fw_b ta_r"><input type="checkbox" id="security_of_service2" name="security_of_service2" value="??????"><label for="security_of_service2">?????? ????????? ???????????? ???????????????.</label></span></li>
						<li><p>??? ?????? ????????? ????????? ???????????? ?????? ???????????? ??????????????? ?????? ????????? ????????? ????????????.</p>
							 <span class="fw_b ta_r"><input type="checkbox" id="security_of_service3" name="security_of_service3" value="??????"><label for="security_of_service3">?????? ????????? ???????????? ???????????????.</label></span></li>
					</ol>							
					
					<div class="day" style="text-align: center;">								
						<p style="display:inline-block;" class="clearfix" id="security_declaration_date">
						</p>
					</div>

					<div class="sit_leader">
						<p>???????????????????????? ??????</p>
					</div>							
				</form>
				<div class="popup_button_area_center clearfix" style="margin: auto;text-align: center;width: 100%;">
					<button type="button" class="blue_btn mr5 security_preview_btn" style="float: none;" onclick="signSecurity();">??????</button>
					<div class="m_a" style="margin: auto;text-align: center;width: 100%;">
						<button type="button" class="blue_btn mr5 d_n sign_complate"  id="btn_reset__" style="float: none;">?????? ??????</button>
						<button type="button" class="blue_btn mr5 d_n" onclick="agreeSecurity();" id="btn_reset" style="float: none;">??????</button>							
					</div>
				</div>
			</div>		
		
		</div> 
	</div>
</div>
<!--//??????????????? ??????-->

<!--??????????????? ?????? ??????-->			
<div class="security_ok_popup_box">		
	<div class="popup_bg"></div>
	<div class="security_ok_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">??????????????? ???????????????</h4>
            <a href="javascript:void(0)" title="??????" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">??????</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">???????????????</span>??? ?????? ?????? ???????????????.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5 popup_close_btn">??????</button>
			</div>	
		</div>									
	</div> 
</div>
<!--??????????????? ?????? ??????-->

<!--??????????????? ??????-->
<div class="receipt_popup_box">		
	<div class="popup_bg"></div>
	<div class="receipt_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">??????????????? ???????????????</h4>
            <a href="javascript:void(0)" title="??????" class="white_font close_btn popup_close_btn fr" id="btn_reset2_1"><i class="fas fa-times"></i><span class="hidden">??????</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="txt">
				<form id="reset_test_form2">
					<table class="write fixed">
						<caption>??????????????? ???????????????</caption>
						<colgroup>
							<col style="width: 20%;">
							<col style="width: 80%;">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">??????</th>
								<td id="name"><span>?????????</span></td> 
							</tr>									  
							<tr>
								<th scope="row">????????????</th>
								<td><span><span class="fl ls">1992</span><span class="fl">-</span><span class="fl ls">01</span><span class="fl">-</span><span class="fl ls">20</span></span></td> 
							</tr>
							<tr>
								<th scope="row">????????????</th>
								<td id="mobile_phone"></td> 
							</tr>
							<tr>
								<th scope="row">?????????</th>
								<td id="email"></td> 
							</tr>
							<tr>
								<th scope="row">??????</th>
								<td id="address"></td> 
							</tr>
							<tr>
								<th scope="row">?????????</th>
								<td>
									<input type="text" id="bank_name" class="form-control w30 fl mr10"  disabled />
									<label for="bank_name" class="hidden fl">?????????</label>
									<button type="button" title="????????????" class="gray_btn2" onclick="updateBankName(this);">????????????</button>
								</td> 
							</tr>
							<tr>
								<th scope="row">????????????</th>
								<td>
									<input type="text" id="bank_number" class="form-control w60 fl mr10" disabled />
									<label for="bank_number" class="hidden fl">????????????</label>
									<button type="button" title="????????????" class="gray_btn2" onclick="updateBankAccount(this);">????????????</button>
								</td> 
							</tr>
						</tbody>
					</table>
				</form>
				<!--??????-->	
				<!--<div class="sign claerfix">															
					 <div class="sign claerfix">															
						 <div class="sigPad claerfix fl" id="linear" style="width:304px">															
							<div class="fl">
								<button type="button" class="blue_btn receipt_sign_save_btn" id="save">?????? ????????????</button>	
							</div>
							<div class="clearButton fr">										
								<button type="button" class="gray_btn clear_btn">?????????</button>											
							</div>	
																
							<div class="sign sigWrapper" style="height:auto;">										
								<canvas class="pad" width="300" height="80" id="downloadImage"></canvas>												
								<span class="sign_txt2">??????</span>
							</div>
						 </div>	
					 </div>									
				</div>-->
				<!--//??????-->
			</div>
			
			<div class="popup_button_area_center clearfix mt5" style="text-align: center;width: 100%;">
				<button type="button" class="blue_btn mr5 receipt_preview_btn" style="float: none;" onclick="signPayment();">??????</button>
				<div class="m_a2" style="margin: auto;text-align: center;width: 100%;">
					<button type="button" class="blue_btn mr5 d_n sign_complate"  id="btn_reset__2" style="float: none;">?????? ??????</button>
					<button type="button" class="blue_btn mr5 d_n" onclick="agreePayment();" id="btn_reset2" style="float: none;">??????</button>						
				</div>
			</div>	

		</div>									
	</div> 
</div>
<!--//??????????????? ??????-->

<!--??????????????? ?????? ??????-->
<div class="receipt_ok_popup_box">		
	<div class="popup_bg"></div>
	<div class="receipt_ok_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">??????????????? ???????????????</h4>
            <a href="javascript:void(0)" title="??????" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">??????</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">???????????????</span>??? ?????? ???????????????.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn mr5 popup_close_btn">??????</button>
			</div>	
		</div>									
	</div> 
</div>
<!--??????????????? ?????? ??????-->


<!--?????? ??????-->
<div class="common_popup_box">
	<div class="popup_bg"></div>
	<div class="id_check_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl" id="popup_title"></h4>
			<a href="javascript:void(0)" title="??????" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">??????</span></a>
		</div>					
		<div class="popup_txt_area">
			<div class="popup_txt_areabg">
				<p id="popup_info" tabindex="0"></p>	
			</div>
			
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn" title="??????" onclick="commonPopupConfirm();">??????</button>
			</div>
		</div>						
	</div> 
</div>
