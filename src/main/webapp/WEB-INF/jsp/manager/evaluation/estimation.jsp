<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="${ctx}/assets/SE2/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<sec:authentication property="principal.username" var="member_id" />
  
<script src="/assets/user/js/script.js"></script>  
<script type='text/javascript'>
	var isModification = false;
	
	$(document).ready(function() {
	 	searchEvaluationDetail();
	 	searchEvaluationCommissionerDetail();
	 	searchEvaluationResultItemDetail();
	 	searchEvaluationItemDetail();
	});

	// 평가위원이 평가한 평가 항목이 있는지 검색
	function searchEvaluationResultItemDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/commissioner/api/evaluation/resultItem/detail'/>");
		comAjax.addParam("member_id","${member_id}");
		comAjax.addParam("evaluation_id","${vo.evaluation_id}");
		comAjax.setCallback(searchEvaluationResultItemDetailCB);
		comAjax.ajax();
	}
	var evaluationResultItemInfo = null;
	function searchEvaluationResultItemDetailCB(data){
		evaluationResultItemInfo = data.result_data;
	}

	
	// 평가항목 검색
	function searchEvaluationItemDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/commissioner/api/evaluation/item/detail'/>");
		comAjax.addParam("evaluation_id","${vo.evaluation_id}");
		comAjax.setCallback(searchEvaluationItemDetailCB);
		comAjax.ajax();
	}
	var evaluationItemInfo;
	function searchEvaluationItemDetailCB(data){
		console.log(data);
		
		evaluationItemInfo = data.result_data;

		var str = "";
		var pointIndex = 1;
		var totalLimitPoint = 0;
		var totalInputPoint = 0;
		// a_type 평가서 인 경우
		if ( evaluationItemInfo.item_type == "A1" || evaluationItemInfo.item_type == "A2" || evaluationItemInfo.item_type == "A3") {
			var body = $("#evaluation_item_body");
			body.empty();

			$("#a_type_div").show();
			$("#b_type_div").hide();
			
			$.each(evaluationItemInfo, function(index, item){ 
				if ( item.item_releated_list != null && item.item_releated_list.length > 0) {
					$.each(item.item_releated_list, function(index2, item2){
						if ( item2.item_form_detail_info_list != null && item2.item_form_detail_info_list.length > 0) {
							$.each(item2.item_form_detail_info_list, function(index3, item3){
								totalLimitPoint = totalLimitPoint + Number(item3.form_item_result);
								str += "<tr item_id='" + item3.item_id + "'>";
								if (index3 == 0 ) {
									str += "<td class='first last rating_item' rowspan='" +item2.item_form_detail_info_list.length  + "'><span>" + item2.form_item_name + "</span></td>";
								}
								str += "	<td class='first rating_indicators'>" + item3.form_item_detail_name + "</td>";
								str += "	<td class='sum_cell_1' id='limit_point_" + pointIndex + "'>" + item3.form_item_result +"</td>";
								str += "	<td class='last sum_cell_2'>";

								var inputPoint = 0;
								if (evaluationResultItemInfo != null && evaluationResultItemInfo.item_result_info_list !=null && evaluationResultItemInfo.item_result_info_list.length > 0){
									$.each(evaluationResultItemInfo.item_result_info_list, function(index4, item4){
										if ( item4.item_id == item3.item_id ) {
											inputPoint = item4.item_result;
											totalInputPoint = Number(totalInputPoint) + Number(inputPoint);
											return false;
										}
									});
								}
								if ( inputPoint != 0 ) {
									str += "	<input type='text' value='" + inputPoint + "'name='select_point' index='" + pointIndex + "' class='form-control w100 ls number_t' maxlength='2' onkeyup='inputPoint(this);'/>";
								} else {

									str += "	<input type='text' name='select_point' index='" + pointIndex + "' class='form-control w100 ls number_t' maxlength='2' onkeyup='inputPoint(this);'/>";
								} 
								str += "	</td>";
								str += "</tr>";
								pointIndex++;
							});
						}
					});
				}
			});
		}
		// b_type 평가서 인 경우 
		else {
			var body = $("#b_type_evaluation_item_body");
			body.empty();
			
			$("#a_type_div").hide();
			$("#b_type_div").show();

			$.each(evaluationItemInfo, function(index, item){ 
				if ( item.item_releated_list != null && item.item_releated_list.length > 0) {
					$.each(item.item_releated_list, function(index2, item2){
						if ( item2.item_form_detail_info_list != null && item2.item_form_detail_info_list.length > 0) {
							$.each(item2.item_form_detail_info_list, function(index3, item3){
								totalLimitPoint = totalLimitPoint + Number(item3.form_item_result);
								str += "<tr item_id='" + item3.item_id + "'>";
								if (index3 == 0 ) {
									str += "<td class='first last rating_item' rowspan='" +item2.item_form_detail_info_list.length  + "'><span>" + item2.form_item_name + "</span></td>";
								}

								str += "	<td class='first rating_indicators'>" + item3.form_item_detail_name + "</td>";
								
								if (evaluationResultItemInfo != null && evaluationResultItemInfo.item_result_info_list !=null && evaluationResultItemInfo.item_result_info_list.length > 0){
									$.each(evaluationResultItemInfo.item_result_info_list, function(index4, item4){
										if ( item4.item_id == item3.item_id ) {
											str += "	<td><textarea rows='10' class='w100'>" + item4.item_result + "</textarea></td>";
											return false;
										}
									});
								} else {
									str += "	<td><textarea rows='10' class='w100'></textarea></td>";
								}

								
								str += "</tr>";
								pointIndex++;
							});
						}
					});
				}
			});
		}
		
		body.append(str);
		$("#total_limit_point").html("<span>" + totalLimitPoint + " 점</span>");
		$("#total_input_point").val(totalInputPoint);
	}

	
	// 평가 상세 조회
	function searchEvaluationDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/commissioner/api/evaluation/detail'/>");
		comAjax.addParam("evaluation_id","${vo.evaluation_id}");
		comAjax.setCallback(searchEvaluationDetailCB);
		comAjax.ajax();
	}
	var evaluationInfo;
	function searchEvaluationDetailCB(data){
		evaluationInfo = data.result_data;

		$("td[name='reception_id']").html("<span>" + evaluationInfo.reception_id + "</span>");
		$("td[name='tech_info_name']").html("<span>" + evaluationInfo.tech_info_name + "</span>");
		$("td[name='institution_name']").html("<span>" + evaluationInfo.institution_name + "</span>");
		$("td[name='steward']").html("<span>" + evaluationInfo.steward + "</span>");
		$("td[name='evaluation_date']").html("<span>" + evaluationInfo.evaluation_date + "</span>");
		
		var body = $("#evaluation_body");
		body.empty();
		
		var str = "";
		str += "<tr>";
		str += "	<td class='first'><span>" + evaluationInfo.announcement_type_name +"</span></td>";
		str += "	<td><span>" + evaluationInfo.classification_name +"</span></td>";
		str += "	<td class='last'><span>" + evaluationInfo.type_name + "</span></td>";
		str += "</tr>";
		
		body.append(str);
	}

	// 평가위원 상세 조회
	function searchEvaluationCommissionerDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/commissioner/api/evaluation/commissioner/detail2'/>");
		comAjax.setCallback(searchEvaluationCommissionerDetailCB);
		comAjax.addParam("member_id", "${member_id}");
		comAjax.addParam("evaluation_id", "${vo.evaluation_id}");
		comAjax.ajax();
	}
	function searchEvaluationCommissionerDetailCB(data){
		var body = $("#commissioner_body");
		body.empty();

		var str = "";
		str += "<tr>";
		str += "	<td class='first'><span>평가위원</span></td>";
		str += "	<td><span>개별평가서</span></td>";
		str += "	<td><span>" + evaluationInfo.tech_info_name + "</span></td>";
		str += "	<td><span></span>" + data.result_data.total_point + "</td>";
		str += "	<td><span></span></td>";
		if ( data.result_data.evaluation_report_yn == "Y") {
			str += "	<td></td>";
			str += "	<td class='last'><span class='font_blue'>제출완료</span></td>";
		} else {
			str += "	<td><button type='button' title='작성하기' class='blue_btn' onclick='commissionerWrite(this);'>작성하기</button></td>";
			str += "	<td class='last'><span>미제출</span></td>";
		}
		
		str += "</tr>";
		
		if ( data.result_data.chairman_yn == "Y") {
			str += "<tr class='leader_cell'>";
			str += "	<td class='first'><span>평가위원장</span></td>";
			str += "	<td><span>종합평가서</span></td>";
			str += "	<td><span>" + evaluationInfo.tech_info_name + "</span></td>";
			str += "	<td><span></span></td>";
			str += "	<td><span></span></td>";
			str += "	<td><button type='button' title='작성하기' class='blue_btn' onclick='chairmanWrite(this);'>작성하기</button></td>";
			str += "	<td class='last'><span>미제출</span></td>";
			str += "</tr>";
		}
		body.append(str);

		// 위원장인 경우 평가위원의 모든 평가 내용을 봐야 한다.
		// 해당 평가에 선정된 평가위원 정보 검색
		if ( data.result_data.chairman_yn == "Y") {
			searchCommissionerList();
		}
		
	}

	// 위원장인 경우 평가위원의 모든 평가 내용을 봐야 한다.
	// 해당 평가에 선정된 평가위원 정보 검색
	function searchCommissionerList() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/commissioner/api/evaluation/search/relatedCommissionerList'/>");
		comAjax.addParam("evaluation_id","${vo.evaluation_id}");
		comAjax.addParam("choice_yn","Y");
		comAjax.setCallback(searchCommissionerListCB);
		comAjax.ajax();
	}

	var isAllEvaluationCompleted = true;
	function searchCommissionerListCB(data){
		var body = $("#commissioner_evaluation_list");
		body.empty();
		
		var str = "";	
		var evaluationItemCount = 0;
		var sumTotalPoint = 0;
		$("#commissioner_count").html("<span>평가위원</span><span>(" + data.result_data.length + "명)</span>");
		$.each(data.result_data, function(key, value) {
			str += "<tr>";
			str += "	<td class='first'><span>" + value.member_name + "</span></td>";

			// 평가서가 완료된 평가위원 정보만 업데이트 한다.
			if ( value.evaluation_report_yn == "Y") {
				var totalPoint = 0;
				var index = 1;
				
				evaluationItemCount = value.commissioner_item_result_list.length;
				// 평가 점수 입력
				$.each(value.commissioner_item_result_list, function(key2, value2) {
					str += "<td class='evaluation_item_" + index + "'><span>" + value2.item_result + "</span></td>";
					totalPoint += Number(value2.item_result);
					index++;
				});

				// 현재 10까지만 입력 가능. 평가점수가 있는 것은 평가 점수를 입력하고 나머지 없는 것은 공백으로 한다.
				for (var i=0; i<(10-value.commissioner_item_result_list.length); i++) {
					str += "<td><span>&nbsp;</span></td>"; 
				}
				sumTotalPoint += Number(totalPoint);
				str += "<td class='result_sum td_c'><span>" + totalPoint + "</span></td>";
				str += "<td class='last'>";
				str += "	<div class='sign_annex'>";
				str += "		<img src='" + value.evaluation_report_declaration_sign + "' alt='서명이미지' class='d_n sign_load' />";
				str += "	</div>";
				str += "</td>";
																		
			} else {
				isAllEvaluationCompleted = false;
				str += "<td><span>&nbsp;</span></td>";
				str += "<td><span>&nbsp;</span></td>";
				str += "<td><span>&nbsp;</span></td>";
				str += "<td><span>&nbsp;</span></td>";
				str += "<td><span>&nbsp;</span></td>";
				str += "<td><span>&nbsp;</span></td>";
				str += "<td><span>&nbsp;</span></td>";
				str += "<td><span>&nbsp;</span></td>";
				str += "<td><span>&nbsp;</span></td>";
				str += "<td><span>&nbsp;</span></td>";
				str += "<td class='result_sum td_c'><span>&nbsp;</span></td>";
				str += "<td class='last'>평가서 미제출</td>";
			}
			
			str += "</tr>";
		});

		body.append(str);

		// 최고 점수
		str += "<tr>";
		str += "	<td class='first td_c2'><span class='fw_b'>최고점수</span></td>";
		// 최고 점수를 찾는다.
		var totalHighPoint = 0;
		for (var i=0; i<evaluationItemCount; i++) {
			var highPoint = 0;
			$(".evaluation_item_" + (i+1)).each(function(){
				if ( Number($(this).text()) >= Number(highPoint)) {
					highPoint = Number($(this).text());
				}
			});

			str += "<td class='td_c'><span>" + highPoint + "</span></td>";
			totalHighPoint += Number(highPoint); 
		}
		// 현재 10까지만 입력 가능. 평가점수가 있는 것은 평가 점수를 입력하고 나머지 없는 것은 공백으로 한다.
		for (var i=0; i<(10-evaluationItemCount); i++) {
			str += "<td class='td_c'><span>&nbsp;</span></td>"; 
		}

		if ( totalHighPoint > 0) {
			str += "<td class='result_sum td_c'><span>" + totalHighPoint + "</span></td>"; 
		} else {
			str += "<td class='result_sum td_c'><span>&nbsp;</span></td>"; 
		}
		str += "	<td class='last'><span>&nbsp;</span></td>"; 
		str += "</tr>";


		// 최저 점수
		str += "<tr>";
		str += "	<td class='first td_c2'><span class='fw_b'>최저점수</span></td>";
		// 최저 점수를 찾는다.
		var totalLowPoint = 0;
		for (var i=0; i<evaluationItemCount; i++) {
			var lowPoint = 0;
			var isFirst = true;
			$(".evaluation_item_" + (i+1)).each(function(){
				if ( isFirst ) {
					lowPoint = Number($(this).text());
					isFirst = false; 
				} else {
					if ( Number($(this).text()) <= Number(lowPoint)) {
						lowPoint = Number($(this).text());
					}
				}
			});

			str += "<td class='td_c'><span>" + lowPoint + "</span></td>";
			totalLowPoint += Number(lowPoint); 
		}
		// 현재 10까지만 입력 가능. 평가점수가 있는 것은 평가 점수를 입력하고 나머지 없는 것은 공백으로 한다.
		for (var i=0; i<(10-evaluationItemCount); i++) {
			str += "<td class='td_c'><span>&nbsp;</span></td>"; 
		}

		if ( totalLowPoint > 0) {
			str += "<td class='result_sum td_c'><span>" + totalLowPoint + "</span></td>"; 
		} else {
			str += "<td class='result_sum td_c'><span>&nbsp;</span></td>"; 
		}
		str += "	<td class='last'><span>&nbsp;</span></td>"; 
		str += "</tr>";

		// 합계
		str += "<tr>";
		str += "	<td class='first td_c2' colspan='11'><span class='fw_b'>합계</span></td>";
		if ( sumTotalPoint != 0) {
			str += "	<td class='last sum_result td_c' colspan='2'><span>" + sumTotalPoint + "</span></td>";
		} else {
			str += "	<td class='last sum_result td_c' colspan='2'><span>&nbsp;</span></td>";
		}
		str += "</tr>";

		//최종합계
		str += "<tr>";
		str += "	<td class='first td_c2' colspan='11'><span class='fw_b'>최종합계<span class='fw_b'>(합계-최고점수-최저점수)</span></span></td>";
		var finalTotalPoint = sumTotalPoint - totalHighPoint - totalLowPoint;
		str += "	<td class='last sum_result td_c' colspan='2'><span>" + finalTotalPoint + "</span></td>";
		str += "</tr>";

		//최종평균
		str += "<tr>";
		str += "	<td class='first td_c2' colspan='11'><span class='fw_b'>최종평균<span class='fw_b'>((합계-최고점수-최저점수)/(N명)</span></span></td>";
		var finalAvg = finalTotalPoint / data.result_data.length;
		str += "	<td class='last sum_result td_c' colspan='2'><span>" + finalAvg + "</span></td>";
		str += "</tr>";
/* 
	
	<tr>
		<td colspan="2" class="first td_c2 fw_b">가점 입력(간사입력)</td>
		<td colspan="9">
			<div class="ta_r">
				<input type="text" id="plus_write" class="form-control w20 ls number_t" />
				<label for="plus_write">점</label>
			</div>
		</td>
		<td class="last total_score" colspan="2">
			<span class="mr5">&nbsp;</span>													
		</td>														
	</tr> */

		body.empty();
		body.append(str);
	}

	// 평가 배점 
	function inputPoint(element) {
		$(element).val($(element).val().replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'));
		
		var index = $(element).attr("index");
		var limitPoint = $("#limit_point_" + index).text();
		var inputPoint = $(element).val();
		if ( gfn_isNull(inputPoint) == false && (Number(inputPoint) > Number(limitPoint)) ) {
			showPopup("입력한 값은 전체 값을 초과 할 수 없습니다.","배점입력");
			$(element).val("");
			return;
		}

		var total = 0;
	 	$("input[name='select_point']").each(function() {
			var tempValue = 0;
			if ( gfn_isNull(this.value) == false ) {
				tempValue = this.value;
			}
			total += Number(tempValue);
	 	});
		$("#total_input_point").val(total);
	}
	
	// 평가위원 작성 화면
	function commissionerWrite(element) {
		$(element).addClass('add_click_btn');
		$(element).parents('td').siblings('td.last').children('span').addClass('add_click_btn2');
		$('.list_back_btn').fadeOut(350);
		$('.rating_result_tabel_area, .rating_result_tabel_area .list_btn').fadeIn(350);
		$('.rating_leader_tabel_area, .rating_leader_tabel_area .list_btn').fadeOut(350);			
	}

	// 평가위원장 작성 화면
	function chairmanWrite(element) {
		$(element).addClass('add_click_leader_btn');
		$(element).parents('td').siblings('td.last').children('span').addClass('add_click_leader_btn2');
		$('.list_back_btn').fadeOut(350);
		$('.rating_leader_tabel_area, .rating_leader_tabel_area .list_btn').fadeIn(350);
		$('.rating_result_tabel_area, .rating_result_tabel_area .list_btn').fadeOut(350);
		$('.rating_leader_tabel_area input, .rating_leader_tabel_area textarea').prop('disabled', false);
	}

	// 서명
	function signEvaluation() {
		var url = "/manager/fwd/evaluation/sign/evaluation?member_id=" + "${member_id}" + "&evaluation_id=" + "${vo.evaluation_id}";  
		window.open(url, "_blank", 'width=700, height=460'); 				
	}

	var finishSubmitEvaluation = false;
	function submitEvaluation() {
		// 점수 입력
		if ( registrationEvalutionResultItem(2) == false ) {
			return;
		}

		var formData = new FormData();
		formData.append("member_id", "${member_id}");
		formData.append("evaluation_id", "${vo.evaluation_id}");
		formData.append("evaluation_report_yn", "Y");
		formData.append("total_point", $("#total_input_point").val());
			
		$.ajax({
		    type : "POST",
		    url : "/commissioner/api/evaluation/update/submitEvaluation",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
			    if ( jsonData.result == true) {
			    	showPopup("평가서 제출이 완료되었습니다.");
			    	finishSubmitEvaluation = true;
			    } else {
			    	showPopup("평가서 제출에 실패했습니다. 디시 시도해 주시기 바랍니다.");
			    }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}
	
	// 평가 점수 항목 저장
	function registrationEvalutionResultItem(type) {
		// 입력된 Point 정보 추출
		var returnFlag = true;
		var resultInfoList = new Array();

		// Type A인 경우
		if ( evaluationItemInfo.item_type == "A1" || evaluationItemInfo.item_type == "A2" || evaluationItemInfo.item_type == "A3") {
			$('#evaluation_item_body tr').each(function(){
				var tr = $(this);
				var resultInfo = new Object();
				resultInfo.item_id = $(this).attr("item_id");
				
				var td = tr.children();
				var tdObj = new Object();

				if ( type != 1) {
					var temp = $(this).find("input").val();
					if ( gfn_isNull($(this).find("input").val()) ) {
						showPopup("점수은 필수 입력입니다.");
						returnFlag = false;
						return false;
					}
				}
				if (returnFlag == false) {
					return false;
				}
				
				resultInfo.item_result = $(this).find("input").val();
				resultInfoList.push(resultInfo);
			});
		} 
		// Type B인 경우
		else {
			$('#b_type_evaluation_item_body tr').each(function(){
				var tr = $(this);
				var resultInfo = new Object();
				resultInfo.item_id = $(this).attr("item_id");
				
				var td = tr.children();
				var tdObj = new Object();

				if ( type != 1) {
					var temp = $(this).find("textarea").val();
					if ( gfn_isNull($(this).find("textarea").val()) ) {
						showPopup("검토 입력은 필수 사항입니다.");
						returnFlag = false;
						return false;
					}
				}
				if (returnFlag == false) {
					return false;
				}
				
				resultInfo.item_result = $(this).find("textarea").val();
				resultInfoList.push(resultInfo);
			});
		}
		
		
		if ( type != 1) {
			if (returnFlag == false) {
				return false;
			}
		}
		
		var formData = new FormData();
		formData.append("member_id", "${member_id}");
		formData.append("item_type", evaluationItemInfo[0].item_type);
		formData.append("evaluation_id","${vo.evaluation_id}");
		formData.append("item_result_info_json", JSON.stringify(resultInfoList));

		$.ajax({
		    type : "POST",
		    url : "/commissioner/api/evaluation/resultItem/registration",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		        	if ( type == 1) {
		        		showPopup("임시저장 되었습니다.");
		        		return true;
		        	}
		        } else {
		        	if ( type == 1) {
		        		showPopup("임시저장에 실패하였습니다.");
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

	// 평가위원장 평가서 작성
	function chairmanRegistrationEvalutionResultItem(type) {
		// 모든 평가위원의 평가가 완료되어야 한다.
		if ( isAllEvaluationCompleted == false ) {
			showPopup("모든 평가위원의 평가서가 제출되지 않았습니다.");
			return;
		}
	}

	// 평가위원장 평가서 서명
	function chairmanSignEvaluation() {
		// 모든 평가위원의 평가가 완료되어야 한다.
		if ( isAllEvaluationCompleted == false ) {
			showPopup("모든 평가위원의 평가서가 제출되지 않았습니다.");
			return;
		}
		var url = "/manager/fwd/evaluation/sign/chairmanEvaluation?member_id=" + "${member_id}" + "&evaluation_id=" + "${vo.evaluation_id}";  
		window.open(url, "_blank", 'width=700, height=460'); 				
	}

	function showPopup(content, title) {
		if ( gfn_isNull(title) != true ) {
			$("#popup_title").html(title);
		} else {
			$("#common_popup_close_btn").hide();
		}
	 	$("#popup_info").html(content);
		$('.common_popup_box, .common_popup_box .popup_bg').fadeIn(350);
		
		
	}

	function commonPopupConfirm(){
		if ( finishSubmitEvaluation ) {
			$('.send_save_popup_box').fadeOut(350);
	    	location.reload();
		}
	}

</script>

<!-- container -->
<div id="container" class="mb50">
	<h2 class="hidden">서브 컨텐츠 화면</h2>					
	<section id="content" class="est-sub">
		<div id="sub_contents">
	    	<div class="content_area">
				<h3 class="hidden">평가위원 전자평가</h3>
				<div class="route hidden">
					<ul class="clearfix">
						<li><i class="fas fa-home">홈</i></li>
						<li>평가위원 전자평가</li>
						<li>평가위원 전자평가</li>
					</ul>
				</div>							
							
				<!--평가 과제-->
				<div class="content_area copmpany_area pt120" id="copmpany_area">							
					<h4>평가 과제</h4>	
					<!--평가 과제-->	
					<div class="scroll_box">
						<div class="table_area scroll_table_area">
							<table class="list fixed">
								<caption>평가 과제 목록</caption>
								<colgroup>
									<col style="width:34%" />
									<col style="width:33%" />
									<col style="width:33%" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col" class="first">사업명</th>
										<th scope="col">구분</th>												
										<th scope="col" class="last">평가구분</th>
									</tr>
								</thead>
								<tbody id="evaluation_body">
								</tbody>
							</table>
						</div>	<!--//table_area scroll_table_area-->
						<!--//평가 과제-->
					</div>

					<h4>평가하기</h4>	
					<!--평가하기-->	
					<div class="scroll_box">
						<div class="table_area scroll_table_area">
							<form id="myForm">
								<table class="list fixed">
									<caption>평가하기 목록</caption>
									<colgroup>
										<col style="width:15%" />
										<col style="width:15%" />
										<col style="width:25%" />
										<col style="width:10%" />
										<col style="width:10%" />
										<col style="width:10%" />
										<col style="width:15%" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col" class="first">역할</th>
											<th scope="col">평가서 구분</th>	
											<th scope="col">기술명</th>
											<th scope="col">평가점수</th>
											<th scope="col">평가결과</th>
											<th scope="col">평가서</th>
											<th scope="col" class="last">제출상태</th>
										</tr>
									</thead>
									<tbody id="commissioner_body">
																				
									</tbody>
								</table>
							</form>
						</div>	<!--//table_area scroll_table_area-->
						<!--//평가하기-->
					</div>	

					<!--평가 위원-->									
					<div class="table_area rating_result_tabel_area">
						<div class="table_area">
							<!--개별평가-->
							<table class="write fixed">
								<caption>평가서 구분</caption>
								<colgroup>
									<col style="width: 20%;">																		
									<col style="width: 80%;">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">평가서 구분</th>
										<td><span>개별평가서</span></td>	
									</tr>									  
									<tr>
										<th scope="row">접수번호</th>
										<td name="reception_id"></td>
									</tr>
									<tr>
										<th scope="row">기술명</th>
										<td name="tech_info_name"></td>
									</tr>
									<tr>
										<th scope="row">기관명</th>
										<td name="institution_name"></td>												
									</tr>
									<tr>
										<th scope="row">검토자/평가자</th>
										<td name="steward"></td>	
									</tr>
									<tr>
										<th scope="row">평가일</th>
										<td name="evaluation_date"></td>	
									</tr>
								</tbody>
							</table>								
							<!--//개별평가-->
						
							<!--평가 점수 항목-->
							<div id="a_type_div">
								<h4>평가 점수 항목</h4>								
								<table class="list fixed score_tabel">
									<caption>평가 점수 항목</caption>
									<colgroup>
										<col style="width:20%" />
										<col style="width:60%" />
										<col style="width:10%" />
										<col style="width:10%" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col" class="first">평가항목(배점)</th>
											<th scope="col">평가지표</th>	
											<th scope="col">배점</th>
											<th scope="col" class="last">점수</th>
										</tr>
									</thead>
									<tbody id="evaluation_item_body">
									</tbody>
									<tfoot>
										<tr>												
											<td class="first sum_all_title" colspan="2">합계</td>
											<td class="all_sum_cell_1 sum_all_title" id="total_limit_point"></td>	
											<td class="all_sum_cell_2 sum_all_title">
												<label for="total_input_point" class="hidden">합계</label>
												<input type="text" class="form-control w75 ls number_t fl" maxlength="3" id="total_input_point" disabled  />
												<span class="ml5 m5 fl">점</span>
											</td>					
										</tr>
									</tfoot>
								</table>	
							</div>
							
							<div id="b_type_div" style="display:none">
								<!--평가 의견 항목-->
								<h4>평가 의견 항목</h4>								
								<table class="list fixed score_tabel">
									<caption>평가 의견 항목</caption>
									<colgroup>
										<col style="width:20%" />
										<col style="width:20%" />
										<col style="width:60%" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col" class="first">검토항목</th>												
											<th scope="col">검토사항</th>
											<th scope="col" class="last">검토의견</th>
										</tr>
									</thead>
									<tbody id="b_type_evaluation_item_body">
									</tbody>
								</table>	
							</div>
							<!--사인-->
							<!--<div class="txt">
								<div class="sign claerfix mt30" style="height: 130px;">																	
									<div class="sigPad mb30" id="linear" style="width:304px">										
										<div class="clearButton mb5">														
											<button type="button" class="gray_btn clear_btn fr">지우기</button>
										</div>									
										<div class="sign sigWrapper" style="height:auto;border: 1px solid #d1d1d1;">										
											<canvas class="pad" width="300" height="80" id="downloadImage"></canvas>	
											
											<span class="sign_txt2">서명</span>
										</div>											
									</div>											
									<div class="sign_img_box">
										<img src="../images/sub/expert_new_img.png"  alt="" />
									</div>									
								</div>
							</div>-->
							<!--사인-->

							<!--//평가 점수 항목-->
							<!--<div class="clearfix w100">
								<button type="button" class="blue_btn receipt_sign_re_btn ml5 fr" style="display:none">서명 수정</button>										
								<button type="button" class="gray_btn2 ml5 fr sign_search_btn">서명 불러오기</button>
								<button type="button" class="blue_btn receipt_sign_save_btn fr" id="save" >서명 저장하기</button>
								
							</div>-->
							<div class="sign_info_txt mt10 ta_c">
								<p><span class="font_blue">서명</span>을 <span class="fw_b">완료</span> 하셔야 <span class="font_blue">제출하기</span>가 가능합니다.</p>
							</div>
								
							<div class="button_box clearfix fr pb20 list_btn mt30 rating_btn_hide">										
								<button type="button" class="blue_btn2 fl mr5 openLayer5 hide_sign" onclick="registrationEvalutionResultItem(1);">임시저장</button>			
								<button type="button" class="blue_btn fl mr5 hide_sign" onclick="signEvaluation();">서명</button>
								<button type="button" class="gray_btn fl" onclick="location.href='/manager/fwd/evaluation/main'">목록</button>
							</div>
							
							<button type="submit" class="blue_btn send_rating mt30 fr mb5" style="display:none;" >제출</button>										
						</div>									
					</div>
					<!--//평가 위원-->

					<!--평가 위원장-->
					<div class="table_area rating_leader_tabel_area">
						<div class="table_area">
							<!--개별평가-->
							<table class="write fixed">
								<caption>평가서 구분</caption>
								<colgroup>
									<col style="width: 20%;">																		
									<col style="width: 80%;">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">평가서 구분</th>
										<td><span>종합평가서</span></td>	
									</tr>									  
									<tr>
										<th scope="row">접수번호</th>
										<td name="reception_id"><span>A2021001</span></td>
									</tr>
									<tr>
										<th scope="row">기술명</th>
										<td name="tech_info_name"><span>기술명</span></td>
									</tr>
									<tr>
										<th scope="row">기관명</th>
										<td name="institution_name"><span>㈜이노싱크</span></td>												
									</tr>
									<tr>
										<th scope="row">검토자/평가자</th>
										<td name="steward"><span>홍길동</span></td>	
									</tr>
									<tr>
										<th scope="row">평가일</th>
										<td name="evaluation_date"><span class="fl">2021</span><span class="fl">-</span><span class="fl">02</span><span class="fl">-</span><span class="fl">22</span></td>	
									</tr>
								</tbody>
							</table>								
							<!--//개별평가-->

							<!--종합 점수-->
							<h4>종합 점수</h4>								
							<table class="list fixed opinion_tabel">
								<caption>종합 점수</caption>
								<colgroup>
									<col style="width:10%" />
									<col style="width:6%" />
									<col style="width:6%" />
									<col style="width:6%" />
									<col style="width:6%" />
									<col style="width:6%" />
									<col style="width:6%" />
									<col style="width:6%" />
									<col style="width:6%" />
									<col style="width:6%" />
									<col style="width:6%" />
									<col style="width:10%" />
									<col style="width:10%" />	
								</colgroup>
								<thead>
									<tr>
										<th scope="col" rowspan="2" class="first" id="commissioner_count"></th>	
										<th scope="col" colspan="11">평가 점수</th>												
										<th scope="col" rowspan="2" class="last">서명</th>
									</tr>										
									<tr>
										<th scope="col" class="first">A</th>
										<th scope="col">B</th>
										<th scope="col">C</th>
										<th scope="col">D</th>
										<th scope="col">E</th>
										<th scope="col">F</th>
										<th scope="col">G</th>
										<th scope="col">H</th>
										<th scope="col">I</th>
										<th scope="col">J</th>												
										<th scope="col" class="last">점수</th>													
									</tr>
								</thead>
								<tbody id="commissioner_evaluation_list">
									
								</tbody>
								<tfoot>											
									<tr>
										<td class="first td_c2" colspan="2">최종결과</td>												
										<td class="last total_score" colspan="11">													
											<input type="radio" id="rating_score_type_congruence" name="rating_score_type" />
											<label for="rating_score_type_congruence" class="font_blue mr20">적합</label>
											<input type="radio" id="rating_score_type_incongruity" name="rating_score_type" />
											<label for="rating_score_type_incongruity" class="font_red">부적합</label>													
										</td>		
									</tr>
								</tfoot>
							</table>	
							<!--//평가 의견 항목-->	

							<!--의결 사항-->
							<table class="write fixed mt30">
								<caption>의결 사항</caption>
								<colgroup>
									<col style="width: 20%;">																		
									<col style="width: 80%;">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="ta_c"><label for="opinion">의결 결과 및 종합의견</label></th>
										<td><textarea rows="10" class="w100" id="opinion"></textarea></td>	
									</tr>											
								</tbody>
							</table>
							<!--//의결 사항-->
							<!--사인-->
							<!--<div class="txt">
								
								<div class="sign claerfix mt30" style="height: 130px;">																		
									<div class="sigPad mb30" id="linear2" style="width:304px">									
										<div class="clearButton mb5">														
											<button type="button" class="gray_btn clear_btn fr">지우기</button>
										</div>									
										<div class="sign sigWrapper" style="height:auto;border: 1px solid #d1d1d1;">										
											<canvas class="pad2" width="300" height="80" id="downloadImage2"></canvas>													
											<span class="sign_txt2">서명</span>
										</div>											
									</div>											
									<div class="sign_img_box">
										<img src="../images/sub/expert_new_img.png"  alt="서명이미지" />
									</div>
									
								
								</div>
								
							</div>--><!--//사인-->
							<!--//평가 점수 항목-->
							<div class="sign_info_txt mt10 ta_c">
								<p><span class="font_blue">서명</span>을 <span class="fw_b">완료</span> 하셔야 <span class="font_blue">제출하기</span>가 가능합니다.</p>
							</div>				
													
							<div class="button_box clearfix fr pb20 list_btn leader_btn_hide">									
								<button type="button" class="blue_btn2 fl mr5" onclick="chairmanRegistrationEvalutionResultItem();">임시저장</button>						
								<button type="button" class="blue_btn fl mr5" onclick="chairmanSignEvaluation();">서명</button>	
								<button type="button" class="gray_btn fl" onclick="location.href='/manager/fwd/evaluation/main'">목록</button>
							</div>
						</div>
						
						<button type="button" class="blue_btn send_leader mt30 fr mb5" style="display:none;">제출</button>
					</div>								
					<!--//평가 위원장-->	
					<div class="list_back clearfix mt50 list_back_btn">
						<button type="button" class="gray_btn fr" onclick="location.href='/manager/fwd/evaluation/main'">목록</button>
					</div>
				</div><!--//content_area-->
			<!--//평가 과제-->
			</div>
		</div><!--//sub_contents-->
	</section>
</div>
 
 
<!--임시저장 팝업-->
<div class="save_popup2_box">		
	<div class="popup_bg"></div>
	<div class="save_popup2_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">임시저장 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="font_blue">임시저장</span> 되었습니다.</p>
		    <div class="popup_button_area_center">
				<button type="button" class="gray_btn popup_close_btn">닫기</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//임시저장 팝업-->			

<!--평가위원 제출 안내 팝업-->
<div class="send_save_popup_box">		
	<div class="popup_bg"></div>
	<div class="send_save_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">제출 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="fw_b">제출 후에는 수정이 불가합니다.</span><br /><span class="font_blue">제출</span> 하시겠습니까?</p>
		    <div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn" onclick="submitEvaluation();">제출</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//평가위원 안내 팝업-->	

<!--평가위원장 제출 안내 팝업-->
<div class="leader_send_save_popup_box">		
	<div class="popup_bg"></div>
	<div class="leader_send_save_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">제출 안내</h4>
            <a href="javascript:void(0)" title="닫기" class="white_font close_btn logout_popup_close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
		</div>					
		<div class="popup_txt_area">
			<p tabindex="0"><span class="fw_b">제출 후에는 수정이 불가합니다.</span><br /><span class="font_blue">제출</span> 하시겠습니까?</p>
		    <div class="popup_button_area_center">
				<button type="submit" class="blue_btn popup_close_btn send_save_ok_btn">제출</button>
			</div>	
		</div>									
	</div> 
</div>
<!--//평가위원장 안내 팝업-->


<!--공통 팝업-->
<div class="common_popup_box">
	<div class="popup_bg"></div>
	<div class="id_check_info_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl" id="popup_title"></h4>
			<a href="javascript:void(0)" id="common_popup_close_btn" title="닫기" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i><span class="hidden">닫기</span></a>
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
