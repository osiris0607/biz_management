<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	$(document).ready(function() {

		$("#today_check").click(function(){
			// 오늘이 선택되면 from / to 를 지운다.
			if ( $("#today_check").is(":checked") ) {
				$("#evaluation_from").val('');
				$("#evaluation_to").val('');
			}
		});

	 	$("#classification_selector").change(function(){
	 		classificationSelectorChange( $(this).val());
		});


	 	displayMain();
		initUpdateEvaluationInfo();
		searchList(1);
	});

	
	/*******************************************************************************
	* FUNCTION 명 : displayMain
	* FUNCTION 기능설명 : announcement_type과 classification에 따라서 달라지는 화면을 그린다.
	*******************************************************************************/
	function displayMain() {
		if ( "${vo.announcement_type}" == "D0000005" ) {
			$("#left_menu_match").addClass("active");
			$(".location_name").text("기술매칭");
		} else if ( "${vo.announcement_type}" == "D0000004" ) {
			$("#left_menu_proposal").addClass("active");
			$(".location_name").text("기술재안");
			$("#li_evaluation_match").hide();
		} else if ( "${vo.announcement_type}" == "D0000003" ) {
			$("#left_menu_contest").addClass("active");
			$(".location_name").text("기술공모");
			$("#li_evaluation_match").hide();
		}

		// 평가전
		if ( "${vo.classification}" == "D0000005") {
			$(".li_status").removeClass("current");
			$("#status_before").addClass("current");
			$("#li_evaluation_gubun").hide();
			$("#li_evaluation_type").hide();
			$("#li_evaluation_status").hide();
			$("#li_evaluation_result").hide();
			$("#2nd_regist_btn").hide();
			$("#3th_regist_btn").hide();
		}
		// 사전검토
		if ( "${vo.classification}" == "D0000004") {
			$(".li_status").removeClass("current");
			$("#status_preview").addClass("current");
			$("#li_evaluation_gubun").hide();
			$("#li_evaluation_type").hide();
		}
		// 선정평가
		if ( "${vo.classification}" == "D0000001") {
			$(".li_status").removeClass("current");
			$("#status_first").addClass("current");
			$("#li_evaluation_gubun").hide();
		}
		// 중간평가
		if ( "${vo.classification}" == "D0000002") {
			$(".li_status").removeClass("current");
			$("#status_middle").addClass("current");
			$("#li_evaluation_gubun").hide();
		}
		// 최종평가
		if ( "${vo.classification}" == "D0000003") {
			$(".li_status").removeClass("current");
			$("#status_final").addClass("current");
			$("#li_evaluation_gubun").hide();
		}
		// 최종평가
		if ( "${vo.classification}" == "D0000003") {
			$(".li_status").removeClass("current");
			$("#status_final").addClass("current");
			$("#li_evaluation_gubun").hide();
		}
		// 전체보기
		if ( gfn_isNull("${vo.classification}") ) {
			$(".li_status").removeClass("current");
			$("#status_total").addClass("current");
		}
	}
	
	function initUpdateEvaluationInfo(){
		$("#classification_selector").empty();
		$("#type_selector").empty();

		var str;
	   	<c:forEach items="${commonCode}" var="code">
		   	<c:if test="${code.master_id == 'M0000016'}">
		   		<c:if test="${code.detail_id != 'D0000005'}">
					str += '<option value="${code.detail_id}">${code.name}</option>';
				</c:if>
			</c:if>
		</c:forEach>
		$("#classification_selector").append(str);

		var typeStr = "";
		typeStr += '<option value="D0000001">서면평가</option>';
		typeStr += '<option value="D0000002">발표평가</option>';
		$("#type_selector").append(typeStr);
	}
	function classificationSelectorChange(category) {
		var str = "";
		$("#type_selector").empty();
		str += '<option value="D0000001">서면평가</option>';
		str += '<option value="D0000002">발표평가</option>';
		$("#type_selector").append(str);
	}
	
	function searchList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/evaluation/match/search/paging' />");
		comAjax.setCallback(searchListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "EVALUATION_REG_NUMBER");

		var announcementType = "${vo.announcement_type}";
		if ( "${vo.announcement_type}" == "D0000005" ) {
			if ( $("#match_type_consulting").is(":checked") && $("#match_type_rnd").is(":checked") == false ) {
				announcementType = $("#match_type_consulting").val();
			}
			if ( $("#match_type_consulting").is(":checked") == false && $("#match_type_rnd").is(":checked") ) {
				announcementType = $("#match_type_rnd").val();
			}
		}
		comAjax.addParam("announcement_type", announcementType);

		var classificationList = new Array();

		if(gfn_isNull("${vo.classification}") ) {
			$("input:checkbox[name='evaluation_classification']:checked").each(function (index) {
				classificationList.push( $(this).val());
		    });
		} else {
			classificationList.push("${vo.classification}");
		}
		comAjax.addParam("classification_list", classificationList);

		var typeList = new Array();
		$("input:checkbox[name='evaluation_type']:checked").each(function (index) {
			typeList.push( $(this).val());
	    });
		comAjax.addParam("type_list", typeList);

		var statusList = new Array();
		$("input:checkbox[name='evaluation_status']:checked").each(function (index) {
			statusList.push( $(this).val());
	    });
		comAjax.addParam("status_list", statusList);

		var resultList = new Array();
		$("input:checkbox[name='evaluation_result']:checked").each(function (index) {
			resultList.push( $(this).val());
	    });
		comAjax.addParam("result_list", resultList);

		comAjax.addParam("search_text", $("#search_text").val());
		if (  $("#today_check").is(":checked") ) {
			const now = new Date();
			var year = now.getFullYear();
		    var month = now.getMonth() + 1;    //1월이 0으로 되기때문에 +1을 함.
		    var date = now.getDate();
		    month = month >=10 ? month : "0" + month;
		    date  = date  >= 10 ? date : "0" + date;
		  	var today =  year + "-" + month + "-" + date;
		    
			comAjax.addParam("evaluation_from", today);
			comAjax.addParam("evaluation_to", today);
		} else {
			if ( gfn_isNull($("#evaluation_from").val()) == true && gfn_isNull($("#evaluation_to").val()) == false ) {
				alert("시작 접수일과 종료 접수일을 같이 선택해 주시기 바랍니다.");
				return;
			}
			if ( gfn_isNull($("#evaluation_from").val()) == false && gfn_isNull($("#evaluation_to").val()) == true) {
				alert("시작 접수일과 종료 접수일을 같이 선택해 주시기 바랍니다.");
				return;
			}
			if ( gfn_isNull($("#evaluation_from").val()) == false && gfn_isNull($("#evaluation_to").val()) == false) {
				if ( $("#evaluation_from").val() > $("#evaluation_to").val()) {
					alert("시작 접수일이 종료 접수일보다 앞선 날짜 입니다. 다시 선택해 주시기 바랍니다.");
					return;
				}
			}
			comAjax.addParam("evaluation_from", $("#evaluation_from").val());
			comAjax.addParam("evaluation_to", $("#evaluation_to").val());
		}
		
		comAjax.ajax();
	}

	var evaluationNumberList = new Array();
	function searchListCB(data) {
		console.log(data);
		var total = data.totalCount;
		var body = $("#list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='14'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			$("#pageIndex").empty();
		} else {
			var params = {
					divId : "pageNavi",
					pageIndex : "pageIndex",
					totalCount : total,
					eventName : "searchList"
				};
	
			gfnRenderPaging(params);
			
			$("#search_count").html("[총 <span class='font_blue'>" + total + "</span>건]");
			var managerList = [];
			var index = 1;
			var str = "";
			$.each(data.result_data, function(key, value) {
				// 검색 시 삭제 Select List를 만들기 위해 중복 데이터를 제거한다.
				if(gfn_isNull(value.evaluation_reg_number) == false && evaluationNumberList.indexOf(value.evaluation_reg_number) == -1 ){
					evaluationNumberList.push(value.evaluation_reg_number);
				}
				
				str += "<tr>";
				str += "	<td class='check'>";
				// 평가번호 할당 전후 상태
				if (gfn_isNull(value.evaluation_reg_number) ) {
					// 평가일 할당 전후 상태
					if (gfn_isNull(value.evaluation_date) ) {
						str += "	<input onclick='clickEvaluationCkeckBox(this);' id='checkbox_" + index + "' name='data_checkbox' status='" + value.status +
									"' evaluation_date_yn='N' reg_number_yn='N' type='checkbox' value='" + value.evaluation_id +  "' chairman_yn='" + value.chairman_yn +
									"' send_email_yn='" + value.send_email_yn + "' commissioner_yn='" + value.commissioner_yn + "' item_complete_yn='" + value.item_complete_yn + "'  />";
						str += "	<label for='checkbox_" + index + "'>&nbsp;</label>";
					} else {
						str += "	<input onclick='clickEvaluationCkeckBox(this);' id='checkbox_" + index + "' name='data_checkbox' status='" + value.status +
									"' evaluation_date_yn='Y' reg_number_yn='N' type='checkbox' value='" + value.evaluation_id + "' chairman_yn='" + value.chairman_yn +
									"' send_email_yn='" + value.send_email_yn + "' commissioner_yn='" + value.commissioner_yn + "' item_complete_yn='" + value.item_complete_yn + "'  />";
						str += "	<label for='checkbox_" + index + "'>&nbsp;</label>";
					}
				} else {
					if (gfn_isNull(value.evaluation_date) ) {
						str += "	<input onclick='clickEvaluationCkeckBox(this);' id='checkbox_" + index + "' name='data_checkbox' status='" + value.status +
									"' evaluation_date_yn='N' reg_number='" + value.evaluation_reg_number + "' chairman_yn='" + value.chairman_yn +
									"' reg_number_yn='Y' type='checkbox' value='" + value.evaluation_id + 
									"' send_email_yn='" + value.send_email_yn + "' commissioner_yn='" + value.commissioner_yn + "' item_complete_yn='" + value.item_complete_yn + "'  />";
						str += "	<label for='checkbox_" + index + "'>&nbsp;</label>";
					} else {
						str += "	<input onclick='clickEvaluationCkeckBox(this);' id='checkbox_" + index + "' name='data_checkbox' status='" + value.status +
									"' evaluation_date_yn='Y' reg_number='" + value.evaluation_reg_number + "' chairman_yn='" + value.chairman_yn +
									"' reg_number_yn='Y' type='checkbox' value='" + value.evaluation_id + 
									"' send_email_yn='" + value.send_email_yn + "' commissioner_yn='" + value.commissioner_yn + "' item_complete_yn='" + value.item_complete_yn + "'  />";
						str += "	<label for='checkbox_" + index + "'>&nbsp;</label>";
					}
				}
				
				str += "	</td>";
				str += "	<td>"+ value.reception_reg_number + "</td>";
				str += "	<td class='rating_number'><span>" + value.agreement_reg_number + "</span></td>";
				str += "	<td><span>" + value.evaluation_reg_number + "</span></td>";
				str += "	<td><span class='long_name'>" + value.announcement_title  + "</span></td>";
				str += "	<td><span class='long_name'>" + value.tech_info_name  + "</span></td>";
				str += "	<td><span class='long_name'>" + value.institution_name  + "</span></td>";
				str += "	<td><span class='long_name'>" + value.steward_department  + "</span></td>";
				str += "	<td><span class='long_name'>" + value.steward  + "</span></td>";
				str += "	<td><span class='long_name'>" + value.classification_name  + "</span></td>";
				str += "	<td><span class='long_name'>" + value.type_name  + "</span></td>";
				str += "	<td><span class='long_name'>" + value.evaluation_date  + "</span></td>";
				str += "	<td><span class='long_name'>" + value.result_name  + "</span></td>";
				str += "	<td><a href='/admin/fwd/evaluation/match/detail?evaluation_id=" + value.evaluation_id + "&announcement_type=" + "${vo.announcement_type}" + "&classification=" + "${vo.classification}" + "'><div class='txt_hidden'>" + value.status_name + "</div></a></td>";
				str += "</tr>";
	
				index++;
			});
			body.append(str);

			// 관리번호 해제 List
			$("#clear_evaluation_number_selector").empty();
			str = "";
			$.each(evaluationNumberList, function(key, value) {
				str += "<option value='" + value + "'>" + value +"</option>";
			});
			$("#clear_evaluation_number_selector").append(str);
		}
	}

	function clickEvaluationCkeckBox(element) {
		if ( $(element).prop("checked") ) {
			if ( $(element).attr("reg_number_yn") == "Y" ){
				$("input:checkbox[name='data_checkbox']").each(function (index) {
					if ( $(this).attr("reg_number_yn") == "Y" && $(this).attr("reg_number") == $(element).attr("reg_number") ) {
						$(this).prop("checked", true);
					}
				});
			}
		} 
		else {
			$(this).prop("checked", false);
			/* if ( $(element).attr("reg_number_yn") == "Y" ){
				$("input:checkbox[name='data_checkbox']").each(function (index) {
					if ( $(this).attr("reg_number_yn") == "Y" && $(this).attr("reg_number") == $(element).attr("reg_number") ) {
						$(this).prop("checked", false);
					}
				});
			} */
		}
	}

	function createEvalutionRegNumber() {
		if ( $("input:checkbox[name='data_checkbox']:checked").length <=0 ) {
			alert("하나 이상의 평가 데이터를 선택하여야 합니다.");
			return;
		}

		var isOK = true;
		var regEvaluationIDList = new Array();
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			if ( $(this).attr("reg_number_yn") == "Y" ) {
				alert("이미 생성된 평가번호가 있는 목록이 포함되어 있습니다.");
				isOK = false;
				return false;
			}
			regEvaluationIDList.push( $(this).val() );
		});

		if ( isOK == false) {
			return;
		}

		var formData = new FormData();
		formData.append("craete_evaluation_number_list", regEvaluationIDList);
		formData.append("announcement_type", "D0000005");
		
		$.ajax({
		    type : "POST",
		    url : "/admin/api/evaluation/match/create/evaluationNumber",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == 1) {
		            alert("생성 되었습니다.");
		            location.reload();
		        } else {
		            alert("생성에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	function prepareClearEvaluationNumber() {
		if ( $("input:checkbox[name='data_checkbox']:checked").length <=0 ) {
			alert("하나 이상의 평가 데이터를 선택하여야 합니다.");
			return;
		}

		var isOK = true;
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			var temp = $(this).attr("status");
			if ( $(this).attr("status") == "D0000003" || $(this).attr("status") == "D0000004" || $(this).attr("status") == "D0000005" ) {
				alert("평가대기/평가중/평가완료 시에는 평가 그룹을 해제할 수 없습니다.");
				isOK = false;
				return false;
			}
		});
		if (isOK == false) {
			return;
		}
		
		var regEvaluationIDList = new Array();
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			if ( $(this).attr("reg_number_yn") == "N" ) {
				alert("평가번호가 생성된 데이터를 선택해야 합니다.");
				isOK = false;
				return false;
			} else {
				regEvaluationIDList.push( $(this).attr("reg_number") );
			}
		});
		if (isOK == false) {
			return;
		}

		// 하나의 평가그룹만 선택 가능하다.
		var filterList = Array.from(new Set(regEvaluationIDList));
		if (filterList.length != 1 ) {
			alert("하나의 평가그룹만 선택해야 합니다.");
			return;
		}

		if(confirm("평가그룹을 해제하시겠습니까?"))
	 	{
			var formData = new FormData();
			formData.append("evaluation_reg_number", filterList[0]);
			
			$.ajax({
			    type : "POST",
			    url : "/admin/api/evaluation/match/clear/evaluationNumber",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == 1) {
			            alert("해제 되었습니다.");
			            location.reload();
			        } else {
			            alert("해제에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
	 	}
	}

	var updateEvaluationNumberList = new Array();
	function prepareUpdateEvaluationInfo() {
		if ( $("input:checkbox[name='data_checkbox']:checked").length <=0 ) {
			alert("하나 이상의 평가 데이터를 선택하여야 합니다.");
			return;
		}

		var isOK = true;
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			if ( $(this).attr("reg_number_yn") == "N" ) {
				alert("평가번호가 없는 목록이 포함되어 있습니다.");
				isOK = false;
				return;
			}
		});
		if ( isOK == false) {
			return;
		}

		isOK = true;
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			if ( $(this).attr("evaluation_date_yn") == "Y" ) {
				alert("이미 평가일자가 등록된 목록이 포함되어 있습니다.");
				isOK = false;
				return;
			}

			updateEvaluationNumberList.push($(this).val());
		});
		if ( isOK == false) {
			return;
		}

		$('.rating_day_popup_box').fadeIn(350);
	}

	function updateEvaluationInfo() {
		if ( gfn_isNull($("#join_datepicker1").val()) ) {
			alert("평가일을 선택하야야 합니다.");
			return
		}
		
		var formData = new FormData();
		formData.append("update_evaluation_number_list", updateEvaluationNumberList);
		formData.append("type", $("#type_selector").val() );
		formData.append("classification", $("#classification_selector").val() );
		formData.append("evaluation_date", $("#join_datepicker1").val() );
		
		$.ajax({
		    type : "POST",
		    url : "/admin/api/evaluation/match/update",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		            alert("등록 되었습니다.");
		            location.reload();
		        } else {
		            alert("등록에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}


	function registEvaluator() {
		if ( $("input:checkbox[name='data_checkbox']:checked").length <=0 ) {
			alert("하나 이상의 평가 데이터를 선택하여야 합니다.");
			return;
		}
		var isOK = true;
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			var temp = $(this).attr("status");
			if ( $(this).attr("status") == "D0000003" || $(this).attr("status") == "D0000004" || $(this).attr("status") == "D0000005" ) {
				alert("평가대기/평가중/평가완료 시에는 평가 위원을 등록할 수 없습니다.");
				isOK = false;
				return false;
			}
		});
		
		var evaluationIDList = new Array();
		var isFirst = true;
		var sendEmailYN = false;
		var previousRegNumber = "";
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			if ( $(this).attr("status") == "D0000001" ) {
				alert("평가준비가 안된 목록이 포함되어 있습니다. 평가번호/평가구분/평가일자를 등록해 주시기 바랍니다.");
				isOK = false;
				return false;
			}

			if ( $(this).attr("item_complete_yn") != "Y" ) {
				alert("평가양식을 먼저 등록해 주시기 바랍니다.");
				isOK = false;
				return false;
			}

			if ( $(this).attr("send_email_yn") == "Y" ) {
				sendEmailYN = true;
			}


			if (isFirst) {
				previousRegNumber = $(this).attr("reg_number");
				evaluationIDList.push($(this).val());
				isFirst= false;
			} else {
				evaluationIDList.push($(this).val());
				if ( previousRegNumber != $(this).attr("reg_number") ) {
					alert("복수의 평가그룹을 선택할 수 없습니다.");
					isOK = false;
					return false;
				}
			}
		});
		if ( isOK == false) {
			return;
		}

		if ( sendEmailYN ) {
			if ( confirm("이미 평가위원에게 선정 의향 메일을 전송했습니다. 평가위원 선정 페이지로 이동하시겠습니까?") ) {
				location.href="/admin/fwd/evaluation/match/commissioner/registComplete?evaluation_reg_number=" + previousRegNumber +
							  "&announcement_type=" + "${vo.announcement_type}" + "&classification=" + "${vo.classification}";
			} else {
				location.href="/admin/fwd/evaluation/match/commissioner/regist?evaluation_reg_number=" + previousRegNumber + 
				"&update_evaluation_number_list=" + evaluationIDList + "&announcement_type=" + '${vo.announcement_type}' + "&classification=" + '${vo.classification}';
			}
		} else {
			location.href="/admin/fwd/evaluation/match/commissioner/regist?evaluation_reg_number=" + previousRegNumber + 
			"&update_evaluation_number_list=" + evaluationIDList + "&announcement_type=" + '${vo.announcement_type}' + "&classification=" + '${vo.classification}';
		}
	}

	function moveEvaluationItem(){
		if ( $("input:checkbox[name='data_checkbox']:checked").length <=0 ) {
			alert("하나 이상의 평가 데이터를 선택하여야 합니다.");
			return;
		}

		var isOK = true;
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			var temp = $(this).attr("status");
			if ( $(this).attr("status") == "D0000003" || $(this).attr("status") == "D0000004" || $(this).attr("status") == "D0000005" ) {
				alert("평가대기/평가중/평가완료 시에는 평가 양식을 등록할 수 없습니다.");
				isOK = false;
				return false;
			}
		});
		
		var evaluationIDList = new Array();
		var isFirst = true;
		var previousRegNumber = "";
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			if ( $(this).attr("status") == "D0000001" ) {
				alert("평가준비가 안된 목록이 포함되어 있습니다. 평가번호/평가구분/평가일자를 등록해 주시기 바랍니다.");
				isOK = false;
				return false;
			}

			if (isFirst) {
				previousRegNumber = $(this).attr("reg_number");
				evaluationIDList.push($(this).val());
				isFirst= false;
			} else {
				evaluationIDList.push($(this).val());
				if ( previousRegNumber != $(this).attr("reg_number") ) {
					alert("복수의 평가그룹을 선택할 수 없습니다.");
					isOK = false;
					return false;
				}
			}
		});
		if ( isOK == false) {
			return;
		}

		location.href="/admin/fwd/evaluation/match/item/registration?update_evaluation_number_list=" + evaluationIDList +
					  "&announcement_type=" + '${vo.announcement_type}' + "&classification=" + '${vo.classification}';

	}

	function startEvaluation() {
		if ( $("input:checkbox[name='data_checkbox']:checked").length <=0 ) {
			alert("하나 이상의 평가 데이터를 선택하여야 합니다.");
			return;
		}

		var isOK = true;
		var isFirst = true;
		var previousRegNumber = "";
		var evaluationRegNumberList = new Array();
		$("input:checkbox[name='data_checkbox']:checked").each(function (index) {
			if ( $(this).attr("status") == "D0000001" ) {
				alert("평가준비가 안된 목록이 포함되어 있습니다. 평가번호/평가구분/평가일자를 등록해 주시기 바랍니다.");
				isOK = false;
				return false;
			}

			if ( $(this).attr("status") == "D0000002" ) {
				alert("평가대기가 안된 목록이 포함되어 있습니다. 평가위원/평가양식을 등록해 주시기 바랍니다.");
				isOK = false;
				return false;
			}

			if ( $(this).attr("chairman_yn") == "N" ) {
				alert("평가위원장이 선정되지 않는 평가 항목이 있습니다. 상세 보기에서 평가위원장을 선정해 주시기 바랍니다.");
				isOK = false;
				return false;
			}

			if ( previousRegNumber != $(this).attr("reg_number") ) {
				evaluationRegNumberList.push($(this).attr("reg_number"));
				previousRegNumber = $(this).attr("reg_number");
			}
		});

		if ( isOK == false) {
			return;
		}
		
		var formData = new FormData();
		formData.append("update_evaluation_reg_number_list", evaluationRegNumberList);
		formData.append("evaluation_status", "D0000004");
		
		$.ajax({
		    type : "POST",
		    url : "/admin/fwd/evaluation/match/update/status",
		    data : formData,
		    processData: false,
		    contentType: false,
		    mimeType: 'multipart/form-data',
		    success : function(data) {
		    	var jsonData = JSON.parse(data);
		        if (jsonData.result == true) {
		            alert("평가 시작 되었습니다.");
		            location.reload();
		        } else {
		            alert("평가 시작에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
		        }
		    },
		    error : function(err) {
		        alert(err.status);
		    }
		});
	}

	/*******************************************************************************
	* FUNCTION 명 : onMoveEvaluationPage
	* FUNCTION 기능설명 : 평가관리 사이트로 이동한다. (기술매칭/기술공모/기술제안 별 평가전/사전검토/선정평가/중간평가/최종평가/전체보기)
	*******************************************************************************/
	function onMoveEvaluationPage(evaluationType, evaluationClassification){
		// 기술매칭/기술공모/기술제안은 URL로 구분
		// 평가전/사전검토/선정평가/중간평가/최종평가/전체보기는 공통코드로 구분
		location.href = "/admin/fwd/evaluation/main?announcement_type=" + evaluationType + "&classification="  + evaluationClassification;
	}


	function downloadExcelFile() {
		if (confirm('다운로드하시겠습니까?')) {
			location.href = "/admin/api/evaluation/excelDownload?announcement_type=${vo.announcement_type}";
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
			       <h2 class="title">평가관리</h2>
			   </div>
                <!--// 레프트 메뉴 서브 타이틀 -->					   
			   <div class="lnb_menu_area">	
			       <ul class="lnb_menu">
				       <li class="on"><a href="javascript:void(0)" title="평가관리" onclick="onMoveEvaluationPage('D0000005', 'D0000005');">평가관리</a></li>
					   <li class="menu2depth">
						   <ul>
							   <li id="left_menu_match"><a href="javascript:void(0)" onclick="onMoveEvaluationPage('D0000005', 'D0000005');">기술매칭</a></li>
							   <li id="left_menu_contest"><a href="javascript:void(0)" onclick="onMoveEvaluationPage('D0000003', 'D0000005');">기술공모</a></li>
							   <li id="left_menu_proposal"><a href="javascript:void(0)" onclick="onMoveEvaluationPage('D0000004', 'D0000005');">기술제안</a></li>
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
				       <li><a href="/admin/fwd/home/main"><i class="nav-icon fa fa-home"></i></a></li>
					   <li>평가관리</li>
					   <li><strong class="location_name">기술매칭</strong></li>
				   </ul>	
				  <!--//페이지 경로-->
				  <!--페이지타이틀-->
				   <h3 class="title_area location_name">기술매칭</h3>
				  <!--//페이지타이틀-->
			   </div>
		   </div>
					   
           	<div class="contents_view">
				<div class="list_link">
					<!--접수 탭-->
					<ul class="list_tabBox">
						<li id="status_before" class="li_status"><a href="javascript:void(0)" onclick="onMoveEvaluationPage('${vo.announcement_type}', 'D0000005');">평가전</a></li>
						<li id="status_preview" class="li_status"><a href="javascript:void(0)" onclick="onMoveEvaluationPage('${vo.announcement_type}', 'D0000004');">사전검토</a></li>
						<li id="status_first" class="li_status"><a href="javascript:void(0)" onclick="onMoveEvaluationPage('${vo.announcement_type}', 'D0000001');">선정평가</a></li>
						<li id="status_middle" class="li_status"><a href="javascript:void(0)" onclick="onMoveEvaluationPage('${vo.announcement_type}', 'D0000002');">중간평가</a></li>
						<li id="status_final" class="li_status"><a href="javascript:void(0)" onclick="onMoveEvaluationPage('${vo.announcement_type}', 'D0000003');">최종평가</a></li>
						<li id="status_total" class="li_status"><a href="javascript:void(0)" onclick="onMoveEvaluationPage('${vo.announcement_type}', '');">전체보기</a></li>
					</ul>
					<!--//접수 탭-->
				
					<div class="estimation_before">
						<div class="list_search_top_area">							   
					    <ul class="clearfix list_search_top2 rating_list">
						    <li class="clearfix" id="li_evaluation_match">
								<label class="fl business_type ta_r w_8">기술매칭</label>										
								<div class="ml20 business_type_area fl clearfix">
									<input id="match_type_consulting" class="allCheck fl" type="checkbox" name="match_type" value="D0000001" />
									<label for="match_type_consulting" class="fl">기술컨설팅</label>									
									<input id="match_type_rnd" class="allCheck fl" type="checkbox" name="match_type" value="D0000002"  />
									<label for="match_type_rnd" class="fl">기술연구개발</label>
								</div>
						    </li>
						    <li class="clearfix" id="li_evaluation_gubun">
								<label class="fl rating ta_r w_8">평가구분</label>										
								<div class="ml10 fl clearfix ml20">
									<input id="classification_preview" type="checkbox" name="evaluation_classification" value="D0000004"/>
									<label for="classification_preview">사전검토</label>
									<input id="classification_frist" type="checkbox" name="evaluation_classification" value="D0000001"/>
									<label for="classification_frist" class="mr10">선정평가</label>
									<input id="classification_middle" type="checkbox" name="evaluation_classification" value="D0000002"/>
									<label for="classification_middle" class="mr10">중간평가</label>
									<input id="classification_final" type="checkbox" name="evaluation_classification" value="D0000003"/>
									<label for="classification_final">최종평가</label>
								</div>
						    </li>
							<li class="clearfix" id="li_evaluation_type">
								<label class="fl rating ta_r w_8">평가유형</label>										
								<div class="ml10 fl clearfix ml20">
									<input id="type_middle" type="checkbox" name="evaluation_type" value="D0000001"/>
									<label for="type_middle">서면평가</label>
									<input id="type_final" type="checkbox" name="evaluation_type" value="D0000002"/>
									<label for="type_final">발표평가</label>
								</div>
						    </li>
							<li class="clearfix" id="li_evaluation_status">
								<label class="fl rating ta_r w_8">평가상태</label>										
								<div class="ml20 fl clearfix">
									<input id="status_before" type="checkbox" name="evaluation_status" value="D0000001"/>
									<label for="status_before">평가 전</label>
									<input id="status_ready" type="checkbox" name="evaluation_status" value="D0000002"/>
									<label for="status_ready">평가준비</label>
									<input id="status_waiting" type="checkbox" name="evaluation_status" value="D0000003"/>
									<label for="status_waiting">평가대기</label>
									<input id="status_processing" type="checkbox" name="evaluation_status" value="D0000004"/>
									<label for="status_processing">평가중</label>
									<input id="status_complete" type="checkbox" name="evaluation_status" value="D0000005"/>
									<label for=status_complete>평가완료</label>
								</div>
						    </li>
							<li class="clearfix" id="li_evaluation_result">
								<label class="fl rating ta_r w_8">평가결과</label>										
								<div class="ml20 fl clearfix">
									<input id="result_fitness" type="checkbox" name="evaluation_result" value="D0000001"/>
									<label for="result_fitness">적합</label>
									<input id="result_incongruity" type="checkbox" name="evaluation_result" value="D0000002"/>
									<label for="result_incongruity">부적합</label>
								</div>
						    </li>
							<li class="clearfix">
								<label for="estimation_search" class="fl list_search_title ta_r w_8">검색어</label>
								<input type="text" id="search_text" class="form-control brc-on-focusd-inline-block fl list_search_word_input w60 ml20" />
							</li>
							<li class="clearfix"> 										
							    <label for="join_datepicker" class="fl rating ta_r w_8 mt5">기간</label>		
								
								<div class="ml20 fl">
									<input id="today_check" class="Check fl" type="checkbox"/>
									<label for="today_check" class="fl mt5 w_6">오늘</label>
								</div>										
								
							    <div class="datepicker_area fl clearfix">
								   <input type="text" id="evaluation_from" onclick="$('#today_check').prop('checked', false);" class="datepicker form-control w_14 fl" placeholder="시작일" />	   
							    </div>
							    <div class="datepicker_area fl clearfix ml10">
								   <input type="text" id="evaluation_to" onclick="$('#today_check').prop('checked', false);" class="datepicker form-control w_14 fl" placeholder="종료일" />		  
							    </div>
						   </li>
						</ul>
														
						<div class="list_search_btn clearfix">
							<button type="button" class="blue_btn fr" onclick="searchList(1);">조회</button>
						</div>
				    </div>
				    <!--//리스트 상단 검색-->
	
				    <!--검색 결과-->
				    <div class="list_search_table">
					    <div class="table_count_area">
						    <div class="count_area clearfix">
							    <div class="clearfix">
									<div class="fl mt5" id="search_count"></div>
									<div class="fr">											    
									    <div class="download fr"><a href="javascript:downloadExcelFile();" class="ex_down green_btn">엑셀 다운로드</a></div>					
							        </div>							   
						        </div>							   
					        </div>
					        <div style="overflow-x:auto;">
						       <table class="list th_c  checkinput_table">
							       <caption>접수 목록</caption>     
							       <colgroup>
										<col style="width: 5%;">
										<col style="width: 6%;">
										<col style="width: 6%;">
										<col style="width: 7%;">
										<col style="width: 13%;">
										<col style="width: 10%;">
										<col style="width: 7%;">
										<col style="width: 7%;">
										<col style="width: 6%;">
										<col style="width: 6%;">
										<col style="width: 6%;">
										<col style="width: 7%;">
										<col style="width: 8%;">
										<col style="width: 6%;">
								   </colgroup>
							       <thead>
								       <tr>
									       <th scope="col">&nbsp;</th>
									       <th scope="col">접수번호</th>
									       <th scope="col">과제번호</th>
										   <th scope="col">평가번호</th>
									       <th scope="col">공고명</th>
									       <th scope="col">제품/서비스명</th>
									       <th scope="col">기관명<br />(개인명)</th>
									       <th scope="col">담당간사 부서명</th>
									       <th scope="col">담당간사명</th>
									       <th scope="col">평가구분</th>
									       <th scope="col">평가유형</th>
										   <th scope="col">평가일자</th>
									       <th scope="col">평가결과</th>
									       <th scope="col">평가상태</th>
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
							
							<div class="button_area clearfix mt30 estimation_buttons">
								<div class="button_area_fl fl clearfix">											
									<button type="button" class="blue_btn2 fl" onclick="createEvalutionRegNumber();">평가번호 생성(평가그룹설정)</button>		
									<button type="button" class="blue_btn2 fl ml5" onclick="prepareClearEvaluationNumber();">평가그룹 해제</button>
									<button type="button" id="1st_regist_btn" class="gray_btn2 fl ml20" onclick="prepareUpdateEvaluationInfo();">1. 평가구분 및 평가일자 등록</button>
									<button type="button" id="2nd_regist_btn" class="gray_btn2 fl ml5" onclick="moveEvaluationItem();">2. 평가양식 등록</button>
									<button type="button" id="3th_regist_btn" class="gray_btn2 fl ml5" onclick="registEvaluator();">3. 평가위원 등록</button>
								</div>
								<div class="button_area_fr fr">
									<button type="button" class="blue_btn fl" onclick="startEvaluation();">평가시작</button>										
								</div>
							</div>
							</div>
				  	 <!--//list_search_table-->
					</div><!--contents_view-->
				</div>	
			</div>                           
		        <!--접수 목록-->
		   </div>
	   <!--//contents-->
	   </div>
     <!--//sub--> 
	</div>            
</div>
            
      <!--평가번호 생성 - 평가번호가 없을때-->
<div class="rating_group_nullproduce_popup_box">
	<div class="popup_bg"></div>
	<div class="rating_group_nullproduce_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">평가번호 생성 안내</h4>
			<a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		</div>
		<div class="popup_txt_area">
			<p>평가그룹을 설정했습니다.<br />평가 번호는 <span class="font_blue">A1234567</span> 입니다.</p>
			<div class="popup_button_area_center">
				<button type="submit" class="blue_btn popup_close_btn">확인</button>
			</div>
		</div>
	</div>
</div>
   <!--//평가번호 생성 - 평가번호가 없을때-->

<!--평가번호 생성 - 평가번호가 있을때-->		
<div class="rating_group_okproduce_popup_box">
	<div class="popup_bg"></div>
	<div class="rating_group_okproduce_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">평가번호 생성 안내</h4>
			<a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		</div>
		<div class="popup_txt_area">
			<p>이미 평가그룹이 등록된 목록이 포함되어 있습니다.</p>
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn">확인</button>
			</div>
		</div>
	</div>
</div>
   <!--//평가번호 생성 - 평가번호가 있을때-->

<!--평가그룹 해제 - 체크하지 않았을때 -->
<div class="rating_groupcancelcheck_popup_box">
	<div class="popup_bg"></div>
	<div class="rating_groupcancelcheck_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">평가그룹 해제 안내</h4>
			<a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		</div>
		<div class="popup_txt_area">
			<p>체크하지 않은 항목이 있습니다. 그룹을 선택해 주세요.</p>
			<div class="popup_button_area_center">
				<button type="submit" class="blue_btn popup_close_btn">확인</button>
			</div>
		</div>
	</div>
</div>
   <!--//평가그룹 해제-->

<!--평가구분 및 평가일자 등록-->
<div class="rating_day_popup_box">
	<div class="popup_bg"></div>
	<div class="rating_day_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">평가구분 및 평가일 선택</h4>
			<a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		</div>
		<div class="popup_txt_area">
			<div class="popup_txt clearfix">
				<div class="fl w33">
					<label for="agreement_category2" class="w100">평가구분을 선택해 주세요.</label>
					<select id="classification_selector" class="selectbox1 fl ace-select w100">	
					</select>
				</div>
				<div class="fl w33 ml10">
					<label for="type_selector" class="w100">평가유형을 선택해 주세요.</label>
					<select id="type_selector" class="selectbox1 fl ace-select w100">						
					</select>
				</div>

				<div class="datepicker_area fl w30 ml10">
					<label for="join_datepicker1">해당 날짜를 선택해 주세요.</label>
					<input type="text" id="join_datepicker1" class="datepicker form-control w_14 fl mr5" placeholder="시작일" />				
				</div>
			</div>
			
			<div class="popup_button_area_center">
				<button type="submit" class="blue_btn" onclick="updateEvaluationInfo();">저장</button>
			</div>
		</div>
	</div>
</div>
<!--//평가구분 및 평가일자 등록-->

<!--평가그룹 해제-->
<div class="rating_groupcancel_popup_box">
	<div class="popup_bg"></div>
	<div class="rating_groupcancel_popup">
		<div class="popup_titlebox clearfix">
			<h4 class="fl">평가그룹 해제 안내</h4>
			<a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
		</div>
		<div class="popup_txt_area">
			<div class="popup_txt ta_c">
				<label for="clear_evaluation_number_selector" class="fl list_search_title mr10 w_20 ta_r">평가 번호 선택</label>
				<select id="clear_evaluation_number_selector" class="ace-select fl w_20">						
				</select>						
			</div>					
			<div class="popup_button_area_center">
				<button type="button" class="blue_btn popup_close_btn ml5" onclick="clearEvaluationNumber();">해제</button>
				<button type="button" class="blue_btn popup_close_btn ml5">취소</button>
			</div>
		</div>
	</div>
</div>
   
<script src="/assets/admin/js/script.js"></script>