<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type='text/javascript'>
	var preChairmanRadioId;

	$(document).ready(function() {
		searchChoicedCommissionerList(1);
		searchCommissionerList();
		searchDetail();

		//이벤트 발생 전 선택된 값 
		preChairmanRadioId = $("input[name='rating_leader']:checked").attr("id");
	});

	// 평가 내용 상세		
	function searchDetail() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/evaluation/match/search/detail' />");
		comAjax.addParam("evaluation_id", $("#evaluation_id").val());
		comAjax.setCallback(searchDetailCB);
		comAjax.ajax();
	}
	var evaluationDetail;
	function searchDetailCB(data) {
		$("#reception_id").html("<span>" + data.result_data.reception_id + "</span>");
		$("#evaluation_reg_number").html("<span>" + data.result_data.evaluation_reg_number + "</span>");
		$("#agreement_reg_number").html("<span>" + data.result_data.agreement_reg_number + "</span>");
		$("#announcement_title").html("<span>" + data.result_data.announcement_title + "</span>");
		$("#tech_info_name").html("<span>" + data.result_data.tech_info_name + "</span>");
		$("#institution_name").html("<span>" + data.result_data.institution_name + "</span>");
		$("#member_name").html("<span>" + data.result_data.member_name + "</span>");
		$("#classification_name").html("<span>" + data.result_data.classification_name + "</span>");
		$("#type_name").html("<span>" + data.result_data.type_name + "</span>");
		$("#status_name").html("<span>" + data.result_data.status_name + "</span>");
		$("#steward_department").html("<span>" + data.result_data.steward_department + "</span>");
		$("#steward").html("<span>" + data.result_data.steward + "</span>");
		$("#evaluation_date").html("<span>" + data.result_data.evaluation_date + "</span>");
		$("#manager_point").val(data.result_data.manager_point);

		$("#guide_file_name").val(data.result_data.guide_file_name);
		$("#result_file_name").val(data.result_data.result_file_name);
		$("#complete_file_name").text(data.result_data.complete_file_name);
		
		
		if ( data.result_data.status == "D0000003" || data.result_data.status == "D0000004" || data.result_data.status == "D0000005") {
			$("#evaluation_waiting").show();
			$("#evaluation_ready").hide();
		}

		if ( data.result_data.status == "D0000005" ) {
			$("#pdf_save_btn").hide();
			$("#upload_complete_file_label").hide();
			$("#upload_complete_file").hide();
			$("#temp_save_btn").hide();
			$("#submit_btn").hide();
		}

		evaluationDetail = data.result_data;
	}

	// 평가 위원 검색
	function searchChoicedCommissionerList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/admin/api/evaluation/match/commissioner/search/pagingRelatedId' />");
		// 20개씩 검색
		comAjax.addParam("choice_yn", "y");
		comAjax.addParam("evaluation_id", $("#evaluation_id").val());
		comAjax.addParam("page_row_count", "20");
		comAjax.setCallback(serarchChoicedCommissionerListCB);
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("orderby", "CHAIRMAN_YN DESC");
		comAjax.ajax();
	}
	function serarchChoicedCommissionerListCB(data) {
		var total = data.totalCount;
		var body = $("#commissioner_list_body");
		body.empty();
		if (total == 0) {
			var str = "<tr>" + "<td colspan='11'>조회된 결과가 없습니다.</td>" + "</tr>";
			body.append(str);
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

			var managerList = [];
			var str = "";
			var index = 1;
			$.each(data.result_data, function(key, value) {
				// 평가위원장의 평가 결과를 찾는다.
				if (value.chairman_yn == "Y") {
					$("#final_result").html("<span class='font_blue'>" + value.chairman_result + "</span>");
				}
				
				str += "<tr>";
				str += "	<td><span>" + index + "</span></td>";
				str += "	<td><a href='/admin/fwd/evaluation/match/commissioner/detail?member_id=" + value.member_id + "' onClick='window.open(this.href, \"\", \"width=1200, height=900, scrollbars=1\"); return false;'>" + value.member_name + "</a></td>";
				str += "	<td><span>" + value.institution_type_name + "</span></td>";
				str += "	<td><span>" + value.institution_name + "</span></td>";
				str += "	<td><span>" + value.national_skill_large + "</span></td>";
				str += "	<td><span>" + value.rnd_class + "</span></td>";
				str += "	<td>";
				if ( value.chairman_yn == "Y") {
					str += "	<input type='radio' name='rating_leader' id='rating_leader_" + index + "' checked><label for='rating_leader1'>&nbsp;</label>";
				} else {
					str += "	<input type='radio' name='rating_leader' id='rating_leader_" + index + "' onclick='appointChairman(\"" + value.member_id + "\");'><label for='rating_leader1'>&nbsp;</label>";
				}
				
				str += "	</td>";
				str += "	<td><span>" + value.mail_send_date + "</span></td>";

				if ( value.institution_type_name == "내부평가위원" ) {
					str += "<td>내부평가위원</td>";
					str += "<td>내부평가위원</td>";
					if ( value.evaluation_report_yn == "Y") {
						str += "<td><a href='/admin/fwd/evaluation/match/commissioner/report/estimation?member_id="+ value.member_id + "&evaluation_id=" + value.evaluation_id + "' onClick='window.open(this.href, \"\", \"width=595, height=841, scrollbars=1\"); return false;' class='font_blue'>작성완료</a></td>";
					} else {
						str += "<td>미작성</td>";
					}
				} else {
					if ( value.security_declaration_yn == "Y") {
						str += "<td><a href='/admin/fwd/evaluation/match/commissioner/report/security?member_id="+ value.member_id + "&evaluation_id=" + value.evaluation_id + "' onClick='window.open(this.href, \"\", \"width=595, height=841, scrollbars=1\"); return false;' class='font_blue'>작성완료</a></td>";
					} else {
						str += "<td>미작성</td>";
					}
					if ( value.payment_declaration_yn == "Y") {
						str += "<td><a href='/admin/fwd/evaluation/match/commissioner/report/payment?member_id="+ value.member_id + "&evaluation_id=" + value.evaluation_id + "' onClick='window.open(this.href, \"\", \"width=595, height=841, scrollbars=1\"); return false;' class='font_blue'>작성완료</a></td>";
					} else {
						str += "<td>미작성</td>";
					}
					if ( value.evaluation_report_yn == "Y") {
						str += "<td><a href='/admin/fwd/evaluation/match/commissioner/report/estimation?member_id="+ value.member_id + "&evaluation_id=" + value.evaluation_id + "' onClick='window.open(this.href, \"\", \"width=595, height=841, scrollbars=1\"); return false;' class='font_blue'>작성완료</a></td>";
					} else {
						str += "<td>미작성</td>";
					}
				}
				index++;
			});
			body.append(str);
		}
	}

	// 해당 평가에 선정된 평가위원 정보 검색(평가내용 포함)
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
		console.log(data);
		var body = $("#commissioner_evaluation_list");
		body.empty();
		
		var str = "";	
		var evaluationItemCount = 0;
		var sumTotalPoint = 0;

		if ( data.result_data != null) {
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

			//간사 입력
			str += "<tr>";
			str += "	<td colspan='2' class='td_c2 fw_b'>가점 입력(간사입력)</td>";
			str += "	<td colspan='9'>";
			str += "		<div class='ta_r'>";
			str += "			<input type='text' id='manager_point' class='form-control w10 ls number_t'  maxlength='3'>";
			str += "			<label for='plus_write'>점</label>";
			str += "		</div>";
			str += "	</td>";
			str += "	<td class='last total_score' colspan='2'>";
			str += "		<span class='mr5'>&nbsp;</span>";
			str += "	</td>";
			str += "</tr>";
			
			body.empty();
			body.append(str);
		}
	}

	// 위원장 선정
	function appointChairman(memberId) {
		if (evaluationDetail.status == "D0000004" || evaluationDetail.status == "D0000005") {
			$("#" + preChairmanRadioId).prop("checked", true);
			alert("평가중/평가완료 상태에서는 위원정 변경이 불가합니다.");
			return;
		}
		
		if ( confirm("기존 위원장이 있을 경우 기존 위원장은 해임됩니다. 위원장으로 선임하시겠습니까?") ) {
			var formData = new FormData();
			formData.append("member_id", memberId);
			formData.append("chairman_yn", "Y" );
			formData.append("evaluation_id", $("#evaluation_id").val() );
			
			$.ajax({
			    type : "POST",
			    url : "/admin/api/evaluation/match/commissioner/relationID/update/chairman",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			            alert("선임 되었습니다.");
			            serarchChoicedCommissionerList(1);
			        } else {
			            alert("선임에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		} else {
			serarchChoicedCommissionerList(1);
		}
	}

	function save() {
		if ( evaluationDetail.submit_yn == "Y") {
			alert("이미 제출하였습니다. 평가 완료를 위하여 최종평가서를 업로드해 주시기 바랍니다.");
  	  		return ;
		}
		
		if ( confirm("임시 저장 하시겠습니까?") ) {
			var formData = new FormData();
			formData.append("evaluation_id", $("#evaluation_id").val());
			if ( gfn_isNull($("#upload_guide_file")[0].files[0]) == false ) {
				formData.append("upload_guide_file", $("#upload_guide_file")[0].files[0]);
			}
			if ( gfn_isNull($("#upload_result_file")[0].files[0]) == false ) {
				formData.append("upload_result_file", $("#upload_result_file")[0].files[0]);
			}

			if ($("#final_result").text() == "적합") {
				formData.append("result", "D0000001");
			} else {
				formData.append("result", "D0000002");
			}

			if ( gfn_isNull($("#manager_point").val()) == false) {
				formData.append("manager_point", $("#manager_point").val());
			}
			
			
			$.ajax({
			    type : "POST",
			    url : "/admin/api/evaluation/match/update/detail",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			            alert("저장 되었습니다.");
			            serarchChoicedCommissionerList(1);
			        } else {
			            alert("저장에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
	}

	function savePDF() {
		var url = "/admin/fwd/evaluation/match/commissioner/report/finalEstimation?evaluation_id=" + $("#evaluation_id").val(); 
		location.herf = url; 
		var openNewWindow = window.open(url, "_blank", 'width=841, height=595, scrollbars=1');
		openNewWindow.location.href = url;

   		//window.open(url, "_blank", 'width=841, height=595, scrollbars=1');
		//window.open("about:blank");
  	}


  	function submitEvaluation() {
  		if ( isAllEvaluationCompleted == false) {
  	  		alert("모든 평가위원의 평가가 완료되지 않았습니다.");
  	  		return ;
  	  	}
  		
		if ( evaluationDetail.submit_yn == "Y") {
			alert("이미 제출하였습니다. 평가 완료를 위하여 최종평가서를 업로드해 주시기 바랍니다.");
  	  		return ;
		}
  	  	

		if ( confirm("제출 후에는 수정이 불가합니다. 저출 하시겠습니까?") ) {
			var formData = new FormData();
			formData.append("evaluation_id", $("#evaluation_id").val());
			if ( gfn_isNull($("#upload_guide_file")[0].files[0]) == false ) {
				formData.append("upload_guide_file", $("#upload_guide_file")[0].files[0]);
			}
			if ( gfn_isNull($("#upload_result_file")[0].files[0]) == false ) {
				formData.append("upload_result_file", $("#upload_result_file")[0].files[0]);
			}

			if ($("#final_result").text() == "적합") {
				formData.append("result", "D0000001");
			} else {
				formData.append("result", "D0000002");
			}
			
			formData.append("manager_point", $("#manager_point").val());
			formData.append("submit_yn", "Y");
			
			
			$.ajax({
			    type : "POST",
			    url : "/admin/api/evaluation/match/update/detail",
			    data : formData,
			    processData: false,
			    contentType: false,
			    mimeType: 'multipart/form-data',
			    success : function(data) {
			    	var jsonData = JSON.parse(data);
			        if (jsonData.result == true) {
			            alert("제출 되었습니다.");
			            location.reload();
			        } else {
			            alert("제출에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
			        }
			    },
			    error : function(err) {
			        alert(err.status);
			    }
			});
		}
  	}

  	function completedEvaluationUpload(element) {
		if ( evaluationDetail.submit_yn != "Y") {
			alert("먼저 종합평가서를 제출해 주시기 바랍니다.");
  	  		return ;
		}
  	  	

  		if ( gfn_isNull($("#upload_complete_file")[0].files[0]) == false ) {
  			if ( confirm("종합평가서 업로드 후에는 해당 평가가 완료됩니다. 업로드 하시겠습니까?") ) {
  				var formData = new FormData();
  				formData.append("evaluation_id", $("#evaluation_id").val());
  				formData.append("reception_id", evaluationDetail.reception_id);
  				formData.append("classification", evaluationDetail.classification);
  				formData.append("upload_complete_file", $("#upload_complete_file")[0].files[0]);
  				
  				$.ajax({
  				    type : "POST",
  				    url : "/admin/api/evaluation/match/update/detail",
  				    data : formData,
  				    processData: false,
  				    contentType: false,
  				    mimeType: 'multipart/form-data',
  				    success : function(data) {
  				    	var jsonData = JSON.parse(data);
  				        if (jsonData.result == true) {
  				            alert("제출 되었습니다.");
  				            location.reload();
  				        } else {
  				            alert("제출에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
  				        }
  				    },
  				    error : function(err) {
  				        alert(err.status);
  				    }
  				});
  			}
	  	}
  	}

	function moveMain() {
		location.href = "/admin/fwd/evaluation/main?announcement_type=" + '${vo.announcement_type}' + "&classification="  + '${vo.classification}';
	}
</script>
            
<input type="hidden" id="evaluation_id" name="evaluation_id" value="${vo.evaluation_id}" />
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
							       <li class="on"><a href="/admin/fwd/evaluation/match/main" title="평가관리">평가관리</a></li>
								   <li class="menu2depth">
								   	   <ul>
										   <li class="active"><a href="/admin/fwd/evaluation/match/main">기술매칭</a></li>
										   <li><a href="">기술공모</a></li>
										   <li><a href="">기술제안</a></li>
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
			   	<li><strong>기술매칭</strong></li>
		   	</ul>	
		  	<!--//페이지 경로-->
		  	<!--페이지타이틀-->
		   	<h3 class="title_area">기술매칭</h3>
		  <!--//페이지타이틀-->
	   </div>
   </div>
					   					   
			<div class="contents_view">
		   		<div class="view_top_area clearfix">
					<h4 class="fl sub_title_h4">과제 정보</h4>
				</div>
				<table class="list2">
					<caption>과제 정보</caption> 
					<colgroup>
					   <col style="width: 20%" />
					   <col style="width: 80%" />
					</colgroup>
					<thead>
					   <tr>
						   <th scope="row">접수번호</th>
						   <td id="reception_id"></td> 
					   </tr>
					</thead>
					<tbody>								       
					   <tr>
						   <th scope="row">과제번호</th>
						   <td id="agreement_reg_number"></td> 
					   </tr>
					   <tr>
						   <th scope="row">평가번호</th>
						   <td id="evaluation_reg_number"></td> 
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
						   <th scope="row">연구기관</th>
						   <td id="institution_name"></td> 
					   </tr>
					   <tr>
						   <th scope="row">연구자</th>
						   <td id="member_name"></td> 
					   </tr>
					</tbody>
				</table>   
			   <!--//과제 정보-->

			   <!--평가정보-->
				<div class="view_top_area clearfix">
					<h4 class="fl sub_title_h4">평가정보</h4>
				</div>						  	
				<table class="list2">
					<caption>평가정보</caption> 
					<colgroup>
					   <col style="width: 20%" />
					   <col style="width: 80%" />
					</colgroup>
					<thead>
					   <tr>
						   <th scope="row">평가구분</th>
						   <td id="classification_name"></td> 
					   </tr>
					</thead>
					<tbody>								       
					   <tr>
						   <th scope="row">평가유형</th>
						   <td id="type_name"></td> 
					   </tr>
					   <tr>
						   <th scope="row">평가상태</th>
						   <td id="status_name"></td> 
					   </tr>
					   <tr>
						   <th scope="row">담당간사 부서명</th>
						   <td id="steward_department"></td> 
					   </tr>
					   <tr>
						   <th scope="row">담당간사 성명</th>
						   <td id="steward"></td> 
					   </tr>
					   <tr>
						   <th scope="row">평가일자</th>
						   <td>
								<div class="day ta_l" id="evaluation_date">
								</div>
							</td> 
					   </tr>
					    <tr>
						   <th scope="row">평가 안내 공문</th>
						   <td>
							   <div class="clearfix file_form_txt">													   
								   <!--업로드 버튼-->	
								   <div class="filebox bs3-primary">
									  <input class="upload-name w50" value="선택된 파일이 없습니다." id="guide_file_name" disabled="disabled">
									  <label for="guide_file_name" class="hidden">선택된 파일이 없습니다.</label>								  
									  <input type="file" id="upload_guide_file" class="upload-hidden"> 
									  <label for="upload_guide_file" class="mt5">찾기</label> 
									</div>													   
								   <!--//업로드 버튼-->														   
								</div>
						   </td>
					   </tr>
					   <tr>
						   <th scope="row">평가 결과 공문</th>
						   <td>
							   <div class="clearfix file_form_txt">													   
								   <!--업로드 버튼-->	
								   <div class="filebox bs3-primary">
									  <input class="upload-name w50" value="선택된 파일이 없습니다." id="result_file_name" disabled="disabled">
									  <label for="result_file_name" class="hidden">선택된 파일이 없습니다.</label>								  
									  <input type="file" id="upload_result_file" class="upload-hidden"> 
									  <label for="upload_result_file" class="mt5">찾기</label> 
									</div>													   
								   <!--//업로드 버튼-->														   
								</div>									   										   
						   </td>
					   </tr>
					   <tr>
						   <th scope="row">평가결과</th>
						   <td id="complete_file_name"></td> 
					   </tr>
					</tbody>
				</table> 						   	
						
				
				
				<div id="evaluation_waiting" style="display:none">
					<table class="list mt50">
					   <caption>평가 정보</caption>     
					   <colgroup>
							<col style="width: 5%;">
							<col style="width: 6%;">
							<col style="width: 9%;">
							<col style="width: 10%;">
							<col style="width: 10%;">
							<col style="width: 20%;">
							<col style="width: 6%;">
							<col style="width: 9%;">
							<col style="width: 8%;">
							<col style="width: 8%;">
							<col style="width: 8%;">									
					   </colgroup>
					   <thead>
						   <tr>
							   <th scope="col">순위</th>
							   <th scope="col">이름</th>
							   <th scope="col">구분</th>
							   <th scope="col">기관명</th>
							   <th scope="col">분야</th>
							   <th scope="col">키워드</th>
							   <th scope="col">평가위원장</th>
							   <th scope="col">이메일(공문)</th>
							   <th scope="col">보안서약서</th>
							   <th scope="col">지급청구서</th>
							   <th scope="col">평가서</th>
						   </tr>
					   </thead>
					   <tbody id="commissioner_list_body">
					   </tbody>
					</table>
					<!--//평가정보-->
	
					<!--페이지 네비게이션-->
			    	<input type="hidden" id="pageIndex" name="pageIndex"/>
				   	<div class="page" id="pageNavi"></div>  
					    <!--//페이지 네비게이션-->
	
					<!--평가 결과-->
					<div class="view_top_area clearfix">
						<h4 class="fl sub_title_h4">평가 결과</h4>
					</div>						  	
					<table class="list ruselt_score">
					   <caption>평가 정보</caption>     
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
								<th scope="col" colspan="11">평가 점수 및 구분</th>												
								<th scope="col" rowspan="2">서명</th>
							</tr>										
							<tr>
								<th scope="col">A</th>
								<th scope="col">B</th>
								<th scope="col">C</th>
								<th scope="col">D</th>
								<th scope="col">E</th>
								<th scope="col">F</th>
								<th scope="col">G</th>
								<th scope="col">H</th>
								<th scope="col">I</th>
								<th scope="col">J</th>												
								<th scope="col">점수</th>
							</tr>
						</thead>
					    <tbody id="commissioner_evaluation_list">
						</tbody>
						<tfoot>											
							<tr>
								<td class="ta_c fw_b" colspan="2">최종결과</td>												
								<td class="last total_score ta_c" colspan="11" id="final_result"></td>		
							</tr>
						</tfoot>
					</table>
					<!--//평가 결과-->
								
					<div class="button_area clearfix mt30 estimation_buttons">
						<div class="button_area_fl fl clearfix">								
							<button type="button" class="gray_btn2 fl rating_pdf_popup_btn" id="pdf_save_btn" onclick="savePDF();">종합평가서 PDF 인쇄</button>
							
							<label class="blue_btn fl ml5" id="upload_complete_file_label" for="upload_complete_file" class="mt5">종합평가서 최종 업로드</label> 
							<input type="file" id="upload_complete_file" style="display:none" onchange="completedEvaluationUpload(this);"> 
						</div>	
		
						<div class="button_area_fl fr clearfix">											
							<button type="button" class="blue_btn2 fl" id="temp_save_btn" onclick="save();">임시저장</button>		
							<button type="button" class="blue_btn fl ml5" id="submit_btn" onclick="submitEvaluation();">제출</button>		
							<button type="button" class="gray_btn2 fl ml5" onclick="moveMain();">목록</button>					
						</div>
					</div>
					
				</div>	
				
				<div id="evaluation_ready" class="button_area clearfix mt30 estimation_buttons">
					<div class="button_area_fl fr clearfix">											
						<button type="button" class="blue_btn2 fl" onclick="save();">저장</button>		
						<button type="button" class="gray_btn2 fl ml5" onclick="moveMain();">목록</button>							
					</div>
				</div>			
						
							
				
			</div><!--//contents view-->
		</div>
	<!--//contents--> 
	</div>
<!--//sub--> 
</div>
            
            
            
<!--평가위원 정보 팝업-->
<div class="rating_link_popup_box">
  <div class="popup_bg"></div>
  <div class="rating_link_popup">
      <div class="popup_titlebox clearfix">
       <h4 class="fl">평가위원 정보</h4>
       <a href="javascript:void(0)" class="white_font close_btn popup_close_btn fr"><i class="fas fa-times"></i></a>
   </div>
   <div class="popup_txt_area">
	   <div class="popup_txt">
			<div class="view_top_area">
			   <h4 class="sub_title_h4">기본 정보</h4>						   
			</div>
			<table class="list2">
			   <caption>기본 정보</caption>
			   <colgroup>
					<col style="width: 30%;">																		
					<col style="width: 70%;">
			   </colgroup>
			   <tbody>
					<tr>
						<th scope="row">성명</th>
						<td><span>홍길동</span></td>	
					</tr>									  
					<tr>
						<th scope="row">생년월일</th>
						<td><span>1992-01-20</span></td>	
					</tr>
					<tr>
						<th scope="row">휴대전화</th>
						<td class="clearfix">
							<span class="ls">010</span><span>-</span><span class="ls">0101</span><span>-</span><span class="ls">0101</span>																			
						</td>	
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td class="clearfix"><span class="ls">abc123</span><span>@</span><span class="ls">abc.co.kr</span></td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td><span class="ls">서울시 동작구 노량진동</span><span class="ls">123-4번지</span></td>
					</tr>
				</tbody>
		    </table>

			<!--기관정보-->
			<div class="view_top_area">
			   <h4 class="sub_title_h4">기관 정보</h4>							  
		    </div>
			<table class="list2">
			   <caption>기관 정보</caption>
			   <colgroup>
					<col style="width: 30%;">																		
					<col style="width: 70%;">
			   </colgroup>
			   <tbody>
					<tr>
						<th scope="row">기관 유형</th>
						<td>
							<span>
								<input type="radio" id="member_signup_company_class_2_5" name="member_signup_company_class_2" value="개인" class="" />
								<label for="member_signup_company_class_2_5">개인</label>
								<input type="radio" id="member_signup_company_class_2" name="member_signup_company_class_2" value="기업" checked="" class="" />
								<label for="member_signup_company_class_2">기업</label>
								<input type="radio" id="member_signup_company_class_2_2" name="member_signup_company_class_2" value="학교" class="" />
								<label for="member_signup_company_class_2_2">학교</label>
								<input type="radio" id="member_signup_company_class_2_3" name="member_signup_company_class_2" value="연구원" class="" />
								<label for="member_signup_company_class_2_3">연구원</label>
								<input type="radio" id="member_signup_company_class_2_4" name="member_signup_company_class_2" value="공공기관" class="" />
								<label for="member_signup_company_class_2_4">공공기관</label>										
								<input type="radio" id="member_signup_company_class_2_6" name="member_signup_company_class_2" value="기타(협/단체 등)" class="" />
								<label for="member_signup_company_class_2_6">기타 (협/단체 등)</label>
							</span>
						</td>
					</tr>									  
					<tr>
						<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_company_name">기관명</label></span></th>
						<td>
							<input type="text" id="agreementmember_company_name" class="form-control w100 mr5 ls" placeholder="기관명을 입력해 주세요.">
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="address_agreementmember_sign2">주소</label></span></th>
						<td>
							<input type="text" id="address_agreementmember_sign2" class="form-control w_40 fl mr5" /><input type="text" class="form-control w_20 fl mr5" /><button type="button" class="gray_btn adress_btn">검색</button>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_charge_tel2">전화</label></span></th>
						<td>
							<select name="agreementmember_charge_tel2" id="agreementmember_charge_tel2" class="w_8 fl ace-select " >
								<option value="031">031</option>
								<option value="02">02</option>
							</select>
							<span style="display:block;" class="fl mc8">-</span>
							<label for="agreementmember_charge_tel2_1" class="hidden">전화</label>
							<input type="text" id="agreementmember_charge_tel2_1" maxlength="4" class=" form-control brc-on-focusd-inline-block w_6 fl ls" />
							<span style="display:block;" class="fl mc8">-</span>
							<label for="agreementmember_charge_tel2_2" class="hidden">전화</label>
							<input type="tel" id="agreementmember_charge_tel2_2" maxlength="4" class=" form-control brc-on-focusd-inline-block w_6 fl ls" />
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_company_partment">부서</label></span></th>
						<td>
							<input type="text" id="agreementmember_company_partment" class="form-control w_20 mr5 ls " />
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_company_rank">직책</label></span></th>
						<td>
							<input type="text" id="agreementmember_company_rank" class="form-control w_20 mr5 ls " />		
						</td>
					</tr>																									
				</tbody>
		    </table>
			<!--//기관정보-->

			<!--계좌정보-->
			<div class="view_top_area">
			   <h4 class="sub_title_h4">계좌 정보</h4>							  
		    </div>
			<table class="list2 write fixed">
			   <caption>계좌 정보</caption>
				<colgroup>
					<col style="width: 30%;">																		
					<col style="width: 70%;">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_bankname">은행명</label></span></th>
						<td>
							<input type="text" id="agreementmember_bankname" class="form-control w_10 mr5 " />					
							<span class="d_i">은행</span>
						</td>	
					</tr>  
					<tr>
						<th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="agreementmember_banknumber">계좌번호</label></span></th>
						<td>
							<input type="number" id="agreementmember_banknumber" class="form-control w60 mr5 ls " />				
							<span class="d_i">" - " 을 제외한 숫자만 입력해 주세요.</span>										
						</td>
					</tr>																							
				</tbody>
		    </table>
			<!--//계좌정보-->

			<!--기술분야-->
			<div class="view_top_area">
			   <h4 class="sub_title_h4">기술 분야</h4>							  
		    </div>
			<table class="list2 write fixed">
			   <caption>기술 분야 </caption>
					<colgroup>
						<col style="width: 30%;">																		
						<col style="width: 70%;">
					</colgroup>								
					<tbody><tr>
						<th scope="row" rowspan="3"><span class="icon_box"><span class="necessary_icon">*</span>국가과학기술분류</span></th>
						<td>
							<label for="science_MainCategory" class="fl mt5 mr5">대분류</label>
							<select name="science_MainCategory" id="science_MainCategory" class="ace-select w95 " >
								 <option value="지구 과학">지구 과학</option>
								 <option value="농림 수산 식품">농림 수산 식품</option>
							</select>
						</td>
					</tr>  
					<tr>
					   <td>
						   <label for="science_MiddleCategory" class="fl mt5 mr5">중분류</label>
						   <select name="science_MiddleCategory" id="science_MiddleCategory" class="ace-select w95 " >
							   <option value="ND07. 자연재해 분석/예측">ND07. 자연재해 분석/예측</option>
							   <option value="LB11. 조경학">LB11. 조경학</option>
						   </select>
					   </td>
					</tr>
					<tr>
					   <td>
						   <label for="science_SubClass" class="fl mt5 mr5">소분류</label>
						   <select name="science_SubClass" id="science_SubClass" class="ace-select w95 " >
							 <option value="ND0701. 기상재해 분석/예측">ND0701. 기상재해 분석/예측</option>
							 <option value="ND0702. 지진발생 분석/예측">ND0702. 지진발생 분석/예측</option>
							 <option value="LB1101. 조경 계획">LB1101. 조경 계획</option>
							 <option value="LB1102. 조경 설계">LB1102. 조경 설계</option>
						   </select>
					   </td>
					</tr>
					<tr>
					   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="industry_4th_technology">4차 산업혁명 기술분류</label></span></th>
					   <td>
						   <select name="industry_4th_technology" id="industry_4th_technology" class="ace-select w30 " >
								<option value="5G">5G</option>
								<option value="스마트헬스케어">스마트헬스케어</option>
						   </select>
						</td> 
				   </tr>							   								
			   </tbody>
			</table>
			<!--//기술분야-->
			
			<!--연구분야-->
			<div class="view_top_area">
			   <h4 class="sub_title_h4">연구 분야</h4>							  
		    </div>
			<table class="list2 write fixed">
				<caption>연구 분야</caption>
				<colgroup>
					<col style="width: 30%;">																		
					<col style="width: 70%;">
				</colgroup>
				<tbody>
					<tr>
					   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="research_class">연구 상세 분야</label></span></th>
					   <td>
						   <textarea name="research_class" id="research_class" cols="30" rows="2" class="w100 " ></textarea>
					   </td>
					</tr>
				</tbody>
		    </table>
			<!--//연구분야-->

			<!--학력-->
			<div class="view_top_area">
			   <h4 class="sub_title_h4">학력</h4>							  
		    </div>
			<table class="list2 write fixed bd_r">
				<caption>학력</caption>
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 25%;">
					<col style="width: 25%;">
					<col style="width: 12%;">
					<col style="width: 28%;">
				</colgroup>
				<thead>
					<tr>
						<th><span class="icon_box"><span class="necessary_icon">*</span>학위</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>학교명</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>전공</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>학위취득연도</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>학위증명서</span></th>				
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="clearfix">	
							<input type="text" id="degree_type" class="form-control w100 " />
							<label for="degree_type" class="hidden">학위</label>												
						</td>
						<td>
							<input type="text" id="school_name" class="form-control w100 " />
							<label for="school_name" class="hidden">학교명</label>
						</td>
						<td>
							<input type="text" id="major_number" class="form-control w100 ls " />
							<label for="major_number" class="hidden">전공</label>
						</td>	
						<td class="td_c">
							<div class="clearfix td_c">
								<input type="text" id="degree_day" class="form-control w80 ls fl  number_t" maxlength="4">
								<label for="degree_day" class="fl w10 ml5 mt5">년</label>
							</div>																						
						</td>
						<td class="td_c">
							<a href="" download="" class="down_btn">학위첨부서.pdf</a>	
						</td>
					</tr>														
				</tbody>
		    </table>
			<!--//학력-->

			<!--경력-->
			<div class="view_top_area">
			   <h4 class="sub_title_h4">경력</h4>							  
		    </div>
			<table class="list2 fixed history_table write2 bd_r">
				<caption>경력</caption>
				<colgroup>
					<col style="width: 20%;">
					<col style="width: 20%;">
					<col style="width: 10%;">
					<col style="width: 19%;">
					<col style="width: 19%;">
					<col style="width: 22%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>근무처</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>근무부서</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>직급</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>입사</span></th>
						<th scope="col"><span class="icon_box">퇴사</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>업무내용</span></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="clearfix">	
							<input type="text" id="company_name_employment" class="form-control w100" />
							<label for="company_name_employment" class="hidden">근무처</label>												
						</td>
						<td>
							<input type="text" id="company_divisions" class="form-control w100" />
							<label for="company_divisions" class="hidden">근무부서</label>
						</td>
						<td>
							<input type="text" id="company_myrank" class="form-control w100 ls" />
							<label for="company_myrank" class="hidden">직급</label>
						</td>	
						<td>
							<input type="text" id="join_day" class="form-control w40 ls  number_t" maxlength="4" />
							<label for="join_day" class="mr10">년</label>
							<input type="text" id="join_day2" class="form-control w30 ls  number_t" maxlength="2" />
							<label for="join_day2">월</label>															
						</td>	
						<td>
							<input type="text" id="leave_day" class="form-control w40 ls  number_t" maxlength="4" />
							<label for="leave_day" class="mr10">년</label>
							<input type="text" id="leave_day2" class="form-control w30 ls  number_t" maxlength="2" />
							<label for="leave_day2">월</label>
						</td>	
						<td>
							<textarea name="business_information" id="business_information" rows="3" class="w100" ></textarea>	
							<label for="business_information" class="hidden">업무내용</label>
						</td>	
					</tr>														
				</tbody>
		    </table>
			<!--//경력-->

			<!--논문/저서-->
			<div class="view_top_area">
			   <h4 class="sub_title_h4">논문/저서<span class="font_blue">(선택)</span></h4>							  
		    </div>
			<table class="list2 fixed history_table write2 bd_r">
				<caption>논문/저서</caption>
				<colgroup>
					<col style="width: 20%;">
					<col style="width: 20%;">
					<col style="width: 10%;">
					<col style="width: 19%;">
					<col style="width: 19%;">
					<col style="width: 22%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>근무처</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>근무부서</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>직급</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>입사</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>퇴사</span></th>
						<th scope="col"><span class="icon_box"><span class="necessary_icon">*</span>발행일자</span></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="clearfix">	
							<input type="text" id="company_name" class="form-control w100 " />
							<label for="company_name" class="hidden">근무처</label>												
						</td>
						<td>
							<input type="text" id="company_department" class="form-control w100 " />
							<label for="company_department" class="hidden">근무부서</label>
						</td>
						<td>
							<input type="text" id="company_rank" class="form-control w100 ls " />
							<label for="company_rank" class="hidden">직급</label>
						</td>	
						<td>
							<input type="text" id="join_day_" class="form-control w40 ls  number_t" maxlength="4" />
							<label for="join_day_" class="mr10">년</label>
							<input type="text" id="join_day_2" class="form-control w30 ls  number_t" maxlength="2" />
							<label for="join_day_2">월</label>															
						</td>	
						<td>
							<input type="text" id="leave_day_" class="form-control w40 ls  number_t" maxlength="4" />
							<label for="leave_day_" class="mr10">년</label>
							<input type="text" id="leave_day_2" class="form-control w30 ls  number_t" maxlength="2" />
							<label for="leave_day_2">월</label>
						</td>	
						<td class="ta_c">
							<div class="datepicker_area">
								<input type="text" id="join_datepicker" class="datepicker form-control w_14 mr5 ls  hasDatepicker" /><button type="button" class="ui-datepicker-trigger"></button>
								
							</div> 											
						</td>	
					</tr>														
				</tbody>
		    </table>
			<!--//논문/저서-->

			<!--지식/재산권-->
			<div class="view_top_area">
			   <h4 class="sub_title_h4">지식재산권<span class="font_blue">(선택)</span></h4>							  
		    </div>
			<table class="list fixed knowledge_table write2">
				<caption>지식재산권</caption>
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 21%;">
					<col style="width: 13%;">
					<col style="width: 14%;">
					<col style="width: 14%;">
					<col style="width: 18%;">
					<col style="width: 10%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">구분</th>
						<th scope="col">논문저서 명</th>
						<th scope="col">출원/등록</th>
						<th scope="col">출원/등록 번호</th>
						<th scope="col">출원/등록 일자</th>
						<th scope="col">출원/등록 국가</th>
						<th scope="col">발명자명</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="clearfix">	
							<input type="text" id="type_class" class="form-control w100 " />
							<label for="type_class" class="hidden">구분</label>												
						</td>
						<td>
							<input type="text" id="treatisebook_name" class="form-control w100 " />
							<label for="treatisebook_name" class="hidden">논문저서 명</label>
						</td>														
						<td>
							<input type="text" id="license_pending1" class="form-control w100 " />
							<label for="license_pending1" class="hidden">출원/등록</label>						
						</td>
						<td>
							<input type="text" id="enrollment_number" class="form-control w100 ls " />
							<label for="enrollment_number" class="hidden">출원/등록 번호</label>									
						</td>	
						<td class="td_c">
							<div class="datepicker_area">
								<input type="text" id="enrollment_day" class="datepicker form-control w_14 mr5 ls  hasDatepicker" /><button type="button" class="ui-datepicker-trigger"></button>
							</div>
							<label for="enrollment_day" class="hidden">출원/등록 일자</label>
						</td>	
						<td>
							<input type="text" id="enrollment_country" class="form-control w100 ls " />
							<label for="enrollment_country" class="hidden">출원/등록 국가</label>
						</td>	
						<td class="last">															
							<input type="text" id="inventor_name" class="form-control w100 ls " />
							<label for="inventor_name" class="hidden fl">발명자명</label>
						</td>	
					</tr>
					<tr>
						<td class="clearfix">	
							<input type="text" id="type_class2" class="form-control w100 " />
							<label for="type_class2" class="hidden">구분</label>												
						</td>
						<td>
							<input type="text" id="treatisebook_name2" class="form-control w100 " />
							<label for="treatisebook_name2" class="hidden">논문저서 명</label>
						</td>														
						<td>
							<input type="text" id="license_pending2" class="form-control w100 " />
							<label for="license_pending2" class="hidden">출원/등록</label>						
						</td>
						<td>
							<input type="text" id="enrollment_number2" class="form-control w100 ls " />
							<label for="enrollment_number2" class="hidden">출원/등록 번호</label>									
						</td>	
						<td>
							<div class="datepicker_area">
								<input type="text" id="enrollment_day2" class="datepicker form-control w_14 mr5 ls  hasDatepicker" /><button type="button" class="ui-datepicker-trigger"></button>
							</div>
							<label for="enrollment_day2" class="hidden">출원/등록 일자</label>
						</td>	
						<td>
							<input type="text" id="enrollment_country2" class="form-control w100 ls " />
							<label for="enrollment_country2" class="hidden">출원/등록 국가</label>
						</td>	
						<td class="last">															
							<input type="text" id="inventor_name2" class="form-control w100 ls " />
							<label for="inventor_name2" class="hidden fl">발명자명</label>
						</td>	
					</tr>
					<tr>
						<td class="clearfix">	
							<input type="text" id="type_class3" class="form-control w100 " />
							<label for="type_class3" class="hidden">구분</label>												
						</td>
						<td>
							<input type="text" id="treatisebook_name3" class="form-control w100 " />
							<label for="treatisebook_name3" class="hidden">논문저서 명</label>
						</td>														
						<td>
							<input type="text" id="license_pending3" class="form-control w100 " />
							<label for="license_pending3" class="hidden">출원/등록</label>						
						</td>
						<td>
							<input type="text" id="enrollment_number3" class="form-control w100 ls " />
							<label for="enrollment_number3" class="hidden">출원/등록 번호</label>									
						</td>	
						<td>
							<div class="datepicker_area">
								<input type="text" id="enrollment_day3" class="datepicker form-control w_14 mr5 ls  hasDatepicker" /><button type="button" class="ui-datepicker-trigger"></button>
							</div>
							<label for="enrollment_day3" class="hidden">출원/등록 일자</label>
						</td>	
						<td>
							<input type="text" id="enrollment_country3" class="form-control w100 ls " />
							<label for="enrollment_country3" class="hidden">출원/등록 국가</label>
						</td>	
						<td class="last">															
							<input type="text" id="inventor_name3" class="form-control w100 ls " />
							<label for="inventor_name3" class="hidden fl">발명자명</label>
						</td>	
					</tr>
				</tbody>
		    </table>
			<!--//지식/재산권-->
			
			<!--자기기술서-->
			<div class="view_top_area clearfix mt30">
			   <h4 class="sub_title_h4">자기기술서<span class="font_blue">(선택)</span></h4>							  
		    </div>
			<table class="list2 font_white">
			   <caption>자기기술서</caption>
				<colgroup>
					<col style="width: 30%;">																		
					<col style="width: 70%;">
				</colgroup>
				<tbody>
					<tr>
					   <th scope="row"><span class="icon_box"><span class="necessary_icon">*</span><label for="my_skill1">자기기술서</label></span></th>
					   <td>
						   <textarea name="my_skill1" id="my_skill1" cols="30" rows="8" class="w100" ></textarea>
						   <p class="ta_r">(500자 이내)</p>
					   </td>
					</tr>
				 </tbody>
			</table>
			<!--//자기기술서-->

			<!--비고-->
			<div class="view_top_area clearfix mt30">
			   <h4 class="sub_title_h4">비고</h4>							  
		    </div>
			<table class="list2 font_white">
			   <caption>비고</caption>
				<colgroup>
					<col style="width: 30%;">																		
					<col style="width: 70%;">
				</colgroup>
				<tbody>
					<tr>
					   <th scope="row">비고</th>
					   <td>
						   <textarea name="note" id="note" cols="30" rows="8" class="w100" ></textarea>
						   <button type="submit" class="blue_btn note_save_btn mt5">저장</button>
					   </td>
					</tr>
				 </tbody>
			</table>
			<!--//비고-->
	   </div>
   </div>
  </div>
</div>
 <!--//평가위원 정보 팝업-->
 
 <!--평가위원 제출 안내 팝업-->
<div class="send_submission_popup_box">		
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
   
<script src="/assets/admin/js/script.js"></script>